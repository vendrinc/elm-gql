module GraphQL.Engine exposing
    ( batch
    , nullable, list, field, fieldWith, object, objectWith, decode
    , enum, maybeEnum
    , union
    , Selection, select, with, map, map2, recover
    , arg, argList, Optional, optional
    , Query, query, Mutation, mutation, Error(..)
    , queryString
    , Argument(..), maybeScalarEncode
    , encodeOptionals, encodeInputObject, encodeArgument
    , decodeNullable
    , unsafe, selectTypeNameButSkip, prebakedQuery
    )

{-|

@docs batch

@docs nullable, list, field, fieldWith, object, objectWith, decode

@docs enum, maybeEnum

@docs union

@docs Selection, select, with, map, map2, recover

@docs arg, argList, Optional, optional

@docs Query, query, Mutation, mutation, Error

@docs queryString

@docs Argument, maybeScalarEncode

@docs encodeOptionals, encodeInputObject, encodeArgument

@docs decodeNullable
@docs unsafe, selectTypeNameButSkip, prebakedQuery

-}

import Dict exposing (Dict)
import Http
import Json.Decode as Json
import Json.Encode as Encode
import Set


{-| Batch a number of selection sets together!
-}
batch : List (Selection source data) -> Selection source (List data)
batch selections =
    Selection <|
        Details
            (\context ->
                List.foldl
                    (\(Selection (Details toFieldsGql _)) ( ctxt, fields ) ->
                        let
                            ( newCtxt, newFields ) =
                                toFieldsGql ctxt
                        in
                        ( newCtxt
                        , fields ++ newFields
                        )
                    )
                    ( context, [] )
                    selections
            )
            (\context ->
                List.foldl
                    (\(Selection (Details _ toItemDecoder)) ( ctxt, cursorFieldsDecoder ) ->
                        let
                            ( newCtxt, itemDecoder ) =
                                toItemDecoder ctxt
                        in
                        ( newCtxt
                        , cursorFieldsDecoder
                            |> Json.andThen
                                (\existingList ->
                                    Json.map
                                        (\item ->
                                            item :: existingList
                                        )
                                        itemDecoder
                                )
                        )
                    )
                    ( context, Json.succeed [] )
                    selections
            )


{-| -}
recover : recovered -> (data -> recovered) -> Selection source data -> Selection source recovered
recover default wrapValue (Selection (Details toQuery toDecoder)) =
    Selection
        (Details toQuery
            (\context ->
                let
                    ( newContext, decoder ) =
                        toDecoder context
                in
                ( newContext
                , Json.oneOf
                    [ Json.map wrapValue decoder
                    , Json.succeed default
                    ]
                )
            )
        )


{-| -}
union : List ( String, Selection source data ) -> Selection source data
union options =
    Selection <|
        Details
            (\context ->
                let
                    ( fragments, fragmentContext ) =
                        List.foldl
                            (\( name, Selection (Details fragQuery _) ) ( frags, currentContext ) ->
                                let
                                    ( newContext, fields ) =
                                        fragQuery currentContext

                                    nonEmptyFields =
                                        case fields of
                                            [] ->
                                                -- we're already selecting typename at the root.
                                                -- this is just so we don't have an empty set of brackets
                                                [ Field "__typename" Nothing [] [] ]

                                            _ ->
                                                fields
                                in
                                ( Fragment name nonEmptyFields :: frags
                                , newContext
                                )
                            )
                            ( [], context )
                            options
                in
                ( fragmentContext
                , Field "__typename" Nothing [] [] :: fragments
                )
            )
            (\context ->
                let
                    ( fragmentDecoders, fragmentContext ) =
                        List.foldl
                            (\( name, Selection (Details _ toFragDecoder) ) ( frags, currentContext ) ->
                                let
                                    ( newContext, fragDecoder ) =
                                        toFragDecoder currentContext

                                    fragDecoderWithTypename =
                                        Json.field "__typename" Json.string
                                            |> Json.andThen
                                                (\typename ->
                                                    if typename == name then
                                                        fragDecoder

                                                    else
                                                        Json.fail "Unknown union variant"
                                                )
                                in
                                ( fragDecoderWithTypename :: frags
                                , newContext
                                )
                            )
                            ( [], context )
                            options
                in
                ( fragmentContext
                , Json.oneOf fragmentDecoders
                )
            )


{-| -}
maybeEnum : List ( String, item ) -> Json.Decoder (Maybe item)
maybeEnum options =
    Json.oneOf
        [ Json.map Just (enum options)
        , Json.succeed Nothing
        ]


{-| -}
enum : List ( String, item ) -> Json.Decoder item
enum options =
    Json.string
        |> Json.andThen
            (findFirstMatch options)


findFirstMatch : List ( String, item ) -> String -> Json.Decoder item
findFirstMatch options str =
    case options of
        [] ->
            Json.fail ("Unexpected enum value: " ++ str)

        ( name, value ) :: remaining ->
            if name == str then
                Json.succeed value

            else
                findFirstMatch remaining str


{-| Used in generated code to handle maybes
-}
nullable : Selection source data -> Selection source (Maybe data)
nullable (Selection (Details toFieldsGql toFieldsDecoder)) =
    Selection <|
        Details
            toFieldsGql
            (\context ->
                let
                    ( fieldContext, fieldsDecoder ) =
                        toFieldsDecoder context
                in
                ( fieldContext
                , Json.oneOf
                    [ Json.map Just fieldsDecoder
                    , Json.succeed Nothing
                    ]
                )
            )


{-| Used in generated code to handle maybes
-}
list : Selection source data -> Selection source (List data)
list (Selection (Details toFieldsGql toFieldsDecoder)) =
    Selection <|
        Details
            toFieldsGql
            (\context ->
                let
                    ( fieldContext, fieldsDecoder ) =
                        toFieldsDecoder context
                in
                ( fieldContext
                , Json.list fieldsDecoder
                )
            )


{-| -}
object : String -> Selection source data -> Selection otherSource data
object =
    objectWith []


{-| -}
objectWith : List ( String, Argument arg ) -> String -> Selection source data -> Selection otherSource data
objectWith args name (Selection (Details toFieldsGql toFieldsDecoder)) =
    Selection <|
        Details
            (\context ->
                let
                    ( fieldContext, fields ) =
                        toFieldsGql { context | aliases = Dict.empty }

                    new =
                        applyContext args name { fieldContext | aliases = context.aliases }
                in
                ( new.context
                , [ Field name new.aliasString new.args fields
                  ]
                )
            )
            (\context ->
                let
                    ( fieldContext, fieldsDecoder ) =
                        toFieldsDecoder { context | aliases = Dict.empty }

                    new =
                        applyContext args name { fieldContext | aliases = context.aliases }

                    aliasedName =
                        Maybe.withDefault name new.aliasString
                in
                ( new.context
                , Json.field aliasedName fieldsDecoder
                )
            )


{-| This adds a bare decoder for data that has already been pulled down.

Note, this is rarely needed! So far, only when a query or mutation returns a scalar directly without selecting any fields.

-}
decode : Json.Decoder data -> Selection source data
decode decoder =
    Selection <|
        Details
            (\context ->
                ( context
                , []
                )
            )
            (\context ->
                ( context
                , decoder
                )
            )


{-| -}
selectTypeNameButSkip : Selection source ()
selectTypeNameButSkip =
    Selection <|
        Details
            (\context ->
                ( context
                , [ Field "__typename" Nothing [] []
                  ]
                )
            )
            (\context ->
                ( context
                , Json.succeed ()
                )
            )


{-| -}
field : String -> Json.Decoder data -> Selection source data
field =
    fieldWith []


{-| -}
fieldWith : List ( String, Argument arg ) -> String -> Json.Decoder data -> Selection source data
fieldWith args name decoder =
    Selection <|
        Details
            (\context ->
                let
                    new =
                        applyContext args name context
                in
                ( new.context
                , [ Field name new.aliasString new.args []
                  ]
                )
            )
            (\context ->
                let
                    new =
                        applyContext args name context

                    aliasedName =
                        Maybe.withDefault name new.aliasString
                in
                ( new.context
                , Json.field aliasedName decoder
                )
            )


applyContext :
    List ( String, Argument arg )
    -> String
    -> Context
    ->
        { context : Context
        , aliasString : Maybe String
        , args : List ( String, Argument Free )
        }
applyContext args name context =
    let
        ( maybeAlias, newAliases ) =
            makeAlias name context.aliases

        ( vars, newVariables ) =
            captureArgs args context.variables
    in
    { context =
        { aliases = newAliases
        , variables = newVariables
        }
    , aliasString = maybeAlias
    , args = vars
    }


captureArgs : List ( String, Argument arg ) -> Dict String (Argument Free) -> ( List ( String, Argument Free ), Dict String (Argument Free) )
captureArgs args context =
    case args of
        [] ->
            ( [], context )

        _ ->
            captureArgsHelper args context []


captureArgsHelper : List ( String, Argument arg ) -> Dict String (Argument Free) -> List ( String, Argument Free ) -> ( List ( String, Argument Free ), Dict String (Argument Free) )
captureArgsHelper args context alreadyPassed =
    case args of
        [] ->
            ( alreadyPassed, context )

        ( name, value ) :: remaining ->
            let
                varname =
                    getValidVariableName name 0 context

                newContext =
                    Dict.insert varname (toFree value) context
            in
            captureArgsHelper remaining newContext (( name, Var varname ) :: alreadyPassed)


getValidVariableName : String -> Int -> Dict String (Argument Free) -> String
getValidVariableName str index used =
    let
        attemptedName =
            if index == 0 then
                str

            else
                str ++ String.fromInt index
    in
    if Dict.member attemptedName used then
        getValidVariableName str (index + 1) used

    else
        attemptedName


makeAlias : String -> Dict String Int -> ( Maybe String, Dict String Int )
makeAlias name aliases =
    case Dict.get name aliases of
        Nothing ->
            ( Nothing, Dict.insert name 0 aliases )

        Just found ->
            ( Just (name ++ String.fromInt (found + 1))
            , Dict.insert name (found + 1) aliases
            )


{-| -}
type Selection source selected
    = Selection (Details selected)


type alias Context =
    { aliases : Dict String Int
    , variables : Dict String (Argument Free)
    }


{-| -}
unsafe : Selection source selected -> Selection unsafe selected
unsafe (Selection deets) =
    Selection deets


type Free
    = Free


toFree : Argument thing -> Argument Free
toFree argument =
    case argument of
        ArgValue json tag ->
            ArgValue json tag

        Var varname ->
            Var varname


empty : Context
empty =
    { aliases = Dict.empty
    , variables = Dict.empty
    }


{-| An unguarded GQL query.
-}
type Details selected
    = Details
        -- Both of these take a Set String, which is how we're keeping track of
        -- what needs to be aliased
        -- How to make the gql query
        (Context -> ( Context, List Field ))
        -- How to decode the data coming back
        (Context -> ( Context, Json.Decoder selected ))


type Field
    = --    name   alias          args                        children
      Field String (Maybe String) (List ( String, Argument Free )) (List Field)
      --        ...on FragmentName
    | Fragment String (List Field)
    -- a piece of GQL that has been validated separately
    -- This is generally for operational gql
    | Baked String


{-| We can also accept:

  - Enum values (unquoted)
  - custom scalars

But we can define anything else in terms of these:

-}
type Argument obj
    = ArgValue Encode.Value String
    | Var String


{-| -}
type Optional arg
    = Optional String (Argument arg)


{-| The encoded value and the name of the expected type for this argument
-}
arg : Encode.Value -> String -> Argument obj
arg val typename =
    ArgValue val typename


{-| -}
argList : List (Argument obj) -> String -> Argument input
argList fields typeName =
    ArgValue
        (fields
            |> Encode.list
                (\argVal ->
                    case argVal of
                        ArgValue val _ ->
                            val

                        Var varName ->
                            Encode.string varName
                )
        )
        typeName


{-| -}
encodeInputObject : List ( String, Argument obj ) -> String -> Argument input
encodeInputObject fields typeName =
    ArgValue
        (fields
            |> List.map
                (\( name, argVal ) ->
                    case argVal of
                        ArgValue val _ ->
                            ( name, val )

                        Var varName ->
                            ( name, Encode.string varName )
                )
            |> Encode.object
        )
        typeName


{-| -}
encodeArgument : Argument obj -> Encode.Value
encodeArgument argVal =
    case argVal of
        ArgValue val _ ->
            val

        Var varName ->
            Encode.string varName


{-| -}
encodeOptionals : List (Optional arg) -> List ( String, Argument arg )
encodeOptionals opts =
    List.foldl
        (\(Optional optName argument) (( found, gathered ) as skip) ->
            if Set.member optName found then
                skip

            else
                ( Set.insert optName found
                , ( optName, argument ) :: gathered
                )
        )
        ( Set.empty, [] )
        opts
        |> Tuple.second


{-|

    Encode the nullability in the argument itself.

-}
optional : String -> Argument arg -> Optional arg
optional =
    Optional


{-| -}
select : data -> Selection source data
select data =
    Selection
        (Details
            (\context ->
                ( context, [] )
            )
            (\context ->
                ( context, Json.succeed data )
            )
        )


{-| -}
with : Selection source a -> Selection source (a -> b) -> Selection source b
with =
    map2 (|>)


{-| -}
map : (a -> b) -> Selection source a -> Selection source b
map fn (Selection (Details fields decoder)) =
    Selection <|
        Details fields
            (\aliases ->
                let
                    ( newAliases, newDecoder ) =
                        decoder aliases
                in
                ( newAliases, Json.map fn newDecoder )
            )


{-| -}
map2 : (a -> b -> c) -> Selection source a -> Selection source b -> Selection source c
map2 fn (Selection (Details oneFields oneDecoder)) (Selection (Details twoFields twoDecoder)) =
    Selection <|
        Details
            (\aliases ->
                let
                    ( oneAliasesNew, oneFieldsNew ) =
                        oneFields aliases

                    ( twoAliasesNew, twoFieldsNew ) =
                        twoFields oneAliasesNew
                in
                ( twoAliasesNew
                , oneFieldsNew ++ twoFieldsNew
                )
            )
            (\aliases ->
                let
                    ( oneAliasesNew, oneDecoderNew ) =
                        oneDecoder aliases

                    ( twoAliasesNew, twoDecoderNew ) =
                        twoDecoder oneAliasesNew
                in
                ( twoAliasesNew
                , Json.map2 fn oneDecoderNew twoDecoderNew
                )
            )


{-|


-}
prebakedQuery : String -> Json.Decoder data -> Selection Query data
prebakedQuery gql decoder =
    Selection <|
        Details
            (\aliases ->
                ( aliases
                , [ Baked gql
                  ]
                )
            )
            (\aliases ->
                ( aliases
                , decoder
                )
            )




{- Making requests -}


{-| -}
type Query
    = Query


{-| -}
type Mutation
    = Mutation


{-| -}
query :
    Selection Query value
    ->
        { name : Maybe String
        , headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Error value)
query sel config =
    Http.request
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "query" config.name sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


{-| -}
mutation :
    Selection Mutation msg
    ->
        { name : Maybe String
        , headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Error msg)
mutation sel config =
    Http.request
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "mutation" config.name sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


{-|

      Http.request
        { method = "POST"
        , headers = []
        , url = "https://example.com/gql-endpoint"
        , body = Gql.body query
        , expect = Gql.expect Received query
        , timeout = Nothing
        , tracker = Nothing
        }

-}
body : String -> Maybe String -> Selection source data -> Http.Body
body operation maybeUnformattedName q =
    let
        maybeName =
            maybeUnformattedName
                |> Maybe.map
                    sanitizeOperationName

        variables : Dict String (Argument Free)
        variables =
            (getContext q).variables

        encodedVariables : Json.Value
        encodedVariables =
            variables
                |> Dict.toList
                |> List.map (Tuple.mapSecond toValue)
                |> Encode.object

        toValue : Argument arg -> Json.Value
        toValue arg_ =
            case arg_ of
                ArgValue value str ->
                    value

                Var str ->
                    Encode.string str
    in
    Http.jsonBody
        (Encode.object
            (List.filterMap identity
                [ Maybe.map (\name -> ( "operationName", Encode.string name )) maybeName
                , Just ( "query", Encode.string (queryString operation maybeName q) )
                , Just ( "variables", encodedVariables )
                ]
            )
        )


{-|

    Operation names need to be formatted in a certain way.

    This is maybe too restrictive, but this keeps everything as [a-zA-Z0-9] and _

    None mathcing characters will be transformed to _.

-}
sanitizeOperationName : String -> String
sanitizeOperationName input =
    String.toList input
        |> List.map
            (\c ->
                if Char.isAlphaNum c || c == '_' then
                    c

                else
                    '_'
            )
        |> String.fromList


getContext : Selection source selected -> Context
getContext (Selection (Details gql _)) =
    let
        ( context, fields ) =
            gql empty
    in
    context


{-| -}
expect : (Result Error data -> msg) -> Selection source data -> Http.Expect msg
expect toMsg (Selection (Details gql toDecoder)) =
    let
        ( context, decoder ) =
            toDecoder empty
    in
    Http.expectStringResponse toMsg <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err (BadUrl url)

                Http.Timeout_ ->
                    Err Timeout

                Http.NetworkError_ ->
                    Err NetworkError

                Http.BadStatus_ metadata responseBody ->
                    Err
                        (BadStatus
                            { status = metadata.statusCode
                            , responseBody = responseBody
                            }
                        )

                Http.GoodStatus_ metadata responseBody ->
                    case Json.decodeString (Json.field "data" decoder) responseBody of
                        Ok value ->
                            Ok value

                        Err err ->
                            Err
                                (BadBody
                                    { responseBody = responseBody
                                    , decodingError = Json.errorToString err
                                    }
                                )


{-| -}
type Error
    = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus
        { status : Int
        , responseBody : String
        }
    | BadBody
        { decodingError : String
        , responseBody : String
        }


{-| -}
queryString : String -> Maybe String -> Selection source data -> String
queryString operation queryName (Selection (Details gql _)) =
    let
        ( context, fields ) =
            gql empty
    in
    operation
        ++ " "
        ++ Maybe.withDefault "" queryName
        ++ renderParameters context.variables
        ++ "{"
        ++ fieldsToQueryString fields ""
        ++ "}"


renderParameters : Dict String (Argument arg) -> String
renderParameters dict =
    let
        paramList =
            Dict.toList dict
    in
    case paramList of
        [] ->
            ""

        _ ->
            "(" ++ renderParametersHelper paramList "" ++ ")"


renderParametersHelper : List ( String, Argument arg ) -> String -> String
renderParametersHelper args rendered =
    case args of
        [] ->
            rendered

        ( name, value ) :: remaining ->
            if String.isEmpty rendered then
                renderParametersHelper remaining ("$" ++ name ++ ":" ++ argToTypeString value)

            else
                renderParametersHelper remaining (rendered ++ ", $" ++ name ++ ":" ++ argToTypeString value)


fieldsToQueryString : List Field -> String -> String
fieldsToQueryString fields rendered =
    case fields of
        [] ->
            rendered

        top :: remaining ->
            if String.isEmpty rendered then
                fieldsToQueryString remaining (renderField top)

            else
                fieldsToQueryString remaining (rendered ++ "\n" ++ renderField top)


renderField : Field -> String
renderField myField =
    case myField of
        Baked q ->
            q

        Fragment name fields ->
            "... on "
                ++ name
                ++ "{"
                ++ fieldsToQueryString fields ""
                ++ "}"

        Field name maybeAlias args fields ->
            let
                aliasString =
                    maybeAlias
                        |> Maybe.map (\a -> a ++ ":")
                        |> Maybe.withDefault ""

                argString =
                    case args of
                        [] ->
                            ""

                        nonEmpty ->
                            "(" ++ renderArgs nonEmpty "" ++ ")"

                selection =
                    case fields of
                        [] ->
                            ""

                        _ ->
                            "{" ++ fieldsToQueryString fields "" ++ "}"
            in
            aliasString ++ name ++ argString ++ selection


renderArgs : List ( String, Argument arg ) -> String -> String
renderArgs args rendered =
    case args of
        [] ->
            rendered

        ( name, top ) :: remaining ->
            if String.isEmpty rendered then
                renderArgs remaining (rendered ++ name ++ ": " ++ argToString top)

            else
                renderArgs remaining (rendered ++ ", " ++ name ++ ": " ++ argToString top)


argToString : Argument arg -> String
argToString argument =
    case argument of
        ArgValue json typename ->
            Encode.encode 0 json

        Var str ->
            "$" ++ str


argToTypeString : Argument arg -> String
argToTypeString argument =
    case argument of
        ArgValue v typename ->
            typename

        Var str ->
            ""


{-| -}
maybeScalarEncode : (a -> Encode.Value) -> Maybe a -> Encode.Value
maybeScalarEncode encoder maybeA =
    maybeA
        |> Maybe.map encoder
        |> Maybe.withDefault Encode.null


{-| -}
decodeNullable : Json.Decoder data -> Json.Decoder (Maybe data)
decodeNullable decoder =
    Json.oneOf
        [ Json.map Just decoder
        , Json.succeed Nothing
        ]

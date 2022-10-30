module GraphQL.Engine exposing
    ( batch
    , nullable, list, object, objectWith, decode
    , enum, maybeEnum
    , field, fieldWith
    , union
    , Selection, select, with, map, map2, recover, withName
    , arg, argList, Optional, optional
    , Query, query, Mutation, mutation, Error(..)
    , queryString
    , Argument(..), maybeScalarEncode
    , encodeOptionals, encodeOptionalsAsJson, encodeInputObject, encodeArgument
    , decodeNullable
    , unsafe, selectTypeNameButSkip
    , Request, send, simulate, mapRequest
    , Option(..), InputObject, inputObject, addField, addOptionalField, encodeInputObjectAsJson, inputObjectToFieldList
    , jsonField, andMap, versionedJsonField, versionedName, versionedAlias
    , bakeToSelection
    )

{-|

@docs batch

@docs nullable, list, object, objectWith, decode

@docs enum, maybeEnum

@docs field, fieldWith

@docs union

@docs Selection, select, with, map, map2, recover, withName

@docs arg, argList, Optional, optional

@docs Query, query, Mutation, mutation, Error

@docs queryString

@docs Argument, maybeScalarEncode

@docs encodeOptionals, encodeOptionalsAsJson, encodeInputObject, encodeArgument

@docs decodeNullable

@docs unsafe, selectTypeNameButSkip

@docs Request, toRequest, send, simulate, mapRequest

@docs Option, InputObject, inputObject, addField, addOptionalField, encodeInputObjectAsJson, inputObjectToFieldList

@docs jsonField, andMap, versionedJsonField, versionedName, versionedAlias

-}

import Dict exposing (Dict)
import Http
import Json.Decode
import Json.Encode
import Set


{-| Batch a number of selection sets together!
-}
batch : List (Selection source data) -> Selection source (List data)
batch selections =
    Selection <|
        Details
            (List.foldl
                (\(Selection (Details newOpName _ _)) maybeOpName ->
                    mergeOpNames maybeOpName newOpName
                )
                Nothing
                selections
            )
            (\context ->
                List.foldl
                    (\(Selection (Details _ toFieldsGql _)) cursor ->
                        let
                            new =
                                toFieldsGql cursor.context
                        in
                        { context = new.context
                        , fields = cursor.fields ++ new.fields
                        , fragments = cursor.fragments ++ new.fragments
                        }
                    )
                    { context = context
                    , fields = []
                    , fragments = ""
                    }
                    selections
            )
            (\context ->
                List.foldl
                    (\(Selection (Details _ _ toItemDecoder)) ( ctxt, cursorFieldsDecoder ) ->
                        let
                            ( newCtxt, itemDecoder ) =
                                toItemDecoder ctxt
                        in
                        ( newCtxt
                        , cursorFieldsDecoder
                            |> Json.Decode.andThen
                                (\existingList ->
                                    Json.Decode.map
                                        (\item ->
                                            item :: existingList
                                        )
                                        itemDecoder
                                )
                        )
                    )
                    ( context, Json.Decode.succeed [] )
                    selections
            )


{-| -}
recover : recovered -> (data -> recovered) -> Selection source data -> Selection source recovered
recover default wrapValue (Selection (Details opName toQuery toDecoder)) =
    Selection
        (Details opName
            toQuery
            (\context ->
                let
                    ( newContext, decoder ) =
                        toDecoder context
                in
                ( newContext
                , Json.Decode.oneOf
                    [ Json.Decode.map wrapValue decoder
                    , Json.Decode.succeed default
                    ]
                )
            )
        )


{-| -}
union : List ( String, Selection source data ) -> Selection source data
union options =
    Selection <|
        Details Nothing
            (\context ->
                let
                    ( fragments, fragmentContext ) =
                        List.foldl
                            (\( name, Selection (Details _ fragQuery _) ) ( frags, currentContext ) ->
                                let
                                    rendered =
                                        fragQuery currentContext

                                    nonEmptyFields =
                                        case rendered.fields of
                                            [] ->
                                                -- we're already selecting typename at the root.
                                                -- this is just so we don't have an empty set of brackets
                                                [ Field "__typename" Nothing [] [] ]

                                            fields ->
                                                fields
                                in
                                ( Fragment name nonEmptyFields :: frags
                                , rendered.context
                                )
                            )
                            ( [], context )
                            options
                in
                { context = fragmentContext
                , fields = Field "__typename" Nothing [] [] :: fragments
                , fragments = ""
                }
            )
            (\context ->
                let
                    ( fragmentDecoders, fragmentContext ) =
                        List.foldl
                            (\( name, Selection (Details _ _ toFragDecoder) ) ( frags, currentContext ) ->
                                let
                                    ( newContext, fragDecoder ) =
                                        toFragDecoder currentContext

                                    fragDecoderWithTypename =
                                        Json.Decode.field "__typename" Json.Decode.string
                                            |> Json.Decode.andThen
                                                (\typename ->
                                                    if typename == name then
                                                        fragDecoder

                                                    else
                                                        Json.Decode.fail "Unknown union variant"
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
                , Json.Decode.oneOf fragmentDecoders
                )
            )


{-| -}
maybeEnum : List ( String, item ) -> Json.Decode.Decoder (Maybe item)
maybeEnum options =
    Json.Decode.oneOf
        [ Json.Decode.map Just (enum options)
        , Json.Decode.succeed Nothing
        ]


{-| -}
enum : List ( String, item ) -> Json.Decode.Decoder item
enum options =
    Json.Decode.string
        |> Json.Decode.andThen
            (findFirstMatch options)


findFirstMatch : List ( String, item ) -> String -> Json.Decode.Decoder item
findFirstMatch options str =
    case options of
        [] ->
            Json.Decode.fail ("Unexpected enum value: " ++ str)

        ( name, value ) :: remaining ->
            if name == str then
                Json.Decode.succeed value

            else
                findFirstMatch remaining str


{-| Used in generated code to handle maybes
-}
nullable : Selection source data -> Selection source (Maybe data)
nullable (Selection (Details opName toFieldsGql toFieldsDecoder)) =
    Selection <|
        Details
            opName
            toFieldsGql
            (\context ->
                let
                    ( fieldContext, fieldsDecoder ) =
                        toFieldsDecoder context
                in
                ( fieldContext
                , Json.Decode.oneOf
                    [ Json.Decode.map Just fieldsDecoder
                    , Json.Decode.succeed Nothing
                    ]
                )
            )


{-| Used in generated code to handle maybes
-}
list : Selection source data -> Selection source (List data)
list (Selection (Details opName toFieldsGql toFieldsDecoder)) =
    Selection <|
        Details
            opName
            toFieldsGql
            (\context ->
                let
                    ( fieldContext, fieldsDecoder ) =
                        toFieldsDecoder context
                in
                ( fieldContext
                , Json.Decode.list fieldsDecoder
                )
            )


{-| -}
object : String -> Selection source data -> Selection otherSource data
object =
    objectWith (inputObject "NoArgs")


type Variable
    = Variable String


{-| -}
objectWith : InputObject args -> String -> Selection source data -> Selection otherSource data
objectWith inputObj name (Selection (Details opName toFieldsGql toFieldsDecoder)) =
    Selection <|
        Details
            opName
            (\context ->
                let
                    rendered =
                        toFieldsGql { context | aliases = Dict.empty }

                    fieldContext =
                        rendered.context

                    new =
                        applyContext inputObj name { fieldContext | aliases = context.aliases }
                in
                { context = new.context
                , fields =
                    [ Field name new.aliasString new.args rendered.fields
                    ]
                , fragments = rendered.fragments
                }
            )
            (\context ->
                let
                    ( fieldContext, fieldsDecoder ) =
                        toFieldsDecoder { context | aliases = Dict.empty }

                    new =
                        applyContext inputObj name { fieldContext | aliases = context.aliases }

                    aliasedName =
                        Maybe.withDefault name new.aliasString
                in
                ( new.context
                , Json.Decode.field aliasedName fieldsDecoder
                )
            )


{-| This adds a bare decoder for data that has already been pulled down.

Note, this is rarely needed! So far, only when a query or mutation returns a scalar directly without selecting any fields.

-}
decode : Json.Decode.Decoder data -> Selection source data
decode decoder =
    Selection <|
        Details Nothing
            (\context ->
                { context = context
                , fields = []
                , fragments = ""
                }
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
        Details Nothing
            (\context ->
                { context = context
                , fields =
                    [ Field "__typename" Nothing [] []
                    ]
                , fragments = ""
                }
            )
            (\context ->
                ( context
                , Json.Decode.succeed ()
                )
            )


{-| -}
field : String -> String -> Json.Decode.Decoder data -> Selection source data
field name gqlTypeName decoder =
    fieldWith (inputObject gqlTypeName) name gqlTypeName decoder


{-| -}
fieldWith : InputObject args -> String -> String -> Json.Decode.Decoder data -> Selection source data
fieldWith args name gqlType decoder =
    Selection <|
        Details Nothing
            (\context ->
                let
                    new =
                        applyContext args name context
                in
                { context = new.context
                , fields =
                    [ Field name new.aliasString new.args []
                    ]
                , fragments = ""
                }
            )
            (\context ->
                let
                    new =
                        applyContext args name context

                    aliasedName =
                        Maybe.withDefault name new.aliasString
                in
                ( new.context
                , Json.Decode.field aliasedName decoder
                )
            )


applyContext :
    InputObject args
    -> String
    -> Context
    ->
        { context : Context
        , aliasString : Maybe String
        , args : List ( String, Variable )
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
        , version = context.version
        }
    , aliasString = maybeAlias
    , args = vars
    }


{-| This is the piece of code that's responsible for swapping real argument values (i.e. json values)

with variables.

-}
captureArgs :
    InputObject args
    -> Dict String VariableDetails
    ->
        ( List ( String, Variable )
        , Dict String VariableDetails
        )
captureArgs (InputObject objname args) context =
    case args of
        [] ->
            ( [], context )

        _ ->
            captureArgsHelper args context []


{-| -}
captureArgsHelper :
    List ( String, VariableDetails )
    -> Dict String VariableDetails
    -> List ( String, Variable )
    ->
        ( List ( String, Variable )
        , Dict String VariableDetails
        )
captureArgsHelper args context alreadyPassed =
    case args of
        [] ->
            ( alreadyPassed, context )

        ( name, value ) :: remaining ->
            let
                varname =
                    getValidVariableName name 0 context

                newContext =
                    Dict.insert varname value context
            in
            captureArgsHelper remaining
                newContext
                (( name, Variable varname ) :: alreadyPassed)


getValidVariableName : String -> Int -> Dict String val -> String
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
    { version : Int
    , aliases : Dict String Int
    , variables : Dict String VariableDetails
    }


type alias VariableDetails =
    { gqlTypeName : String
    , value : Maybe Json.Encode.Value
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
    , version = 0
    , variables = Dict.empty
    }


withName : String -> Selection source data -> Selection source data
withName name (Selection (Details _ toGql toDecoder)) =
    Selection (Details (Just name) toGql toDecoder)


{-| An unguarded GQL query.
-}
type Details selected
    = Details
        -- This is an optional *operation name*
        -- Can only be set on Queries and Mutations
        (Maybe String)
        -- Both of these take a Set String, which is how we're keeping track of
        -- what needs to be aliased
        -- How to make the gql query
        (Context
         ->
            { context : Context
            , fields : List Field
            , fragments : String
            }
        )
        -- How to decode the data coming back
        (Context -> ( Context, Json.Decode.Decoder selected ))


type Field
    = --    name   alias          args                        children
      Field String (Maybe String) (List ( String, Variable )) (List Field)
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
    = ArgValue Json.Encode.Value String
    | Var String


{-| -}
type Option value
    = Present value
    | Null
    | Absent


{-| -}
type InputObject value
    = InputObject String (List ( String, VariableDetails ))


{-| -}
inputObject : String -> InputObject value
inputObject name =
    InputObject name []


{-| -}
addField : String -> String -> Json.Encode.Value -> InputObject value -> InputObject value
addField fieldName gqlFieldType val (InputObject name inputFields) =
    InputObject name
        (( fieldName
         , { gqlTypeName = gqlFieldType
           , value = Just val
           }
         )
            :: inputFields
        )


{-| -}
addOptionalField : String -> String -> Option value -> (value -> Json.Encode.Value) -> InputObject input -> InputObject input
addOptionalField fieldName gqlFieldType optionalValue toJsonValue (InputObject name inputFields) =
    InputObject name
        (case optionalValue of
            Absent ->
                ( fieldName, { value = Nothing, gqlTypeName = gqlFieldType } ) :: inputFields

            Null ->
                ( fieldName, { value = Just Json.Encode.null, gqlTypeName = gqlFieldType } ) :: inputFields

            Present val ->
                ( fieldName, { value = Just (toJsonValue val), gqlTypeName = gqlFieldType } ) :: inputFields
        )


{-| -}
type Optional arg
    = Optional String (Argument arg)


{-| The encoded value and the name of the expected type for this argument
-}
arg : Json.Encode.Value -> String -> Argument obj
arg val typename =
    ArgValue val typename


{-| -}
argList : List (Argument obj) -> String -> Argument input
argList fields typeName =
    ArgValue
        (fields
            |> Json.Encode.list
                (\argVal ->
                    case argVal of
                        ArgValue val _ ->
                            val

                        Var varName ->
                            Json.Encode.string varName
                )
        )
        typeName


{-| -}
inputObjectToFieldList : InputObject a -> List ( String, VariableDetails )
inputObjectToFieldList (InputObject _ fields) =
    fields


{-| -}
encodeInputObjectAsJson : InputObject value -> Json.Decode.Value
encodeInputObjectAsJson (InputObject _ fields) =
    fields
        |> List.filterMap
            (\( varName, var ) ->
                case var.value of
                    Nothing ->
                        Nothing

                    Just value ->
                        Just ( varName, value )
            )
        |> Json.Encode.object


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
                            ( name, Json.Encode.string varName )
                )
            |> Json.Encode.object
        )
        typeName


{-| -}
encodeArgument : Argument obj -> Json.Encode.Value
encodeArgument argVal =
    case argVal of
        ArgValue val _ ->
            val

        Var varName ->
            Json.Encode.string varName


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


{-| -}
encodeOptionalsAsJson : List (Optional arg) -> List ( String, Json.Encode.Value )
encodeOptionalsAsJson opts =
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
        |> List.map (Tuple.mapSecond encodeArgument)


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
        (Details Nothing
            (\context ->
                { context = context
                , fields = []
                , fragments = ""
                }
            )
            (\context ->
                ( context, Json.Decode.succeed data )
            )
        )


{-| -}
with : Selection source a -> Selection source (a -> b) -> Selection source b
with =
    map2 (|>)


{-| -}
map : (a -> b) -> Selection source a -> Selection source b
map fn (Selection (Details maybeOpName fields decoder)) =
    Selection <|
        Details maybeOpName
            fields
            (\aliases ->
                let
                    ( newAliases, newDecoder ) =
                        decoder aliases
                in
                ( newAliases, Json.Decode.map fn newDecoder )
            )


mergeOpNames : Maybe String -> Maybe String -> Maybe String
mergeOpNames maybeOne maybeTwo =
    case ( maybeOne, maybeTwo ) of
        ( Nothing, Nothing ) ->
            Nothing

        ( Just one, _ ) ->
            Just one

        ( _, Just two ) ->
            Just two


{-| -}
map2 : (a -> b -> c) -> Selection source a -> Selection source b -> Selection source c
map2 fn (Selection (Details oneOpName oneFields oneDecoder)) (Selection (Details twoOpName twoFields twoDecoder)) =
    Selection <|
        Details
            (mergeOpNames oneOpName twoOpName)
            (\aliases ->
                let
                    one =
                        oneFields aliases

                    two =
                        twoFields one.context
                in
                { context = two.context
                , fields = one.fields ++ two.fields
                , fragments = one.fragments ++ two.fragments
                }
            )
            (\aliases ->
                let
                    ( oneAliasesNew, oneDecoderNew ) =
                        oneDecoder aliases

                    ( twoAliasesNew, twoDecoderNew ) =
                        twoDecoder oneAliasesNew
                in
                ( twoAliasesNew
                , Json.Decode.map2 fn oneDecoderNew twoDecoderNew
                )
            )


{-| -}
bakeToSelection :
    Maybe String
    ->
        (Int
         ->
            { args : List ( String, VariableDetails )
            , body : String
            , fragments : String
            }
        )
    -> (Int -> Json.Decode.Decoder data)
    -> Selection source data
bakeToSelection maybeOpName toGql toDecoder =
    Selection
        (Details maybeOpName
            (\context ->
                let
                    gql =
                        toGql context.version
                in
                { context =
                    { context
                        | version = context.version + 1
                        , variables =
                            gql.args
                                |> List.map (protectArgs context.version)
                                |> Dict.fromList
                                |> Dict.union context.variables
                    }
                , fields = [ Baked gql.body ]
                , fragments = gql.fragments
                }
            )
            (\context ->
                let
                    decoder =
                        toDecoder context.version
                in
                ( { context
                    | version = context.version + 1
                  }
                , decoder
                )
            )
        )


protectArgs : Int -> ( String, VariableDetails ) -> ( String, VariableDetails )
protectArgs version ( name, var ) =
    ( versionedName version name, var )



{- Making requests -}


{-| -}
type Query
    = Query


{-| -}
type Mutation
    = Mutation


{-| -}
type Request value
    = Request
        { method : String
        , headers : List ( String, String )
        , url : String
        , body : Json.Encode.Value
        , expect : Http.Response String -> Result Error value
        , timeout : Maybe Float
        , tracker : Maybe String
        }


{-| -}
mapRequest : (a -> b) -> Request a -> Request b
mapRequest fn (Request request) =
    Request
        { method = request.method
        , headers = request.headers
        , url = request.url
        , body = request.body
        , expect = request.expect >> Result.map fn
        , timeout = request.timeout
        , tracker = request.tracker
        }


{-| -}
send : Request data -> Cmd (Result Error data)
send (Request req) =
    Http.request
        { method = req.method
        , headers = List.map (\( key, val ) -> Http.header key val) req.headers
        , url = req.url
        , body = Http.jsonBody req.body
        , expect =
            Http.expectStringResponse identity req.expect
        , timeout = req.timeout
        , tracker = req.tracker
        }


{-| -}
simulate :
    { toHeader : String -> String -> header
    , toExpectation : (Http.Response String -> Result Error value) -> expectation
    , toBody : Json.Encode.Value -> body
    , toRequest :
        { method : String
        , headers : List header
        , url : String
        , body : body
        , expect : expectation
        , timeout : Maybe Float
        , tracker : Maybe String
        }
        -> simulated
    }
    -> Request value
    -> simulated
simulate config (Request req) =
    config.toRequest
        { method = req.method
        , headers = List.map (\( key, val ) -> config.toHeader key val) req.headers
        , url = req.url
        , body = config.toBody req.body
        , expect = config.toExpectation req.expect
        , timeout = req.timeout
        , tracker = req.tracker
        }


{-| -}
query :
    Selection Query value
    ->
        { headers : List Http.Header
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
        , body = body "query" sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


{-| -}
mutation :
    Selection Mutation msg
    ->
        { headers : List Http.Header
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
        , body = body "mutation" sel
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
body : String -> Selection source data -> Http.Body
body operation q =
    let
        variables : Dict String VariableDetails
        variables =
            (getContext q).variables

        encodedVariables : Json.Decode.Value
        encodedVariables =
            variables
                |> Dict.toList
                |> List.filterMap
                    (\( varName, var ) ->
                        case var.value of
                            Nothing ->
                                Nothing

                            Just value ->
                                Just ( varName, value )
                    )
                |> Json.Encode.object
    in
    Http.jsonBody
        (Json.Encode.object
            (List.filterMap identity
                [ Just ( "query", Json.Encode.string (queryString operation q) )
                , Just ( "variables", encodedVariables )
                ]
            )
        )


{-|

    Operation names need to be formatted in a certain way.

    This is maybe too restrictive, but this keeps everything as [a-zA-Z0-9] and _

    None matching characters will be transformed to _.

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
getContext (Selection (Details maybeOpName gql _)) =
    let
        rendered =
            gql empty
    in
    rendered.context


{-| -}
expect : (Result Error data -> msg) -> Selection source data -> Http.Expect msg
expect toMsg (Selection (Details maybeOpName gql toDecoder)) =
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
                    case Json.Decode.decodeString (Json.Decode.field "data" decoder) responseBody of
                        Ok value ->
                            Ok value

                        Err err ->
                            Err
                                (BadBody
                                    { responseBody = responseBody
                                    , decodingError = Json.Decode.errorToString err
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
queryString : String -> Selection source data -> String
queryString operation (Selection (Details maybeOpName gql _)) =
    let
        rendered =
            gql empty
    in
    operation
        ++ " "
        ++ Maybe.withDefault "" maybeOpName
        ++ renderParameters rendered.context.variables
        ++ "{"
        ++ fieldsToQueryString rendered.fields ""
        ++ "}"
        ++ rendered.fragments


renderParameters : Dict String VariableDetails -> String
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


renderParametersHelper : List ( String, VariableDetails ) -> String -> String
renderParametersHelper args rendered =
    case args of
        [] ->
            rendered

        ( name, value ) :: remaining ->
            if String.isEmpty rendered then
                renderParametersHelper remaining ("$" ++ name ++ ":" ++ value.gqlTypeName)

            else
                renderParametersHelper remaining (rendered ++ ", $" ++ name ++ ":" ++ value.gqlTypeName)


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


renderArgs : List ( String, Variable ) -> String -> String
renderArgs args rendered =
    case args of
        [] ->
            rendered

        ( name, Variable varName ) :: remaining ->
            if String.isEmpty rendered then
                renderArgs remaining (rendered ++ name ++ ": $" ++ varName)

            else
                renderArgs remaining (rendered ++ ", " ++ name ++ ": $" ++ varName)


argToString : Argument arg -> String
argToString argument =
    case argument of
        ArgValue json typename ->
            Json.Encode.encode 0 json

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
maybeScalarEncode : (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
maybeScalarEncode encoder maybeA =
    maybeA
        |> Maybe.map encoder
        |> Maybe.withDefault Json.Encode.null


{-| -}
decodeNullable : Json.Decode.Decoder data -> Json.Decode.Decoder (Maybe data)
decodeNullable =
    Json.Decode.nullable


versionedJsonField :
    Int
    -> String
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
versionedJsonField int name new build =
    Json.Decode.map2
        (\a fn -> fn a)
        (Json.Decode.field (versionedName int name) new)
        build


versionedName : Int -> String -> String
versionedName i name =
    if i == 0 then
        name

    else
        name ++ "_batch_" ++ String.fromInt i


{-| Slightly different than versioned name, this is specific to only making an alias if the version is not 0.

so if I'm selecting a field "myField"

Then

    versionedAlias 0 "myField"
        -> "myField"

but

    versionedAlias 1 "myField"
        -> "myField\_batch\_1: myField"

-}
versionedAlias : Int -> String -> String
versionedAlias i name =
    if i == 0 then
        name

    else
        name ++ "_batch_" ++ String.fromInt i ++ ": " ++ name


jsonField :
    String
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
jsonField name new build =
    Json.Decode.map2
        (\a fn -> fn a)
        (Json.Decode.field name new)
        build


andMap :
    Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
andMap new build =
    Json.Decode.map2
        (\a fn -> fn a)
        new
        build

module GraphQL.Engine exposing
    ( field, fieldWith, object, objectWith
    , enum, maybeEnum
    , union
    , Selection, select, with, map, map2, recover
    , arg
    , Query, query, Mutation, mutation
    , queryString
    )

{-|

@docs field, fieldWith, object, objectWith

@docs enum, maybeEnum

@docs union

@docs Selection, select, with, map, map2, recover

@docs arg

@docs Query, query, Mutation, mutation

@docs queryString

-}

import Dict exposing (Dict)
import Http
import Json.Decode as Json
import Json.Encode


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
                                in
                                ( Fragment name fields :: frags
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


{-| -}
object : String -> Selection source data -> Selection source data
object =
    objectWith []


{-| -}
objectWith : List ( String, Argument ) -> String -> Selection source data -> Selection source data
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


field : String -> Json.Decoder data -> Selection source data
field =
    fieldWith []


fieldWith : List ( String, Argument ) -> String -> Json.Decoder data -> Selection source data
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
    List ( String, Argument )
    -> String
    -> Context
    ->
        { context : Context
        , aliasString : Maybe String
        , args : List ( String, Argument )
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


captureArgs : List ( String, Argument ) -> Dict String Argument -> ( List ( String, Argument ), Dict String Argument )
captureArgs args context =
    case args of
        [] ->
            ( args, context )

        _ ->
            captureArgsHelper args context []


captureArgsHelper : List ( String, Argument ) -> Dict String Argument -> List ( String, Argument ) -> ( List ( String, Argument ), Dict String Argument )
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
            captureArgsHelper remaining newContext (( name, Var varname ) :: alreadyPassed)


getValidVariableName : String -> Int -> Dict String Argument -> String
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


type Selection source selected
    = Selection (Details selected)


type alias Context =
    { aliases : Dict String Int
    , variables : Dict String Argument
    }


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
      Field String (Maybe String) (List ( String, Argument )) (List Field)
      --        ...on FragmentName
    | Fragment String (List Field)


{-| We can also accept:

  - Enum values (unquoted)
  - custom scalars

But we can define anything else in terms of these:

-}
type Argument
    = ArgValue Json.Encode.Value String
    | Var String


{-| The encoded value and the name of the expected type for this argument
-}
arg : Json.Encode.Value -> String -> Argument
arg val typename =
    ArgValue val typename


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



{- Making requests -}


type Query
    = Query


type Mutation
    = Mutation


query :
    Selection Query msg
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Http.Error msg)
query sel config =
    Http.request
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


mutation :
    Selection Mutation msg
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Http.Error msg)
mutation sel config =
    Http.request
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body sel
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
body : Selection source data -> Http.Body
body q =
    Http.jsonBody
        (Json.Encode.object
            [ ( "query", Json.Encode.string (queryString q) ) ]
        )


{-| -}
expect : (Result Http.Error data -> msg) -> Selection source data -> Http.Expect msg
expect toMsg (Selection (Details gql toDecoder)) =
    let
        ( context, decoder ) =
            toDecoder empty
    in
    Http.expectJson toMsg (Json.field "data" decoder)


queryString : Selection source data -> String
queryString (Selection (Details gql _)) =
    let
        ( context, fields ) =
            gql empty

        operation =
            "query"

        queryName =
            "MyQuery"
    in
    operation
        ++ " "
        ++ queryName
        ++ renderParameters context.variables
        ++ "{"
        ++ fieldsToQueryString fields ""
        ++ "}"
        ++ "\n"
        ++ renderParameterValues context.variables


renderParameterValues : Dict String Argument -> String
renderParameterValues dict =
    let
        list =
            Dict.toList dict
    in
    case list of
        [] ->
            ""

        _ ->
            "{" ++ renderParameterValuesHelper list "" ++ "}"


renderParameterValuesHelper : List ( String, Argument ) -> String -> String
renderParameterValuesHelper args rendered =
    case args of
        [] ->
            rendered

        ( name, value ) :: remaining ->
            let
                comma =
                    case rendered of
                        "" ->
                            ""

                        _ ->
                            ", "
            in
            renderParameterValuesHelper remaining (rendered ++ comma ++ "\"" ++ name ++ "\" :" ++ argToString value)


renderParameters : Dict String Argument -> String
renderParameters dict =
    let
        list =
            Dict.toList dict
    in
    case list of
        [] ->
            ""

        _ ->
            "(" ++ renderParametersHelper list "" ++ ")"


renderParametersHelper : List ( String, Argument ) -> String -> String
renderParametersHelper args rendered =
    case args of
        [] ->
            rendered

        ( name, value ) :: remaining ->
            let
                comma =
                    case rendered of
                        "" ->
                            ""

                        _ ->
                            ", "
            in
            renderParametersHelper remaining (rendered ++ comma ++ "$" ++ name ++ ":" ++ argToTypeString value)


fieldsToQueryString : List Field -> String -> String
fieldsToQueryString fields rendered =
    case fields of
        [] ->
            rendered

        top :: remaining ->
            fieldsToQueryString remaining (rendered ++ renderField top)


renderField : Field -> String
renderField myField =
    case myField of
        Fragment name fields ->
            ".. on "
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


renderArgs : List ( String, Argument ) -> String -> String
renderArgs args rendered =
    case args of
        [] ->
            rendered

        ( name, top ) :: remaining ->
            renderArgs remaining (rendered ++ name ++ ": " ++ argToString top)


argToString : Argument -> String
argToString argument =
    case argument of
        ArgValue json typename ->
            Json.Encode.encode 0 json

        Var str ->
            "$" ++ str


argToTypeString : Argument -> String
argToTypeString argument =
    case argument of
        ArgValue v typename ->
            typename

        Var str ->
            ""

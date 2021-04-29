module Gql.Engine exposing
    ( field, fieldWith, object, objectWith
    , Data, Query, map, map2
    , stringArg
    , body, expect
    , queryString
    )

{-|

@docs field, fieldWith, object, objectWith

@docs Data, Query, map, map2

@docs stringArg

@docs body, expect

@docs queryString

-}

import Dict exposing (Dict)
import Http
import Json.Decode as Json
import Json.Encode


{-| -}
object : String -> Query data -> Query data
object =
    objectWith []


{-| -}
objectWith : List ( String, Argument ) -> String -> Query data -> Query data
objectWith args name (Query toFieldsGql toFieldsDecoder) =
    Query
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


field : String -> Json.Decoder data -> Query data
field =
    fieldWith []


fieldWith : List ( String, Argument ) -> String -> Json.Decoder data -> Query data
fieldWith args name decoder =
    Query
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


type Data source selected
    = Data (Query selected)


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
type Query selected
    = Query
        -- Both of these take a Set String, which is how we're keeping track of
        -- what needs to be aliased
        -- How to make the gql query
        (Context -> ( Context, List Field ))
        -- How to decode the data coming back
        (Context -> ( Context, Json.Decoder selected ))


type Field
    = --    name   alias          args                        children
      Field String (Maybe String) (List ( String, Argument )) (List Field)


{-| We can also accept:

  - Enum values (unquoted)
  - custom scalars

But we can define anything else in terms of these:

-}
type Argument
    = ArgString String -- includes quotes
    | ArgStringLiteral String -- does not include quotes
    | ArgFloat Float
    | ArgInt Int
    | ArgBoolean Bool
    | Null
    | Var String


{-| -}
stringArg : String -> Argument
stringArg str =
    ArgString str


map : (a -> b) -> Query a -> Query b
map fn (Query fields decoder) =
    Query fields
        (\aliases ->
            let
                ( newAliases, newDecoder ) =
                    decoder aliases
            in
            ( newAliases, Json.map fn newDecoder )
        )


map2 : (a -> b -> c) -> Query a -> Query b -> Query c
map2 fn (Query oneFields oneDecoder) (Query twoFields twoDecoder) =
    Query
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
body : Query data -> Http.Body
body q =
    Http.jsonBody
        (Json.Encode.object
            [ ( "query", Json.Encode.string (queryString q) ) ]
        )


{-| -}
expect : (Result Http.Error data -> msg) -> Query data -> Http.Expect msg
expect toMsg (Query gql decoder) =
    Http.expectJson toMsg (Tuple.second (decoder empty))


queryString : Query data -> String
queryString (Query gql _) =
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
renderField (Field name maybeAlias args children) =
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
            case children of
                [] ->
                    ""

                _ ->
                    "{" ++ fieldsToQueryString children "" ++ "}"
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
argToString arg =
    case arg of
        ArgString string ->
            "\"" ++ string ++ "\""

        ArgStringLiteral string ->
            string

        ArgFloat float ->
            String.fromFloat float

        ArgInt int ->
            String.fromInt int

        ArgBoolean True ->
            "true"

        ArgBoolean False ->
            "false"

        Null ->
            "null"

        Var str ->
            "$" ++ str


argToTypeString : Argument -> String
argToTypeString arg =
    case arg of
        ArgString string ->
            "String"

        ArgStringLiteral string ->
            "Enum"

        ArgFloat float ->
            "Float"

        ArgInt int ->
            "Int"

        ArgBoolean _ ->
            "Boolean"

        Null ->
            "null"

        Var str ->
            ""

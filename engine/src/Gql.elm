module Gql exposing
    ( field, fieldWith, object, objectWith
    , Data, Query, map, map2
    , body, expect
    , queryString
    )

{-|

@docs field, fieldWith, object, objectWith

@docs Data, Query, map, map2

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
        (\aliases ->
            let
                ( maybeAlias, newAliases ) =
                    makeAlias name aliases

                ( _, fields ) =
                    toFieldsGql Dict.empty
            in
            ( newAliases
            , [ Field name maybeAlias args fields
              ]
            )
        )
        (\aliases ->
            let
                ( maybeAlias, newAliases ) =
                    makeAlias name aliases

                aliasedName =
                    Maybe.withDefault name maybeAlias

                ( _, fieldsDecoder ) =
                    toFieldsDecoder Dict.empty
            in
            ( newAliases
            , Json.field aliasedName fieldsDecoder
            )
        )


field : String -> Json.Decoder data -> Query data
field =
    fieldWith []


fieldWith : List ( String, Argument ) -> String -> Json.Decoder data -> Query data
fieldWith args name decoder =
    Query
        (\aliases ->
            let
                ( maybeAlias, newAliases ) =
                    makeAlias name aliases
            in
            ( newAliases
            , [ Field name maybeAlias args []
              ]
            )
        )
        (\aliases ->
            let
                ( maybeAlias, newAliases ) =
                    makeAlias name aliases

                aliasedName =
                    Maybe.withDefault name maybeAlias
            in
            ( newAliases
            , Json.field aliasedName decoder
            )
        )


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


type alias AliasCache =
    Dict String Int


{-| An unguarded GQL query.
-}
type Query selected
    = Query
        -- Both of these take a Set String, which is how we're keeping track of
        -- what needs to be aliased
        -- How to make the gql query
        (AliasCache -> ( AliasCache, List Field ))
        -- How to decode the data coming back
        (AliasCache -> ( AliasCache, Json.Decoder selected ))


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
    Http.expectJson toMsg (Tuple.second (decoder Dict.empty))


queryString : Query data -> String
queryString (Query gql _) =
    let
        ( _, fields ) =
            gql Dict.empty
    in
    fieldsToQueryString fields ""


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
    in
    aliasString ++ name ++ argString ++ "{" ++ fieldsToQueryString children "" ++ "}"


renderArgs : List ( String, Argument ) -> String -> String
renderArgs args rendered =
    case args of
        [] ->
            ""

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

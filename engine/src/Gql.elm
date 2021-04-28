module Gql exposing (..)

{-| -}

import Http
import Json.Decode as Json
import Json.Encode
import Set exposing (Set)


type Data source selected
    = Data (Query selected)


{-| An unguarded GQL query.
-}
type Query selected
    = Query
        -- Both of these take a Set String, which is how we're keeping track of
        -- what needs to be aliased
        -- How to make the gql query
        (Set String -> List Field)
        -- How to decode the data coming back
        (Set String -> Json.Decoder selected)


map : (a -> b) -> Query a -> Query b
map fn (Query fields decoder) =
    Query fields
        (\aliases ->
            Json.map fn (decoder aliases)
        )


map2 : (a -> b -> c) -> Query a -> Query b -> Query c
map2 fn (Query oneFields oneDecoder) (Query twoFields twoDecoder) =
    Query
        (\aliases ->
            oneFields aliases ++ twoFields aliases
        )
        (\aliases ->
            Json.map fn (decoder aliases)
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
            [ ( "query", Json.Encode.string (toQuery q) ) ]
        )


{-| -}
expect : (Result Http.Error data -> msg) -> Query data -> Http.Expect msg
expect toMsg (Query gql decoder) =
    Http.expectJson toMsg (decoder Set.empty)


toQuery : Query data -> String
toQuery (Query gql _) =
    let
        fields =
            gql Set.empty
    in
    fieldsToQueryString fields ""


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
            Maybe.withDefault "" maybeAlias

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

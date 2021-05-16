module GraphQL.Schema.Deprecation exposing
    ( Deprecation
    , decoder
    , isDeprecated
    )

import Json.Decode as Json

type Deprecation
    = Deprecated (Maybe String)
    | Active


decoder : Json.Decoder Deprecation
decoder =
    let
        fromBoolean : Bool -> Json.Decoder Deprecation
        fromBoolean isDeprecated_ =
            if isDeprecated_ then
                Json.map Deprecated
                    (Json.maybe (Json.field "deprecationReason" Json.string))

            else
                Json.succeed Active
    in
    Json.field "isDeprecated" Json.bool
        |> Json.andThen fromBoolean


isDeprecated : Deprecation -> Bool
isDeprecated deprecation =
    case deprecation of
        Deprecated _ ->
            True

        Active ->
            False

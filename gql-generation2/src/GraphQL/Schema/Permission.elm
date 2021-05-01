module GraphQL.Schema.Permission exposing
    ( Permission
    , decoder
    )

import Json.Decode as Json


type alias Permission =
    String


decoder : Json.Decoder (List Permission)
decoder =
    Json.list Json.string
        |> Json.at [ "directives", "requires", "permissions" ]
        |> Json.maybe
        |> Json.map (Maybe.withDefault [])

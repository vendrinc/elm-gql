module GraphQL.Schema.Union exposing (Union, decoder, Variant)

import GraphQL.Schema.Kind as Kind exposing (Kind)
import Json.Decode as Json
import Utils.Json


type alias Union =
    { name : String
    , description : Maybe String
    , variants : List Variant
    }


decoder : Json.Decoder Union
decoder =
    Json.map3 Union
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
        (Json.field "possibleTypes" (Json.list variant))



-- VARIANT


type alias Variant =
    { kind : Kind
    }


variant : Json.Decoder Variant
variant =
    Json.map Variant
        Kind.decoder

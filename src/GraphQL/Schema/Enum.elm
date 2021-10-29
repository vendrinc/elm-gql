module GraphQL.Schema.Enum exposing (Enum, decoder)

import Json.Decode as Json
import Utils.Json


type alias Enum =
    { name : String
    , description : Maybe String
    , values : List Value
    }


decoder : Json.Decoder Enum
decoder =
    Json.map3 Enum
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
        (Json.field "enumValues" (Json.list valueDecoder))


type alias Value =
    { name : String
    , description : Maybe String
    }


valueDecoder : Json.Decoder Value
valueDecoder =
    Json.map2 Value
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))

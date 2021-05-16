module GraphQL.Schema.Scalar exposing (Scalar, decoder)

import Json.Decode as Json
import Utils.Json


type alias Scalar =
    { name : String
    , description : Maybe String
    }


decoder : Json.Decoder Scalar
decoder =
    Json.map2 Scalar
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
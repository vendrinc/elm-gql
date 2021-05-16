module GraphQL.Schema.Argument exposing (Argument, decoder)

import GraphQL.Schema.Type as Type exposing (Type)
import Json.Decode as Json
import Utils.Json


type alias Argument =
    { name : String
    , description : Maybe String
    , type_ : Type
    }


decoder : Json.Decoder Argument
decoder =
    Json.map3 Argument
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
        (Json.field "type" Type.decoder)

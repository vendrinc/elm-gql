module GraphQL.Schema.Field exposing (Field, decoder)

import GraphQL.Schema.Permission as Permission exposing (Permission)
import GraphQL.Schema.Type as Type exposing (Type)
import Json.Decode as Json
import Utils.Json


type alias Field =
    { name : String
    , description : Maybe String
    , type_ : Type
    , permissions : List Permission
    }


decoder : Json.Decoder Field
decoder =
    Json.map4 Field
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
        (Json.field "type" Type.decoder)
        Permission.decoder

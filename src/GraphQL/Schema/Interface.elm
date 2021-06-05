module GraphQL.Schema.Interface exposing (Interface, decoder)

import GraphQL.Schema.Field as Field exposing (Field)
import GraphQL.Schema.Kind as Kind exposing (Kind)
import Json.Decode as Json


type alias Interface =
    { name : String
    , description : Maybe String
    , fields : List Field
    , implementedBy : List Kind
    }


decoder : Json.Decoder Interface
decoder =
    Json.map4 Interface
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Json.string))
        (Json.field "fields" (Json.list Field.decoder))
        (Json.field "possibleTypes" (Json.list Kind.decoder))
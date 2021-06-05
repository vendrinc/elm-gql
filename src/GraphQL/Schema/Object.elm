module GraphQL.Schema.Object exposing (Object, decoder)

import GraphQL.Schema.Field as Field exposing (Field)
import GraphQL.Schema.Kind as Kind exposing (Kind)
import Json.Decode as Json
import Utils.Json


type alias Object =
    { name : String
    , description : Maybe String
    , fields : List Field
    , interfaces : List Kind
    }


decoder : Json.Decoder Object
decoder =
    Json.map4 Object
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
        (Json.field "fields" (Json.list Field.decoder))
        (Json.field "interfaces" (Json.list interface))

interface : Json.Decoder Kind
interface =
    Json.field "name" Json.string
        |> Json.map Kind.Interface

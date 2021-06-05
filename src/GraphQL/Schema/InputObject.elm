module GraphQL.Schema.InputObject exposing (InputObject, decoder)

import GraphQL.Schema.Field as Field exposing (Field)
import GraphQL.Schema.Kind exposing (Kind)
import Json.Decode as Json
import Utils.Json


type alias InputObject =
    { name : String
    , description : Maybe String
    , fields : List Field
    }


decoder : Json.Decoder InputObject
decoder =
    Json.map3 InputObject
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
        (Json.field "inputFields" (Json.list Field.decoder))
module GraphQL.Decode exposing (field, versionedField, andMap)

{-|

@docs field, versionedField, andMap

-}

import Dict exposing (Dict)
import GraphQL.Engine
import Json.Decode
import Set


versionedField :
    Int
    -> String
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
versionedField int name new build =
    Json.Decode.map2
        (\a fn -> fn a)
        (Json.Decode.field (GraphQL.Engine.versionedName int name) new)
        build


field :
    String
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
field name new build =
    Json.Decode.map2
        (\a fn -> fn a)
        (Json.Decode.field name new)
        build


andMap :
    Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
andMap new build =
    Json.Decode.map2
        (\a fn -> fn a)
        new
        build

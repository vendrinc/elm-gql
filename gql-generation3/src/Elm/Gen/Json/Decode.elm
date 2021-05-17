module Elm.Gen.Json.Decode exposing (..)

import Elm


moduleName : Elm.Module
moduleName =
    Elm.moduleName [ "Json", "Decode" ]


string : Elm.Expression
string =
    Elm.valueFrom moduleName "string"

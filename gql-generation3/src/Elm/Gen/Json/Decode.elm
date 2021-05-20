module Elm.Gen.Json.Decode exposing (..)

import Elm



moduleName : Elm.Module
moduleName =
    Elm.moduleName [ "Json", "Decode" ]


string : Elm.Expression
string =
    Elm.valueFrom moduleName "string"


andThen : Elm.Expression
andThen =
    Elm.valueFrom moduleName "andThen"


succeed : Elm.Expression
succeed =
    Elm.valueFrom moduleName "succeed"


fail : Elm.Expression
fail =
    Elm.valueFrom moduleName "fail"

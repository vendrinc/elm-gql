module Elm.Gen.Json.Decode exposing (..)

import Elm
import Elm.Let exposing (Declaration)


moduleName : Elm.Module
moduleName =
    Elm.moduleName [ "Json", "Decode" ]


string : ( Elm.Module, String )
string =
    ( moduleName, "string" )


andThen : ( Elm.Module, String )
andThen =
    ( moduleName, "andThen" )


succeed : ( Elm.Module, String )
succeed =
    ( moduleName, "succeed" )


fail : ( Elm.Module, String )
fail =
    ( moduleName, "fail" )

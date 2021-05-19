module Utils.ElmAux exposing (..)

import Elm exposing (moduleName)


apply : ( Elm.Module, String ) -> List Elm.Expression -> Elm.Expression
apply ( moduleName, name ) args =
    Elm.applyFrom moduleName name args


pipe : Elm.Expression -> ( Elm.Module, String ) -> Elm.Expression
pipe exp ( moduleName, name ) =
    exp
        |> Elm.pipe (Elm.valueFrom moduleName name)

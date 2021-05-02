module Codegen.Common exposing (..)

import Elm.CodeGen as Elm


type alias File =
    { name : Elm.ModuleName
    , file : Elm.File
    }

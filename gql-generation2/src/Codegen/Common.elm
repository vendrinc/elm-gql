module Codegen.Common exposing (File, modules)

import Elm.CodeGen as Elm


modules =
    { decode =
        { fqName = [ "Json", "Decode" ]
        , name = [ "Decode" ]
        , import_ = Elm.importStmt [ "Json", "Decode" ] (Just [ "Decode" ]) (Just ([ Elm.funExpose "Decoder" ] |> Elm.exposeExplicit))
        }
    }


type alias File =
    { name : Elm.ModuleName
    , file : Elm.File
    }

module Codegen.ElmCodegenUtil exposing (..)

import Elm.CodeGen as Elm


mergeLinkage : Elm.Linkage -> Elm.Linkage -> Elm.Linkage
mergeLinkage l1 l2 =
    Elm.combineLinkage [ l1, l2 ]

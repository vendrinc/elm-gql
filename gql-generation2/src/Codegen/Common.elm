module Codegen.Common exposing (File, gqlTypeToElmTypeAnnotation, modules)

import Elm.CodeGen as Elm
import GraphQL.Schema.Type exposing (Type(..))
import Json.Decode exposing (nullable)


moduleEngine =
    [ "GraphQL", "Engine" ]


moduleEngineArgs =
    moduleEngine ++ [ "args" ]


moduleJson =
    [ "Json" ]


modules =
    { json =
        { fns =
            { maybe = Elm.fqFun moduleJson "maybe"
            }
        }
    , decode =
        { fqName = [ "Json", "Decode" ]
        , name = [ "Decode" ]
        , import_ = Elm.importStmt [ "Json", "Decode" ] (Just [ "Decode" ]) (Just ([ Elm.funExpose "Decoder" ] |> Elm.exposeExplicit))
        }
    , engine =
        { fqName = moduleEngine
        , import_ = Elm.importStmt moduleEngine Nothing Nothing
        , fns =
            { query = Elm.fqFun moduleEngine "query"
            }
        , args =
            { fqName = moduleEngineArgs
            , import_ = Elm.importStmt moduleEngineArgs Nothing Nothing
            , fns =
                { scalar = Elm.fqFun moduleEngineArgs "scalar"
                , enum = Elm.fqFun moduleEngineArgs "enum"
                , input = Elm.fqFun moduleEngineArgs "input"
                }
            }
        }
    , scalar =
        { codecs =
            { fqName = [ "Scalar", "codecs" ]
            , import_ = Elm.importStmt [ "Scalar", "codecs" ] Nothing Nothing
            }
        }
    }


type alias File =
    { name : Elm.ModuleName
    , file : Elm.File
    }


gqlTypeToElmTypeAnnotation : GraphQL.Schema.Type.Type -> Maybe (List Elm.TypeAnnotation) -> Elm.TypeAnnotation
gqlTypeToElmTypeAnnotation gqlType maybeAppliedToTypes =
    let
        appliedToTypes =
            Maybe.withDefault [] maybeAppliedToTypes
    in
    case gqlType of
        Scalar scalarName ->
            Elm.fqTyped [ "TnGql", "Scalar" ] scalarName appliedToTypes

        InputObject inputObjectName ->
            Elm.fqTyped [ "TnGql", "InputObject" ] inputObjectName appliedToTypes

        Object objectName ->
            Elm.fqTyped [ "TnGql", "Object" ] objectName appliedToTypes

        Enum enumName ->
            Elm.fqTyped [ "TnGql", "Enum" ] enumName appliedToTypes

        Union unionName ->
            Elm.fqTyped [ "TnGql", "Union" ] unionName appliedToTypes

        Interface interfaceName ->
            Elm.fqTyped [ "TnGql", "Interface" ] interfaceName appliedToTypes

        List_ listElementType ->
            Elm.typed "List" [ gqlTypeToElmTypeAnnotation listElementType maybeAppliedToTypes ]

        Nullable nonNullType ->
            Elm.maybeAnn (gqlTypeToElmTypeAnnotation nonNullType maybeAppliedToTypes)

module Codegen.Common exposing (File, gqlTypeToElmTypeAnnotation, modules)

import Elm.CodeGen as Elm
import GraphQL.Schema.Type exposing (Type(..))


moduleEngine : Elm.ModuleName
moduleEngine =
    [ "GraphQL", "Engine" ]


moduleEngineArgs : Elm.ModuleName
moduleEngineArgs =
    moduleEngine ++ [ "args" ]


moduleJson : Elm.ModuleName
moduleJson =
    [ "Json" ]


modules =
    { json =
        { fns =
            { maybe = Elm.fqFun moduleJson "maybe"
            }
        }
    , codec =
        { fns =
            { decoder = Elm.fqFun [ "Codec" ] "decoder"
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
            , field = Elm.fqFun moduleEngine "field"
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
        { import_ = Elm.importStmt [ "Scalar" ] Nothing Nothing
        , exports =
            { codec = Elm.fqVal [ "Scalar" ] "codecs"
            }
        }
    }


type alias File =
    { name : Elm.ModuleName
    , file : Elm.File
    }


gqlTypeToElmTypeAnnotation : GraphQL.Schema.Type.Type -> Maybe (List Elm.TypeAnnotation) -> ( Elm.TypeAnnotation, Elm.Linkage )
gqlTypeToElmTypeAnnotation gqlType maybeAppliedToTypes =
    let
        linkage =
            Elm.emptyLinkage

        appliedToTypes =
            Maybe.withDefault [] maybeAppliedToTypes
    in
    case gqlType of
        Scalar scalarName ->
            ( Elm.fqTyped [ "TnGql", "Scalar" ] scalarName appliedToTypes, linkage |> Elm.addImport (Elm.importStmt [ "TnGql", "Scalar" ] Nothing Nothing) )

        InputObject inputObjectName ->
            ( Elm.fqTyped [ "TnGql", "InputObject" ] inputObjectName appliedToTypes, linkage |> Elm.addImport (Elm.importStmt [ "TnGql", "InputObject", inputObjectName ] Nothing Nothing) )

        Object objectName ->
            ( Elm.fqTyped [ "TnGql", "Object" ] objectName appliedToTypes, linkage |> Elm.addImport (Elm.importStmt [ "TnGql", "Object", objectName ] Nothing Nothing) )

        Enum enumName ->
            ( Elm.fqTyped [ "TnGql", "Enum" ] enumName appliedToTypes, linkage |> Elm.addImport (Elm.importStmt [ "TnGql", "Enum", enumName ] Nothing Nothing) )

        Union unionName ->
            ( Elm.fqTyped [ "TnGql", "Union" ] unionName appliedToTypes, linkage |> Elm.addImport (Elm.importStmt [ "TnGql", "Union", unionName ] Nothing Nothing) )

        Interface interfaceName ->
            ( Elm.fqTyped [ "TnGql", "Interface" ] interfaceName appliedToTypes, linkage |> Elm.addImport (Elm.importStmt [ "TnGql", "Interface", interfaceName ] Nothing Nothing) )

        List_ listElementType ->
            let
                ( innerType, linkage_ ) =
                    gqlTypeToElmTypeAnnotation listElementType maybeAppliedToTypes
            in
            ( Elm.typed "List" [ innerType ], linkage_ )

        Nullable nonNullType ->
            let
                ( innerType, linkage_ ) =
                    gqlTypeToElmTypeAnnotation nonNullType maybeAppliedToTypes
            in
            ( Elm.maybeAnn innerType, linkage_ )

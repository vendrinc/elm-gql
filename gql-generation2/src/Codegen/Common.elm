module Codegen.Common exposing (File, gqlTypeToElmTypeAnnotation, modules)

import Elm.CodeGen as Elm
import GraphQL.Schema.Type exposing (Type(..))
import Json.Decode exposing (nullable)


modules =
    { decode =
        { fqName = [ "Json", "Decode" ]
        , name = [ "Decode" ]
        , import_ = Elm.importStmt [ "Json", "Decode" ] (Just [ "Decode" ]) (Just ([ Elm.funExpose "Decoder" ] |> Elm.exposeExplicit))
        }
    , engine =
        { fqName = [ "GraphQL", "Engine" ]
        , import_ = Elm.importStmt [ "GraphQL", "Engine" ] Nothing Nothing
        , args =
            { fqName = [ "GraphQL", "Engine", "args" ]
            , import_ = Elm.importStmt [ "GraphQL", "Engine", "args" ] Nothing Nothing
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

        gqlTypeToElmTypeAnnotatio_ nullable gqlType_ =
            let
                innerType =
                    case gqlType_ of
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
                            Elm.typed "List" [ gqlTypeToElmTypeAnnotatio_ True listElementType ]

                        Non_Null nonNullType ->
                            gqlTypeToElmTypeAnnotatio_ False nonNullType
            in
            if nullable then
                Elm.maybeAnn innerType

            else
                innerType
    in
    case gqlType of
        Non_Null gqlType_ ->
            gqlTypeToElmTypeAnnotatio_ False gqlType_

        _ ->
            gqlTypeToElmTypeAnnotatio_ True gqlType

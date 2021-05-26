module Generate.Common exposing (..)

-- import Codegen.Common as Common

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as GenEngine
import Elm.Pattern
import GraphQL.Schema
import GraphQL.Schema.Object
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String
import Utils.String


gqlTypeToElmTypeAnnotation : GraphQL.Schema.Type.Type -> Maybe (List Elm.Annotation.Annotation) -> Elm.Annotation.Annotation
gqlTypeToElmTypeAnnotation gqlType maybeAppliedToTypes =
    let
        appliedToTypes =
            Maybe.withDefault [] maybeAppliedToTypes
    in
    case gqlType of
        Scalar scalarName ->
            case String.toLower scalarName of
                "string" ->
                    Elm.Annotation.string

                "int" ->
                    Elm.Annotation.int

                "float" ->
                    Elm.Annotation.float

                "boolean" ->
                    Elm.Annotation.bool

                "id" ->
                    Elm.Annotation.namedWith (Elm.moduleName [ "GraphQL", "Engine" ]) "Id" appliedToTypes

                _ ->
                    Elm.Annotation.namedWith (Elm.moduleName [ "Scalar" ])
                        (Utils.String.formatTypename scalarName)
                        appliedToTypes

        Enum enumName ->
            Elm.Annotation.namedWith (Elm.moduleName [ "TnGql", "Enum" ]) enumName appliedToTypes

        List_ listElementType ->
            let
                innerType =
                    gqlTypeToElmTypeAnnotation listElementType maybeAppliedToTypes
            in
            Elm.Annotation.list innerType

        Nullable nonNullType ->
            let
                innerType =
                    gqlTypeToElmTypeAnnotation nonNullType maybeAppliedToTypes
            in
            Elm.Annotation.maybe innerType

        InputObject inputObjectName ->
            Elm.Annotation.namedWith (Elm.moduleName [ "TnGql", "InputObject" ]) inputObjectName appliedToTypes

        Object objectName ->
            Elm.Annotation.namedWith (Elm.moduleName [ "TnGql", "Object" ]) objectName appliedToTypes

        Union unionName ->
            Elm.Annotation.namedWith (Elm.moduleName [ "TnGql", "Union" ]) unionName appliedToTypes

        Interface interfaceName ->
            Elm.Annotation.namedWith (Elm.moduleName [ "TnGql", "Interface" ]) interfaceName appliedToTypes

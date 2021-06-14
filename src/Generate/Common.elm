module Generate.Common exposing (..)

import Elm
import Elm.Annotation
import GraphQL.Schema.Type exposing (Type(..))
import Utils.String


gqlTypeToElmTypeAnnotation : String -> GraphQL.Schema.Type.Type -> Maybe (List Elm.Annotation.Annotation) -> Elm.Annotation.Annotation
gqlTypeToElmTypeAnnotation namespace gqlType maybeAppliedToTypes =
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
            Elm.Annotation.namedWith (Elm.moduleName [ namespace, "Enum", enumName ]) enumName appliedToTypes

        List_ listElementType ->
            let
                innerType =
                    gqlTypeToElmTypeAnnotation namespace listElementType maybeAppliedToTypes
            in
            Elm.Annotation.list innerType

        Nullable nonNullType ->
            let
                innerType =
                    gqlTypeToElmTypeAnnotation namespace nonNullType maybeAppliedToTypes
            in
            Elm.Annotation.maybe innerType

        InputObject inputObjectName ->
            Elm.Annotation.namedWith (Elm.moduleName [ namespace, "InputObject" ]) inputObjectName appliedToTypes

        Object objectName ->
            Elm.Annotation.namedWith (Elm.moduleName [ namespace, "Object" ]) objectName appliedToTypes

        Union unionName ->
            Elm.Annotation.namedWith (Elm.moduleName [ namespace, "Union" ]) unionName appliedToTypes

        Interface interfaceName ->
            Elm.Annotation.namedWith (Elm.moduleName [ namespace, "Interface" ]) interfaceName appliedToTypes

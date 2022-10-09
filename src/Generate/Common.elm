module Generate.Common exposing (..)

import Elm.Annotation
import GraphQL.Schema exposing (Namespace)
import Utils.String


modules =
    { enum =
        \namespace enumName ->
            [ namespace.enums
            , "Enum"
            , Utils.String.formatTypename enumName
            ]
    , enumSourceModule =
        \namespace enumName ->
            [ namespace.namespace
            , "Enum"
            , Utils.String.formatTypename enumName
            ]
    , query =
        \namespace queryName ->
            [ namespace
            , "Queries"
            , Utils.String.formatTypename queryName
            ]
    , mutation =
        \namespace mutationName ->
            [ namespace
            , "Mutations"
            , Utils.String.formatTypename mutationName
            ]
    , input =
        \namespace name ->
            [ namespace
            , Utils.String.formatTypename name
            ]
    }


selection : String -> String -> Elm.Annotation.Annotation -> Elm.Annotation.Annotation
selection namespace name data =
    Elm.Annotation.namedWith
        [ namespace ]
        name
        [ data ]


selectionLocal : String -> String -> Elm.Annotation.Annotation -> Elm.Annotation.Annotation
selectionLocal namespace name data =
    Elm.Annotation.namedWith
        []
        name
        [ data ]


ref : Namespace -> String -> Elm.Annotation.Annotation
ref namespace name =
    Elm.Annotation.named [ namespace.namespace ] name


local : Namespace -> String -> Elm.Annotation.Annotation
local namespace name =
    Elm.Annotation.named [] name


gqlTypeToElmTypeAnnotation : Namespace -> GraphQL.Schema.Type -> Maybe (List Elm.Annotation.Annotation) -> Elm.Annotation.Annotation
gqlTypeToElmTypeAnnotation namespace gqlType maybeAppliedToTypes =
    let
        appliedToTypes =
            Maybe.withDefault [] maybeAppliedToTypes
    in
    case gqlType of
        GraphQL.Schema.Scalar scalarName ->
            case String.toLower scalarName of
                "string" ->
                    Elm.Annotation.string

                "int" ->
                    Elm.Annotation.int

                "float" ->
                    Elm.Annotation.float

                "boolean" ->
                    Elm.Annotation.bool

                _ ->
                    Elm.Annotation.namedWith
                        [ namespace.namespace
                        , "Scalar"
                        ]
                        (Utils.String.formatScalar scalarName)
                        appliedToTypes

        GraphQL.Schema.Enum enumName ->
            Elm.Annotation.namedWith [ namespace.enums, "Enum", enumName ] enumName appliedToTypes

        GraphQL.Schema.List_ listElementType ->
            let
                innerType =
                    gqlTypeToElmTypeAnnotation namespace listElementType maybeAppliedToTypes
            in
            Elm.Annotation.list innerType

        GraphQL.Schema.Nullable nonNullType ->
            let
                innerType =
                    gqlTypeToElmTypeAnnotation namespace nonNullType maybeAppliedToTypes
            in
            Elm.Annotation.maybe innerType

        GraphQL.Schema.InputObject inputObjectName ->
            ref namespace inputObjectName

        GraphQL.Schema.Object objectName ->
            ref namespace objectName

        GraphQL.Schema.Union unionName ->
            ref namespace unionName

        GraphQL.Schema.Interface interfaceName ->
            ref namespace interfaceName


localAnnotation : Namespace -> GraphQL.Schema.Type -> Maybe (List Elm.Annotation.Annotation) -> Elm.Annotation.Annotation
localAnnotation namespace gqlType maybeAppliedToTypes =
    let
        appliedToTypes =
            Maybe.withDefault [] maybeAppliedToTypes
    in
    case gqlType of
        GraphQL.Schema.Scalar scalarName ->
            case String.toLower scalarName of
                "string" ->
                    Elm.Annotation.string

                "int" ->
                    Elm.Annotation.int

                "float" ->
                    Elm.Annotation.float

                "boolean" ->
                    Elm.Annotation.bool

                _ ->
                    Elm.Annotation.namedWith
                        [ namespace.namespace
                        , "Scalar"
                        ]
                        (Utils.String.formatScalar scalarName)
                        appliedToTypes

        GraphQL.Schema.Enum enumName ->
            Elm.Annotation.namedWith [ namespace.enums, "Enum", enumName ] enumName appliedToTypes

        GraphQL.Schema.List_ listElementType ->
            let
                innerType =
                    gqlTypeToElmTypeAnnotation namespace listElementType maybeAppliedToTypes
            in
            Elm.Annotation.list innerType

        GraphQL.Schema.Nullable nonNullType ->
            let
                innerType =
                    gqlTypeToElmTypeAnnotation namespace nonNullType maybeAppliedToTypes
            in
            Elm.Annotation.maybe innerType

        GraphQL.Schema.InputObject inputObjectName ->
            local namespace inputObjectName

        GraphQL.Schema.Object objectName ->
            local namespace objectName

        GraphQL.Schema.Union unionName ->
            local namespace unionName

        GraphQL.Schema.Interface interfaceName ->
            local namespace interfaceName

module Generate.Common exposing (..)

import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import GraphQL.Schema.Type exposing (Type(..))
import Utils.String

modules =
    { enum = 
        \namespace enumName ->
            [ namespace
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


ref namespace name =
    Elm.Annotation.named [ namespace ] name


local namespace name =
    Elm.Annotation.named [] name


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

                _ ->
                    Elm.Annotation.namedWith ( [ "Scalar" ])
                        (Utils.String.formatScalar scalarName)
                        appliedToTypes

        Enum enumName ->
            Elm.Annotation.namedWith ( [ namespace, "Enum", enumName ]) enumName appliedToTypes

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
            ref namespace inputObjectName

        Object objectName ->
            ref namespace objectName

        Union unionName ->
            ref namespace unionName

        Interface interfaceName ->
            ref namespace interfaceName


localAnnotation : String -> GraphQL.Schema.Type.Type -> Maybe (List Elm.Annotation.Annotation) -> Elm.Annotation.Annotation
localAnnotation namespace gqlType maybeAppliedToTypes =
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

                _ ->
                    Elm.Annotation.namedWith ( [ "Scalar" ])
                        (Utils.String.formatScalar scalarName)
                        appliedToTypes

        Enum enumName ->
            Elm.Annotation.namedWith ( [ namespace, "Enum", enumName ]) enumName appliedToTypes

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
            local namespace inputObjectName

        Object objectName ->
            local namespace objectName

        Union unionName ->
            local namespace unionName

        Interface interfaceName ->
            local namespace interfaceName

module Generate.Objects exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation as Type
import Gen.GraphQL.Engine as Engine
import Gen.Json.Decode as Json
import Generate.Common as Common
import Generate.Scalar
import GraphQL.Schema exposing (Namespace)
import Utils.String


valueFrom mod name =
    Elm.value
        { importFrom = mod
        , name = name
        , annotation = Nothing
        }


objectToModule :
    Namespace
    -- this can be objects or interfaces
    -> { a | fields : List GraphQL.Schema.Field, name : String }
    -> List Elm.Declaration
objectToModule namespace object =
    let
        fieldTypesAndImpls =
            object.fields
                |> List.foldl
                    (\field accDecls ->
                        let
                            implemented =
                                implementField
                                    namespace
                                    object.name
                                    field.name
                                    field.type_
                                    (GraphQL.Schema.getWrap field.type_)
                        in
                        ( field.name, implemented.annotation, implemented.expression ) :: accDecls
                    )
                    []

        objectTypeAnnotation =
            fieldTypesAndImpls
                |> List.map
                    (\( name, typeAnnotation, _ ) ->
                        ( formatName name, typeAnnotation )
                    )
                |> Type.record

        objectImplementation =
            fieldTypesAndImpls
                |> List.map (\( name, _, expression ) -> ( formatName name, expression ))
                |> Elm.record
    in
    [ Elm.alias object.name
        (Engine.annotation_.selection
            (Type.named [ namespace.namespace, "Meta", "Id" ] object.name)
            (Type.var "data")
        )
    , Elm.declaration (Utils.String.formatValue object.name)
        (objectImplementation
            |> Elm.withType objectTypeAnnotation
        )
    ]


formatName : String -> String
formatName str =
    case str of
        "_" ->
            "underscore"

        _ ->
            str


implementField :
    Namespace
    -> String
    -> String
    -> GraphQL.Schema.Type
    -> GraphQL.Schema.Wrapped
    ->
        { expression : Elm.Expression
        , annotation : Type.Annotation
        }
implementField namespace objectName fieldName fieldType wrapped =
    case fieldType of
        GraphQL.Schema.Nullable newType ->
            implementField namespace objectName fieldName newType wrapped

        GraphQL.Schema.List_ newType ->
            implementField namespace objectName fieldName newType wrapped

        GraphQL.Schema.Scalar scalarName ->
            let
                signature =
                    fieldSignature namespace objectName wrapped fieldType
            in
            { expression =
                Engine.field
                    fieldName
                    scalarName
                    (Generate.Scalar.decode namespace scalarName wrapped)
            , annotation = signature.annotation
            }

        GraphQL.Schema.Enum enumName ->
            let
                signature =
                    fieldSignature namespace objectName wrapped fieldType
            in
            { expression =
                Engine.field
                    fieldName
                    enumName
                    (valueFrom [ namespace.enums, "Enum", enumName ] "decoder"
                        |> decodeWrapper wrapped
                    )
            , annotation = signature.annotation
            }

        GraphQL.Schema.Object nestedObjectName ->
            { expression =
                Elm.fn
                    ( "selection_"
                    , Common.selectionLocal namespace.namespace
                        nestedObjectName
                        (Type.var "data")
                        |> Just
                    )
                    (\sel ->
                        Engine.object
                            fieldName
                            (wrapExpression wrapped sel)
                    )
            , annotation =
                Type.function
                    [ Common.selectionLocal namespace.namespace
                        nestedObjectName
                        (Type.var "data")
                    ]
                    (Common.selectionLocal namespace.namespace
                        objectName
                        (wrapAnnotation wrapped (Type.var "data"))
                    )
            }

        GraphQL.Schema.Interface interfaceName ->
            { expression =
                Elm.fn
                    ( "selection_"
                    , Just
                        (Common.selectionLocal namespace.namespace
                            interfaceName
                            (Type.var "data")
                        )
                    )
                    (\sel ->
                        Engine.object
                            fieldName
                            (wrapExpression wrapped sel)
                    )
            , annotation =
                Type.function
                    [ Common.selectionLocal namespace.namespace
                        interfaceName
                        (Type.var "data")
                    ]
                    (Common.selectionLocal namespace.namespace
                        objectName
                        (wrapAnnotation wrapped (Type.var "data"))
                    )
            }

        GraphQL.Schema.InputObject inputName ->
            let
                signature =
                    fieldSignature namespace objectName wrapped fieldType
            in
            { expression = Elm.string ("unimplemented: " ++ inputName)
            , annotation = signature.annotation
            }

        GraphQL.Schema.Union unionName ->
            { expression =
                Elm.fn
                    ( "union_"
                    , Common.selectionLocal namespace.namespace
                        unionName
                        (Type.var "data")
                        |> Just
                    )
                    (\un ->
                        Engine.object
                            fieldName
                            (wrapExpression wrapped un)
                    )
            , annotation =
                Type.function
                    [ Common.selectionLocal namespace.namespace
                        unionName
                        (Type.var "data")
                    ]
                    (Common.selectionLocal namespace.namespace
                        objectName
                        (wrapAnnotation wrapped (Type.var "data"))
                    )
            }


wrapAnnotation : GraphQL.Schema.Wrapped -> Type.Annotation -> Type.Annotation
wrapAnnotation wrap signature =
    case wrap of
        GraphQL.Schema.UnwrappedValue ->
            signature

        GraphQL.Schema.InList inner ->
            Type.list (wrapAnnotation inner signature)

        GraphQL.Schema.InMaybe inner ->
            Type.maybe (wrapAnnotation inner signature)


wrapExpression : GraphQL.Schema.Wrapped -> Elm.Expression -> Elm.Expression
wrapExpression wrap exp =
    case wrap of
        GraphQL.Schema.UnwrappedValue ->
            exp

        GraphQL.Schema.InList inner ->
            Engine.list
                (wrapExpression inner exp)

        GraphQL.Schema.InMaybe inner ->
            Engine.nullable
                (wrapExpression inner exp)


fieldSignature :
    Namespace
    -> String
    -> GraphQL.Schema.Wrapped
    -> GraphQL.Schema.Type
    ->
        { annotation : Type.Annotation
        }
fieldSignature namespace objectName wrapped fieldType =
    let
        dataType =
            Common.localAnnotation namespace fieldType Nothing
                |> wrapAnnotation wrapped

        typeAnnotation =
            Common.selectionLocal namespace.namespace
                objectName
                dataType
    in
    { annotation = typeAnnotation
    }


decodeWrapper : GraphQL.Schema.Wrapped -> Elm.Expression -> Elm.Expression
decodeWrapper wrap exp =
    case wrap of
        GraphQL.Schema.UnwrappedValue ->
            exp

        GraphQL.Schema.InList inner ->
            Json.list
                (decodeWrapper inner exp)

        GraphQL.Schema.InMaybe inner ->
            Engine.decodeNullable
                (decodeWrapper inner exp)


generateFiles : Namespace -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace graphQLSchema =
    let
        objects =
            graphQLSchema.objects
                |> Dict.values

        interfaces =
            graphQLSchema.interfaces
                |> Dict.values

        renderedObjects =
            List.concatMap (objectToModule namespace) objects
                ++ List.concatMap (objectToModule namespace) interfaces

        phantomTypeDeclarations =
            objects
                |> List.map
                    .name

        unionTypeDeclarations =
            graphQLSchema.unions
                |> Dict.toList
                |> List.map
                    (Tuple.second >> .name)

        interfaceTypeDeclarations =
            graphQLSchema.interfaces
                |> Dict.toList
                |> List.map
                    (Tuple.second >> .name)

        names =
            phantomTypeDeclarations
                ++ unionTypeDeclarations
                ++ interfaceTypeDeclarations

        proofsAndAliases =
            List.map
                (\name ->
                    Elm.customType name [ Elm.variant name ]
                )
                names
    in
    [ Elm.file [ namespace.namespace, "Meta", "Id" ]
        proofsAndAliases
    , Elm.file [ namespace.namespace, "Object" ]
        renderedObjects
    ]

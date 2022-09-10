module Generate.Objects exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Gen.GraphQL.Engine as Engine
import Gen.Json.Decode as Json
import Generate.Common as Common
import Generate.Decode
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
    -> Elm.Declaration
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
                |> Elm.Annotation.record

        objectImplementation =
            fieldTypesAndImpls
                |> List.map (\( name, _, expression ) -> ( formatName name, expression ))
                |> Elm.record
    in
    Elm.declaration (Utils.String.formatValue object.name)
        (objectImplementation
            |> Elm.withType objectTypeAnnotation
        )


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
        , annotation : Elm.Annotation.Annotation
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
                    (Generate.Decode.scalar scalarName wrapped)
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
                        (Elm.Annotation.var "data")
                        |> Just
                    )
                    (\sel ->
                        Engine.object
                            fieldName
                            (wrapExpression wrapped sel)
                    )
            , annotation =
                Elm.Annotation.function
                    [ Common.selectionLocal namespace.namespace
                        nestedObjectName
                        (Elm.Annotation.var "data")
                    ]
                    (Common.selectionLocal namespace.namespace
                        objectName
                        (wrapAnnotation wrapped (Elm.Annotation.var "data"))
                    )
            }

        GraphQL.Schema.Interface interfaceName ->
            { expression =
                Elm.fn
                    ( "selection_"
                    , Just
                        (Common.selectionLocal namespace.namespace
                            interfaceName
                            (Elm.Annotation.var "data")
                        )
                    )
                    (\sel ->
                        Engine.object
                            fieldName
                            (wrapExpression wrapped sel)
                    )
            , annotation =
                Elm.Annotation.function
                    [ Common.selectionLocal namespace.namespace
                        interfaceName
                        (Elm.Annotation.var "data")
                    ]
                    (Common.selectionLocal namespace.namespace
                        objectName
                        (wrapAnnotation wrapped (Elm.Annotation.var "data"))
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
                        (Elm.Annotation.var "data")
                        |> Just
                    )
                    (\un ->
                        Engine.object
                            fieldName
                            (wrapExpression wrapped un)
                    )
            , annotation =
                Elm.Annotation.function
                    [ Common.selectionLocal namespace.namespace
                        unionName
                        (Elm.Annotation.var "data")
                    ]
                    (Common.selectionLocal namespace.namespace
                        objectName
                        (wrapAnnotation wrapped (Elm.Annotation.var "data"))
                    )
            }


wrapAnnotation : GraphQL.Schema.Wrapped -> Elm.Annotation.Annotation -> Elm.Annotation.Annotation
wrapAnnotation wrap signature =
    case wrap of
        GraphQL.Schema.UnwrappedValue ->
            signature

        GraphQL.Schema.InList inner ->
            Elm.Annotation.list (wrapAnnotation inner signature)

        GraphQL.Schema.InMaybe inner ->
            Elm.Annotation.maybe (wrapAnnotation inner signature)


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
        { annotation : Elm.Annotation.Annotation
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
                |> Dict.toList
                |> List.map Tuple.second

        interfaces =
            graphQLSchema.interfaces
                |> Dict.toList
                |> List.map Tuple.second

        renderedObjects =
            List.map (objectToModule namespace) objects
                ++ List.map (objectToModule namespace) interfaces

        phantomTypeDeclarations =
            objects
                |> List.map
                    .name

        unionTypeDeclarations =
            graphQLSchema.unions
                |> Dict.toList
                |> List.map
                    (Tuple.second >> .name)

        inputTypeDeclarations =
            graphQLSchema.inputObjects
                |> Dict.toList
                |> List.map
                    (Tuple.second >> .name)

        interfaceTypeDeclarations =
            graphQLSchema.interfaces
                |> Dict.toList
                |> List.map
                    (Tuple.second >> .name)

        queryOptionNames =
            graphQLSchema.queries
                |> Dict.toList
                |> List.map
                    -- we add `Query` to the name here because we don't want to clash with objects of the same name.
                    -- Such as the app query vs the App object
                    (\( _, q ) ->
                        q.name ++ "_Option"
                    )

        mutationOptionNames =
            graphQLSchema.mutations
                |> Dict.toList
                |> List.map
                    -- same note as above for queries
                    (\( _, q ) ->
                        q.name ++ "_MutOption"
                    )

        names =
            phantomTypeDeclarations
                ++ unionTypeDeclarations
                ++ interfaceTypeDeclarations

        optionNames =
            queryOptionNames
                ++ mutationOptionNames

        inputHelpers =
            List.concatMap
                (\name ->
                    [ Elm.alias name
                        (Engine.annotation_.argument
                            (Elm.Annotation.named [] (name ++ "_"))
                        )
                    , Elm.customType (name ++ "_") [ Elm.variant name ]
                    ]
                )
                inputTypeDeclarations
                ++ List.map
                    (\name ->
                        Elm.customType name [ Elm.variant name ]
                    )
                    optionNames

        proofsAndAliases =
            List.concatMap
                (\name ->
                    [ Elm.alias name
                        -- [ "data" ]
                        -- NOTE, does the type variable stick around?
                        (Engine.annotation_.selection
                            (Elm.Annotation.named [] (name ++ "_"))
                            (Elm.Annotation.var "data")
                        )
                    , Elm.customType (name ++ "_") [ Elm.variant name ]
                    ]
                )
                names

        engine =
            [ Elm.alias "Operation"
                (Engine.annotation_.premade
                    (Elm.Annotation.var "data")
                )
            , Elm.declaration "map"
                Engine.values_.mapPremade
            , Elm.comment "The below is generally deprecated and shouldn't be needed!"
            , Elm.declaration "select"
                Engine.values_.select
            , Elm.declaration "with"
                Engine.values_.with
            , Elm.declaration "mapSelection"
                Engine.values_.map
            , Elm.declaration "mapSelection2"
                Engine.values_.map2
            , Elm.declaration "batch"
                Engine.values_.batch
            , Elm.declaration "recover"
                Engine.values_.recover
            , Elm.alias "Selection"
                (Engine.annotation_.selection
                    (Elm.Annotation.var "source")
                    (Elm.Annotation.var "data")
                )
            , Elm.alias "Query"
                (Engine.annotation_.selection
                    Engine.annotation_.query
                    (Elm.Annotation.var "data")
                )
            , Elm.declaration "query"
                Engine.values_.query
            , Elm.alias "Mutation"
                (Engine.annotation_.selection
                    Engine.annotation_.mutation
                    (Elm.Annotation.var "data")
                )
            , Elm.declaration "mutation"
                Engine.values_.mutation
            ]
    in
    [ Elm.file [ namespace.namespace ]
        (engine
            ++ renderedObjects
            ++ proofsAndAliases
            ++ inputHelpers
        )
    ]

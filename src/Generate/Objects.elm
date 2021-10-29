module Generate.Objects exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Json
import Elm.Pattern
import Generate.Args as Args
import Generate.Common as Common
import Generate.Decode
import Generate.Input as Input exposing (Wrapped(..))
import GraphQL.Schema
import GraphQL.Schema.Field as Field exposing (Field)
import GraphQL.Schema.Object
import GraphQL.Schema.Type exposing (Type(..))
import Utils.String


objectToModule :
    String
    -- this can be objects oir interfaces
    -> { a | fields : List Field, name : String }
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
                                    (Input.getWrap field.type_)
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
                |> List.map (\( name, _, expression ) -> Elm.field (formatName name) expression)
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
    String
    -> String
    -> String
    -> Type
    -> Wrapped
    ->
        { expression : Elm.Expression
        , annotation : Elm.Annotation.Annotation
        }
implementField namespace objectName fieldName fieldType wrapped =
    case fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            implementField namespace objectName fieldName newType wrapped

        GraphQL.Schema.Type.List_ newType ->
            implementField namespace objectName fieldName newType wrapped

        GraphQL.Schema.Type.Scalar scalarName ->
            let
                signature =
                    fieldSignature namespace objectName wrapped fieldType
            in
            { expression =
                Engine.field
                    (Elm.string fieldName)
                    (Generate.Decode.scalar scalarName wrapped)
            , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Enum enumName ->
            let
                signature =
                    fieldSignature namespace objectName wrapped fieldType
            in
            { expression =
                Engine.field
                    (Elm.string fieldName)
                    (Elm.valueFrom [ namespace, "Enum", enumName ] "decoder"
                        |> decodeWrapper wrapped
                    )
            , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Object nestedObjectName ->
            { expression =
                Elm.lambda "selection_"
                    (Common.selectionLocal namespace
                        nestedObjectName
                        (Elm.Annotation.var "data")
                    )
                    (\sel ->
                        Engine.object
                            (Elm.string fieldName)
                            (wrapExpression wrapped sel)
                    )
            , annotation =
                Elm.Annotation.function
                    [ Common.selectionLocal namespace
                        nestedObjectName
                        (Elm.Annotation.var "data")
                    ]
                    (Common.selectionLocal namespace
                        objectName
                        (wrapAnnotation wrapped (Elm.Annotation.var "data"))
                    )
            }

        GraphQL.Schema.Type.Interface interfaceName ->
            { expression =
                Elm.lambda "selection_"
                    (Common.selectionLocal namespace
                        interfaceName
                        (Elm.Annotation.var "data")
                    )
                    (\sel ->
                        Engine.object
                            (Elm.string fieldName)
                            (wrapExpression wrapped sel)
                    )
            , annotation =
                Elm.Annotation.function
                    [ Common.selectionLocal namespace
                        interfaceName
                        (Elm.Annotation.var "data")
                    ]
                    (Common.selectionLocal namespace
                        objectName
                        (wrapAnnotation wrapped (Elm.Annotation.var "data"))
                    )
            }

        GraphQL.Schema.Type.InputObject inputName ->
            let
                signature =
                    fieldSignature namespace objectName wrapped fieldType
            in
            { expression = Elm.string ("unimplemented: " ++ inputName)
            , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Union unionName ->
            { expression =
                Elm.lambda "union_"
                    (Common.selectionLocal namespace
                        unionName
                        (Elm.Annotation.var "data")
                    )
                    (\un ->
                        Engine.object
                            (Elm.string fieldName)
                            (wrapExpression wrapped un)
                    )
            , annotation =
                Elm.Annotation.function
                    [ Common.selectionLocal namespace
                        unionName
                        (Elm.Annotation.var "data")
                    ]
                    (Common.selectionLocal namespace
                        objectName
                        (wrapAnnotation wrapped (Elm.Annotation.var "data"))
                    )
            }


wrapAnnotation : Wrapped -> Elm.Annotation.Annotation -> Elm.Annotation.Annotation
wrapAnnotation wrap signature =
    case wrap of
        UnwrappedValue ->
            signature

        InList inner ->
            Elm.Annotation.list (wrapAnnotation inner signature)

        InMaybe inner ->
            Elm.Annotation.maybe (wrapAnnotation inner signature)


wrapExpression : Wrapped -> Elm.Expression -> Elm.Expression
wrapExpression wrap exp =
    case wrap of
        UnwrappedValue ->
            exp

        InList inner ->
            Engine.list
                (wrapExpression inner exp)

        InMaybe inner ->
            Engine.nullable
                (wrapExpression inner exp)


fieldSignature :
    String
    -> String
    -> Wrapped
    -> Type
    ->
        { annotation : Elm.Annotation.Annotation
        }
fieldSignature namespace objectName wrapped fieldType =
    let
        dataType =
            Common.localAnnotation namespace fieldType Nothing
                |> wrapAnnotation wrapped

        typeAnnotation =
            Common.selectionLocal namespace
                objectName
                dataType
    in
    { annotation = typeAnnotation
    }


decodeWrapper : Wrapped -> Elm.Expression -> Elm.Expression
decodeWrapper wrap exp =
    case wrap of
        UnwrappedValue ->
            exp

        InList inner ->
            Json.list
                (decodeWrapper inner exp)

        InMaybe inner ->
            Engine.decodeNullable
                (decodeWrapper inner exp)


generateFiles : String -> GraphQL.Schema.Schema -> List Elm.File
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
                        (Engine.types_.argument
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
                        (Engine.types_.selection
                            (Elm.Annotation.named [] (name ++ "_"))
                            (Elm.Annotation.var "data")
                        )
                    , Elm.customType (name ++ "_") [ Elm.variant name ]
                    ]
                )
                names

        engine =
            [ Elm.declaration "select"
                (Elm.valueFrom
                    Engine.moduleName_
                    "select"
                )
            , Elm.declaration "with"
                (Elm.valueFrom
                    Engine.moduleName_
                    "with"
                )
            , Elm.declaration "map"
                (Elm.valueFrom
                    Engine.moduleName_
                    "map"
                )
            , Elm.declaration "map2"
                (Elm.valueFrom
                    Engine.moduleName_
                    "map2"
                )
            , Elm.declaration "batch"
                (Elm.valueFrom
                    Engine.moduleName_
                    "batch"
                )
            , Elm.declaration "recover"
                (Elm.valueFrom
                    Engine.moduleName_
                    "recover"
                )
            , Elm.alias "Selection"
                -- [ "source"
                -- , "data"
                -- ]
                (Engine.types_.selection
                    (Elm.Annotation.var "source")
                    (Elm.Annotation.var "data")
                )
            , Elm.alias "Query"
                -- [ "data" ]
                (Engine.types_.selection
                    Engine.types_.query
                    (Elm.Annotation.var "data")
                )
            , Elm.declaration "query"
                (Elm.valueFrom
                    Engine.moduleName_
                    "query"
                )
            , Elm.alias "Mutation"
                -- [ "data" ]
                (Engine.types_.selection
                    Engine.types_.mutation
                    (Elm.Annotation.var "data")
                )
            , Elm.declaration "mutation"
                (Elm.valueFrom
                    Engine.moduleName_
                    "mutation"
                )
            ]
    in
    [ Elm.file [ namespace ]
        (engine
            ++ renderedObjects
            ++ proofsAndAliases
            ++ inputHelpers
        )
    ]



--:: objectFiles

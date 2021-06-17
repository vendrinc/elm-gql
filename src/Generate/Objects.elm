module Generate.Objects exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Json
import Elm.Pattern
import Generate.Common as Common
import GraphQL.Schema
import GraphQL.Schema.Object
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String
import Utils.String


objectToModule : String -> GraphQL.Schema.Object.Object -> Elm.File
objectToModule namespace object =
    let
        fieldTypesAndImpls =
            object.fields
                --|> List.filter
                --    (\field ->
                --        --List.member field.name [ "name", "slug", "id", "viewUrl", "parent" ]
                --        List.member field.name [ "parent" ]
                --    )
                |> List.foldl
                    (\field accDecls ->
                        let
                            implemented =
                                implementField
                                    namespace
                                    object.name
                                    field.name
                                    field.type_
                                    UnwrappedValue
                        in
                        ( field.name, implemented.annotation, implemented.expression ) :: accDecls
                    )
                    []

        objectTypeAnnotation =
            fieldTypesAndImpls
                |> List.map (\( name, typeAnnotation, _ ) -> ( name, typeAnnotation ))
                |> Elm.Annotation.record

        objectImplementation =
            fieldTypesAndImpls
                |> List.map (\( name, _, expression ) -> ( name, expression ))
                |> Elm.record

        objectDecl =
            Elm.declarationWith (String.decapitalize object.name) objectTypeAnnotation objectImplementation
    in
    Elm.file (Elm.moduleName [ namespace, "Object", object.name ])
        ""
        [ objectDecl |> Elm.expose
        ]


type Wrapped
    = UnwrappedValue
    | InList Wrapped
    | InMaybe Wrapped


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
            implementField namespace objectName fieldName newType (InMaybe wrapped)

        GraphQL.Schema.Type.List_ newType ->
            implementField namespace objectName fieldName newType (InList wrapped)

        GraphQL.Schema.Type.Scalar scalarName ->
            let
                signature =
                    fieldSignature namespace objectName fieldType
            in
            { expression =
                Engine.field
                    (Elm.string fieldName)
                    (decodeScalar scalarName wrapped)
            , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Enum enumName ->
            let
                signature =
                    fieldSignature namespace objectName fieldType
            in
            { expression =
                Engine.field
                    (Elm.string fieldName)
                    (Elm.valueFrom (Elm.moduleName [ namespace, "Enum", enumName ]) "decoder")
            , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Object nestedObjectName ->
            { expression =
                Elm.lambda "selection_"
                    (Engine.typeSelection.annotation
                        (Elm.Annotation.named (Elm.moduleName [ namespace, "Object" ]) nestedObjectName)
                        (Elm.Annotation.var "data")
                    )
                    (\sel ->
                        Engine.object
                            (Elm.string fieldName)
                            (wrapExpression wrapped sel)
                    )
            , annotation =
                Elm.Annotation.function
                    [ Engine.typeSelection.annotation
                        (Elm.Annotation.named (Elm.moduleName [ namespace, "Object" ]) nestedObjectName)
                        (Elm.Annotation.var "data")
                    ]
                    (Engine.typeSelection.annotation
                        (Elm.Annotation.named (Elm.moduleName [ namespace, "Object" ]) objectName)
                        (wrapAnnotation wrapped
                            (Elm.Annotation.var
                                "data"
                            )
                        )
                    )
            }

        GraphQL.Schema.Type.Interface interfaceName ->
            let
                signature =
                    fieldSignature namespace objectName fieldType
            in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
            , annotation = signature.annotation
            }

        GraphQL.Schema.Type.InputObject inputName ->
            let
                signature =
                    fieldSignature namespace objectName fieldType
            in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
            , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Union unionName ->
            { expression =
                Elm.lambda "union_"
                    (Engine.typeSelection.annotation
                        (Elm.Annotation.named (Elm.moduleName [ namespace, "Object" ]) unionName)
                        (Elm.Annotation.var
                            "data"
                        )
                    )
                    (\un ->
                        Engine.object
                            (Elm.string fieldName)
                            (wrapExpression wrapped un)
                    )
            , annotation =
                Elm.Annotation.function
                    [ Engine.typeSelection.annotation
                        (Elm.Annotation.named (Elm.moduleName [ namespace, "Object" ]) unionName)
                        (Elm.Annotation.var
                            "data"
                        )
                    ]
                    (Engine.typeSelection.annotation
                        (Elm.Annotation.named (Elm.moduleName [ namespace, "Object" ]) objectName)
                        (wrapAnnotation wrapped
                            (Elm.Annotation.var
                                "data"
                            )
                        )
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
    -> Type
    ->
        { annotation : Elm.Annotation.Annotation
        }
fieldSignature namespace objectName fieldType =
    let
        dataType =
            Common.gqlTypeToElmTypeAnnotation namespace fieldType Nothing

        typeAnnotation =
            Engine.typeSelection.annotation
                (Elm.Annotation.namedWith (Elm.moduleName [ namespace, "Object" ]) objectName [])
                dataType
    in
    { annotation = typeAnnotation
    }


decodeScalar : String -> Wrapped -> Elm.Expression
decodeScalar scalarName nullable =
    let
        lowered =
            String.toLower scalarName
    in
    case lowered of
        "string" ->
            Json.string

        "int" ->
            Json.int

        "float" ->
            Json.float

        "id" ->
            Engine.decodeId

        "boolean" ->
            Json.bool

        _ ->
            Elm.valueFrom (Elm.moduleName [ "Scalar" ]) (Utils.String.formatValue scalarName)
                |> Elm.get "decoder"


generateFiles : String -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace graphQLSchema =
    let
        objects =
            graphQLSchema.objects
                |> Dict.toList
                |> List.map Tuple.second

        --|> List.filter (\object -> object.name == "App")
        objectFiles =
            objects
                |> List.map (objectToModule namespace)

        phantomTypeDeclarations =
            objects
                |> List.map
                    (\object ->
                        Elm.customType object.name [ ( object.name, [] ) ]
                    )

        unionTypeDeclarations =
            graphQLSchema.unions
                |> Dict.toList
                |> List.map
                    (\( _, union ) ->
                        Elm.customType union.name [ ( union.name, [] ) ]
                    )

        inputTypeDeclarations =
            graphQLSchema.inputObjects
                |> Dict.toList
                |> List.map
                    (\( _, union ) ->
                        Elm.customType union.name [ ( union.name, [] ) ]
                    )

        masterObjectFile =
            Elm.file (Elm.moduleName [ namespace, "Object" ])
                "These are all the types we need to protect our API using phantom types."
                ((phantomTypeDeclarations
                    ++ unionTypeDeclarations
                    ++ inputTypeDeclarations
                 )
                    |> List.map Elm.expose
                )
    in
    masterObjectFile :: objectFiles

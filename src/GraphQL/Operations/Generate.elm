module GraphQL.Operations.Generate exposing (generate)

{-| Generate elm code from an Operations.AST
-}

import Dict
import Elm
import Elm.Annotation as Type
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Decode
import Elm.Gen.String
import Elm.Pattern as Pattern
import Generate.Input as Input
import Generate.Input.Encode
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Validate as Validate
import GraphQL.Schema
import Set
import Utils.String


type alias Namespace =
    { namespace : String
    , enums : String
    }


generate :
    { namespace : Namespace
    , schema : GraphQL.Schema.Schema
    , base : List String
    , document : Can.Document
    , path : List String
    }
    -> Result (List Validate.Error) (List Elm.File)
generate opts =
    Ok <|
        List.map (generateDefinition opts) opts.document.definitions


opTypeName : Can.OperationType -> String
opTypeName op =
    case op of
        Can.Query ->
            "Query"

        Can.Mutation ->
            "Mutation"


opValueName : Can.OperationType -> String
opValueName op =
    case op of
        Can.Query ->
            "query"

        Can.Mutation ->
            "mutation"


option =
    { annotation =
        Engine.types_.option
    , absent =
        Engine.make_.option.absent
    , null =
        Engine.make_.option.null
    , present =
        Engine.make_.option.present
    }


toArgument : Can.VariableDefinition -> GraphQL.Schema.Argument
toArgument varDef =
    -- if the declared type is required, and the schema is optional
    -- adjust the schema type to also be required for this variable defintiion
    -- This will make the generated code cleaner
    let
        adjustedSchemaType =
            case varDef.type_ of
                AST.Nullable _ ->
                    varDef.schemaType

                _ ->
                    case varDef.schemaType of
                        GraphQL.Schema.Nullable schemaType ->
                            schemaType

                        _ ->
                            varDef.schemaType
    in
    { name = Can.nameToString varDef.variable.name
    , description = Nothing
    , type_ = adjustedSchemaType
    }


generateDefinition :
    { namespace : Namespace
    , schema : GraphQL.Schema.Schema
    , base : List String
    , document : Can.Document
    , path : List String
    }
    -> Can.Definition
    -> Elm.File
generateDefinition { namespace, schema, base, document, path } ((Can.Operation op) as def) =
    let
        opName =
            Maybe.withDefault (opTypeName op.operationType)
                (Maybe.map
                    Can.nameToString
                    op.name
                )

        arguments =
            List.map toArgument op.variableDefinitions

        input =
            case op.variableDefinitions of
                [] ->
                    []

                _ ->
                    List.concat
                        [ [ Elm.comment """  Inputs """
                          , Generate.Input.Encode.toRecordInput namespace
                                schema
                                arguments
                          ]
                        , Generate.Input.Encode.toRecordOptionals namespace
                            schema
                            arguments
                        , Generate.Input.Encode.toRecordNulls arguments
                        , [ Generate.Input.Encode.toInputRecordAlias namespace schema "Input" arguments
                          ]
                        ]

        query =
            case op.variableDefinitions of
                [] ->
                    [ Elm.declaration (opValueName op.operationType)
                        (Engine.prebakedQuery
                            (Elm.string (Can.toString def))
                            (Elm.list [])
                            (generateDecoder namespace schema def)
                            |> Elm.withType
                                (Engine.types_.premade
                                    (Type.named [] opName)
                                )
                        )
                        |> Elm.exposeAndGroup "query"
                    ]

                _ ->
                    [ Elm.fn (opValueName op.operationType)
                        ( "args"
                        , Type.named [] "Input"
                        )
                        (\var ->
                            Engine.prebakedQuery
                                (Elm.string (Can.toString def))
                                (Generate.Input.Encode.fullRecordToInputObject
                                    namespace
                                    schema
                                    arguments
                                    (Elm.value "args")
                                    |> Engine.inputObjectToFieldList
                                )
                                (generateDecoder namespace schema def)
                                |> Elm.withType
                                    (Engine.types_.premade
                                        (Type.named [] opName)
                                    )
                        )
                        |> Elm.exposeAndGroup "query"
                    ]

        helpers =
            -- These are union types that are necessary
            generateResultTypes namespace schema (Set.fromList builtinNames) def

        -- auxHelpers are record alises that aren't *essential* to the return type,
        -- but are useful in some cases
        auxHelpers =
            -- generateAuxTypes namespace schema (Set.fromList builtinNames) def
            aliasedTypes namespace schema (Set.fromList builtinNames) def

        primaryResult =
            -- if we no longer want aliased versions, there's also one without aliases
            Elm.comment """ Return data """
                :: generatePrimaryResultTypeAliased namespace schema def
    in
    Elm.fileWith (base ++ path ++ [ opName ])
        { aliases = []
        , docs =
            \docs ->
                """This file is generated from a `.gql` file, likely in a nearby folder.

Please avoid modifying directly :)

This file can be regenerated by running `yarn api` or `yarn api-from-file`

""" ++ renderStandardComment docs
        }
        (input ++ primaryResult ++ helpers ++ auxHelpers ++ query ++ [ decodeHelper ])
        |> modifyFilePath (path ++ [ opName ])


modifyFilePath : List String -> { a | path : String } -> { a | path : String }
modifyFilePath pieces file =
    { file
        | path = String.join "/" pieces ++ ".elm"
    }


builtinNames : List String
builtinNames =
    [ "List"
    , "String"
    , "Maybe"
    , "Result"
    , "Bool"
    , "Float"
    , "Int"
    ]


renderStandardComment :
    List
        { group : Maybe String
        , members : List String
        }
    -> String
renderStandardComment groups =
    if List.isEmpty groups then
        ""

    else
        List.foldl
            (\grouped str ->
                str ++ "@docs " ++ String.join ", " grouped.members ++ "\n\n"
            )
            "\n\n"
            groups


andField : Can.Name -> Elm.Expression -> Elm.Expression -> Elm.Expression
andField name decoder builder =
    Elm.pipe
        builder
        (Elm.apply
            (Elm.value "field")
            [ Elm.string (Can.nameToString name)
            , decoder
            ]
        )


{-| field name fieldExpr builder
-}
decodeHelper : Elm.Declaration
decodeHelper =
    Elm.fn3 "field"
        ( "name", Type.string )
        ( "new", Decode.types_.decoder (Type.var "a") )
        ( "build", Decode.types_.decoder (Type.function [ Type.var "a" ] (Type.var "b")) )
        (\name new build ->
            build
                |> Decode.map2
                    (\_ _ ->
                        Elm.lambda2 "inner"
                            Type.unit
                            Type.unit
                            (\one two ->
                                Elm.apply two [ one ]
                            )
                    )
                    (Decode.field
                        name
                        new
                    )
                |> Elm.withType (Decode.types_.decoder (Type.var "b"))
        )


primitives : Set.Set String
primitives =
    Set.fromList
        [ "Int"
        , "String"
        , "Float"
        , "Boolean"
        , "ID"
        ]



{- RESULT DATA -}


generatePrimaryResultType : Namespace -> GraphQL.Schema.Schema -> Can.Definition -> List Elm.Declaration
generatePrimaryResultType namespace schema def =
    case def of
        Can.Operation op ->
            let
                ( _, record ) =
                    fieldsToRecord namespace schema primitives Nothing op.fields []
            in
            [ Elm.alias
                (Maybe.withDefault "Query"
                    (Maybe.map
                        Can.nameToString
                        op.name
                    )
                )
                record
                |> Elm.exposeAndGroup "necessary"
            ]


generatePrimaryResultTypeAliased : Namespace -> GraphQL.Schema.Schema -> Can.Definition -> List Elm.Declaration
generatePrimaryResultTypeAliased namespace schema def =
    case def of
        Can.Operation op ->
            let
                ( _, record ) =
                    fieldsToAliasedRecord namespace schema primitives Nothing op.fields []
            in
            [ Elm.alias
                (Maybe.withDefault "Query"
                    (Maybe.map
                        Can.nameToString
                        op.name
                    )
                )
                record
                |> Elm.exposeAndGroup "necessary"
            ]


fieldsToRecord :
    Namespace
    -> GraphQL.Schema.Schema
    -> Set.Set String
    -> Maybe String
    -> List Can.Selection
    -> List ( String, Type.Annotation )
    -> ( Set.Set String, Type.Annotation )
fieldsToRecord namespace schema knownNames maybeParent fieldList result =
    case fieldList of
        [] ->
            ( knownNames, Type.record (List.reverse result) )

        top :: remaining ->
            let
                new =
                    fieldAnnotation
                        namespace
                        schema
                        knownNames
                        maybeParent
                        top
            in
            fieldsToRecord namespace
                schema
                new.knownNames
                maybeParent
                remaining
                (( new.name, new.annotation ) :: result)


generateResultTypes : Namespace -> GraphQL.Schema.Schema -> Set.Set String -> Can.Definition -> List Elm.Declaration
generateResultTypes namespace schema usedNames def =
    case def of
        Can.Operation op ->
            generateTypesForFields (generateChildTypes namespace schema) usedNames [] op.fields
                |> Tuple.second


generateTypesForFields fn set generated fields =
    case fields of
        [] ->
            ( set, generated )

        top :: remaining ->
            let
                ( newSet, newStuff ) =
                    fn set top
            in
            generateTypesForFields fn
                newSet
                (generated ++ newStuff)
                remaining


generateAuxTypes : Namespace -> GraphQL.Schema.Schema -> Set.Set String -> Can.Definition -> List Elm.Declaration
generateAuxTypes namespace schema usedNames def =
    case def of
        Can.Operation op ->
            generateTypesForFields (generateChildAuxRecords namespace schema) usedNames [] op.fields
                |> Tuple.second


generateChildAuxRecords : Namespace -> GraphQL.Schema.Schema -> Set.Set String -> Can.Selection -> ( Set.Set String, List Elm.Declaration )
generateChildAuxRecords namespace schema knownNames sel =
    case sel of
        Can.FieldObject obj ->
            let
                ( resolvedName, knownNames2 ) =
                    resolveNewName desiredName
                        knownNames

                ( knownNames3, newDecls ) =
                    generateTypesForFields (generateChildAuxRecords namespace schema) knownNames2 [] obj.selection

                desiredName =
                    Can.nameToString obj.globalAlias

                ( finalNames, fieldResult ) =
                    fieldsToRecord namespace schema knownNames3 Nothing obj.selection []
            in
            ( finalNames
            , (Elm.alias resolvedName fieldResult
                |> Elm.expose
              )
                :: newDecls
            )

        Can.FieldUnion field ->
            generateTypesForFields (generateChildAuxRecords namespace schema) knownNames [] field.selection

        Can.UnionCase unionCase ->
            generateTypesForFields (generateChildAuxRecords namespace schema) knownNames [] unionCase.selection

        _ ->
            ( knownNames, [] )


aliasedTypes : Namespace -> GraphQL.Schema.Schema -> Set.Set String -> Can.Definition -> List Elm.Declaration
aliasedTypes namespace schema usedNames def =
    case def of
        Can.Operation op ->
            generateTypesForFields (genAliasedTypes namespace schema) usedNames [] op.fields
                |> Tuple.second


genAliasedTypes : Namespace -> GraphQL.Schema.Schema -> Set.Set String -> Can.Selection -> ( Set.Set String, List Elm.Declaration )
genAliasedTypes namespace schema knownNames sel =
    case sel of
        Can.FieldObject obj ->
            let
                ( resolvedName, knownNames2 ) =
                    resolveNewName desiredName
                        knownNames

                ( knownNames3, newDecls ) =
                    generateTypesForFields (genAliasedTypes namespace schema) knownNames2 [] obj.selection

                desiredName =
                    Can.nameToString obj.globalAlias

                ( finalNames, fieldResult ) =
                    fieldsToAliasedRecord namespace
                        schema
                        knownNames3
                        Nothing
                        obj.selection
                        []
            in
            ( finalNames
            , (Elm.alias resolvedName fieldResult
                |> Elm.expose
              )
                :: newDecls
            )

        Can.FieldUnion field ->
            generateTypesForFields (genAliasedTypes namespace schema) knownNames [] field.selection

        Can.UnionCase unionCase ->
            generateTypesForFields (genAliasedTypes namespace schema) knownNames [] unionCase.selection

        _ ->
            ( knownNames, [] )


fieldsToAliasedRecord :
    Namespace
    -> GraphQL.Schema.Schema
    -> Set.Set String
    -> Maybe String
    -> List Can.Selection
    -> List ( String, Type.Annotation )
    -> ( Set.Set String, Type.Annotation )
fieldsToAliasedRecord namespace schema knownNames maybeParent fieldList result =
    case fieldList of
        [] ->
            ( knownNames, Type.record (List.reverse result) )

        top :: remaining ->
            let
                new =
                    fieldAliasedAnnotation namespace schema knownNames maybeParent top
            in
            fieldsToAliasedRecord namespace schema new.knownNames maybeParent remaining (( new.name, new.annotation ) :: result)


fieldAliasedAnnotation :
    Namespace
    -> GraphQL.Schema.Schema
    -> Set.Set String
    -> Maybe String
    -> Can.Selection
    ->
        { name : String
        , annotation : Type.Annotation
        , knownNames : Set.Set String
        }
fieldAliasedAnnotation namespace schema knownNames parent selection =
    let
        ( desiredName, newKnownNames ) =
            getDesiredFieldName knownNames selection
    in
    case selection of
        Can.FieldObject field ->
            let
                annotation =
                    Input.wrapElmType field.wrapper
                        (Type.named
                            []
                            -- desiredName
                            (Can.nameToString field.globalAlias)
                        )
            in
            { name = desiredName
            , annotation = annotation
            , knownNames = newKnownNames
            }

        Can.FieldScalar field ->
            { name = desiredName
            , annotation =
                schemaTypeToPrefab field.type_
            , knownNames = newKnownNames
            }

        Can.FieldEnum field ->
            { name = desiredName
            , annotation =
                enumType namespace field.enumName
                    |> Input.wrapElmType field.wrapper
            , knownNames = newKnownNames
            }

        Can.UnionCase field ->
            { name = desiredName
            , annotation =
                Type.named
                    []
                    (Can.nameToString field.tag)
            , knownNames = newKnownNames
            }

        Can.FieldUnion field ->
            let
                ( desiredTypeName, newKnownNames2 ) =
                    getDesiredTypeName newKnownNames selection
            in
            case field.selection of
                [] ->
                    let
                        annotation =
                            case parent of
                                Nothing ->
                                    Type.unit

                                Just par ->
                                    getScalarType par (Can.nameToString field.name) schema
                                        |> schemaTypeToPrefab
                    in
                    { name = desiredName
                    , annotation = annotation
                    , knownNames = newKnownNames2
                    }

                sels ->
                    let
                        annotation =
                            Type.named
                                []
                                desiredTypeName
                                |> Input.wrapElmType field.wrapper
                    in
                    { name = desiredName
                    , annotation = annotation
                    , knownNames = newKnownNames2
                    }


generateChildTypes : Namespace -> GraphQL.Schema.Schema -> Set.Set String -> Can.Selection -> ( Set.Set String, List Elm.Declaration )
generateChildTypes namespace schema knownNames sel =
    case sel of
        Can.FieldObject obj ->
            -- let
            --     ( newSet, newDecls ) =
            generateTypesForFields (generateChildTypes namespace schema) knownNames [] obj.selection

        --     desiredName =
        --         Maybe.withDefault (Can.nameToString obj.name)
        --             (Maybe.map
        --                 Can.nameToString
        --                 obj.alias_
        --             )
        -- in
        -- ( Set.insert desiredName newSet
        -- , if Set.member desiredName newSet then
        --     newDecls
        --   else
        --     (Elm.alias
        --         desiredName
        --         (Type.record
        --             (List.map
        --                 (fieldAnnotation namespace schema Nothing)
        --                 obj.selection
        --             )
        --         )
        --         |> Elm.expose
        --     )
        --         :: newDecls
        -- )
        Can.FieldUnion field ->
            let
                ( desiredTypeName, newKnownNames2 ) =
                    getDesiredTypeName knownNames sel

                aliasName =
                    Maybe.map
                        Can.nameToString
                        field.alias_

                ( newSet, newDecls ) =
                    generateTypesForFields (generateChildTypes namespace schema) newKnownNames2 [] field.selection

                ( finallyKnownNames, variants ) =
                    unionVariants namespace schema newSet aliasName field.selection []
            in
            ( finallyKnownNames
            , (Elm.customType
                desiredTypeName
                variants
                |> Elm.exposeConstructorAndGroup "necessary"
              )
                :: newDecls
            )

        Can.UnionCase unionCase ->
            generateTypesForFields (generateChildTypes namespace schema) knownNames [] unionCase.selection

        _ ->
            ( knownNames, [] )


unionVariants :
    Namespace
    -> GraphQL.Schema.Schema
    -> Set.Set String
    -> Maybe String
    -> List Can.Selection
    -> List Elm.Variant
    -> ( Set.Set String, List Elm.Variant )
unionVariants namespace schema knownNames alias_ selections variants =
    case selections of
        [] ->
            ( knownNames, List.reverse variants )

        (Can.FieldScalar field) :: remain ->
            unionVariants namespace schema knownNames alias_ remain variants

        (Can.UnionCase field) :: remain ->
            let
                ( known, var ) =
                    case List.filter removeTypename field.selection of
                        [] ->
                            ( knownNames
                            , Elm.variant
                                (case alias_ of
                                    Nothing ->
                                        Can.nameToString field.tag

                                    Just prefix ->
                                        prefix ++ Can.nameToString field.tag
                                )
                            )

                        fields ->
                            let
                                ( knownNames2, record ) =
                                    fieldsToRecord
                                        namespace
                                        schema
                                        knownNames
                                        Nothing
                                        fields
                                        []
                            in
                            ( knownNames2
                            , Elm.variantWith
                                (case alias_ of
                                    Nothing ->
                                        Can.nameToString field.tag

                                    Just prefix ->
                                        prefix ++ Can.nameToString field.tag
                                )
                                [ record
                                ]
                            )
            in
            unionVariants namespace schema known alias_ remain (var :: variants)

        _ :: remain ->
            unionVariants namespace schema knownNames alias_ remain variants


removeTypename : Can.Selection -> Bool
removeTypename field =
    case field of
        Can.FieldScalar scal ->
            case scal.type_ of
                GraphQL.Schema.Scalar "typename" ->
                    False

                _ ->
                    True

        _ ->
            True


getDesiredFieldName : Set.Set String -> Can.Selection -> ( String, Set.Set String )
getDesiredFieldName knownNames selection =
    case selection of
        Can.FieldObject field ->
            let
                desired =
                    Maybe.withDefault
                        (Can.nameToString field.name)
                        (Maybe.map
                            Can.nameToString
                            field.alias_
                        )
            in
            Tuple.pair desired knownNames

        Can.FieldScalar field ->
            let
                desired =
                    Maybe.withDefault
                        (Can.nameToString field.name)
                        (Maybe.map
                            Can.nameToString
                            field.alias_
                        )
            in
            Tuple.pair desired knownNames

        Can.FieldEnum field ->
            let
                desired =
                    Maybe.withDefault
                        (Can.nameToString field.name)
                        (Maybe.map
                            Can.nameToString
                            field.alias_
                        )
            in
            Tuple.pair desired knownNames

        Can.UnionCase field ->
            let
                desired =
                    Can.nameToString field.tag
            in
            Tuple.pair desired knownNames

        Can.FieldUnion field ->
            let
                desired =
                    Maybe.withDefault
                        (Can.nameToString field.name)
                        (Maybe.map
                            Can.nameToString
                            field.alias_
                        )
            in
            Tuple.pair desired knownNames


getDesiredTypeName : Set.Set String -> Can.Selection -> ( String, Set.Set String )
getDesiredTypeName knownNames selection =
    case selection of
        Can.FieldObject field ->
            let
                desired =
                    Maybe.withDefault
                        field.object.name
                        (Maybe.map
                            Can.nameToString
                            field.alias_
                        )
            in
            Tuple.pair desired knownNames

        Can.FieldScalar field ->
            let
                desired =
                    Maybe.withDefault
                        (Can.nameToString field.name)
                        (Maybe.map
                            Can.nameToString
                            field.alias_
                        )
            in
            Tuple.pair desired knownNames

        Can.FieldEnum field ->
            let
                desired =
                    Maybe.withDefault
                        (Can.nameToString field.name)
                        (Maybe.map
                            Can.nameToString
                            field.alias_
                        )
            in
            Tuple.pair desired knownNames

        Can.UnionCase field ->
            let
                desired =
                    Can.nameToString field.tag
            in
            Tuple.pair desired knownNames

        Can.FieldUnion field ->
            let
                desired =
                    Maybe.withDefault
                        field.union.name
                        (Maybe.map
                            Can.nameToString
                            field.alias_
                        )
            in
            Tuple.pair desired knownNames


resolveNewName : String -> Set.Set String -> ( String, Set.Set String )
resolveNewName newName knownNames =
    if Set.member newName knownNames then
        resolveNewName (newName ++ "_") knownNames

    else
        ( newName, Set.insert newName knownNames )


fieldAnnotation :
    Namespace
    -> GraphQL.Schema.Schema
    -> Set.Set String
    -> Maybe String
    -> Can.Selection
    ->
        { name : String
        , annotation : Type.Annotation
        , knownNames : Set.Set String
        }
fieldAnnotation namespace schema knownNames parent selection =
    let
        ( desiredName, newKnownNames ) =
            getDesiredFieldName knownNames selection
    in
    case selection of
        Can.FieldObject field ->
            case field.selection of
                [] ->
                    let
                        annotation =
                            case parent of
                                Nothing ->
                                    Type.unit

                                Just par ->
                                    getScalarType par (Can.nameToString field.name) schema
                                        |> schemaTypeToPrefab
                    in
                    { name = desiredName
                    , annotation = annotation
                    , knownNames = newKnownNames
                    }

                sels ->
                    let
                        ( knownNames2, record ) =
                            fieldsToRecord namespace
                                schema
                                newKnownNames
                                (Just (Can.nameToString field.name))
                                field.selection
                                []

                        annotation =
                            Input.wrapElmType field.wrapper
                                record
                    in
                    { name = desiredName
                    , annotation = annotation
                    , knownNames = knownNames2
                    }

        Can.FieldScalar field ->
            { name = desiredName
            , annotation =
                schemaTypeToPrefab field.type_
            , knownNames = newKnownNames
            }

        Can.FieldEnum field ->
            { name = desiredName
            , annotation =
                enumType namespace field.enumName
                    |> Input.wrapElmType field.wrapper
            , knownNames = newKnownNames
            }

        Can.UnionCase field ->
            { name = desiredName
            , annotation =
                Type.named
                    []
                    (Can.nameToString field.tag)
            , knownNames = newKnownNames
            }

        Can.FieldUnion field ->
            let
                ( desiredTypeName, newKnownNames2 ) =
                    getDesiredTypeName newKnownNames selection
            in
            case field.selection of
                [] ->
                    let
                        annotation =
                            case parent of
                                Nothing ->
                                    Type.unit

                                Just par ->
                                    getScalarType par (Can.nameToString field.name) schema
                                        |> schemaTypeToPrefab
                    in
                    { name = desiredName
                    , annotation = annotation
                    , knownNames = newKnownNames2
                    }

                sels ->
                    let
                        annotation =
                            Type.named
                                []
                                desiredTypeName
                                |> Input.wrapElmType field.wrapper
                    in
                    { name = desiredName
                    , annotation = annotation
                    , knownNames = newKnownNames2
                    }


enumValue : Namespace -> String -> String -> Elm.Expression
enumValue namespace enumName val =
    Elm.valueFrom
        [ namespace.enums
        , "Enum"
        , Utils.String.formatTypename enumName
        ]
        val


enumType : Namespace -> String -> Type.Annotation
enumType namespace enumName =
    Type.named
        [ namespace.enums
        , "Enum"
        , Utils.String.formatTypename enumName
        ]
        enumName


schemaTypeToPrefab : GraphQL.Schema.Type -> Type.Annotation
schemaTypeToPrefab schemaType =
    case schemaType of
        GraphQL.Schema.Scalar scalarName ->
            case String.toLower scalarName of
                "string" ->
                    Type.string

                "int" ->
                    Type.int

                "float" ->
                    Type.float

                "boolean" ->
                    Type.bool

                _ ->
                    Type.namedWith [ "Scalar" ]
                        (Utils.String.formatScalar scalarName)
                        []

        GraphQL.Schema.InputObject input ->
            Type.unit

        GraphQL.Schema.Object obj ->
            Type.unit

        GraphQL.Schema.Enum name ->
            Type.unit

        GraphQL.Schema.Union name ->
            Type.unit

        GraphQL.Schema.Interface name ->
            Type.unit

        GraphQL.Schema.List_ inner ->
            Type.list (schemaTypeToPrefab inner)

        GraphQL.Schema.Nullable inner ->
            Type.maybe (schemaTypeToPrefab inner)



{- DECODER -}


generateDecoder : Namespace -> GraphQL.Schema.Schema -> Can.Definition -> Elm.Expression
generateDecoder namespace schema (Can.Operation op) =
    let
        opName =
            Maybe.withDefault "Query"
                (Maybe.map
                    Can.nameToString
                    op.name
                )
    in
    decodeFields namespace
        initIndex
        op.fields
        (Decode.succeed
            (Elm.value opName)
        )


subobjectBuilderArgs : Can.Selection -> ( Pattern.Pattern, Type.Annotation )
subobjectBuilderArgs sel =
    ( Pattern.var (Utils.String.formatValue (Can.getAliasedName sel))
    , Type.unit
    )


subobjectBuilderBody : List Can.Selection -> Elm.Expression
subobjectBuilderBody fields =
    Elm.record
        (List.map
            (\selection ->
                let
                    name =
                        Can.getAliasedName selection
                in
                Elm.field name
                    (Elm.value (Utils.String.formatValue name))
            )
            fields
        )


type Index
    = Index Int (List Int)


indexToString : Index -> String
indexToString (Index top tail) =
    String.fromInt top ++ "_" ++ String.join "_" (List.map String.fromInt tail)


initIndex : Index
initIndex =
    Index 0 []


next : Index -> Index
next (Index top total) =
    Index (top + 1) total


child : Index -> Index
child (Index top total) =
    Index 0 (top :: total)


decodeFields : Namespace -> Index -> List Can.Selection -> Elm.Expression -> Elm.Expression
decodeFields namespace index fields exp =
    case fields of
        [] ->
            exp

        ((Can.FieldObject obj) as field) :: remain ->
            decodeFields namespace
                (next index)
                remain
                (andField
                    (Can.Name (Can.getAliasedName field))
                    (Input.decodeWrapper obj.wrapper
                        (decodeFields namespace
                            (child index)
                            obj.selection
                            (Decode.succeed
                                (Elm.lambdaWith
                                    (List.map subobjectBuilderArgs obj.selection)
                                    (subobjectBuilderBody obj.selection)
                                )
                            )
                        )
                    )
                    exp
                )

        ((Can.FieldScalar scal) as field) :: remain ->
            let
                decoded =
                    andField
                        (Can.Name (Can.getAliasedName field))
                        (decodeScalarType scal.type_)
                        exp
            in
            decodeFields namespace
                (next index)
                remain
                decoded

        ((Can.FieldEnum enum) as field) :: remain ->
            let
                decoded =
                    andField
                        (Can.Name (Can.getAliasedName field))
                        (Input.decodeWrapper enum.wrapper
                            (Decode.string
                                |> Decode.andThen
                                    (\_ ->
                                        Elm.lambda "enum"
                                            Type.string
                                            (\str ->
                                                Elm.caseOf (Elm.Gen.String.toLower str)
                                                    (List.map
                                                        (\value ->
                                                            ( Pattern.string (String.toLower value.name)
                                                            , Decode.succeed
                                                                (enumValue namespace
                                                                    enum.enumName
                                                                    value.name
                                                                )
                                                            )
                                                        )
                                                        enum.values
                                                        ++ [ ( Pattern.wildcard
                                                             , Decode.fail (Elm.string "I don't recognize this enum!")
                                                             )
                                                           ]
                                                    )
                                            )
                                    )
                            )
                        )
                        exp
            in
            decodeFields namespace
                (next index)
                remain
                decoded

        ((Can.FieldUnion union) as field) :: remain ->
            decodeFields namespace
                (next index)
                remain
                (andField
                    (Can.Name (Can.getAliasedName field))
                    (Input.decodeWrapper union.wrapper
                        (decodeUnion namespace (child index) (Can.getAliasedName field) union)
                    )
                    exp
                )

        _ ->
            exp


decodeUnion : Namespace -> Index -> String -> Can.FieldUnionDetails -> Elm.Expression
decodeUnion namespace index fieldName union =
    Decode.field (Elm.string "__typename") Decode.string
        |> Decode.andThen
            (\_ ->
                Elm.lambda ("typename" ++ fieldName ++ indexToString index)
                    Type.string
                    (\typename ->
                        Elm.caseOf typename
                            (toUnionVariantPattern namespace
                                (child index)
                                union.alias_
                                union.selection
                                []
                                ++ [ ( Pattern.wildcard
                                     , Decode.fail (Elm.string "Unknown union type")
                                     )
                                   ]
                            )
                    )
            )


toUnionVariantPattern : Namespace -> Index -> Maybe Can.Name -> List Can.Selection -> List ( Pattern.Pattern, Elm.Expression ) -> List ( Pattern.Pattern, Elm.Expression )
toUnionVariantPattern namespace index maybeAlias sels patterns =
    case sels of
        [] ->
            List.reverse patterns

        (Can.UnionCase var) :: remain ->
            let
                tag =
                    Utils.String.formatTypename (Can.nameToString var.tag)

                tagTypeName =
                    case maybeAlias of
                        Nothing ->
                            Utils.String.formatTypename (Can.nameToString var.tag)

                        Just (Can.Name alias_) ->
                            Utils.String.formatTypename (alias_ ++ Can.nameToString var.tag)

                newPattern =
                    ( Pattern.string tag
                    , case List.filter removeTypename var.selection of
                        [] ->
                            Decode.succeed (Elm.value tagTypeName)

                        fields ->
                            Decode.succeed
                                (Elm.lambdaWith
                                    (List.map fieldParameters fields)
                                    (Elm.apply (Elm.value tagTypeName)
                                        [ Elm.record
                                            (List.map buildRecordFromVariantFields fields)
                                        ]
                                    )
                                )
                                |> decodeFields namespace (child index) fields
                    )
            in
            toUnionVariantPattern namespace (next index) maybeAlias remain (newPattern :: patterns)

        _ :: remain ->
            toUnionVariantPattern namespace index maybeAlias remain patterns


fieldParameters : Can.Selection -> ( Pattern.Pattern, Type.Annotation )
fieldParameters field =
    let
        name =
            Can.getAliasedName field
    in
    ( Pattern.var name, Type.unit )


buildRecordFromVariantFields : Can.Selection -> Elm.Field
buildRecordFromVariantFields field =
    let
        name =
            Can.getAliasedName field
    in
    Elm.field name (Elm.value name)


decodeScalarType : GraphQL.Schema.Type -> Elm.Expression
decodeScalarType type_ =
    case type_ of
        GraphQL.Schema.Scalar scalarName ->
            case String.toLower scalarName of
                "int" ->
                    Decode.int

                "float" ->
                    Decode.float

                "string" ->
                    Decode.string

                "boolean" ->
                    Decode.bool

                scal ->
                    Elm.valueFrom [ "Scalar" ]
                        (Utils.String.formatValue scalarName)
                        |> Elm.get "decoder"

        GraphQL.Schema.Nullable inner ->
            Decode.nullable (decodeScalarType inner)

        GraphQL.Schema.List_ inner ->
            Decode.list (decodeScalarType inner)

        _ ->
            Decode.succeed (Elm.string "DECODE UNKNOWN")


getScalarType : String -> String -> GraphQL.Schema.Schema -> GraphQL.Schema.Type
getScalarType queryName field schema =
    case Dict.get queryName schema.queries of
        Nothing ->
            case Dict.get queryName schema.objects of
                Nothing ->
                    GraphQL.Schema.Scalar (queryName ++ "." ++ field ++ "NOT AN OBJECT?!")

                Just object ->
                    let
                        found =
                            List.filter
                                (\f ->
                                    f.name == field
                                )
                                object.fields
                    in
                    case List.head found of
                        Nothing ->
                            GraphQL.Schema.Scalar "NOT FOUND?!"

                        Just foundField ->
                            foundField.type_

        Just q ->
            case q.type_ of
                GraphQL.Schema.Object objName ->
                    case Dict.get objName schema.objects of
                        Nothing ->
                            GraphQL.Schema.Scalar "WHAAT?!?!"

                        Just object ->
                            let
                                found =
                                    List.filter
                                        (\f ->
                                            f.name == field
                                        )
                                        object.fields
                            in
                            case List.head found of
                                Nothing ->
                                    GraphQL.Schema.Scalar "NOT FOUND?!"

                                Just foundField ->
                                    foundField.type_

                _ ->
                    q.type_

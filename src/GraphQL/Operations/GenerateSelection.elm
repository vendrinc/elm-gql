module GraphQL.Operations.GenerateSelection exposing (generate)

{-| Generate elm code from an Operations.AST
-}

import Dict
import Elm
import Elm.Annotation as Type
import Elm.Case
import Elm.Op
import Gen.GraphQL.Engine as Engine
import Gen.Json.Decode as Decode
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
    , document : Can.Document

    -- all the dirs between CWD and the GQL file
    , path : List String

    -- all the directories between the Elm source folder and the GQL file
    , elmBase : List String
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
        Engine.annotation_.option
    , absent =
        Engine.make_.absent
    , null =
        Engine.make_.null
    , present =
        Engine.make_.present
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
    , document : Can.Document

    -- all the dirs between CWD and the GQL file
    , path : List String

    -- all the directories between CWD and the Elm root
    , elmBase : List String
    }
    -> Can.Definition
    -> Elm.File
generateDefinition { namespace, schema, document, path, elmBase } ((Can.Operation op) as def) =
    let
        opName =
            Maybe.withDefault (opTypeName op.operationType)
                (Maybe.map
                    Can.nameToString
                    op.name
                )

        arguments =
            List.map toArgument op.variableDefinitions

        -- The path between elm root and the gql file
        pathFromElmRootToGqlFile =
            path |> removePrefix elmBase

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
                        (Engine.bakeToSelection
                            (case Can.operationLabel def of
                                Nothing ->
                                    Elm.nothing

                                Just label ->
                                    Elm.just (Elm.string label)
                            )
                            (\ctxt -> Elm.tuple ctxt (Elm.string (Can.toStringFields def)))
                            (\ctxt -> Elm.tuple ctxt (generateDecoder namespace def))
                            |> Elm.withType
                                (Type.namedWith [ namespace.namespace ]
                                    (opTypeName op.operationType)
                                    [ Type.named [] opName ]
                                )
                        )
                        |> Elm.exposeWith { exposeConstructor = True, group = Just "query" }
                    ]

                _ ->
                    [ Elm.fn
                        ( "args"
                        , Just (Type.named [] "Input")
                        )
                        (\args ->
                            let
                                vars =
                                    Generate.Input.Encode.fullRecordToInputObject
                                        namespace
                                        schema
                                        arguments
                                        args
                                        |> Engine.inputObjectToFieldList
                            in
                            Engine.bakeToSelection
                                (case Can.operationLabel def of
                                    Nothing ->
                                        Elm.nothing

                                    Just label ->
                                        Elm.just (Elm.string label)
                                )
                                (\ctxt ->
                                    -- case Can.bake ctxt vars def of
                                    --     ( newCtxt, bakedDef ) ->
                                    Elm.tuple
                                        ctxt
                                        (Elm.string (Can.toStringFields def))
                                )
                                (\ctxt ->
                                    -- case Can.bake ctxt vars def of
                                    --     ( newCtxt, bakedDef ) ->
                                    Elm.tuple ctxt (generateDecoder namespace def)
                                )
                                |> Elm.withType
                                    (Type.namedWith [ namespace.namespace ]
                                        (opTypeName op.operationType)
                                        [ Type.named [] opName ]
                                    )
                        )
                        |> Elm.declaration (opValueName op.operationType)
                        |> Elm.exposeWith { exposeConstructor = True, group = Just "query" }
                    , Elm.declaration "canonical"
                        (Can.toExpression def)
                    ]

        -- auxHelpers are record alises that aren't *essential* to the return type,
        -- but are useful in some cases
        auxHelpers =
            aliasedTypes namespace schema (Set.fromList builtinNames) def

        primaryResult =
            -- if we no longer want aliased versions, there's also one without aliases
            Elm.comment """ Return data """
                :: generatePrimaryResultTypeAliased namespace schema def
    in
    Elm.fileWith (pathFromElmRootToGqlFile ++ [ opName ])
        { aliases = []
        , docs =
            \docs ->
                [ """This file is generated from a `.gql` file, likely in a nearby folder.

Please avoid modifying directly :)

This file can be regenerated by running `elm-gql`

""" ++ renderStandardComment docs
                ]
        }
        (input
            ++ primaryResult
            ++ auxHelpers
            ++ query
        )
        |> modifyFilePath (path ++ [ opName ])


removePrefix prefix list =
    case prefix of
        [] ->
            list

        pref :: remainPref ->
            case list of
                [] ->
                    list

                first :: remain ->
                    removePrefix remainPref remain


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
    builder
        |> Elm.Op.pipe
            (Elm.apply
                Engine.values_.jsonField
                [ Elm.string (Can.nameToString name)
                , decoder
                ]
            )


andMap : Elm.Expression -> Elm.Expression -> Elm.Expression
andMap decoder builder =
    builder
        |> Elm.Op.pipe
            (Elm.apply
                Engine.values_.andMap
                [ decoder
                ]
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
                |> Elm.exposeWith { exposeConstructor = True, group = Just "necessary" }
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
                |> Elm.exposeWith { exposeConstructor = True, group = Just "necessary" }
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


aliasedTypes : Namespace -> GraphQL.Schema.Schema -> Set.Set String -> Can.Definition -> List Elm.Declaration
aliasedTypes namespace schema usedNames def =
    case def of
        Can.Operation op ->
            generateTypesForFields (genAliasedTypes namespace schema) usedNames [] op.fields
                |> Tuple.second


genAliasedTypes :
    Namespace
    -> GraphQL.Schema.Schema
    -> Set.Set String
    -> Can.Selection
    -> ( Set.Set String, List Elm.Declaration )
genAliasedTypes namespace schema knownNames sel =
    case sel of
        Can.FieldObject obj ->
            let
                desiredName =
                    Can.nameToString obj.globalAlias

                ( resolvedName, knownNames2 ) =
                    resolveNewName desiredName
                        knownNames

                ( knownNames3, newDecls ) =
                    generateTypesForFields (genAliasedTypes namespace schema)
                        knownNames2
                        []
                        obj.selection

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
            let
                desiredName =
                    Can.nameToString field.globalAlias

                ( desiredTypeName, newKnownNames2 ) =
                    resolveNewName desiredName
                        knownNames

                ( knownNames3, newDecls ) =
                    generateTypesForFields (genAliasedTypes namespace schema)
                        newKnownNames2
                        []
                        field.selection

                aliasName =
                    Maybe.map
                        Can.nameToString
                        field.alias_

                final =
                    List.foldl
                        (unionVars namespace schema aliasName)
                        { names = knownNames3
                        , variants = []
                        , declarations = []
                        }
                        field.variants

                ghostVariants =
                    List.map (Elm.variant << unionVariantName) field.remainingTags

                -- Any records within variants
            in
            ( final.names
            , (Elm.customType
                desiredTypeName
                (final.variants ++ ghostVariants)
                |> Elm.exposeWith { exposeConstructor = True, group = Just "unions" }
              )
                :: final.declarations
                ++ newDecls
            )

        Can.FieldInterface field ->
            let
                desiredName =
                    Can.nameToString field.globalAlias

                ( desiredTypeName, newKnownNames2 ) =
                    resolveNewName desiredName
                        knownNames

                ( knownNames3, newDecls ) =
                    generateTypesForFields (genAliasedTypes namespace schema)
                        newKnownNames2
                        []
                        field.selection

                aliasName =
                    Maybe.map
                        Can.nameToString
                        field.alias_

                selectingForVariants =
                    case field.variants of
                        [] ->
                            False

                        _ ->
                            True

                -- Generate the record
                ( knownNames4, interfaceRecord ) =
                    fieldsToAliasedRecord namespace
                        schema
                        knownNames3
                        Nothing
                        (List.reverse field.selection)
                        (if selectingForVariants then
                            [ ( "specifics_"
                              , Type.named [] (desiredTypeName ++ "_Specifics")
                              )
                            ]

                         else
                            []
                        )

                final =
                    List.foldl
                        (interfaceVariants namespace schema aliasName)
                        { names = knownNames4
                        , variants = []
                        , declarations = []
                        }
                        field.variants

                ghostVariants =
                    List.map (Elm.variant << unionVariantName) field.remainingTags

                withSpecificType existingList =
                    if selectingForVariants then
                        (Elm.customType
                            (desiredTypeName ++ "_Specifics")
                            (final.variants ++ ghostVariants)
                            |> Elm.exposeWith { exposeConstructor = True, group = Just "unions" }
                        )
                            :: existingList

                    else
                        existingList
            in
            ( final.names
            , (Elm.alias desiredTypeName interfaceRecord
                |> Elm.exposeWith { exposeConstructor = True, group = Just "necessary" }
              )
                :: withSpecificType
                    (final.declarations
                        ++ newDecls
                    )
            )

        _ ->
            ( knownNames, [] )


unionVariantName tag =
    Can.nameToString tag.globalAlias


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
            if Can.isTypeNameSelection top then
                -- skip it!
                fieldsToAliasedRecord namespace
                    schema
                    knownNames
                    maybeParent
                    remaining
                    result

            else
                let
                    new =
                        fieldAliasedAnnotation namespace schema knownNames maybeParent top
                in
                fieldsToAliasedRecord namespace
                    schema
                    new.knownNames
                    maybeParent
                    remaining
                    (( new.name, new.annotation ) :: result)


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
    case selection of
        Can.FieldObject field ->
            let
                annotation =
                    Input.wrapElmType field.wrapper
                        (Type.named
                            []
                            (Can.nameToString field.globalAlias)
                        )
            in
            { name = Can.getAliasedFieldName field
            , annotation = annotation
            , knownNames = knownNames
            }

        Can.FieldScalar field ->
            { name = Can.getAliasedFieldName field
            , annotation =
                schemaTypeToPrefab field.type_
            , knownNames = knownNames
            }

        Can.FieldEnum field ->
            { name = Can.getAliasedFieldName field
            , annotation =
                enumType namespace field.enumName
                    |> Input.wrapElmType field.wrapper
            , knownNames = knownNames
            }

        Can.FieldUnion field ->
            let
                annotation =
                    Input.wrapElmType field.wrapper
                        (Type.named
                            []
                            (Can.nameToString field.globalAlias)
                        )
            in
            { name = Can.getAliasedFieldName field
            , annotation = annotation
            , knownNames = knownNames
            }

        Can.FieldInterface field ->
            let
                annotation =
                    Input.wrapElmType field.wrapper
                        (Type.named
                            []
                            (Can.nameToString field.globalAlias)
                        )
            in
            { name = Can.getAliasedFieldName field
            , annotation = annotation
            , knownNames = knownNames
            }


{-| -}
unionVars :
    Namespace
    -> GraphQL.Schema.Schema
    -> Maybe String
    -> Can.UnionCaseDetails
    ->
        { names : Set.Set String
        , variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
    ->
        { names : Set.Set String
        , variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
unionVars namespace schema alias_ unionCase gathered =
    case List.filter removeTypename unionCase.selection of
        [] ->
            { names = gathered.names
            , declarations = gathered.declarations
            , variants =
                Elm.variant
                    (Can.nameToString unionCase.globalAlias)
                    :: gathered.variants
            }

        fields ->
            let
                ( knownNames2, record ) =
                    fieldsToAliasedRecord
                        namespace
                        schema
                        gathered.names
                        Nothing
                        fields
                        []

                variantName =
                    Can.nameToString unionCase.globalAlias

                detailsName =
                    variantName ++ "_Details"

                recordAlias =
                    Elm.alias detailsName record
                        |> Elm.exposeWith { exposeConstructor = True, group = Just "necessary" }

                -- aliases for subselections
                ( knownNames3, subfieldAliases ) =
                    generateTypesForFields (genAliasedTypes namespace schema)
                        knownNames2
                        []
                        fields
            in
            { names = knownNames3
            , variants =
                Elm.variantWith
                    variantName
                    [ Type.named [] detailsName
                    ]
                    :: gathered.variants
            , declarations =
                Elm.comment (Can.nameToString unionCase.tag)
                    :: recordAlias
                    :: subfieldAliases
                    ++ gathered.declarations
            }


{-| -}
interfaceVariants :
    Namespace
    -> GraphQL.Schema.Schema
    -> Maybe String
    -> Can.UnionCaseDetails
    ->
        { names : Set.Set String
        , variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
    ->
        { names : Set.Set String
        , variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
interfaceVariants namespace schema alias_ unionCase gathered =
    case List.filter removeTypename unionCase.selection of
        [] ->
            { names = gathered.names
            , variants =
                Elm.variant
                    (Can.nameToString unionCase.globalAlias)
                    :: gathered.variants
            , declarations = gathered.declarations
            }

        fields ->
            let
                ( knownNames2, record ) =
                    fieldsToAliasedRecord
                        namespace
                        schema
                        gathered.names
                        Nothing
                        fields
                        []

                variantName =
                    Can.nameToString unionCase.globalAlias

                detailsName =
                    variantName ++ "_Details"

                recordAlias =
                    Elm.alias detailsName record
                        |> Elm.exposeWith { exposeConstructor = True, group = Just "necessary" }

                -- aliases for subselections
                ( knownNames3, subfieldAliases ) =
                    generateTypesForFields (genAliasedTypes namespace schema)
                        knownNames2
                        []
                        fields
            in
            { names = knownNames3
            , variants =
                Elm.variantWith
                    variantName
                    [ Type.named [] detailsName
                    ]
                    :: gathered.variants
            , declarations =
                Elm.comment (Can.nameToString unionCase.tag)
                    :: recordAlias
                    :: subfieldAliases
                    ++ gathered.declarations
            }


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
                    { name = Can.getAliasedFieldName field
                    , annotation = annotation
                    , knownNames = knownNames
                    }

                sels ->
                    let
                        ( knownNames2, record ) =
                            fieldsToRecord namespace
                                schema
                                knownNames
                                (Just (Can.nameToString field.name))
                                field.selection
                                []

                        annotation =
                            Input.wrapElmType field.wrapper
                                record
                    in
                    { name = Can.getAliasedFieldName field
                    , annotation = annotation
                    , knownNames = knownNames2
                    }

        Can.FieldScalar field ->
            { name = Can.getAliasedFieldName field
            , annotation =
                schemaTypeToPrefab field.type_
            , knownNames = knownNames
            }

        Can.FieldEnum field ->
            { name = Can.getAliasedFieldName field
            , annotation =
                enumType namespace field.enumName
                    |> Input.wrapElmType field.wrapper
            , knownNames = knownNames
            }

        Can.FieldUnion field ->
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
                    { name = Can.getAliasedFieldName field
                    , annotation = annotation
                    , knownNames = knownNames
                    }

                sels ->
                    let
                        annotation =
                            Type.named
                                []
                                -- Shouldnt this be a globa lalias?
                                (Can.getAliasedFieldName field)
                                |> Input.wrapElmType field.wrapper
                    in
                    { name = Can.getAliasedFieldName field
                    , annotation = annotation
                    , knownNames = knownNames
                    }

        Can.FieldInterface field ->
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
                    { name = Can.getAliasedFieldName field
                    , annotation = annotation
                    , knownNames = knownNames
                    }

                sels ->
                    let
                        annotation =
                            Type.named
                                []
                                -- Shouldnt this be a globa lalias?
                                (Can.getAliasedFieldName field)
                                |> Input.wrapElmType field.wrapper
                    in
                    { name = Can.getAliasedFieldName field
                    , annotation = annotation
                    , knownNames = knownNames
                    }


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


generateDecoder : Namespace -> Can.Definition -> Elm.Expression
generateDecoder namespace (Can.Operation op) =
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
            (Elm.value
                { importFrom = []
                , name = opName
                , annotation = Nothing
                }
            )
        )


{-| -}
selectSubFields : Can.Selection -> Elm.Expression -> ( String, Elm.Expression )
selectSubFields selection value =
    ( Can.getAliasedName selection
    , value
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
                                (Elm.function
                                    (List.map
                                        (\sel ->
                                            ( Utils.String.formatValue (Can.getAliasedName sel)
                                            , Nothing
                                            )
                                        )
                                        obj.selection
                                    )
                                    (\args ->
                                        Elm.record
                                            (List.map2 selectSubFields obj.selection args)
                                    )
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
                            (Elm.value
                                { importFrom =
                                    [ namespace.enums
                                    , "Enum"
                                    , Utils.String.formatTypename enum.enumName
                                    ]
                                , name = "decoder"
                                , annotation =
                                    Nothing
                                }
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

        ((Can.FieldInterface interface) as field) :: remain ->
            decodeFields namespace
                (next index)
                remain
                (andField
                    (Can.Name (Can.getAliasedName field))
                    (Input.decodeWrapper interface.wrapper
                        (decodeInterface namespace (child index) (Can.getAliasedName field) interface)
                    )
                    exp
                )


decodeInterface : Namespace -> Index -> String -> Can.FieldInterfaceDetails -> Elm.Expression
decodeInterface namespace index fieldName interface =
    let
        selection =
            List.filter (not << Can.isTypeNameSelection) interface.selection
                |> List.reverse
    in
    case interface.variants of
        [] ->
            Decode.succeed
                (Elm.function
                    (List.map fieldParameters selection)
                    (\args ->
                        Elm.record
                            (List.map2 selectSubFields selection args)
                    )
                )
                |> decodeFields namespace (child index) selection

        _ ->
            Decode.succeed
                (Elm.function
                    (( "specifics_", Nothing )
                        :: List.map fieldParameters selection
                    )
                    (\args ->
                        Elm.record
                            (List.map2 selectSubFields selection (List.drop 1 args)
                                ++ [ ( "specifics_"
                                     , Elm.value
                                        { importFrom = []
                                        , name = "specifics_"
                                        , annotation = Nothing
                                        }
                                     )
                                   ]
                            )
                    )
                )
                |> andMap (decodeInterfaceSpecifics namespace index fieldName interface)
                |> decodeFields namespace (child index) selection


decodeInterfaceSpecifics namespace index fieldName interface =
    Decode.field "__typename" Decode.string
        |> Decode.andThen
            (\_ ->
                Elm.fn
                    ( "typename" ++ fieldName ++ indexToString index
                    , Just Type.string
                    )
                    (\val ->
                        Elm.Case.string val
                            { cases =
                                List.map
                                    (interfacePattern namespace
                                        (child index)
                                        interface.alias_
                                        interface.selection
                                    )
                                    interface.variants
                                    ++ List.map
                                        (\tag ->
                                            ( Can.nameToString tag.tag
                                            , Decode.succeed
                                                (Elm.value
                                                    { importFrom = []
                                                    , name = unionVariantName tag
                                                    , annotation = Nothing
                                                    }
                                                )
                                            )
                                        )
                                        interface.remainingTags
                            , otherwise =
                                Decode.fail "Unknown interface type"
                            }
                    )
            )


interfacePattern namespace index maybeAlias commonFields var =
    let
        tag =
            Utils.String.formatTypename (Can.nameToString var.tag)

        tagTypeName =
            Can.nameToString var.globalAlias

        allFields =
            var.selection
    in
    ( tag
    , case List.filter removeTypename allFields of
        [] ->
            Decode.succeed
                (Elm.value
                    { importFrom = []
                    , name = tagTypeName
                    , annotation = Nothing
                    }
                )

        fields ->
            Decode.succeed
                (Elm.function
                    (List.map fieldParameters fields)
                    (\args ->
                        Elm.apply
                            (Elm.value
                                { importFrom = []
                                , name = tagTypeName
                                , annotation = Nothing
                                }
                            )
                            [ Elm.record
                                (List.map2 selectSubFields fields args)
                            ]
                    )
                )
                |> decodeFields namespace (child index) fields
    )


decodeUnion : Namespace -> Index -> String -> Can.FieldUnionDetails -> Elm.Expression
decodeUnion namespace index fieldName union =
    Decode.field "__typename" Decode.string
        |> Decode.andThen
            (\_ ->
                Elm.fn
                    ( "typename" ++ fieldName ++ indexToString index
                    , Just Type.string
                    )
                    (\typename ->
                        Elm.Case.string typename
                            { cases =
                                List.map
                                    (unionPattern namespace
                                        (child index)
                                        union.alias_
                                    )
                                    union.variants
                                    ++ List.map
                                        (\tag ->
                                            ( Can.nameToString tag.tag
                                            , Decode.succeed
                                                (Elm.value
                                                    { importFrom = []
                                                    , name = unionVariantName tag
                                                    , annotation = Nothing
                                                    }
                                                )
                                            )
                                        )
                                        union.remainingTags
                            , otherwise =
                                Decode.fail "Unknown union type"
                            }
                    )
            )


unionPattern namespace index maybeAlias var =
    let
        tag =
            Utils.String.formatTypename (Can.nameToString var.tag)

        tagTypeName =
            Can.nameToString var.globalAlias
    in
    ( tag
    , case List.filter removeTypename var.selection of
        [] ->
            Decode.succeed
                (Elm.value
                    { importFrom = []
                    , name = tagTypeName
                    , annotation = Nothing
                    }
                )

        fields ->
            Decode.succeed
                (Elm.function
                    (List.map fieldParameters fields)
                    (\args ->
                        Elm.apply
                            (Elm.value
                                { importFrom = []
                                , name = tagTypeName
                                , annotation = Nothing
                                }
                            )
                            [ Elm.record
                                (List.map2 selectSubFields fields args)
                            ]
                    )
                )
                |> decodeFields namespace (child index) fields
    )


fieldParameters : Can.Selection -> ( String, Maybe Type.Annotation )
fieldParameters field =
    ( Can.getAliasedName field, Nothing )


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
                    Elm.value
                        { importFrom =
                            [ "Scalar" ]
                        , name = Utils.String.formatValue scalarName
                        , annotation =
                            Nothing
                        }
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

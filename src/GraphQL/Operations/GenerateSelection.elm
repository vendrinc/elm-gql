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
    -> List Elm.File
generate opts =
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
                            (\version ->
                                Elm.tuple
                                    (Elm.list [])
                                    (Can.toRendererExpression version def)
                            )
                            (\version -> generateDecoder version namespace def)
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
                                (\version ->
                                    Elm.tuple
                                        vars
                                        (Can.toRendererExpression version def)
                                )
                                (\version ->
                                    generateDecoder version namespace def
                                )
                                |> Elm.withType
                                    (Type.namedWith [ namespace.namespace ]
                                        (opTypeName op.operationType)
                                        [ Type.named [] opName ]
                                    )
                        )
                        |> Elm.declaration (opValueName op.operationType)
                        |> Elm.exposeWith { exposeConstructor = True, group = Just "query" }
                    ]

        fragmentDecoders =
            generateFragmentDecoders namespace document.fragments

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
            ++ fragmentDecoders
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
                |> Elm.exposeWith
                    { exposeConstructor = True
                    , group = Just "necessary"
                    }
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
            generateTypesForFields
                (genAliasedTypes namespace schema)
                usedNames
                []
                op.fields
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

        Can.FieldFragment fragment ->
            { name = AST.nameToString fragment.fragment.name
            , annotation =
                Type.named [] (AST.nameToString fragment.fragment.name)
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
                    (Can.nameToString unionCase.globalTagName)
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
                    Can.nameToString unionCase.globalTagName

                detailsName =
                    Can.nameToString unionCase.globalDetailsAlias

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
                    (Can.nameToString unionCase.globalTagName)
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

                -- variantName =
                --     Can.nameToString unionCase.globalTagName
                detailsName =
                    Can.nameToString unionCase.globalDetailsAlias

                recordAlias =
                    Elm.alias detailsName record
                        |> Elm.exposeWith
                            { exposeConstructor = True
                            , group = Just "necessary"
                            }

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
                    (Can.nameToString unionCase.globalTagName)
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
    -- if Set.member newName knownNames then
    --     resolveNewName (newName ++ "_") knownNames
    -- else
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

        Can.FieldFragment field ->
            { name = AST.nameToString field.fragment.name
            , annotation =
                Type.named [] (AST.nameToString field.fragment.name)
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


{-| -}
generateDecoder : Elm.Expression -> Namespace -> Can.Definition -> Elm.Expression
generateDecoder version namespace (Can.Operation op) =
    let
        opName =
            Maybe.withDefault "Query"
                (Maybe.map
                    Can.nameToString
                    op.name
                )
    in
    decodeFields namespace
        version
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


type Index
    = Index Int (List Int)


isTopLevel : Index -> Bool
isTopLevel (Index i tail) =
    List.isEmpty tail


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


decodeFields : Namespace -> Elm.Expression -> Index -> List Can.Selection -> Elm.Expression -> Elm.Expression
decodeFields namespace version index fields exp =
    List.foldl
        (decodeFieldsHelper namespace version)
        ( index, exp )
        fields
        |> Tuple.second


decodeFieldsHelper : Namespace -> Elm.Expression -> Can.Selection -> ( Index, Elm.Expression ) -> ( Index, Elm.Expression )
decodeFieldsHelper namespace version field ( index, exp ) =
    ( next index
    , case field of
        Can.FieldObject obj ->
            exp
                |> decodeSingleField version
                    index
                    (Can.getAliasedName obj)
                    (Input.decodeWrapper obj.wrapper
                        (decodeFields namespace
                            version
                            (child index)
                            obj.selection
                            (Elm.val (Can.getAliasedName obj))
                        )
                    )

        Can.FieldScalar scal ->
            exp
                |> decodeSingleField version
                    index
                    (Can.getAliasedName scal)
                    (decodeScalarType scal.type_)

        Can.FieldEnum enum ->
            exp
                |> decodeSingleField version
                    index
                    (Can.getAliasedName enum)
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

        Can.FieldUnion union ->
            exp
                |> decodeSingleField version
                    index
                    (Can.getAliasedName union)
                    (Input.decodeWrapper union.wrapper
                        (decodeUnion namespace
                            version
                            (child index)
                            (Can.getAliasedName union)
                            union
                        )
                    )

        Can.FieldInterface interface ->
            exp
                |> decodeSingleField version
                    index
                    (Can.getAliasedName interface)
                    (Input.decodeWrapper interface.wrapper
                        (decodeInterface namespace
                            version
                            (child index)
                            (Can.getAliasedName interface)
                            interface
                        )
                    )

        Can.FieldFragment fragment ->
            exp
                |> Elm.Op.pipe
                    (Elm.value
                        { importFrom = []
                        , name = "fragments_"
                        , annotation = Nothing
                        }
                        |> Elm.get (AST.nameToString fragment.fragment.name)
                        |> Elm.get "decoder"
                    )
    )


decodeSingleField version index name decoder exp =
    exp
        |> Elm.Op.pipe
            (Elm.apply
                Engine.values_.versionedJsonField
                -- we only care about adjusting the aliases of the top-level things that could collide
                [ if isTopLevel index then
                    version

                  else
                    Elm.int 0
                , Elm.string name
                , decoder
                ]
            )


decodeInterface : Namespace -> Elm.Expression -> Index -> String -> Can.FieldInterfaceDetails -> Elm.Expression
decodeInterface namespace version index fieldName interface =
    let
        selection =
            List.filter (not << Can.isTypeNameSelection) interface.selection
                |> List.reverse
    in
    case interface.variants of
        [] ->
            Decode.succeed
                (Elm.val (Can.nameToString interface.globalAlias))
                |> decodeFields namespace version (child index) selection

        _ ->
            Decode.succeed
                (Elm.val (Can.nameToString interface.globalAlias))
                |> decodeFields namespace version (child index) selection
                |> andMap (decodeInterfaceSpecifics namespace version index fieldName interface)


decodeInterfaceSpecifics namespace version index fieldName interface =
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
                                        version
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


interfacePattern namespace version index maybeAlias commonFields var =
    let
        tag =
            Utils.String.formatTypename (Can.nameToString var.tag)

        tagTypeName =
            Can.nameToString var.globalTagName

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
            Decode.call_.map
                (Elm.val tagTypeName)
                (Decode.succeed
                    (Elm.val (Can.nameToString var.globalDetailsAlias))
                )
                |> decodeFields namespace version (child index) fields
    )


decodeUnion : Namespace -> Elm.Expression -> Index -> String -> Can.FieldUnionDetails -> Elm.Expression
decodeUnion namespace version index fieldName union =
    Decode.field "__typename" Decode.string
        |> Decode.andThen
            (\typename ->
                Elm.Case.string typename
                    { cases =
                        List.map
                            (unionPattern namespace
                                version
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


unionPattern namespace version index maybeAlias var =
    let
        tag =
            Utils.String.formatTypename (Can.nameToString var.tag)

        tagTypeName =
            Can.nameToString var.globalTagName

        tagDetailsName =
            Can.nameToString var.globalDetailsAlias
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
            Decode.call_.map
                (Elm.value
                    { importFrom = []
                    , name = tagTypeName
                    , annotation = Nothing
                    }
                )
                (Decode.succeed
                    (Elm.value
                        { importFrom = []
                        , name = tagDetailsName
                        , annotation = Nothing
                        }
                    )
                    |> decodeFields namespace version (child index) fields
                )
    )


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



{- FRAGMENTS -}


generateFragmentDecoders : Namespace -> List AST.FragmentDetails -> List Elm.Definition
generateFragmentDecoders namespace fragments =
    let
        types =
            []

        decoderRecord =
            List.map (genFragDecoder namespace) fragments
                |> Elm.record
                |> Elm.declaration "fragments_"
                |> Elm.expose
    in
    decoderRecord :: types


{-|

        { name : Name
    , typeCondition : Name
    , directives : List Directive
    , selection : List Selection
    }

-}
genFragDecoder : Namespace -> AST.FragmentDetails -> ( String, Elm.Expression )
genFragDecoder namespace frag =
    ( AST.nameToString frag.name
    , Elm.record
        [ ( "decoder"
          , decodeFields namespace
                (Elm.int 0)
                initIndex
                frag.selection
                (Decode.succeed
                    (Elm.value
                        { importFrom = []
                        , name = opName
                        , annotation = Nothing
                        }
                    )
                )
          )
        ]
    )

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
            aliasedTypes namespace def

        primaryResult =
            -- if we no longer want aliased versions, there's also one without aliases
            Elm.comment """ Return data """
                :: generatePrimaryResultTypeAliased namespace def
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



{- RESULT DATA -}


generatePrimaryResultType : Namespace -> Can.Definition -> List Elm.Declaration
generatePrimaryResultType namespace def =
    case def of
        Can.Operation op ->
            let
                record =
                    List.foldl
                        (\field allFields ->
                            let
                                new =
                                    fieldAnnotation
                                        namespace
                                        field
                            in
                            ( new.name, new.annotation ) :: allFields
                        )
                        []
                        op.fields
                        |> List.reverse
                        |> Type.record
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


generatePrimaryResultTypeAliased : Namespace -> Can.Definition -> List Elm.Declaration
generatePrimaryResultTypeAliased namespace def =
    case def of
        Can.Operation op ->
            let
                record =
                    List.foldl (aliasedFieldRecord namespace)
                        []
                        op.fields
                        |> List.reverse
                        |> Type.record
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


generateTypesForFields fn generated fields =
    case fields of
        [] ->
            generated

        top :: remaining ->
            let
                newStuff =
                    fn top
            in
            generateTypesForFields fn
                (generated ++ newStuff)
                remaining


aliasedTypes : Namespace -> Can.Definition -> List Elm.Declaration
aliasedTypes namespace def =
    case def of
        Can.Operation op ->
            generateTypesForFields
                (genAliasedTypes namespace)
                []
                op.fields


genAliasedTypes :
    Namespace
    -> Can.Selection
    -> List Elm.Declaration
genAliasedTypes namespace sel =
    case sel of
        Can.FieldObject obj ->
            let
                name =
                    Can.nameToString obj.globalAlias

                newDecls =
                    generateTypesForFields (genAliasedTypes namespace)
                        []
                        obj.selection

                fieldResult =
                    List.foldl (aliasedFieldRecord namespace)
                        []
                        obj.selection
                        |> List.reverse
                        |> Type.record
            in
            (Elm.alias name fieldResult
                |> Elm.expose
            )
                :: newDecls

        Can.FieldUnion field ->
            let
                desiredName =
                    Can.nameToString field.globalAlias

                desiredTypeName =
                    desiredName

                newDecls =
                    generateTypesForFields (genAliasedTypes namespace)
                        []
                        field.selection

                aliasName =
                    Maybe.map
                        Can.nameToString
                        field.alias_

                final =
                    List.foldl
                        (unionVars namespace)
                        { variants = []
                        , declarations = []
                        }
                        field.variants

                ghostVariants =
                    List.map (Elm.variant << unionVariantName) field.remainingTags

                -- Any records within variants
            in
            (Elm.customType
                desiredTypeName
                (final.variants ++ ghostVariants)
                |> Elm.exposeWith
                    { exposeConstructor = True
                    , group = Just "unions"
                    }
            )
                :: final.declarations
                ++ newDecls

        Can.FieldInterface field ->
            let
                desiredName =
                    Can.nameToString field.globalAlias

                desiredTypeName =
                    desiredName

                newDecls =
                    generateTypesForFields (genAliasedTypes namespace)
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
                interfaceRecord =
                    List.foldl (aliasedFieldRecord namespace)
                        (if selectingForVariants then
                            [ ( "specifics_"
                              , Type.named [] (desiredTypeName ++ "_Specifics")
                              )
                            ]

                         else
                            []
                        )
                        field.selection
                        |> Type.record

                final =
                    List.foldl
                        (interfaceVariants namespace)
                        { variants = []
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
                            |> Elm.exposeWith
                                { exposeConstructor = True
                                , group = Just "unions"
                                }
                        )
                            :: existingList

                    else
                        existingList
            in
            (Elm.alias desiredTypeName interfaceRecord
                |> Elm.exposeWith { exposeConstructor = True, group = Just "necessary" }
            )
                :: withSpecificType
                    (final.declarations
                        ++ newDecls
                    )

        _ ->
            []


unionVariantName tag =
    Can.nameToString tag.globalAlias


aliasedFieldRecord :
    Namespace
    -> Can.Selection
    -> List ( String, Type.Annotation )
    -> List ( String, Type.Annotation )
aliasedFieldRecord namespace sel fields =
    if Can.isTypeNameSelection sel then
        -- skip it!
        fields

    else
        fieldAliasedAnnotation namespace sel ++ fields


fieldAliasedAnnotation :
    Namespace
    -> Can.Selection
    -> List ( String, Type.Annotation )
fieldAliasedAnnotation namespace selection =
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
            [ ( Can.getAliasedFieldName field
              , annotation
              )
            ]

        Can.FieldScalar field ->
            [ ( Can.getAliasedFieldName field
              , schemaTypeToPrefab field.type_
              )
            ]

        Can.FieldEnum field ->
            [ ( Can.getAliasedFieldName field
              , enumType namespace field.enumName
                    |> Input.wrapElmType field.wrapper
              )
            ]

        Can.FieldFragment fragment ->
            List.foldl
                (aliasedFieldRecord namespace)
                []
                fragment.fragment.selection

        Can.FieldUnion field ->
            let
                annotation =
                    Input.wrapElmType field.wrapper
                        (Type.named
                            []
                            (Can.nameToString field.globalAlias)
                        )
            in
            [ ( Can.getAliasedFieldName field
              , annotation
              )
            ]

        Can.FieldInterface field ->
            let
                annotation =
                    Input.wrapElmType field.wrapper
                        (Type.named
                            []
                            (Can.nameToString field.globalAlias)
                        )
            in
            [ ( Can.getAliasedFieldName field
              , annotation
              )
            ]


{-| -}
unionVars :
    Namespace
    -> Can.UnionCaseDetails
    ->
        { variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
    ->
        { variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
unionVars namespace unionCase gathered =
    case List.filter removeTypename unionCase.selection of
        [] ->
            { declarations = gathered.declarations
            , variants =
                Elm.variant
                    (Can.nameToString unionCase.globalTagName)
                    :: gathered.variants
            }

        fields ->
            let
                record =
                    List.foldl (aliasedFieldRecord namespace)
                        []
                        fields
                        |> List.reverse
                        |> Type.record

                variantName =
                    Can.nameToString unionCase.globalTagName

                detailsName =
                    Can.nameToString unionCase.globalDetailsAlias

                recordAlias =
                    Elm.alias detailsName record
                        |> Elm.exposeWith
                            { exposeConstructor = True
                            , group = Just "necessary"
                            }

                -- aliases for subselections
                subfieldAliases =
                    generateTypesForFields (genAliasedTypes namespace)
                        []
                        fields
            in
            { variants =
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
    -> Can.UnionCaseDetails
    ->
        { variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
    ->
        { variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
interfaceVariants namespace unionCase gathered =
    case List.filter removeTypename unionCase.selection of
        [] ->
            { variants =
                Elm.variant
                    (Can.nameToString unionCase.globalTagName)
                    :: gathered.variants
            , declarations = gathered.declarations
            }

        fields ->
            let
                record =
                    List.foldl (aliasedFieldRecord namespace)
                        []
                        fields
                        |> List.reverse
                        |> Type.record

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
                subfieldAliases =
                    generateTypesForFields (genAliasedTypes namespace)
                        []
                        fields
            in
            { variants =
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


fieldAnnotation :
    Namespace
    -> Can.Selection
    ->
        { name : String
        , annotation : Type.Annotation
        }
fieldAnnotation namespace selection =
    case selection of
        Can.FieldObject field ->
            let
                record =
                    List.foldl
                        (\subfield allFields ->
                            let
                                new =
                                    fieldAnnotation
                                        namespace
                                        subfield
                            in
                            ( new.name, new.annotation ) :: allFields
                        )
                        []
                        field.selection
                        |> List.reverse
                        |> Type.record

                annotation =
                    Input.wrapElmType field.wrapper
                        record
            in
            { name = Can.getAliasedFieldName field
            , annotation =
                annotation
            }

        Can.FieldScalar field ->
            { name = Can.getAliasedFieldName field
            , annotation =
                schemaTypeToPrefab field.type_
            }

        Can.FieldEnum field ->
            { name = Can.getAliasedFieldName field
            , annotation =
                enumType namespace field.enumName
                    |> Input.wrapElmType field.wrapper
            }

        Can.FieldFragment field ->
            { name = Can.nameToString field.fragment.name
            , annotation =
                Type.named [] (Can.nameToString field.fragment.name)
            }

        --  case field.selection of
        --     [] ->
        --         let
        --             annotation =
        --                 case parent of
        --                     Nothing ->
        --                         Type.unit
        --                     Just par ->
        --                         getScalarType par (Can.nameToString field.name) schema
        --                             |> schemaTypeToPrefab
        --         in
        --         { name = Can.getAliasedFieldName field
        --         , annotation = annotation
        --
        --         }
        --     sels ->
        --         let
        --             ( knownNames2, record ) =
        --                 fieldsToRecord namespace
        --                     schema
        --                     knownNames
        --                     (Just (Can.nameToString field.name))
        --                     field.selection
        --                     []
        --             annotation =
        --                 Input.wrapElmType field.wrapper
        --                     record
        --         in
        --         { name = Can.getAliasedFieldName field
        --         , annotation = annotation
        --        2
        --         }
        Can.FieldUnion field ->
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
            }

        Can.FieldInterface field ->
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
                            (Decode.succeed (Elm.val (Can.nameToString obj.globalAlias)))
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
                        |> Elm.get (Can.nameToString fragment.fragment.name)
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



{- FRAGMENTS -}


generateFragmentDecoders : Namespace -> List Can.Fragment -> List Elm.Declaration
generateFragmentDecoders namespace fragments =
    let
        decoderRecord =
            List.map (genFragDecoder namespace) fragments
                |> Elm.record
                |> Elm.declaration "fragments_"
    in
    [ decoderRecord ]


{-|

    { name = Name
    , typeCondition = Name
    , directives = List Directive
    , selection = List Selection
    }

-}
genFragDecoder : Namespace -> Can.Fragment -> ( String, Elm.Expression )
genFragDecoder namespace frag =
    ( Can.nameToString frag.name
    , Elm.record
        [ ( "decoder"
          , Elm.fn ( "start_", Nothing )
                (\start ->
                    decodeFields namespace
                        (Elm.int 0)
                        initIndex
                        frag.selection
                        start
                )
          )
        ]
    )

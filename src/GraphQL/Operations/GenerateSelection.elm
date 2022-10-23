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
import Generate.Path
import Generate.Scalar
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
    , path : String

    -- all the directories between the Elm source folder and the GQL file
    , gqlDir : List String
    }
    -> List Elm.File
generate opts =
    List.map (generateDefinition opts) opts.document.definitions
        ++ List.map (generateFragment opts) opts.document.fragments


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


getOpName : Can.Definition -> String
getOpName (Can.Operation op) =
    Maybe.withDefault (opTypeName op.operationType)
        (Maybe.map
            Can.nameToString
            op.name
        )


generateFragment :
    { namespace : Namespace
    , schema : GraphQL.Schema.Schema
    , document : Can.Document

    -- all the dirs between CWD and the GQL file
    , path : String

    -- all the directories between CWD and the Elm root
    , gqlDir : List String
    }
    -> Can.Fragment
    -> Elm.File
generateFragment { namespace, schema, document, path, gqlDir } frag =
    let
        paths =
            Generate.Path.fragment
                { name = Utils.String.formatTypename (Can.nameToString frag.name)
                , path = path
                , gqlDir = gqlDir
                }

        fragmentDecoders =
            generateFragmentDecoder namespace frag
                |> Elm.declaration "decoder"
                |> Elm.expose

        fragmentType =
            generateFragmentTypes namespace frag
    in
    Elm.fileWith paths.modulePath
        { aliases = []
        , docs =
            \docs ->
                [ "This file is generated from " ++ path ++ " using `elm-gql`" ++ """

Please avoid modifying directly.

""" ++ renderStandardComment docs
                ]
        }
        (fragmentType
            ++ [ fragmentDecoders
               ]
        )
        |> replaceFilePath paths.filePath


responseName : String
responseName =
    "Response"


generateDefinition :
    { namespace : Namespace
    , schema : GraphQL.Schema.Schema
    , document : Can.Document

    -- all the dirs between CWD and the GQL file
    , path : String

    -- all the directories between CWD and the Elm root
    , gqlDir : List String
    }
    -> Can.Definition
    -> Elm.File
generateDefinition { namespace, schema, document, path, gqlDir } ((Can.Operation op) as def) =
    let
        opName =
            getOpName def

        arguments =
            List.map toArgument op.variableDefinitions

        paths =
            Generate.Path.operation
                { name = Utils.String.formatTypename opName
                , path = path
                , gqlDir = gqlDir
                }

        input =
            case op.variableDefinitions of
                [] ->
                    []

                _ ->
                    List.concat
                        [ [ Generate.Input.Encode.toRecordInput namespace
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
                    Elm.declaration (opValueName op.operationType)
                        (Engine.call_.bakeToSelection
                            (case Can.operationLabel def of
                                Nothing ->
                                    Elm.nothing

                                Just label ->
                                    Elm.just (Elm.string label)
                            )
                            (Elm.fn
                                ( "version_", Nothing )
                                (\version ->
                                    Elm.tuple
                                        (Elm.list [])
                                        (Elm.apply (Elm.val "toPayload_")
                                            [ version ]
                                        )
                                )
                            )
                            (Elm.val "decoder_")
                            |> Elm.withType
                                (Type.namedWith [ namespace.namespace ]
                                    (opTypeName op.operationType)
                                    [ Type.named [] responseName ]
                                )
                        )
                        |> Elm.exposeWith { exposeConstructor = True, group = Just "query" }

                _ ->
                    Elm.fn
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
                            Engine.call_.bakeToSelection
                                (case Can.operationLabel def of
                                    Nothing ->
                                        Elm.nothing

                                    Just label ->
                                        Elm.just (Elm.string label)
                                )
                                (Elm.fn
                                    ( "version_", Nothing )
                                    (\version ->
                                        Elm.tuple
                                            vars
                                            (Elm.apply (Elm.val "toPayload_")
                                                [ version ]
                                            )
                                    )
                                )
                                (Elm.val "decoder_")
                                |> Elm.withType
                                    (Type.namedWith [ namespace.namespace ]
                                        (opTypeName op.operationType)
                                        [ Type.named [] responseName ]
                                    )
                        )
                        |> Elm.declaration (opValueName op.operationType)
                        |> Elm.exposeWith { exposeConstructor = True, group = Just "query" }

        decodersAndStuff =
            [ Elm.declaration "decoder_"
                (Elm.fn
                    ( "version_", Nothing )
                    (\version ->
                        generateDecoder version namespace def
                    )
                    |> Elm.withType
                        (Type.function
                            [ Type.int
                            ]
                            (Decode.annotation_.decoder (Type.named [] responseName))
                        )
                )
            , Elm.declaration "toPayload_"
                (Elm.fn
                    ( "version_", Nothing )
                    (\version ->
                        Can.toRendererExpression version def
                    )
                )
            ]

        -- auxHelpers are record alises that aren't *essential* to the return type,
        -- but are useful in some cases
        auxHelpers =
            aliasedTypes namespace def

        primaryResult =
            Elm.comment """ Return data """
                :: generatePrimaryResultTypeAliased namespace def
    in
    Elm.fileWith paths.modulePath
        { aliases = []
        , docs =
            \docs ->
                [ "This file is generated from " ++ path ++ " using `elm-gql`" ++ """

Please avoid modifying directly.

This file can be regenerated by running `elm-gql`

""" ++ renderStandardComment docs
                ]
        }
        (input
            ++ query
            :: primaryResult
            ++ auxHelpers
            ++ decodersAndStuff
        )
        |> replaceFilePath paths.filePath


replaceFilePath : String -> { a | path : String } -> { a | path : String }
replaceFilePath newPath file =
    { file
        | path = newPath
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


generatePrimaryResultTypeAliased : Namespace -> Can.Definition -> List Elm.Declaration
generatePrimaryResultTypeAliased namespace def =
    case def of
        Can.Operation op ->
            let
                record =
                    toAliasedFields namespace [] op.fields
            in
            [ Elm.alias
                responseName
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


genAliasedTypes : Namespace -> Can.Field -> List Elm.Declaration
genAliasedTypes namespace fieldOrFrag =
    case fieldOrFrag of
        Can.Frag frag ->
            []

        Can.Field field ->
            case field.selectsOnlyFragment of
                Just fragmentSelected ->
                    []

                Nothing ->
                    let
                        name =
                            Can.nameToString field.globalAlias
                    in
                    case field.selection of
                        Can.FieldObject selection ->
                            let
                                newDecls =
                                    generateTypesForFields (genAliasedTypes namespace)
                                        []
                                        selection

                                fieldResult =
                                    toAliasedFields namespace [] selection
                            in
                            (Elm.alias name fieldResult
                                |> Elm.expose
                            )
                                :: newDecls

                        Can.FieldUnion union ->
                            let
                                newDecls =
                                    generateTypesForFields (genAliasedTypes namespace)
                                        []
                                        union.selection

                                final =
                                    List.foldl
                                        (unionVars namespace)
                                        { variants = []
                                        , declarations = []
                                        }
                                        union.variants

                                ghostVariants =
                                    List.map (Elm.variant << unionVariantName) union.remainingTags

                                -- Any records within variants
                            in
                            (Elm.customType
                                name
                                (final.variants ++ ghostVariants)
                                |> Elm.exposeWith
                                    { exposeConstructor = True
                                    , group = Just "unions"
                                    }
                            )
                                :: final.declarations
                                ++ newDecls

                        Can.FieldInterface interface ->
                            let
                                newDecls =
                                    generateTypesForFields (genAliasedTypes namespace)
                                        []
                                        interface.selection

                                selectingForVariants =
                                    case interface.variants of
                                        [] ->
                                            False

                                        _ ->
                                            True

                                -- Generate the record
                                interfaceRecord =
                                    toAliasedFields namespace
                                        (if selectingForVariants then
                                            [ ( "specifics_"
                                              , Type.named [] (name ++ "_Specifics")
                                              )
                                            ]

                                         else
                                            []
                                        )
                                        interface.selection

                                final =
                                    List.foldl
                                        (interfaceVariants namespace)
                                        { variants = []
                                        , declarations = []
                                        }
                                        interface.variants

                                ghostVariants =
                                    List.map (Elm.variant << unionVariantName) interface.remainingTags

                                withSpecificType existingList =
                                    if selectingForVariants then
                                        (Elm.customType
                                            (name ++ "_Specifics")
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
                            (Elm.alias name interfaceRecord
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


toAliasedFields :
    Namespace
    -> List ( String, Type.Annotation )
    -> List Can.Field
    -> Type.Annotation
toAliasedFields namespace additionalFields selection =
    List.foldl (aliasedFieldRecord namespace)
        additionalFields
        selection
        |> List.reverse
        |> Type.record


aliasedFieldRecord :
    Namespace
    -> Can.Field
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
    -> Can.Field
    -> List ( String, Type.Annotation )
fieldAliasedAnnotation namespace field =
    if Can.isTypeNameSelection field then
        []

    else
        case field of
            Can.Field details ->
                [ ( Can.getAliasedName details
                  , selectionAliasedAnnotation namespace details
                        |> Input.wrapElmType details.wrapper
                  )
                ]

            Can.Frag frag ->
                case frag.fragment.selection of
                    Can.FragmentObject { selection } ->
                        List.concatMap
                            (fieldAliasedAnnotation namespace)
                            selection

                    Can.FragmentUnion union ->
                        List.concatMap
                            (fieldAliasedAnnotation namespace)
                            union.selection

                    Can.FragmentInterface interface ->
                        if not (List.isEmpty interface.variants) || not (List.isEmpty interface.remainingTags) then
                            let
                                name =
                                    Can.nameToString frag.fragment.name
                            in
                            List.concatMap
                                (fieldAliasedAnnotation namespace)
                                interface.selection
                                ++ [ ( name, Type.named [] (name ++ "_Specifics") )
                                   ]

                        else
                            List.concatMap
                                (fieldAliasedAnnotation namespace)
                                interface.selection


selectionAliasedAnnotation :
    Namespace
    -> Can.FieldDetails
    -> Type.Annotation
selectionAliasedAnnotation namespace field =
    case field.selectsOnlyFragment of
        Just fragment ->
            Type.named
                fragment.importFrom
                fragment.name

        Nothing ->
            case field.selection of
                Can.FieldObject obj ->
                    Type.named
                        []
                        (Can.nameToString field.globalAlias)

                Can.FieldScalar type_ ->
                    schemaTypeToPrefab namespace type_

                Can.FieldEnum enum ->
                    enumType namespace enum.enumName

                Can.FieldUnion _ ->
                    Type.named
                        []
                        (Can.nameToString field.globalAlias)

                Can.FieldInterface _ ->
                    Type.named
                        []
                        (Can.nameToString field.globalAlias)


{-| -}
unionVars :
    Namespace
    -> Can.VariantCase
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
                    toAliasedFields namespace [] fields

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
    -> Can.VariantCase
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
                    toAliasedFields namespace [] fields

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


removeTypename : Can.Field -> Bool
removeTypename field =
    case field of
        Can.Field details ->
            Can.nameToString details.name /= "__typename"

        _ ->
            True


enumType : Namespace -> String -> Type.Annotation
enumType namespace enumName =
    Type.named
        [ namespace.enums
        , "Enum"
        , Utils.String.formatTypename enumName
        ]
        enumName


schemaTypeToPrefab : Namespace -> GraphQL.Schema.Type -> Type.Annotation
schemaTypeToPrefab namespace schemaType =
    case schemaType of
        GraphQL.Schema.Scalar scalarName ->
            Generate.Scalar.type_ namespace scalarName

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
            Type.list (schemaTypeToPrefab namespace inner)

        GraphQL.Schema.Nullable inner ->
            Type.maybe (schemaTypeToPrefab namespace inner)



{- DECODER -}


{-| -}
generateDecoder : Elm.Expression -> Namespace -> Can.Definition -> Elm.Expression
generateDecoder version namespace ((Can.Operation op) as def) =
    Decode.succeed
        (Elm.value
            { importFrom = []
            , name = responseName
            , annotation = Nothing
            }
        )
        |> decodeFields namespace
            version
            initIndex
            op.fields


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


decodeFields : Namespace -> Elm.Expression -> Index -> List Can.Field -> Elm.Expression -> Elm.Expression
decodeFields namespace version index fields exp =
    List.foldl
        (decodeFieldHelper namespace version)
        ( index, exp )
        fields
        |> Tuple.second


decodeFieldHelper : Namespace -> Elm.Expression -> Can.Field -> ( Index, Elm.Expression ) -> ( Index, Elm.Expression )
decodeFieldHelper namespace version field ( index, exp ) =
    case field of
        Can.Field details ->
            ( next index
            , exp
                |> decodeSingleField version
                    index
                    (Can.getAliasedName details)
                    (decodeSelection
                        namespace
                        version
                        details
                        (child index)
                        |> Input.decodeWrapper details.wrapper
                    )
            )

        Can.Frag fragment ->
            ( index
            , exp
                |> Elm.Op.pipe
                    (Elm.value
                        { importFrom =
                            fragment.fragment.importFrom
                        , name = "decoder"
                        , annotation = Nothing
                        }
                    )
            )


decodeSelection : Namespace -> Elm.Expression -> Can.FieldDetails -> Index -> Elm.Expression
decodeSelection namespace version field index =
    let
        start =
            case field.selectsOnlyFragment of
                Just fragment ->
                    Decode.succeed
                        (Elm.value
                            { importFrom =
                                fragment.importFrom
                            , name = fragment.name
                            , annotation =
                                Just (Type.named fragment.importFrom fragment.name)
                            }
                        )

                Nothing ->
                    Decode.succeed (Elm.val (Can.nameToString field.globalAlias))
    in
    -- NOTE: this withType thing is a workaround at the moment.  It's not even necessarily correct?
    -- If we don't have it, then the `Apps2` query with a union fragment will go into an infinite loop when generating
    -- The main issue seems to be with decodeUnion, but is also tricky
    -- This means elm-codegen still has an issue with type inference.
    -- We're not relying on type inference here, so it's not that big of a deal
    Elm.withType (Decode.annotation_.decoder (Type.named [] (Can.nameToString field.globalAlias))) <|
        case field.selection of
            Can.FieldObject objSelection ->
                start
                    |> decodeFields namespace
                        version
                        (child index)
                        objSelection

            Can.FieldScalar type_ ->
                decodeScalarType namespace type_

            Can.FieldEnum enum ->
                Elm.value
                    { importFrom =
                        [ namespace.enums
                        , "Enum"
                        , Utils.String.formatTypename enum.enumName
                        ]
                    , name = "decoder"
                    , annotation =
                        Nothing
                    }

            Can.FieldUnion union ->
                case field.selectsOnlyFragment of
                    Just fragment ->
                        Elm.value
                            { importFrom =
                                fragment.importFrom
                            , name = "decoder"
                            , annotation =
                                Nothing
                            }

                    Nothing ->
                        decodeUnion namespace
                            version
                            (child index)
                            union

            -- Elm.unit
            Can.FieldInterface interface ->
                start
                    |> decodeInterface namespace
                        version
                        (child index)
                        interface


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


decodeInterface :
    Namespace
    -> Elm.Expression
    -> Index
    -> Can.FieldVariantDetails
    -> Elm.Expression
    -> Elm.Expression
decodeInterface namespace version index interface start =
    let
        selection =
            List.filter (not << Can.isTypeNameSelection) interface.selection
                |> List.reverse
    in
    case interface.variants of
        [] ->
            start
                |> decodeFields namespace version (child index) selection

        _ ->
            start
                |> decodeFields namespace version (child index) selection
                |> andMap (decodeInterfaceSpecifics namespace version index interface)


decodeInterfaceSpecifics : Namespace -> Elm.Expression -> Index -> Can.FieldVariantDetails -> Elm.Expression
decodeInterfaceSpecifics namespace version index interface =
    Decode.field "__typename" Decode.string
        |> Decode.andThen
            (\val ->
                Elm.Case.string val
                    { cases =
                        List.map
                            (interfacePattern namespace
                                version
                                (child index)
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



-- interfacePattern : Namespace -> Elm.Expression -> Index ->


interfacePattern namespace version index commonFields var =
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


decodeUnion :
    Namespace
    -> Elm.Expression
    -> Index
    -> Can.FieldVariantDetails
    -> Elm.Expression
decodeUnion namespace version index union =
    Decode.field "__typename" Decode.string
        |> Decode.andThen
            (\typename ->
                Elm.Case.string typename
                    { cases =
                        List.map
                            (unionPattern namespace
                                version
                                (child index)
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
                        Decode.fail
                            "Unknown union found"
                    }
            )


unionPattern namespace version index var =
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


decodeScalarType : Namespace -> GraphQL.Schema.Type -> Elm.Expression
decodeScalarType namespace type_ =
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
                            [ namespace.namespace ]
                        , name = Utils.String.formatValue scalarName
                        , annotation =
                            Nothing
                        }
                        |> Elm.get "decoder"

        GraphQL.Schema.Nullable inner ->
            Decode.nullable (decodeScalarType namespace inner)

        GraphQL.Schema.List_ inner ->
            Decode.list (decodeScalarType namespace inner)

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
    [ decoderRecord
    ]


generateFragmentTypes : Namespace -> Can.Fragment -> List Elm.Declaration
generateFragmentTypes namespace frag =
    let
        name =
            Can.nameToString frag.name
    in
    case frag.selection of
        Can.FragmentObject { selection } ->
            let
                newDecls =
                    generateTypesForFields (genAliasedTypes namespace)
                        []
                        selection

                fieldResult =
                    toAliasedFields namespace [] selection
            in
            (Elm.alias name fieldResult
                |> Elm.expose
            )
                :: newDecls

        Can.FragmentUnion union ->
            let
                newDecls =
                    generateTypesForFields (genAliasedTypes namespace)
                        []
                        union.selection

                final =
                    List.foldl
                        (unionVars namespace)
                        { variants = []
                        , declarations = []
                        }
                        union.variants

                ghostVariants =
                    List.map (Elm.variant << unionVariantName) union.remainingTags

                -- Any records within variants
            in
            (Elm.customType
                name
                (final.variants ++ ghostVariants)
                |> Elm.exposeWith
                    { exposeConstructor = True
                    , group = Just "unions"
                    }
            )
                :: final.declarations
                ++ newDecls

        Can.FragmentInterface interface ->
            let
                newDecls =
                    generateTypesForFields (genAliasedTypes namespace)
                        []
                        interface.selection

                selectingForVariants =
                    case interface.variants of
                        [] ->
                            False

                        _ ->
                            True

                final =
                    List.foldl
                        (interfaceVariants namespace)
                        { variants = []
                        , declarations = []
                        }
                        interface.variants

                interfaceRecord =
                    toAliasedFields namespace
                        (if selectingForVariants then
                            [ ( "specifics_"
                              , Type.named [] (name ++ "_Specifics")
                              )
                            ]

                         else
                            []
                        )
                        interface.selection

                withSpecificType existingList =
                    if selectingForVariants then
                        let
                            ghostVariants =
                                List.map (Elm.variant << unionVariantName) interface.remainingTags
                        in
                        Elm.alias name interfaceRecord
                            :: (Elm.customType
                                    (name ++ "_Specifics")
                                    (final.variants ++ ghostVariants)
                                    |> Elm.exposeWith
                                        { exposeConstructor = True
                                        , group = Just "unions"
                                        }
                               )
                            :: existingList

                    else
                        Elm.alias name interfaceRecord :: existingList
            in
            withSpecificType
                (final.declarations
                    ++ newDecls
                )


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
          , generateFragmentDecoder namespace frag
          )
        ]
    )


generateFragmentDecoder : Namespace -> Can.Fragment -> Elm.Expression
generateFragmentDecoder namespace frag =
    case frag.selection of
        Can.FragmentObject fragSelection ->
            Elm.fn ( "start_", Nothing )
                (\start ->
                    decodeFields namespace
                        (Elm.int 0)
                        initIndex
                        fragSelection.selection
                        start
                )

        Can.FragmentUnion fragSelection ->
            Elm.fn ( "start_", Nothing )
                (\start ->
                    start
                        |> decodeSingleField (Elm.int 0)
                            initIndex
                            (Can.nameToString frag.name)
                            (decodeUnion namespace
                                (Elm.int 0)
                                initIndex
                                fragSelection
                            )
                )

        Can.FragmentInterface fragSelection ->
            Elm.fn ( "start_", Nothing )
                (\start ->
                    start
                        |> decodeInterface namespace
                            (Elm.int 0)
                            initIndex
                            fragSelection
                )

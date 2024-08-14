module GraphQL.Operations.Generate exposing (generate)

{-| Generate elm code from an Operations.AST
-}

import Elm
import Elm.Annotation as Type
import Elm.Case
import Elm.Let
import Elm.Op
import Gen.GraphQL.Engine as Engine
import Gen.GraphQL.InputObject
import Gen.Json.Decode as Decode
import Gen.Json.Encode
import Generate.Input.Encode
import Generate.Path
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Generate.Decode exposing (Namespace)
import GraphQL.Operations.Generate.Fragment
import GraphQL.Operations.Generate.Help as Help
import GraphQL.Operations.Generate.Mock as Mock
import GraphQL.Operations.Generate.Options as Options
import GraphQL.Operations.Generate.Types as GeneratedTypes
import GraphQL.Schema
import Set
import Utils.String


generate : Options.Options -> List Elm.File
generate opts =
    let
        mocks =
            if opts.generateMocks then
                Mock.generate opts

            else
                []

        generatedFragments =
            List.filterMap
                (\frag ->
                    if frag.isGlobal then
                        Nothing

                    else
                        Just (GraphQL.Operations.Generate.Fragment.generate opts frag)
                )
                opts.document.fragments
    in
    List.map (generateDefinition opts) opts.document.definitions
        ++ generatedFragments
        ++ mocks


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
    Maybe.withDefault (Can.operationTypeName op.operationType)
        (Maybe.map
            Can.nameToString
            op.name
        )


responseName : String
responseName =
    "Response"


generateDefinition :
    Options.Options
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
                    [ Generate.Input.Encode.toInputRecordAlias namespace schema "Input" arguments
                    ]

        query =
            case op.variableDefinitions of
                [] ->
                    Elm.declaration (Can.operationName op.operationType)
                        (Engine.call_.operation
                            (case Can.operationLabel def of
                                Nothing ->
                                    Elm.nothing

                                Just label ->
                                    Elm.just (Elm.string label)
                            )
                            (Elm.fn
                                ( "version_", Nothing )
                                (\version ->
                                    Elm.record
                                        [ ( "args", Elm.list [] )
                                        , ( "body"
                                          , Elm.apply (Elm.val "toPayload_")
                                                [ version ]
                                          )
                                        , ( "fragments"
                                          , Elm.apply (Elm.val "toFragments_")
                                                [ version ]
                                          )
                                        ]
                                )
                            )
                            (Elm.val "decoder_")
                            |> Elm.withType
                                (Type.namedWith [ namespace.namespace ]
                                    (Can.operationTypeName op.operationType)
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
                                        |> Gen.GraphQL.InputObject.toFieldList
                            in
                            Engine.call_.operation
                                (case Can.operationLabel def of
                                    Nothing ->
                                        Elm.nothing

                                    Just label ->
                                        Elm.just (Elm.string label)
                                )
                                (Elm.fn
                                    ( "version_", Nothing )
                                    (\version ->
                                        Elm.record
                                            [ ( "args", vars )
                                            , ( "body"
                                              , Elm.apply (Elm.val "toPayload_")
                                                    [ version ]
                                              )
                                            , ( "fragments"
                                              , Elm.apply (Elm.val "toFragments_")
                                                    [ version ]
                                              )
                                            ]
                                    )
                                )
                                (Elm.val "decoder_")
                                |> Elm.withType
                                    (Type.namedWith [ namespace.namespace ]
                                        (Can.operationTypeName op.operationType)
                                        [ Type.named [] responseName ]
                                    )
                        )
                        |> Elm.declaration (Can.operationName op.operationType)
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
            , Elm.declaration "toFragments_"
                (Elm.fn
                    ( "version_", Just Type.int )
                    (\version ->
                        Can.toFragmentRendererExpression version document def
                    )
                )
            ]

        encoders =
            toJsonEncoder { importFrom = [] } (Type.named [] "Response") namespace def

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
""" ++ Help.renderStandardComment docs
                ]
        }
        (input
            ++ query
            :: primaryResult
            ++ auxHelpers
            ++ decodersAndStuff
            ++ encoders
        )
        |> Help.replaceFilePath paths.filePath


toJsonEncoder : { importFrom : List String } -> Type.Annotation -> Namespace -> Can.Definition -> List Elm.Declaration
toJsonEncoder targetModule responseType namespace (Can.Operation def) =
    let
        builders =
            createBuilders targetModule namespace Nothing def.fields

        topEncoder =
            createFieldsEncoder "encode" (Just responseType) namespace def.fields
                |> Elm.expose
    in
    topEncoder :: deduplicate builders


createBuilders : { importFrom : List String } -> Namespace -> Maybe Can.FragmentDetails -> List Can.Field -> List ( String, Elm.Declaration )
createBuilders targetModule namespace maybeFragmentName fields =
    List.concatMap
        (createBuilder targetModule namespace maybeFragmentName)
        fields


deduplicate : List ( String, Elm.Declaration ) -> List Elm.Declaration
deduplicate builders =
    List.foldl
        (\( key, builder ) ( seen, acc ) ->
            if Set.member key seen then
                ( seen, acc )

            else
                ( Set.insert key seen, builder :: acc )
        )
        ( Set.empty, [] )
        builders
        |> Tuple.second
        |> List.reverse


createFieldsEncoder name annotation namespace fields =
    Elm.declaration name
        (Elm.fn
            ( "valueToEncode"
            , annotation
            )
            (\value ->
                let
                    data =
                        encodeFields namespace fields value
                            |> toObject
                in
                data
                    |> Elm.withType Gen.Json.Encode.annotation_.value
            )
        )


createBuilder : { importFrom : List String } -> Namespace -> Maybe Can.FragmentDetails -> Can.Field -> List ( String, Elm.Declaration )
createBuilder targetModule namespace maybeFragmentName field =
    let
        name =
            Can.getFieldName field
    in
    case field of
        Can.Frag fragment ->
            -- case fragment.fragment.selection of
            --     Can.FragmentObject { selection } ->
            --         createBuilders targetModule namespace (Just fragment) selection
            --     Can.FragmentUnion union ->
            --         let
            --             encoderName =
            --                 toEncoderName Nothing maybeFragmentName name
            --             builder =
            --                 createUnionEncoder targetModule namespace name encoderName union
            --             allSelections =
            --                 List.concatMap .selection union.variants
            --             innerBuilders =
            --                 createBuilders targetModule
            --                     namespace
            --                     maybeFragmentName
            --                     (union.selection ++ allSelections)
            --         in
            --         ( encoderName, builder )
            --             :: innerBuilders
            --     Can.FragmentInterface interface ->
            --         createBuilders targetModule namespace (Just fragment) interface.selection
            []

        Can.Field fieldDetails ->
            case fieldDetails.selectsOnlyFragment of
                Just onlyFragment ->
                    []

                Nothing ->
                    let
                        annotation =
                            case fieldDetails.selectsOnlyFragment of
                                Nothing ->
                                    case maybeFragmentName of
                                        Just frag ->
                                            Type.named frag.fragment.importFrom
                                                (Utils.String.formatTypename name)
                                                |> Just

                                        Nothing ->
                                            Type.named targetModule.importFrom globalAlias
                                                |> Just

                                Just frag ->
                                    Type.named frag.importFrom (Utils.String.formatTypename frag.name)
                                        |> Just

                        globalAlias =
                            Can.nameToString fieldDetails.globalAlias
                                |> Utils.String.formatTypename
                    in
                    case fieldDetails.selection of
                        Can.FieldScalar scalarType ->
                            []

                        Can.FieldEnum enum ->
                            []

                        Can.FieldObject fields ->
                            let
                                encoderName =
                                    toEncoderName fieldDetails.selectsOnlyFragment maybeFragmentName globalAlias

                                builder =
                                    createFieldsEncoder encoderName
                                        annotation
                                        namespace
                                        fields

                                innerBuilders =
                                    createBuilders targetModule namespace maybeFragmentName fields
                            in
                            ( encoderName, builder ) :: innerBuilders

                        Can.FieldUnion union ->
                            let
                                encoderName =
                                    toEncoderName fieldDetails.selectsOnlyFragment maybeFragmentName globalAlias

                                builder =
                                    createUnionEncoder targetModule namespace globalAlias encoderName union

                                allSelections =
                                    List.concatMap .selection union.variants

                                innerBuilders =
                                    createBuilders targetModule
                                        namespace
                                        maybeFragmentName
                                        (union.selection ++ allSelections)
                            in
                            ( encoderName, builder ) :: innerBuilders

                        Can.FieldInterface interface ->
                            let
                                encoderName =
                                    toEncoderName fieldDetails.selectsOnlyFragment maybeFragmentName globalAlias

                                allSelections =
                                    List.concatMap .selection interface.variants

                                builder =
                                    createInterfaceEncoder targetModule namespace globalAlias encoderName interface

                                innerBuilders =
                                    createBuilders targetModule namespace maybeFragmentName (interface.selection ++ allSelections)
                            in
                            ( encoderName, builder ) :: innerBuilders


createInterfaceEncoder : { importFrom : List String } -> Namespace -> String -> String -> Can.FieldVariantDetails -> Elm.Declaration
createInterfaceEncoder target namespace interfaceName encoderName interface =
    case interface.variants of
        [] ->
            let
                interfaceType =
                    Type.named target.importFrom
                        (Utils.String.formatTypename interfaceName)
            in
            createFieldsEncoder encoderName (Just interfaceType) namespace interface.selection

        _ ->
            let
                branches =
                    List.map
                        (createUnionEncoderBranch target namespace)
                        interface.variants

                interfaceType =
                    Type.named target.importFrom
                        (Utils.String.formatTypename interfaceName)
            in
            Elm.declaration encoderName
                (Elm.fn
                    ( "valueToEncode"
                    , Just interfaceType
                    )
                    (\value ->
                        Elm.Let.letIn
                            (\common specifics ->
                                Elm.Op.append common specifics
                                    |> Gen.Json.Encode.call_.object
                            )
                            |> Elm.Let.value "commonFields_" (Elm.list (encodeFields namespace interface.selection value))
                            |> Elm.Let.value "specifics_"
                                (Elm.Case.custom (Elm.get "specifics_" value)
                                    interfaceType
                                    (List.reverse branches)
                                )
                            |> Elm.Let.toExpression
                            |> Elm.withType Gen.Json.Encode.annotation_.value
                    )
                )


createUnionEncoder : { importFrom : List String } -> Namespace -> String -> String -> Can.FieldVariantDetails -> Elm.Declaration
createUnionEncoder target namespace unionName encoderName union =
    let
        branches =
            List.map
                (createUnionEncoderBranch target namespace)
                union.variants

        remainingBranches =
            List.map
                createUnionEncoderBranchEmpty
                union.remainingTags

        unionType =
            Type.named target.importFrom
                (Utils.String.formatTypename unionName)
    in
    Elm.declaration encoderName
        (Elm.fn
            ( "valueToEncode"
            , Just unionType
            )
            (\value ->
                Elm.Case.custom value
                    unionType
                    (List.reverse (remainingBranches ++ branches))
                    |> Gen.Json.Encode.call_.object
                    |> Elm.withType Gen.Json.Encode.annotation_.value
            )
        )


createUnionEncoderBranchEmpty : { tag : Can.Name, globalAlias : Can.Name } -> Elm.Case.Branch
createUnionEncoderBranchEmpty variant =
    let
        typename =
            typeNameField (Can.nameToString variant.tag)
    in
    Elm.Case.branch0
        (Can.nameToString variant.globalAlias)
        ([ typename ]
            |> Elm.list
            |> Elm.withType Gen.Json.Encode.annotation_.value
        )


typeNameField : String -> Elm.Expression
typeNameField name =
    Elm.tuple (Elm.string "__typename") (Gen.Json.Encode.string name)


createUnionEncoderBranch : { importFrom : List String } -> Namespace -> Can.VariantCase -> Elm.Case.Branch
createUnionEncoderBranch target namespace variant =
    let
        selection =
            List.filter (not << Can.isTypeNameSelection) variant.selection

        typename =
            typeNameField (Can.nameToString variant.tag)
    in
    if List.isEmpty selection then
        Elm.Case.branch0
            (Can.nameToString variant.globalTagName)
            ([ typename ]
                |> Elm.list
                |> Elm.withType Gen.Json.Encode.annotation_.value
            )

    else
        let
            tagName =
                variant.globalTagName |> Can.nameToString
        in
        Elm.Case.branch1 tagName
            ( tagName ++ "__details", Type.named target.importFrom (tagName |> Utils.String.formatTypename) )
            (\details ->
                typename
                    :: encodeFields namespace selection details
                    |> Elm.list
                    |> Elm.withType Gen.Json.Encode.annotation_.value
            )


toObject fields =
    Gen.Json.Encode.call_.object
        (fields
            |> Elm.list
        )


encodeFields : Namespace -> List Can.Field -> Elm.Expression -> List Elm.Expression
encodeFields namespace fields runtimeValue =
    let
        encodedFields =
            List.concatMap
                (encodeFragmentFields namespace Nothing runtimeValue)
                fields
    in
    List.reverse encodedFields


fieldToJson : String -> Elm.Expression -> Elm.Expression
fieldToJson name value =
    Elm.tuple (Elm.string name) value


encodeFragmentFields : Namespace -> Maybe Can.FragmentDetails -> Elm.Expression -> Can.Field -> List Elm.Expression
encodeFragmentFields namespace maybeParentFragment parentObjectRuntimeValue field =
    let
        jsonFieldName =
            Can.getFieldName field
                |> Utils.String.formatJsonFieldName

        name =
            Can.getFieldName field
                |> Utils.String.formatValue

        runtimeValue =
            parentObjectRuntimeValue
                |> Elm.get name
    in
    case field of
        Can.Frag fragment ->
            case fragment.fragment.selection of
                Can.FragmentObject fields ->
                    List.concatMap
                        (encodeFragmentFields namespace (Just fragment) parentObjectRuntimeValue)
                        fields.selection

                Can.FragmentUnion union ->
                    List.concatMap
                        (encodeFragmentFields namespace (Just fragment) parentObjectRuntimeValue)
                        union.selection

                Can.FragmentInterface interface ->
                    List.concatMap
                        (encodeFragmentFields namespace (Just fragment) parentObjectRuntimeValue)
                        interface.selection

        Can.Field fieldDetails ->
            if Can.isTypeNameSelection field then
                []

            else
                let
                    globalFieldValueName =
                        fieldDetails.globalAlias
                            |> Can.nameToString
                            |> Utils.String.formatValue
                in
                case fieldDetails.selectsOnlyFragment of
                    Just onlyFragment ->
                        [ Elm.tuple
                            (Elm.string jsonFieldName)
                            (wrapEncoder fieldDetails.wrapper
                                (Elm.value
                                    { importFrom = onlyFragment.importMockFrom
                                    , name = "encode"
                                    , annotation = Nothing
                                    }
                                )
                                runtimeValue
                            )
                        ]

                    Nothing ->
                        case fieldDetails.selection of
                            Can.FieldScalar scalarType ->
                                [ fieldToJson jsonFieldName
                                    (encodeScalar namespace
                                        fieldDetails.wrapper
                                        scalarType
                                        runtimeValue
                                    )
                                ]

                            Can.FieldEnum enum ->
                                [ fieldToJson jsonFieldName
                                    (encodeEnum namespace
                                        fieldDetails.wrapper
                                        enum
                                        runtimeValue
                                    )
                                ]

                            Can.FieldObject fields ->
                                case maybeParentFragment of
                                    Just parent ->
                                        [ Elm.tuple
                                            (Elm.string jsonFieldName)
                                            (wrapEncoder fieldDetails.wrapper
                                                (Elm.value
                                                    { importFrom = parent.fragment.importMockFrom
                                                    , name = "encode" ++ Utils.String.capitalize name
                                                    , annotation = Nothing
                                                    }
                                                )
                                                runtimeValue
                                            )
                                        ]

                                    Nothing ->
                                        [ Elm.tuple (Elm.string jsonFieldName)
                                            (wrapEncoder fieldDetails.wrapper
                                                (Elm.val
                                                    (toEncoderName fieldDetails.selectsOnlyFragment maybeParentFragment globalFieldValueName)
                                                )
                                                runtimeValue
                                            )
                                        ]

                            Can.FieldUnion union ->
                                case maybeParentFragment of
                                    Just parent ->
                                        [ Elm.tuple
                                            (Elm.string jsonFieldName)
                                            (wrapEncoder fieldDetails.wrapper
                                                (Elm.value
                                                    { importFrom = parent.fragment.importMockFrom
                                                    , name = "encode" ++ Utils.String.capitalize name
                                                    , annotation = Nothing
                                                    }
                                                )
                                                runtimeValue
                                            )
                                        ]

                                    Nothing ->
                                        [ fieldToJson jsonFieldName
                                            (wrapEncoder fieldDetails.wrapper
                                                (Elm.val
                                                    (toEncoderName fieldDetails.selectsOnlyFragment maybeParentFragment globalFieldValueName)
                                                )
                                                runtimeValue
                                            )
                                        ]

                            Can.FieldInterface interface ->
                                case maybeParentFragment of
                                    Just parent ->
                                        [ Elm.tuple
                                            (Elm.string jsonFieldName)
                                            (wrapEncoder fieldDetails.wrapper
                                                (Elm.value
                                                    { importFrom = parent.fragment.importMockFrom
                                                    , name = "encode" ++ Utils.String.capitalize globalFieldValueName
                                                    , annotation = Nothing
                                                    }
                                                )
                                                runtimeValue
                                            )
                                        ]

                                    Nothing ->
                                        [ fieldToJson jsonFieldName
                                            (wrapEncoder fieldDetails.wrapper
                                                (Elm.val
                                                    (toEncoderName fieldDetails.selectsOnlyFragment maybeParentFragment globalFieldValueName)
                                                )
                                                runtimeValue
                                            )
                                        ]


toEncoderName :
    Maybe
        { importFrom : List String
        , importMockFrom : List String
        , name : String
        }
    -> Maybe Can.FragmentDetails
    -> String
    -> String
toEncoderName maybeSingleSelection maybeFragment name =
    let
        fragName =
            case maybeSingleSelection of
                Nothing ->
                    case maybeFragment of
                        Just frag ->
                            Can.nameToString frag.fragment.name
                                |> Utils.String.formatTypename
                                |> Utils.String.capitalize

                        Nothing ->
                            ""

                Just frag ->
                    frag.name
                        |> Utils.String.formatTypename
                        |> Utils.String.capitalize
    in
    "encode" ++ fragName ++ Utils.String.capitalize name


encodeEnum : Namespace -> GraphQL.Schema.Wrapped -> Can.FieldEnumDetails -> Elm.Expression -> Elm.Expression
encodeEnum namespace wrapper enum value =
    if namespace.enums == namespace.namespace then
        wrapEncoder wrapper
            (Elm.value
                { importFrom =
                    [ namespace.enums
                    , "Enum"
                    , Utils.String.formatTypename enum.enumName
                    ]
                , name = "encode"
                , annotation =
                    Nothing
                }
            )
            value

    else
        -- We're using dillonkearns/elm-graphql, so we need to use the generated code from there
        wrapEncoder wrapper
            (Elm.fn
                ( "innerEnum", Nothing )
                (\innerEnum ->
                    Elm.apply
                        (Elm.value
                            { importFrom =
                                [ namespace.enums
                                , "Enum"
                                , Utils.String.formatTypename enum.enumName
                                ]
                            , name = "toString"
                            , annotation =
                                Nothing
                            }
                        )
                        [ innerEnum ]
                        |> Gen.Json.Encode.call_.string
                )
            )
            value


encodeScalar : Namespace -> GraphQL.Schema.Wrapped -> GraphQL.Schema.Type -> Elm.Expression -> Elm.Expression
encodeScalar namespace wrapper scalarType value =
    case scalarType of
        GraphQL.Schema.Scalar name ->
            let
                encoder =
                    case String.toLower name of
                        "string" ->
                            Gen.Json.Encode.values_.string

                        "int" ->
                            Gen.Json.Encode.values_.int

                        "float" ->
                            Gen.Json.Encode.values_.float

                        "boolean" ->
                            Gen.Json.Encode.values_.bool

                        _ ->
                            Elm.value
                                { importFrom = [ namespace.namespace ]
                                , name = Utils.String.formatValue name
                                , annotation = Nothing
                                }
                                |> Elm.get "encode"
            in
            wrapEncoder wrapper encoder value

        _ ->
            Gen.Json.Encode.null


wrapEncoder : GraphQL.Schema.Wrapped -> Elm.Expression -> Elm.Expression -> Elm.Expression
wrapEncoder wrapper encoder value =
    case wrapper of
        GraphQL.Schema.InMaybe inner ->
            Elm.Case.maybe value
                { nothing = Gen.Json.Encode.null
                , just =
                    ( "innerMaybeJust"
                    , \val ->
                        wrapEncoder inner encoder val
                    )
                }

        GraphQL.Schema.InList inner ->
            Gen.Json.Encode.call_.list
                (Elm.fn
                    ( "innerItemToEncode", Nothing )
                    (\innerValue ->
                        wrapEncoder inner encoder innerValue
                    )
                )
                value

        GraphQL.Schema.UnwrappedValue ->
            Elm.apply encoder [ value ]



{- RESULT DATA -}


generatePrimaryResultTypeAliased : Namespace -> Can.Definition -> List Elm.Declaration
generatePrimaryResultTypeAliased namespace def =
    case def of
        Can.Operation op ->
            let
                fields =
                    GeneratedTypes.toFields namespace [] op.fields
            in
            [ Elm.alias
                responseName
                (Type.record fields)
                |> Elm.exposeWith
                    { exposeConstructor = True
                    , group = Just "necessary"
                    }
            ]


aliasedTypes : Namespace -> Can.Definition -> List Elm.Declaration
aliasedTypes namespace def =
    case def of
        Can.Operation op ->
            GeneratedTypes.generate namespace op.fields



{- DECODER -}


{-| -}
generateDecoder : Elm.Expression -> Namespace -> Can.Definition -> Elm.Expression
generateDecoder version namespace (Can.Operation op) =
    Decode.succeed
        (Elm.value
            { importFrom = []
            , name = responseName
            , annotation = Nothing
            }
        )
        |> GraphQL.Operations.Generate.Decode.decodeFields namespace
            version
            GraphQL.Operations.Generate.Decode.initIndex
            op.fields

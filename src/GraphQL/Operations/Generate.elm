module GraphQL.Operations.Generate exposing (generate)

{-| Generate elm code from an Operations.AST
-}

import Elm
import Elm.Annotation as Type
import Gen.GraphQL.Engine as Engine
import Gen.GraphQL.InputObject
import Gen.Json.Decode as Decode
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
generateDefinition { namespace, schema, document, path, queryDir } ((Can.Operation op) as def) =
    let
        opName =
            getOpName def

        arguments =
            List.map toArgument op.variableDefinitions

        paths =
            Generate.Path.operation
                { name = Utils.String.formatTypename opName
                , path = path
                , queryDir = queryDir
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
        )
        |> Help.replaceFilePath paths.filePath



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

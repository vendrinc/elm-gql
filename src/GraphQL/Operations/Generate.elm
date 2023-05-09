module GraphQL.Operations.Generate exposing (generate)

{-| Generate elm code from an Operations.AST
-}

import Elm
import Elm.Annotation as Type
import Gen.GraphQL.Engine as Engine
import Gen.Json.Decode as Decode
import Generate.Input.Encode
import Generate.Path
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Generate.Decode exposing (Namespace)
import GraphQL.Operations.Generate.Fragment
import GraphQL.Operations.Generate.Help as Help
import GraphQL.Operations.Generate.Mock as Mock
import GraphQL.Operations.Generate.Types as GeneratedTypes
import GraphQL.Schema
import Utils.String


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
        ++ List.map (GraphQL.Operations.Generate.Fragment.generate opts) opts.document.fragments
        ++ Mock.generate opts


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
                    [ Generate.Input.Encode.toInputRecordAlias namespace schema "Input" arguments
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
                record =
                    GeneratedTypes.toAliasedFields namespace [] op.fields
            in
            [ Elm.alias
                responseName
                record
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
generateDecoder version namespace ((Can.Operation op) as def) =
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

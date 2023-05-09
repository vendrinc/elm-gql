module GraphQL.Operations.Generate.Mock exposing (generate)

{-| For a given query, generate a bunch of functions to help mock data that the query can return.
-}

import Elm
import Elm.Annotation as Type
import Generate.Path
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Generate.Decode exposing (Namespace)
import GraphQL.Operations.Generate.Help as Help
import GraphQL.Operations.Generate.Mock.Fragment as MockFragment
import GraphQL.Operations.Generate.Mock.Value as Mock
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
        ++ List.map (MockFragment.generate opts) opts.document.fragments


opTypeName : Can.OperationType -> String
opTypeName op =
    case op of
        Can.Query ->
            "Query"

        Can.Mutation ->
            "Mutation"


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

        paths =
            Generate.Path.operation
                { name = Utils.String.formatTypename opName
                , path = path
                , gqlDir = gqlDir
                }
    in
    Elm.fileWith paths.mockModulePath
        { aliases =
            [ ( paths.modulePath, opName )
            ]
        , docs =
            \docs ->
                [ "\nThis is a **mock** module for the `" ++ opName ++ "` operation.  It is intended to be used in tests.\n\nThis file is generated from " ++ path ++ " using `elm-gql`" ++ """

Please avoid modifying directly.
""" ++ Help.renderStandardComment docs
                ]
        }
        (mockPrimaryResult paths namespace def)
        |> Help.replaceFilePath paths.mockModuleFilePath



{- RESULT DATA -}


mockPrimaryResult : Generate.Path.Paths -> Namespace -> Can.Definition -> List Elm.Declaration
mockPrimaryResult paths namespace def =
    case def of
        Can.Operation op ->
            let
                record =
                    GeneratedTypes.toAliasedFields namespace [] op.fields

                primaryResponse =
                    Elm.declaration responseName
                        (Elm.record
                            (List.concatMap
                                (\field ->
                                    if Can.isTypeNameSelection field then
                                        []

                                    else
                                        [ ( Can.getFieldName field
                                                |> Utils.String.formatValue
                                          , Mock.field namespace field
                                          )
                                        ]
                                )
                                op.fields
                            )
                            |> Elm.withType
                                (Type.alias paths.modulePath
                                    responseName
                                    []
                                    record
                                )
                        )
                        |> Elm.exposeWith
                            { exposeConstructor = True
                            , group = Just "necessary"
                            }

                builders =
                    List.concatMap
                        (Mock.builders paths namespace)
                        op.fields
            in
            primaryResponse :: builders

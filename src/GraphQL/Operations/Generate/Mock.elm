module GraphQL.Operations.Generate.Mock exposing (generate)

{-| For a given query, generate a bunch of functions to help mock data that the query can return.
-}

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
import GraphQL.Operations.Generate.Decode exposing (Namespace)
import GraphQL.Operations.Generate.Fragment
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
                [ "This file is generated from " ++ path ++ " using `elm-gql`" ++ """

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
                        (generateMockBuilders paths namespace)
                        op.fields
            in
            primaryResponse :: builders


generateMockBuilders : Generate.Path.Paths -> Namespace -> Can.Field -> List Elm.Declaration
generateMockBuilders paths namespace field =
    case field of
        Can.Frag fragDetails ->
            []

        Can.Field fieldDetails ->
            case fieldDetails.selection of
                Can.FieldScalar type_ ->
                    -- Don't need builders for scalars
                    []

                Can.FieldEnum enum ->
                    -- Don't need builders for enums
                    []

                Can.FieldObject fields ->
                    let
                        objectType =
                            GeneratedTypes.toAliasedFields namespace [] fields

                        builderForThisObject =
                            Elm.declaration
                                (fieldDetails.globalAlias
                                    |> Can.nameToString
                                    |> Utils.String.formatValue
                                )
                                (Elm.record
                                    (List.concatMap
                                        (\innerField ->
                                            if Can.isTypeNameSelection innerField then
                                                []

                                            else
                                                -- case innerField of
                                                --     Can.Field details ->
                                                --         [ ( Utils.String.formatValue (Can.getAliasedName details)
                                                --           , mockValue namespace details
                                                --                 |> Input.wrapExpression details.wrapper
                                                --           )
                                                --         ]
                                                --     Can.Frag frag ->
                                                --         []
                                                [ ( Can.getFieldName field
                                                        |> Utils.String.formatValue
                                                  , Mock.field namespace field
                                                  )
                                                ]
                                        )
                                        fields
                                    )
                                    |> Elm.withType
                                        (Type.alias paths.modulePath
                                            (Can.nameToString fieldDetails.globalAlias)
                                            []
                                            objectType
                                        )
                                )
                                |> Elm.exposeWith
                                    { exposeConstructor = True
                                    , group = Just "builders"
                                    }

                        -- What is this, a builder for ANTS?!
                        buildersForChildren =
                            List.concatMap
                                (generateMockBuilders paths namespace)
                                fields
                    in
                    builderForThisObject :: buildersForChildren

                Can.FieldUnion union ->
                    if fieldDetails.selectsOnlyFragment /= Nothing then
                        []

                    else
                        generateVariantBuilders paths namespace fieldDetails union

                Can.FieldInterface interface ->
                    if fieldDetails.selectsOnlyFragment /= Nothing then
                        []

                    else
                        generateVariantBuilders paths namespace fieldDetails interface


onlySingleFragmentSelection : List Can.Field -> Bool
onlySingleFragmentSelection fields =
    case fields of
        [ Can.Frag _ ] ->
            True

        _ ->
            False


generateVariantBuilders : Generate.Path.Paths -> Namespace -> Can.FieldDetails -> Can.FieldVariantDetails -> List Elm.Declaration
generateVariantBuilders paths namespace parentField variantDetails =
    let
        variantBuilders =
            List.concatMap
                (generateVariantBuilder paths namespace parentField variantDetails)
                variantDetails.variants

        variantBuildersForRemainigTags =
            List.map
                (\tag ->
                    Elm.declaration (Utils.String.formatValue (Can.nameToString tag.globalAlias))
                        (Elm.value
                            { name = Can.nameToString tag.globalAlias
                            , importFrom = paths.modulePath
                            , annotation =
                                Just (Type.namedWith paths.modulePath (Can.nameToString parentField.globalAlias) [])
                            }
                        )
                        |> Elm.expose
                )
                variantDetails.remainingTags

        builders =
            Elm.comment (Can.nameToString parentField.globalAlias)
                :: variantBuilders
                ++ variantBuildersForRemainigTags

        defaultBuilder name =
            Elm.declaration (Utils.String.formatValue (Can.nameToString parentField.globalAlias))
                (Elm.value
                    { name = Utils.String.formatValue (Can.nameToString name)
                    , importFrom = []
                    , annotation =
                        Just (Type.namedWith paths.modulePath (Can.nameToString parentField.globalAlias) [])
                    }
                )
                |> Elm.expose
    in
    case variantDetails.variants of
        [] ->
            case variantDetails.remainingTags of
                [] ->
                    builders

                topTag :: _ ->
                    defaultBuilder topTag.globalAlias :: builders

        topTag :: _ ->
            defaultBuilder topTag.globalTagName :: builders


generateVariantBuilder : Generate.Path.Paths -> Namespace -> Can.FieldDetails -> Can.FieldVariantDetails -> Can.VariantCase -> List Elm.Declaration
generateVariantBuilder paths namespace parentDetails parent variant =
    let
        variantName =
            Can.nameToString variant.globalTagName

        fields =
            variant.selection

        variantType =
            GeneratedTypes.toAliasedFields namespace [] fields

        builder =
            Elm.declaration
                (variantName
                    |> Utils.String.formatValue
                )
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
                        variant.selection
                    )
                    |> List.singleton
                    |> Elm.apply
                        (Elm.value
                            { name = variantName
                            , importFrom = paths.modulePath
                            , annotation = Nothing
                            }
                        )
                    |> Elm.withType
                        (Type.namedWith paths.modulePath (Can.nameToString parentDetails.globalAlias) [])
                )
                |> Elm.exposeWith
                    { exposeConstructor = True
                    , group = Just "builders"
                    }

        buildersForChildren =
            List.concatMap
                (generateMockBuilders paths namespace)
                fields
    in
    builder :: buildersForChildren


aliasedTypes : Namespace -> Can.Definition -> List Elm.Declaration
aliasedTypes namespace def =
    case def of
        Can.Operation op ->
            GeneratedTypes.generate namespace op.fields

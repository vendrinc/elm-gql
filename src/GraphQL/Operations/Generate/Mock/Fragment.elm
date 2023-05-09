module GraphQL.Operations.Generate.Mock.Fragment exposing (generate)

{-| -}

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
import GraphQL.Operations.Generate.Help as Help
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

    -- all the directories between CWD and the Elm root
    , gqlDir : List String
    }
    -> Can.Fragment
    -> Elm.File
generate { namespace, schema, document, path, gqlDir } frag =
    let
        paths =
            Generate.Path.fragment
                { name = Utils.String.formatTypename (Can.nameToString frag.name)
                , path = path
                , gqlDir = gqlDir
                }
    in
    Elm.fileWith paths.mockModulePath
        { aliases = [ ( paths.modulePath, "Fragment" ) ]
        , docs =
            \docs ->
                [ "This file is generated from " ++ path ++ " using `elm-gql`\n" ++ Help.renderStandardComment docs
                ]
        }
        (mockFragment paths namespace frag)
        |> Help.replaceFilePath paths.mockModuleFilePath


mockFragment : Generate.Path.Paths -> Namespace -> Can.Fragment -> List Elm.Declaration
mockFragment paths namespace frag =
    generateMockBuilders paths namespace frag


generateMockBuilders : Generate.Path.Paths -> Namespace -> Can.Fragment -> List Elm.Declaration
generateMockBuilders paths namespace frag =
    case frag.selection of
        Can.FragmentObject { selection } ->
            List.concatMap
                (Mock.builders paths namespace)
                selection

        Can.FragmentUnion union ->
            List.concatMap
                (Mock.builders paths namespace)
                union.selection
                ++ Mock.variantBuilders paths
                    namespace
                    { globalAlias = frag.name
                    , selectsOnlyFragment = Nothing
                    }
                    union

        Can.FragmentInterface interface ->
            List.concatMap
                (Mock.builders paths namespace)
                interface.selection
                ++ Mock.variantBuilders paths
                    namespace
                    { globalAlias = frag.name
                    , selectsOnlyFragment = Nothing
                    }
                    interface

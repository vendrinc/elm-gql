module GraphQL.Operations.Generate.Fragment exposing (generate)

{-| -}

import Elm
import Elm.Annotation as Type
import Gen.Json.Decode as Decode
import Generate.Path
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Generate.Decode exposing (Namespace)
import GraphQL.Operations.Generate.Help as Help
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
    , generateMocks : Bool
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

""" ++ Help.renderStandardComment docs
                ]
        }
        (fragmentType
            ++ [ fragmentDecoders
               ]
        )
        |> Help.replaceFilePath paths.filePath


generateFragmentDecoder : Namespace -> Can.Fragment -> Elm.Expression
generateFragmentDecoder namespace frag =
    case frag.selection of
        Can.FragmentObject fragSelection ->
            Elm.fn ( "start_", Nothing )
                (\start ->
                    GraphQL.Operations.Generate.Decode.decodeFields namespace
                        (Elm.int 0)
                        GraphQL.Operations.Generate.Decode.initIndex
                        fragSelection.selection
                        start
                )

        Can.FragmentUnion fragSelection ->
            GraphQL.Operations.Generate.Decode.decodeUnion namespace
                (Elm.int 0)
                GraphQL.Operations.Generate.Decode.initIndex
                fragSelection
                |> Elm.withType (Decode.annotation_.decoder (Type.named [] (Can.nameToString frag.name)))

        Can.FragmentInterface fragSelection ->
            Elm.fn ( "start_", Nothing )
                (\start ->
                    start
                        |> GraphQL.Operations.Generate.Decode.decodeInterface namespace
                            (Elm.int 0)
                            GraphQL.Operations.Generate.Decode.initIndex
                            fragSelection
                )


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
                    GeneratedTypes.generate namespace selection

                fieldResult =
                    GeneratedTypes.toAliasedFields namespace [] selection
            in
            (Elm.alias name fieldResult
                |> Elm.expose
            )
                :: newDecls

        Can.FragmentUnion union ->
            let
                newDecls =
                    GeneratedTypes.generate namespace union.selection

                final =
                    List.foldl
                        (GeneratedTypes.unionVars namespace)
                        { variants = []
                        , declarations = []
                        }
                        union.variants

                ghostVariants =
                    List.map (Elm.variant << GraphQL.Operations.Generate.Decode.unionVariantName) union.remainingTags

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
                    GeneratedTypes.generate namespace interface.selection

                selectingForVariants =
                    case interface.variants of
                        [] ->
                            False

                        _ ->
                            True

                final =
                    List.foldl
                        (GeneratedTypes.interfaceVariants namespace)
                        { variants = []
                        , declarations = []
                        }
                        interface.variants

                interfaceRecord =
                    GeneratedTypes.toAliasedFields namespace
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
                                List.map (Elm.variant << GraphQL.Operations.Generate.Decode.unionVariantName) interface.remainingTags
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

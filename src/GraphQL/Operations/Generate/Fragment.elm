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
    , outDir : List String
    , generateMocks : Bool
    }
    -> Can.Fragment
    -> Elm.File
generate { namespace, schema, document, path, gqlDir, outDir } frag =
    let
        paths =
            if frag.isGlobal then
                Generate.Path.fragmentGlobal
                    { name = Utils.String.formatTypename (Can.nameToString frag.name)
                    , namespace = namespace.namespace
                    , path = path
                    , gqlDir = gqlDir
                    , outDir = outDir
                    }

            else
                Generate.Path.fragment
                    { name = Utils.String.formatTypename (Can.nameToString frag.name)
                    , path = path
                    , gqlDir = gqlDir
                    , outDir = outDir
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
    let
        finalType =
            Type.var (Can.nameToString frag.name)

        index =
            -- Fragments are always children because they're not queries themselves
            -- This has the effect of not using versioned fields
            GraphQL.Operations.Generate.Decode.initIndex
                |> GraphQL.Operations.Generate.Decode.child
    in
    case frag.selection of
        Can.FragmentObject fragSelection ->
            let
                fields =
                    GeneratedTypes.toFields namespace [] fragSelection.selection
            in
            Elm.fn2
                ( "version_", Just Type.int )
                ( "start_"
                , Just
                    (Decode.annotation_.decoder
                        (Type.function
                            (List.map Tuple.second fields)
                            finalType
                        )
                    )
                )
                (\version start ->
                    GraphQL.Operations.Generate.Decode.decodeFields namespace
                        version
                        index
                        fragSelection.selection
                        start
                        |> Elm.withType
                            (Decode.annotation_.decoder finalType)
                )

        Can.FragmentUnion fragSelection ->
            Elm.fn
                ( "version_", Just Type.int )
                (\version ->
                    GraphQL.Operations.Generate.Decode.decodeUnion namespace
                        version
                        index
                        fragSelection
                        |> Elm.withType (Decode.annotation_.decoder (Type.named [] (Can.nameToString frag.name)))
                )

        Can.FragmentInterface fragSelection ->
            Elm.fn2
                ( "version_", Just Type.int )
                ( "start_", Nothing )
                (\version start ->
                    start
                        |> GraphQL.Operations.Generate.Decode.decodeInterface namespace
                            version
                            index
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

                fields =
                    GeneratedTypes.toFields namespace [] selection
            in
            List.concat
                [ [ Elm.alias name (Type.record fields)
                        |> Elm.expose
                  ]
                , newDecls
                , [ Elm.alias (name ++ "_Open")
                        (Type.extensible "open" fields)
                        |> Elm.expose
                  , Elm.declaration ("to" ++ Utils.String.capitalize name)
                        (Elm.fn
                            ( "open", Just (Type.extensible "open" fields) )
                            (\open ->
                                Elm.record
                                    (List.map
                                        (\fieldName ->
                                            ( fieldName
                                            , Elm.get fieldName open
                                            )
                                        )
                                        (GeneratedTypes.toFieldNames namespace [] selection)
                                    )
                                    |> Elm.withType (Type.named [] name)
                            )
                        )
                        |> Elm.expose
                        |> Elm.withDocumentation
                            "Convert an open record to a record with all fields required.\n"
                  ]
                ]

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
                    GeneratedTypes.toFields namespace
                        (if selectingForVariants then
                            [ ( "specifics_"
                              , Type.named [] (name ++ "_Specifics")
                              )
                            ]

                         else
                            []
                        )
                        interface.selection
                        |> Type.record

                withSpecificType existingList =
                    if selectingForVariants then
                        let
                            ghostVariants =
                                List.map (Elm.variant << GraphQL.Operations.Generate.Decode.unionVariantName) interface.remainingTags
                        in
                        (Elm.alias name interfaceRecord
                            |> Elm.expose
                        )
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

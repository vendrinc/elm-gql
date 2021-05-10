module Codegen.Union exposing (generateFiles)

import Codegen.Common as Common
import Dict
import Elm.CodeGen as Elm
import GraphQL.Schema
import GraphQL.Schema.Kind exposing (Kind(..))
import GraphQL.Schema.Type exposing (Type(..))
import GraphQL.Schema.Union
import String.Extra as String


{-|

    app :
        { variantName : Selection App data
        , variantName2 : Selection App data
        } -> Selection UnionName data
    app variants =
        Engine.union
            [ ("variantName", variants.variantName )

            ]

-}
buildUnion : GraphQL.Schema.Union.Union -> Common.File
buildUnion union =
    let
        linkage =
            []

        unionImplementation =
            Elm.apply
                [ Common.modules.engine.fns.union
                , Elm.list
                    (List.map
                        (\var ->
                            let
                                variantName =
                                    varName var.kind
                            in
                            Elm.tuple
                                [ Elm.string variantName
                                , Elm.access (Elm.fun "variants") (String.decapitalize variantName)
                                ]
                        )
                        union.variants
                    )
                ]

        unionTypeAnnotation =
            Elm.funAnn
                (Elm.recordAnn
                    (List.map
                        (\var ->
                            let
                                variantName =
                                    varName var.kind
                            in
                            ( String.decapitalize variantName
                            , Common.modules.engine.fns.selection variantName
                                (Elm.typeVar "data")
                            )
                        )
                        union.variants
                    )
                )
                (Common.modules.engine.fns.selection union.name
                    (Elm.typeVar "data")
                )

        comments =
            case union.description of
                Nothing ->
                    Nothing

                Just desc ->
                    Elm.emptyDocComment
                        |> Elm.markdown desc
                        |> Just

        unionDecl =
            Elm.funDecl
                comments
                (Just unionTypeAnnotation)
                (String.decapitalize union.name)
                [ -- arguments
                  Elm.varPattern "variants"
                ]
                unionImplementation

        moduleName =
            [ "TnGql", "Union", union.name ]

        module_ =
            Elm.normalModule moduleName []

        ( imports_, exposing_ ) =
            Elm.combineLinkage linkage
                |> Elm.addImport Common.modules.decode.import_
                |> Elm.addImport Common.modules.scalar.import_
                |> Elm.addImport (Elm.importStmt [ "TnGql", "Object" ] Nothing Nothing)
                |> Elm.addImport (Elm.importStmt [ "GraphQL", "Engine" ] Nothing Nothing)
    in
    { name = moduleName
    , file =
        Elm.file module_
            imports_
            [ unionDecl ]
            Nothing
    }


varName :
    Kind
    -> String
varName variantKind =
    case variantKind of
        GraphQL.Schema.Kind.Object name ->
            name

        GraphQL.Schema.Kind.Scalar name ->
            name

        GraphQL.Schema.Kind.InputObject name ->
            name

        GraphQL.Schema.Kind.Enum name ->
            name

        GraphQL.Schema.Kind.Union name ->
            name

        GraphQL.Schema.Kind.Interface name ->
            name


generateFiles : GraphQL.Schema.Schema -> List Common.File
generateFiles graphQLSchema =
    let
        objects =
            graphQLSchema.unions
                |> Dict.toList
                |> List.map Tuple.second

        objectFiles =
            objects
                |> List.map buildUnion

        moduleName =
            [ "TnGql", "Union" ]

        module_ =
            Elm.normalModule moduleName []

        phantomTypeDeclarations =
            objects
                |> List.map
                    (\object ->
                        Elm.customTypeDecl Nothing object.name [] [ ( object.name, [] ) ]
                    )

        masterObjectFile =
            { name = moduleName
            , file =
                Elm.file module_
                    []
                    phantomTypeDeclarations
                    Nothing
            }
    in
    masterObjectFile :: objectFiles

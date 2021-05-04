module Codegen.Objects exposing (generateFiles)

import Codegen.Common as Common
import Dict
import Elm.CodeGen as Elm
import GraphQL.Schema
import GraphQL.Schema.Object
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String



-- target:
-- module TnGql.Object.App exposing (..)
-- import Json.Decode as Decode exposing (Decoder)
-- import TnGql.Object
-- import GraphQL.Engine as Engine
-- app : { name : Engine.Selection Tng.Object.App String, slug : Engine.Selection Tng.Object.App String  }
-- app =
--     { name = Engine.field "name" Decode.string
--     , slug = Engine.field "slug" Decode.string
--     }


objectToModule : GraphQL.Schema.Object.Object -> Common.File
objectToModule object =
    let
        ( fieldTypesAndImpls, linkage ) =
            object.fields
                |> List.filter
                    (\field ->
                        List.member field.name [ "name", "slug" ]
                    )
                |> List.foldl
                    (\field ( accDecls, linkageAcc ) ->
                        let
                            ( underlyingTypeAnnotation, linkage__ ) =
                                Common.gqlTypeToElmTypeAnnotation field.type_ Nothing

                            typeAnnotation =
                                Elm.fqTyped [ "GraphQL", "Engine" ] "Selection" [ Elm.fqTyped [ "Tng", "Object" ] object.name [], underlyingTypeAnnotation ]

                            ( implementation, import_ ) =
                                case field.type_ of
                                    GraphQL.Schema.Type.Scalar scalarName ->
                                        ( Elm.apply
                                            [ Common.modules.engine.fns.field
                                            , Elm.string field.name
                                            , Elm.fqVal [ "Decoder" ] (String.decapitalize scalarName)
                                            ]
                                        , Nothing
                                        )

                                    GraphQL.Schema.Type.Enum enumName ->
                                        ( Elm.apply
                                            [ Common.modules.engine.fns.field
                                            , Elm.fun "identity"
                                            , Elm.string field.name
                                            , Elm.fqFun [ "TnGql", "Enum", enumName ] "decoder"
                                            , Elm.list []
                                            ]
                                        , Just [ "TnGql", "Enum", enumName ]
                                        )

                                    GraphQL.Schema.Type.Object objectName ->
                                        ( Elm.lambda [ Elm.varPattern "selection_" ]
                                            -- GraphQL.Engine.field identity "name" (GraphQL.Engine.decoder selection_) []
                                            (Elm.apply
                                                [ Common.modules.engine.fns.field
                                                , Elm.fun "identity"
                                                , Elm.string field.name
                                                , Elm.parens
                                                    (Elm.apply
                                                        [ Elm.fqFun [ "TnGql", "Object", objectName ] "decoder"
                                                        , Elm.val "selection_"
                                                        ]
                                                    )
                                                , Elm.list []
                                                ]
                                            )
                                        , Just [ "TnGql", "Object", objectName ]
                                        )

                                    _ ->
                                        ( Elm.string "unimplemented", Nothing )
                        in
                        ( ( field.name, typeAnnotation, implementation ) :: accDecls
                        , linkage__
                            :: (import_
                                    |> Maybe.map (\i -> Elm.emptyLinkage |> Elm.addImport (Elm.importStmt i Nothing Nothing))
                                    |> Maybe.withDefault Elm.emptyLinkage
                               )
                            :: linkageAcc
                        )
                    )
                    ( [], [] )

        -- GQL.Query (Maybe value)
        objectTypeAnnotation =
            fieldTypesAndImpls
                |> List.map (\( name, typeAnnotation, _ ) -> ( name, typeAnnotation ))
                |> Elm.recordAnn

        objectImplementation =
            fieldTypesAndImpls
                |> List.map (\( name, _, implementation ) -> ( name, implementation ))
                |> Elm.record

        objectDecl =
            Elm.valDecl Nothing (Just objectTypeAnnotation) (String.decapitalize object.name) objectImplementation

        moduleName =
            [ "TnGql", "Object", object.name ]

        module_ =
            Elm.normalModule moduleName []

        ( imports_, exposing_ ) =
            Elm.combineLinkage linkage
                |> Elm.addImport Common.modules.decode.import_
                |> Elm.addImport Common.modules.scalar.import_
                |> Elm.addImport (Elm.importStmt [ "GraphQL", "Engine" ] Nothing Nothing)
    in
    { name = moduleName
    , file =
        Elm.file module_
            imports_
            [ objectDecl ]
            Nothing
    }


generateFiles : GraphQL.Schema.Schema -> List Common.File
generateFiles graphQLSchema =
    let
        objects =
            graphQLSchema.objects
                |> Dict.toList
                |> List.map Tuple.second
                |> List.filter (\object -> object.name == "App")

        objectFiles =
            objects
                |> List.map objectToModule

        moduleName =
            [ "TnGql", "Object" ]

        module_ =
            Elm.normalModule moduleName []

        phantomTypeDeclarations =
            objects
                |> List.map
                    (\object ->
                        Elm.customTypeDecl Nothing object.name [] [ ( object.name, [] ) ]
                    )

        -- ( imports_, exposing_ ) =
        --     Elm.combineLinkage linkage
        --         |> Elm.addImport Common.modules.decode.import_
        --         |> Elm.addImport Common.modules.scalar.import_
        --     in
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

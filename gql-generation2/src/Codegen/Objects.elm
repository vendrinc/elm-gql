module Codegen.Objects exposing (generateFiles)

import Codegen.Common as Common
import Dict
import Elm.CodeGen as Elm
import GraphQL.Schema
import GraphQL.Schema.Argument exposing (Argument)
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String


generateFiles graphQLSchema =
    graphQLSchema.objects
        -- type alias Object =
        -- { name : String
        -- , description : Maybe String
        -- , fields : List Field
        -- , interfaces : List Kind
        -- }
        |> Dict.toList
        |> List.map
            (\( _, object ) ->
                let
                    moduleName =
                        [ "TnGql", "Object", object.name ]

                    module_ =
                        Elm.normalModule moduleName []

                    docs =
                        Nothing

                    ( fieldDecl, linkage ) =
                        object.fields
                            |> List.foldl
                                (\field ( accDecls, linkage_ ) ->
                                    let
                                        typeAnnotation =
                                            Common.gqlTypeToElmTypeAnnotation field.type_ Nothing

                                        -- { id = GraphQL.Engine.field identity "id" (Codec.decoder Scalar.codecs.id) []
                                        -- , name =
                                        --     \selection_ ->
                                        --         GraphQL.Engine.field identity "name" (GraphQL.Engine.decoder selection_) []
                                        -- , role = GraphQL.Engine.field identity "role" role []
                                        -- , email = GraphQL.Engine.field Json.maybe "email" (Codec.decoder Scalar.codecs.string) []
                                        -- , friends =
                                        --     \selection_ opts_ ->
                                        --         GraphQL.Engine.field Json.list "friends" (GraphQL.Engine.decoder selection_) (GraphQL.Engine.optionalsToArguments opts_)
                                        -- }
                                        ( implementation, import_ ) =
                                            case field.type_ of
                                                GraphQL.Schema.Type.Scalar scalarName ->
                                                    ( Elm.apply
                                                        [ Common.modules.engine.fns.field
                                                        , Elm.fun "identity"
                                                        , Elm.string field.name
                                                        , Elm.parens
                                                            (Elm.apply
                                                                [ Common.modules.codec.fns.decoder
                                                                , Elm.access Common.modules.scalar.exports.codec (String.decapitalize scalarName)
                                                                ]
                                                            )
                                                        , Elm.list []
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
                                    , import_
                                        |> Maybe.map (\i -> linkage_ |> Elm.addImport (Elm.importStmt i Nothing Nothing))
                                        |> Maybe.withDefault linkage_
                                    )
                                )
                                ( [], Elm.emptyLinkage )

                    -- GQL.Query (Maybe value)
                    objectTypeAnnotation =
                        fieldDecl
                            |> List.map (\( name, typeAnnotation, _ ) -> ( name, typeAnnotation ))
                            |> Elm.recordAnn

                    objectImplementation =
                        fieldDecl
                            |> List.map (\( name, _, implementation ) -> ( name, implementation ))
                            |> Elm.record

                    objectDecl =
                        Elm.valDecl Nothing (Just objectTypeAnnotation) (String.decapitalize object.name) objectImplementation

                    ( imports_, exposing_ ) =
                        linkage
                            |> Elm.addImport Common.modules.decode.import_
                            |> Elm.addImport Common.modules.scalar.import_
                in
                { name = moduleName
                , file =
                    Elm.file module_
                        imports_
                        [ objectDecl ]
                        Nothing
                }
            )

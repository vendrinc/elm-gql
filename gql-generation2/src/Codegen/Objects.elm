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
                -- app :
                --     { id : GQL.App GQL.ID
                --     , slug : GQL.App String
                --     , name : GQL.App String
                --     }
                -- app =
                --     { id = GraphQL.Engine.field identity "id" (Codec.decoder Scalar.codecs.id) {} []
                --     , slug = GraphQL.Engine.field identity "slug" (Codec.decoder Scalar.codecs.string) {} []
                --     , slug = GraphQL.Engine.field identity "name" (Codec.decoder Scalar.codecs.string) {} []
                --     }
                let
                    moduleName =
                        [ "TnGql", "Object", object.name ]

                    module_ =
                        Elm.normalModule moduleName []

                    docs =
                        Nothing

                    fieldDecl =
                        object.fields
                            |> List.map
                                (\field ->
                                    -- { name : String
                                    -- , description : Maybe String
                                    -- , type_ : Type
                                    -- , permissions : List Permission
                                    -- }
                                    let
                                        typeAnnotation =
                                            Common.gqlTypeToElmTypeAnnotation field.type_ Nothing

                                        implementation =
                                            Elm.string "unimplemented"
                                    in
                                    ( field.name, typeAnnotation, implementation )
                                )

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
                in
                { name = moduleName
                , file =
                    Elm.file module_
                        [ Common.modules.decode.import_
                        ]
                        [ objectDecl ]
                        Nothing
                }
             -- { name = queryOperation.name
             -- , signature = type_
             -- , implementation = expression
             -- }
            )

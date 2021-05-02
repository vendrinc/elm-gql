module Codegen.Queries exposing (generateFiles)

import Codegen.Common as Common
import Dict
import Elm.CodeGen as Elm
import GraphQL.Schema
import GraphQL.Schema.Argument exposing (Argument)
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String



-- query :
--     { app : { id : GQL.ID } -> GQL.App value -> GQL.Query (Maybe value)
--     , person : { id : GQL.ID } -> GQL.Person value -> GQL.Query (Maybe value)
--     }
-- query =
--     { app =
--         \req_ selection_ ->
--             GraphQL.Engine.query "app"
--                 Json.maybe
--                 selection_
--                 [ ( "id", GraphQL.Engine.args.scalar Scalar.codecs.id req_.id )
--                 ]
--     , person =
--         \req_ selection_ ->
--             GraphQL.Engine.query "person"
--                 Json.maybe
--                 selection_
--                 [ ( "id", GraphQL.Engine.args.scalar Scalar.codecs.id req_.id )
--                 ]
--     }


enumNameToConstructorName =
    String.toSentenceCase



-- generateFiles : GraphQL.Schema.Schema -> List Codegen.Common.File


generateFiles graphQLSchema =
    graphQLSchema.queries
        |> Dict.toList
        |> List.map
            (\( _, queryOperation ) ->
                -- type alias Operation =
                --     { name : String
                --     , deprecation : Deprecation
                --     , description : Maybe String
                --     , arguments : List Argument
                --     , type_ : Type
                --     , permissions : List Permission
                --     }
                let
                    moduleName =
                        [ "TnGql", "Queries", String.toSentenceCase queryOperation.name ]

                    module_ =
                        Elm.normalModule moduleName []

                    docs =
                        Nothing

                    -- GQL.Query (Maybe value)
                    returnType =
                        Elm.typed "GQL.Query" [ Elm.typed "Maybe" [ Elm.typed "value" [] ] ]

                    inputType =
                        queryOperation.arguments
                            |> List.map
                                (\argument ->
                                    ( argument.name, Common.gqlTypeToElmTypeAnnotation argument.type_ Nothing )
                                )
                            |> Elm.recordAnn

                    type_ =
                        Elm.funAnn inputType
                            (Elm.funAnn
                                (Common.gqlTypeToElmTypeAnnotation queryOperation.type_ (Just [ Elm.typeVar "value" ]))
                                returnType
                            )

                    expression =
                        Elm.lambda [ Elm.varPattern "req_", Elm.varPattern "selection_" ]
                            (Elm.apply
                                [ Common.modules.engine.fns.query
                                , Elm.string queryOperation.name
                                , Common.modules.json.fns.maybe
                                , Elm.val "selection_"
                                , Elm.list
                                    (queryOperation.arguments
                                        |> List.map
                                            (\argument ->
                                                Elm.tuple
                                                    [ Elm.string argument.name
                                                    , let
                                                        convert type__ =
                                                            case type__ of
                                                                GraphQL.Schema.Type.Scalar scalarName ->
                                                                    Elm.apply
                                                                        [ Common.modules.engine.args.fns.scalar
                                                                        , Elm.fqFun Common.modules.scalar.codecs.fqName (String.decapitalize scalarName)
                                                                        , Elm.access (Elm.val "req") argument.name
                                                                        ]

                                                                GraphQL.Schema.Type.Enum enumName ->
                                                                    Elm.apply
                                                                        [ Common.modules.engine.args.fns.scalar
                                                                        , Common.modules.engine.args.fns.enum
                                                                        , Elm.fqFun [ "TnGql", "Enum", enumName ] "decoder"
                                                                        , Elm.access (Elm.val "req") argument.name
                                                                        ]

                                                                GraphQL.Schema.Type.InputObject inputObject ->
                                                                    Elm.apply
                                                                        [ Common.modules.engine.args.fns.scalar
                                                                        , Elm.fqFun [ "TnGql", "InputObject", inputObject ] "decoder"
                                                                        , Elm.access (Elm.val "req") argument.name
                                                                        ]

                                                                GraphQL.Schema.Type.Nullable innerType ->
                                                                    -- bugbug pretty sure the inner decoder
                                                                    -- needs to be instructed to handle null
                                                                    -- but I'm just glossing over that for now
                                                                    convert innerType

                                                                _ ->
                                                                    Elm.string "unimplemented"
                                                      in
                                                      convert argument.type_
                                                    ]
                                            )
                                    )
                                ]
                            )

                    testVal =
                        Elm.valDecl Nothing (Just type_) queryOperation.name expression
                in
                { name = moduleName
                , file =
                    Elm.file module_
                        [ Common.modules.decode.import_
                        ]
                        [ testVal ]
                        Nothing
                }
             -- { name = queryOperation.name
             -- , signature = type_
             -- , implementation = expression
             -- }
            )

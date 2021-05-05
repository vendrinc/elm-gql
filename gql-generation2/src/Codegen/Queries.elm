module Codegen.Queries exposing (generateFiles)

import Codegen.Common as Common
import Codegen.ElmCodegenUtil as Elm
import Dict
import Elm.CodeGen as Elm
import GraphQL.Schema
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String



-- target
-- app : { slug : Maybe String, id : Maybe String } -> GraphQL.Engine.Selection TnGql.Object.App value -> GraphQL.Engine.Selection GraphQL.Engine.Query value
-- app =
--     \required selection ->
--     GraphQL.Engine.objectWith
--         [ ("slug", GraphQL.Engine.ArgValue (Maybe.map Json.Encode.string required.slug |> Maybe.withDefault Json.Encode.null) "string")
--         , ("id", GraphQL.Engine.ArgValue (Maybe.map Json.Encode.string required.id |> Maybe.withDefault Json.Encode.null) "string")
--         ]
--         "app"
--         selection


queryToModule : GraphQL.Schema.Query -> Common.File
queryToModule queryOperation =
    let
        linkage =
            Elm.emptyLinkage
                |> Elm.addImport (Elm.importStmt [ "GraphQL", "Engine" ] Nothing Nothing)

        -- GQL.Query (Maybe value)
        returnType =
            Elm.typed "GraphQL.Engine.Selection" [ Elm.typed "GraphQL.Engine.Query" [], Elm.typed "value" [] ]

        ( inputType, argumentsLinkage ) =
            queryOperation.arguments
                |> List.foldl
                    (\argument ( argumentTypeAcc, linkageAcc ) ->
                        let
                            ( argumentTypeAnnotation, argumentTypeLinkage ) =
                                Common.gqlTypeToElmTypeAnnotation argument.type_ Nothing
                        in
                        ( ( argument.name, argumentTypeAnnotation ) :: argumentTypeAcc, argumentTypeLinkage :: linkageAcc )
                    )
                    ( [], [] )
                |> Tuple.mapFirst Elm.recordAnn
                |> Tuple.mapSecond Elm.combineLinkage

        ( type_, functionAnnotationLinkage ) =
            let
                ( innerOperationType, linkage____ ) =
                    Common.gqlTypeToElmTypeAnnotation queryOperation.type_ Nothing

                operationType =
                    Elm.typed "GraphQL.Engine.Selection" [ innerOperationType, Elm.typeVar "value" ]
            in
            ( Elm.funAnn inputType
                (Elm.funAnn
                    operationType
                    returnType
                )
            , linkage____
            )

        expression =
            Elm.lambda [ Elm.varPattern "required", Elm.varPattern "selection" ]
                (Elm.apply
                    [ Elm.fqVal [ "GraphQL", "Engine" ] "objectWith"
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
                                                            [ Elm.fqVal [ "GraphQL", "Engine" ] "ArgValue"
                                                            , Elm.parens
                                                                (Elm.apply
                                                                    [ Elm.fqVal [ "GraphQL", "Engine" ] "maybeScalarEncode"
                                                                    , Elm.fqVal [ "Json", "Encode" ] (String.decapitalize scalarName)
                                                                    , Elm.access (Elm.val "required") argument.name
                                                                    ]
                                                                )
                                                            , Elm.string (String.decapitalize scalarName)
                                                            ]

                                                    GraphQL.Schema.Type.Enum enumName ->
                                                        Elm.apply
                                                            [ Common.modules.engine.args.fns.scalar
                                                            , Common.modules.engine.args.fns.enum
                                                            , Elm.fqFun [ "TnGql", "Enum", enumName ] "decoder"
                                                            , Elm.access (Elm.val "required") argument.name
                                                            ]

                                                    GraphQL.Schema.Type.InputObject inputObject ->
                                                        Elm.apply
                                                            [ Common.modules.engine.args.fns.scalar
                                                            , Elm.fqFun [ "TnGql", "InputObject", inputObject ] "decoder"
                                                            , Elm.access (Elm.val "required") argument.name
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
                    , Elm.string queryOperation.name
                    , Elm.val "selection"
                    ]
                )

        queryFunction =
            Elm.valDecl Nothing (Just type_) queryOperation.name expression

        moduleName =
            [ "TnGql", "Queries", String.toSentenceCase queryOperation.name ]

        ( imports_, exposing_ ) =
            linkage
                |> Elm.addImport Common.modules.decode.import_
                |> Elm.addImport Common.modules.encode.import_
                |> Elm.mergeLinkage argumentsLinkage
                |> Elm.mergeLinkage functionAnnotationLinkage
    in
    { name = moduleName
    , file =
        Elm.file (Elm.normalModule moduleName [])
            imports_
            [ queryFunction ]
            Nothing
    }


generateFiles : GraphQL.Schema.Schema -> List Common.File
generateFiles graphQLSchema =
    graphQLSchema.queries
        |> Dict.toList
        |> List.map Tuple.second
        |> List.map queryToModule

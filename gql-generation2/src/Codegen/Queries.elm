module Codegen.Queries exposing (generateFiles)

import Codegen.Common as Common
import Codegen.ElmCodegenUtil as Elm
import Dict
import Elm.CodeGen as Elm
import GraphQL.Schema
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String


queryToModule : GraphQL.Schema.Query -> Common.File
queryToModule queryOperation =
    let
        linkage =
            Elm.emptyLinkage
                |> Elm.addImport (Elm.importStmt [ "GraphQL", "Engine" ] Nothing Nothing)

        -- GQL.Query (Maybe value)
        returnType =
            Elm.typed "GraphQL.Engine.Query" [ Elm.typed "Maybe" [ Elm.typed "value" [] ] ]

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
                ( operationType, linkage____ ) =
                    Common.gqlTypeToElmTypeAnnotation queryOperation.type_ (Just [ Elm.typeVar "value" ])
            in
            ( Elm.funAnn inputType
                (Elm.funAnn
                    operationType
                    returnType
                )
            , linkage____
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
                                                            , Elm.access Common.modules.scalar.exports.codec (String.decapitalize scalarName)

                                                            -- , Elm.fqFun Common.modules.scalar.codecs.fqName (String.decapitalize scalarName)
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

        queryFunction =
            Elm.valDecl Nothing (Just type_) queryOperation.name expression

        moduleName =
            [ "TnGql", "Queries", String.toSentenceCase queryOperation.name ]

        ( imports_, exposing_ ) =
            linkage
                |> Elm.addImport Common.modules.decode.import_
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

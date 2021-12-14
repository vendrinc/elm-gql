module Generate.Operations exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Generate.Args
import Generate.Example
import Generate.Input as Input
import GraphQL.Schema exposing (Namespace)
import Utils.String


queryToModule : Namespace -> Input.Operation -> GraphQL.Schema.Schema -> GraphQL.Schema.Operation -> Elm.File
queryToModule namespace op schema operation =
    let
        dir =
            directory op

        queryFunction =
            Generate.Args.createBuilder namespace
                schema
                operation.name
                operation.arguments
                operation.type_
                op

        example =
            Generate.Example.example namespace
                schema
                operation.name
                operation.arguments
                operation.type_
                op

        optionalHelpers =
            if List.any Input.isOptional operation.arguments then
                let
                    topLevelAlias =
                        Elm.alias "Optional"
                            (Engine.types_.optional
                                (Elm.Annotation.named [ namespace.namespace ]
                                    (case op of
                                        Input.Query ->
                                            operation.name ++ "_Option"

                                        Input.Mutation ->
                                            operation.name ++ "_MutOption"
                                    )
                                )
                            )
                            |> Elm.expose

                    optional =
                        List.filter Input.isOptional operation.arguments
                in
                topLevelAlias
                    :: Generate.Args.optionsRecursive namespace
                        schema
                        operation.name
                        optional
                    ++ [ Generate.Args.nullsRecord namespace operation.name optional
                            |> Elm.declaration "null"
                            |> Elm.expose
                       ]

            else
                []
    in
    Elm.fileWith
        [ namespace.namespace
        , dir
        , Utils.String.formatTypename operation.name
        ]
        { docs =
            \docs ->
                "\n\nExample usage:\n\n"
                    ++ Elm.expressionImports example
                    ++ "\n\n\n"
                    ++ Elm.toString example
        , aliases = []
        }
        (queryFunction :: optionalHelpers)


directory : Input.Operation -> String
directory op =
    case op of
        Input.Query ->
            "Queries"

        Input.Mutation ->
            "Mutations"


generateFiles : Namespace -> Input.Operation -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace op schema =
    case op of
        Input.Mutation ->
            schema.mutations
                |> Dict.toList
                |> List.map
                    (\( _, oper ) ->
                        queryToModule namespace op schema oper
                    )

        Input.Query ->
            schema.queries
                |> Dict.toList
                |> List.map
                    (\( _, oper ) ->
                        queryToModule namespace op schema oper
                    )

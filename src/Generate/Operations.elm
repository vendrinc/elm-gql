module Generate.Operations exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Generate.Args
import Generate.Example
import Generate.Input
import GraphQL.Schema
import GraphQL.Schema.Operation
import String.Extra as String
import Generate.Input

queryToModule : String -> Generate.Args.Operation -> GraphQL.Schema.Schema -> GraphQL.Schema.Operation.Operation -> Elm.File
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
                (case op of
                    Generate.Args.Query ->
                        Generate.Input.Query

                    Generate.Args.Mutation ->
                        Generate.Input.Mutation
                )

        optionalHelpers =
            if List.any Generate.Input.isOptional operation.arguments then
                let
                    topLevelAlias =
                        Elm.aliasWith "Optional"
                            []
                            (Engine.typeOptional.annotation
                                (Elm.Annotation.named (Elm.moduleName [ namespace ])
                                    (case op of
                                        Generate.Args.Query ->
                                            operation.name ++ "_Option"

                                        Generate.Args.Mutation ->
                                            operation.name ++ "_MutOption"
                                    )
                                )
                            )
                            |> Elm.expose

                    optional =
                        List.filter Generate.Input.isOptional operation.arguments
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
    Elm.file
        (Elm.moduleName
            [ namespace
            , dir
            , String.toSentenceCase operation.name
            ]
        )
        ("\n\nExample usage:\n\n"
            ++ Elm.expressionImportsToString example
            ++ "\n\n\n"
            ++ Elm.expressionToString example
        )
        (queryFunction :: optionalHelpers)


directory : Generate.Args.Operation -> String
directory op =
    case op of
        Generate.Args.Query ->
            "Queries"

        Generate.Args.Mutation ->
            "Mutations"


generateFiles : String -> Generate.Args.Operation -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace op schema =
    case op of
        Generate.Args.Mutation ->
            schema.mutations
                |> Dict.toList
                |> List.map
                    (\( _, oper ) ->
                        queryToModule namespace op schema oper
                    )

        Generate.Args.Query ->
            schema.queries
                |> Dict.toList
                |> List.map
                    (\( _, oper ) ->
                        queryToModule namespace op schema oper
                    )

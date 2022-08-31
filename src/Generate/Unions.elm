module Generate.Unions exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Gen.GraphQL.Engine as Engine
import Generate.Common as Common
import GraphQL.Schema exposing (Namespace)
import Utils.String


enumNameToConstructorName : String -> String
enumNameToConstructorName =
    Utils.String.formatValue


generateFiles : Namespace -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace graphQLSchema =
    graphQLSchema.unions
        |> Dict.toList
        |> List.concatMap
            (\( _, unionDefinition ) ->
                let
                    record =
                        Elm.fn
                            ( "fragments"
                            , Elm.Annotation.record
                                (List.map
                                    (\var ->
                                        ( GraphQL.Schema.kindToString var.kind
                                        , Common.selection namespace.namespace
                                            (GraphQL.Schema.kindToString var.kind)
                                            (Elm.Annotation.var "data")
                                        )
                                    )
                                    unionDefinition.variants
                                )
                                |> Just
                            )
                            (\fragments ->
                                Engine.union
                                    (List.map
                                        (\var ->
                                            Elm.tuple
                                                (Elm.string (GraphQL.Schema.kindToString var.kind))
                                                (fragments
                                                    |> Elm.get (GraphQL.Schema.kindToString var.kind)
                                                    |> Engine.unsafe
                                                )
                                        )
                                        unionDefinition.variants
                                    )
                                    |> Elm.withType
                                        (Common.selection namespace.namespace
                                            unionDefinition.name
                                            (Elm.Annotation.var "data")
                                        )
                            )
                            |> Elm.declaration unionDefinition.name
                in
                [ record
                    |> Elm.expose
                ]
            )
        |> Elm.file [ namespace.namespace, "Unions" ]
        |> List.singleton

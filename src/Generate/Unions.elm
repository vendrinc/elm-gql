module Generate.Unions exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Generate.Common as Common
import GraphQL.Schema
import GraphQL.Schema.Kind
import String.Extra as String


enumNameToConstructorName =
    String.toSentenceCase


generateFiles : String -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace graphQLSchema =
    graphQLSchema.unions
        |> Dict.toList
        |> List.concatMap
            (\( _, unionDefinition ) ->
                let
                    record =
                        Elm.fn unionDefinition.name
                            ( "fragments"
                            , Elm.Annotation.record
                                (List.map
                                    (\var ->
                                        ( GraphQL.Schema.Kind.toString var.kind
                                        , 
                                          Common.selection namespace
                                            (GraphQL.Schema.Kind.toString var.kind)
                                            (Elm.Annotation.var "data")
                                        )
                                    )
                                    unionDefinition.variants
                                )
                            )
                            (\fragments ->
                                Engine.union
                                    (Elm.list
                                        (List.map
                                            (\var ->
                                                Elm.tuple
                                                    (Elm.string (GraphQL.Schema.Kind.toString var.kind))
                                                    (fragments
                                                        |> Elm.get (GraphQL.Schema.Kind.toString var.kind)
                                                        |> Engine.unsafe
                                                    )
                                            )
                                            unionDefinition.variants
                                        )
                                    )
                                    |> Elm.withAnnotation
                                        
                                        (Common.selection namespace
                                            unionDefinition.name
                                            (Elm.Annotation.var "data")
                                        )
                            )
                in
                [ record
                    |> Elm.expose
                ]
            )
        |> Elm.file (Elm.moduleName [ namespace, "Unions" ])
            ""
        |> List.singleton

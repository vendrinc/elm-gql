module Generate.Root exposing (generate)

{-| This is the base `{Namespace}` file that has everything you need to launch queries.
-}

import Dict
import Elm
import Elm.Annotation as Type
import Gen.GraphQL.Engine as Engine
import Gen.Json.Decode as Json
import Gen.Platform.Cmd
import Gen.Result
import Generate.Common as Common
import Generate.Scalar
import GraphQL.Schema exposing (Namespace)
import Utils.String


groups =
    { mutations = "Mutations"
    , queries = "Queries"
    , maps = "Batching and Mapping"
    }


groupOrder :
    { group : Maybe String
    , members : List String
    }
    -> Int
groupOrder group =
    case group.group of
        Nothing ->
            1000

        Just name ->
            if name == groups.queries then
                1

            else if name == groups.mutations then
                2

            else
                3


generate : Namespace -> GraphQL.Schema.Schema -> Elm.File
generate namespace schema =
    Elm.fileWith [ namespace.namespace ]
        { docs =
            \docs ->
                "This is a file used by `elm-gql` to decode your GraphQL scalars."
                    :: "You'll need to maintain it and ensure that each scalar type is being encoded and decoded correctly!"
                    :: (docs
                            |> List.sortBy groupOrder
                            |> List.map Elm.docs
                       )
        , aliases = []
        }
        ([ Elm.alias "Query"
            (Engine.annotation_.selection
                Engine.annotation_.query
                (Type.var "data")
            )
            |> Elm.exposeWith
                { exposeConstructor = True
                , group = Just groups.queries
                }
         , Elm.alias "Mutation"
            (Engine.annotation_.selection
                Engine.annotation_.mutation
                (Type.var "data")
            )
            |> Elm.exposeWith
                { exposeConstructor = True
                , group = Just groups.mutations
                }
         , Elm.declaration "query"
            (Elm.fn2
                ( "sel", Just (Type.namedWith [] "Query" [ Type.var "data" ]) )
                ( "options"
                , Just
                    (Type.record
                        [ ( "headers", Type.list (Type.named [ "Http" ] "Header") )
                        , ( "url", Type.string )
                        , ( "timeout", Type.maybe Type.float )
                        , ( "tracker", Type.maybe Type.string )
                        ]
                    )
                )
                (\sel options ->
                    Engine.call_.query sel options
                        |> Elm.withType
                            (Gen.Platform.Cmd.annotation_.cmd
                                (Gen.Result.annotation_.result
                                    Engine.annotation_.error
                                    (Type.var "data")
                                )
                            )
                )
            )
            |> Elm.exposeWith
                { exposeConstructor = True
                , group = Just groups.queries
                }
         , Elm.declaration "mutation"
            (Elm.fn2
                ( "sel", Just (Type.namedWith [] "Mutation" [ Type.var "data" ]) )
                ( "options"
                , Just
                    (Type.record
                        [ ( "headers", Type.list (Type.named [ "Http" ] "Header") )
                        , ( "url", Type.string )
                        , ( "timeout", Type.maybe Type.float )
                        , ( "tracker", Type.maybe Type.string )
                        ]
                    )
                )
                (\sel options ->
                    Engine.call_.mutation sel options
                        |> Elm.withType
                            (Gen.Platform.Cmd.annotation_.cmd
                                (Gen.Result.annotation_.result
                                    Engine.annotation_.error
                                    (Type.var "data")
                                )
                            )
                )
            )
            |> Elm.exposeWith
                { exposeConstructor = True
                , group = Just groups.mutations
                }
         , Elm.declaration "batch"
            Engine.values_.batch
            |> Elm.exposeWith
                { exposeConstructor = True
                , group = Just groups.maps
                }
         , Elm.declaration "map"
            Engine.values_.map
            |> Elm.exposeWith
                { exposeConstructor = True
                , group = Just groups.maps
                }
         , Elm.declaration "map2"
            Engine.values_.map2
            |> Elm.exposeWith
                { exposeConstructor = True
                , group = Just groups.maps
                }
         ]
            ++ Generate.Scalar.generate namespace schema
        )

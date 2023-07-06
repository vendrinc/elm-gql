module Gen.GraphQL.Engine exposing (annotation_, batch, call_, caseOf_, make_, map, map2, mapRequest, moduleName_, mutation, mutationRisky, mutationRiskyTask, mutationTask, operation, query, queryRisky, queryRiskyTask, queryString, queryTask, select, send, simulate, subscription, values_, versionedAlias, versionedName, withName)

{-| 
@docs moduleName_, queryString, mutationRiskyTask, queryRiskyTask, mutationRisky, queryRisky, mutationTask, queryTask, mutation, query, subscription, simulate, send, mapRequest, versionedAlias, versionedName, operation, map2, map, withName, select, batch, annotation_, make_, caseOf_, call_, values_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Engine" ]


{-| {-| -}

queryString: String -> Selection source data -> String
-}
queryString : String -> Elm.Expression -> Elm.Expression
queryString queryStringArg queryStringArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "queryString"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        Type.string
                    )
            }
        )
        [ Elm.string queryStringArg, queryStringArg0 ]


{-| {-| -}

mutationRiskyTask: 
    Selection Mutation value
    -> { headers : List Http.Header, url : String, timeout : Maybe Float }
    -> Task Error value
-}
mutationRiskyTask :
    Elm.Expression
    -> { headers : List Elm.Expression, url : String, timeout : Elm.Expression }
    -> Elm.Expression
mutationRiskyTask mutationRiskyTaskArg mutationRiskyTaskArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mutationRiskyTask"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Mutation" []
                            , Type.var "value"
                            ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Task"
                            [ Type.namedWith [] "Error" [], Type.var "value" ]
                        )
                    )
            }
        )
        [ mutationRiskyTaskArg
        , Elm.record
            [ Tuple.pair "headers" (Elm.list mutationRiskyTaskArg0.headers)
            , Tuple.pair "url" (Elm.string mutationRiskyTaskArg0.url)
            , Tuple.pair "timeout" mutationRiskyTaskArg0.timeout
            ]
        ]


{-| {-| -}

queryRiskyTask: 
    Selection Query value
    -> { headers : List Http.Header, url : String, timeout : Maybe Float }
    -> Task Error value
-}
queryRiskyTask :
    Elm.Expression
    -> { headers : List Elm.Expression, url : String, timeout : Elm.Expression }
    -> Elm.Expression
queryRiskyTask queryRiskyTaskArg queryRiskyTaskArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "queryRiskyTask"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "value" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Task"
                            [ Type.namedWith [] "Error" [], Type.var "value" ]
                        )
                    )
            }
        )
        [ queryRiskyTaskArg
        , Elm.record
            [ Tuple.pair "headers" (Elm.list queryRiskyTaskArg0.headers)
            , Tuple.pair "url" (Elm.string queryRiskyTaskArg0.url)
            , Tuple.pair "timeout" queryRiskyTaskArg0.timeout
            ]
        ]


{-| {-| -}

mutationRisky: 
    Selection Mutation msg
    -> { headers : List Http.Header
    , url : String
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Cmd (Result Error msg)
-}
mutationRisky :
    Elm.Expression
    -> { headers : List Elm.Expression
    , url : String
    , timeout : Elm.Expression
    , tracker : Elm.Expression
    }
    -> Elm.Expression
mutationRisky mutationRiskyArg mutationRiskyArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mutationRisky"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Mutation" [], Type.var "msg" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            , ( "tracker"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Cmd"
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [] "Error" [], Type.var "msg" ]
                            ]
                        )
                    )
            }
        )
        [ mutationRiskyArg
        , Elm.record
            [ Tuple.pair "headers" (Elm.list mutationRiskyArg0.headers)
            , Tuple.pair "url" (Elm.string mutationRiskyArg0.url)
            , Tuple.pair "timeout" mutationRiskyArg0.timeout
            , Tuple.pair "tracker" mutationRiskyArg0.tracker
            ]
        ]


{-| {-| -}

queryRisky: 
    Selection Query value
    -> { headers : List Http.Header
    , url : String
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Cmd (Result Error value)
-}
queryRisky :
    Elm.Expression
    -> { headers : List Elm.Expression
    , url : String
    , timeout : Elm.Expression
    , tracker : Elm.Expression
    }
    -> Elm.Expression
queryRisky queryRiskyArg queryRiskyArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "queryRisky"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "value" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            , ( "tracker"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Cmd"
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [] "Error" []
                                , Type.var "value"
                                ]
                            ]
                        )
                    )
            }
        )
        [ queryRiskyArg
        , Elm.record
            [ Tuple.pair "headers" (Elm.list queryRiskyArg0.headers)
            , Tuple.pair "url" (Elm.string queryRiskyArg0.url)
            , Tuple.pair "timeout" queryRiskyArg0.timeout
            , Tuple.pair "tracker" queryRiskyArg0.tracker
            ]
        ]


{-| {-| -}

mutationTask: 
    Selection Mutation value
    -> { headers : List Http.Header, url : String, timeout : Maybe Float }
    -> Task Error value
-}
mutationTask :
    Elm.Expression
    -> { headers : List Elm.Expression, url : String, timeout : Elm.Expression }
    -> Elm.Expression
mutationTask mutationTaskArg mutationTaskArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mutationTask"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Mutation" []
                            , Type.var "value"
                            ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Task"
                            [ Type.namedWith [] "Error" [], Type.var "value" ]
                        )
                    )
            }
        )
        [ mutationTaskArg
        , Elm.record
            [ Tuple.pair "headers" (Elm.list mutationTaskArg0.headers)
            , Tuple.pair "url" (Elm.string mutationTaskArg0.url)
            , Tuple.pair "timeout" mutationTaskArg0.timeout
            ]
        ]


{-| {-| -}

queryTask: 
    Selection Query value
    -> { headers : List Http.Header, url : String, timeout : Maybe Float }
    -> Task Error value
-}
queryTask :
    Elm.Expression
    -> { headers : List Elm.Expression, url : String, timeout : Elm.Expression }
    -> Elm.Expression
queryTask queryTaskArg queryTaskArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "queryTask"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "value" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Task"
                            [ Type.namedWith [] "Error" [], Type.var "value" ]
                        )
                    )
            }
        )
        [ queryTaskArg
        , Elm.record
            [ Tuple.pair "headers" (Elm.list queryTaskArg0.headers)
            , Tuple.pair "url" (Elm.string queryTaskArg0.url)
            , Tuple.pair "timeout" queryTaskArg0.timeout
            ]
        ]


{-| {-| -}

mutation: 
    Selection Mutation msg
    -> { headers : List Http.Header
    , url : String
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Cmd (Result Error msg)
-}
mutation :
    Elm.Expression
    -> { headers : List Elm.Expression
    , url : String
    , timeout : Elm.Expression
    , tracker : Elm.Expression
    }
    -> Elm.Expression
mutation mutationArg mutationArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mutation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Mutation" [], Type.var "msg" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            , ( "tracker"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Cmd"
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [] "Error" [], Type.var "msg" ]
                            ]
                        )
                    )
            }
        )
        [ mutationArg
        , Elm.record
            [ Tuple.pair "headers" (Elm.list mutationArg0.headers)
            , Tuple.pair "url" (Elm.string mutationArg0.url)
            , Tuple.pair "timeout" mutationArg0.timeout
            , Tuple.pair "tracker" mutationArg0.tracker
            ]
        ]


{-| {-| -}

query: 
    Selection Query value
    -> { headers : List Http.Header
    , url : String
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Cmd (Result Error value)
-}
query :
    Elm.Expression
    -> { headers : List Elm.Expression
    , url : String
    , timeout : Elm.Expression
    , tracker : Elm.Expression
    }
    -> Elm.Expression
query queryArg queryArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "query"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "value" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            , ( "tracker"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Cmd"
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [] "Error" []
                                , Type.var "value"
                                ]
                            ]
                        )
                    )
            }
        )
        [ queryArg
        , Elm.record
            [ Tuple.pair "headers" (Elm.list queryArg0.headers)
            , Tuple.pair "url" (Elm.string queryArg0.url)
            , Tuple.pair "timeout" queryArg0.timeout
            , Tuple.pair "tracker" queryArg0.tracker
            ]
        ]


{-| {-| -}

subscription: 
    Selection Subscription data
    -> { payload : Json.Encode.Value, decoder : Json.Decode.Decoder data }
-}
subscription : Elm.Expression -> Elm.Expression
subscription subscriptionArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "subscription"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Subscription" []
                            , Type.var "data"
                            ]
                        ]
                        (Type.record
                            [ ( "payload"
                              , Type.namedWith [ "Json", "Encode" ] "Value" []
                              )
                            , ( "decoder"
                              , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "data" ]
                              )
                            ]
                        )
                    )
            }
        )
        [ subscriptionArg ]


{-| {-| -}

simulate: 
    { toHeader : String -> String -> header
    , toExpectation : (Http.Response String -> Result Error value) -> expectation
    , toBody : Json.Encode.Value -> body
    , toRequest :
        { method : String
        , headers : List header
        , url : String
        , body : body
        , expect : expectation
        , timeout : Maybe Float
        , tracker : Maybe String
        }
        -> simulated
    }
    -> Request value
    -> simulated
-}
simulate :
    { toHeader : Elm.Expression -> Elm.Expression -> Elm.Expression
    , toExpectation : Elm.Expression -> Elm.Expression
    , toBody : Elm.Expression -> Elm.Expression
    , toRequest : Elm.Expression -> Elm.Expression
    }
    -> Elm.Expression
    -> Elm.Expression
simulate simulateArg simulateArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "simulate"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "toHeader"
                              , Type.function
                                    [ Type.string, Type.string ]
                                    (Type.var "header")
                              )
                            , ( "toExpectation"
                              , Type.function
                                    [ Type.function
                                        [ Type.namedWith
                                            [ "Http" ]
                                            "Response"
                                            [ Type.string ]
                                        ]
                                        (Type.namedWith
                                            []
                                            "Result"
                                            [ Type.namedWith [] "Error" []
                                            , Type.var "value"
                                            ]
                                        )
                                    ]
                                    (Type.var "expectation")
                              )
                            , ( "toBody"
                              , Type.function
                                    [ Type.namedWith
                                        [ "Json", "Encode" ]
                                        "Value"
                                        []
                                    ]
                                    (Type.var "body")
                              )
                            , ( "toRequest"
                              , Type.function
                                    [ Type.record
                                        [ ( "method", Type.string )
                                        , ( "headers"
                                          , Type.list (Type.var "header")
                                          )
                                        , ( "url", Type.string )
                                        , ( "body", Type.var "body" )
                                        , ( "expect", Type.var "expectation" )
                                        , ( "timeout"
                                          , Type.namedWith
                                                []
                                                "Maybe"
                                                [ Type.float ]
                                          )
                                        , ( "tracker"
                                          , Type.namedWith
                                                []
                                                "Maybe"
                                                [ Type.string ]
                                          )
                                        ]
                                    ]
                                    (Type.var "simulated")
                              )
                            ]
                        , Type.namedWith [] "Request" [ Type.var "value" ]
                        ]
                        (Type.var "simulated")
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair
                "toHeader"
                (Elm.functionReduced
                    "simulateUnpack"
                    (\functionReducedUnpack ->
                        Elm.functionReduced
                            "unpack"
                            (simulateArg.toHeader functionReducedUnpack)
                    )
                )
            , Tuple.pair
                "toExpectation"
                (Elm.functionReduced "simulateUnpack" simulateArg.toExpectation)
            , Tuple.pair
                "toBody"
                (Elm.functionReduced "simulateUnpack" simulateArg.toBody)
            , Tuple.pair
                "toRequest"
                (Elm.functionReduced "simulateUnpack" simulateArg.toRequest)
            ]
        , simulateArg0
        ]


{-| {-| -}

send: Request data -> Cmd (Result Error data)
-}
send : Elm.Expression -> Elm.Expression
send sendArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "send"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Request" [ Type.var "data" ] ]
                        (Type.namedWith
                            []
                            "Cmd"
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [] "Error" []
                                , Type.var "data"
                                ]
                            ]
                        )
                    )
            }
        )
        [ sendArg ]


{-| {-| -}

mapRequest: (a -> b) -> Request a -> Request b
-}
mapRequest :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
mapRequest mapRequestArg mapRequestArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mapRequest"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "a" ] (Type.var "b")
                        , Type.namedWith [] "Request" [ Type.var "a" ]
                        ]
                        (Type.namedWith [] "Request" [ Type.var "b" ])
                    )
            }
        )
        [ Elm.functionReduced "mapRequestUnpack" mapRequestArg, mapRequestArg0 ]


{-| {-| Slightly different than versioned name, this is specific to only making an alias if the version is not 0.

so if I'm selecting a field "myField"

Then

    versionedAlias 0 "myField"
        -> "myField"

but

    versionedAlias 1 "myField"
        -> "myField\_batch\_1: myField"

-}

versionedAlias: Int -> String -> String
-}
versionedAlias : Int -> String -> Elm.Expression
versionedAlias versionedAliasArg versionedAliasArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "versionedAlias"
            , annotation =
                Just (Type.function [ Type.int, Type.string ] Type.string)
            }
        )
        [ Elm.int versionedAliasArg, Elm.string versionedAliasArg0 ]


{-| versionedName: Int -> String -> String -}
versionedName : Int -> String -> Elm.Expression
versionedName versionedNameArg versionedNameArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "versionedName"
            , annotation =
                Just (Type.function [ Type.int, Type.string ] Type.string)
            }
        )
        [ Elm.int versionedNameArg, Elm.string versionedNameArg0 ]


{-| {-| -}

operation: 
    Maybe String
    -> (Int
    -> { args : List ( String, VariableDetails )
    , body : String
    , fragments : String
    })
    -> (Int -> Json.Decode.Decoder data)
    -> Selection source data
-}
operation :
    Elm.Expression
    -> (Elm.Expression -> Elm.Expression)
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
operation operationArg operationArg0 operationArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "operation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Maybe" [ Type.string ]
                        , Type.function
                            [ Type.int ]
                            (Type.record
                                [ ( "args"
                                  , Type.list
                                        (Type.tuple
                                            Type.string
                                            (Type.namedWith
                                                []
                                                "VariableDetails"
                                                []
                                            )
                                        )
                                  )
                                , ( "body", Type.string )
                                , ( "fragments", Type.string )
                                ]
                            )
                        , Type.function
                            [ Type.int ]
                            (Type.namedWith
                                [ "Json", "Decode" ]
                                "Decoder"
                                [ Type.var "data" ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
        )
        [ operationArg
        , Elm.functionReduced "operationUnpack" operationArg0
        , Elm.functionReduced "operationUnpack" operationArg1
        ]


{-| {-| -}

map2: (a -> b -> c) -> Selection source a -> Selection source b -> Selection source c
-}
map2 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map2 map2Arg map2Arg0 map2Arg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "map2"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a", Type.var "b" ]
                            (Type.var "c")
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "a" ]
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "b" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "c" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced
            "map2Unpack"
            (\functionReducedUnpack ->
                Elm.functionReduced "unpack" (map2Arg functionReducedUnpack)
            )
        , map2Arg0
        , map2Arg1
        ]


{-| {-| -}

map: (a -> b) -> Selection source a -> Selection source b
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map mapArg mapArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "map"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "a" ] (Type.var "b")
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "a" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "b" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced "mapUnpack" mapArg, mapArg0 ]


{-| withName: String -> Selection source data -> Selection source data -}
withName : String -> Elm.Expression -> Elm.Expression
withName withNameArg withNameArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "withName"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
        )
        [ Elm.string withNameArg, withNameArg0 ]


{-| {-| -}

select: data -> Selection source data
-}
select : Elm.Expression -> Elm.Expression
select selectArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "select"
            , annotation =
                Just
                    (Type.function
                        [ Type.var "data" ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
        )
        [ selectArg ]


{-| {-| Batch a number of selection sets together!
-}

batch: List (Selection source data) -> Selection source (List data)
-}
batch : List Elm.Expression -> Elm.Expression
batch batchArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "batch"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith
                                []
                                "Selection"
                                [ Type.var "source", Type.var "data" ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.list (Type.var "data") ]
                        )
                    )
            }
        )
        [ Elm.list batchArg ]


annotation_ :
    { error : Type.Annotation
    , request : Type.Annotation -> Type.Annotation
    , subscription : Type.Annotation
    , mutation : Type.Annotation
    , query : Type.Annotation
    , option : Type.Annotation -> Type.Annotation
    , selection : Type.Annotation -> Type.Annotation -> Type.Annotation
    }
annotation_ =
    { error = Type.namedWith [ "GraphQL", "Engine" ] "Error" []
    , request =
        \requestArg0 ->
            Type.namedWith [ "GraphQL", "Engine" ] "Request" [ requestArg0 ]
    , subscription = Type.namedWith [ "GraphQL", "Engine" ] "Subscription" []
    , mutation = Type.namedWith [ "GraphQL", "Engine" ] "Mutation" []
    , query = Type.namedWith [ "GraphQL", "Engine" ] "Query" []
    , option =
        \optionArg0 ->
            Type.namedWith [ "GraphQL", "Engine" ] "Option" [ optionArg0 ]
    , selection =
        \selectionArg0 selectionArg1 ->
            Type.namedWith
                [ "GraphQL", "Engine" ]
                "Selection"
                [ selectionArg0, selectionArg1 ]
    }


make_ :
    { badUrl : Elm.Expression -> Elm.Expression
    , timeout : Elm.Expression
    , networkError : Elm.Expression
    , badStatus : Elm.Expression -> Elm.Expression
    , badBody : Elm.Expression -> Elm.Expression
    , present : Elm.Expression -> Elm.Expression
    , null : Elm.Expression
    , absent : Elm.Expression
    }
make_ =
    { badUrl =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "BadUrl"
                    , annotation = Just (Type.namedWith [] "Error" [])
                    }
                )
                [ ar0 ]
    , timeout =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "Timeout"
            , annotation = Just (Type.namedWith [] "Error" [])
            }
    , networkError =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "NetworkError"
            , annotation = Just (Type.namedWith [] "Error" [])
            }
    , badStatus =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "BadStatus"
                    , annotation = Just (Type.namedWith [] "Error" [])
                    }
                )
                [ ar0 ]
    , badBody =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "BadBody"
                    , annotation = Just (Type.namedWith [] "Error" [])
                    }
                )
                [ ar0 ]
    , present =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "Present"
                    , annotation =
                        Just (Type.namedWith [] "Option" [ Type.var "value" ])
                    }
                )
                [ ar0 ]
    , null =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "Null"
            , annotation =
                Just (Type.namedWith [] "Option" [ Type.var "value" ])
            }
    , absent =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "Absent"
            , annotation =
                Just (Type.namedWith [] "Option" [ Type.var "value" ])
            }
    }


caseOf_ :
    { error :
        Elm.Expression
        -> { errorTags_0_0
            | badUrl : Elm.Expression -> Elm.Expression
            , timeout : Elm.Expression
            , networkError : Elm.Expression
            , badStatus : Elm.Expression -> Elm.Expression
            , badBody : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , option :
        Elm.Expression
        -> { optionTags_1_0
            | present : Elm.Expression -> Elm.Expression
            , null : Elm.Expression
            , absent : Elm.Expression
        }
        -> Elm.Expression
    }
caseOf_ =
    { error =
        \errorExpression errorTags ->
            Elm.Case.custom
                errorExpression
                (Type.namedWith [ "GraphQL", "Engine" ] "Error" [])
                [ Elm.Case.branch1
                    "BadUrl"
                    ( "string.String", Type.string )
                    errorTags.badUrl
                , Elm.Case.branch0 "Timeout" errorTags.timeout
                , Elm.Case.branch0 "NetworkError" errorTags.networkError
                , Elm.Case.branch1
                    "BadStatus"
                    ( "one"
                    , Type.record
                        [ ( "status", Type.int )
                        , ( "responseBody", Type.string )
                        ]
                    )
                    errorTags.badStatus
                , Elm.Case.branch1
                    "BadBody"
                    ( "one"
                    , Type.record
                        [ ( "decodingError", Type.string )
                        , ( "responseBody", Type.string )
                        ]
                    )
                    errorTags.badBody
                ]
    , option =
        \optionExpression optionTags ->
            Elm.Case.custom
                optionExpression
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Option"
                    [ Type.var "value" ]
                )
                [ Elm.Case.branch1
                    "Present"
                    ( "value", Type.var "value" )
                    optionTags.present
                , Elm.Case.branch0 "Null" optionTags.null
                , Elm.Case.branch0 "Absent" optionTags.absent
                ]
    }


call_ :
    { queryString : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutationRiskyTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , queryRiskyTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutationRisky : Elm.Expression -> Elm.Expression -> Elm.Expression
    , queryRisky : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutationTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , queryTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutation : Elm.Expression -> Elm.Expression -> Elm.Expression
    , query : Elm.Expression -> Elm.Expression -> Elm.Expression
    , subscription : Elm.Expression -> Elm.Expression
    , simulate : Elm.Expression -> Elm.Expression -> Elm.Expression
    , send : Elm.Expression -> Elm.Expression
    , mapRequest : Elm.Expression -> Elm.Expression -> Elm.Expression
    , versionedAlias : Elm.Expression -> Elm.Expression -> Elm.Expression
    , versionedName : Elm.Expression -> Elm.Expression -> Elm.Expression
    , operation :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , map2 :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , map : Elm.Expression -> Elm.Expression -> Elm.Expression
    , withName : Elm.Expression -> Elm.Expression -> Elm.Expression
    , select : Elm.Expression -> Elm.Expression
    , batch : Elm.Expression -> Elm.Expression
    }
call_ =
    { queryString =
        \queryStringArg queryStringArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "queryString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                ]
                                Type.string
                            )
                    }
                )
                [ queryStringArg, queryStringArg0 ]
    , mutationRiskyTask =
        \mutationRiskyTaskArg mutationRiskyTaskArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "mutationRiskyTask"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Mutation" []
                                    , Type.var "value"
                                    ]
                                , Type.record
                                    [ ( "headers"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Http" ]
                                                "Header"
                                                []
                                            )
                                      )
                                    , ( "url", Type.string )
                                    , ( "timeout"
                                      , Type.namedWith [] "Maybe" [ Type.float ]
                                      )
                                    ]
                                ]
                                (Type.namedWith
                                    []
                                    "Task"
                                    [ Type.namedWith [] "Error" []
                                    , Type.var "value"
                                    ]
                                )
                            )
                    }
                )
                [ mutationRiskyTaskArg, mutationRiskyTaskArg0 ]
    , queryRiskyTask =
        \queryRiskyTaskArg queryRiskyTaskArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "queryRiskyTask"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Query" []
                                    , Type.var "value"
                                    ]
                                , Type.record
                                    [ ( "headers"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Http" ]
                                                "Header"
                                                []
                                            )
                                      )
                                    , ( "url", Type.string )
                                    , ( "timeout"
                                      , Type.namedWith [] "Maybe" [ Type.float ]
                                      )
                                    ]
                                ]
                                (Type.namedWith
                                    []
                                    "Task"
                                    [ Type.namedWith [] "Error" []
                                    , Type.var "value"
                                    ]
                                )
                            )
                    }
                )
                [ queryRiskyTaskArg, queryRiskyTaskArg0 ]
    , mutationRisky =
        \mutationRiskyArg mutationRiskyArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "mutationRisky"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Mutation" []
                                    , Type.var "msg"
                                    ]
                                , Type.record
                                    [ ( "headers"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Http" ]
                                                "Header"
                                                []
                                            )
                                      )
                                    , ( "url", Type.string )
                                    , ( "timeout"
                                      , Type.namedWith [] "Maybe" [ Type.float ]
                                      )
                                    , ( "tracker"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.string ]
                                      )
                                    ]
                                ]
                                (Type.namedWith
                                    []
                                    "Cmd"
                                    [ Type.namedWith
                                        []
                                        "Result"
                                        [ Type.namedWith [] "Error" []
                                        , Type.var "msg"
                                        ]
                                    ]
                                )
                            )
                    }
                )
                [ mutationRiskyArg, mutationRiskyArg0 ]
    , queryRisky =
        \queryRiskyArg queryRiskyArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "queryRisky"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Query" []
                                    , Type.var "value"
                                    ]
                                , Type.record
                                    [ ( "headers"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Http" ]
                                                "Header"
                                                []
                                            )
                                      )
                                    , ( "url", Type.string )
                                    , ( "timeout"
                                      , Type.namedWith [] "Maybe" [ Type.float ]
                                      )
                                    , ( "tracker"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.string ]
                                      )
                                    ]
                                ]
                                (Type.namedWith
                                    []
                                    "Cmd"
                                    [ Type.namedWith
                                        []
                                        "Result"
                                        [ Type.namedWith [] "Error" []
                                        , Type.var "value"
                                        ]
                                    ]
                                )
                            )
                    }
                )
                [ queryRiskyArg, queryRiskyArg0 ]
    , mutationTask =
        \mutationTaskArg mutationTaskArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "mutationTask"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Mutation" []
                                    , Type.var "value"
                                    ]
                                , Type.record
                                    [ ( "headers"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Http" ]
                                                "Header"
                                                []
                                            )
                                      )
                                    , ( "url", Type.string )
                                    , ( "timeout"
                                      , Type.namedWith [] "Maybe" [ Type.float ]
                                      )
                                    ]
                                ]
                                (Type.namedWith
                                    []
                                    "Task"
                                    [ Type.namedWith [] "Error" []
                                    , Type.var "value"
                                    ]
                                )
                            )
                    }
                )
                [ mutationTaskArg, mutationTaskArg0 ]
    , queryTask =
        \queryTaskArg queryTaskArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "queryTask"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Query" []
                                    , Type.var "value"
                                    ]
                                , Type.record
                                    [ ( "headers"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Http" ]
                                                "Header"
                                                []
                                            )
                                      )
                                    , ( "url", Type.string )
                                    , ( "timeout"
                                      , Type.namedWith [] "Maybe" [ Type.float ]
                                      )
                                    ]
                                ]
                                (Type.namedWith
                                    []
                                    "Task"
                                    [ Type.namedWith [] "Error" []
                                    , Type.var "value"
                                    ]
                                )
                            )
                    }
                )
                [ queryTaskArg, queryTaskArg0 ]
    , mutation =
        \mutationArg mutationArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "mutation"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Mutation" []
                                    , Type.var "msg"
                                    ]
                                , Type.record
                                    [ ( "headers"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Http" ]
                                                "Header"
                                                []
                                            )
                                      )
                                    , ( "url", Type.string )
                                    , ( "timeout"
                                      , Type.namedWith [] "Maybe" [ Type.float ]
                                      )
                                    , ( "tracker"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.string ]
                                      )
                                    ]
                                ]
                                (Type.namedWith
                                    []
                                    "Cmd"
                                    [ Type.namedWith
                                        []
                                        "Result"
                                        [ Type.namedWith [] "Error" []
                                        , Type.var "msg"
                                        ]
                                    ]
                                )
                            )
                    }
                )
                [ mutationArg, mutationArg0 ]
    , query =
        \queryArg queryArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "query"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Query" []
                                    , Type.var "value"
                                    ]
                                , Type.record
                                    [ ( "headers"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Http" ]
                                                "Header"
                                                []
                                            )
                                      )
                                    , ( "url", Type.string )
                                    , ( "timeout"
                                      , Type.namedWith [] "Maybe" [ Type.float ]
                                      )
                                    , ( "tracker"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.string ]
                                      )
                                    ]
                                ]
                                (Type.namedWith
                                    []
                                    "Cmd"
                                    [ Type.namedWith
                                        []
                                        "Result"
                                        [ Type.namedWith [] "Error" []
                                        , Type.var "value"
                                        ]
                                    ]
                                )
                            )
                    }
                )
                [ queryArg, queryArg0 ]
    , subscription =
        \subscriptionArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "subscription"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Subscription" []
                                    , Type.var "data"
                                    ]
                                ]
                                (Type.record
                                    [ ( "payload"
                                      , Type.namedWith
                                            [ "Json", "Encode" ]
                                            "Value"
                                            []
                                      )
                                    , ( "decoder"
                                      , Type.namedWith
                                            [ "Json", "Decode" ]
                                            "Decoder"
                                            [ Type.var "data" ]
                                      )
                                    ]
                                )
                            )
                    }
                )
                [ subscriptionArg ]
    , simulate =
        \simulateArg simulateArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "simulate"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "toHeader"
                                      , Type.function
                                            [ Type.string, Type.string ]
                                            (Type.var "header")
                                      )
                                    , ( "toExpectation"
                                      , Type.function
                                            [ Type.function
                                                [ Type.namedWith
                                                    [ "Http" ]
                                                    "Response"
                                                    [ Type.string ]
                                                ]
                                                (Type.namedWith
                                                    []
                                                    "Result"
                                                    [ Type.namedWith
                                                        []
                                                        "Error"
                                                        []
                                                    , Type.var "value"
                                                    ]
                                                )
                                            ]
                                            (Type.var "expectation")
                                      )
                                    , ( "toBody"
                                      , Type.function
                                            [ Type.namedWith
                                                [ "Json", "Encode" ]
                                                "Value"
                                                []
                                            ]
                                            (Type.var "body")
                                      )
                                    , ( "toRequest"
                                      , Type.function
                                            [ Type.record
                                                [ ( "method", Type.string )
                                                , ( "headers"
                                                  , Type.list
                                                        (Type.var "header")
                                                  )
                                                , ( "url", Type.string )
                                                , ( "body", Type.var "body" )
                                                , ( "expect"
                                                  , Type.var "expectation"
                                                  )
                                                , ( "timeout"
                                                  , Type.namedWith
                                                        []
                                                        "Maybe"
                                                        [ Type.float ]
                                                  )
                                                , ( "tracker"
                                                  , Type.namedWith
                                                        []
                                                        "Maybe"
                                                        [ Type.string ]
                                                  )
                                                ]
                                            ]
                                            (Type.var "simulated")
                                      )
                                    ]
                                , Type.namedWith
                                    []
                                    "Request"
                                    [ Type.var "value" ]
                                ]
                                (Type.var "simulated")
                            )
                    }
                )
                [ simulateArg, simulateArg0 ]
    , send =
        \sendArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "send"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Request"
                                    [ Type.var "data" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Cmd"
                                    [ Type.namedWith
                                        []
                                        "Result"
                                        [ Type.namedWith [] "Error" []
                                        , Type.var "data"
                                        ]
                                    ]
                                )
                            )
                    }
                )
                [ sendArg ]
    , mapRequest =
        \mapRequestArg mapRequestArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "mapRequest"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function [ Type.var "a" ] (Type.var "b")
                                , Type.namedWith [] "Request" [ Type.var "a" ]
                                ]
                                (Type.namedWith [] "Request" [ Type.var "b" ])
                            )
                    }
                )
                [ mapRequestArg, mapRequestArg0 ]
    , versionedAlias =
        \versionedAliasArg versionedAliasArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "versionedAlias"
                    , annotation =
                        Just
                            (Type.function [ Type.int, Type.string ] Type.string
                            )
                    }
                )
                [ versionedAliasArg, versionedAliasArg0 ]
    , versionedName =
        \versionedNameArg versionedNameArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "versionedName"
                    , annotation =
                        Just
                            (Type.function [ Type.int, Type.string ] Type.string
                            )
                    }
                )
                [ versionedNameArg, versionedNameArg0 ]
    , operation =
        \operationArg operationArg0 operationArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "operation"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Maybe" [ Type.string ]
                                , Type.function
                                    [ Type.int ]
                                    (Type.record
                                        [ ( "args"
                                          , Type.list
                                                (Type.tuple
                                                    Type.string
                                                    (Type.namedWith
                                                        []
                                                        "VariableDetails"
                                                        []
                                                    )
                                                )
                                          )
                                        , ( "body", Type.string )
                                        , ( "fragments", Type.string )
                                        ]
                                    )
                                , Type.function
                                    [ Type.int ]
                                    (Type.namedWith
                                        [ "Json", "Decode" ]
                                        "Decoder"
                                        [ Type.var "data" ]
                                    )
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                )
                            )
                    }
                )
                [ operationArg, operationArg0, operationArg1 ]
    , map2 =
        \map2Arg map2Arg0 map2Arg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "map2"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a", Type.var "b" ]
                                    (Type.var "c")
                                , Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "a" ]
                                , Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "b" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "c" ]
                                )
                            )
                    }
                )
                [ map2Arg, map2Arg0, map2Arg1 ]
    , map =
        \mapArg mapArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "map"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function [ Type.var "a" ] (Type.var "b")
                                , Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "a" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "b" ]
                                )
                            )
                    }
                )
                [ mapArg, mapArg0 ]
    , withName =
        \withNameArg withNameArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "withName"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                )
                            )
                    }
                )
                [ withNameArg, withNameArg0 ]
    , select =
        \selectArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "select"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.var "data" ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                )
                            )
                    }
                )
                [ selectArg ]
    , batch =
        \batchArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "batch"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.namedWith
                                        []
                                        "Selection"
                                        [ Type.var "source", Type.var "data" ]
                                    )
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source"
                                    , Type.list (Type.var "data")
                                    ]
                                )
                            )
                    }
                )
                [ batchArg ]
    }


values_ :
    { queryString : Elm.Expression
    , mutationRiskyTask : Elm.Expression
    , queryRiskyTask : Elm.Expression
    , mutationRisky : Elm.Expression
    , queryRisky : Elm.Expression
    , mutationTask : Elm.Expression
    , queryTask : Elm.Expression
    , mutation : Elm.Expression
    , query : Elm.Expression
    , subscription : Elm.Expression
    , simulate : Elm.Expression
    , send : Elm.Expression
    , mapRequest : Elm.Expression
    , versionedAlias : Elm.Expression
    , versionedName : Elm.Expression
    , operation : Elm.Expression
    , map2 : Elm.Expression
    , map : Elm.Expression
    , withName : Elm.Expression
    , select : Elm.Expression
    , batch : Elm.Expression
    }
values_ =
    { queryString =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "queryString"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        Type.string
                    )
            }
    , mutationRiskyTask =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mutationRiskyTask"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Mutation" []
                            , Type.var "value"
                            ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Task"
                            [ Type.namedWith [] "Error" [], Type.var "value" ]
                        )
                    )
            }
    , queryRiskyTask =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "queryRiskyTask"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "value" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Task"
                            [ Type.namedWith [] "Error" [], Type.var "value" ]
                        )
                    )
            }
    , mutationRisky =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mutationRisky"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Mutation" [], Type.var "msg" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            , ( "tracker"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Cmd"
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [] "Error" [], Type.var "msg" ]
                            ]
                        )
                    )
            }
    , queryRisky =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "queryRisky"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "value" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            , ( "tracker"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Cmd"
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [] "Error" []
                                , Type.var "value"
                                ]
                            ]
                        )
                    )
            }
    , mutationTask =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mutationTask"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Mutation" []
                            , Type.var "value"
                            ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Task"
                            [ Type.namedWith [] "Error" [], Type.var "value" ]
                        )
                    )
            }
    , queryTask =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "queryTask"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "value" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Task"
                            [ Type.namedWith [] "Error" [], Type.var "value" ]
                        )
                    )
            }
    , mutation =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mutation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Mutation" [], Type.var "msg" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            , ( "tracker"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Cmd"
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [] "Error" [], Type.var "msg" ]
                            ]
                        )
                    )
            }
    , query =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "query"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "value" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list
                                    (Type.namedWith [ "Http" ] "Header" [])
                              )
                            , ( "url", Type.string )
                            , ( "timeout"
                              , Type.namedWith [] "Maybe" [ Type.float ]
                              )
                            , ( "tracker"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Cmd"
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [] "Error" []
                                , Type.var "value"
                                ]
                            ]
                        )
                    )
            }
    , subscription =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "subscription"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Subscription" []
                            , Type.var "data"
                            ]
                        ]
                        (Type.record
                            [ ( "payload"
                              , Type.namedWith [ "Json", "Encode" ] "Value" []
                              )
                            , ( "decoder"
                              , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "data" ]
                              )
                            ]
                        )
                    )
            }
    , simulate =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "simulate"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "toHeader"
                              , Type.function
                                    [ Type.string, Type.string ]
                                    (Type.var "header")
                              )
                            , ( "toExpectation"
                              , Type.function
                                    [ Type.function
                                        [ Type.namedWith
                                            [ "Http" ]
                                            "Response"
                                            [ Type.string ]
                                        ]
                                        (Type.namedWith
                                            []
                                            "Result"
                                            [ Type.namedWith [] "Error" []
                                            , Type.var "value"
                                            ]
                                        )
                                    ]
                                    (Type.var "expectation")
                              )
                            , ( "toBody"
                              , Type.function
                                    [ Type.namedWith
                                        [ "Json", "Encode" ]
                                        "Value"
                                        []
                                    ]
                                    (Type.var "body")
                              )
                            , ( "toRequest"
                              , Type.function
                                    [ Type.record
                                        [ ( "method", Type.string )
                                        , ( "headers"
                                          , Type.list (Type.var "header")
                                          )
                                        , ( "url", Type.string )
                                        , ( "body", Type.var "body" )
                                        , ( "expect", Type.var "expectation" )
                                        , ( "timeout"
                                          , Type.namedWith
                                                []
                                                "Maybe"
                                                [ Type.float ]
                                          )
                                        , ( "tracker"
                                          , Type.namedWith
                                                []
                                                "Maybe"
                                                [ Type.string ]
                                          )
                                        ]
                                    ]
                                    (Type.var "simulated")
                              )
                            ]
                        , Type.namedWith [] "Request" [ Type.var "value" ]
                        ]
                        (Type.var "simulated")
                    )
            }
    , send =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "send"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Request" [ Type.var "data" ] ]
                        (Type.namedWith
                            []
                            "Cmd"
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [] "Error" []
                                , Type.var "data"
                                ]
                            ]
                        )
                    )
            }
    , mapRequest =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mapRequest"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "a" ] (Type.var "b")
                        , Type.namedWith [] "Request" [ Type.var "a" ]
                        ]
                        (Type.namedWith [] "Request" [ Type.var "b" ])
                    )
            }
    , versionedAlias =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "versionedAlias"
            , annotation =
                Just (Type.function [ Type.int, Type.string ] Type.string)
            }
    , versionedName =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "versionedName"
            , annotation =
                Just (Type.function [ Type.int, Type.string ] Type.string)
            }
    , operation =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "operation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Maybe" [ Type.string ]
                        , Type.function
                            [ Type.int ]
                            (Type.record
                                [ ( "args"
                                  , Type.list
                                        (Type.tuple
                                            Type.string
                                            (Type.namedWith
                                                []
                                                "VariableDetails"
                                                []
                                            )
                                        )
                                  )
                                , ( "body", Type.string )
                                , ( "fragments", Type.string )
                                ]
                            )
                        , Type.function
                            [ Type.int ]
                            (Type.namedWith
                                [ "Json", "Decode" ]
                                "Decoder"
                                [ Type.var "data" ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
    , map2 =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "map2"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a", Type.var "b" ]
                            (Type.var "c")
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "a" ]
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "b" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "c" ]
                        )
                    )
            }
    , map =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "map"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "a" ] (Type.var "b")
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "a" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "b" ]
                        )
                    )
            }
    , withName =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "withName"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
    , select =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "select"
            , annotation =
                Just
                    (Type.function
                        [ Type.var "data" ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
    , batch =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "batch"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith
                                []
                                "Selection"
                                [ Type.var "source", Type.var "data" ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.list (Type.var "data") ]
                        )
                    )
            }
    }
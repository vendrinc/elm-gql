module Gen.GraphQL.Engine exposing (annotation_, batch, call_, caseOf_, encodeVariables, make_, map, map2, mapRequest, moduleName_, mutation, mutationRisky, mutationRiskyTask, mutationTask, mutationToTestingDetails, operation, query, queryRisky, queryRiskyTask, queryString, queryTask, queryToTestingDetails, select, selectionVariables, send, subscription, values_, versionedAlias, versionedName, withName)

{-| 
@docs moduleName_, queryString, encodeVariables, selectionVariables, mutationRiskyTask, queryRiskyTask, mutationRisky, queryRisky, mutationTask, queryTask, mutation, query, subscription, mutationToTestingDetails, queryToTestingDetails, send, mapRequest, versionedAlias, versionedName, operation, map2, map, withName, select, batch, annotation_, make_, caseOf_, call_, values_
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


{-| encodeVariables: Dict String VariableDetails -> Json.Encode.Value -}
encodeVariables : Elm.Expression -> Elm.Expression
encodeVariables encodeVariablesArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeVariables"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Dict"
                            [ Type.string
                            , Type.namedWith [] "VariableDetails" []
                            ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ encodeVariablesArg ]


{-| selectionVariables: Selection source data -> Dict String VariableDetails -}
selectionVariables : Elm.Expression -> Elm.Expression
selectionVariables selectionVariablesArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "selectionVariables"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Dict"
                            [ Type.string
                            , Type.namedWith [] "VariableDetails" []
                            ]
                        )
                    )
            }
        )
        [ selectionVariablesArg ]


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

mutationToTestingDetails: 
    Selection Mutation data
    -> { payload : Json.Encode.Value, decoder : Json.Decode.Decoder data }
-}
mutationToTestingDetails : Elm.Expression -> Elm.Expression
mutationToTestingDetails mutationToTestingDetailsArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mutationToTestingDetails"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Mutation" [], Type.var "data" ]
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
        [ mutationToTestingDetailsArg ]


{-| {-| -}

queryToTestingDetails: 
    Selection Query data
    -> { payload : Json.Encode.Value, decoder : Json.Decode.Decoder data }
-}
queryToTestingDetails : Elm.Expression -> Elm.Expression
queryToTestingDetails queryToTestingDetailsArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "queryToTestingDetails"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "data" ]
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
        [ queryToTestingDetailsArg ]


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
    { location : Type.Annotation
    , gqlError : Type.Annotation
    , variableDetails : Type.Annotation
    , error : Type.Annotation
    , request : Type.Annotation -> Type.Annotation
    , subscription : Type.Annotation
    , mutation : Type.Annotation
    , query : Type.Annotation
    , option : Type.Annotation -> Type.Annotation
    , selection : Type.Annotation -> Type.Annotation -> Type.Annotation
    }
annotation_ =
    { location =
        Type.alias
            moduleName_
            "Location"
            []
            (Type.record [ ( "line", Type.int ), ( "column", Type.int ) ])
    , gqlError =
        Type.alias
            moduleName_
            "GqlError"
            []
            (Type.record
                [ ( "message", Type.string )
                , ( "path"
                  , Type.namedWith [] "Maybe" [ Type.list Type.string ]
                  )
                , ( "locations"
                  , Type.namedWith
                        []
                        "Maybe"
                        [ Type.list (Type.namedWith [] "Location" []) ]
                  )
                , ( "extensions"
                  , Type.namedWith
                        []
                        "Maybe"
                        [ Type.namedWith [ "Json", "Decode" ] "Value" [] ]
                  )
                ]
            )
    , variableDetails =
        Type.alias
            moduleName_
            "VariableDetails"
            []
            (Type.record
                [ ( "gqlTypeName", Type.string )
                , ( "value"
                  , Type.namedWith
                        []
                        "Maybe"
                        [ Type.namedWith [ "Json", "Encode" ] "Value" [] ]
                  )
                ]
            )
    , error = Type.namedWith [ "GraphQL", "Engine" ] "Error" []
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
    { location :
        { line : Elm.Expression, column : Elm.Expression } -> Elm.Expression
    , gqlError :
        { message : Elm.Expression
        , path : Elm.Expression
        , locations : Elm.Expression
        , extensions : Elm.Expression
        }
        -> Elm.Expression
    , variableDetails :
        { gqlTypeName : Elm.Expression, value : Elm.Expression }
        -> Elm.Expression
    , badUrl : Elm.Expression -> Elm.Expression
    , timeout : Elm.Expression
    , networkError : Elm.Expression
    , badStatus : Elm.Expression -> Elm.Expression
    , badBody : Elm.Expression -> Elm.Expression
    , errorField : Elm.Expression -> Elm.Expression
    , present : Elm.Expression -> Elm.Expression
    , null : Elm.Expression
    , absent : Elm.Expression
    }
make_ =
    { location =
        \location_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Engine" ]
                    "Location"
                    []
                    (Type.record
                        [ ( "line", Type.int ), ( "column", Type.int ) ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "line" location_args.line
                    , Tuple.pair "column" location_args.column
                    ]
                )
    , gqlError =
        \gqlError_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Engine" ]
                    "GqlError"
                    []
                    (Type.record
                        [ ( "message", Type.string )
                        , ( "path"
                          , Type.namedWith [] "Maybe" [ Type.list Type.string ]
                          )
                        , ( "locations"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.list (Type.namedWith [] "Location" []) ]
                          )
                        , ( "extensions"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [ "Json", "Decode" ] "Value" []
                                ]
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "message" gqlError_args.message
                    , Tuple.pair "path" gqlError_args.path
                    , Tuple.pair "locations" gqlError_args.locations
                    , Tuple.pair "extensions" gqlError_args.extensions
                    ]
                )
    , variableDetails =
        \variableDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Engine" ]
                    "VariableDetails"
                    []
                    (Type.record
                        [ ( "gqlTypeName", Type.string )
                        , ( "value"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [ "Json", "Encode" ] "Value" []
                                ]
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "gqlTypeName" variableDetails_args.gqlTypeName
                    , Tuple.pair "value" variableDetails_args.value
                    ]
                )
    , badUrl =
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
    , errorField =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "ErrorField"
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
            , errorField : Elm.Expression -> Elm.Expression
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
                , Elm.Case.branch1
                    "ErrorField"
                    ( "one"
                    , Type.record
                        [ ( "errors"
                          , Type.list (Type.namedWith [] "GqlError" [])
                          )
                        ]
                    )
                    errorTags.errorField
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
    , encodeVariables : Elm.Expression -> Elm.Expression
    , selectionVariables : Elm.Expression -> Elm.Expression
    , mutationRiskyTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , queryRiskyTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutationRisky : Elm.Expression -> Elm.Expression -> Elm.Expression
    , queryRisky : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutationTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , queryTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutation : Elm.Expression -> Elm.Expression -> Elm.Expression
    , query : Elm.Expression -> Elm.Expression -> Elm.Expression
    , subscription : Elm.Expression -> Elm.Expression
    , mutationToTestingDetails : Elm.Expression -> Elm.Expression
    , queryToTestingDetails : Elm.Expression -> Elm.Expression
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
    , encodeVariables =
        \encodeVariablesArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "encodeVariables"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Dict"
                                    [ Type.string
                                    , Type.namedWith [] "VariableDetails" []
                                    ]
                                ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ encodeVariablesArg ]
    , selectionVariables =
        \selectionVariablesArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "selectionVariables"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Dict"
                                    [ Type.string
                                    , Type.namedWith [] "VariableDetails" []
                                    ]
                                )
                            )
                    }
                )
                [ selectionVariablesArg ]
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
    , mutationToTestingDetails =
        \mutationToTestingDetailsArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "mutationToTestingDetails"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Mutation" []
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
                [ mutationToTestingDetailsArg ]
    , queryToTestingDetails =
        \queryToTestingDetailsArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "queryToTestingDetails"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Query" []
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
                [ queryToTestingDetailsArg ]
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
    , encodeVariables : Elm.Expression
    , selectionVariables : Elm.Expression
    , mutationRiskyTask : Elm.Expression
    , queryRiskyTask : Elm.Expression
    , mutationRisky : Elm.Expression
    , queryRisky : Elm.Expression
    , mutationTask : Elm.Expression
    , queryTask : Elm.Expression
    , mutation : Elm.Expression
    , query : Elm.Expression
    , subscription : Elm.Expression
    , mutationToTestingDetails : Elm.Expression
    , queryToTestingDetails : Elm.Expression
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
    , encodeVariables =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeVariables"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Dict"
                            [ Type.string
                            , Type.namedWith [] "VariableDetails" []
                            ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , selectionVariables =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "selectionVariables"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Dict"
                            [ Type.string
                            , Type.namedWith [] "VariableDetails" []
                            ]
                        )
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
    , mutationToTestingDetails =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mutationToTestingDetails"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Mutation" [], Type.var "data" ]
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
    , queryToTestingDetails =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "queryToTestingDetails"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "data" ]
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
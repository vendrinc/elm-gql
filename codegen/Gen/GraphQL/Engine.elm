module Gen.GraphQL.Engine exposing (addField, addOptionalField, andMap, annotation_, arg, argList, bakeToSelection, batch, call_, caseOf_, decode, decodeNullable, encodeArgument, encodeInputObject, encodeInputObjectAsJson, encodeOptionals, encodeOptionalsAsJson, enum, field, fieldWith, inputObject, inputObjectToFieldList, jsonField, list, make_, map, map2, mapRequest, maybeEnum, maybeScalarEncode, moduleName_, mutation, mutationRisky, mutationRiskyTask, mutationTask, nullable, object, objectWith, optional, query, queryRisky, queryRiskyTask, queryString, queryTask, recover, select, selectTypeNameButSkip, send, simulate, union, unsafe, values_, versionedAlias, versionedJsonField, versionedName, with, withName)

{-| 
@docs values_, call_, caseOf_, make_, annotation_, batch, recover, union, maybeEnum, enum, nullable, list, object, objectWith, decode, selectTypeNameButSkip, field, fieldWith, unsafe, withName, inputObject, addField, addOptionalField, arg, argList, inputObjectToFieldList, encodeInputObjectAsJson, encodeInputObject, encodeArgument, encodeOptionals, encodeOptionalsAsJson, optional, select, with, map, map2, bakeToSelection, mapRequest, send, simulate, query, mutation, queryTask, mutationTask, queryRisky, mutationRisky, queryRiskyTask, mutationRiskyTask, queryString, maybeScalarEncode, decodeNullable, versionedJsonField, versionedName, versionedAlias, jsonField, andMap, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Engine" ]


{-| andMap: Json.Decode.Decoder a -> Json.Decode.Decoder (a -> b) -> Json.Decode.Decoder b -}
andMap : Elm.Expression -> Elm.Expression -> Elm.Expression
andMap andMapArg andMapArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "andMap"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
        )
        [ andMapArg, andMapArg0 ]


{-| jsonField: 
    String
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
-}
jsonField : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
jsonField jsonFieldArg jsonFieldArg0 jsonFieldArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "jsonField"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
        )
        [ Elm.string jsonFieldArg, jsonFieldArg0, jsonFieldArg1 ]


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


{-| versionedJsonField: 
    Int
    -> String
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
-}
versionedJsonField :
    Int -> String -> Elm.Expression -> Elm.Expression -> Elm.Expression
versionedJsonField versionedJsonFieldArg versionedJsonFieldArg0 versionedJsonFieldArg1 versionedJsonFieldArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "versionedJsonField"
            , annotation =
                Just
                    (Type.function
                        [ Type.int
                        , Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
        )
        [ Elm.int versionedJsonFieldArg
        , Elm.string versionedJsonFieldArg0
        , versionedJsonFieldArg1
        , versionedJsonFieldArg2
        ]


{-| {-| -}

decodeNullable: Json.Decode.Decoder data -> Json.Decode.Decoder (Maybe data)
-}
decodeNullable : Elm.Expression -> Elm.Expression
decodeNullable decodeNullableArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "decodeNullable"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.namedWith [] "Maybe" [ Type.var "data" ] ]
                        )
                    )
            }
        )
        [ decodeNullableArg ]


{-| {-| -}

maybeScalarEncode: (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
-}
maybeScalarEncode :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
maybeScalarEncode maybeScalarEncodeArg maybeScalarEncodeArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "maybeScalarEncode"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [] "Maybe" [ Type.var "a" ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.functionReduced "maybeScalarEncodeUnpack" maybeScalarEncodeArg
        , maybeScalarEncodeArg0
        ]


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


{-| {-| -}

bakeToSelection: 
    Maybe String
    -> (Int
    -> { args : List ( String, VariableDetails )
    , body : String
    , fragments : String
    })
    -> (Int -> Json.Decode.Decoder data)
    -> Selection source data
-}
bakeToSelection :
    Elm.Expression
    -> (Elm.Expression -> Elm.Expression)
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
bakeToSelection bakeToSelectionArg bakeToSelectionArg0 bakeToSelectionArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "bakeToSelection"
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
        [ bakeToSelectionArg
        , Elm.functionReduced "bakeToSelectionUnpack" bakeToSelectionArg0
        , Elm.functionReduced "bakeToSelectionUnpack" bakeToSelectionArg1
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


{-| {-| -}

with: Selection source a -> Selection source (a -> b) -> Selection source b
-}
with : Elm.Expression -> Elm.Expression -> Elm.Expression
with withArg withArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "with"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "a" ]
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source"
                            , Type.function [ Type.var "a" ] (Type.var "b")
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "b" ]
                        )
                    )
            }
        )
        [ withArg, withArg0 ]


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


{-| {-|

    Encode the nullability in the argument itself.

-}

optional: String -> Argument arg -> Optional arg
-}
optional : String -> Elm.Expression -> Elm.Expression
optional optionalArg optionalArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "optional"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "Argument" [ Type.var "arg" ]
                        ]
                        (Type.namedWith [] "Optional" [ Type.var "arg" ])
                    )
            }
        )
        [ Elm.string optionalArg, optionalArg0 ]


{-| {-| -}

encodeOptionalsAsJson: List (Optional arg) -> List ( String, Json.Encode.Value )
-}
encodeOptionalsAsJson : List Elm.Expression -> Elm.Expression
encodeOptionalsAsJson encodeOptionalsAsJsonArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeOptionalsAsJson"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith [] "Optional" [ Type.var "arg" ])
                        ]
                        (Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                        )
                    )
            }
        )
        [ Elm.list encodeOptionalsAsJsonArg ]


{-| {-| -}

encodeOptionals: List (Optional arg) -> List ( String, Argument arg )
-}
encodeOptionals : List Elm.Expression -> Elm.Expression
encodeOptionals encodeOptionalsArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeOptionals"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith [] "Optional" [ Type.var "arg" ])
                        ]
                        (Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "Argument" [ Type.var "arg" ]
                                )
                            )
                        )
                    )
            }
        )
        [ Elm.list encodeOptionalsArg ]


{-| {-| -}

encodeArgument: Argument obj -> Json.Encode.Value
-}
encodeArgument : Elm.Expression -> Elm.Expression
encodeArgument encodeArgumentArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeArgument"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Argument" [ Type.var "obj" ] ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ encodeArgumentArg ]


{-| {-| -}

encodeInputObject: List ( String, Argument obj ) -> String -> Argument input
-}
encodeInputObject : List Elm.Expression -> String -> Elm.Expression
encodeInputObject encodeInputObjectArg encodeInputObjectArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeInputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "Argument" [ Type.var "obj" ]
                                )
                            )
                        , Type.string
                        ]
                        (Type.namedWith [] "Argument" [ Type.var "input" ])
                    )
            }
        )
        [ Elm.list encodeInputObjectArg, Elm.string encodeInputObjectArg0 ]


{-| {-| -}

encodeInputObjectAsJson: InputObject value -> Json.Decode.Value
-}
encodeInputObjectAsJson : Elm.Expression -> Elm.Expression
encodeInputObjectAsJson encodeInputObjectAsJsonArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeInputObjectAsJson"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "value" ] ]
                        (Type.namedWith [ "Json", "Decode" ] "Value" [])
                    )
            }
        )
        [ encodeInputObjectAsJsonArg ]


{-| {-| -}

inputObjectToFieldList: InputObject a -> List ( String, VariableDetails )
-}
inputObjectToFieldList : Elm.Expression -> Elm.Expression
inputObjectToFieldList inputObjectToFieldListArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "inputObjectToFieldList"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "a" ] ]
                        (Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "VariableDetails" [])
                            )
                        )
                    )
            }
        )
        [ inputObjectToFieldListArg ]


{-| {-| -}

argList: List (Argument obj) -> String -> Argument input
-}
argList : List Elm.Expression -> String -> Elm.Expression
argList argListArg argListArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "argList"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith [] "Argument" [ Type.var "obj" ])
                        , Type.string
                        ]
                        (Type.namedWith [] "Argument" [ Type.var "input" ])
                    )
            }
        )
        [ Elm.list argListArg, Elm.string argListArg0 ]


{-| {-| The encoded value and the name of the expected type for this argument
-}

arg: Json.Encode.Value -> String -> Argument obj
-}
arg : Elm.Expression -> String -> Elm.Expression
arg argArg argArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "arg"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Json", "Encode" ] "Value" []
                        , Type.string
                        ]
                        (Type.namedWith [] "Argument" [ Type.var "obj" ])
                    )
            }
        )
        [ argArg, Elm.string argArg0 ]


{-| {-| -}

addOptionalField: 
    String
    -> String
    -> Option value
    -> (value -> Json.Encode.Value)
    -> InputObject input
    -> InputObject input
-}
addOptionalField :
    String
    -> String
    -> Elm.Expression
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
addOptionalField addOptionalFieldArg addOptionalFieldArg0 addOptionalFieldArg1 addOptionalFieldArg2 addOptionalFieldArg3 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "addOptionalField"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [] "Option" [ Type.var "value" ]
                        , Type.function
                            [ Type.var "value" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [] "InputObject" [ Type.var "input" ]
                        ]
                        (Type.namedWith [] "InputObject" [ Type.var "input" ])
                    )
            }
        )
        [ Elm.string addOptionalFieldArg
        , Elm.string addOptionalFieldArg0
        , addOptionalFieldArg1
        , Elm.functionReduced "addOptionalFieldUnpack" addOptionalFieldArg2
        , addOptionalFieldArg3
        ]


{-| {-| -}

addField: String -> String -> Json.Encode.Value -> InputObject value -> InputObject value
-}
addField :
    String -> String -> Elm.Expression -> Elm.Expression -> Elm.Expression
addField addFieldArg addFieldArg0 addFieldArg1 addFieldArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "addField"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [ "Json", "Encode" ] "Value" []
                        , Type.namedWith [] "InputObject" [ Type.var "value" ]
                        ]
                        (Type.namedWith [] "InputObject" [ Type.var "value" ])
                    )
            }
        )
        [ Elm.string addFieldArg
        , Elm.string addFieldArg0
        , addFieldArg1
        , addFieldArg2
        ]


{-| {-| -}

inputObject: String -> InputObject value
-}
inputObject : String -> Elm.Expression
inputObject inputObjectArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "inputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith [] "InputObject" [ Type.var "value" ])
                    )
            }
        )
        [ Elm.string inputObjectArg ]


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

unsafe: Selection source selected -> Selection unsafe selected
-}
unsafe : Elm.Expression -> Elm.Expression
unsafe unsafeArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "unsafe"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "selected" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "unsafe", Type.var "selected" ]
                        )
                    )
            }
        )
        [ unsafeArg ]


{-| {-| -}

fieldWith: 
    InputObject args
    -> String
    -> String
    -> Json.Decode.Decoder data
    -> Selection source data
-}
fieldWith :
    Elm.Expression -> String -> String -> Elm.Expression -> Elm.Expression
fieldWith fieldWithArg fieldWithArg0 fieldWithArg1 fieldWithArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "fieldWith"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "args" ]
                        , Type.string
                        , Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
        )
        [ fieldWithArg
        , Elm.string fieldWithArg0
        , Elm.string fieldWithArg1
        , fieldWithArg2
        ]


{-| {-| -}

field: String -> String -> Json.Decode.Decoder data -> Selection source data
-}
field : String -> String -> Elm.Expression -> Elm.Expression
field fieldArg fieldArg0 fieldArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
        )
        [ Elm.string fieldArg, Elm.string fieldArg0, fieldArg1 ]


{-| {-| -}

selectTypeNameButSkip: Selection source ()
-}
selectTypeNameButSkip : Elm.Expression
selectTypeNameButSkip =
    Elm.value
        { importFrom = [ "GraphQL", "Engine" ]
        , name = "selectTypeNameButSkip"
        , annotation =
            Just
                (Type.namedWith [] "Selection" [ Type.var "source", Type.unit ])
        }


{-| {-| This adds a bare decoder for data that has already been pulled down.

Note, this is rarely needed! So far, only when a query or mutation returns a scalar directly without selecting any fields.

-}

decode: Json.Decode.Decoder data -> Selection source data
-}
decode : Elm.Expression -> Elm.Expression
decode decodeArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "decode"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
        )
        [ decodeArg ]


{-| {-| -}

objectWith: 
    InputObject args
    -> String
    -> Selection source data
    -> Selection otherSource data
-}
objectWith : Elm.Expression -> String -> Elm.Expression -> Elm.Expression
objectWith objectWithArg objectWithArg0 objectWithArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "objectWith"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "args" ]
                        , Type.string
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "otherSource", Type.var "data" ]
                        )
                    )
            }
        )
        [ objectWithArg, Elm.string objectWithArg0, objectWithArg1 ]


{-| {-| -}

object: String -> Selection source data -> Selection otherSource data
-}
object : String -> Elm.Expression -> Elm.Expression
object objectArg objectArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "object"
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
                            [ Type.var "otherSource", Type.var "data" ]
                        )
                    )
            }
        )
        [ Elm.string objectArg, objectArg0 ]


{-| {-| Used in generated code to handle maybes
-}

list: Selection source data -> Selection source (List data)
-}
list : Elm.Expression -> Elm.Expression
list listArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "list"
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
                            "Selection"
                            [ Type.var "source", Type.list (Type.var "data") ]
                        )
                    )
            }
        )
        [ listArg ]


{-| {-| Used in generated code to handle maybes
-}

nullable: Selection source data -> Selection source (Maybe data)
-}
nullable : Elm.Expression -> Elm.Expression
nullable nullableArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "nullable"
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
                            "Selection"
                            [ Type.var "source"
                            , Type.namedWith [] "Maybe" [ Type.var "data" ]
                            ]
                        )
                    )
            }
        )
        [ nullableArg ]


{-| {-| -}

enum: List ( String, item ) -> Json.Decode.Decoder item
-}
enum : List Elm.Expression -> Elm.Expression
enum enumArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "enum"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.tuple Type.string (Type.var "item")) ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "item" ]
                        )
                    )
            }
        )
        [ Elm.list enumArg ]


{-| {-| -}

maybeEnum: List ( String, item ) -> Json.Decode.Decoder (Maybe item)
-}
maybeEnum : List Elm.Expression -> Elm.Expression
maybeEnum maybeEnumArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "maybeEnum"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.tuple Type.string (Type.var "item")) ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.namedWith [] "Maybe" [ Type.var "item" ] ]
                        )
                    )
            }
        )
        [ Elm.list maybeEnumArg ]


{-| {-| -}

union: List ( String, Selection source data ) -> Selection source data
-}
union : List Elm.Expression -> Elm.Expression
union unionArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "union"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                )
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
        [ Elm.list unionArg ]


{-| {-| -}

recover: 
    recovered
    -> (data -> recovered)
    -> Selection source data
    -> Selection source recovered
-}
recover :
    Elm.Expression
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
recover recoverArg recoverArg0 recoverArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "recover"
            , annotation =
                Just
                    (Type.function
                        [ Type.var "recovered"
                        , Type.function
                            [ Type.var "data" ]
                            (Type.var "recovered")
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "recovered" ]
                        )
                    )
            }
        )
        [ recoverArg
        , Elm.functionReduced "recoverUnpack" recoverArg0
        , recoverArg1
        ]


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
    , mutation : Type.Annotation
    , query : Type.Annotation
    , optional : Type.Annotation -> Type.Annotation
    , inputObject : Type.Annotation -> Type.Annotation
    , option : Type.Annotation -> Type.Annotation
    , argument : Type.Annotation -> Type.Annotation
    , selection : Type.Annotation -> Type.Annotation -> Type.Annotation
    }
annotation_ =
    { error = Type.namedWith [ "GraphQL", "Engine" ] "Error" []
    , request =
        \requestArg0 ->
            Type.namedWith [ "GraphQL", "Engine" ] "Request" [ requestArg0 ]
    , mutation = Type.namedWith [ "GraphQL", "Engine" ] "Mutation" []
    , query = Type.namedWith [ "GraphQL", "Engine" ] "Query" []
    , optional =
        \optionalArg0 ->
            Type.namedWith [ "GraphQL", "Engine" ] "Optional" [ optionalArg0 ]
    , inputObject =
        \inputObjectArg0 ->
            Type.namedWith
                [ "GraphQL", "Engine" ]
                "InputObject"
                [ inputObjectArg0 ]
    , option =
        \optionArg0 ->
            Type.namedWith [ "GraphQL", "Engine" ] "Option" [ optionArg0 ]
    , argument =
        \argumentArg0 ->
            Type.namedWith [ "GraphQL", "Engine" ] "Argument" [ argumentArg0 ]
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
    , argValue : Elm.Expression -> Elm.Expression -> Elm.Expression
    , var : Elm.Expression -> Elm.Expression
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
    , argValue =
        \ar0 ar1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "ArgValue"
                    , annotation =
                        Just (Type.namedWith [] "Argument" [ Type.var "obj" ])
                    }
                )
                [ ar0, ar1 ]
    , var =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "Var"
                    , annotation =
                        Just (Type.namedWith [] "Argument" [ Type.var "obj" ])
                    }
                )
                [ ar0 ]
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
    , argument :
        Elm.Expression
        -> { argumentTags_2_0
            | argValue : Elm.Expression -> Elm.Expression -> Elm.Expression
            , var : Elm.Expression -> Elm.Expression
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
    , argument =
        \argumentExpression argumentTags ->
            Elm.Case.custom
                argumentExpression
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Argument"
                    [ Type.var "obj" ]
                )
                [ Elm.Case.branch2
                    "ArgValue"
                    ( "json.Encode.Value"
                    , Type.namedWith [ "Json", "Encode" ] "Value" []
                    )
                    ( "string.String", Type.string )
                    argumentTags.argValue
                , Elm.Case.branch1
                    "Var"
                    ( "string.String", Type.string )
                    argumentTags.var
                ]
    }


call_ :
    { andMap : Elm.Expression -> Elm.Expression -> Elm.Expression
    , jsonField :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , versionedAlias : Elm.Expression -> Elm.Expression -> Elm.Expression
    , versionedName : Elm.Expression -> Elm.Expression -> Elm.Expression
    , versionedJsonField :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , decodeNullable : Elm.Expression -> Elm.Expression
    , maybeScalarEncode : Elm.Expression -> Elm.Expression -> Elm.Expression
    , queryString : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutationRiskyTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , queryRiskyTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutationRisky : Elm.Expression -> Elm.Expression -> Elm.Expression
    , queryRisky : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutationTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , queryTask : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutation : Elm.Expression -> Elm.Expression -> Elm.Expression
    , query : Elm.Expression -> Elm.Expression -> Elm.Expression
    , simulate : Elm.Expression -> Elm.Expression -> Elm.Expression
    , send : Elm.Expression -> Elm.Expression
    , mapRequest : Elm.Expression -> Elm.Expression -> Elm.Expression
    , bakeToSelection :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , map2 :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , map : Elm.Expression -> Elm.Expression -> Elm.Expression
    , with : Elm.Expression -> Elm.Expression -> Elm.Expression
    , select : Elm.Expression -> Elm.Expression
    , optional : Elm.Expression -> Elm.Expression -> Elm.Expression
    , encodeOptionalsAsJson : Elm.Expression -> Elm.Expression
    , encodeOptionals : Elm.Expression -> Elm.Expression
    , encodeArgument : Elm.Expression -> Elm.Expression
    , encodeInputObject : Elm.Expression -> Elm.Expression -> Elm.Expression
    , encodeInputObjectAsJson : Elm.Expression -> Elm.Expression
    , inputObjectToFieldList : Elm.Expression -> Elm.Expression
    , argList : Elm.Expression -> Elm.Expression -> Elm.Expression
    , arg : Elm.Expression -> Elm.Expression -> Elm.Expression
    , addOptionalField :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , addField :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , inputObject : Elm.Expression -> Elm.Expression
    , withName : Elm.Expression -> Elm.Expression -> Elm.Expression
    , unsafe : Elm.Expression -> Elm.Expression
    , fieldWith :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , field :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , decode : Elm.Expression -> Elm.Expression
    , objectWith :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , object : Elm.Expression -> Elm.Expression -> Elm.Expression
    , list : Elm.Expression -> Elm.Expression
    , nullable : Elm.Expression -> Elm.Expression
    , enum : Elm.Expression -> Elm.Expression
    , maybeEnum : Elm.Expression -> Elm.Expression
    , union : Elm.Expression -> Elm.Expression
    , recover :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , batch : Elm.Expression -> Elm.Expression
    }
call_ =
    { andMap =
        \andMapArg andMapArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "andMap"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.function
                                        [ Type.var "a" ]
                                        (Type.var "b")
                                    ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                )
                            )
                    }
                )
                [ andMapArg, andMapArg0 ]
    , jsonField =
        \jsonFieldArg jsonFieldArg0 jsonFieldArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "jsonField"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.function
                                        [ Type.var "a" ]
                                        (Type.var "b")
                                    ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                )
                            )
                    }
                )
                [ jsonFieldArg, jsonFieldArg0, jsonFieldArg1 ]
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
    , versionedJsonField =
        \versionedJsonFieldArg versionedJsonFieldArg0 versionedJsonFieldArg1 versionedJsonFieldArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "versionedJsonField"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.int
                                , Type.string
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.function
                                        [ Type.var "a" ]
                                        (Type.var "b")
                                    ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                )
                            )
                    }
                )
                [ versionedJsonFieldArg
                , versionedJsonFieldArg0
                , versionedJsonFieldArg1
                , versionedJsonFieldArg2
                ]
    , decodeNullable =
        \decodeNullableArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "decodeNullable"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "data" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.namedWith
                                        []
                                        "Maybe"
                                        [ Type.var "data" ]
                                    ]
                                )
                            )
                    }
                )
                [ decodeNullableArg ]
    , maybeScalarEncode =
        \maybeScalarEncodeArg maybeScalarEncodeArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "maybeScalarEncode"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a" ]
                                    (Type.namedWith
                                        [ "Json", "Encode" ]
                                        "Value"
                                        []
                                    )
                                , Type.namedWith [] "Maybe" [ Type.var "a" ]
                                ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ maybeScalarEncodeArg, maybeScalarEncodeArg0 ]
    , queryString =
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
    , bakeToSelection =
        \bakeToSelectionArg bakeToSelectionArg0 bakeToSelectionArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "bakeToSelection"
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
                [ bakeToSelectionArg, bakeToSelectionArg0, bakeToSelectionArg1 ]
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
    , with =
        \withArg withArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "with"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "a" ]
                                , Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source"
                                    , Type.function
                                        [ Type.var "a" ]
                                        (Type.var "b")
                                    ]
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "b" ]
                                )
                            )
                    }
                )
                [ withArg, withArg0 ]
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
    , optional =
        \optionalArg optionalArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "optional"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith
                                    []
                                    "Argument"
                                    [ Type.var "arg" ]
                                ]
                                (Type.namedWith [] "Optional" [ Type.var "arg" ]
                                )
                            )
                    }
                )
                [ optionalArg, optionalArg0 ]
    , encodeOptionalsAsJson =
        \encodeOptionalsAsJsonArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "encodeOptionalsAsJson"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.namedWith
                                        []
                                        "Optional"
                                        [ Type.var "arg" ]
                                    )
                                ]
                                (Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith
                                            [ "Json", "Encode" ]
                                            "Value"
                                            []
                                        )
                                    )
                                )
                            )
                    }
                )
                [ encodeOptionalsAsJsonArg ]
    , encodeOptionals =
        \encodeOptionalsArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "encodeOptionals"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.namedWith
                                        []
                                        "Optional"
                                        [ Type.var "arg" ]
                                    )
                                ]
                                (Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith
                                            []
                                            "Argument"
                                            [ Type.var "arg" ]
                                        )
                                    )
                                )
                            )
                    }
                )
                [ encodeOptionalsArg ]
    , encodeArgument =
        \encodeArgumentArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "encodeArgument"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Argument"
                                    [ Type.var "obj" ]
                                ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ encodeArgumentArg ]
    , encodeInputObject =
        \encodeInputObjectArg encodeInputObjectArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "encodeInputObject"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith
                                            []
                                            "Argument"
                                            [ Type.var "obj" ]
                                        )
                                    )
                                , Type.string
                                ]
                                (Type.namedWith
                                    []
                                    "Argument"
                                    [ Type.var "input" ]
                                )
                            )
                    }
                )
                [ encodeInputObjectArg, encodeInputObjectArg0 ]
    , encodeInputObjectAsJson =
        \encodeInputObjectAsJsonArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "encodeInputObjectAsJson"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "value" ]
                                ]
                                (Type.namedWith [ "Json", "Decode" ] "Value" [])
                            )
                    }
                )
                [ encodeInputObjectAsJsonArg ]
    , inputObjectToFieldList =
        \inputObjectToFieldListArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "inputObjectToFieldList"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "a" ]
                                ]
                                (Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith [] "VariableDetails" [])
                                    )
                                )
                            )
                    }
                )
                [ inputObjectToFieldListArg ]
    , argList =
        \argListArg argListArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "argList"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.namedWith
                                        []
                                        "Argument"
                                        [ Type.var "obj" ]
                                    )
                                , Type.string
                                ]
                                (Type.namedWith
                                    []
                                    "Argument"
                                    [ Type.var "input" ]
                                )
                            )
                    }
                )
                [ argListArg, argListArg0 ]
    , arg =
        \argArg argArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "arg"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Json", "Encode" ] "Value" []
                                , Type.string
                                ]
                                (Type.namedWith [] "Argument" [ Type.var "obj" ]
                                )
                            )
                    }
                )
                [ argArg, argArg0 ]
    , addOptionalField =
        \addOptionalFieldArg addOptionalFieldArg0 addOptionalFieldArg1 addOptionalFieldArg2 addOptionalFieldArg3 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "addOptionalField"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.string
                                , Type.namedWith
                                    []
                                    "Option"
                                    [ Type.var "value" ]
                                , Type.function
                                    [ Type.var "value" ]
                                    (Type.namedWith
                                        [ "Json", "Encode" ]
                                        "Value"
                                        []
                                    )
                                , Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "input" ]
                                ]
                                (Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "input" ]
                                )
                            )
                    }
                )
                [ addOptionalFieldArg
                , addOptionalFieldArg0
                , addOptionalFieldArg1
                , addOptionalFieldArg2
                , addOptionalFieldArg3
                ]
    , addField =
        \addFieldArg addFieldArg0 addFieldArg1 addFieldArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "addField"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.string
                                , Type.namedWith [ "Json", "Encode" ] "Value" []
                                , Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "value" ]
                                ]
                                (Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ addFieldArg, addFieldArg0, addFieldArg1, addFieldArg2 ]
    , inputObject =
        \inputObjectArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "inputObject"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string ]
                                (Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ inputObjectArg ]
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
    , unsafe =
        \unsafeArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "unsafe"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "selected" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "unsafe", Type.var "selected" ]
                                )
                            )
                    }
                )
                [ unsafeArg ]
    , fieldWith =
        \fieldWithArg fieldWithArg0 fieldWithArg1 fieldWithArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "fieldWith"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "args" ]
                                , Type.string
                                , Type.string
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "data" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                )
                            )
                    }
                )
                [ fieldWithArg, fieldWithArg0, fieldWithArg1, fieldWithArg2 ]
    , field =
        \fieldArg fieldArg0 fieldArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "field"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.string
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "data" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                )
                            )
                    }
                )
                [ fieldArg, fieldArg0, fieldArg1 ]
    , decode =
        \decodeArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "decode"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "data" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                )
                            )
                    }
                )
                [ decodeArg ]
    , objectWith =
        \objectWithArg objectWithArg0 objectWithArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "objectWith"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "args" ]
                                , Type.string
                                , Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "otherSource", Type.var "data" ]
                                )
                            )
                    }
                )
                [ objectWithArg, objectWithArg0, objectWithArg1 ]
    , object =
        \objectArg objectArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "object"
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
                                    [ Type.var "otherSource", Type.var "data" ]
                                )
                            )
                    }
                )
                [ objectArg, objectArg0 ]
    , list =
        \listArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "list"
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
                                    "Selection"
                                    [ Type.var "source"
                                    , Type.list (Type.var "data")
                                    ]
                                )
                            )
                    }
                )
                [ listArg ]
    , nullable =
        \nullableArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "nullable"
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
                                    "Selection"
                                    [ Type.var "source"
                                    , Type.namedWith
                                        []
                                        "Maybe"
                                        [ Type.var "data" ]
                                    ]
                                )
                            )
                    }
                )
                [ nullableArg ]
    , enum =
        \enumArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "enum"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.tuple Type.string (Type.var "item"))
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "item" ]
                                )
                            )
                    }
                )
                [ enumArg ]
    , maybeEnum =
        \maybeEnumArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "maybeEnum"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.tuple Type.string (Type.var "item"))
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.namedWith
                                        []
                                        "Maybe"
                                        [ Type.var "item" ]
                                    ]
                                )
                            )
                    }
                )
                [ maybeEnumArg ]
    , union =
        \unionArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "union"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith
                                            []
                                            "Selection"
                                            [ Type.var "source"
                                            , Type.var "data"
                                            ]
                                        )
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
                [ unionArg ]
    , recover =
        \recoverArg recoverArg0 recoverArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "recover"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.var "recovered"
                                , Type.function
                                    [ Type.var "data" ]
                                    (Type.var "recovered")
                                , Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "recovered" ]
                                )
                            )
                    }
                )
                [ recoverArg, recoverArg0, recoverArg1 ]
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
    { andMap : Elm.Expression
    , jsonField : Elm.Expression
    , versionedAlias : Elm.Expression
    , versionedName : Elm.Expression
    , versionedJsonField : Elm.Expression
    , decodeNullable : Elm.Expression
    , maybeScalarEncode : Elm.Expression
    , queryString : Elm.Expression
    , mutationRiskyTask : Elm.Expression
    , queryRiskyTask : Elm.Expression
    , mutationRisky : Elm.Expression
    , queryRisky : Elm.Expression
    , mutationTask : Elm.Expression
    , queryTask : Elm.Expression
    , mutation : Elm.Expression
    , query : Elm.Expression
    , simulate : Elm.Expression
    , send : Elm.Expression
    , mapRequest : Elm.Expression
    , bakeToSelection : Elm.Expression
    , map2 : Elm.Expression
    , map : Elm.Expression
    , with : Elm.Expression
    , select : Elm.Expression
    , optional : Elm.Expression
    , encodeOptionalsAsJson : Elm.Expression
    , encodeOptionals : Elm.Expression
    , encodeArgument : Elm.Expression
    , encodeInputObject : Elm.Expression
    , encodeInputObjectAsJson : Elm.Expression
    , inputObjectToFieldList : Elm.Expression
    , argList : Elm.Expression
    , arg : Elm.Expression
    , addOptionalField : Elm.Expression
    , addField : Elm.Expression
    , inputObject : Elm.Expression
    , withName : Elm.Expression
    , unsafe : Elm.Expression
    , fieldWith : Elm.Expression
    , field : Elm.Expression
    , selectTypeNameButSkip : Elm.Expression
    , decode : Elm.Expression
    , objectWith : Elm.Expression
    , object : Elm.Expression
    , list : Elm.Expression
    , nullable : Elm.Expression
    , enum : Elm.Expression
    , maybeEnum : Elm.Expression
    , union : Elm.Expression
    , recover : Elm.Expression
    , batch : Elm.Expression
    }
values_ =
    { andMap =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "andMap"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
    , jsonField =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "jsonField"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
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
    , versionedJsonField =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "versionedJsonField"
            , annotation =
                Just
                    (Type.function
                        [ Type.int
                        , Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
    , decodeNullable =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "decodeNullable"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.namedWith [] "Maybe" [ Type.var "data" ] ]
                        )
                    )
            }
    , maybeScalarEncode =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "maybeScalarEncode"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [] "Maybe" [ Type.var "a" ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , queryString =
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
    , bakeToSelection =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "bakeToSelection"
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
    , with =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "with"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "a" ]
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source"
                            , Type.function [ Type.var "a" ] (Type.var "b")
                            ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "b" ]
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
    , optional =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "optional"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "Argument" [ Type.var "arg" ]
                        ]
                        (Type.namedWith [] "Optional" [ Type.var "arg" ])
                    )
            }
    , encodeOptionalsAsJson =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeOptionalsAsJson"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith [] "Optional" [ Type.var "arg" ])
                        ]
                        (Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                        )
                    )
            }
    , encodeOptionals =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeOptionals"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith [] "Optional" [ Type.var "arg" ])
                        ]
                        (Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "Argument" [ Type.var "arg" ]
                                )
                            )
                        )
                    )
            }
    , encodeArgument =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeArgument"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Argument" [ Type.var "obj" ] ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , encodeInputObject =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeInputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "Argument" [ Type.var "obj" ]
                                )
                            )
                        , Type.string
                        ]
                        (Type.namedWith [] "Argument" [ Type.var "input" ])
                    )
            }
    , encodeInputObjectAsJson =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "encodeInputObjectAsJson"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "value" ] ]
                        (Type.namedWith [ "Json", "Decode" ] "Value" [])
                    )
            }
    , inputObjectToFieldList =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "inputObjectToFieldList"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "a" ] ]
                        (Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "VariableDetails" [])
                            )
                        )
                    )
            }
    , argList =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "argList"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith [] "Argument" [ Type.var "obj" ])
                        , Type.string
                        ]
                        (Type.namedWith [] "Argument" [ Type.var "input" ])
                    )
            }
    , arg =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "arg"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Json", "Encode" ] "Value" []
                        , Type.string
                        ]
                        (Type.namedWith [] "Argument" [ Type.var "obj" ])
                    )
            }
    , addOptionalField =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "addOptionalField"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [] "Option" [ Type.var "value" ]
                        , Type.function
                            [ Type.var "value" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [] "InputObject" [ Type.var "input" ]
                        ]
                        (Type.namedWith [] "InputObject" [ Type.var "input" ])
                    )
            }
    , addField =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "addField"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [ "Json", "Encode" ] "Value" []
                        , Type.namedWith [] "InputObject" [ Type.var "value" ]
                        ]
                        (Type.namedWith [] "InputObject" [ Type.var "value" ])
                    )
            }
    , inputObject =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "inputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith [] "InputObject" [ Type.var "value" ])
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
    , unsafe =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "unsafe"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "selected" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "unsafe", Type.var "selected" ]
                        )
                    )
            }
    , fieldWith =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "fieldWith"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "args" ]
                        , Type.string
                        , Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
    , field =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
    , selectTypeNameButSkip =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "selectTypeNameButSkip"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Selection"
                        [ Type.var "source", Type.unit ]
                    )
            }
    , decode =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "decode"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
    , objectWith =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "objectWith"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "args" ]
                        , Type.string
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "otherSource", Type.var "data" ]
                        )
                    )
            }
    , object =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "object"
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
                            [ Type.var "otherSource", Type.var "data" ]
                        )
                    )
            }
    , list =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "list"
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
                            "Selection"
                            [ Type.var "source", Type.list (Type.var "data") ]
                        )
                    )
            }
    , nullable =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "nullable"
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
                            "Selection"
                            [ Type.var "source"
                            , Type.namedWith [] "Maybe" [ Type.var "data" ]
                            ]
                        )
                    )
            }
    , enum =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "enum"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.tuple Type.string (Type.var "item")) ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "item" ]
                        )
                    )
            }
    , maybeEnum =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "maybeEnum"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.tuple Type.string (Type.var "item")) ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.namedWith [] "Maybe" [ Type.var "item" ] ]
                        )
                    )
            }
    , union =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "union"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                )
                            )
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
            }
    , recover =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "recover"
            , annotation =
                Just
                    (Type.function
                        [ Type.var "recovered"
                        , Type.function
                            [ Type.var "data" ]
                            (Type.var "recovered")
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        (Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "recovered" ]
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



module Gen.GraphQL.Engine exposing (addField, addOptionalField, andMap, annotation_, arg, argList, bakeToSelection, batch, call_, caseOf_, decode, decodeNullable, encodeArgument, encodeInputObject, encodeInputObjectAsJson, encodeOptionals, encodeOptionalsAsJson, enum, field, fieldWith, getGql, inputObject, inputObjectToFieldList, jsonField, list, make_, map, map2, mapPremade, mapRequest, maybeEnum, maybeScalarEncode, moduleName_, mutation, nullable, object, objectWith, optional, prebakedQuery, premadeOperation, query, queryString, recover, select, selectTypeNameButSkip, send, simulate, toRequest, union, unsafe, values_, with)

{-| 
@docs values_, call_, caseOf_, make_, annotation_, batch, recover, union, maybeEnum, enum, nullable, list, object, objectWith, decode, selectTypeNameButSkip, field, fieldWith, unsafe, inputObject, addField, addOptionalField, arg, argList, inputObjectToFieldList, encodeInputObjectAsJson, encodeInputObject, encodeArgument, encodeOptionals, encodeOptionalsAsJson, optional, select, with, map, map2, bakeToSelection, prebakedQuery, getGql, mapPremade, premadeOperation, mapRequest, toRequest, send, simulate, query, mutation, queryString, maybeScalarEncode, decodeNullable, jsonField, andMap, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Engine" ]


{-| andMap: 
    Json.Decode.Decoder map2Unpack
    -> Json.Decode.Decoder (map2Unpack -> inner -> (inner -> inner2) -> inner2)
    -> Json.Decode.Decoder (inner -> (inner -> inner2) -> inner2)
-}
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
                            [ Type.var "map2Unpack" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function
                                [ Type.var "map2Unpack"
                                , Type.var "inner"
                                , Type.function
                                    [ Type.var "inner" ]
                                    (Type.var "inner2")
                                ]
                                (Type.var "inner2")
                            ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function
                                [ Type.var "inner"
                                , Type.function
                                    [ Type.var "inner" ]
                                    (Type.var "inner2")
                                ]
                                (Type.var "inner2")
                            ]
                        )
                    )
            }
        )
        [ andMapArg, andMapArg0 ]


{-| jsonField: 
    String
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> inner -> (inner -> inner2) -> inner2)
    -> Json.Decode.Decoder (inner -> (inner -> inner2) -> inner2)
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
                            [ Type.function
                                [ Type.var "a"
                                , Type.var "inner"
                                , Type.function
                                    [ Type.var "inner" ]
                                    (Type.var "inner2")
                                ]
                                (Type.var "inner2")
                            ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function
                                [ Type.var "inner"
                                , Type.function
                                    [ Type.var "inner" ]
                                    (Type.var "inner2")
                                ]
                                (Type.var "inner2")
                            ]
                        )
                    )
            }
        )
        [ Elm.string jsonFieldArg, jsonFieldArg0, jsonFieldArg1 ]


{-| {-| -}

decodeNullable: Decode.Decoder data -> Decode.Decoder (Maybe data)
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
                            [ "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith
                            [ "Decode" ]
                            "Decoder"
                            [ Type.namedWith [] "Maybe" [ Type.var "data" ] ]
                        )
                    )
            }
        )
        [ decodeNullableArg ]


{-| {-| -}

maybeScalarEncode: (a -> Encode.Value) -> Maybe a -> Encode.Value
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
                            (Type.namedWith [ "Encode" ] "Value" [])
                        , Type.namedWith [] "Maybe" [ Type.var "a" ]
                        ]
                        (Type.namedWith [ "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.functionReduced "maybeScalarEncodeUnpack" maybeScalarEncodeArg
        , maybeScalarEncodeArg0
        ]


{-| {-| -}

queryString: String -> Maybe String -> Selection source data -> String
-}
queryString : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
queryString queryStringArg queryStringArg0 queryStringArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "queryString"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "Maybe" [ Type.string ]
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        Type.string
                    )
            }
        )
        [ Elm.string queryStringArg, queryStringArg0, queryStringArg1 ]


{-| {-| -}

mutation: 
    Selection Mutation msg
    -> { name : Maybe String
    , headers : List Http.Header
    , url : String
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Cmd (Result Error msg)
-}
mutation :
    Elm.Expression
    -> { name : Elm.Expression
    , headers : List Elm.Expression
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
                            [ ( "name"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            , ( "headers"
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
            [ Tuple.pair "name" mutationArg0.name
            , Tuple.pair "headers" (Elm.list mutationArg0.headers)
            , Tuple.pair "url" (Elm.string mutationArg0.url)
            , Tuple.pair "timeout" mutationArg0.timeout
            , Tuple.pair "tracker" mutationArg0.tracker
            ]
        ]


{-| {-| -}

query: 
    Selection Query value
    -> { name : Maybe String
    , headers : List Http.Header
    , url : String
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Cmd (Result Error value)
-}
query :
    Elm.Expression
    -> { name : Elm.Expression
    , headers : List Elm.Expression
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
                            [ ( "name"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            , ( "headers"
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
            [ Tuple.pair "name" queryArg0.name
            , Tuple.pair "headers" (Elm.list queryArg0.headers)
            , Tuple.pair "url" (Elm.string queryArg0.url)
            , Tuple.pair "timeout" queryArg0.timeout
            , Tuple.pair "tracker" queryArg0.tracker
            ]
        ]


{-| {-| -}

simulate: 
    { toHeader : String -> String -> header
    , toExpectation : (Http.Response String -> Result Error value) -> expectation
    , toBody : Encode.Value -> body
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
                                    [ Type.namedWith [ "Encode" ] "Value" [] ]
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


{-| {-| Return details that can be directly given to `Http.request`.

This is so that wiring up [Elm Program Test](https://package.elm-lang.org/packages/avh4/elm-program-test/latest/ProgramTest) is relatively easy.

-}

toRequest: 
    Premade value
    -> { headers : List ( String, String )
    , url : String
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Request value
-}
toRequest :
    Elm.Expression
    -> { headers : List Elm.Expression
    , url : String
    , timeout : Elm.Expression
    , tracker : Elm.Expression
    }
    -> Elm.Expression
toRequest toRequestArg toRequestArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "toRequest"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Premade" [ Type.var "value" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list (Type.tuple Type.string Type.string)
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
                        (Type.namedWith [] "Request" [ Type.var "value" ])
                    )
            }
        )
        [ toRequestArg
        , Elm.record
            [ Tuple.pair "headers" (Elm.list toRequestArg0.headers)
            , Tuple.pair "url" (Elm.string toRequestArg0.url)
            , Tuple.pair "timeout" toRequestArg0.timeout
            , Tuple.pair "tracker" toRequestArg0.tracker
            ]
        ]


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

premadeOperation: 
    Premade value
    -> { headers : List Http.Header
    , url : String
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Cmd (Result Error value)
-}
premadeOperation :
    Elm.Expression
    -> { headers : List Elm.Expression
    , url : String
    , timeout : Elm.Expression
    , tracker : Elm.Expression
    }
    -> Elm.Expression
premadeOperation premadeOperationArg premadeOperationArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "premadeOperation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Premade" [ Type.var "value" ]
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
        [ premadeOperationArg
        , Elm.record
            [ Tuple.pair "headers" (Elm.list premadeOperationArg0.headers)
            , Tuple.pair "url" (Elm.string premadeOperationArg0.url)
            , Tuple.pair "timeout" premadeOperationArg0.timeout
            , Tuple.pair "tracker" premadeOperationArg0.tracker
            ]
        ]


{-| {-| -}

mapPremade: (a -> b) -> Premade a -> Premade b
-}
mapPremade :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
mapPremade mapPremadeArg mapPremadeArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mapPremade"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "a" ] (Type.var "b")
                        , Type.namedWith [] "Premade" [ Type.var "a" ]
                        ]
                        (Type.namedWith [] "Premade" [ Type.var "b" ])
                    )
            }
        )
        [ Elm.functionReduced "mapPremadeUnpack" mapPremadeArg, mapPremadeArg0 ]


{-| {-| -}

getGql: Premade data -> String
-}
getGql : Elm.Expression -> Elm.Expression
getGql getGqlArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "getGql"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Premade" [ Type.var "data" ] ]
                        Type.string
                    )
            }
        )
        [ getGqlArg ]


{-| {-| -}

prebakedQuery: 
    String
    -> List ( String, VariableDetails )
    -> Decode.Decoder data
    -> Premade data
-}
prebakedQuery :
    String -> List Elm.Expression -> Elm.Expression -> Elm.Expression
prebakedQuery prebakedQueryArg prebakedQueryArg0 prebakedQueryArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "prebakedQuery"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "VariableDetails" [])
                            )
                        , Type.namedWith
                            [ "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith [] "Premade" [ Type.var "data" ])
                    )
            }
        )
        [ Elm.string prebakedQueryArg
        , Elm.list prebakedQueryArg0
        , prebakedQueryArg1
        ]


{-| {-| -}

bakeToSelection: 
    Maybe String
    -> String
    -> List ( String, VariableDetails )
    -> Decode.Decoder data
    -> Premade data
-}
bakeToSelection :
    Elm.Expression
    -> String
    -> List Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
bakeToSelection bakeToSelectionArg bakeToSelectionArg0 bakeToSelectionArg1 bakeToSelectionArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "bakeToSelection"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Maybe" [ Type.string ]
                        , Type.string
                        , Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "VariableDetails" [])
                            )
                        , Type.namedWith
                            [ "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith [] "Premade" [ Type.var "data" ])
                    )
            }
        )
        [ bakeToSelectionArg
        , Elm.string bakeToSelectionArg0
        , Elm.list bakeToSelectionArg1
        , bakeToSelectionArg2
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

encodeOptionalsAsJson: List (Optional arg) -> List ( String, Encode.Value )
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
                                (Type.namedWith [ "Encode" ] "Value" [])
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

encodeArgument: Argument obj -> Encode.Value
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
                        (Type.namedWith [ "Encode" ] "Value" [])
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

encodeInputObjectAsJson: InputObject value -> Decode.Value
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
                        (Type.namedWith [ "Decode" ] "Value" [])
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

arg: Encode.Value -> String -> Argument obj
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
                        [ Type.namedWith [ "Encode" ] "Value" [], Type.string ]
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
    -> (value -> Encode.Value)
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
                            (Type.namedWith [ "Encode" ] "Value" [])
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

addField: String -> String -> Encode.Value -> InputObject value -> InputObject value
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
                        , Type.namedWith [ "Encode" ] "Value" []
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
    -> Decode.Decoder data
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
                            [ "Decode" ]
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

field: String -> String -> Decode.Decoder data -> Selection source data
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
                            [ "Decode" ]
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

decode: Decode.Decoder data -> Selection source data
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
                            [ "Decode" ]
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

enum: List ( String, item ) -> Decode.Decoder item
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
                            [ "Decode" ]
                            "Decoder"
                            [ Type.var "item" ]
                        )
                    )
            }
        )
        [ Elm.list enumArg ]


{-| {-| -}

maybeEnum: List ( String, item ) -> Decode.Decoder (Maybe item)
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
                            [ "Decode" ]
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
    , premade : Type.Annotation -> Type.Annotation
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
    , premade =
        \premadeArg0 ->
            Type.namedWith [ "GraphQL", "Engine" ] "Premade" [ premadeArg0 ]
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
                    ( "encode.Value", Type.namedWith [ "Encode" ] "Value" [] )
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
    , decodeNullable : Elm.Expression -> Elm.Expression
    , maybeScalarEncode : Elm.Expression -> Elm.Expression -> Elm.Expression
    , queryString :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutation : Elm.Expression -> Elm.Expression -> Elm.Expression
    , query : Elm.Expression -> Elm.Expression -> Elm.Expression
    , simulate : Elm.Expression -> Elm.Expression -> Elm.Expression
    , send : Elm.Expression -> Elm.Expression
    , toRequest : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mapRequest : Elm.Expression -> Elm.Expression -> Elm.Expression
    , premadeOperation : Elm.Expression -> Elm.Expression -> Elm.Expression
    , mapPremade : Elm.Expression -> Elm.Expression -> Elm.Expression
    , getGql : Elm.Expression -> Elm.Expression
    , prebakedQuery :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , bakeToSelection :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
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
                                    [ Type.var "map2Unpack" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.function
                                        [ Type.var "map2Unpack"
                                        , Type.var "inner"
                                        , Type.function
                                            [ Type.var "inner" ]
                                            (Type.var "inner2")
                                        ]
                                        (Type.var "inner2")
                                    ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.function
                                        [ Type.var "inner"
                                        , Type.function
                                            [ Type.var "inner" ]
                                            (Type.var "inner2")
                                        ]
                                        (Type.var "inner2")
                                    ]
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
                                        [ Type.var "a"
                                        , Type.var "inner"
                                        , Type.function
                                            [ Type.var "inner" ]
                                            (Type.var "inner2")
                                        ]
                                        (Type.var "inner2")
                                    ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.function
                                        [ Type.var "inner"
                                        , Type.function
                                            [ Type.var "inner" ]
                                            (Type.var "inner2")
                                        ]
                                        (Type.var "inner2")
                                    ]
                                )
                            )
                    }
                )
                [ jsonFieldArg, jsonFieldArg0, jsonFieldArg1 ]
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
                                    [ "Decode" ]
                                    "Decoder"
                                    [ Type.var "data" ]
                                ]
                                (Type.namedWith
                                    [ "Decode" ]
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
                                    (Type.namedWith [ "Encode" ] "Value" [])
                                , Type.namedWith [] "Maybe" [ Type.var "a" ]
                                ]
                                (Type.namedWith [ "Encode" ] "Value" [])
                            )
                    }
                )
                [ maybeScalarEncodeArg, maybeScalarEncodeArg0 ]
    , queryString =
        \queryStringArg queryStringArg0 queryStringArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "queryString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "Maybe" [ Type.string ]
                                , Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.var "source", Type.var "data" ]
                                ]
                                Type.string
                            )
                    }
                )
                [ queryStringArg, queryStringArg0, queryStringArg1 ]
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
                                    [ ( "name"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.string ]
                                      )
                                    , ( "headers"
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
                                    [ ( "name"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.string ]
                                      )
                                    , ( "headers"
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
                                                [ "Encode" ]
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
    , toRequest =
        \toRequestArg toRequestArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "toRequest"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Premade"
                                    [ Type.var "value" ]
                                , Type.record
                                    [ ( "headers"
                                      , Type.list
                                            (Type.tuple Type.string Type.string)
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
                                    "Request"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ toRequestArg, toRequestArg0 ]
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
    , premadeOperation =
        \premadeOperationArg premadeOperationArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "premadeOperation"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Premade"
                                    [ Type.var "value" ]
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
                [ premadeOperationArg, premadeOperationArg0 ]
    , mapPremade =
        \mapPremadeArg mapPremadeArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "mapPremade"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function [ Type.var "a" ] (Type.var "b")
                                , Type.namedWith [] "Premade" [ Type.var "a" ]
                                ]
                                (Type.namedWith [] "Premade" [ Type.var "b" ])
                            )
                    }
                )
                [ mapPremadeArg, mapPremadeArg0 ]
    , getGql =
        \getGqlArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "getGql"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "Premade"
                                    [ Type.var "data" ]
                                ]
                                Type.string
                            )
                    }
                )
                [ getGqlArg ]
    , prebakedQuery =
        \prebakedQueryArg prebakedQueryArg0 prebakedQueryArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "prebakedQuery"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith [] "VariableDetails" [])
                                    )
                                , Type.namedWith
                                    [ "Decode" ]
                                    "Decoder"
                                    [ Type.var "data" ]
                                ]
                                (Type.namedWith [] "Premade" [ Type.var "data" ]
                                )
                            )
                    }
                )
                [ prebakedQueryArg, prebakedQueryArg0, prebakedQueryArg1 ]
    , bakeToSelection =
        \bakeToSelectionArg bakeToSelectionArg0 bakeToSelectionArg1 bakeToSelectionArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Engine" ]
                    , name = "bakeToSelection"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Maybe" [ Type.string ]
                                , Type.string
                                , Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith [] "VariableDetails" [])
                                    )
                                , Type.namedWith
                                    [ "Decode" ]
                                    "Decoder"
                                    [ Type.var "data" ]
                                ]
                                (Type.namedWith [] "Premade" [ Type.var "data" ]
                                )
                            )
                    }
                )
                [ bakeToSelectionArg
                , bakeToSelectionArg0
                , bakeToSelectionArg1
                , bakeToSelectionArg2
                ]
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
                                        (Type.namedWith [ "Encode" ] "Value" [])
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
                                (Type.namedWith [ "Encode" ] "Value" [])
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
                                (Type.namedWith [ "Decode" ] "Value" [])
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
                                [ Type.namedWith [ "Encode" ] "Value" []
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
                                    (Type.namedWith [ "Encode" ] "Value" [])
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
                                , Type.namedWith [ "Encode" ] "Value" []
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
                                    [ "Decode" ]
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
                                    [ "Decode" ]
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
                                    [ "Decode" ]
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
                                    [ "Decode" ]
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
                                    [ "Decode" ]
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
    , decodeNullable : Elm.Expression
    , maybeScalarEncode : Elm.Expression
    , queryString : Elm.Expression
    , mutation : Elm.Expression
    , query : Elm.Expression
    , simulate : Elm.Expression
    , send : Elm.Expression
    , toRequest : Elm.Expression
    , mapRequest : Elm.Expression
    , premadeOperation : Elm.Expression
    , mapPremade : Elm.Expression
    , getGql : Elm.Expression
    , prebakedQuery : Elm.Expression
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
                            [ Type.var "map2Unpack" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function
                                [ Type.var "map2Unpack"
                                , Type.var "inner"
                                , Type.function
                                    [ Type.var "inner" ]
                                    (Type.var "inner2")
                                ]
                                (Type.var "inner2")
                            ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function
                                [ Type.var "inner"
                                , Type.function
                                    [ Type.var "inner" ]
                                    (Type.var "inner2")
                                ]
                                (Type.var "inner2")
                            ]
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
                            [ Type.function
                                [ Type.var "a"
                                , Type.var "inner"
                                , Type.function
                                    [ Type.var "inner" ]
                                    (Type.var "inner2")
                                ]
                                (Type.var "inner2")
                            ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function
                                [ Type.var "inner"
                                , Type.function
                                    [ Type.var "inner" ]
                                    (Type.var "inner2")
                                ]
                                (Type.var "inner2")
                            ]
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
                            [ "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith
                            [ "Decode" ]
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
                            (Type.namedWith [ "Encode" ] "Value" [])
                        , Type.namedWith [] "Maybe" [ Type.var "a" ]
                        ]
                        (Type.namedWith [ "Encode" ] "Value" [])
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
                        , Type.namedWith [] "Maybe" [ Type.string ]
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        ]
                        Type.string
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
                            [ ( "name"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            , ( "headers"
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
                            [ ( "name"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            , ( "headers"
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
                                    [ Type.namedWith [ "Encode" ] "Value" [] ]
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
    , toRequest =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "toRequest"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Premade" [ Type.var "value" ]
                        , Type.record
                            [ ( "headers"
                              , Type.list (Type.tuple Type.string Type.string)
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
                        (Type.namedWith [] "Request" [ Type.var "value" ])
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
    , premadeOperation =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "premadeOperation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Premade" [ Type.var "value" ]
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
    , mapPremade =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "mapPremade"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "a" ] (Type.var "b")
                        , Type.namedWith [] "Premade" [ Type.var "a" ]
                        ]
                        (Type.namedWith [] "Premade" [ Type.var "b" ])
                    )
            }
    , getGql =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "getGql"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Premade" [ Type.var "data" ] ]
                        Type.string
                    )
            }
    , prebakedQuery =
        Elm.value
            { importFrom = [ "GraphQL", "Engine" ]
            , name = "prebakedQuery"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "VariableDetails" [])
                            )
                        , Type.namedWith
                            [ "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith [] "Premade" [ Type.var "data" ])
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
                        , Type.string
                        , Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "VariableDetails" [])
                            )
                        , Type.namedWith
                            [ "Decode" ]
                            "Decoder"
                            [ Type.var "data" ]
                        ]
                        (Type.namedWith [] "Premade" [ Type.var "data" ])
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
                                (Type.namedWith [ "Encode" ] "Value" [])
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
                        (Type.namedWith [ "Encode" ] "Value" [])
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
                        (Type.namedWith [ "Decode" ] "Value" [])
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
                        [ Type.namedWith [ "Encode" ] "Value" [], Type.string ]
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
                            (Type.namedWith [ "Encode" ] "Value" [])
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
                        , Type.namedWith [ "Encode" ] "Value" []
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
                            [ "Decode" ]
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
                            [ "Decode" ]
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
                            [ "Decode" ]
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
                            [ "Decode" ]
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
                            [ "Decode" ]
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



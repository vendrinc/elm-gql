module Gen.Generate.Args exposing (annotation, call_, createBuilder, encodeWrapped, inputTypeToString, moduleName_, nullsRecord, optionsRecursive, toEngineArg, toJsonValue, unwrapWith, values_)

{-| 
@docs values_, call_, unwrapWith, nullsRecord, optionsRecursive, toJsonValue, toEngineArg, inputTypeToString, encodeWrapped, annotation, createBuilder, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Args" ]


{-| {-| -}

createBuilder: 
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    -> List { fieldOrArg
        | name : String
        , description : Maybe String
        , type_ : GraphQL.Schema.Type
    }
    -> GraphQL.Schema.Type
    -> Input.Operation
    -> Elm.Declaration
-}
createBuilder :
    Elm.Expression
    -> Elm.Expression
    -> String
    -> List { fieldOrArg
        | name : String
        , description : Elm.Expression
        , type_ : Elm.Expression
    }
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
createBuilder createBuilderArg createBuilderArg0 createBuilderArg1 createBuilderArg2 createBuilderArg3 createBuilderArg4 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "createBuilder"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.string
                        , Type.list
                            (Type.extensible
                                "fieldOrArg"
                                [ ( "name", Type.string )
                                , ( "description"
                                  , Type.namedWith [] "Maybe" [ Type.string ]
                                  )
                                , ( "type_"
                                  , Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Type"
                                        []
                                  )
                                ]
                            )
                        , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith [ "Input" ] "Operation" []
                        ]
                        (Type.namedWith [ "Elm" ] "Declaration" [])
                    )
            }
        )
        [ createBuilderArg
        , createBuilderArg0
        , Elm.string createBuilderArg1
        , Elm.list
            (List.map
                (\unpack ->
                    Elm.record
                        [ Tuple.pair "name" (Elm.string unpack.name)
                        , Tuple.pair "description" unpack.description
                        , Tuple.pair "type_" unpack.type_
                        ]
                )
                createBuilderArg2
            )
        , createBuilderArg3
        , createBuilderArg4
        ]


{-| annotation: 
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.InputObjectDetails
    -> Elm.Annotation.Annotation
-}
annotation :
    Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
annotation annotationArg annotationArg0 annotationArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "annotation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith
                            [ "GraphQL", "Schema" ]
                            "InputObjectDetails"
                            []
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
        )
        [ annotationArg, annotationArg0, annotationArg1 ]


{-| encodeWrapped: 
    GraphQL.Schema.Wrapped
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
-}
encodeWrapped :
    Elm.Expression
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
encodeWrapped encodeWrappedArg encodeWrappedArg0 encodeWrappedArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "encodeWrapped"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.function
                            [ Type.namedWith [ "Elm" ] "Expression" [] ]
                            (Type.namedWith [ "Elm" ] "Expression" [])
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ encodeWrappedArg
        , Elm.functionReduced "encodeWrappedUnpack" encodeWrappedArg0
        , encodeWrappedArg1
        ]


{-| inputTypeToString: GraphQL.Schema.Type -> String -}
inputTypeToString : Elm.Expression -> Elm.Expression
inputTypeToString inputTypeToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "inputTypeToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Type" [] ]
                        Type.string
                    )
            }
        )
        [ inputTypeToStringArg ]


{-| toEngineArg: 
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.Type
    -> GraphQL.Schema.Wrapped
    -> Elm.Expression
    -> Elm.Expression
-}
toEngineArg :
    Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
toEngineArg toEngineArgArg toEngineArgArg0 toEngineArgArg1 toEngineArgArg2 toEngineArgArg3 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "toEngineArg"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ toEngineArgArg
        , toEngineArgArg0
        , toEngineArgArg1
        , toEngineArgArg2
        , toEngineArgArg3
        ]


{-| {-|

    Take an input

-}

toJsonValue: 
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.Type
    -> GraphQL.Schema.Wrapped
    -> Elm.Expression
    -> Elm.Expression
-}
toJsonValue :
    Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
toJsonValue toJsonValueArg toJsonValueArg0 toJsonValueArg1 toJsonValueArg2 toJsonValueArg3 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "toJsonValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ toJsonValueArg
        , toJsonValueArg0
        , toJsonValueArg1
        , toJsonValueArg2
        , toJsonValueArg3
        ]


{-| {-|

    The `recursive` part means it's going to jump into the schema in order to figure out how to encode the various inputs

    Instead of making you do it yourself.

-}

optionsRecursive: 
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    -> List { fieldOrArg
        | name : String
        , type_ : GraphQL.Schema.Type
        , description : Maybe String
    }
    -> List Elm.Declaration
-}
optionsRecursive :
    Elm.Expression
    -> Elm.Expression
    -> String
    -> List { fieldOrArg
        | name : String
        , type_ : Elm.Expression
        , description : Elm.Expression
    }
    -> Elm.Expression
optionsRecursive optionsRecursiveArg optionsRecursiveArg0 optionsRecursiveArg1 optionsRecursiveArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "optionsRecursive"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.string
                        , Type.list
                            (Type.extensible
                                "fieldOrArg"
                                [ ( "name", Type.string )
                                , ( "type_"
                                  , Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Type"
                                        []
                                  )
                                , ( "description"
                                  , Type.namedWith [] "Maybe" [ Type.string ]
                                  )
                                ]
                            )
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ optionsRecursiveArg
        , optionsRecursiveArg0
        , Elm.string optionsRecursiveArg1
        , Elm.list
            (List.map
                (\unpack ->
                    Elm.record
                        [ Tuple.pair "name" (Elm.string unpack.name)
                        , Tuple.pair "type_" unpack.type_
                        , Tuple.pair "description" unpack.description
                        ]
                )
                optionsRecursiveArg2
            )
        ]


{-| {-|

    Creates a `nulls` record that looks like


    null =
        { fieldOne
        , fieldTwo
        }

-}

nullsRecord: 
    Namespace
    -> String
    -> List { fieldOrArg
        | name : String
        , type_ : GraphQL.Schema.Type
        , description : Maybe String
    }
    -> Elm.Expression
-}
nullsRecord :
    Elm.Expression
    -> String
    -> List { fieldOrArg
        | name : String
        , type_ : Elm.Expression
        , description : Elm.Expression
    }
    -> Elm.Expression
nullsRecord nullsRecordArg nullsRecordArg0 nullsRecordArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "nullsRecord"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.string
                        , Type.list
                            (Type.extensible
                                "fieldOrArg"
                                [ ( "name", Type.string )
                                , ( "type_"
                                  , Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Type"
                                        []
                                  )
                                , ( "description"
                                  , Type.namedWith [] "Maybe" [ Type.string ]
                                  )
                                ]
                            )
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ nullsRecordArg
        , Elm.string nullsRecordArg0
        , Elm.list
            (List.map
                (\unpack ->
                    Elm.record
                        [ Tuple.pair "name" (Elm.string unpack.name)
                        , Tuple.pair "type_" unpack.type_
                        , Tuple.pair "description" unpack.description
                        ]
                )
                nullsRecordArg1
            )
        ]


{-| unwrapWith: GraphQL.Schema.Wrapped -> Elm.Annotation.Annotation -> Elm.Annotation.Annotation -}
unwrapWith : Elm.Expression -> Elm.Expression -> Elm.Expression
unwrapWith unwrapWithArg unwrapWithArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "unwrapWith"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.namedWith [ "Elm", "Annotation" ] "Annotation" []
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
        )
        [ unwrapWithArg, unwrapWithArg0 ]


call_ :
    { createBuilder :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , annotation :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , encodeWrapped :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , inputTypeToString : Elm.Expression -> Elm.Expression
    , toEngineArg :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , toJsonValue :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , optionsRecursive :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , nullsRecord :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , unwrapWith : Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { createBuilder =
        \createBuilderArg createBuilderArg0 createBuilderArg1 createBuilderArg2 createBuilderArg3 createBuilderArg4 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Args" ]
                    , name = "createBuilder"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.string
                                , Type.list
                                    (Type.extensible
                                        "fieldOrArg"
                                        [ ( "name", Type.string )
                                        , ( "description"
                                          , Type.namedWith
                                                []
                                                "Maybe"
                                                [ Type.string ]
                                          )
                                        , ( "type_"
                                          , Type.namedWith
                                                [ "GraphQL", "Schema" ]
                                                "Type"
                                                []
                                          )
                                        ]
                                    )
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Type"
                                    []
                                , Type.namedWith [ "Input" ] "Operation" []
                                ]
                                (Type.namedWith [ "Elm" ] "Declaration" [])
                            )
                    }
                )
                [ createBuilderArg
                , createBuilderArg0
                , createBuilderArg1
                , createBuilderArg2
                , createBuilderArg3
                , createBuilderArg4
                ]
    , annotation =
        \annotationArg annotationArg0 annotationArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Args" ]
                    , name = "annotation"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "InputObjectDetails"
                                    []
                                ]
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            )
                    }
                )
                [ annotationArg, annotationArg0, annotationArg1 ]
    , encodeWrapped =
        \encodeWrappedArg encodeWrappedArg0 encodeWrappedArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Args" ]
                    , name = "encodeWrapped"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Wrapped"
                                    []
                                , Type.function
                                    [ Type.namedWith [ "Elm" ] "Expression" [] ]
                                    (Type.namedWith [ "Elm" ] "Expression" [])
                                , Type.namedWith [ "Elm" ] "Expression" []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ encodeWrappedArg, encodeWrappedArg0, encodeWrappedArg1 ]
    , inputTypeToString =
        \inputTypeToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Args" ]
                    , name = "inputTypeToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Type"
                                    []
                                ]
                                Type.string
                            )
                    }
                )
                [ inputTypeToStringArg ]
    , toEngineArg =
        \toEngineArgArg toEngineArgArg0 toEngineArgArg1 toEngineArgArg2 toEngineArgArg3 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Args" ]
                    , name = "toEngineArg"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Type"
                                    []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Wrapped"
                                    []
                                , Type.namedWith [ "Elm" ] "Expression" []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ toEngineArgArg
                , toEngineArgArg0
                , toEngineArgArg1
                , toEngineArgArg2
                , toEngineArgArg3
                ]
    , toJsonValue =
        \toJsonValueArg toJsonValueArg0 toJsonValueArg1 toJsonValueArg2 toJsonValueArg3 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Args" ]
                    , name = "toJsonValue"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Type"
                                    []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Wrapped"
                                    []
                                , Type.namedWith [ "Elm" ] "Expression" []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ toJsonValueArg
                , toJsonValueArg0
                , toJsonValueArg1
                , toJsonValueArg2
                , toJsonValueArg3
                ]
    , optionsRecursive =
        \optionsRecursiveArg optionsRecursiveArg0 optionsRecursiveArg1 optionsRecursiveArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Args" ]
                    , name = "optionsRecursive"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.string
                                , Type.list
                                    (Type.extensible
                                        "fieldOrArg"
                                        [ ( "name", Type.string )
                                        , ( "type_"
                                          , Type.namedWith
                                                [ "GraphQL", "Schema" ]
                                                "Type"
                                                []
                                          )
                                        , ( "description"
                                          , Type.namedWith
                                                []
                                                "Maybe"
                                                [ Type.string ]
                                          )
                                        ]
                                    )
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ optionsRecursiveArg
                , optionsRecursiveArg0
                , optionsRecursiveArg1
                , optionsRecursiveArg2
                ]
    , nullsRecord =
        \nullsRecordArg nullsRecordArg0 nullsRecordArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Args" ]
                    , name = "nullsRecord"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.string
                                , Type.list
                                    (Type.extensible
                                        "fieldOrArg"
                                        [ ( "name", Type.string )
                                        , ( "type_"
                                          , Type.namedWith
                                                [ "GraphQL", "Schema" ]
                                                "Type"
                                                []
                                          )
                                        , ( "description"
                                          , Type.namedWith
                                                []
                                                "Maybe"
                                                [ Type.string ]
                                          )
                                        ]
                                    )
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ nullsRecordArg, nullsRecordArg0, nullsRecordArg1 ]
    , unwrapWith =
        \unwrapWithArg unwrapWithArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Args" ]
                    , name = "unwrapWith"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Wrapped"
                                    []
                                , Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                ]
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            )
                    }
                )
                [ unwrapWithArg, unwrapWithArg0 ]
    }


values_ :
    { createBuilder : Elm.Expression
    , annotation : Elm.Expression
    , encodeWrapped : Elm.Expression
    , inputTypeToString : Elm.Expression
    , toEngineArg : Elm.Expression
    , toJsonValue : Elm.Expression
    , optionsRecursive : Elm.Expression
    , nullsRecord : Elm.Expression
    , unwrapWith : Elm.Expression
    }
values_ =
    { createBuilder =
        Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "createBuilder"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.string
                        , Type.list
                            (Type.extensible
                                "fieldOrArg"
                                [ ( "name", Type.string )
                                , ( "description"
                                  , Type.namedWith [] "Maybe" [ Type.string ]
                                  )
                                , ( "type_"
                                  , Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Type"
                                        []
                                  )
                                ]
                            )
                        , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith [ "Input" ] "Operation" []
                        ]
                        (Type.namedWith [ "Elm" ] "Declaration" [])
                    )
            }
    , annotation =
        Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "annotation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith
                            [ "GraphQL", "Schema" ]
                            "InputObjectDetails"
                            []
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
    , encodeWrapped =
        Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "encodeWrapped"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.function
                            [ Type.namedWith [ "Elm" ] "Expression" [] ]
                            (Type.namedWith [ "Elm" ] "Expression" [])
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , inputTypeToString =
        Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "inputTypeToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Type" [] ]
                        Type.string
                    )
            }
    , toEngineArg =
        Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "toEngineArg"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , toJsonValue =
        Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "toJsonValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , optionsRecursive =
        Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "optionsRecursive"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.string
                        , Type.list
                            (Type.extensible
                                "fieldOrArg"
                                [ ( "name", Type.string )
                                , ( "type_"
                                  , Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Type"
                                        []
                                  )
                                , ( "description"
                                  , Type.namedWith [] "Maybe" [ Type.string ]
                                  )
                                ]
                            )
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    , nullsRecord =
        Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "nullsRecord"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.string
                        , Type.list
                            (Type.extensible
                                "fieldOrArg"
                                [ ( "name", Type.string )
                                , ( "type_"
                                  , Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Type"
                                        []
                                  )
                                , ( "description"
                                  , Type.namedWith [] "Maybe" [ Type.string ]
                                  )
                                ]
                            )
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , unwrapWith =
        Elm.value
            { importFrom = [ "Generate", "Args" ]
            , name = "unwrapWith"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.namedWith [ "Elm", "Annotation" ] "Annotation" []
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
    }



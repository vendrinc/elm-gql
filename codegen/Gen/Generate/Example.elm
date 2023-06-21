module Gen.Generate.Example exposing (call_, example, moduleName_, operation, values_)

{-| 
@docs moduleName_, example, operation, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Example" ]


{-| {-|

    Generates an example that demonstrates Inputs, but the selection set is only `select{Object}`

-}

example: 
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    -> List { fieldOrArg
        | name : String
        , description : Maybe String
        , type_ : GraphQL.Schema.Type
    }
    -> GraphQL.Schema.Type
    -> Generate.Input.Operation
    -> Elm.Expression
-}
example :
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
example exampleArg exampleArg0 exampleArg1 exampleArg2 exampleArg3 exampleArg4 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Example" ]
            , name = "example"
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
                        , Type.namedWith [ "Generate", "Input" ] "Operation" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ exampleArg
        , exampleArg0
        , Elm.string exampleArg1
        , Elm.list
            (List.map
                (\unpack ->
                    Elm.record
                        [ Tuple.pair "name" (Elm.string unpack.name)
                        , Tuple.pair "description" unpack.description
                        , Tuple.pair "type_" unpack.type_
                        ]
                )
                exampleArg2
            )
        , exampleArg3
        , exampleArg4
        ]


{-| {-| -}

operation: 
    Namespace
    -> GraphQL.Schema.Schema
    -> ( Generate.Input.Operation, GraphQL.Schema.Field )
    -> Elm.Expression
-}
operation : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
operation operationArg operationArg0 operationArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Example" ]
            , name = "operation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.tuple
                            (Type.namedWith
                                [ "Generate", "Input" ]
                                "Operation"
                                []
                            )
                            (Type.namedWith [ "GraphQL", "Schema" ] "Field" [])
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ operationArg, operationArg0, operationArg1 ]


call_ :
    { example :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , operation :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { example =
        \exampleArg exampleArg0 exampleArg1 exampleArg2 exampleArg3 exampleArg4 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Example" ]
                    , name = "example"
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
                                , Type.namedWith
                                    [ "Generate", "Input" ]
                                    "Operation"
                                    []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ exampleArg
                , exampleArg0
                , exampleArg1
                , exampleArg2
                , exampleArg3
                , exampleArg4
                ]
    , operation =
        \operationArg operationArg0 operationArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Example" ]
                    , name = "operation"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.tuple
                                    (Type.namedWith
                                        [ "Generate", "Input" ]
                                        "Operation"
                                        []
                                    )
                                    (Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Field"
                                        []
                                    )
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ operationArg, operationArg0, operationArg1 ]
    }


values_ : { example : Elm.Expression, operation : Elm.Expression }
values_ =
    { example =
        Elm.value
            { importFrom = [ "Generate", "Example" ]
            , name = "example"
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
                        , Type.namedWith [ "Generate", "Input" ] "Operation" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , operation =
        Elm.value
            { importFrom = [ "Generate", "Example" ]
            , name = "operation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.tuple
                            (Type.namedWith
                                [ "Generate", "Input" ]
                                "Operation"
                                []
                            )
                            (Type.namedWith [ "GraphQL", "Schema" ] "Field" [])
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    }
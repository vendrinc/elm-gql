module Gen.GraphQL.Mock exposing (annotation_, call_, mock, moduleName_, schemaFromString, values_)

{-| 
@docs values_, call_, annotation_, schemaFromString, mock, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Mock" ]


{-| {-| Given a premade query or mutation, return an auto-mocked, json-stringified version of what the query is expecting
-}

mock: Schema -> Selection Query value -> Result Error String
-}
mock : Elm.Expression -> Elm.Expression -> Elm.Expression
mock mockArg mockArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Mock" ]
            , name = "mock"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Schema" []
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "value" ]
                        ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.namedWith [] "Error" [], Type.string ]
                        )
                    )
            }
        )
        [ mockArg, mockArg0 ]


{-| {-| -}

schemaFromString: String -> Schema
-}
schemaFromString : String -> Elm.Expression
schemaFromString schemaFromStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Mock" ]
            , name = "schemaFromString"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith [] "Schema" [])
                    )
            }
        )
        [ Elm.string schemaFromStringArg ]


annotation_ : { schema : Type.Annotation }
annotation_ =
    { schema = Type.namedWith [ "GraphQL", "Mock" ] "Schema" [] }


call_ :
    { mock : Elm.Expression -> Elm.Expression -> Elm.Expression
    , schemaFromString : Elm.Expression -> Elm.Expression
    }
call_ =
    { mock =
        \mockArg mockArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Mock" ]
                    , name = "mock"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Schema" []
                                , Type.namedWith
                                    []
                                    "Selection"
                                    [ Type.namedWith [] "Query" []
                                    , Type.var "value"
                                    ]
                                ]
                                (Type.namedWith
                                    []
                                    "Result"
                                    [ Type.namedWith [] "Error" []
                                    , Type.string
                                    ]
                                )
                            )
                    }
                )
                [ mockArg, mockArg0 ]
    , schemaFromString =
        \schemaFromStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Mock" ]
                    , name = "schemaFromString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string ]
                                (Type.namedWith [] "Schema" [])
                            )
                    }
                )
                [ schemaFromStringArg ]
    }


values_ : { mock : Elm.Expression, schemaFromString : Elm.Expression }
values_ =
    { mock =
        Elm.value
            { importFrom = [ "GraphQL", "Mock" ]
            , name = "mock"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Schema" []
                        , Type.namedWith
                            []
                            "Selection"
                            [ Type.namedWith [] "Query" [], Type.var "value" ]
                        ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.namedWith [] "Error" [], Type.string ]
                        )
                    )
            }
    , schemaFromString =
        Elm.value
            { importFrom = [ "GraphQL", "Mock" ]
            , name = "schemaFromString"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith [] "Schema" [])
                    )
            }
    }



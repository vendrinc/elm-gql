module Gen.Generate.Scalar exposing (call_, decode, encode, generate, moduleName_, values_)

{-| 
@docs values_, call_, encode, decode, generate, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Scalar" ]


{-| generate: Namespace -> GraphQL.Schema.Schema -> Elm.File -}
generate : Elm.Expression -> Elm.Expression -> Elm.Expression
generate generateArg generateArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Scalar" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        ]
                        (Type.namedWith [ "Elm" ] "File" [])
                    )
            }
        )
        [ generateArg, generateArg0 ]


{-| decode: Namespace -> String -> GraphQL.Schema.Wrapped -> Elm.Expression -}
decode : Elm.Expression -> String -> Elm.Expression -> Elm.Expression
decode decodeArg decodeArg0 decodeArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Scalar" ]
            , name = "decode"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.string
                        , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ decodeArg, Elm.string decodeArg0, decodeArg1 ]


{-| encode: 
    Namespace
    -> String
    -> GraphQL.Schema.Wrapped
    -> Elm.Expression
    -> Elm.Expression
-}
encode :
    Elm.Expression
    -> String
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
encode encodeArg encodeArg0 encodeArg1 encodeArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Scalar" ]
            , name = "encode"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.string
                        , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ encodeArg, Elm.string encodeArg0, encodeArg1, encodeArg2 ]


call_ :
    { generate : Elm.Expression -> Elm.Expression -> Elm.Expression
    , decode :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , encode :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    }
call_ =
    { generate =
        \generateArg generateArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Scalar" ]
                    , name = "generate"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                ]
                                (Type.namedWith [ "Elm" ] "File" [])
                            )
                    }
                )
                [ generateArg, generateArg0 ]
    , decode =
        \decodeArg decodeArg0 decodeArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Scalar" ]
                    , name = "decode"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.string
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Wrapped"
                                    []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ decodeArg, decodeArg0, decodeArg1 ]
    , encode =
        \encodeArg encodeArg0 encodeArg1 encodeArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Scalar" ]
                    , name = "encode"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.string
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
                [ encodeArg, encodeArg0, encodeArg1, encodeArg2 ]
    }


values_ :
    { generate : Elm.Expression
    , decode : Elm.Expression
    , encode : Elm.Expression
    }
values_ =
    { generate =
        Elm.value
            { importFrom = [ "Generate", "Scalar" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        ]
                        (Type.namedWith [ "Elm" ] "File" [])
                    )
            }
    , decode =
        Elm.value
            { importFrom = [ "Generate", "Scalar" ]
            , name = "decode"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.string
                        , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , encode =
        Elm.value
            { importFrom = [ "Generate", "Scalar" ]
            , name = "encode"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.string
                        , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    }



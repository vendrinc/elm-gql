module Gen.Generate.Scalar exposing (call_, decoder, encode, generate, moduleName_, type_, values_)

{-| 
@docs moduleName_, generate, decoder, encode, type_, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Scalar" ]


{-| generate: Namespace -> GraphQL.Schema.Schema -> List Elm.Declaration -}
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
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ generateArg, generateArg0 ]


{-| decoder: Namespace -> String -> GraphQL.Schema.Wrapped -> Elm.Expression -}
decoder : Elm.Expression -> String -> Elm.Expression -> Elm.Expression
decoder decoderArg decoderArg0 decoderArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Scalar" ]
            , name = "decoder"
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
        [ decoderArg, Elm.string decoderArg0, decoderArg1 ]


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


{-| type_: Namespace -> String -> Type.Annotation -}
type_ : Elm.Expression -> String -> Elm.Expression
type_ type_Arg type_Arg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Scalar" ]
            , name = "type_"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" [], Type.string ]
                        (Type.namedWith [ "Type" ] "Annotation" [])
                    )
            }
        )
        [ type_Arg, Elm.string type_Arg0 ]


call_ :
    { generate : Elm.Expression -> Elm.Expression -> Elm.Expression
    , decoder :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , encode :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , type_ : Elm.Expression -> Elm.Expression -> Elm.Expression
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
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ generateArg, generateArg0 ]
    , decoder =
        \decoderArg decoderArg0 decoderArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Scalar" ]
                    , name = "decoder"
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
                [ decoderArg, decoderArg0, decoderArg1 ]
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
    , type_ =
        \type_Arg type_Arg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Scalar" ]
                    , name = "type_"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.string
                                ]
                                (Type.namedWith [ "Type" ] "Annotation" [])
                            )
                    }
                )
                [ type_Arg, type_Arg0 ]
    }


values_ :
    { generate : Elm.Expression
    , decoder : Elm.Expression
    , encode : Elm.Expression
    , type_ : Elm.Expression
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
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    , decoder =
        Elm.value
            { importFrom = [ "Generate", "Scalar" ]
            , name = "decoder"
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
    , type_ =
        Elm.value
            { importFrom = [ "Generate", "Scalar" ]
            , name = "type_"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" [], Type.string ]
                        (Type.namedWith [ "Type" ] "Annotation" [])
                    )
            }
    }
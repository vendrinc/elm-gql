module Gen.GraphQL.Operations.Generate.Mock.ServerResponse exposing (call_, fragmentToJsonEncoder, moduleName_, toJsonEncoder, values_)

{-| 
@docs moduleName_, toJsonEncoder, fragmentToJsonEncoder, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Generate", "Mock", "ServerResponse" ]


{-| {-| A standard query generates some Elm code that returns

    Api.Query DataReturned

Where we generate types for DataReturned.

This generates a function that takes a {DataReturned} and returns a JSON value.

This will ultimately be used in testing as follows

        Spec.app.sends
            { gql =
                AppsPaginated.query
                    (AppsPaginated.input
                        |> AppsPaginated.first 50
                    )

            , encoder = Mock.encoder
            , serverReturns  =
                Mock.AppsPaginated.query
            }


        Spec.app.sends
            { gql =
                -- Api.Query data
                AppsPaginated.query
                    (AppsPaginated.input
                        |> AppsPaginated.first 50
                    )
            -- data -> Json.Encode.Value
            , encoder = Mock.encoder
            -- data
            , serverReturns  =
                Mock.AppsPaginated.query
            }


        Api.Mock.appsPaginated
            { input =
                AppsPaginated.input
                    |> AppsPaginated.first 50
            , returns =
                Mock.AppsPaginated.query
            }

-}

toJsonEncoder: 
    TargetModule
    -> Type.Annotation
    -> Namespace
    -> Can.Definition
    -> List Elm.Declaration
-}
toJsonEncoder :
    Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
toJsonEncoder toJsonEncoderArg toJsonEncoderArg0 toJsonEncoderArg1 toJsonEncoderArg2 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL"
                , "Operations"
                , "Generate"
                , "Mock"
                , "ServerResponse"
                ]
            , name = "toJsonEncoder"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "TargetModule" []
                        , Type.namedWith [ "Type" ] "Annotation" []
                        , Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "Definition" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ toJsonEncoderArg
        , toJsonEncoderArg0
        , toJsonEncoderArg1
        , toJsonEncoderArg2
        ]


{-| fragmentToJsonEncoder: TargetModule -> Namespace -> Can.Fragment -> List Elm.Declaration -}
fragmentToJsonEncoder :
    Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
fragmentToJsonEncoder fragmentToJsonEncoderArg fragmentToJsonEncoderArg0 fragmentToJsonEncoderArg1 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL"
                , "Operations"
                , "Generate"
                , "Mock"
                , "ServerResponse"
                ]
            , name = "fragmentToJsonEncoder"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "TargetModule" []
                        , Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "Fragment" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ fragmentToJsonEncoderArg
        , fragmentToJsonEncoderArg0
        , fragmentToJsonEncoderArg1
        ]


call_ :
    { toJsonEncoder :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , fragmentToJsonEncoder :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { toJsonEncoder =
        \toJsonEncoderArg toJsonEncoderArg0 toJsonEncoderArg1 toJsonEncoderArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL"
                        , "Operations"
                        , "Generate"
                        , "Mock"
                        , "ServerResponse"
                        ]
                    , name = "toJsonEncoder"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "TargetModule" []
                                , Type.namedWith [ "Type" ] "Annotation" []
                                , Type.namedWith [] "Namespace" []
                                , Type.namedWith [ "Can" ] "Definition" []
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ toJsonEncoderArg
                , toJsonEncoderArg0
                , toJsonEncoderArg1
                , toJsonEncoderArg2
                ]
    , fragmentToJsonEncoder =
        \fragmentToJsonEncoderArg fragmentToJsonEncoderArg0 fragmentToJsonEncoderArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL"
                        , "Operations"
                        , "Generate"
                        , "Mock"
                        , "ServerResponse"
                        ]
                    , name = "fragmentToJsonEncoder"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "TargetModule" []
                                , Type.namedWith [] "Namespace" []
                                , Type.namedWith [ "Can" ] "Fragment" []
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ fragmentToJsonEncoderArg
                , fragmentToJsonEncoderArg0
                , fragmentToJsonEncoderArg1
                ]
    }


values_ :
    { toJsonEncoder : Elm.Expression, fragmentToJsonEncoder : Elm.Expression }
values_ =
    { toJsonEncoder =
        Elm.value
            { importFrom =
                [ "GraphQL"
                , "Operations"
                , "Generate"
                , "Mock"
                , "ServerResponse"
                ]
            , name = "toJsonEncoder"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "TargetModule" []
                        , Type.namedWith [ "Type" ] "Annotation" []
                        , Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "Definition" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    , fragmentToJsonEncoder =
        Elm.value
            { importFrom =
                [ "GraphQL"
                , "Operations"
                , "Generate"
                , "Mock"
                , "ServerResponse"
                ]
            , name = "fragmentToJsonEncoder"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "TargetModule" []
                        , Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "Fragment" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    }
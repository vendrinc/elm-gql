module Gen.GraphQL.Operations.Generate.Mock.Fragment exposing (call_, generate, moduleName_, values_)

{-| 
@docs moduleName_, generate, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Generate", "Mock", "Fragment" ]


{-| generate: Options.Options -> Can.Fragment -> Elm.File -}
generate : Elm.Expression -> Elm.Expression -> Elm.Expression
generate generateArg generateArg0 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Generate", "Mock", "Fragment" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Options" ] "Options" []
                        , Type.namedWith [ "Can" ] "Fragment" []
                        ]
                        (Type.namedWith [ "Elm" ] "File" [])
                    )
            }
        )
        [ generateArg, generateArg0 ]


call_ : { generate : Elm.Expression -> Elm.Expression -> Elm.Expression }
call_ =
    { generate =
        \generateArg generateArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL"
                        , "Operations"
                        , "Generate"
                        , "Mock"
                        , "Fragment"
                        ]
                    , name = "generate"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Options" ] "Options" []
                                , Type.namedWith [ "Can" ] "Fragment" []
                                ]
                                (Type.namedWith [ "Elm" ] "File" [])
                            )
                    }
                )
                [ generateArg, generateArg0 ]
    }


values_ : { generate : Elm.Expression }
values_ =
    { generate =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Generate", "Mock", "Fragment" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Options" ] "Options" []
                        , Type.namedWith [ "Can" ] "Fragment" []
                        ]
                        (Type.namedWith [ "Elm" ] "File" [])
                    )
            }
    }
module Gen.Generate.Root exposing (call_, generate, moduleName_, values_)

{-| 
@docs values_, call_, generate, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Root" ]


{-| generate: Namespace -> GraphQL.Schema.Schema -> Elm.File -}
generate : Elm.Expression -> Elm.Expression -> Elm.Expression
generate generateArg generateArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Root" ]
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


call_ : { generate : Elm.Expression -> Elm.Expression -> Elm.Expression }
call_ =
    { generate =
        \generateArg generateArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Root" ]
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
    }


values_ : { generate : Elm.Expression }
values_ =
    { generate =
        Elm.value
            { importFrom = [ "Generate", "Root" ]
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
    }



module Gen.Generate.Paged exposing (call_, generate, moduleName_, values_)

{-| 
@docs values_, call_, generate, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Paged" ]


{-| generate: String -> GraphQL.Schema.Schema -> List Elm.File -}
generate : String -> Elm.Expression -> Elm.Expression
generate generateArg generateArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Paged" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "File" []))
                    )
            }
        )
        [ Elm.string generateArg, generateArg0 ]


call_ : { generate : Elm.Expression -> Elm.Expression -> Elm.Expression }
call_ =
    { generate =
        \generateArg generateArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Paged" ]
                    , name = "generate"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                ]
                                (Type.list (Type.namedWith [ "Elm" ] "File" []))
                            )
                    }
                )
                [ generateArg, generateArg0 ]
    }


values_ : { generate : Elm.Expression }
values_ =
    { generate =
        Elm.value
            { importFrom = [ "Generate", "Paged" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "File" []))
                    )
            }
    }



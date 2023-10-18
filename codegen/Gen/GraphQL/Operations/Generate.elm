module Gen.GraphQL.Operations.Generate exposing (call_, generate, moduleName_, values_)

{-| 
@docs moduleName_, generate, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Generate" ]


{-| generate: Options.Options -> List Elm.File -}
generate : Elm.Expression -> Elm.Expression
generate generateArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Options" ] "Options" [] ]
                        (Type.list (Type.namedWith [ "Elm" ] "File" []))
                    )
            }
        )
        [ generateArg ]


call_ : { generate : Elm.Expression -> Elm.Expression }
call_ =
    { generate =
        \generateArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Generate" ]
                    , name = "generate"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Options" ] "Options" [] ]
                                (Type.list (Type.namedWith [ "Elm" ] "File" []))
                            )
                    }
                )
                [ generateArg ]
    }


values_ : { generate : Elm.Expression }
values_ =
    { generate =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Options" ] "Options" [] ]
                        (Type.list (Type.namedWith [ "Elm" ] "File" []))
                    )
            }
    }
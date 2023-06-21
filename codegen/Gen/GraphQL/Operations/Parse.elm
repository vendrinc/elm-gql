module Gen.GraphQL.Operations.Parse exposing (call_, errorToString, moduleName_, parse, values_)

{-| 
@docs moduleName_, errorToString, parse, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Parse" ]


{-| errorToString: List Parser.DeadEnd -> String -}
errorToString : List Elm.Expression -> Elm.Expression
errorToString errorToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "errorToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [ "Parser" ] "DeadEnd" []) ]
                        Type.string
                    )
            }
        )
        [ Elm.list errorToStringArg ]


{-| parse: String -> Result (List Parser.DeadEnd) AST.Document -}
parse : String -> Elm.Expression
parse parseArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "parse"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list
                                (Type.namedWith [ "Parser" ] "DeadEnd" [])
                            , Type.namedWith [ "AST" ] "Document" []
                            ]
                        )
                    )
            }
        )
        [ Elm.string parseArg ]


call_ :
    { errorToString : Elm.Expression -> Elm.Expression
    , parse : Elm.Expression -> Elm.Expression
    }
call_ =
    { errorToString =
        \errorToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "errorToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.namedWith [ "Parser" ] "DeadEnd" [])
                                ]
                                Type.string
                            )
                    }
                )
                [ errorToStringArg ]
    , parse =
        \parseArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "parse"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string ]
                                (Type.namedWith
                                    []
                                    "Result"
                                    [ Type.list
                                        (Type.namedWith
                                            [ "Parser" ]
                                            "DeadEnd"
                                            []
                                        )
                                    , Type.namedWith [ "AST" ] "Document" []
                                    ]
                                )
                            )
                    }
                )
                [ parseArg ]
    }


values_ : { errorToString : Elm.Expression, parse : Elm.Expression }
values_ =
    { errorToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "errorToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [ "Parser" ] "DeadEnd" []) ]
                        Type.string
                    )
            }
    , parse =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "parse"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list
                                (Type.namedWith [ "Parser" ] "DeadEnd" [])
                            , Type.namedWith [ "AST" ] "Document" []
                            ]
                        )
                    )
            }
    }
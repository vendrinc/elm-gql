module Gen.GraphQL.Operations.Canonicalize exposing (call_, canonicalize, cyan, errorToString, moduleName_, values_)

{-| 
@docs values_, call_, cyan, errorToString, canonicalize, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize" ]


{-| canonicalize: GraphQL.Schema.Schema -> AST.Document -> Result (List Error) Can.Document -}
canonicalize : Elm.Expression -> Elm.Expression -> Elm.Expression
canonicalize canonicalizeArg canonicalizeArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "canonicalize"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [ "AST" ] "Document" []
                        ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list (Type.namedWith [] "Error" [])
                            , Type.namedWith [ "Can" ] "Document" []
                            ]
                        )
                    )
            }
        )
        [ canonicalizeArg, canonicalizeArg0 ]


{-| errorToString: Error -> String -}
errorToString : Elm.Expression -> Elm.Expression
errorToString errorToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "errorToString"
            , annotation =
                Just
                    (Type.function [ Type.namedWith [] "Error" [] ] Type.string)
            }
        )
        [ errorToStringArg ]


{-| cyan: String -> String -}
cyan : String -> Elm.Expression
cyan cyanArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "cyan"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
        )
        [ Elm.string cyanArg ]


call_ :
    { canonicalize : Elm.Expression -> Elm.Expression -> Elm.Expression
    , errorToString : Elm.Expression -> Elm.Expression
    , cyan : Elm.Expression -> Elm.Expression
    }
call_ =
    { canonicalize =
        \canonicalizeArg canonicalizeArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
                    , name = "canonicalize"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.namedWith [ "AST" ] "Document" []
                                ]
                                (Type.namedWith
                                    []
                                    "Result"
                                    [ Type.list (Type.namedWith [] "Error" [])
                                    , Type.namedWith [ "Can" ] "Document" []
                                    ]
                                )
                            )
                    }
                )
                [ canonicalizeArg, canonicalizeArg0 ]
    , errorToString =
        \errorToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
                    , name = "errorToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Error" [] ]
                                Type.string
                            )
                    }
                )
                [ errorToStringArg ]
    , cyan =
        \cyanArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
                    , name = "cyan"
                    , annotation =
                        Just (Type.function [ Type.string ] Type.string)
                    }
                )
                [ cyanArg ]
    }


values_ :
    { canonicalize : Elm.Expression
    , errorToString : Elm.Expression
    , cyan : Elm.Expression
    }
values_ =
    { canonicalize =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "canonicalize"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [ "AST" ] "Document" []
                        ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list (Type.namedWith [] "Error" [])
                            , Type.namedWith [ "Can" ] "Document" []
                            ]
                        )
                    )
            }
    , errorToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "errorToString"
            , annotation =
                Just
                    (Type.function [ Type.namedWith [] "Error" [] ] Type.string)
            }
    , cyan =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "cyan"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
    }



module Gen.GraphQL.Operations.Canonicalize exposing (annotation_, call_, canonicalize, make_, moduleName_, values_)

{-| 
@docs moduleName_, canonicalize, annotation_, make_, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize" ]


{-| canonicalize: 
    GraphQL.Schema.Namespace
    -> GraphQL.Schema.Schema
    -> Paths
    -> List Can.Fragment
    -> AST.Document
    -> Result (List Error.Error) Can.Document
-}
canonicalize :
    Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> List Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
canonicalize canonicalizeArg canonicalizeArg0 canonicalizeArg1 canonicalizeArg2 canonicalizeArg3 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "canonicalize"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [] "Paths" []
                        , Type.list (Type.namedWith [ "Can" ] "Fragment" [])
                        , Type.namedWith [ "AST" ] "Document" []
                        ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list (Type.namedWith [ "Error" ] "Error" [])
                            , Type.namedWith [ "Can" ] "Document" []
                            ]
                        )
                    )
            }
        )
        [ canonicalizeArg
        , canonicalizeArg0
        , canonicalizeArg1
        , Elm.list canonicalizeArg2
        , canonicalizeArg3
        ]


annotation_ : { paths : Type.Annotation }
annotation_ =
    { paths =
        Type.alias
            moduleName_
            "Paths"
            []
            (Type.record
                [ ( "path", Type.string )
                , ( "queryDir", Type.list Type.string )
                , ( "fragmentDir", Type.list Type.string )
                ]
            )
    }


make_ :
    { paths :
        { path : Elm.Expression
        , queryDir : Elm.Expression
        , fragmentDir : Elm.Expression
        }
        -> Elm.Expression
    }
make_ =
    { paths =
        \paths_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Canonicalize" ]
                    "Paths"
                    []
                    (Type.record
                        [ ( "path", Type.string )
                        , ( "queryDir", Type.list Type.string )
                        , ( "fragmentDir", Type.list Type.string )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "path" paths_args.path
                    , Tuple.pair "queryDir" paths_args.queryDir
                    , Tuple.pair "fragmentDir" paths_args.fragmentDir
                    ]
                )
    }


call_ :
    { canonicalize :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    }
call_ =
    { canonicalize =
        \canonicalizeArg canonicalizeArg0 canonicalizeArg1 canonicalizeArg2 canonicalizeArg3 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
                    , name = "canonicalize"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Namespace"
                                    []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.namedWith [] "Paths" []
                                , Type.list
                                    (Type.namedWith [ "Can" ] "Fragment" [])
                                , Type.namedWith [ "AST" ] "Document" []
                                ]
                                (Type.namedWith
                                    []
                                    "Result"
                                    [ Type.list
                                        (Type.namedWith [ "Error" ] "Error" [])
                                    , Type.namedWith [ "Can" ] "Document" []
                                    ]
                                )
                            )
                    }
                )
                [ canonicalizeArg
                , canonicalizeArg0
                , canonicalizeArg1
                , canonicalizeArg2
                , canonicalizeArg3
                ]
    }


values_ : { canonicalize : Elm.Expression }
values_ =
    { canonicalize =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "canonicalize"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [] "Paths" []
                        , Type.list (Type.namedWith [ "Can" ] "Fragment" [])
                        , Type.namedWith [ "AST" ] "Document" []
                        ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list (Type.namedWith [ "Error" ] "Error" [])
                            , Type.namedWith [ "Can" ] "Document" []
                            ]
                        )
                    )
            }
    }
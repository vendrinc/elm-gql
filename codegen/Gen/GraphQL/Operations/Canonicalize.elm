module Gen.GraphQL.Operations.Canonicalize exposing (annotation_, call_, canonicalize, cyan, errorToString, make_, moduleName_, values_)

{-| 
@docs values_, call_, make_, annotation_, cyan, errorToString, canonicalize, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize" ]


{-| canonicalize: 
    GraphQL.Schema.Schema
    -> Paths
    -> AST.Document
    -> Result (List Error) Can.Document
-}
canonicalize :
    Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
canonicalize canonicalizeArg canonicalizeArg0 canonicalizeArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "canonicalize"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [] "Paths" []
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
        [ canonicalizeArg, canonicalizeArg0, canonicalizeArg1 ]


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


annotation_ : { paths : Type.Annotation, error : Type.Annotation }
annotation_ =
    { paths =
        Type.alias
            moduleName_
            "Paths"
            []
            (Type.record
                [ ( "path", Type.string ), ( "gqlDir", Type.list Type.string ) ]
            )
    , error =
        Type.namedWith [ "GraphQL", "Operations", "Canonicalize" ] "Error" []
    }


make_ :
    { paths :
        { path : Elm.Expression, gqlDir : Elm.Expression } -> Elm.Expression
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
                        , ( "gqlDir", Type.list Type.string )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "path" paths_args.path
                    , Tuple.pair "gqlDir" paths_args.gqlDir
                    ]
                )
    }


call_ :
    { canonicalize :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , errorToString : Elm.Expression -> Elm.Expression
    , cyan : Elm.Expression -> Elm.Expression
    }
call_ =
    { canonicalize =
        \canonicalizeArg canonicalizeArg0 canonicalizeArg1 ->
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
                                , Type.namedWith [] "Paths" []
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
                [ canonicalizeArg, canonicalizeArg0, canonicalizeArg1 ]
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
                        , Type.namedWith [] "Paths" []
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



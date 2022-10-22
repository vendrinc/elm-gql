module Gen.GraphQL.Operations.Canonicalize exposing (call_, canonicalize, cyan, doTypesMatch, errorToString, moduleName_, values_)

{-| 
@docs values_, call_, cyan, errorToString, canonicalize, doTypesMatch, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize" ]


{-| {-| The AST.Type is the type declared at the top of the document.

The Schema.Type is what is in the schema.

    variableDefinition is the AST representation of the variable declaration at the top.

-}

doTypesMatch: GraphQL.Schema.Type -> AST.Type -> Bool
-}
doTypesMatch : Elm.Expression -> Elm.Expression -> Elm.Expression
doTypesMatch doTypesMatchArg doTypesMatchArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "doTypesMatch"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith [ "AST" ] "Type" []
                        ]
                        Type.bool
                    )
            }
        )
        [ doTypesMatchArg, doTypesMatchArg0 ]


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


call_ :
    { doTypesMatch : Elm.Expression -> Elm.Expression -> Elm.Expression
    , canonicalize :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , errorToString : Elm.Expression -> Elm.Expression
    , cyan : Elm.Expression -> Elm.Expression
    }
call_ =
    { doTypesMatch =
        \doTypesMatchArg doTypesMatchArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
                    , name = "doTypesMatch"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Type"
                                    []
                                , Type.namedWith [ "AST" ] "Type" []
                                ]
                                Type.bool
                            )
                    }
                )
                [ doTypesMatchArg, doTypesMatchArg0 ]
    , canonicalize =
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
    { doTypesMatch : Elm.Expression
    , canonicalize : Elm.Expression
    , errorToString : Elm.Expression
    , cyan : Elm.Expression
    }
values_ =
    { doTypesMatch =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "doTypesMatch"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith [ "AST" ] "Type" []
                        ]
                        Type.bool
                    )
            }
    , canonicalize =
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



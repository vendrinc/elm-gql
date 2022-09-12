module Gen.Generate.Input exposing (annotation_, call_, caseOf_, decodeWrapper, getWrapFromAst, gqlType, gqlTypeHelper, isOptional, make_, moduleName_, operationToString, splitRequired, values_, wrapElmType, wrapExpression)

{-| 
@docs values_, call_, caseOf_, make_, annotation_, operationToString, gqlType, gqlTypeHelper, getWrapFromAst, wrapElmType, wrapExpression, splitRequired, isOptional, decodeWrapper, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Input" ]


{-| decodeWrapper: Wrapped -> Elm.Expression -> Elm.Expression -}
decodeWrapper : Elm.Expression -> Elm.Expression -> Elm.Expression
decodeWrapper decodeWrapperArg decodeWrapperArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "decodeWrapper"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapped" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ decodeWrapperArg, decodeWrapperArg0 ]


{-| isOptional: { a | type_ : GraphQL.Schema.Type } -> Bool -}
isOptional : { a | type_ : Elm.Expression } -> Elm.Expression
isOptional isOptionalArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "isOptional"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "a"
                            [ ( "type_"
                              , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                              )
                            ]
                        ]
                        Type.bool
                    )
            }
        )
        [ Elm.record [ Tuple.pair "type_" isOptionalArg.type_ ] ]


{-| splitRequired: 
    List { a | type_ : GraphQL.Schema.Type }
    -> ( List { a | type_ : GraphQL.Schema.Type }, List { a
        | type_ : GraphQL.Schema.Type
    } )
-}
splitRequired : List { a | type_ : Elm.Expression } -> Elm.Expression
splitRequired splitRequiredArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "splitRequired"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.extensible
                                "a"
                                [ ( "type_"
                                  , Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Type"
                                        []
                                  )
                                ]
                            )
                        ]
                        (Type.tuple
                            (Type.list
                                (Type.extensible
                                    "a"
                                    [ ( "type_"
                                      , Type.namedWith
                                            [ "GraphQL", "Schema" ]
                                            "Type"
                                            []
                                      )
                                    ]
                                )
                            )
                            (Type.list
                                (Type.extensible
                                    "a"
                                    [ ( "type_"
                                      , Type.namedWith
                                            [ "GraphQL", "Schema" ]
                                            "Type"
                                            []
                                      )
                                    ]
                                )
                            )
                        )
                    )
            }
        )
        [ Elm.list
            (List.map
                (\unpack -> Elm.record [ Tuple.pair "type_" unpack.type_ ])
                splitRequiredArg
            )
        ]


{-| wrapExpression: Wrapped -> Elm.Expression -> Elm.Expression -}
wrapExpression : Elm.Expression -> Elm.Expression -> Elm.Expression
wrapExpression wrapExpressionArg wrapExpressionArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "wrapExpression"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapped" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ wrapExpressionArg, wrapExpressionArg0 ]


{-| wrapElmType: Wrapped -> Type.Annotation -> Type.Annotation -}
wrapElmType : Elm.Expression -> Elm.Expression -> Elm.Expression
wrapElmType wrapElmTypeArg wrapElmTypeArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "wrapElmType"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapped" []
                        , Type.namedWith [ "Type" ] "Annotation" []
                        ]
                        (Type.namedWith [ "Type" ] "Annotation" [])
                    )
            }
        )
        [ wrapElmTypeArg, wrapElmTypeArg0 ]


{-| getWrapFromAst: Ast.Type -> Wrapped -}
getWrapFromAst : Elm.Expression -> Elm.Expression
getWrapFromAst getWrapFromAstArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "getWrapFromAst"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Ast" ] "Type" [] ]
                        (Type.namedWith [] "Wrapped" [])
                    )
            }
        )
        [ getWrapFromAstArg ]


{-| gqlTypeHelper: Wrapped -> String -> String -}
gqlTypeHelper : Elm.Expression -> String -> Elm.Expression
gqlTypeHelper gqlTypeHelperArg gqlTypeHelperArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "gqlTypeHelper"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapped" [], Type.string ]
                        Type.string
                    )
            }
        )
        [ gqlTypeHelperArg, Elm.string gqlTypeHelperArg0 ]


{-| gqlType: Wrapped -> String -> String -}
gqlType : Elm.Expression -> String -> Elm.Expression
gqlType gqlTypeArg gqlTypeArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "gqlType"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapped" [], Type.string ]
                        Type.string
                    )
            }
        )
        [ gqlTypeArg, Elm.string gqlTypeArg0 ]


{-| operationToString: Operation -> String -}
operationToString : Elm.Expression -> Elm.Expression
operationToString operationToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "operationToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Operation" [] ]
                        Type.string
                    )
            }
        )
        [ operationToStringArg ]


annotation_ : { operation : Type.Annotation }
annotation_ =
    { operation = Type.namedWith [ "Generate", "Input" ] "Operation" [] }


make_ : { query : Elm.Expression, mutation : Elm.Expression }
make_ =
    { query =
        Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "Query"
            , annotation = Just (Type.namedWith [] "Operation" [])
            }
    , mutation =
        Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "Mutation"
            , annotation = Just (Type.namedWith [] "Operation" [])
            }
    }


caseOf_ :
    { operation :
        Elm.Expression
        -> { operationTags_0_0
            | query : Elm.Expression
            , mutation : Elm.Expression
        }
        -> Elm.Expression
    }
caseOf_ =
    { operation =
        \operationExpression operationTags ->
            Elm.Case.custom
                operationExpression
                (Type.namedWith [ "Generate", "Input" ] "Operation" [])
                [ Elm.Case.branch0 "Query" operationTags.query
                , Elm.Case.branch0 "Mutation" operationTags.mutation
                ]
    }


call_ :
    { decodeWrapper : Elm.Expression -> Elm.Expression -> Elm.Expression
    , isOptional : Elm.Expression -> Elm.Expression
    , splitRequired : Elm.Expression -> Elm.Expression
    , wrapExpression : Elm.Expression -> Elm.Expression -> Elm.Expression
    , wrapElmType : Elm.Expression -> Elm.Expression -> Elm.Expression
    , getWrapFromAst : Elm.Expression -> Elm.Expression
    , gqlTypeHelper : Elm.Expression -> Elm.Expression -> Elm.Expression
    , gqlType : Elm.Expression -> Elm.Expression -> Elm.Expression
    , operationToString : Elm.Expression -> Elm.Expression
    }
call_ =
    { decodeWrapper =
        \decodeWrapperArg decodeWrapperArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input" ]
                    , name = "decodeWrapper"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Wrapped" []
                                , Type.namedWith [ "Elm" ] "Expression" []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ decodeWrapperArg, decodeWrapperArg0 ]
    , isOptional =
        \isOptionalArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input" ]
                    , name = "isOptional"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.extensible
                                    "a"
                                    [ ( "type_"
                                      , Type.namedWith
                                            [ "GraphQL", "Schema" ]
                                            "Type"
                                            []
                                      )
                                    ]
                                ]
                                Type.bool
                            )
                    }
                )
                [ isOptionalArg ]
    , splitRequired =
        \splitRequiredArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input" ]
                    , name = "splitRequired"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.extensible
                                        "a"
                                        [ ( "type_"
                                          , Type.namedWith
                                                [ "GraphQL", "Schema" ]
                                                "Type"
                                                []
                                          )
                                        ]
                                    )
                                ]
                                (Type.tuple
                                    (Type.list
                                        (Type.extensible
                                            "a"
                                            [ ( "type_"
                                              , Type.namedWith
                                                    [ "GraphQL", "Schema" ]
                                                    "Type"
                                                    []
                                              )
                                            ]
                                        )
                                    )
                                    (Type.list
                                        (Type.extensible
                                            "a"
                                            [ ( "type_"
                                              , Type.namedWith
                                                    [ "GraphQL", "Schema" ]
                                                    "Type"
                                                    []
                                              )
                                            ]
                                        )
                                    )
                                )
                            )
                    }
                )
                [ splitRequiredArg ]
    , wrapExpression =
        \wrapExpressionArg wrapExpressionArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input" ]
                    , name = "wrapExpression"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Wrapped" []
                                , Type.namedWith [ "Elm" ] "Expression" []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ wrapExpressionArg, wrapExpressionArg0 ]
    , wrapElmType =
        \wrapElmTypeArg wrapElmTypeArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input" ]
                    , name = "wrapElmType"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Wrapped" []
                                , Type.namedWith [ "Type" ] "Annotation" []
                                ]
                                (Type.namedWith [ "Type" ] "Annotation" [])
                            )
                    }
                )
                [ wrapElmTypeArg, wrapElmTypeArg0 ]
    , getWrapFromAst =
        \getWrapFromAstArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input" ]
                    , name = "getWrapFromAst"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Ast" ] "Type" [] ]
                                (Type.namedWith [] "Wrapped" [])
                            )
                    }
                )
                [ getWrapFromAstArg ]
    , gqlTypeHelper =
        \gqlTypeHelperArg gqlTypeHelperArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input" ]
                    , name = "gqlTypeHelper"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Wrapped" [], Type.string ]
                                Type.string
                            )
                    }
                )
                [ gqlTypeHelperArg, gqlTypeHelperArg0 ]
    , gqlType =
        \gqlTypeArg gqlTypeArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input" ]
                    , name = "gqlType"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Wrapped" [], Type.string ]
                                Type.string
                            )
                    }
                )
                [ gqlTypeArg, gqlTypeArg0 ]
    , operationToString =
        \operationToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input" ]
                    , name = "operationToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Operation" [] ]
                                Type.string
                            )
                    }
                )
                [ operationToStringArg ]
    }


values_ :
    { decodeWrapper : Elm.Expression
    , isOptional : Elm.Expression
    , splitRequired : Elm.Expression
    , wrapExpression : Elm.Expression
    , wrapElmType : Elm.Expression
    , getWrapFromAst : Elm.Expression
    , gqlTypeHelper : Elm.Expression
    , gqlType : Elm.Expression
    , operationToString : Elm.Expression
    }
values_ =
    { decodeWrapper =
        Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "decodeWrapper"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapped" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , isOptional =
        Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "isOptional"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "a"
                            [ ( "type_"
                              , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                              )
                            ]
                        ]
                        Type.bool
                    )
            }
    , splitRequired =
        Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "splitRequired"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.extensible
                                "a"
                                [ ( "type_"
                                  , Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Type"
                                        []
                                  )
                                ]
                            )
                        ]
                        (Type.tuple
                            (Type.list
                                (Type.extensible
                                    "a"
                                    [ ( "type_"
                                      , Type.namedWith
                                            [ "GraphQL", "Schema" ]
                                            "Type"
                                            []
                                      )
                                    ]
                                )
                            )
                            (Type.list
                                (Type.extensible
                                    "a"
                                    [ ( "type_"
                                      , Type.namedWith
                                            [ "GraphQL", "Schema" ]
                                            "Type"
                                            []
                                      )
                                    ]
                                )
                            )
                        )
                    )
            }
    , wrapExpression =
        Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "wrapExpression"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapped" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , wrapElmType =
        Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "wrapElmType"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapped" []
                        , Type.namedWith [ "Type" ] "Annotation" []
                        ]
                        (Type.namedWith [ "Type" ] "Annotation" [])
                    )
            }
    , getWrapFromAst =
        Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "getWrapFromAst"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Ast" ] "Type" [] ]
                        (Type.namedWith [] "Wrapped" [])
                    )
            }
    , gqlTypeHelper =
        Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "gqlTypeHelper"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapped" [], Type.string ]
                        Type.string
                    )
            }
    , gqlType =
        Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "gqlType"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapped" [], Type.string ]
                        Type.string
                    )
            }
    , operationToString =
        Elm.value
            { importFrom = [ "Generate", "Input" ]
            , name = "operationToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Operation" [] ]
                        Type.string
                    )
            }
    }



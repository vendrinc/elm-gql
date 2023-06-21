module Gen.Generate.Input exposing (annotation_, call_, caseOf_, decodeWrapper, make_, moduleName_, splitRequired, values_, wrapElmType, wrapExpression)

{-| 
@docs moduleName_, decodeWrapper, splitRequired, wrapExpression, wrapElmType, annotation_, make_, caseOf_, call_, values_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case


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
    , splitRequired : Elm.Expression -> Elm.Expression
    , wrapExpression : Elm.Expression -> Elm.Expression -> Elm.Expression
    , wrapElmType : Elm.Expression -> Elm.Expression -> Elm.Expression
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
    }


values_ :
    { decodeWrapper : Elm.Expression
    , splitRequired : Elm.Expression
    , wrapExpression : Elm.Expression
    , wrapElmType : Elm.Expression
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
    }
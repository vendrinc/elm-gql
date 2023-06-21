module Gen.GraphQL.Operations.Generate.Types exposing (call_, enumType, generate, interfaceVariants, moduleName_, toAliasedFields, unionVars, values_)

{-| 
@docs moduleName_, enumType, toAliasedFields, interfaceVariants, unionVars, generate, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Generate", "Types" ]


{-| enumType: Namespace -> String -> Type.Annotation -}
enumType : Elm.Expression -> String -> Elm.Expression
enumType enumTypeArg enumTypeArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "enumType"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" [], Type.string ]
                        (Type.namedWith [ "Type" ] "Annotation" [])
                    )
            }
        )
        [ enumTypeArg, Elm.string enumTypeArg0 ]


{-| toAliasedFields: 
    Namespace
    -> List ( String, Type.Annotation )
    -> List Can.Field
    -> Type.Annotation
-}
toAliasedFields :
    Elm.Expression
    -> List Elm.Expression
    -> List Elm.Expression
    -> Elm.Expression
toAliasedFields toAliasedFieldsArg toAliasedFieldsArg0 toAliasedFieldsArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "toAliasedFields"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [ "Type" ] "Annotation" [])
                            )
                        , Type.list (Type.namedWith [ "Can" ] "Field" [])
                        ]
                        (Type.namedWith [ "Type" ] "Annotation" [])
                    )
            }
        )
        [ toAliasedFieldsArg
        , Elm.list toAliasedFieldsArg0
        , Elm.list toAliasedFieldsArg1
        ]


{-| {-| -}

interfaceVariants: 
    Namespace
    -> Can.VariantCase
    -> { variants : List Elm.Variant, declarations : List Elm.Declaration }
    -> { variants : List Elm.Variant, declarations : List Elm.Declaration }
-}
interfaceVariants :
    Elm.Expression
    -> Elm.Expression
    -> { variants : List Elm.Expression, declarations : List Elm.Expression }
    -> Elm.Expression
interfaceVariants interfaceVariantsArg interfaceVariantsArg0 interfaceVariantsArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "interfaceVariants"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "VariantCase" []
                        , Type.record
                            [ ( "variants"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Variant" [])
                              )
                            , ( "declarations"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                              )
                            ]
                        ]
                        (Type.record
                            [ ( "variants"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Variant" [])
                              )
                            , ( "declarations"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                              )
                            ]
                        )
                    )
            }
        )
        [ interfaceVariantsArg
        , interfaceVariantsArg0
        , Elm.record
            [ Tuple.pair "variants" (Elm.list interfaceVariantsArg1.variants)
            , Tuple.pair
                "declarations"
                (Elm.list interfaceVariantsArg1.declarations)
            ]
        ]


{-| {-| -}

unionVars: 
    Namespace
    -> Can.VariantCase
    -> { variants : List Elm.Variant, declarations : List Elm.Declaration }
    -> { variants : List Elm.Variant, declarations : List Elm.Declaration }
-}
unionVars :
    Elm.Expression
    -> Elm.Expression
    -> { variants : List Elm.Expression, declarations : List Elm.Expression }
    -> Elm.Expression
unionVars unionVarsArg unionVarsArg0 unionVarsArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "unionVars"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "VariantCase" []
                        , Type.record
                            [ ( "variants"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Variant" [])
                              )
                            , ( "declarations"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                              )
                            ]
                        ]
                        (Type.record
                            [ ( "variants"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Variant" [])
                              )
                            , ( "declarations"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                              )
                            ]
                        )
                    )
            }
        )
        [ unionVarsArg
        , unionVarsArg0
        , Elm.record
            [ Tuple.pair "variants" (Elm.list unionVarsArg1.variants)
            , Tuple.pair "declarations" (Elm.list unionVarsArg1.declarations)
            ]
        ]


{-| {-| -}

generate: Namespace -> List Can.Field -> List Elm.Declaration
-}
generate : Elm.Expression -> List Elm.Expression -> Elm.Expression
generate generateArg generateArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.list (Type.namedWith [ "Can" ] "Field" [])
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ generateArg, Elm.list generateArg0 ]


call_ :
    { enumType : Elm.Expression -> Elm.Expression -> Elm.Expression
    , toAliasedFields :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , interfaceVariants :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , unionVars :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , generate : Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { enumType =
        \enumTypeArg enumTypeArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Types" ]
                    , name = "enumType"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.string
                                ]
                                (Type.namedWith [ "Type" ] "Annotation" [])
                            )
                    }
                )
                [ enumTypeArg, enumTypeArg0 ]
    , toAliasedFields =
        \toAliasedFieldsArg toAliasedFieldsArg0 toAliasedFieldsArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Types" ]
                    , name = "toAliasedFields"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith
                                            [ "Type" ]
                                            "Annotation"
                                            []
                                        )
                                    )
                                , Type.list
                                    (Type.namedWith [ "Can" ] "Field" [])
                                ]
                                (Type.namedWith [ "Type" ] "Annotation" [])
                            )
                    }
                )
                [ toAliasedFieldsArg, toAliasedFieldsArg0, toAliasedFieldsArg1 ]
    , interfaceVariants =
        \interfaceVariantsArg interfaceVariantsArg0 interfaceVariantsArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Types" ]
                    , name = "interfaceVariants"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith [ "Can" ] "VariantCase" []
                                , Type.record
                                    [ ( "variants"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Elm" ]
                                                "Variant"
                                                []
                                            )
                                      )
                                    , ( "declarations"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Elm" ]
                                                "Declaration"
                                                []
                                            )
                                      )
                                    ]
                                ]
                                (Type.record
                                    [ ( "variants"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Elm" ]
                                                "Variant"
                                                []
                                            )
                                      )
                                    , ( "declarations"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Elm" ]
                                                "Declaration"
                                                []
                                            )
                                      )
                                    ]
                                )
                            )
                    }
                )
                [ interfaceVariantsArg
                , interfaceVariantsArg0
                , interfaceVariantsArg1
                ]
    , unionVars =
        \unionVarsArg unionVarsArg0 unionVarsArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Types" ]
                    , name = "unionVars"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith [ "Can" ] "VariantCase" []
                                , Type.record
                                    [ ( "variants"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Elm" ]
                                                "Variant"
                                                []
                                            )
                                      )
                                    , ( "declarations"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Elm" ]
                                                "Declaration"
                                                []
                                            )
                                      )
                                    ]
                                ]
                                (Type.record
                                    [ ( "variants"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Elm" ]
                                                "Variant"
                                                []
                                            )
                                      )
                                    , ( "declarations"
                                      , Type.list
                                            (Type.namedWith
                                                [ "Elm" ]
                                                "Declaration"
                                                []
                                            )
                                      )
                                    ]
                                )
                            )
                    }
                )
                [ unionVarsArg, unionVarsArg0, unionVarsArg1 ]
    , generate =
        \generateArg generateArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Types" ]
                    , name = "generate"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.list
                                    (Type.namedWith [ "Can" ] "Field" [])
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ generateArg, generateArg0 ]
    }


values_ :
    { enumType : Elm.Expression
    , toAliasedFields : Elm.Expression
    , interfaceVariants : Elm.Expression
    , unionVars : Elm.Expression
    , generate : Elm.Expression
    }
values_ =
    { enumType =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "enumType"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" [], Type.string ]
                        (Type.namedWith [ "Type" ] "Annotation" [])
                    )
            }
    , toAliasedFields =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "toAliasedFields"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [ "Type" ] "Annotation" [])
                            )
                        , Type.list (Type.namedWith [ "Can" ] "Field" [])
                        ]
                        (Type.namedWith [ "Type" ] "Annotation" [])
                    )
            }
    , interfaceVariants =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "interfaceVariants"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "VariantCase" []
                        , Type.record
                            [ ( "variants"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Variant" [])
                              )
                            , ( "declarations"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                              )
                            ]
                        ]
                        (Type.record
                            [ ( "variants"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Variant" [])
                              )
                            , ( "declarations"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                              )
                            ]
                        )
                    )
            }
    , unionVars =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "unionVars"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "VariantCase" []
                        , Type.record
                            [ ( "variants"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Variant" [])
                              )
                            , ( "declarations"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                              )
                            ]
                        ]
                        (Type.record
                            [ ( "variants"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Variant" [])
                              )
                            , ( "declarations"
                              , Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                              )
                            ]
                        )
                    )
            }
    , generate =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.list (Type.namedWith [ "Can" ] "Field" [])
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    }
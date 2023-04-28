module Gen.GraphQL.Operations.Generate.Types exposing (call_, genAliasedTypes, interfaceVariants, moduleName_, toAliasedFields, unionVars, values_)

{-| 
@docs values_, call_, genAliasedTypes, unionVars, interfaceVariants, toAliasedFields, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Generate", "Types" ]


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


{-| genAliasedTypes: Namespace -> Can.Field -> List Elm.Declaration -}
genAliasedTypes : Elm.Expression -> Elm.Expression -> Elm.Expression
genAliasedTypes genAliasedTypesArg genAliasedTypesArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "genAliasedTypes"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "Field" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ genAliasedTypesArg, genAliasedTypesArg0 ]


call_ :
    { toAliasedFields :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , interfaceVariants :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , unionVars :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , genAliasedTypes : Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { toAliasedFields =
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
    , genAliasedTypes =
        \genAliasedTypesArg genAliasedTypesArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Types" ]
                    , name = "genAliasedTypes"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith [ "Can" ] "Field" []
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ genAliasedTypesArg, genAliasedTypesArg0 ]
    }


values_ :
    { toAliasedFields : Elm.Expression
    , interfaceVariants : Elm.Expression
    , unionVars : Elm.Expression
    , genAliasedTypes : Elm.Expression
    }
values_ =
    { toAliasedFields =
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
    , genAliasedTypes =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Types" ]
            , name = "genAliasedTypes"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "Field" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    }



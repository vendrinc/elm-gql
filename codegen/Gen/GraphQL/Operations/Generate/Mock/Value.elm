module Gen.GraphQL.Operations.Generate.Mock.Value exposing (builders, call_, field, moduleName_, values_, variantBuilders)

{-| 
@docs values_, call_, field, builders, variantBuilders, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Generate", "Mock", "Value" ]


{-| variantBuilders: 
    Generate.Path.Paths
    -> Namespace
    -> { parentField
        | globalAlias : Can.Name
        , selectsOnlyFragment :
            Maybe { importFrom : List String
            , importMockFrom : List String
            , name : String
            }
    }
    -> Can.FieldVariantDetails
    -> List Elm.Declaration
-}
variantBuilders :
    Elm.Expression
    -> Elm.Expression
    -> { parentField
        | globalAlias : Elm.Expression
        , selectsOnlyFragment : Elm.Expression
    }
    -> Elm.Expression
    -> Elm.Expression
variantBuilders variantBuildersArg variantBuildersArg0 variantBuildersArg1 variantBuildersArg2 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Generate", "Mock", "Value" ]
            , name = "variantBuilders"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Generate", "Path" ] "Paths" []
                        , Type.namedWith [] "Namespace" []
                        , Type.extensible
                            "parentField"
                            [ ( "globalAlias"
                              , Type.namedWith [ "Can" ] "Name" []
                              )
                            , ( "selectsOnlyFragment"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.record
                                        [ ( "importFrom"
                                          , Type.list Type.string
                                          )
                                        , ( "importMockFrom"
                                          , Type.list Type.string
                                          )
                                        , ( "name", Type.string )
                                        ]
                                    ]
                              )
                            ]
                        , Type.namedWith [ "Can" ] "FieldVariantDetails" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ variantBuildersArg
        , variantBuildersArg0
        , Elm.record
            [ Tuple.pair "globalAlias" variantBuildersArg1.globalAlias
            , Tuple.pair
                "selectsOnlyFragment"
                variantBuildersArg1.selectsOnlyFragment
            ]
        , variantBuildersArg2
        ]


{-| builders: Generate.Path.Paths -> Namespace -> Can.Field -> List Elm.Declaration -}
builders : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
builders buildersArg buildersArg0 buildersArg1 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Generate", "Mock", "Value" ]
            , name = "builders"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Generate", "Path" ] "Paths" []
                        , Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "Field" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ buildersArg, buildersArg0, buildersArg1 ]


{-| field: Namespace -> Can.Field -> Elm.Expression -}
field : Elm.Expression -> Elm.Expression -> Elm.Expression
field fieldArg fieldArg0 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Generate", "Mock", "Value" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "Field" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ fieldArg, fieldArg0 ]


call_ :
    { variantBuilders :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , builders :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , field : Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { variantBuilders =
        \variantBuildersArg variantBuildersArg0 variantBuildersArg1 variantBuildersArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Mock", "Value" ]
                    , name = "variantBuilders"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Generate", "Path" ]
                                    "Paths"
                                    []
                                , Type.namedWith [] "Namespace" []
                                , Type.extensible
                                    "parentField"
                                    [ ( "globalAlias"
                                      , Type.namedWith [ "Can" ] "Name" []
                                      )
                                    , ( "selectsOnlyFragment"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.record
                                                [ ( "importFrom"
                                                  , Type.list Type.string
                                                  )
                                                , ( "importMockFrom"
                                                  , Type.list Type.string
                                                  )
                                                , ( "name", Type.string )
                                                ]
                                            ]
                                      )
                                    ]
                                , Type.namedWith
                                    [ "Can" ]
                                    "FieldVariantDetails"
                                    []
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ variantBuildersArg
                , variantBuildersArg0
                , variantBuildersArg1
                , variantBuildersArg2
                ]
    , builders =
        \buildersArg buildersArg0 buildersArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Mock", "Value" ]
                    , name = "builders"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Generate", "Path" ]
                                    "Paths"
                                    []
                                , Type.namedWith [] "Namespace" []
                                , Type.namedWith [ "Can" ] "Field" []
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ buildersArg, buildersArg0, buildersArg1 ]
    , field =
        \fieldArg fieldArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Mock", "Value" ]
                    , name = "field"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith [ "Can" ] "Field" []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ fieldArg, fieldArg0 ]
    }


values_ :
    { variantBuilders : Elm.Expression
    , builders : Elm.Expression
    , field : Elm.Expression
    }
values_ =
    { variantBuilders =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Generate", "Mock", "Value" ]
            , name = "variantBuilders"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Generate", "Path" ] "Paths" []
                        , Type.namedWith [] "Namespace" []
                        , Type.extensible
                            "parentField"
                            [ ( "globalAlias"
                              , Type.namedWith [ "Can" ] "Name" []
                              )
                            , ( "selectsOnlyFragment"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.record
                                        [ ( "importFrom"
                                          , Type.list Type.string
                                          )
                                        , ( "importMockFrom"
                                          , Type.list Type.string
                                          )
                                        , ( "name", Type.string )
                                        ]
                                    ]
                              )
                            ]
                        , Type.namedWith [ "Can" ] "FieldVariantDetails" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    , builders =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Generate", "Mock", "Value" ]
            , name = "builders"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Generate", "Path" ] "Paths" []
                        , Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "Field" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    , field =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Generate", "Mock", "Value" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Can" ] "Field" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    }



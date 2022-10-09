module Gen.GraphQL.Operations.Canonicalize.Cache exposing (addFragment, addVars, annotation_, call_, empty, make_, merge, moduleName_, values_)

{-| 
@docs values_, call_, make_, annotation_, empty, addVars, addFragment, merge, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize", "Cache" ]


{-| merge: Cache -> Cache -> Cache -}
merge : Elm.Expression -> Elm.Expression -> Elm.Expression
merge mergeArg mergeArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "merge"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Cache" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ mergeArg, mergeArg0 ]


{-| addFragment: { fragment : Can.Fragment, alongsideOtherFields : Bool } -> Cache -> Cache -}
addFragment :
    { fragment : Elm.Expression, alongsideOtherFields : Bool }
    -> Elm.Expression
    -> Elm.Expression
addFragment addFragmentArg addFragmentArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addFragment"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "fragment"
                              , Type.namedWith [ "Can" ] "Fragment" []
                              )
                            , ( "alongsideOtherFields", Type.bool )
                            ]
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "fragment" addFragmentArg.fragment
            , Tuple.pair
                "alongsideOtherFields"
                (Elm.bool addFragmentArg.alongsideOtherFields)
            ]
        , addFragmentArg0
        ]


{-| addVars: List ( String, GraphQL.Schema.Type ) -> Cache -> Cache -}
addVars : List Elm.Expression -> Elm.Expression -> Elm.Expression
addVars addVarsArg addVarsArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addVars"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Type"
                                    []
                                )
                            )
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.list addVarsArg, addVarsArg0 ]


{-| empty: Cache -}
empty : Elm.Expression
empty =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
        , name = "empty"
        , annotation = Just (Type.namedWith [] "Cache" [])
        }


annotation_ : { cache : Type.Annotation }
annotation_ =
    { cache =
        Type.alias
            moduleName_
            "Cache"
            []
            (Type.record
                [ ( "varTypes"
                  , Type.list
                        (Type.tuple
                            Type.string
                            (Type.namedWith [ "GraphQL", "Schema" ] "Type" [])
                        )
                  )
                , ( "fragmentsUsed"
                  , Type.list
                        (Type.record
                            [ ( "fragment"
                              , Type.namedWith [ "Can" ] "Fragment" []
                              )
                            , ( "alongsideOtherFields", Type.bool )
                            ]
                        )
                  )
                ]
            )
    }


make_ :
    { cache :
        { varTypes : Elm.Expression, fragmentsUsed : Elm.Expression }
        -> Elm.Expression
    }
make_ =
    { cache =
        \cache_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    "Cache"
                    []
                    (Type.record
                        [ ( "varTypes"
                          , Type.list
                                (Type.tuple
                                    Type.string
                                    (Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Type"
                                        []
                                    )
                                )
                          )
                        , ( "fragmentsUsed"
                          , Type.list
                                (Type.record
                                    [ ( "fragment"
                                      , Type.namedWith [ "Can" ] "Fragment" []
                                      )
                                    , ( "alongsideOtherFields", Type.bool )
                                    ]
                                )
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "varTypes" cache_args.varTypes
                    , Tuple.pair "fragmentsUsed" cache_args.fragmentsUsed
                    ]
                )
    }


call_ :
    { merge : Elm.Expression -> Elm.Expression -> Elm.Expression
    , addFragment : Elm.Expression -> Elm.Expression -> Elm.Expression
    , addVars : Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { merge =
        \mergeArg mergeArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "merge"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Cache" []
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ mergeArg, mergeArg0 ]
    , addFragment =
        \addFragmentArg addFragmentArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "addFragment"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "fragment"
                                      , Type.namedWith [ "Can" ] "Fragment" []
                                      )
                                    , ( "alongsideOtherFields", Type.bool )
                                    ]
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ addFragmentArg, addFragmentArg0 ]
    , addVars =
        \addVarsArg addVarsArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "addVars"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith
                                            [ "GraphQL", "Schema" ]
                                            "Type"
                                            []
                                        )
                                    )
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ addVarsArg, addVarsArg0 ]
    }


values_ :
    { merge : Elm.Expression
    , addFragment : Elm.Expression
    , addVars : Elm.Expression
    , empty : Elm.Expression
    }
values_ =
    { merge =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "merge"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Cache" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , addFragment =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addFragment"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "fragment"
                              , Type.namedWith [ "Can" ] "Fragment" []
                              )
                            , ( "alongsideOtherFields", Type.bool )
                            ]
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , addVars =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addVars"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Type"
                                    []
                                )
                            )
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , empty =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "empty"
            , annotation = Just (Type.namedWith [] "Cache" [])
            }
    }



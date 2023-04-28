module Gen.GraphQL.Operations.Canonicalize.Cache exposing (addFragment, addLevel, addLevelKeepSiblingStack, addVars, annotation_, call_, getGlobalName, init, levelFromField, make_, moduleName_, saveSibling, siblingCollision, values_)

{-| 
@docs values_, call_, make_, annotation_, init, addVars, addFragment, addLevelKeepSiblingStack, addLevel, getGlobalName, saveSibling, siblingCollision, levelFromField, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize", "Cache" ]


{-| levelFromField: 
    { field | name : AST.Name, alias_ : Maybe AST.Name }
    -> { name : String, isAlias : Bool }
-}
levelFromField :
    { field | name : Elm.Expression, alias_ : Elm.Expression } -> Elm.Expression
levelFromField levelFromFieldArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "levelFromField"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "field"
                            [ ( "name", Type.namedWith [ "AST" ] "Name" [] )
                            , ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [ "AST" ] "Name" [] ]
                              )
                            ]
                        ]
                        (Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        )
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" levelFromFieldArg.name
            , Tuple.pair "alias_" levelFromFieldArg.alias_
            ]
        ]


{-| siblingCollision: UsedNames.Sibling -> Cache -> Bool -}
siblingCollision : Elm.Expression -> Elm.Expression -> Elm.Expression
siblingCollision siblingCollisionArg siblingCollisionArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "siblingCollision"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "UsedNames" ] "Sibling" []
                        , Type.namedWith [] "Cache" []
                        ]
                        Type.bool
                    )
            }
        )
        [ siblingCollisionArg, siblingCollisionArg0 ]


{-| saveSibling: UsedNames.Sibling -> Cache -> Cache -}
saveSibling : Elm.Expression -> Elm.Expression -> Elm.Expression
saveSibling saveSiblingArg saveSiblingArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "saveSibling"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "UsedNames" ] "Sibling" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ saveSiblingArg, saveSiblingArg0 ]


{-| getGlobalName: String -> Cache -> { globalName : String, used : Cache } -}
getGlobalName : String -> Elm.Expression -> Elm.Expression
getGlobalName getGlobalNameArg getGlobalNameArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "getGlobalName"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "Cache" [] ]
                        (Type.record
                            [ ( "globalName", Type.string )
                            , ( "used", Type.namedWith [] "Cache" [] )
                            ]
                        )
                    )
            }
        )
        [ Elm.string getGlobalNameArg, getGlobalNameArg0 ]


{-| addLevel: { name : String, isAlias : Bool } -> Cache -> Cache -}
addLevel : { name : String, isAlias : Bool } -> Elm.Expression -> Elm.Expression
addLevel addLevelArg addLevelArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addLevel"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" (Elm.string addLevelArg.name)
            , Tuple.pair "isAlias" (Elm.bool addLevelArg.isAlias)
            ]
        , addLevelArg0
        ]


{-| addLevelKeepSiblingStack: { name : String, isAlias : Bool } -> Cache -> Cache -}
addLevelKeepSiblingStack :
    { name : String, isAlias : Bool } -> Elm.Expression -> Elm.Expression
addLevelKeepSiblingStack addLevelKeepSiblingStackArg addLevelKeepSiblingStackArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addLevelKeepSiblingStack"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" (Elm.string addLevelKeepSiblingStackArg.name)
            , Tuple.pair
                "isAlias"
                (Elm.bool addLevelKeepSiblingStackArg.isAlias)
            ]
        , addLevelKeepSiblingStackArg0
        ]


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


{-| init: { reservedNames : List String } -> Cache -}
init : { reservedNames : List String } -> Elm.Expression
init initArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "init"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "reservedNames", Type.list Type.string ) ]
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair
                "reservedNames"
                (Elm.list (List.map Elm.string initArg.reservedNames))
            ]
        ]


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
                , ( "usedNames", Type.namedWith [ "UsedNames" ] "UsedNames" [] )
                ]
            )
    }


make_ :
    { cache :
        { varTypes : Elm.Expression
        , fragmentsUsed : Elm.Expression
        , usedNames : Elm.Expression
        }
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
                        , ( "usedNames"
                          , Type.namedWith [ "UsedNames" ] "UsedNames" []
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "varTypes" cache_args.varTypes
                    , Tuple.pair "fragmentsUsed" cache_args.fragmentsUsed
                    , Tuple.pair "usedNames" cache_args.usedNames
                    ]
                )
    }


call_ :
    { levelFromField : Elm.Expression -> Elm.Expression
    , siblingCollision : Elm.Expression -> Elm.Expression -> Elm.Expression
    , saveSibling : Elm.Expression -> Elm.Expression -> Elm.Expression
    , getGlobalName : Elm.Expression -> Elm.Expression -> Elm.Expression
    , addLevel : Elm.Expression -> Elm.Expression -> Elm.Expression
    , addLevelKeepSiblingStack :
        Elm.Expression -> Elm.Expression -> Elm.Expression
    , addFragment : Elm.Expression -> Elm.Expression -> Elm.Expression
    , addVars : Elm.Expression -> Elm.Expression -> Elm.Expression
    , init : Elm.Expression -> Elm.Expression
    }
call_ =
    { levelFromField =
        \levelFromFieldArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "levelFromField"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.extensible
                                    "field"
                                    [ ( "name"
                                      , Type.namedWith [ "AST" ] "Name" []
                                      )
                                    , ( "alias_"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.namedWith [ "AST" ] "Name" []
                                            ]
                                      )
                                    ]
                                ]
                                (Type.record
                                    [ ( "name", Type.string )
                                    , ( "isAlias", Type.bool )
                                    ]
                                )
                            )
                    }
                )
                [ levelFromFieldArg ]
    , siblingCollision =
        \siblingCollisionArg siblingCollisionArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "siblingCollision"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "UsedNames" ] "Sibling" []
                                , Type.namedWith [] "Cache" []
                                ]
                                Type.bool
                            )
                    }
                )
                [ siblingCollisionArg, siblingCollisionArg0 ]
    , saveSibling =
        \saveSiblingArg saveSiblingArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "saveSibling"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "UsedNames" ] "Sibling" []
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ saveSiblingArg, saveSiblingArg0 ]
    , getGlobalName =
        \getGlobalNameArg getGlobalNameArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "getGlobalName"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string, Type.namedWith [] "Cache" [] ]
                                (Type.record
                                    [ ( "globalName", Type.string )
                                    , ( "used", Type.namedWith [] "Cache" [] )
                                    ]
                                )
                            )
                    }
                )
                [ getGlobalNameArg, getGlobalNameArg0 ]
    , addLevel =
        \addLevelArg addLevelArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "addLevel"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "name", Type.string )
                                    , ( "isAlias", Type.bool )
                                    ]
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ addLevelArg, addLevelArg0 ]
    , addLevelKeepSiblingStack =
        \addLevelKeepSiblingStackArg addLevelKeepSiblingStackArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "addLevelKeepSiblingStack"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "name", Type.string )
                                    , ( "isAlias", Type.bool )
                                    ]
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ addLevelKeepSiblingStackArg, addLevelKeepSiblingStackArg0 ]
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
    , init =
        \initArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "init"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "reservedNames", Type.list Type.string )
                                    ]
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ initArg ]
    }


values_ :
    { levelFromField : Elm.Expression
    , siblingCollision : Elm.Expression
    , saveSibling : Elm.Expression
    , getGlobalName : Elm.Expression
    , addLevel : Elm.Expression
    , addLevelKeepSiblingStack : Elm.Expression
    , addFragment : Elm.Expression
    , addVars : Elm.Expression
    , init : Elm.Expression
    }
values_ =
    { levelFromField =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "levelFromField"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "field"
                            [ ( "name", Type.namedWith [ "AST" ] "Name" [] )
                            , ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [ "AST" ] "Name" [] ]
                              )
                            ]
                        ]
                        (Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        )
                    )
            }
    , siblingCollision =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "siblingCollision"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "UsedNames" ] "Sibling" []
                        , Type.namedWith [] "Cache" []
                        ]
                        Type.bool
                    )
            }
    , saveSibling =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "saveSibling"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "UsedNames" ] "Sibling" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , getGlobalName =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "getGlobalName"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "Cache" [] ]
                        (Type.record
                            [ ( "globalName", Type.string )
                            , ( "used", Type.namedWith [] "Cache" [] )
                            ]
                        )
                    )
            }
    , addLevel =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addLevel"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , addLevelKeepSiblingStack =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addLevelKeepSiblingStack"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
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
    , init =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "init"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "reservedNames", Type.list Type.string ) ]
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    }



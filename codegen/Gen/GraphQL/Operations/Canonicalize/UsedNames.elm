module Gen.GraphQL.Operations.Canonicalize.UsedNames exposing (addLevel, annotation_, call_, dropLevel, empty, getGlobalName, levelFromField, moduleName_, resetSiblings, saveSibling, siblingCollision, values_)

{-| 
@docs values_, call_, annotation_, empty, saveSibling, siblingCollision, getGlobalName, levelFromField, addLevel, dropLevel, resetSiblings, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]


{-| {-| -}

resetSiblings: UsedNames -> UsedNames -> UsedNames
-}
resetSiblings : Elm.Expression -> Elm.Expression -> Elm.Expression
resetSiblings resetSiblingsArg resetSiblingsArg0 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "resetSiblings"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "UsedNames" []
                        , Type.namedWith [] "UsedNames" []
                        ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
        )
        [ resetSiblingsArg, resetSiblingsArg0 ]


{-| {-| -}

dropLevel: UsedNames -> UsedNames
-}
dropLevel : Elm.Expression -> Elm.Expression
dropLevel dropLevelArg =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "dropLevel"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "UsedNames" [] ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
        )
        [ dropLevelArg ]


{-| {-|

    levels should be the alias name

-}

addLevel: { name : String, isAlias : Bool } -> UsedNames -> UsedNames
-}
addLevel : { name : String, isAlias : Bool } -> Elm.Expression -> Elm.Expression
addLevel addLevelArg addLevelArg0 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "addLevel"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        , Type.namedWith [] "UsedNames" []
                        ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" (Elm.string addLevelArg.name)
            , Tuple.pair "isAlias" (Elm.bool addLevelArg.isAlias)
            ]
        , addLevelArg0
        ]


{-| levelFromField: 
    { field | name : AST.Name, alias_ : Maybe AST.Name }
    -> { name : String, isAlias : Bool }
-}
levelFromField :
    { field | name : Elm.Expression, alias_ : Elm.Expression } -> Elm.Expression
levelFromField levelFromFieldArg =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
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


{-| {-|

    This will retrieve a globally unique name.
    The intention is that an aliased name is passed in.
    If it's used, then this returns nothing
    and the query should fail to compile.
    If not, then a new globally unique name is returend that can be used for code generation.

-}

getGlobalName: String -> UsedNames -> { globalName : String, used : UsedNames }
-}
getGlobalName : String -> Elm.Expression -> Elm.Expression
getGlobalName getGlobalNameArg getGlobalNameArg0 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "getGlobalName"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "UsedNames" [] ]
                        (Type.record
                            [ ( "globalName", Type.string )
                            , ( "used", Type.namedWith [] "UsedNames" [] )
                            ]
                        )
                    )
            }
        )
        [ Elm.string getGlobalNameArg, getGlobalNameArg0 ]


{-| siblingCollision: String -> UsedNames -> Bool -}
siblingCollision : String -> Elm.Expression -> Elm.Expression
siblingCollision siblingCollisionArg siblingCollisionArg0 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "siblingCollision"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "UsedNames" [] ]
                        Type.bool
                    )
            }
        )
        [ Elm.string siblingCollisionArg, siblingCollisionArg0 ]


{-| saveSibling: String -> UsedNames -> UsedNames -}
saveSibling : String -> Elm.Expression -> Elm.Expression
saveSibling saveSiblingArg saveSiblingArg0 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "saveSibling"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "UsedNames" [] ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
        )
        [ Elm.string saveSiblingArg, saveSiblingArg0 ]


{-| empty: UsedNames -}
empty : Elm.Expression
empty =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
        , name = "empty"
        , annotation = Just (Type.namedWith [] "UsedNames" [])
        }


annotation_ : { usedNames : Type.Annotation }
annotation_ =
    { usedNames =
        Type.namedWith
            [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            "UsedNames"
            []
    }


call_ :
    { resetSiblings : Elm.Expression -> Elm.Expression -> Elm.Expression
    , dropLevel : Elm.Expression -> Elm.Expression
    , addLevel : Elm.Expression -> Elm.Expression -> Elm.Expression
    , levelFromField : Elm.Expression -> Elm.Expression
    , getGlobalName : Elm.Expression -> Elm.Expression -> Elm.Expression
    , siblingCollision : Elm.Expression -> Elm.Expression -> Elm.Expression
    , saveSibling : Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { resetSiblings =
        \resetSiblingsArg resetSiblingsArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
                    , name = "resetSiblings"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "UsedNames" []
                                , Type.namedWith [] "UsedNames" []
                                ]
                                (Type.namedWith [] "UsedNames" [])
                            )
                    }
                )
                [ resetSiblingsArg, resetSiblingsArg0 ]
    , dropLevel =
        \dropLevelArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
                    , name = "dropLevel"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "UsedNames" [] ]
                                (Type.namedWith [] "UsedNames" [])
                            )
                    }
                )
                [ dropLevelArg ]
    , addLevel =
        \addLevelArg addLevelArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
                    , name = "addLevel"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "name", Type.string )
                                    , ( "isAlias", Type.bool )
                                    ]
                                , Type.namedWith [] "UsedNames" []
                                ]
                                (Type.namedWith [] "UsedNames" [])
                            )
                    }
                )
                [ addLevelArg, addLevelArg0 ]
    , levelFromField =
        \levelFromFieldArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
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
    , getGlobalName =
        \getGlobalNameArg getGlobalNameArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
                    , name = "getGlobalName"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "UsedNames" []
                                ]
                                (Type.record
                                    [ ( "globalName", Type.string )
                                    , ( "used"
                                      , Type.namedWith [] "UsedNames" []
                                      )
                                    ]
                                )
                            )
                    }
                )
                [ getGlobalNameArg, getGlobalNameArg0 ]
    , siblingCollision =
        \siblingCollisionArg siblingCollisionArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
                    , name = "siblingCollision"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "UsedNames" []
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
                        [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
                    , name = "saveSibling"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "UsedNames" []
                                ]
                                (Type.namedWith [] "UsedNames" [])
                            )
                    }
                )
                [ saveSiblingArg, saveSiblingArg0 ]
    }


values_ :
    { resetSiblings : Elm.Expression
    , dropLevel : Elm.Expression
    , addLevel : Elm.Expression
    , levelFromField : Elm.Expression
    , getGlobalName : Elm.Expression
    , siblingCollision : Elm.Expression
    , saveSibling : Elm.Expression
    , empty : Elm.Expression
    }
values_ =
    { resetSiblings =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "resetSiblings"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "UsedNames" []
                        , Type.namedWith [] "UsedNames" []
                        ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
    , dropLevel =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "dropLevel"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "UsedNames" [] ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
    , addLevel =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "addLevel"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        , Type.namedWith [] "UsedNames" []
                        ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
    , levelFromField =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
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
    , getGlobalName =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "getGlobalName"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "UsedNames" [] ]
                        (Type.record
                            [ ( "globalName", Type.string )
                            , ( "used", Type.namedWith [] "UsedNames" [] )
                            ]
                        )
                    )
            }
    , siblingCollision =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "siblingCollision"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "UsedNames" [] ]
                        Type.bool
                    )
            }
    , saveSibling =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "saveSibling"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "UsedNames" [] ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
    , empty =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "empty"
            , annotation = Just (Type.namedWith [] "UsedNames" [])
            }
    }



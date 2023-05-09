module Gen.GraphQL.Operations.Canonicalize.UsedNames exposing (addLevel, addLevelKeepSiblingStack, annotation_, call_, dropLevel, dropLevelNotSiblings, getGlobalName, init, levelFromField, make_, moduleName_, saveSibling, siblingCollision, values_)

{-| 
@docs values_, call_, make_, annotation_, init, saveSibling, siblingCollision, getGlobalName, levelFromField, addLevel, addLevelKeepSiblingStack, dropLevelNotSiblings, dropLevel, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]


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


{-| {-| -}

dropLevelNotSiblings: UsedNames -> UsedNames
-}
dropLevelNotSiblings : Elm.Expression -> Elm.Expression
dropLevelNotSiblings dropLevelNotSiblingsArg =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "dropLevelNotSiblings"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "UsedNames" [] ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
        )
        [ dropLevelNotSiblingsArg ]


{-| {-|

    levels should be the alias name

-}

addLevelKeepSiblingStack: { name : String, isAlias : Bool } -> UsedNames -> UsedNames
-}
addLevelKeepSiblingStack :
    { name : String, isAlias : Bool } -> Elm.Expression -> Elm.Expression
addLevelKeepSiblingStack addLevelKeepSiblingStackArg addLevelKeepSiblingStackArg0 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "addLevelKeepSiblingStack"
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
            [ Tuple.pair "name" (Elm.string addLevelKeepSiblingStackArg.name)
            , Tuple.pair
                "isAlias"
                (Elm.bool addLevelKeepSiblingStackArg.isAlias)
            ]
        , addLevelKeepSiblingStackArg0
        ]


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


{-| siblingCollision: Sibling -> UsedNames -> Bool -}
siblingCollision : Elm.Expression -> Elm.Expression -> Elm.Expression
siblingCollision siblingCollisionArg siblingCollisionArg0 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "siblingCollision"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Sibling" []
                        , Type.namedWith [] "UsedNames" []
                        ]
                        Type.bool
                    )
            }
        )
        [ siblingCollisionArg, siblingCollisionArg0 ]


{-| saveSibling: Sibling -> UsedNames -> UsedNames -}
saveSibling : Elm.Expression -> Elm.Expression -> Elm.Expression
saveSibling saveSiblingArg saveSiblingArg0 =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "saveSibling"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Sibling" []
                        , Type.namedWith [] "UsedNames" []
                        ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
        )
        [ saveSiblingArg, saveSiblingArg0 ]


{-| init: List String -> UsedNames -}
init : List String -> Elm.Expression
init initArg =
    Elm.apply
        (Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "init"
            , annotation =
                Just
                    (Type.function
                        [ Type.list Type.string ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
        )
        [ Elm.list (List.map Elm.string initArg) ]


annotation_ : { sibling : Type.Annotation, usedNames : Type.Annotation }
annotation_ =
    { sibling =
        Type.alias
            moduleName_
            "Sibling"
            []
            (Type.record
                [ ( "aliasedName", Type.string )
                , ( "scalar", Type.namedWith [] "Maybe" [ Type.string ] )
                ]
            )
    , usedNames =
        Type.namedWith
            [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            "UsedNames"
            []
    }


make_ :
    { sibling :
        { aliasedName : Elm.Expression, scalar : Elm.Expression }
        -> Elm.Expression
    }
make_ =
    { sibling =
        \sibling_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
                    "Sibling"
                    []
                    (Type.record
                        [ ( "aliasedName", Type.string )
                        , ( "scalar"
                          , Type.namedWith [] "Maybe" [ Type.string ]
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "aliasedName" sibling_args.aliasedName
                    , Tuple.pair "scalar" sibling_args.scalar
                    ]
                )
    }


call_ :
    { dropLevel : Elm.Expression -> Elm.Expression
    , dropLevelNotSiblings : Elm.Expression -> Elm.Expression
    , addLevelKeepSiblingStack :
        Elm.Expression -> Elm.Expression -> Elm.Expression
    , addLevel : Elm.Expression -> Elm.Expression -> Elm.Expression
    , levelFromField : Elm.Expression -> Elm.Expression
    , getGlobalName : Elm.Expression -> Elm.Expression -> Elm.Expression
    , siblingCollision : Elm.Expression -> Elm.Expression -> Elm.Expression
    , saveSibling : Elm.Expression -> Elm.Expression -> Elm.Expression
    , init : Elm.Expression -> Elm.Expression
    }
call_ =
    { dropLevel =
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
    , dropLevelNotSiblings =
        \dropLevelNotSiblingsArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
                    , name = "dropLevelNotSiblings"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "UsedNames" [] ]
                                (Type.namedWith [] "UsedNames" [])
                            )
                    }
                )
                [ dropLevelNotSiblingsArg ]
    , addLevelKeepSiblingStack =
        \addLevelKeepSiblingStackArg addLevelKeepSiblingStackArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
                    , name = "addLevelKeepSiblingStack"
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
                [ addLevelKeepSiblingStackArg, addLevelKeepSiblingStackArg0 ]
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
                                [ Type.namedWith [] "Sibling" []
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
                                [ Type.namedWith [] "Sibling" []
                                , Type.namedWith [] "UsedNames" []
                                ]
                                (Type.namedWith [] "UsedNames" [])
                            )
                    }
                )
                [ saveSiblingArg, saveSiblingArg0 ]
    , init =
        \initArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
                    , name = "init"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list Type.string ]
                                (Type.namedWith [] "UsedNames" [])
                            )
                    }
                )
                [ initArg ]
    }


values_ :
    { dropLevel : Elm.Expression
    , dropLevelNotSiblings : Elm.Expression
    , addLevelKeepSiblingStack : Elm.Expression
    , addLevel : Elm.Expression
    , levelFromField : Elm.Expression
    , getGlobalName : Elm.Expression
    , siblingCollision : Elm.Expression
    , saveSibling : Elm.Expression
    , init : Elm.Expression
    }
values_ =
    { dropLevel =
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
    , dropLevelNotSiblings =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "dropLevelNotSiblings"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "UsedNames" [] ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
    , addLevelKeepSiblingStack =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "addLevelKeepSiblingStack"
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
                        [ Type.namedWith [] "Sibling" []
                        , Type.namedWith [] "UsedNames" []
                        ]
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
                        [ Type.namedWith [] "Sibling" []
                        , Type.namedWith [] "UsedNames" []
                        ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
    , init =
        Elm.value
            { importFrom =
                [ "GraphQL", "Operations", "Canonicalize", "UsedNames" ]
            , name = "init"
            , annotation =
                Just
                    (Type.function
                        [ Type.list Type.string ]
                        (Type.namedWith [] "UsedNames" [])
                    )
            }
    }



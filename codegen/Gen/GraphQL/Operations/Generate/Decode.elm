module Gen.GraphQL.Operations.Generate.Decode exposing (annotation_, call_, decodeFields, decodeInterface, decodeUnion, initIndex, make_, moduleName_, removeTypename, values_)

{-| 
@docs values_, call_, make_, annotation_, initIndex, decodeFields, decodeInterface, decodeUnion, removeTypename, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Generate", "Decode" ]


{-| removeTypename: Can.Field -> Bool -}
removeTypename : Elm.Expression -> Elm.Expression
removeTypename removeTypenameArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Decode" ]
            , name = "removeTypename"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Can" ] "Field" [] ]
                        Type.bool
                    )
            }
        )
        [ removeTypenameArg ]


{-| decodeUnion: 
    Namespace
    -> Elm.Expression
    -> Index
    -> Can.FieldVariantDetails
    -> Elm.Expression
-}
decodeUnion :
    Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
decodeUnion decodeUnionArg decodeUnionArg0 decodeUnionArg1 decodeUnionArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Decode" ]
            , name = "decodeUnion"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        , Type.namedWith [] "Index" []
                        , Type.namedWith [ "Can" ] "FieldVariantDetails" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ decodeUnionArg, decodeUnionArg0, decodeUnionArg1, decodeUnionArg2 ]


{-| decodeInterface: 
    Namespace
    -> Elm.Expression
    -> Index
    -> Can.FieldVariantDetails
    -> Elm.Expression
    -> Elm.Expression
-}
decodeInterface :
    Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
decodeInterface decodeInterfaceArg decodeInterfaceArg0 decodeInterfaceArg1 decodeInterfaceArg2 decodeInterfaceArg3 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Decode" ]
            , name = "decodeInterface"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        , Type.namedWith [] "Index" []
                        , Type.namedWith [ "Can" ] "FieldVariantDetails" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ decodeInterfaceArg
        , decodeInterfaceArg0
        , decodeInterfaceArg1
        , decodeInterfaceArg2
        , decodeInterfaceArg3
        ]


{-| decodeFields: 
    Namespace
    -> Elm.Expression
    -> Index
    -> List Can.Field
    -> Elm.Expression
    -> Elm.Expression
-}
decodeFields :
    Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> List Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
decodeFields decodeFieldsArg decodeFieldsArg0 decodeFieldsArg1 decodeFieldsArg2 decodeFieldsArg3 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Decode" ]
            , name = "decodeFields"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        , Type.namedWith [] "Index" []
                        , Type.list (Type.namedWith [ "Can" ] "Field" [])
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ decodeFieldsArg
        , decodeFieldsArg0
        , decodeFieldsArg1
        , Elm.list decodeFieldsArg2
        , decodeFieldsArg3
        ]


{-| initIndex: Index -}
initIndex : Elm.Expression
initIndex =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Generate", "Decode" ]
        , name = "initIndex"
        , annotation = Just (Type.namedWith [] "Index" [])
        }


annotation_ : { namespace : Type.Annotation }
annotation_ =
    { namespace =
        Type.alias
            moduleName_
            "Namespace"
            []
            (Type.record
                [ ( "namespace", Type.string ), ( "enums", Type.string ) ]
            )
    }


make_ :
    { namespace :
        { namespace : Elm.Expression, enums : Elm.Expression } -> Elm.Expression
    }
make_ =
    { namespace =
        \namespace_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Generate", "Decode" ]
                    "Namespace"
                    []
                    (Type.record
                        [ ( "namespace", Type.string )
                        , ( "enums", Type.string )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "namespace" namespace_args.namespace
                    , Tuple.pair "enums" namespace_args.enums
                    ]
                )
    }


call_ :
    { removeTypename : Elm.Expression -> Elm.Expression
    , decodeUnion :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , decodeInterface :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , decodeFields :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    }
call_ =
    { removeTypename =
        \removeTypenameArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Decode" ]
                    , name = "removeTypename"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Can" ] "Field" [] ]
                                Type.bool
                            )
                    }
                )
                [ removeTypenameArg ]
    , decodeUnion =
        \decodeUnionArg decodeUnionArg0 decodeUnionArg1 decodeUnionArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Decode" ]
                    , name = "decodeUnion"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith [ "Elm" ] "Expression" []
                                , Type.namedWith [] "Index" []
                                , Type.namedWith
                                    [ "Can" ]
                                    "FieldVariantDetails"
                                    []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ decodeUnionArg
                , decodeUnionArg0
                , decodeUnionArg1
                , decodeUnionArg2
                ]
    , decodeInterface =
        \decodeInterfaceArg decodeInterfaceArg0 decodeInterfaceArg1 decodeInterfaceArg2 decodeInterfaceArg3 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Decode" ]
                    , name = "decodeInterface"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith [ "Elm" ] "Expression" []
                                , Type.namedWith [] "Index" []
                                , Type.namedWith
                                    [ "Can" ]
                                    "FieldVariantDetails"
                                    []
                                , Type.namedWith [ "Elm" ] "Expression" []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ decodeInterfaceArg
                , decodeInterfaceArg0
                , decodeInterfaceArg1
                , decodeInterfaceArg2
                , decodeInterfaceArg3
                ]
    , decodeFields =
        \decodeFieldsArg decodeFieldsArg0 decodeFieldsArg1 decodeFieldsArg2 decodeFieldsArg3 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Decode" ]
                    , name = "decodeFields"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith [ "Elm" ] "Expression" []
                                , Type.namedWith [] "Index" []
                                , Type.list
                                    (Type.namedWith [ "Can" ] "Field" [])
                                , Type.namedWith [ "Elm" ] "Expression" []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ decodeFieldsArg
                , decodeFieldsArg0
                , decodeFieldsArg1
                , decodeFieldsArg2
                , decodeFieldsArg3
                ]
    }


values_ :
    { removeTypename : Elm.Expression
    , decodeUnion : Elm.Expression
    , decodeInterface : Elm.Expression
    , decodeFields : Elm.Expression
    , initIndex : Elm.Expression
    }
values_ =
    { removeTypename =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Decode" ]
            , name = "removeTypename"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Can" ] "Field" [] ]
                        Type.bool
                    )
            }
    , decodeUnion =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Decode" ]
            , name = "decodeUnion"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        , Type.namedWith [] "Index" []
                        , Type.namedWith [ "Can" ] "FieldVariantDetails" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , decodeInterface =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Decode" ]
            , name = "decodeInterface"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        , Type.namedWith [] "Index" []
                        , Type.namedWith [ "Can" ] "FieldVariantDetails" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , decodeFields =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Decode" ]
            , name = "decodeFields"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "Elm" ] "Expression" []
                        , Type.namedWith [] "Index" []
                        , Type.list (Type.namedWith [ "Can" ] "Field" [])
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , initIndex =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Decode" ]
            , name = "initIndex"
            , annotation = Just (Type.namedWith [] "Index" [])
            }
    }



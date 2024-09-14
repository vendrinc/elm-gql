module Gen.Generate.Path exposing (annotation_, call_, fragment, fragmentGlobal, make_, moduleName_, operation, values_)

{-| 
@docs moduleName_, operation, fragmentGlobal, fragment, annotation_, make_, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Path" ]


{-| operation: 
    { name : String, path : String, queryDir : List String }
    -> { modulePath : List String
    , mockModulePath : List String
    , filePath : String
    , mockModuleFilePath : String
    }
-}
operation :
    { name : String, path : String, queryDir : List String } -> Elm.Expression
operation operationArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Path" ]
            , name = "operation"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "path", Type.string )
                            , ( "queryDir", Type.list Type.string )
                            ]
                        ]
                        (Type.record
                            [ ( "modulePath", Type.list Type.string )
                            , ( "mockModulePath", Type.list Type.string )
                            , ( "filePath", Type.string )
                            , ( "mockModuleFilePath", Type.string )
                            ]
                        )
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" (Elm.string operationArg.name)
            , Tuple.pair "path" (Elm.string operationArg.path)
            , Tuple.pair
                "queryDir"
                (Elm.list (List.map Elm.string operationArg.queryDir))
            ]
        ]


{-| fragmentGlobal: 
    { name : String, namespace : String, path : String, queryDir : List String }
    -> Paths
-}
fragmentGlobal :
    { name : String, namespace : String, path : String, queryDir : List String }
    -> Elm.Expression
fragmentGlobal fragmentGlobalArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Path" ]
            , name = "fragmentGlobal"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "namespace", Type.string )
                            , ( "path", Type.string )
                            , ( "queryDir", Type.list Type.string )
                            ]
                        ]
                        (Type.namedWith [] "Paths" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" (Elm.string fragmentGlobalArg.name)
            , Tuple.pair "namespace" (Elm.string fragmentGlobalArg.namespace)
            , Tuple.pair "path" (Elm.string fragmentGlobalArg.path)
            , Tuple.pair
                "queryDir"
                (Elm.list (List.map Elm.string fragmentGlobalArg.queryDir))
            ]
        ]


{-| fragment: { name : String, path : String, queryDir : List String } -> Paths -}
fragment :
    { name : String, path : String, queryDir : List String } -> Elm.Expression
fragment fragmentArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Path" ]
            , name = "fragment"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "path", Type.string )
                            , ( "queryDir", Type.list Type.string )
                            ]
                        ]
                        (Type.namedWith [] "Paths" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" (Elm.string fragmentArg.name)
            , Tuple.pair "path" (Elm.string fragmentArg.path)
            , Tuple.pair
                "queryDir"
                (Elm.list (List.map Elm.string fragmentArg.queryDir))
            ]
        ]


annotation_ : { paths : Type.Annotation }
annotation_ =
    { paths =
        Type.alias
            moduleName_
            "Paths"
            []
            (Type.record
                [ ( "modulePath", Type.list Type.string )
                , ( "mockModulePath", Type.list Type.string )
                , ( "filePath", Type.string )
                , ( "mockModuleFilePath", Type.string )
                ]
            )
    }


make_ :
    { paths :
        { modulePath : Elm.Expression
        , mockModulePath : Elm.Expression
        , filePath : Elm.Expression
        , mockModuleFilePath : Elm.Expression
        }
        -> Elm.Expression
    }
make_ =
    { paths =
        \paths_args ->
            Elm.withType
                (Type.alias
                    [ "Generate", "Path" ]
                    "Paths"
                    []
                    (Type.record
                        [ ( "modulePath", Type.list Type.string )
                        , ( "mockModulePath", Type.list Type.string )
                        , ( "filePath", Type.string )
                        , ( "mockModuleFilePath", Type.string )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "modulePath" paths_args.modulePath
                    , Tuple.pair "mockModulePath" paths_args.mockModulePath
                    , Tuple.pair "filePath" paths_args.filePath
                    , Tuple.pair
                        "mockModuleFilePath"
                        paths_args.mockModuleFilePath
                    ]
                )
    }


call_ :
    { operation : Elm.Expression -> Elm.Expression
    , fragmentGlobal : Elm.Expression -> Elm.Expression
    , fragment : Elm.Expression -> Elm.Expression
    }
call_ =
    { operation =
        \operationArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Path" ]
                    , name = "operation"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "name", Type.string )
                                    , ( "path", Type.string )
                                    , ( "queryDir", Type.list Type.string )
                                    ]
                                ]
                                (Type.record
                                    [ ( "modulePath", Type.list Type.string )
                                    , ( "mockModulePath"
                                      , Type.list Type.string
                                      )
                                    , ( "filePath", Type.string )
                                    , ( "mockModuleFilePath", Type.string )
                                    ]
                                )
                            )
                    }
                )
                [ operationArg ]
    , fragmentGlobal =
        \fragmentGlobalArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Path" ]
                    , name = "fragmentGlobal"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "name", Type.string )
                                    , ( "namespace", Type.string )
                                    , ( "path", Type.string )
                                    , ( "queryDir", Type.list Type.string )
                                    ]
                                ]
                                (Type.namedWith [] "Paths" [])
                            )
                    }
                )
                [ fragmentGlobalArg ]
    , fragment =
        \fragmentArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Path" ]
                    , name = "fragment"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "name", Type.string )
                                    , ( "path", Type.string )
                                    , ( "queryDir", Type.list Type.string )
                                    ]
                                ]
                                (Type.namedWith [] "Paths" [])
                            )
                    }
                )
                [ fragmentArg ]
    }


values_ :
    { operation : Elm.Expression
    , fragmentGlobal : Elm.Expression
    , fragment : Elm.Expression
    }
values_ =
    { operation =
        Elm.value
            { importFrom = [ "Generate", "Path" ]
            , name = "operation"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "path", Type.string )
                            , ( "queryDir", Type.list Type.string )
                            ]
                        ]
                        (Type.record
                            [ ( "modulePath", Type.list Type.string )
                            , ( "mockModulePath", Type.list Type.string )
                            , ( "filePath", Type.string )
                            , ( "mockModuleFilePath", Type.string )
                            ]
                        )
                    )
            }
    , fragmentGlobal =
        Elm.value
            { importFrom = [ "Generate", "Path" ]
            , name = "fragmentGlobal"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "namespace", Type.string )
                            , ( "path", Type.string )
                            , ( "queryDir", Type.list Type.string )
                            ]
                        ]
                        (Type.namedWith [] "Paths" [])
                    )
            }
    , fragment =
        Elm.value
            { importFrom = [ "Generate", "Path" ]
            , name = "fragment"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "path", Type.string )
                            , ( "queryDir", Type.list Type.string )
                            ]
                        ]
                        (Type.namedWith [] "Paths" [])
                    )
            }
    }
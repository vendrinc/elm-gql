module Gen.Generate.Path exposing (call_, fragment, moduleName_, operation, values_)

{-| 
@docs values_, call_, fragment, operation, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Path" ]


{-| operation: 
    { name : String, path : String, gqlDir : List String }
    -> { modulePath : List String, filePath : String }
-}
operation :
    { name : String, path : String, gqlDir : List String } -> Elm.Expression
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
                            , ( "gqlDir", Type.list Type.string )
                            ]
                        ]
                        (Type.record
                            [ ( "modulePath", Type.list Type.string )
                            , ( "filePath", Type.string )
                            ]
                        )
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" (Elm.string operationArg.name)
            , Tuple.pair "path" (Elm.string operationArg.path)
            , Tuple.pair
                "gqlDir"
                (Elm.list (List.map Elm.string operationArg.gqlDir))
            ]
        ]


{-| fragment: 
    { name : String, path : String, gqlDir : List String }
    -> { modulePath : List String, filePath : String }
-}
fragment :
    { name : String, path : String, gqlDir : List String } -> Elm.Expression
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
                            , ( "gqlDir", Type.list Type.string )
                            ]
                        ]
                        (Type.record
                            [ ( "modulePath", Type.list Type.string )
                            , ( "filePath", Type.string )
                            ]
                        )
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" (Elm.string fragmentArg.name)
            , Tuple.pair "path" (Elm.string fragmentArg.path)
            , Tuple.pair
                "gqlDir"
                (Elm.list (List.map Elm.string fragmentArg.gqlDir))
            ]
        ]


call_ :
    { operation : Elm.Expression -> Elm.Expression
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
                                    , ( "gqlDir", Type.list Type.string )
                                    ]
                                ]
                                (Type.record
                                    [ ( "modulePath", Type.list Type.string )
                                    , ( "filePath", Type.string )
                                    ]
                                )
                            )
                    }
                )
                [ operationArg ]
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
                                    , ( "gqlDir", Type.list Type.string )
                                    ]
                                ]
                                (Type.record
                                    [ ( "modulePath", Type.list Type.string )
                                    , ( "filePath", Type.string )
                                    ]
                                )
                            )
                    }
                )
                [ fragmentArg ]
    }


values_ : { operation : Elm.Expression, fragment : Elm.Expression }
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
                            , ( "gqlDir", Type.list Type.string )
                            ]
                        ]
                        (Type.record
                            [ ( "modulePath", Type.list Type.string )
                            , ( "filePath", Type.string )
                            ]
                        )
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
                            , ( "gqlDir", Type.list Type.string )
                            ]
                        ]
                        (Type.record
                            [ ( "modulePath", Type.list Type.string )
                            , ( "filePath", Type.string )
                            ]
                        )
                    )
            }
    }



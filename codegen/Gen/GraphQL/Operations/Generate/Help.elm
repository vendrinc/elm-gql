module Gen.GraphQL.Operations.Generate.Help exposing (call_, moduleName_, renderStandardComment, replaceFilePath, values_)

{-| 
@docs values_, call_, replaceFilePath, renderStandardComment, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Generate", "Help" ]


{-| renderStandardComment: List { group : Maybe String, members : List String } -> String -}
renderStandardComment :
    List { group : Elm.Expression, members : List String } -> Elm.Expression
renderStandardComment renderStandardCommentArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Help" ]
            , name = "renderStandardComment"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.record
                                [ ( "group"
                                  , Type.namedWith [] "Maybe" [ Type.string ]
                                  )
                                , ( "members", Type.list Type.string )
                                ]
                            )
                        ]
                        Type.string
                    )
            }
        )
        [ Elm.list
            (List.map
                (\unpack ->
                    Elm.record
                        [ Tuple.pair "group" unpack.group
                        , Tuple.pair
                            "members"
                            (Elm.list (List.map Elm.string unpack.members))
                        ]
                )
                renderStandardCommentArg
            )
        ]


{-| replaceFilePath: String -> { a | path : String } -> { a | path : String } -}
replaceFilePath : String -> { a | path : String } -> Elm.Expression
replaceFilePath replaceFilePathArg replaceFilePathArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Help" ]
            , name = "replaceFilePath"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.extensible "a" [ ( "path", Type.string ) ]
                        ]
                        (Type.extensible "a" [ ( "path", Type.string ) ])
                    )
            }
        )
        [ Elm.string replaceFilePathArg
        , Elm.record [ Tuple.pair "path" (Elm.string replaceFilePathArg0.path) ]
        ]


call_ :
    { renderStandardComment : Elm.Expression -> Elm.Expression
    , replaceFilePath : Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { renderStandardComment =
        \renderStandardCommentArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Help" ]
                    , name = "renderStandardComment"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.record
                                        [ ( "group"
                                          , Type.namedWith
                                                []
                                                "Maybe"
                                                [ Type.string ]
                                          )
                                        , ( "members", Type.list Type.string )
                                        ]
                                    )
                                ]
                                Type.string
                            )
                    }
                )
                [ renderStandardCommentArg ]
    , replaceFilePath =
        \replaceFilePathArg replaceFilePathArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Help" ]
                    , name = "replaceFilePath"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.extensible
                                    "a"
                                    [ ( "path", Type.string ) ]
                                ]
                                (Type.extensible "a" [ ( "path", Type.string ) ]
                                )
                            )
                    }
                )
                [ replaceFilePathArg, replaceFilePathArg0 ]
    }


values_ :
    { renderStandardComment : Elm.Expression, replaceFilePath : Elm.Expression }
values_ =
    { renderStandardComment =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Help" ]
            , name = "renderStandardComment"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.record
                                [ ( "group"
                                  , Type.namedWith [] "Maybe" [ Type.string ]
                                  )
                                , ( "members", Type.list Type.string )
                                ]
                            )
                        ]
                        Type.string
                    )
            }
    , replaceFilePath =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Help" ]
            , name = "replaceFilePath"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.extensible "a" [ ( "path", Type.string ) ]
                        ]
                        (Type.extensible "a" [ ( "path", Type.string ) ])
                    )
            }
    }



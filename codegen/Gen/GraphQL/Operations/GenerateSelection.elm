module Gen.GraphQL.Operations.GenerateSelection exposing (call_, generate, moduleName_, values_)

{-| 
@docs values_, call_, generate, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "GenerateSelection" ]


{-| generate: 
    { namespace : Namespace
    , schema : GraphQL.Schema.Schema
    , document : Can.Document
    , path : List String
    , gqlDir : List String
    }
    -> List Elm.File
-}
generate :
    { namespace : Elm.Expression
    , schema : Elm.Expression
    , document : Elm.Expression
    , path : List String
    , gqlDir : List String
    }
    -> Elm.Expression
generate generateArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "GenerateSelection" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "namespace", Type.namedWith [] "Namespace" [] )
                            , ( "schema"
                              , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                              )
                            , ( "document"
                              , Type.namedWith [ "Can" ] "Document" []
                              )
                            , ( "path", Type.list Type.string )
                            , ( "gqlDir", Type.list Type.string )
                            ]
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "File" []))
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "namespace" generateArg.namespace
            , Tuple.pair "schema" generateArg.schema
            , Tuple.pair "document" generateArg.document
            , Tuple.pair
                "path"
                (Elm.list (List.map Elm.string generateArg.path))
            , Tuple.pair
                "gqlDir"
                (Elm.list (List.map Elm.string generateArg.gqlDir))
            ]
        ]


call_ : { generate : Elm.Expression -> Elm.Expression }
call_ =
    { generate =
        \generateArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "GenerateSelection" ]
                    , name = "generate"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "namespace"
                                      , Type.namedWith [] "Namespace" []
                                      )
                                    , ( "schema"
                                      , Type.namedWith
                                            [ "GraphQL", "Schema" ]
                                            "Schema"
                                            []
                                      )
                                    , ( "document"
                                      , Type.namedWith [ "Can" ] "Document" []
                                      )
                                    , ( "path", Type.list Type.string )
                                    , ( "gqlDir", Type.list Type.string )
                                    ]
                                ]
                                (Type.list (Type.namedWith [ "Elm" ] "File" []))
                            )
                    }
                )
                [ generateArg ]
    }


values_ : { generate : Elm.Expression }
values_ =
    { generate =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "GenerateSelection" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "namespace", Type.namedWith [] "Namespace" [] )
                            , ( "schema"
                              , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                              )
                            , ( "document"
                              , Type.namedWith [ "Can" ] "Document" []
                              )
                            , ( "path", Type.list Type.string )
                            , ( "gqlDir", Type.list Type.string )
                            ]
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "File" []))
                    )
            }
    }



module Gen.GraphQL.Operations.Generate.Mock exposing (call_, generate, moduleName_, values_)

{-| 
@docs moduleName_, generate, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Generate", "Mock" ]


{-| generate: 
    { namespace : Namespace
    , schema : GraphQL.Schema.Schema
    , document : Can.Document
    , path : String
    , gqlDir : List String
    , outDir : List String
    , generateMocks : Bool
    }
    -> List Elm.File
-}
generate :
    { namespace : Elm.Expression
    , schema : Elm.Expression
    , document : Elm.Expression
    , path : String
    , gqlDir : List String
    , outDir : List String
    , generateMocks : Bool
    }
    -> Elm.Expression
generate generateArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Generate", "Mock" ]
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
                            , ( "path", Type.string )
                            , ( "gqlDir", Type.list Type.string )
                            , ( "outDir", Type.list Type.string )
                            , ( "generateMocks", Type.bool )
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
            , Tuple.pair "path" (Elm.string generateArg.path)
            , Tuple.pair
                "gqlDir"
                (Elm.list (List.map Elm.string generateArg.gqlDir))
            , Tuple.pair
                "outDir"
                (Elm.list (List.map Elm.string generateArg.outDir))
            , Tuple.pair "generateMocks" (Elm.bool generateArg.generateMocks)
            ]
        ]


call_ : { generate : Elm.Expression -> Elm.Expression }
call_ =
    { generate =
        \generateArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Generate", "Mock" ]
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
                                    , ( "path", Type.string )
                                    , ( "gqlDir", Type.list Type.string )
                                    , ( "outDir", Type.list Type.string )
                                    , ( "generateMocks", Type.bool )
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
            { importFrom = [ "GraphQL", "Operations", "Generate", "Mock" ]
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
                            , ( "path", Type.string )
                            , ( "gqlDir", Type.list Type.string )
                            , ( "outDir", Type.list Type.string )
                            , ( "generateMocks", Type.bool )
                            ]
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "File" []))
                    )
            }
    }
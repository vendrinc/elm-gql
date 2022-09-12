module Gen.Generate.Enums exposing (call_, generateFiles, moduleName_, values_)

{-| 
@docs values_, call_, generateFiles, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Enums" ]


{-| generateFiles: Namespace -> GraphQL.Schema.Schema -> List Elm.File -}
generateFiles : Elm.Expression -> Elm.Expression -> Elm.Expression
generateFiles generateFilesArg generateFilesArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Enums" ]
            , name = "generateFiles"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "File" []))
                    )
            }
        )
        [ generateFilesArg, generateFilesArg0 ]


call_ : { generateFiles : Elm.Expression -> Elm.Expression -> Elm.Expression }
call_ =
    { generateFiles =
        \generateFilesArg generateFilesArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Enums" ]
                    , name = "generateFiles"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                ]
                                (Type.list (Type.namedWith [ "Elm" ] "File" []))
                            )
                    }
                )
                [ generateFilesArg, generateFilesArg0 ]
    }


values_ : { generateFiles : Elm.Expression }
values_ =
    { generateFiles =
        Elm.value
            { importFrom = [ "Generate", "Enums" ]
            , name = "generateFiles"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "File" []))
                    )
            }
    }



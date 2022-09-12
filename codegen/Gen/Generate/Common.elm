module Gen.Generate.Common exposing (call_, gqlTypeToElmTypeAnnotation, local, localAnnotation, moduleName_, ref, selection, selectionLocal, values_)

{-| 
@docs values_, call_, selection, selectionLocal, ref, local, gqlTypeToElmTypeAnnotation, localAnnotation, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Common" ]


{-| localAnnotation: 
    Namespace
    -> GraphQL.Schema.Type
    -> Maybe (List Elm.Annotation.Annotation)
    -> Elm.Annotation.Annotation
-}
localAnnotation :
    Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
localAnnotation localAnnotationArg localAnnotationArg0 localAnnotationArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "localAnnotation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith
                            []
                            "Maybe"
                            [ Type.list
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            ]
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
        )
        [ localAnnotationArg, localAnnotationArg0, localAnnotationArg1 ]


{-| gqlTypeToElmTypeAnnotation: 
    Namespace
    -> GraphQL.Schema.Type
    -> Maybe (List Elm.Annotation.Annotation)
    -> Elm.Annotation.Annotation
-}
gqlTypeToElmTypeAnnotation :
    Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
gqlTypeToElmTypeAnnotation gqlTypeToElmTypeAnnotationArg gqlTypeToElmTypeAnnotationArg0 gqlTypeToElmTypeAnnotationArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "gqlTypeToElmTypeAnnotation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith
                            []
                            "Maybe"
                            [ Type.list
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            ]
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
        )
        [ gqlTypeToElmTypeAnnotationArg
        , gqlTypeToElmTypeAnnotationArg0
        , gqlTypeToElmTypeAnnotationArg1
        ]


{-| local: Namespace -> String -> Elm.Annotation.Annotation -}
local : Elm.Expression -> String -> Elm.Expression
local localArg localArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "local"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" [], Type.string ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
        )
        [ localArg, Elm.string localArg0 ]


{-| ref: Namespace -> String -> Elm.Annotation.Annotation -}
ref : Elm.Expression -> String -> Elm.Expression
ref refArg refArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "ref"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" [], Type.string ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
        )
        [ refArg, Elm.string refArg0 ]


{-| selectionLocal: String -> String -> Elm.Annotation.Annotation -> Elm.Annotation.Annotation -}
selectionLocal : String -> String -> Elm.Expression -> Elm.Expression
selectionLocal selectionLocalArg selectionLocalArg0 selectionLocalArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "selectionLocal"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [ "Elm", "Annotation" ] "Annotation" []
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
        )
        [ Elm.string selectionLocalArg
        , Elm.string selectionLocalArg0
        , selectionLocalArg1
        ]


{-| selection: String -> String -> Elm.Annotation.Annotation -> Elm.Annotation.Annotation -}
selection : String -> String -> Elm.Expression -> Elm.Expression
selection selectionArg selectionArg0 selectionArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "selection"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [ "Elm", "Annotation" ] "Annotation" []
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
        )
        [ Elm.string selectionArg, Elm.string selectionArg0, selectionArg1 ]


call_ :
    { localAnnotation :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , gqlTypeToElmTypeAnnotation :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , local : Elm.Expression -> Elm.Expression -> Elm.Expression
    , ref : Elm.Expression -> Elm.Expression -> Elm.Expression
    , selectionLocal :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , selection :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { localAnnotation =
        \localAnnotationArg localAnnotationArg0 localAnnotationArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Common" ]
                    , name = "localAnnotation"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Type"
                                    []
                                , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.list
                                        (Type.namedWith
                                            [ "Elm", "Annotation" ]
                                            "Annotation"
                                            []
                                        )
                                    ]
                                ]
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            )
                    }
                )
                [ localAnnotationArg, localAnnotationArg0, localAnnotationArg1 ]
    , gqlTypeToElmTypeAnnotation =
        \gqlTypeToElmTypeAnnotationArg gqlTypeToElmTypeAnnotationArg0 gqlTypeToElmTypeAnnotationArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Common" ]
                    , name = "gqlTypeToElmTypeAnnotation"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Type"
                                    []
                                , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.list
                                        (Type.namedWith
                                            [ "Elm", "Annotation" ]
                                            "Annotation"
                                            []
                                        )
                                    ]
                                ]
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            )
                    }
                )
                [ gqlTypeToElmTypeAnnotationArg
                , gqlTypeToElmTypeAnnotationArg0
                , gqlTypeToElmTypeAnnotationArg1
                ]
    , local =
        \localArg localArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Common" ]
                    , name = "local"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.string
                                ]
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            )
                    }
                )
                [ localArg, localArg0 ]
    , ref =
        \refArg refArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Common" ]
                    , name = "ref"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.string
                                ]
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            )
                    }
                )
                [ refArg, refArg0 ]
    , selectionLocal =
        \selectionLocalArg selectionLocalArg0 selectionLocalArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Common" ]
                    , name = "selectionLocal"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.string
                                , Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                ]
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            )
                    }
                )
                [ selectionLocalArg, selectionLocalArg0, selectionLocalArg1 ]
    , selection =
        \selectionArg selectionArg0 selectionArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Common" ]
                    , name = "selection"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.string
                                , Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                ]
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            )
                    }
                )
                [ selectionArg, selectionArg0, selectionArg1 ]
    }


values_ :
    { localAnnotation : Elm.Expression
    , gqlTypeToElmTypeAnnotation : Elm.Expression
    , local : Elm.Expression
    , ref : Elm.Expression
    , selectionLocal : Elm.Expression
    , selection : Elm.Expression
    }
values_ =
    { localAnnotation =
        Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "localAnnotation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith
                            []
                            "Maybe"
                            [ Type.list
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            ]
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
    , gqlTypeToElmTypeAnnotation =
        Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "gqlTypeToElmTypeAnnotation"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                        , Type.namedWith
                            []
                            "Maybe"
                            [ Type.list
                                (Type.namedWith
                                    [ "Elm", "Annotation" ]
                                    "Annotation"
                                    []
                                )
                            ]
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
    , local =
        Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "local"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" [], Type.string ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
    , ref =
        Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "ref"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" [], Type.string ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
    , selectionLocal =
        Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "selectionLocal"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [ "Elm", "Annotation" ] "Annotation" []
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
    , selection =
        Elm.value
            { importFrom = [ "Generate", "Common" ]
            , name = "selection"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [ "Elm", "Annotation" ] "Annotation" []
                        ]
                        (Type.namedWith [ "Elm", "Annotation" ] "Annotation" [])
                    )
            }
    }



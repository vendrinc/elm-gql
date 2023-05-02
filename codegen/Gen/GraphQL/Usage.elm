module Gen.GraphQL.Usage exposing (annotation_, call_, enum, field, init, inputObject, merge, moduleName_, mutation, query, scalar, toUnusedReport, values_)

{-| 
@docs values_, call_, annotation_, init, query, mutation, field, scalar, enum, inputObject, merge, toUnusedReport, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Usage" ]


{-| {-| Returns a schema of only things that are unused
-}

toUnusedReport: GraphQL.Schema.Schema -> Usages -> GraphQL.Schema.Schema
-}
toUnusedReport : Elm.Expression -> Elm.Expression -> Elm.Expression
toUnusedReport toUnusedReportArg toUnusedReportArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "toUnusedReport"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [ "GraphQL", "Schema" ] "Schema" [])
                    )
            }
        )
        [ toUnusedReportArg, toUnusedReportArg0 ]


{-| merge: Usages -> Usages -> Usages -}
merge : Elm.Expression -> Elm.Expression -> Elm.Expression
merge mergeArg mergeArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "merge"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Usages" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
        )
        [ mergeArg, mergeArg0 ]


{-| inputObject: String -> String -> FilePath -> Usages -> Usages -}
inputObject :
    String -> String -> Elm.Expression -> Elm.Expression -> Elm.Expression
inputObject inputObjectArg inputObjectArg0 inputObjectArg1 inputObjectArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "inputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
        )
        [ Elm.string inputObjectArg
        , Elm.string inputObjectArg0
        , inputObjectArg1
        , inputObjectArg2
        ]


{-| enum: String -> FilePath -> Usages -> Usages -}
enum : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
enum enumArg enumArg0 enumArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "enum"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
        )
        [ Elm.string enumArg, enumArg0, enumArg1 ]


{-| scalar: String -> FilePath -> Usages -> Usages -}
scalar : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
scalar scalarArg scalarArg0 scalarArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "scalar"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
        )
        [ Elm.string scalarArg, scalarArg0, scalarArg1 ]


{-| field: String -> String -> FilePath -> Usages -> Usages -}
field : String -> String -> Elm.Expression -> Elm.Expression -> Elm.Expression
field fieldArg fieldArg0 fieldArg1 fieldArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
        )
        [ Elm.string fieldArg, Elm.string fieldArg0, fieldArg1, fieldArg2 ]


{-| mutation: String -> FilePath -> Usages -> Usages -}
mutation : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
mutation mutationArg mutationArg0 mutationArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "mutation"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
        )
        [ Elm.string mutationArg, mutationArg0, mutationArg1 ]


{-| query: String -> FilePath -> Usages -> Usages -}
query : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
query queryArg queryArg0 queryArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "query"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
        )
        [ Elm.string queryArg, queryArg0, queryArg1 ]


{-| init: Usages -}
init : Elm.Expression
init =
    Elm.value
        { importFrom = [ "GraphQL", "Usage" ]
        , name = "init"
        , annotation = Just (Type.namedWith [] "Usages" [])
        }


annotation_ : { usages : Type.Annotation }
annotation_ =
    { usages = Type.namedWith [ "GraphQL", "Usage" ] "Usages" [] }


call_ :
    { toUnusedReport : Elm.Expression -> Elm.Expression -> Elm.Expression
    , merge : Elm.Expression -> Elm.Expression -> Elm.Expression
    , inputObject :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , enum :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , scalar :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , field :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , mutation :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , query :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { toUnusedReport =
        \toUnusedReportArg toUnusedReportArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Usage" ]
                    , name = "toUnusedReport"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.namedWith [] "Usages" []
                                ]
                                (Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                )
                            )
                    }
                )
                [ toUnusedReportArg, toUnusedReportArg0 ]
    , merge =
        \mergeArg mergeArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Usage" ]
                    , name = "merge"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Usages" []
                                , Type.namedWith [] "Usages" []
                                ]
                                (Type.namedWith [] "Usages" [])
                            )
                    }
                )
                [ mergeArg, mergeArg0 ]
    , inputObject =
        \inputObjectArg inputObjectArg0 inputObjectArg1 inputObjectArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Usage" ]
                    , name = "inputObject"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Usages" []
                                ]
                                (Type.namedWith [] "Usages" [])
                            )
                    }
                )
                [ inputObjectArg
                , inputObjectArg0
                , inputObjectArg1
                , inputObjectArg2
                ]
    , enum =
        \enumArg enumArg0 enumArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Usage" ]
                    , name = "enum"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Usages" []
                                ]
                                (Type.namedWith [] "Usages" [])
                            )
                    }
                )
                [ enumArg, enumArg0, enumArg1 ]
    , scalar =
        \scalarArg scalarArg0 scalarArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Usage" ]
                    , name = "scalar"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Usages" []
                                ]
                                (Type.namedWith [] "Usages" [])
                            )
                    }
                )
                [ scalarArg, scalarArg0, scalarArg1 ]
    , field =
        \fieldArg fieldArg0 fieldArg1 fieldArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Usage" ]
                    , name = "field"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Usages" []
                                ]
                                (Type.namedWith [] "Usages" [])
                            )
                    }
                )
                [ fieldArg, fieldArg0, fieldArg1, fieldArg2 ]
    , mutation =
        \mutationArg mutationArg0 mutationArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Usage" ]
                    , name = "mutation"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Usages" []
                                ]
                                (Type.namedWith [] "Usages" [])
                            )
                    }
                )
                [ mutationArg, mutationArg0, mutationArg1 ]
    , query =
        \queryArg queryArg0 queryArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Usage" ]
                    , name = "query"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Usages" []
                                ]
                                (Type.namedWith [] "Usages" [])
                            )
                    }
                )
                [ queryArg, queryArg0, queryArg1 ]
    }


values_ :
    { toUnusedReport : Elm.Expression
    , merge : Elm.Expression
    , inputObject : Elm.Expression
    , enum : Elm.Expression
    , scalar : Elm.Expression
    , field : Elm.Expression
    , mutation : Elm.Expression
    , query : Elm.Expression
    , init : Elm.Expression
    }
values_ =
    { toUnusedReport =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "toUnusedReport"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [ "GraphQL", "Schema" ] "Schema" [])
                    )
            }
    , merge =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "merge"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Usages" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
    , inputObject =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "inputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
    , enum =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "enum"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
    , scalar =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "scalar"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
    , field =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
    , mutation =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "mutation"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
    , query =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "query"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Usages" []
                        ]
                        (Type.namedWith [] "Usages" [])
                    )
            }
    , init =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "init"
            , annotation = Just (Type.namedWith [] "Usages" [])
            }
    }



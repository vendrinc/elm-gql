module Gen.GraphQL.Usage exposing (annotation_, call_, enum, field, init, input, interface, make_, moduleName_, mutation, query, scalar, union, values_)

{-| 
@docs values_, call_, make_, annotation_, init, query, mutation, field, scalar, enum, union, input, interface, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Usage" ]


{-| interface: String -> String -> FilePath -> Usages -> Usages -}
interface :
    String -> String -> Elm.Expression -> Elm.Expression -> Elm.Expression
interface interfaceArg interfaceArg0 interfaceArg1 interfaceArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "interface"
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
        [ Elm.string interfaceArg
        , Elm.string interfaceArg0
        , interfaceArg1
        , interfaceArg2
        ]


{-| input: String -> String -> FilePath -> Usages -> Usages -}
input : String -> String -> Elm.Expression -> Elm.Expression -> Elm.Expression
input inputArg inputArg0 inputArg1 inputArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "input"
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
        [ Elm.string inputArg, Elm.string inputArg0, inputArg1, inputArg2 ]


{-| union: String -> FilePath -> Usages -> Usages -}
union : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
union unionArg unionArg0 unionArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "union"
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
        [ Elm.string unionArg, unionArg0, unionArg1 ]


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


annotation_ : { usage : Type.Annotation }
annotation_ =
    { usage =
        Type.alias
            moduleName_
            "Usage"
            []
            (Type.record
                [ ( "usedIn", Type.namedWith [] "FilePath" [] )
                , ( "type_", Type.namedWith [] "Type" [] )
                ]
            )
    }


make_ :
    { usage :
        { usedIn : Elm.Expression, type_ : Elm.Expression } -> Elm.Expression
    }
make_ =
    { usage =
        \usage_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Usage" ]
                    "Usage"
                    []
                    (Type.record
                        [ ( "usedIn", Type.namedWith [] "FilePath" [] )
                        , ( "type_", Type.namedWith [] "Type" [] )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "usedIn" usage_args.usedIn
                    , Tuple.pair "type_" usage_args.type_
                    ]
                )
    }


call_ :
    { interface :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , input :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , union :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
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
    { interface =
        \interfaceArg interfaceArg0 interfaceArg1 interfaceArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Usage" ]
                    , name = "interface"
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
                [ interfaceArg, interfaceArg0, interfaceArg1, interfaceArg2 ]
    , input =
        \inputArg inputArg0 inputArg1 inputArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Usage" ]
                    , name = "input"
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
                [ inputArg, inputArg0, inputArg1, inputArg2 ]
    , union =
        \unionArg unionArg0 unionArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Usage" ]
                    , name = "union"
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
                [ unionArg, unionArg0, unionArg1 ]
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
    { interface : Elm.Expression
    , input : Elm.Expression
    , union : Elm.Expression
    , enum : Elm.Expression
    , scalar : Elm.Expression
    , field : Elm.Expression
    , mutation : Elm.Expression
    , query : Elm.Expression
    , init : Elm.Expression
    }
values_ =
    { interface =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "interface"
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
    , input =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "input"
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
    , union =
        Elm.value
            { importFrom = [ "GraphQL", "Usage" ]
            , name = "union"
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



module Gen.GraphQL.Decode exposing (andMap, call_, field, moduleName_, values_, versionedField)

{-| 
@docs moduleName_, andMap, field, versionedField, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Decode" ]


{-| andMap: Json.Decode.Decoder a -> Json.Decode.Decoder (a -> b) -> Json.Decode.Decoder b -}
andMap : Elm.Expression -> Elm.Expression -> Elm.Expression
andMap andMapArg andMapArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Decode" ]
            , name = "andMap"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
        )
        [ andMapArg, andMapArg0 ]


{-| field: 
    String
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
-}
field : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
field fieldArg fieldArg0 fieldArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Decode" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
        )
        [ Elm.string fieldArg, fieldArg0, fieldArg1 ]


{-| versionedField: 
    Int
    -> String
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
-}
versionedField :
    Int -> String -> Elm.Expression -> Elm.Expression -> Elm.Expression
versionedField versionedFieldArg versionedFieldArg0 versionedFieldArg1 versionedFieldArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Decode" ]
            , name = "versionedField"
            , annotation =
                Just
                    (Type.function
                        [ Type.int
                        , Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
        )
        [ Elm.int versionedFieldArg
        , Elm.string versionedFieldArg0
        , versionedFieldArg1
        , versionedFieldArg2
        ]


call_ :
    { andMap : Elm.Expression -> Elm.Expression -> Elm.Expression
    , field :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , versionedField :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    }
call_ =
    { andMap =
        \andMapArg andMapArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Decode" ]
                    , name = "andMap"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.function
                                        [ Type.var "a" ]
                                        (Type.var "b")
                                    ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                )
                            )
                    }
                )
                [ andMapArg, andMapArg0 ]
    , field =
        \fieldArg fieldArg0 fieldArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Decode" ]
                    , name = "field"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.function
                                        [ Type.var "a" ]
                                        (Type.var "b")
                                    ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                )
                            )
                    }
                )
                [ fieldArg, fieldArg0, fieldArg1 ]
    , versionedField =
        \versionedFieldArg versionedFieldArg0 versionedFieldArg1 versionedFieldArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Decode" ]
                    , name = "versionedField"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.int
                                , Type.string
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.function
                                        [ Type.var "a" ]
                                        (Type.var "b")
                                    ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                )
                            )
                    }
                )
                [ versionedFieldArg
                , versionedFieldArg0
                , versionedFieldArg1
                , versionedFieldArg2
                ]
    }


values_ :
    { andMap : Elm.Expression
    , field : Elm.Expression
    , versionedField : Elm.Expression
    }
values_ =
    { andMap =
        Elm.value
            { importFrom = [ "GraphQL", "Decode" ]
            , name = "andMap"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
    , field =
        Elm.value
            { importFrom = [ "GraphQL", "Decode" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
    , versionedField =
        Elm.value
            { importFrom = [ "GraphQL", "Decode" ]
            , name = "versionedField"
            , annotation =
                Just
                    (Type.function
                        [ Type.int
                        , Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
    }
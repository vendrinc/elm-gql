module Gen.Utils.Json exposing (apply, call_, filterHidden, moduleName_, nonEmptyString, values_)

{-| 
@docs values_, call_, apply, nonEmptyString, filterHidden, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Utils", "Json" ]


{-| filterHidden: Json.Decoder value -> Json.Decoder (Maybe value) -}
filterHidden : Elm.Expression -> Elm.Expression
filterHidden filterHiddenArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "Json" ]
            , name = "filterHidden"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json" ]
                            "Decoder"
                            [ Type.var "value" ]
                        ]
                        (Type.namedWith
                            [ "Json" ]
                            "Decoder"
                            [ Type.namedWith [] "Maybe" [ Type.var "value" ] ]
                        )
                    )
            }
        )
        [ filterHiddenArg ]


{-| nonEmptyString: Json.Decoder String -}
nonEmptyString : Elm.Expression
nonEmptyString =
    Elm.value
        { importFrom = [ "Utils", "Json" ]
        , name = "nonEmptyString"
        , annotation =
            Just (Type.namedWith [ "Json" ] "Decoder" [ Type.string ])
        }


{-| apply: Json.Decoder a -> Json.Decoder (a -> b) -> Json.Decoder b -}
apply : Elm.Expression -> Elm.Expression -> Elm.Expression
apply applyArg applyArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "Json" ]
            , name = "apply"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Json" ] "Decoder" [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith [ "Json" ] "Decoder" [ Type.var "b" ])
                    )
            }
        )
        [ applyArg, applyArg0 ]


call_ :
    { filterHidden : Elm.Expression -> Elm.Expression
    , apply : Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { filterHidden =
        \filterHiddenArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "Json" ]
                    , name = "filterHidden"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json" ]
                                    "Decoder"
                                    [ Type.var "value" ]
                                ]
                                (Type.namedWith
                                    [ "Json" ]
                                    "Decoder"
                                    [ Type.namedWith
                                        []
                                        "Maybe"
                                        [ Type.var "value" ]
                                    ]
                                )
                            )
                    }
                )
                [ filterHiddenArg ]
    , apply =
        \applyArg applyArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "Json" ]
                    , name = "apply"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json" ]
                                    "Decoder"
                                    [ Type.function
                                        [ Type.var "a" ]
                                        (Type.var "b")
                                    ]
                                ]
                                (Type.namedWith
                                    [ "Json" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                )
                            )
                    }
                )
                [ applyArg, applyArg0 ]
    }


values_ :
    { filterHidden : Elm.Expression
    , nonEmptyString : Elm.Expression
    , apply : Elm.Expression
    }
values_ =
    { filterHidden =
        Elm.value
            { importFrom = [ "Utils", "Json" ]
            , name = "filterHidden"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json" ]
                            "Decoder"
                            [ Type.var "value" ]
                        ]
                        (Type.namedWith
                            [ "Json" ]
                            "Decoder"
                            [ Type.namedWith [] "Maybe" [ Type.var "value" ] ]
                        )
                    )
            }
    , nonEmptyString =
        Elm.value
            { importFrom = [ "Utils", "Json" ]
            , name = "nonEmptyString"
            , annotation =
                Just (Type.namedWith [ "Json" ] "Decoder" [ Type.string ])
            }
    , apply =
        Elm.value
            { importFrom = [ "Utils", "Json" ]
            , name = "apply"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Json" ] "Decoder" [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json" ]
                            "Decoder"
                            [ Type.function [ Type.var "a" ] (Type.var "b") ]
                        ]
                        (Type.namedWith [ "Json" ] "Decoder" [ Type.var "b" ])
                    )
            }
    }



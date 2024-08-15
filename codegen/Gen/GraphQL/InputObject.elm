module Gen.GraphQL.InputObject exposing (addField, addOptionalField, annotation_, call_, encode, inputObject, maybe, moduleName_, raw, toFieldList, values_)

{-| 
@docs moduleName_, maybe, encode, toFieldList, addOptionalField, addField, raw, inputObject, annotation_, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "InputObject" ]


{-| {-| -}

maybe: (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
-}
maybe : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
maybe maybeArg maybeArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "maybe"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [] "Maybe" [ Type.var "a" ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.functionReduced "maybeUnpack" maybeArg, maybeArg0 ]


{-| {-| -}

encode: InputObject value -> Json.Encode.Value
-}
encode : Elm.Expression -> Elm.Expression
encode encodeArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "encode"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "value" ] ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ encodeArg ]


{-| {-| -}

toFieldList: InputObject a -> List ( String, VariableDetails )
-}
toFieldList : Elm.Expression -> Elm.Expression
toFieldList toFieldListArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "toFieldList"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "a" ] ]
                        (Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "VariableDetails" [])
                            )
                        )
                    )
            }
        )
        [ toFieldListArg ]


{-| {-| -}

addOptionalField: 
    String
    -> String
    -> Option value
    -> (value -> Json.Encode.Value)
    -> InputObject input
    -> InputObject input
-}
addOptionalField :
    String
    -> String
    -> Elm.Expression
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
addOptionalField addOptionalFieldArg addOptionalFieldArg0 addOptionalFieldArg1 addOptionalFieldArg2 addOptionalFieldArg3 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "addOptionalField"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [] "Option" [ Type.var "value" ]
                        , Type.function
                            [ Type.var "value" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [] "InputObject" [ Type.var "input" ]
                        ]
                        (Type.namedWith [] "InputObject" [ Type.var "input" ])
                    )
            }
        )
        [ Elm.string addOptionalFieldArg
        , Elm.string addOptionalFieldArg0
        , addOptionalFieldArg1
        , Elm.functionReduced "addOptionalFieldUnpack" addOptionalFieldArg2
        , addOptionalFieldArg3
        ]


{-| {-| -}

addField: String -> String -> Json.Encode.Value -> InputObject value -> InputObject value
-}
addField :
    String -> String -> Elm.Expression -> Elm.Expression -> Elm.Expression
addField addFieldArg addFieldArg0 addFieldArg1 addFieldArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "addField"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [ "Json", "Encode" ] "Value" []
                        , Type.namedWith [] "InputObject" [ Type.var "value" ]
                        ]
                        (Type.namedWith [] "InputObject" [ Type.var "value" ])
                    )
            }
        )
        [ Elm.string addFieldArg
        , Elm.string addFieldArg0
        , addFieldArg1
        , addFieldArg2
        ]


{-| {-| -}

raw: String -> List ( String, VariableDetails ) -> InputObject value
-}
raw : String -> List Elm.Expression -> Elm.Expression
raw rawArg rawArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "raw"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "VariableDetails" [])
                            )
                        ]
                        (Type.namedWith [] "InputObject" [ Type.var "value" ])
                    )
            }
        )
        [ Elm.string rawArg, Elm.list rawArg0 ]


{-| {-| -}

inputObject: String -> InputObject value
-}
inputObject : String -> Elm.Expression
inputObject inputObjectArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "inputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith [] "InputObject" [ Type.var "value" ])
                    )
            }
        )
        [ Elm.string inputObjectArg ]


annotation_ : { inputObject : Type.Annotation -> Type.Annotation }
annotation_ =
    { inputObject =
        \inputObjectArg0 ->
            Type.namedWith
                [ "GraphQL", "InputObject" ]
                "InputObject"
                [ inputObjectArg0 ]
    }


call_ :
    { maybe : Elm.Expression -> Elm.Expression -> Elm.Expression
    , encode : Elm.Expression -> Elm.Expression
    , toFieldList : Elm.Expression -> Elm.Expression
    , addOptionalField :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , addField :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , raw : Elm.Expression -> Elm.Expression -> Elm.Expression
    , inputObject : Elm.Expression -> Elm.Expression
    }
call_ =
    { maybe =
        \maybeArg maybeArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "InputObject" ]
                    , name = "maybe"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a" ]
                                    (Type.namedWith
                                        [ "Json", "Encode" ]
                                        "Value"
                                        []
                                    )
                                , Type.namedWith [] "Maybe" [ Type.var "a" ]
                                ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ maybeArg, maybeArg0 ]
    , encode =
        \encodeArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "InputObject" ]
                    , name = "encode"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "value" ]
                                ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ encodeArg ]
    , toFieldList =
        \toFieldListArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "InputObject" ]
                    , name = "toFieldList"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "a" ]
                                ]
                                (Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith [] "VariableDetails" [])
                                    )
                                )
                            )
                    }
                )
                [ toFieldListArg ]
    , addOptionalField =
        \addOptionalFieldArg addOptionalFieldArg0 addOptionalFieldArg1 addOptionalFieldArg2 addOptionalFieldArg3 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "InputObject" ]
                    , name = "addOptionalField"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.string
                                , Type.namedWith
                                    []
                                    "Option"
                                    [ Type.var "value" ]
                                , Type.function
                                    [ Type.var "value" ]
                                    (Type.namedWith
                                        [ "Json", "Encode" ]
                                        "Value"
                                        []
                                    )
                                , Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "input" ]
                                ]
                                (Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "input" ]
                                )
                            )
                    }
                )
                [ addOptionalFieldArg
                , addOptionalFieldArg0
                , addOptionalFieldArg1
                , addOptionalFieldArg2
                , addOptionalFieldArg3
                ]
    , addField =
        \addFieldArg addFieldArg0 addFieldArg1 addFieldArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "InputObject" ]
                    , name = "addField"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.string
                                , Type.namedWith [ "Json", "Encode" ] "Value" []
                                , Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "value" ]
                                ]
                                (Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ addFieldArg, addFieldArg0, addFieldArg1, addFieldArg2 ]
    , raw =
        \rawArg rawArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "InputObject" ]
                    , name = "raw"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith [] "VariableDetails" [])
                                    )
                                ]
                                (Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ rawArg, rawArg0 ]
    , inputObject =
        \inputObjectArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "InputObject" ]
                    , name = "inputObject"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string ]
                                (Type.namedWith
                                    []
                                    "InputObject"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ inputObjectArg ]
    }


values_ :
    { maybe : Elm.Expression
    , encode : Elm.Expression
    , toFieldList : Elm.Expression
    , addOptionalField : Elm.Expression
    , addField : Elm.Expression
    , raw : Elm.Expression
    , inputObject : Elm.Expression
    }
values_ =
    { maybe =
        Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "maybe"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [] "Maybe" [ Type.var "a" ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , encode =
        Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "encode"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "value" ] ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , toFieldList =
        Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "toFieldList"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "InputObject" [ Type.var "a" ] ]
                        (Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "VariableDetails" [])
                            )
                        )
                    )
            }
    , addOptionalField =
        Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "addOptionalField"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [] "Option" [ Type.var "value" ]
                        , Type.function
                            [ Type.var "value" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [] "InputObject" [ Type.var "input" ]
                        ]
                        (Type.namedWith [] "InputObject" [ Type.var "input" ])
                    )
            }
    , addField =
        Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "addField"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [ "Json", "Encode" ] "Value" []
                        , Type.namedWith [] "InputObject" [ Type.var "value" ]
                        ]
                        (Type.namedWith [] "InputObject" [ Type.var "value" ])
                    )
            }
    , raw =
        Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "raw"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [] "VariableDetails" [])
                            )
                        ]
                        (Type.namedWith [] "InputObject" [ Type.var "value" ])
                    )
            }
    , inputObject =
        Elm.value
            { importFrom = [ "GraphQL", "InputObject" ]
            , name = "inputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith [] "InputObject" [ Type.var "value" ])
                    )
            }
    }
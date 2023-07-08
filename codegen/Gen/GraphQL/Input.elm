module Gen.GraphQL.Input exposing (addField, addOptionalField, annotation_, call_, encode, inputObject, maybeScalarEncode, moduleName_, toFieldList, values_)

{-| 
@docs moduleName_, maybeScalarEncode, encode, toFieldList, addOptionalField, addField, inputObject, annotation_, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Input" ]


{-| {-| -}

maybeScalarEncode: (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
-}
maybeScalarEncode :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
maybeScalarEncode maybeScalarEncodeArg maybeScalarEncodeArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Input" ]
            , name = "maybeScalarEncode"
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
        [ Elm.functionReduced "maybeScalarEncodeUnpack" maybeScalarEncodeArg
        , maybeScalarEncodeArg0
        ]


{-| {-| -}

encode: InputObject value -> Json.Encode.Value
-}
encode : Elm.Expression -> Elm.Expression
encode encodeArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Input" ]
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
            { importFrom = [ "GraphQL", "Input" ]
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
            { importFrom = [ "GraphQL", "Input" ]
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
            { importFrom = [ "GraphQL", "Input" ]
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

inputObject: String -> InputObject value
-}
inputObject : String -> Elm.Expression
inputObject inputObjectArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Input" ]
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
                [ "GraphQL", "Input" ]
                "InputObject"
                [ inputObjectArg0 ]
    }


call_ :
    { maybeScalarEncode : Elm.Expression -> Elm.Expression -> Elm.Expression
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
    , inputObject : Elm.Expression -> Elm.Expression
    }
call_ =
    { maybeScalarEncode =
        \maybeScalarEncodeArg maybeScalarEncodeArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Input" ]
                    , name = "maybeScalarEncode"
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
                [ maybeScalarEncodeArg, maybeScalarEncodeArg0 ]
    , encode =
        \encodeArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Input" ]
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
                    { importFrom = [ "GraphQL", "Input" ]
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
                    { importFrom = [ "GraphQL", "Input" ]
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
                    { importFrom = [ "GraphQL", "Input" ]
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
    , inputObject =
        \inputObjectArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Input" ]
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
    { maybeScalarEncode : Elm.Expression
    , encode : Elm.Expression
    , toFieldList : Elm.Expression
    , addOptionalField : Elm.Expression
    , addField : Elm.Expression
    , inputObject : Elm.Expression
    }
values_ =
    { maybeScalarEncode =
        Elm.value
            { importFrom = [ "GraphQL", "Input" ]
            , name = "maybeScalarEncode"
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
            { importFrom = [ "GraphQL", "Input" ]
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
            { importFrom = [ "GraphQL", "Input" ]
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
            { importFrom = [ "GraphQL", "Input" ]
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
            { importFrom = [ "GraphQL", "Input" ]
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
    , inputObject =
        Elm.value
            { importFrom = [ "GraphQL", "Input" ]
            , name = "inputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith [] "InputObject" [ Type.var "value" ])
                    )
            }
    }
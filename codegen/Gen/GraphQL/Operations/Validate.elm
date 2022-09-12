module Gen.GraphQL.Operations.Validate exposing (annotation_, call_, errorToString, moduleName_, validate, values_)

{-| 
@docs values_, call_, annotation_, errorToString, validate, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Validate" ]


{-| validate: GraphQL.Schema.Schema -> AST.Document -> Result (List Error) AST.Document -}
validate : Elm.Expression -> Elm.Expression -> Elm.Expression
validate validateArg validateArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Validate" ]
            , name = "validate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [ "AST" ] "Document" []
                        ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list (Type.namedWith [] "Error" [])
                            , Type.namedWith [ "AST" ] "Document" []
                            ]
                        )
                    )
            }
        )
        [ validateArg, validateArg0 ]


{-| errorToString: Error -> String -}
errorToString : Elm.Expression -> Elm.Expression
errorToString errorToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Validate" ]
            , name = "errorToString"
            , annotation =
                Just
                    (Type.function [ Type.namedWith [] "Error" [] ] Type.string)
            }
        )
        [ errorToStringArg ]


annotation_ : { error : Type.Annotation }
annotation_ =
    { error = Type.namedWith [ "GraphQL", "Operations", "Validate" ] "Error" []
    }


call_ :
    { validate : Elm.Expression -> Elm.Expression -> Elm.Expression
    , errorToString : Elm.Expression -> Elm.Expression
    }
call_ =
    { validate =
        \validateArg validateArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Validate" ]
                    , name = "validate"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.namedWith [ "AST" ] "Document" []
                                ]
                                (Type.namedWith
                                    []
                                    "Result"
                                    [ Type.list (Type.namedWith [] "Error" [])
                                    , Type.namedWith [ "AST" ] "Document" []
                                    ]
                                )
                            )
                    }
                )
                [ validateArg, validateArg0 ]
    , errorToString =
        \errorToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Validate" ]
                    , name = "errorToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Error" [] ]
                                Type.string
                            )
                    }
                )
                [ errorToStringArg ]
    }


values_ : { validate : Elm.Expression, errorToString : Elm.Expression }
values_ =
    { validate =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Validate" ]
            , name = "validate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [ "AST" ] "Document" []
                        ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list (Type.namedWith [] "Error" [])
                            , Type.namedWith [ "AST" ] "Document" []
                            ]
                        )
                    )
            }
    , errorToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Validate" ]
            , name = "errorToString"
            , annotation =
                Just
                    (Type.function [ Type.namedWith [] "Error" [] ] Type.string)
            }
    }



module Gen.GraphQL.Operations.Mock exposing (annotation_, call_, caseOf_, generate, make_, moduleName_, values_)

{-| 
@docs values_, call_, caseOf_, make_, annotation_, generate, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Mock" ]


{-| generate: 
    Can.Document
    -> Result (List Error) (List { name : String, body : Json.Encode.Value })
-}
generate : Elm.Expression -> Elm.Expression
generate generateArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Mock" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Can" ] "Document" [] ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list (Type.namedWith [] "Error" [])
                            , Type.list
                                (Type.record
                                    [ ( "name", Type.string )
                                    , ( "body"
                                      , Type.namedWith
                                            [ "Json", "Encode" ]
                                            "Value"
                                            []
                                      )
                                    ]
                                )
                            ]
                        )
                    )
            }
        )
        [ generateArg ]


annotation_ : { error : Type.Annotation }
annotation_ =
    { error = Type.namedWith [ "GraphQL", "Operations", "Mock" ] "Error" [] }


make_ : { error : Elm.Expression }
make_ =
    { error =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Mock" ]
            , name = "Error"
            , annotation = Just (Type.namedWith [] "Error" [])
            }
    }


caseOf_ :
    { error :
        Elm.Expression
        -> { errorTags_0_0 | error : Elm.Expression }
        -> Elm.Expression
    }
caseOf_ =
    { error =
        \errorExpression errorTags ->
            Elm.Case.custom
                errorExpression
                (Type.namedWith [ "GraphQL", "Operations", "Mock" ] "Error" [])
                [ Elm.Case.branch0 "Error" errorTags.error ]
    }


call_ : { generate : Elm.Expression -> Elm.Expression }
call_ =
    { generate =
        \generateArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Mock" ]
                    , name = "generate"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Can" ] "Document" [] ]
                                (Type.namedWith
                                    []
                                    "Result"
                                    [ Type.list (Type.namedWith [] "Error" [])
                                    , Type.list
                                        (Type.record
                                            [ ( "name", Type.string )
                                            , ( "body"
                                              , Type.namedWith
                                                    [ "Json", "Encode" ]
                                                    "Value"
                                                    []
                                              )
                                            ]
                                        )
                                    ]
                                )
                            )
                    }
                )
                [ generateArg ]
    }


values_ : { generate : Elm.Expression }
values_ =
    { generate =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Mock" ]
            , name = "generate"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Can" ] "Document" [] ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list (Type.namedWith [] "Error" [])
                            , Type.list
                                (Type.record
                                    [ ( "name", Type.string )
                                    , ( "body"
                                      , Type.namedWith
                                            [ "Json", "Encode" ]
                                            "Value"
                                            []
                                      )
                                    ]
                                )
                            ]
                        )
                    )
            }
    }



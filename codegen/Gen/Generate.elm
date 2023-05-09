module Gen.Generate exposing (annotation_, main, make_, moduleName_, values_)

{-| 
@docs values_, make_, annotation_, main, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate" ]


{-| main: Program Json.Encode.Value Model Msg -}
main : Elm.Expression
main =
    Elm.value
        { importFrom = [ "Generate" ]
        , name = "main"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Program"
                    [ Type.namedWith [ "Json", "Encode" ] "Value" []
                    , Type.namedWith [] "Model" []
                    , Type.namedWith [] "Msg" []
                    ]
                )
        }


annotation_ :
    { model : Type.Annotation, msg : Type.Annotation, input : Type.Annotation }
annotation_ =
    { model =
        Type.alias
            moduleName_
            "Model"
            []
            (Type.record
                [ ( "flags", Type.namedWith [ "Json", "Encode" ] "Value" [] )
                , ( "input", Type.namedWith [] "Input" [] )
                , ( "namespace", Type.string )
                ]
            )
    , msg = Type.namedWith [ "Generate" ] "Msg" []
    , input = Type.namedWith [ "Generate" ] "Input" []
    }


make_ :
    { model :
        { flags : Elm.Expression
        , input : Elm.Expression
        , namespace : Elm.Expression
        }
        -> Elm.Expression
    }
make_ =
    { model =
        \model_args ->
            Elm.withType
                (Type.alias
                    [ "Generate" ]
                    "Model"
                    []
                    (Type.record
                        [ ( "flags"
                          , Type.namedWith [ "Json", "Encode" ] "Value" []
                          )
                        , ( "input", Type.namedWith [] "Input" [] )
                        , ( "namespace", Type.string )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "flags" model_args.flags
                    , Tuple.pair "input" model_args.input
                    , Tuple.pair "namespace" model_args.namespace
                    ]
                )
    }


values_ : { main_ : Elm.Expression }
values_ =
    { main_ =
        Elm.value
            { importFrom = [ "Generate" ]
            , name = "main"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Program"
                        [ Type.namedWith [ "Json", "Encode" ] "Value" []
                        , Type.namedWith [] "Model" []
                        , Type.namedWith [] "Msg" []
                        ]
                    )
            }
    }



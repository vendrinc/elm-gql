module Gen.Generate.Decode exposing (call_, moduleName_, scalar, values_)

{-| 
@docs values_, call_, scalar, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Decode" ]


{-| scalar: String -> Wrapped -> Elm.Expression -}
scalar : String -> Elm.Expression -> Elm.Expression
scalar scalarArg scalarArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Decode" ]
            , name = "scalar"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "Wrapped" [] ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ Elm.string scalarArg, scalarArg0 ]


call_ : { scalar : Elm.Expression -> Elm.Expression -> Elm.Expression }
call_ =
    { scalar =
        \scalarArg scalarArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Decode" ]
                    , name = "scalar"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string, Type.namedWith [] "Wrapped" [] ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ scalarArg, scalarArg0 ]
    }


values_ : { scalar : Elm.Expression }
values_ =
    { scalar =
        Elm.value
            { importFrom = [ "Generate", "Decode" ]
            , name = "scalar"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "Wrapped" [] ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    }



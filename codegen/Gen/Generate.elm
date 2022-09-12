module Gen.Generate exposing (main, moduleName_, values_)

{-| 
@docs values_, main, moduleName_
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



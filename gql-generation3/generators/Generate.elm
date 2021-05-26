module Generator exposing (main)

{-| -}

import Elm
import Elm.Pattern as Pattern
import Elm.Type as Type
import Elm.Gen


main : Program {} () ()
main =
    Platform.worker
        { init =
            json ->
                ( ()
                , Elm.Gen.files
                    [ Elm.render file
                    ]
                )
        , update =
            msg model ->
                ( model, Cmd.none )
        , subscriptions = _ -> Sub.none
        }


file =
    Elm.file (Elm.moduleName [ "My", "Module" ])
        [ Elm.declaration "placeholder"
            (Elm.valueFrom (Elm.moduleAs [ "Json", "Decode" ] "Json")
                "map2"
            )
        , Elm.declaration "myRecord"
            (Elm.record
                [ ( "one", Elm.string "My cool string" )
                , ( "two", Elm.int 5 )
                , ( "three"
                  , Elm.record
                        [ ( "four", Elm.string "My cool string" )
                        , ( "five", Elm.int 5 )
                        ]
                  )
                ]
            )
            |> Elm.expose
        ]

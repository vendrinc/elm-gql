module Generate exposing (main)

{-|-}


import Elm
import Elm.Gen
import Elm.Type as Type
import Elm.Pattern as Pattern


main : Program {} () ()
main =
    Platform.worker
        { init =
            \json ->
                ( ()
                , Elm.Gen.files
                    [ Elm.render file
                    ]
                )
        , update =
            \msg model ->
                (model, Cmd.none)
        , subscriptions = \_ -> Sub.none
        }



file =
    Elm.file (Elm.moduleName [ "My", "Module" ])
        [ Elm.declaration "placeholder"
            (Elm.string "a fancy string!")
        ]
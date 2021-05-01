port module Worker exposing (main)

import Debug
import GraphQL.Schema exposing (empty)

port outgoing : String -> Cmd msg


main : Program Flags () Never
main =
    Platform.worker
        { init = \flags -> ( (), run flags )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }



-- ACTUAL APP


type alias Flags =
    { message : String
    }


run : Flags -> Cmd msg
run flags =
    let
        _ = Debug.log "flags" flags
    in
    outgoing flags.message

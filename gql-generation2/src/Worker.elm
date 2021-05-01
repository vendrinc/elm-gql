port module Worker exposing (main)

import Debug
import GraphQL.Schema exposing (empty)
import Json.Decode as Json

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
    { schemaJson : Json.Value
    }


run : Flags -> Cmd msg
run flags =
    let
        _ = Debug.log "schema" (case Json.decodeValue GraphQL.Schema.decoder flags.schemaJson of
                    Ok schema ->
                        Just schema

                    Err error ->
                        Nothing)
    in
    outgoing "hi"

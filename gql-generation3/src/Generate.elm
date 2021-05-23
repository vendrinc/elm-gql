module Generate exposing (main)

{-| -}

import Elm
import Elm.Gen
import Elm.Pattern as Pattern
import Generate.Enums
import Generate.Objects
import GraphQL.Schema
import Http


main : Program {} () Msg
main =
    Platform.worker
        { init =
            \json ->
                ( ()
                , GraphQL.Schema.get "https://api.blissfully.com/prod/graphql"
                    SchemaReceived
                )
        , update =
            \msg model ->
                case msg of
                    SchemaReceived (Ok schema) ->
                        let
                            enumFiles =
                                Generate.Enums.generateFiles schema
                            
                            objectFiles =
                                Generate.Objects.generateFiles schema
                        in
                        ( model
                        , Elm.Gen.files
                            (List.map Elm.render ( enumFiles ++ objectFiles))
                        )

                    SchemaReceived (Err err) ->
                        ( model, Elm.Gen.error "Something went wrong with retriving the scheam" )
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = SchemaReceived (Result Http.Error GraphQL.Schema.Schema)

module Generate exposing (main)

{-|-}


import Elm
import Elm.Gen
import Elm.Type as Type
import Elm.Pattern as Pattern
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
                --Elm.Gen.files
                --    [ Elm.render file
                --    ]
                )
        , update =
            \msg model ->
                case msg of
                    SchemaReceived (Ok schema) ->
                        (model
                        , Elm.Gen.files
                            [ Elm.render file
                            ]
                        )
                    SchemaReceived (Err err) ->
                        (model, Elm.Gen.error "Something went wrong with retriving the scheam")
        , subscriptions = \_ -> Sub.none
        }


type Msg =
    SchemaReceived (Result Http.Error GraphQL.Schema.Schema)


file =
    Elm.file (Elm.moduleName [ "My", "Module" ])
        [ Elm.declaration "placeholder"
            (Elm.string "a fancy string!")
        ]
module Generate exposing (main)

{-| -}

import Elm
import Elm.Gen
import Elm.Pattern as Pattern
import Generate.Enums
import Generate.Objects
import Generate.Operations
import GraphQL.Schema
import Http
import Dict


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
                            
                            queryFiles =
                                schema.queries
                                    |> Dict.toList
                                    |> List.map Tuple.second
                                    |> Generate.Operations.generateFiles Generate.Operations.Query


                            mutationFiles =
                                schema.queries
                                    |> Dict.toList
                                    |> List.map Tuple.second
                                    |> Generate.Operations.generateFiles Generate.Operations.Mutation
                        in
                        ( model
                        , Elm.Gen.files
                            (List.map Elm.render ( enumFiles ++ objectFiles ++ queryFiles ++ mutationFiles))
                        )

                    SchemaReceived (Err err) ->
                        ( model, Elm.Gen.error "Something went wrong with retriving the scheam" )
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = SchemaReceived (Result Http.Error GraphQL.Schema.Schema)

module Generate exposing (main)

{-| -}

import Dict
import Elm
import Elm.Gen
import Generate.Args
import Generate.Enums
import Generate.InputObjects
import Generate.Objects
import Generate.Operations
import Generate.Unions
import GraphQL.Schema
import Http


main : Program {} { namespace : String } Msg
main =
    Platform.worker
        { init =
            \json ->
                ( { namespace = "TnG" }
                , GraphQL.Schema.get "https://api.blissfully.com/prod/graphql"
                    SchemaReceived
                )
        , update =
            \msg model ->
                case msg of
                    SchemaReceived (Ok schema) ->
                        let
                            enumFiles =
                                Generate.Enums.generateFiles model.namespace schema

                            unionFiles =
                                Generate.Unions.generateFiles model.namespace schema

                            objectFiles =
                                Generate.Objects.generateFiles model.namespace schema

                            inputFiles =
                                Generate.InputObjects.generateFiles model.namespace schema

                            queryFiles =
                                Generate.Operations.generateFiles model.namespace Generate.Args.Query schema

                            mutationFiles =
                                Generate.Operations.generateFiles model.namespace Generate.Args.Mutation schema
                        in
                        ( model
                        , Elm.Gen.files
                            (List.map Elm.render
                                (unionFiles
                                    ++ enumFiles
                                    ++ objectFiles
                                    ++ queryFiles
                                    ++ mutationFiles
                                    ++ inputFiles
                                )
                            )
                        )

                    SchemaReceived (Err err) ->
                        ( model, Elm.Gen.error "Something went wrong with retriving the scheam" )
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = SchemaReceived (Result Http.Error GraphQL.Schema.Schema)

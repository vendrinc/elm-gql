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
import Json.Decode
import Json.Encode


main :
    Program
        Json.Encode.Value
        Model
        Msg
main =
    Platform.worker
        { init =
            \flags ->
                let
                    
                    decoded =
                        Json.Decode.decodeValue flagsDecoder flags
                in
                case decoded of
                    Err err ->
                        ( { flags = flags
                          , input = InputError
                          , namespace = "Api"
                          }
                        , Elm.Gen.error  ("Error decoding flags!")
                        )

                    Ok input ->
                        case input of
                            InputError ->
                                ( { flags = flags
                                  , input = InputError
                                  , namespace = "Api"
                                  }
                                , Elm.Gen.error ("Error decoding flags!")
                                )

                            SchemaInline schema ->
                                ( { flags = flags
                                  , input = input
                                  , namespace = "Api"
                                  }
                                , generateSchema "Api" schema
                                )

                            SchemaGet details ->
                                ( { flags = flags
                                  , input = input
                                  , namespace = details.namespace
                                  }
                                , GraphQL.Schema.get
                                    details.schema
                                    SchemaReceived
                                )
        , update =
            \msg model ->
                case msg of
                    SchemaReceived (Ok schema) ->
                        ( model
                        , generateSchema model.namespace schema
                        )

                    SchemaReceived (Err err) ->
                        ( model
                        , Elm.Gen.error ("Something went wrong with retrieving the schema.\n\n    " ++ httpErrorToString err)
                        )
        , subscriptions = \_ -> Sub.none
        }


generateSchema : String -> GraphQL.Schema.Schema -> Cmd msg
generateSchema namespace schema =
    let
        enumFiles =
            Generate.Enums.generateFiles namespace schema

        unionFiles =
            Generate.Unions.generateFiles namespace schema

        objectFiles =
            Generate.Objects.generateFiles namespace schema

        inputFiles =
            Generate.InputObjects.generateFiles namespace schema

        queryFiles =
            Generate.Operations.generateFiles namespace Generate.Args.Query schema

        mutationFiles =
            Generate.Operations.generateFiles namespace Generate.Args.Mutation schema
    in
    Elm.Gen.files
        (List.map Elm.render
            (unionFiles
                ++ enumFiles
                ++ objectFiles
                ++ queryFiles
                ++ mutationFiles
                ++ inputFiles
            )
        )


flagsDecoder : Json.Decode.Decoder Input
flagsDecoder =
    Json.Decode.oneOf
        [ Json.Decode.map2
            (\namespace schemaUrl ->
                SchemaGet
                    { schema = schemaUrl
                    , namespace = namespace
                    }
            )
            (Json.Decode.field "namespace" Json.Decode.string)
            (Json.Decode.field "schema" Json.Decode.string)
        ,  Json.Decode.map SchemaInline GraphQL.Schema.decoder
        ]


type alias Model =
    { flags : Json.Encode.Value
    , input : Input
    , namespace : String
    }


type Input
    = SchemaInline GraphQL.Schema.Schema
    | SchemaGet
        { schema : String
        , namespace : String
        }
    | InputError


type Msg
    = SchemaReceived (Result Http.Error GraphQL.Schema.Schema)


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        Http.BadUrl msg ->
            "Bad Url: " ++ msg

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus status ->
            "Bad Status: " ++ String.fromInt status

        Http.BadBody msg ->
            "Bad Body: " ++ msg

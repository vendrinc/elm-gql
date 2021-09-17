module Fuzzish exposing (main)

{-| -}

import Dict
import Elm
import Elm.Gen
import Generate.Args
import Generate.Enums
import Generate.Input
import Generate.InputObjects
import Generate.Objects
import Generate.Operations
import Generate.Paged
import Generate.Unions
import Generate.Example
import GraphQL.Operations.AST as AST
import GraphQL.Operations.Generate
import GraphQL.Operations.Parse
import GraphQL.Operations.Validate
import GraphQL.Schema
import Http
import Json.Decode
import Json.Encode
import Utils.String


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
                        , Elm.Gen.error
                            { title = "Error decoding flags"
                            , description = Json.Decode.errorToString err
                            }
                        )

                    Ok input ->
                        case input of
                            InputError ->
                                ( { flags = flags
                                  , input = InputError
                                  , namespace = "Api"
                                  }
                                , Elm.Gen.error
                                    { title = "Error decoding flags"
                                    , description = ""
                                    }
                                )

                            SchemaInline schema ->
                                ( { flags = flags
                                  , input = input
                                  , namespace = "Api"
                                  }
                                , generateExampleFile "Api" schema
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
                        , generateExampleFile model.namespace schema
                        )

                    SchemaReceived (Err err) ->
                        ( model
                        , Elm.Gen.error
                            { title = "Error retieving schema"
                            , description =
                                "Something went wrong with retrieving the schema.\n\n    " ++ httpErrorToString err
                            }
                        )
        , subscriptions = \_ -> Sub.none
        }


generateExampleFile : String -> GraphQL.Schema.Schema -> Cmd msg
generateExampleFile namespace schema =
    Elm.Gen.files
        [ exampleFile namespace schema
            |> Elm.render
        ]


exampleFile : String -> GraphQL.Schema.Schema -> Elm.File
exampleFile namespace schema =
    let
        queries =
            schema.queries
                |> Dict.toList
                -- |> List.filter 
                --     (\(name, op) ->
                --         String.toLower name == "updategsuiteIntegrationAction"

                --     )
                |> List.map (Tuple.pair Generate.Input.Query << Tuple.second)

        mutations =
            schema.mutations
                |> Dict.toList
                |> List.filter 
                    (\(name, op) ->
                        String.toLower name /= "version"

                    )
                |> List.map (Tuple.pair Generate.Input.Mutation << Tuple.second)
            
    in
    Elm.file [ "All" ]
        (List.map
            (\((_, operation) as op) -> 
                Generate.Example.operation namespace schema op
                    |> Elm.declaration (Utils.String.formatValue operation.name)
            )
            (queries ++ mutations)
        )


parseAndValidateQuery : String -> GraphQL.Schema.Schema -> String -> Cmd msg
parseAndValidateQuery namespace schema queryStr =
    case GraphQL.Operations.Parse.parse queryStr of
        Err err ->
            Elm.Gen.error
                { title = "Malformed query"
                , description =
                    Debug.toString err
                }

        Ok query ->
            case GraphQL.Operations.Generate.generate schema query [ "Ops", "Test" ] of
                Err validationError ->
                    Elm.Gen.error
                        { title = "Invalid query"
                        , description =
                            List.map GraphQL.Operations.Validate.errorToString validationError
                                |> String.join "\n\n    "
                        }

                Ok files ->
                    Elm.Gen.files (List.map Elm.render files)


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
        , Json.Decode.map SchemaInline GraphQL.Schema.decoder
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

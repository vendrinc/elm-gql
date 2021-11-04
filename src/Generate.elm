module Generate exposing (main)

{-| -}

import Dict
import Elm
import Elm.Gen
import Generate.Args
import Generate.Enums
import Generate.Input as Input
import Generate.InputObjects
import Generate.Objects
import Generate.Operations
import Generate.Paged
import Generate.Unions
import GraphQL.Operations.AST as AST
import GraphQL.Operations.Canonicalize as Canonicalize
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

                            Flags details ->
                                case details.schema of
                                    SchemaUrl url ->
                                        ( { flags = flags
                                          , input = input
                                          , namespace = details.namespace
                                          }
                                        , GraphQL.Schema.get
                                            url
                                            (SchemaReceived details)
                                        )

                                    Schema schema ->
                                        ( { flags = flags
                                          , input = input
                                          , namespace = details.namespace
                                          }
                                        , generateSchema details.namespace schema details
                                        )
        , update =
            \msg model ->
                case msg of
                    SchemaReceived flagDetails (Ok schema) ->
                        ( model
                        , generateSchema model.namespace schema flagDetails
                        )

                    SchemaReceived flagDetails (Err err) ->
                        ( model
                        , Elm.Gen.error
                            { title = "Error retieving schema"
                            , description =
                                "Something went wrong with retrieving the schema.\n\n    " ++ httpErrorToString err
                            }
                        )
        , subscriptions = \_ -> Sub.none
        }


generateSchema : String -> GraphQL.Schema.Schema -> FlagDetails -> Cmd Msg
generateSchema namespace schema flagDetails =
    let

        -- _ =
        --     Generate.Paged.generate namespace schema
        parsedGqlQueries =
            parseGql namespace schema flagDetails flagDetails.gql []
    in
    case parsedGqlQueries of
        Err err ->
            Elm.Gen.error err

        Ok gqlFiles ->
            if flagDetails.generatePlatform then
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
                        Generate.Operations.generateFiles namespace Input.Query schema

                    mutationFiles =
                        Generate.Operations.generateFiles namespace Input.Mutation schema
                in
                Elm.Gen.files
                    (unionFiles
                        ++ enumFiles
                        ++ objectFiles
                        ++ queryFiles
                        ++ mutationFiles
                        ++ inputFiles
                        ++ gqlFiles
                    )

            else
                Elm.Gen.files
                    gqlFiles


parseGql : String -> GraphQL.Schema.Schema -> c -> List { src : String, path : String } -> List Elm.File -> Result Error (List Elm.File)
parseGql namespace schema flagDetails gql rendered =
    case gql of
        [] ->
            Ok rendered

        top :: remaining ->
            case parseAndValidateQuery namespace schema top of
                Ok parsedFiles ->
                    parseGql namespace
                        schema
                        flagDetails
                        remaining
                        (rendered ++ parsedFiles)

                Err err ->
                    Err err


flagsDecoder : Json.Decode.Decoder Input
flagsDecoder =
    Json.Decode.oneOf
        [ Json.Decode.map4
            (\namespace gql schemaUrl generatePlatform ->
                Flags
                    { schema = schemaUrl
                    , gql = gql
                    , namespace = namespace
                    , generatePlatform = generatePlatform
                    }
            )
            (Json.Decode.field "namespace" Json.Decode.string)
            (Json.Decode.field "gql"
                (Json.Decode.list
                    (Json.Decode.map2
                        (\path src ->
                            { path = path
                            , src = src
                            }
                        )
                        (Json.Decode.field "path" Json.Decode.string)
                        (Json.Decode.field "src" Json.Decode.string)
                    )
                )
            )
            (Json.Decode.field "schema"
                (Json.Decode.oneOf
                    [ Json.Decode.map SchemaUrl
                        (Json.Decode.string
                            |> Json.Decode.andThen
                                (\str ->
                                    if String.startsWith "http" str then
                                        Json.Decode.succeed str

                                    else
                                        Json.Decode.fail "Schema Url lacks http-based protocol"
                                )
                        )
                    , Json.Decode.map Schema GraphQL.Schema.decoder
                    ]
                )
            )
            (Json.Decode.field "generatePlatform" Json.Decode.bool)
        ]


type alias Model =
    { flags : Json.Encode.Value
    , input : Input
    , namespace : String
    }


type Input
    = Flags FlagDetails
    | InputError


type alias FlagDetails =
    { schema : Schema
    , gql : List Gql
    , namespace : String
    , generatePlatform : Bool
    }


type alias Gql =
    { path : String
    , src : String
    }


type Schema
    = SchemaUrl String
    | Schema GraphQL.Schema.Schema


type Msg
    = SchemaReceived FlagDetails (Result Http.Error GraphQL.Schema.Schema)


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


type alias Error =
    { title : String
    , description : String
    }


parseAndValidateQuery : String -> GraphQL.Schema.Schema -> { src : String, path : String } -> Result Error (List Elm.File)
parseAndValidateQuery namespace schema gql =
    case GraphQL.Operations.Parse.parse gql.src of
        Err err ->
            Err
                { title = "Malformed query"
                , description =
                    GraphQL.Operations.Parse.errorToString err
                }

        Ok query ->
            case Canonicalize.canonicalize schema query of
                Err errors ->
                    Err
                        { title = "Errors"
                        , description =
                            List.map Canonicalize.errorToString errors
                                |> String.join "\n\n    "
                        }

                Ok canAST ->
                    let
                        name =
                            gql.path
                                |> String.split "/"
                                |> List.reverse
                                |> List.head
                                |> Maybe.withDefault "Query"
                                |> String.replace ".gql" ""
                                |> Utils.String.formatTypename
                    in
                    case GraphQL.Operations.Generate.generate namespace schema gql.src canAST [ namespace, name ] of
                        Err validationError ->
                            Err
                                { title = "Invalid query"
                                , description =
                                    List.map GraphQL.Operations.Validate.errorToString validationError
                                        |> String.join "\n\n    "
                                }

                        Ok files ->
                            Ok files

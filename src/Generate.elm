module Generate exposing (Input, Model, Msg, main)

{-| -}

import Elm
import Gen as Generate
import Gen.GraphQL.Mock
import Generate.Enums
import Generate.InputObjects
import Generate.Root
import GraphQL.Operations.Canonicalize as Canonicalize
import GraphQL.Operations.Canonicalize.Error as Error
import GraphQL.Operations.Generate
import GraphQL.Operations.Parse
import GraphQL.Schema exposing (Namespace)
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
            \json ->
                let
                    decoded =
                        Json.Decode.decodeValue flagsDecoder json
                in
                case decoded of
                    Err err ->
                        ( { flags = json
                          , input = InputError
                          , namespace = "Api"
                          }
                        , Generate.error
                            [ { title = "Error decoding flags"
                              , description = Json.Decode.errorToString err
                              }
                            ]
                        )

                    Ok input ->
                        case input of
                            InputError ->
                                ( { flags = json
                                  , input = InputError
                                  , namespace = "Api"
                                  }
                                , Generate.error
                                    [ { title = "Error decoding flags"
                                      , description = ""
                                      }
                                    ]
                                )

                            Flags flags ->
                                case flags.schema of
                                    SchemaUrl url ->
                                        case parseHeaders flags.header of
                                            Err error ->
                                                ( { flags = json
                                                  , input = InputError
                                                  , namespace = flags.namespace
                                                  }
                                                , Generate.error
                                                    [ error
                                                    ]
                                                )

                                            Ok headers ->
                                                ( { flags = json
                                                  , input = input
                                                  , namespace = flags.namespace
                                                  }
                                                , GraphQL.Schema.getJsonValue headers
                                                    url
                                                    (SchemaReceived flags)
                                                )

                                    Schema schemaAsJson schema ->
                                        ( { flags = json
                                          , input = input
                                          , namespace = flags.namespace
                                          }
                                        , generatePlatform flags.namespace schema schemaAsJson flags
                                        )
        , update =
            \msg model ->
                case msg of
                    SchemaReceived flagDetails (Ok schemaJsonValue) ->
                        case Json.Decode.decodeValue GraphQL.Schema.decoder schemaJsonValue of
                            Ok schema ->
                                ( model
                                , generatePlatform model.namespace schema schemaJsonValue flagDetails
                                )

                            Err decodingError ->
                                ( model
                                , Generate.error
                                    [ { title = "Error decoding schema"
                                      , description =
                                            "Something went wrong with decoding the schema.\n\n    " ++ Json.Decode.errorToString decodingError
                                      }
                                    ]
                                )

                    SchemaReceived _ (Err err) ->
                        ( model
                        , Generate.error
                            [ { title = "Error retrieving schema"
                              , description =
                                    "Something went wrong with retrieving the schema.\n\n    " ++ httpErrorToString err
                              }
                            ]
                        )
        , subscriptions = \_ -> Sub.none
        }


parseHeaders : List String -> Result { title : String, description : String } (List ( String, String ))
parseHeaders headers =
    headers
        |> List.foldl parseSingleHeader (Ok [])
        |> Result.map List.reverse


parseSingleHeader : String -> Result { title : String, description : String } (List ( String, String )) -> Result { title : String, description : String } (List ( String, String ))
parseSingleHeader headerString result =
    case result of
        Err err ->
            Err err

        Ok headers ->
            case String.split ":" headerString of
                [] ->
                    Err
                        { title = "Unknown Header Format"
                        , description =
                            "I received the header '"
                                ++ headerString
                                ++ "' but I wasn't able parse it."
                                ++ """
Headers should be provided 

    --header 'Authorization: bearer TOKEN'
"""
                        }

                key :: remaining ->
                    Ok (( String.trim key, String.join "," remaining ) :: headers)


generatePlatform : String -> GraphQL.Schema.Schema -> Json.Encode.Value -> FlagDetails -> Cmd Msg
generatePlatform namespaceStr schema schemaAsJson flagDetails =
    let
        namespace =
            { namespace = namespaceStr
            , enums = Maybe.withDefault namespaceStr flagDetails.existingEnumDefinitions
            }

        parsedGqlQueries =
            List.foldl (parseGql namespace schema flagDetails)
                (Ok [])
                flagDetails.gql
    in
    case parsedGqlQueries of
        Err err ->
            Generate.error [ err ]

        Ok gqlFiles ->
            if flagDetails.generatePlatform then
                let
                    schemaFiles =
                        saveSchemaAsElm namespace schemaAsJson
                            :: saveSchemaAsJson namespace schemaAsJson
                            :: Generate.Enums.generateFiles namespace schema
                            ++ Generate.InputObjects.generateFiles namespace schema

                    all =
                        List.map (addOutputDir flagDetails.elmBaseSchema) schemaFiles
                            ++ gqlFiles

                    -- This is a test file with references to every file generated, useful for testing!
                    -- testFile =
                    --     Elm.file [ "Test" ]
                    --         [ Elm.declaration "all"
                    --             (Elm.string (String.join "\\n" (List.map (.path >> formatElmPath) all)))
                    --         ]
                in
                Generate.files
                    (if flagDetails.isInit then
                        (Generate.Root.generate namespace schema
                            |> addOutputDir [ "src" ]
                        )
                            :: all

                     else
                        all
                    )

            else
                Generate.files
                    gqlFiles


addOutputDir : List String -> { a | path : String } -> { a | path : String }
addOutputDir pieces file =
    { file
        | path = String.join "/" pieces ++ "/" ++ file.path
    }


saveSchemaAsElm : Namespace -> Json.Encode.Value -> Elm.File
saveSchemaAsElm namespace val =
    Elm.file [ namespace.namespace, "Meta", "Schema" ]
        [ Elm.declaration "schema"
            (Gen.GraphQL.Mock.schemaFromString (Json.Encode.encode 4 val))
            |> Elm.expose
        ]


saveSchemaAsJson : Namespace -> Json.Encode.Value -> Elm.File
saveSchemaAsJson namespace val =
    { path = namespace.namespace ++ "/" ++ "schema.json"
    , warnings = []
    , contents = Json.Encode.encode 4 val
    }


parseGql :
    Namespace
    -> GraphQL.Schema.Schema
    -> FlagDetails
    -> { src : String, path : String }
    -> Result Error (List Elm.File)
    -> Result Error (List Elm.File)
parseGql namespace schema flagDetails gql result =
    case result of
        Ok files ->
            case parseAndValidateQuery namespace schema flagDetails gql of
                Ok parsedFiles ->
                    Ok (files ++ parsedFiles)

                Err err ->
                    Err err

        Err err ->
            result


flagsDecoder : Json.Decode.Decoder Input
flagsDecoder =
    Json.Decode.succeed
        (\gqlDir elmBaseSchema namespace header isInit gql schemaUrl genPlatform existingEnums ->
            Flags
                { schema = schemaUrl
                , gql = gql
                , isInit = isInit
                , gqlDir = gqlDir
                , elmBaseSchema = elmBaseSchema
                , namespace = namespace
                , header = header
                , generatePlatform = genPlatform
                , existingEnumDefinitions = existingEnums
                }
        )
        |> andField "gqlDir" (Json.Decode.list Json.Decode.string)
        |> andField "elmBaseSchema" (Json.Decode.list Json.Decode.string)
        |> andField "namespace" Json.Decode.string
        |> andField "header" (Json.Decode.list Json.Decode.string)
        |> andField "init" Json.Decode.bool
        |> andField "gql"
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
        |> andField "schema"
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
                , Json.Decode.map2 Schema
                    Json.Decode.value
                    GraphQL.Schema.decoder
                ]
            )
        |> andField "generatePlatform" Json.Decode.bool
        |> andField "existingEnumDefinitions"
            (Json.Decode.string
                |> Json.Decode.maybe
            )


andField : String -> Json.Decode.Decoder a -> Json.Decode.Decoder (a -> b) -> Json.Decode.Decoder b
andField name fieldDecoder baseDecoder =
    Json.Decode.map2
        (\a fn ->
            fn a
        )
        (Json.Decode.field name fieldDecoder)
        baseDecoder


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

    -- all directories between and including cwd and the elm src dir
    , gqlDir : List String

    -- We do a little bit more generation if init is called
    , isInit : Bool

    -- same as above, but for the schema-related files
    -- sometimes it's nice to separate that out into a separate dir.
    , elmBaseSchema : List String
    , namespace : String

    -- The unparsed header for the introspection query
    , header : List String
    , generatePlatform : Bool
    , existingEnumDefinitions : Maybe String
    }


type alias Gql =
    -- relative path from cwd to gql file, including the gql filename
    { path : String

    -- the entire source file
    , src : String
    }


type Schema
    = SchemaUrl String
    | Schema Json.Encode.Value GraphQL.Schema.Schema


type Msg
    = SchemaReceived FlagDetails (Result Http.Error Json.Encode.Value)


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

    -- , file : Maybe String
    , description : String
    }


parseAndValidateQuery :
    Namespace
    -> GraphQL.Schema.Schema
    -> FlagDetails
    -> Gql
    -> Result Error (List Elm.File)
parseAndValidateQuery namespace schema flags gql =
    case GraphQL.Operations.Parse.parse gql.src of
        Err err ->
            Err
                { title = formatTitle "UNABLE TO PARSE QUERY" gql.path
                , description =
                    GraphQL.Operations.Parse.errorToString err
                }

        Ok query ->
            case
                Canonicalize.canonicalize schema
                    { path = gql.path
                    , gqlDir = flags.gqlDir
                    }
                    query
            of
                Err errors ->
                    Err
                        { title = formatTitle "ELM GQL" gql.path
                        , description =
                            List.map Error.toString errors
                                |> String.join (Error.cyan "\n-------------------\n\n")
                        }

                Ok canAST ->
                    GraphQL.Operations.Generate.generate
                        { namespace = namespace
                        , schema = schema
                        , document = canAST
                        , path = gql.path
                        , gqlDir = flags.gqlDir
                        }
                        |> Ok


formatTitle : String -> String -> String
formatTitle title path =
    let
        middle =
            "-" |> String.repeat (78 - (String.length title + 2 + String.length path))
    in
    title ++ middle ++ path

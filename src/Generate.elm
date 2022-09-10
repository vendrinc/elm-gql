module Generate exposing (main)

{-| -}

-- import Gen.CodeGen.Generate as Generate

import Elm
import Elm.Annotation
import Gen as Generate
import Gen.GraphQL.Mock
import Generate.Enums
import Generate.Input as Input
import Generate.InputObjects
import Generate.Objects
import Generate.Operations
import Generate.Paged
import Generate.Unions
import GraphQL.Operations.Canonicalize as Canonicalize
import GraphQL.Operations.Generate
import GraphQL.Operations.GenerateSelection
import GraphQL.Operations.Parse
import GraphQL.Operations.Validate
import GraphQL.Schema exposing (Namespace)
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
                        , Generate.error
                            [ { title = "Error decoding flags"
                              , description = Json.Decode.errorToString err
                              }
                            ]
                        )

                    Ok input ->
                        case input of
                            InputError ->
                                ( { flags = flags
                                  , input = InputError
                                  , namespace = "Api"
                                  }
                                , Generate.error
                                    [ { title = "Error decoding flags"
                                      , description = ""
                                      }
                                    ]
                                )

                            Flags details ->
                                case details.schema of
                                    SchemaUrl url ->
                                        ( { flags = flags
                                          , input = input
                                          , namespace = details.namespace
                                          }
                                        , GraphQL.Schema.getJsonValue
                                            url
                                            (SchemaReceived details)
                                        )

                                    Schema schemaAsJson schema ->
                                        ( { flags = flags
                                          , input = input
                                          , namespace = details.namespace
                                          }
                                        , generatePlatform details.namespace schema schemaAsJson details
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

                    SchemaReceived flagDetails (Err err) ->
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


generatePlatform : String -> GraphQL.Schema.Schema -> Json.Encode.Value -> FlagDetails -> Cmd Msg
generatePlatform namespaceStr schema schemaAsJson flagDetails =
    let
        namespace =
            { namespace = namespaceStr
            , enums = Maybe.withDefault namespaceStr flagDetails.existingEnumDefinitions
            }

        -- _ =
        --     Generate.Paged.generate namespace schema
        parsedGqlQueries =
            parseGql namespace schema flagDetails flagDetails.gql []
    in
    case parsedGqlQueries of
        Err err ->
            Generate.error [ err ]

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

                    schemaFiles =
                        saveSchema namespace schemaAsJson
                            :: unionFiles
                            ++ enumFiles
                            ++ objectFiles
                            ++ queryFiles
                            ++ mutationFiles
                            ++ inputFiles

                    all =
                        schemaFiles ++ gqlFiles

                    -- This is a test file with references to every file generated, useful for testing!
                    -- testFile =
                    --     Elm.file [ "Test" ]
                    --         [ Elm.declaration "all"
                    --             (Elm.string (String.join "\\n" (List.map (.path >> formatElmPath) all)))
                    --         ]
                in
                Generate.files
                    (List.map (addOutputDir flagDetails.elmBaseSchema) all)

            else
                Generate.files
                    gqlFiles


formatElmPath : String -> String
formatElmPath str =
    str
        |> String.replace ".elm" ""
        |> String.replace "/" "."


addOutputDir : List String -> { a | path : String } -> { a | path : String }
addOutputDir pieces file =
    { file
        | path = String.join "/" pieces ++ "/" ++ file.path
    }


saveSchema : Namespace -> Json.Encode.Value -> Elm.File
saveSchema namespace val =
    Elm.file [ namespace.namespace, "Meta", "Schema" ]
        [ Elm.declaration "schema"
            (Gen.GraphQL.Mock.schemaFromString (Json.Encode.encode 4 val))
            |> Elm.expose
        ]


parseGql :
    Namespace
    -> GraphQL.Schema.Schema
    -> FlagDetails
    -> List { src : String, path : String }
    -> List Elm.File
    -> Result Error (List Elm.File)
parseGql namespace schema flagDetails gql rendered =
    case gql of
        [] ->
            Ok rendered

        top :: remaining ->
            case parseAndValidateQuery namespace schema flagDetails top of
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
        [ Json.Decode.map7
            (\elmBase elmBaseSchema namespace gql schemaUrl genPlatform existingEnums ->
                Flags
                    { schema = schemaUrl
                    , gql = gql
                    , elmBase = elmBase
                    , elmBaseSchema = elmBaseSchema
                    , namespace = namespace
                    , generatePlatform = genPlatform
                    , existingEnumDefinitions = existingEnums
                    }
            )
            (Json.Decode.field "elmBase" (Json.Decode.list Json.Decode.string))
            (Json.Decode.field "elmBaseSchema" (Json.Decode.list Json.Decode.string))
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
                    , Json.Decode.map2 Schema
                        Json.Decode.value
                        GraphQL.Schema.decoder
                    ]
                )
            )
            (Json.Decode.field "generatePlatform" Json.Decode.bool)
            (Json.Decode.field "existingEnumDefinitions"
                Json.Decode.string
                |> Json.Decode.maybe
            )
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

    -- all directories between cwd and the elm src dir
    , elmBase : List String

    -- same as above, but for the schema-related files
    -- sometimes it's nice to separate that out into a separate dir.
    , elmBaseSchema : List String
    , namespace : String
    , generatePlatform : Bool
    , existingEnumDefinitions : Maybe String
    }


type alias Gql =
    --
    { path : String

    -- relative path from cwd to gql file, including the gql filename
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
                { title = formatTitle "WEIRD QUERY" gql.path
                , description =
                    GraphQL.Operations.Parse.errorToString err
                }

        Ok query ->
            case Canonicalize.canonicalize schema query of
                Err errors ->
                    Err
                        { title = formatTitle "ELM GQL" gql.path

                        -- , file = Just gql.path
                        , description =
                            List.map Canonicalize.errorToString errors
                                |> String.join (Canonicalize.cyan "\n-------------------\n\n")
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
                    case
                        GraphQL.Operations.GenerateSelection.generate
                            { namespace =
                                namespace
                            , schema = schema
                            , document = canAST
                            , path =
                                gql.path
                                    |> String.split "/"
                                    |> List.map (String.replace ".gql" "")
                            , elmBase = flags.elmBase
                            }
                    of
                        Err validationError ->
                            Err
                                { title = formatTitle "INVALID QUERY" gql.path

                                -- , file = Just gql.path
                                , description =
                                    List.map GraphQL.Operations.Validate.errorToString validationError
                                        |> String.join "\n\n    "
                                }

                        Ok files ->
                            Ok files


formatTitle : String -> String -> String
formatTitle title path =
    let
        middle =
            "-" |> String.repeat (78 - (String.length title + 2 + String.length path))
    in
    title ++ middle ++ path

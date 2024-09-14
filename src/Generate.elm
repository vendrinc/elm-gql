module Generate exposing (Input, Model, Msg, main)

{-| -}

import Elm
import Gen as Generate
import Generate.Enums
import Generate.InputObjects
import Generate.Root
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Canonicalize as Canonicalize
import GraphQL.Operations.Canonicalize.Error as Error
import GraphQL.Operations.Generate
import GraphQL.Operations.Generate.Fragment
import GraphQL.Operations.Generate.Mock.Fragment as MockFragment
import GraphQL.Operations.Parse
import GraphQL.Schema exposing (Namespace)
import GraphQL.Usage
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

        globalFragmentsResult =
            flagDetails.globalFragments
                |> parseGlobalFragments namespace schema flagDetails
    in
    case globalFragmentsResult of
        Err err ->
            Generate.error [ err ]

        Ok globalFragments ->
            generatePlatformHelper namespace schema schemaAsJson flagDetails globalFragments


generatePlatformHelper :
    Namespace
    -> GraphQL.Schema.Schema
    -> Json.Encode.Value
    -> FlagDetails
    ->
        { fragments : List Can.Fragment
        , files : List Elm.File
        , usages : GraphQL.Usage.Usages
        }
    -> Cmd Msg
generatePlatformHelper namespace schema schemaAsJson flagDetails globalFragments =
    let
        parsedGraphQLQueriesResult =
            flagDetails.gql
                |> List.foldl (parseGql namespace schema flagDetails globalFragments.fragments)
                    (Ok { files = [], usages = globalFragments.usages })
    in
    case parsedGraphQLQueriesResult of
        Err err ->
            Generate.error [ err ]

        Ok parsedGQL ->
            let
                gqlFiles =
                    case flagDetails.outputAll of
                        Nothing ->
                            parsedGQL.files

                        Just outputDir ->
                            parsedGQL.files
                                |> List.map
                                    (replaceOutputDir
                                        { new = outputDir
                                        , original = flagDetails.queryDir
                                        }
                                    )

                finalGlobalFragments =
                    case flagDetails.outputAll of
                        Nothing ->
                            globalFragments.files

                        Just outputDir ->
                            globalFragments.files
                                |> List.map
                                    (replaceOutputDir
                                        { new = outputDir
                                        , original = flagDetails.fragmentDir
                                        }
                                    )
            in
            (finalGlobalFragments ++ gqlFiles)
                |> appendIf (flagDetails.initDir /= Nothing && flagDetails.generatePlatform)
                    (\_ ->
                        case flagDetails.initDir of
                            Nothing ->
                                []

                            Just initDir ->
                                -- These are files that are only generated when `elm-gql init` is run
                                -- And the user should own
                                [ Generate.Root.generate namespace schema
                                    |> addOutputDir initDir
                                ]
                    )
                |> appendIf flagDetails.generatePlatform
                    (\_ ->
                        List.map (addOutputDir flagDetails.outputPlatformDir)
                            (saveSchemaAsJson namespace schemaAsJson
                                :: Generate.Enums.generateFiles namespace schema
                                ++ Generate.InputObjects.generateFiles namespace schema
                            )
                    )
                |> appendIf flagDetails.reportUnused
                    (\_ ->
                        [ { path = String.join "/" flagDetails.outputPlatformDir ++ "/unused.schema"
                          , contents =
                                parsedGQL.usages
                                    |> GraphQL.Usage.toUnusedReport schema
                                    |> GraphQL.Schema.toString
                                    |> prepend """# This file is generated automatically when `elm-gql` is run.
    #
    # This captures all parts of the schema that were not used by any of your graphQL queries or mutations.

    """
                          , warnings = []
                          }
                        ]
                    )
                |> Generate.files


prepend : String -> String -> String
prepend prefix str =
    prefix ++ "\n\n" ++ str


appendIf : Bool -> (() -> List a) -> List a -> List a
appendIf condition fn list =
    if condition then
        list ++ fn ()

    else
        list


replaceOutputDir : { original : List String, new : List String } -> { a | path : String } -> { a | path : String }
replaceOutputDir { original, new } file =
    { file
        | path =
            String.join "/" new
                ++ "/"
                ++ (file.path
                        |> dropStarting (String.join "/" original)
                        |> dropStarting "/"
                   )
    }


dropStarting : String -> String -> String
dropStarting starting str =
    if String.startsWith starting str then
        String.dropLeft (String.length starting) str

    else
        str


addOutputDir : List String -> { a | path : String } -> { a | path : String }
addOutputDir pieces file =
    { file
        | path = String.join "/" pieces ++ "/" ++ file.path
    }


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
    -> List Can.Fragment
    -> { src : String, path : String }
    ->
        Result
            Error
            { files : List Elm.File
            , usages : GraphQL.Usage.Usages
            }
    ->
        Result
            Error
            { files : List Elm.File
            , usages : GraphQL.Usage.Usages
            }
parseGql namespace schema flagDetails fragments gql result =
    case result of
        Ok files ->
            case parseAndValidateQuery namespace schema flagDetails fragments gql of
                Ok parsedFiles ->
                    Ok (mergeResults files parsedFiles)

                Err err ->
                    Err err

        Err _ ->
            result


mergeResults :
    { files : List Elm.File
    , usages : GraphQL.Usage.Usages
    }
    ->
        { files : List Elm.File
        , usages : GraphQL.Usage.Usages
        }
    ->
        { files : List Elm.File
        , usages : GraphQL.Usage.Usages
        }
mergeResults one two =
    { files = one.files ++ two.files
    , usages = GraphQL.Usage.merge one.usages two.usages
    }


parseGlobalFragments :
    Namespace
    -> GraphQL.Schema.Schema
    -> FlagDetails
    -> List { src : String, path : String }
    ->
        Result
            Error
            { fragments : List Can.Fragment
            , files : List Elm.File
            , usages : GraphQL.Usage.Usages
            }
parseGlobalFragments namespace schema flagDetails files =
    let
        maybeParsedAst =
            List.foldl
                (\file maybeGathered ->
                    case maybeGathered of
                        Nothing ->
                            case parseGlobalFragmentsFile namespace schema flagDetails file of
                                Err err ->
                                    Just (Err err)

                                Ok ast ->
                                    Just (Ok ast)

                        Just (Err err) ->
                            maybeGathered

                        Just (Ok existingAST) ->
                            case parseGlobalFragmentsFile namespace schema flagDetails file of
                                Err err ->
                                    Just (Err err)

                                Ok ast ->
                                    Just (Ok (AST.merge ast existingAST))
                )
                Nothing
                files
    in
    case maybeParsedAst of
        Nothing ->
            Ok { fragments = [], files = [], usages = GraphQL.Usage.init }

        Just (Err err) ->
            Err err

        Just (Ok ast) ->
            let
                canonicalizationResult =
                    Canonicalize.canonicalize namespace
                        schema
                        { path = namespace.namespace
                        , queryDir = []
                        , fragmentDir = flagDetails.fragmentDir
                        }
                        []
                        ast
            in
            case canonicalizationResult of
                Err errors ->
                    Err
                        (Error.render
                            { path = "Global fragments"
                            , errors = errors
                            }
                        )

                Ok canAST ->
                    let
                        fragments =
                            List.map
                                (Can.markFragmentAsGlobal
                                    { path = namespace.namespace
                                    , queryDir = flagDetails.fragmentDir
                                    , namespace = namespace.namespace
                                    }
                                )
                                canAST.fragments
                    in
                    Ok
                        { fragments =
                            fragments
                        , files =
                            List.concatMap
                                (\frag ->
                                    let
                                        opts =
                                            { namespace = namespace
                                            , schema = schema
                                            , document =
                                                { definitions = []
                                                , fragments = [ frag ]
                                                , usages = canAST.usages
                                                }
                                            , path = namespace.namespace
                                            , queryDir = flagDetails.fragmentDir
                                            , generateMocks = flagDetails.generateMocks
                                            }

                                        fragFile =
                                            GraphQL.Operations.Generate.Fragment.generate
                                                opts
                                                frag
                                    in
                                    if flagDetails.generateMocks then
                                        [ fragFile, MockFragment.generate opts frag ]

                                    else
                                        [ fragFile ]
                                )
                                fragments
                        , usages = canAST.usages
                        }


mergeFragmentResults :
    { fragments : List Can.Fragment
    , usages : GraphQL.Usage.Usages
    }
    ->
        { fragments : List Can.Fragment
        , usages : GraphQL.Usage.Usages
        }
    ->
        { fragments : List Can.Fragment
        , usages : GraphQL.Usage.Usages
        }
mergeFragmentResults one two =
    { fragments = one.fragments ++ two.fragments
    , usages = GraphQL.Usage.merge one.usages two.usages
    }


{-| Go through each fragment file and parse into an `AST`.
-}
parseGlobalFragmentsFile :
    Namespace
    -> GraphQL.Schema.Schema
    -> FlagDetails
    -> Gql
    -> Result Error AST.Document
parseGlobalFragmentsFile namespace schema flags gql =
    case GraphQL.Operations.Parse.parse gql.src of
        Err err ->
            Err
                (Error.render
                    { path = gql.path
                    , errors =
                        [ Error.UnableToParse { description = GraphQL.Operations.Parse.errorToString err }
                            |> Error.error
                        ]
                    }
                )

        Ok ast ->
            case ast.definitions of
                [ AST.Fragment single ] ->
                    let
                        fragname =
                            AST.nameToString single.name

                        fragnameFromPath =
                            Utils.String.toFilename gql.path
                    in
                    if String.toLower fragname == String.toLower fragnameFromPath then
                        Ok ast

                    else
                        Err
                            (Error.render
                                { path = gql.path
                                , errors =
                                    [ Error.GlobalFragmentNameFilenameMismatch
                                        { filename = gql.path
                                        , fragmentName = "fragment " ++ fragname
                                        }
                                        |> Error.error
                                    ]
                                }
                            )

                _ ->
                    Err
                        (Error.render
                            { path = gql.path
                            , errors =
                                [ Error.GlobalFragmentTooMuchStuff
                                    |> Error.error
                                ]
                            }
                        )


parseAndValidateFragments :
    Namespace
    -> GraphQL.Schema.Schema
    -> FlagDetails
    -> Gql
    ->
        Result
            Error
            { fragments : List Can.Fragment
            , usages : GraphQL.Usage.Usages
            }
parseAndValidateFragments namespace schema flags gql =
    case GraphQL.Operations.Parse.parse gql.src of
        Err err ->
            Err
                (Error.render
                    { path = gql.path
                    , errors =
                        [ Error.UnableToParse { description = GraphQL.Operations.Parse.errorToString err }
                            |> Error.error
                        ]
                    }
                )

        Ok query ->
            case
                Canonicalize.canonicalize namespace
                    schema
                    { path = gql.path
                    , queryDir = flags.queryDir
                    , fragmentDir = flags.fragmentDir
                    }
                    []
                    query
            of
                Err errors ->
                    Err
                        (Error.render
                            { path = gql.path
                            , errors = errors
                            }
                        )

                Ok canAST ->
                    case canAST.fragments of
                        [ single ] ->
                            let
                                fragname =
                                    Can.nameToString single.name

                                fragnameFromPath =
                                    Utils.String.toFilename gql.path
                            in
                            if String.toLower fragname == String.toLower fragnameFromPath && List.isEmpty canAST.definitions then
                                Ok
                                    { fragments = canAST.fragments
                                    , usages = canAST.usages
                                    }

                            else if not (List.isEmpty canAST.definitions) then
                                Err
                                    (Error.render
                                        { path = gql.path
                                        , errors =
                                            [ Error.error Error.GlobalFragmentTooMuchStuff
                                            ]
                                        }
                                    )

                            else
                                Err
                                    (Error.render
                                        { path = gql.path
                                        , errors =
                                            [ Error.GlobalFragmentNameFilenameMismatch
                                                { filename = fragnameFromPath
                                                , fragmentName = fragname
                                                }
                                                |> Error.error
                                            ]
                                        }
                                    )

                        _ ->
                            Err
                                (Error.render
                                    { path = gql.path
                                    , errors =
                                        [ Error.GlobalFragmentTooMuchStuff
                                            |> Error.error
                                        ]
                                    }
                                )


flagsDecoder : Json.Decode.Decoder Input
flagsDecoder =
    Json.Decode.succeed
        (\queryDir fragmentDir outputPlatformDir outputAll namespace header initDir gql globalFragments schemaUrl genPlatform generateMocks reportUnused existingEnums ->
            Flags
                { schema = schemaUrl
                , gql = gql
                , fragmentDir = fragmentDir
                , globalFragments = globalFragments
                , initDir = initDir
                , queryDir = queryDir
                , outputPlatformDir =
                    case outputAll of
                        Nothing ->
                            outputPlatformDir

                        Just outputDir ->
                            outputDir
                , outputAll = outputAll
                , namespace = namespace
                , header = header
                , generatePlatform = genPlatform
                , generateMocks = generateMocks
                , reportUnused = reportUnused
                , existingEnumDefinitions = existingEnums
                }
        )
        |> andField "queryDir" (Json.Decode.list Json.Decode.string)
        |> andField "fragmentDir" (Json.Decode.list Json.Decode.string)
        |> andField "outputPlatformDir" (Json.Decode.list Json.Decode.string)
        |> andField "outputAll" (Json.Decode.maybe (Json.Decode.list Json.Decode.string))
        |> andField "namespace" Json.Decode.string
        |> andField "header" (Json.Decode.list Json.Decode.string)
        |> andField "initDir" (Json.Decode.maybe (Json.Decode.list Json.Decode.string))
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
        |> andField "globalFragments"
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
        |> andField "generateMocks" Json.Decode.bool
        |> andField "reportUnused" Json.Decode.bool
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
    , namespace : String
    , gql : List Gql
    , globalFragments : List Gql

    -- We generate an `Api.elm` file in the following directory if it's provided'
    , initDir : Maybe (List String)

    --
    , fragmentDir : List String

    -- all directories between and including cwd and the elm src dir
    , queryDir : List String

    -- Dir for platform files
    , outputPlatformDir : List String
    , outputAll : Maybe (List String)

    -- The unparsed header for the introspection query
    , header : List String
    , generatePlatform : Bool
    , generateMocks : Bool
    , reportUnused : Bool
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
    -> List Can.Fragment
    -> Gql
    ->
        Result
            Error
            { files : List Elm.File
            , usages : GraphQL.Usage.Usages
            }
parseAndValidateQuery namespace schema flags globalFragments gql =
    case GraphQL.Operations.Parse.parse gql.src of
        Err err ->
            Err
                (Error.render
                    { path = gql.path
                    , errors =
                        [ Error.UnableToParse { description = GraphQL.Operations.Parse.errorToString err }
                            |> Error.error
                        ]
                    }
                )

        Ok query ->
            case
                Canonicalize.canonicalize namespace
                    schema
                    { path = gql.path
                    , queryDir = flags.queryDir
                    , fragmentDir = flags.fragmentDir
                    }
                    globalFragments
                    query
            of
                Err errors ->
                    Err
                        (Error.render
                            { path = gql.path
                            , errors = errors
                            }
                        )

                Ok canAST ->
                    Ok
                        { files =
                            GraphQL.Operations.Generate.generate
                                { namespace = namespace
                                , schema = schema
                                , document = canAST
                                , path = gql.path
                                , queryDir = flags.queryDir
                                , generateMocks = flags.generateMocks
                                }
                        , usages = canAST.usages
                        }

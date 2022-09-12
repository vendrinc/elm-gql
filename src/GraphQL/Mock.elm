module GraphQL.Mock exposing (Schema, mock, schemaFromString)

{-| -}

import GraphQL.Engine exposing (..)
import GraphQL.Operations.Canonicalize as Canonicalize
import GraphQL.Operations.Mock as Mock
import GraphQL.Operations.Parse as Parse
import GraphQL.Schema
import Json.Decode
import Json.Encode


{-| -}
type Schema
    = Schema String


type alias Error =
    { title : String
    , description : String
    }


{-| -}
schemaFromString : String -> Schema
schemaFromString =
    Schema


{-| Given a premade query or mutation, return an auto-mocked, json-stringified version of what the query is expecting
-}
mock : Schema -> Premade value -> Result Error String
mock (Schema schemaStr) premade =
    case Json.Decode.decodeString GraphQL.Schema.decoder schemaStr of
        Ok schema ->
            case Parse.parse (GraphQL.Engine.getGql premade) of
                Err err ->
                    Err
                        { title = "Malformed query"
                        , description =
                            Parse.errorToString err
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
                            case Mock.generate canAST of
                                Ok [] ->
                                    Err
                                        { title = "No named queries present"
                                        , description =
                                            "Can't generate data if there are no queries"
                                        }

                                Ok (op :: _) ->
                                    -- this throws away everything but the first named operation
                                    -- But ultimately there should be only one named operation
                                    Ok
                                        (op.body
                                            |> Json.Encode.encode 4
                                        )

                                Err mockError ->
                                    Err
                                        { title = "Errors"
                                        , description =
                                            "Issue generating mocked data"
                                        }

        Err errors ->
            Err
                { title = "Error decoding schema"
                , description =
                    "Rerun elm-gql"
                }

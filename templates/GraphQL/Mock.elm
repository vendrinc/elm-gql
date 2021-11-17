module GraphQL.Mock exposing (Schema, schemaFromString, query)

{-|-}

import GraphQL.Engine exposing (..)
import GraphQL.Operations.Mock as Mock
import GraphQL.Operations.Canonicalize as Canonicalize
import GraphQL.Operations.Parse as Parse
import GraphQL.Schema

{-|-}
type Schema =
    Schema String

type alias Error =
    { title : String 
    , description : String
    }

{-|-}
schemaFromString : String -> Schema
schemaFromString =
    Schema


{-|  Given a premade query or mutation, return an auto-mocked, json-stringified version of what the query is expecting -}
mock : Schema -> Premade value -> Result Error String
mock (Schema schemaStr) premade =
    case Json.Decode.decodeString GraphQL.Schema.decoder schemaStr of
        Ok schema ->
            case Parse.parse gql.src of
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
                                Ok val ->
                                    Ok
                                        (Json.Encode.object
                                            (List.map (\item -> ( item.name, item.body )) val)
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
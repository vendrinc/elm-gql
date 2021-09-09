module Generate.Paged exposing (generate)

{-|

    This is for generating some helpers around pagination automatically.

    This is based off of the `Relay` spec: https://relay.dev/docs/guides/graphql-server-specification/

-}

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Json
import Elm.Pattern
import Generate.Args as Args exposing (Wrapped(..))
import Generate.Common as Common
import GraphQL.Schema
import GraphQL.Schema.Field as Field exposing (Field)
import GraphQL.Schema.Object
import GraphQL.Schema.Operation
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String
import Utils.String


generate : String -> GraphQL.Schema.Schema -> List Elm.File
generate namespace schema =
    let
        {- We're looking for
           1. any query that results in a selection with a `Connection` usffix
           2. To gather that `Connection`
           3. To also gather a related `Edge`

        -}
        paginations =
            detectPagination schema
    in
    []


type alias Pagination =
    { query : GraphQL.Schema.Operation.Operation
    , edges : GraphQL.Schema.Object.Object
    , connection : GraphQL.Schema.Object.Object
    }


detectPagination : GraphQL.Schema.Schema -> List Pagination
detectPagination schema =
    let
        objs =
            schema.objects
                |> Dict.toList
    in
    schema.queries
        |> Dict.toList
        |> List.filterMap
            (\( name, oper ) ->
                case oper.type_ of
                    GraphQL.Schema.Type.Object objName ->
                        if String.endsWith "Connection" objName then
                            let
                                maybeConnection =
                                    findObjectNamed objName objs
                            in
                            case maybeConnection of
                                Nothing ->
                                    Nothing

                                Just connection ->
                                    let
                                        maybeEdgeName =
                                            List.filterMap
                                                (\field ->
                                                    if field.name == "edges" then
                                                        Just (GraphQL.Schema.Type.toString field.type_)

                                                    else
                                                        Nothing
                                                )
                                                connection.fields
                                                |> List.head

                                        maybeEdge =
                                            case maybeEdgeName of
                                                Nothing ->
                                                    Nothing

                                                Just edgeName ->
                                                    findObjectNamed edgeName objs
                                    in
                                    case maybeEdge of
                                        Nothing ->
                                            Nothing

                                        Just edge ->
                                            Just
                                                { query = oper
                                                , edges = edge
                                                , connection = connection
                                                }

                        else
                            Nothing

                    _ ->
                        Nothing
            )


findObjectNamed : String -> List ( String, GraphQL.Schema.Object.Object ) -> Maybe GraphQL.Schema.Object.Object
findObjectNamed name objects =
    case objects of
        [] ->
            Nothing

        ( topName, obj ) :: remain ->
            if topName == name then
                Just obj

            else
                findObjectNamed name remain

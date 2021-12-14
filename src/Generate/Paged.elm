module Generate.Paged exposing (generate)

{-|

    This is for generating some helpers around pagination automatically.

    This is based off of the `Relay` spec: https://relay.dev/docs/guides/graphql-server-specification/

-}

import Dict
import Elm
import GraphQL.Schema


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
    { query : GraphQL.Schema.Operation
    , edges : GraphQL.Schema.ObjectDetails
    , connection : GraphQL.Schema.ObjectDetails
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
                    GraphQL.Schema.Object objName ->
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
                                                        Just (GraphQL.Schema.typeToElmString field.type_)

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


findObjectNamed : String -> List ( String, GraphQL.Schema.ObjectDetails ) -> Maybe GraphQL.Schema.ObjectDetails
findObjectNamed name objects =
    case objects of
        [] ->
            Nothing

        ( topName, obj ) :: remain ->
            if topName == name then
                Just obj

            else
                findObjectNamed name remain

module Engine exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Gql.Engine
import Json.Decode as Json
import Test exposing (..)


suite : Test
suite =
    describe "Gql"
        [ --aliases
          -- ,
          arguments
        ]


aliases =
    let
        field : Gql.Engine.Query String
        field =
            Gql.Engine.field "test" Json.string
    in
    describe "Generating Gql.Engine aliases"
        [ test "Two fields that are map2'ed will auto-alias" <|
            \_ ->
                let
                    query =
                        Gql.Engine.map2 (++) field field
                in
                Expect.equal "wut is it?" (Gql.Engine.queryString query)
        , test "Three fields that are map2'ed will auto-alias" <|
            \_ ->
                let
                    first =
                        Gql.Engine.map2 (++) field field

                    query =
                        Gql.Engine.map2 (++) first field
                in
                Expect.equal "wut is it?"
                    (Gql.Engine.queryString query)
        , test "Order in map2 doesn't affect aliasing" <|
            \_ ->
                let
                    first =
                        Gql.Engine.map2 (++) field field

                    query =
                        Gql.Engine.map2 (++) field first
                in
                Expect.equal "wut is it?"
                    (Gql.Engine.queryString query)
        ]


arguments =
    describe "Auto-variablize arguments"
        [ test "Two fields that are map2'ed will auto-alias" <|
            \_ ->
                let
                    field =
                        Gql.Engine.fieldWith [ ( "arg", Gql.Engine.stringArg "My argument" ) ] "test" Json.string

                    query =
                        Gql.Engine.map2 (++) field field
                in
                Expect.equal "wut is it?" (Gql.Engine.queryString query)
        ]

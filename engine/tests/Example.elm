module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Gql
import Test exposing (..)


field : Gql.Query String
field =
    Gql.stringField "test"


suite : Test
suite =
    describe "Generating GQL aliases"
        [ test "Two fields that are map2'ed will auto-alias" <|
            \_ ->
                let
                    query =
                        Gql.map2 (++) field field
                in
                Expect.equal "wut is it?" (Gql.queryString query)
        , test "Three fields that are map2'ed will auto-alias" <|
            \_ ->
                let
                    first =
                        Gql.map2 (++) field field

                    query =
                        Gql.map2 (++) first field
                in
                Expect.equal "wut is it?"
                    (Gql.queryString query)
        , test "Order in map2 doesn't affect aliasing" <|
            \_ ->
                let
                    first =
                        Gql.map2 (++) field field

                    query =
                        Gql.map2 (++) field first
                in
                Expect.equal "wut is it?"
                    (Gql.queryString query)
        ]

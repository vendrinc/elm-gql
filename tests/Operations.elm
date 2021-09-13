module Operations exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import GraphQL.Operations.AST as AST
import GraphQL.Operations.Parse as Parse
import Test exposing (..)


queries =
    { simple =
        """query {
  organization {
    isActive
    domain
    teams {
      name
    }
  }
}

        """
    }


suite : Test
suite =
    describe "Operational GQL"
        [ test "Parse a query" <|
            \_ ->
                let
                    parsed =
                        Parse.parse queries.simple
                            |> Debug.log "PARSED?"
                in
                Expect.equal
                    parsed
                    parsed
        ]

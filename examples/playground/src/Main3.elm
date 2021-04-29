module Main3 exposing (main)

import FQL as GQL
import GQL.Person.Friends
import Html exposing (Html)


main : Html msg
main =
    Html.text "Yes"


type alias Person =
    { name : Name
    , email : Maybe String
    , friends : List Friend
    }


type alias Name =
    { first : String
    , last : String
    }


type alias Friend =
    { id : GQL.ID
    , name : Name
    }


query : GQL.Query (Maybe Person)
query =
    GQL.queries.person person
        { id = GQL.id "12345"
        }


person : GQL.Person Person
person =
    GQL.person Person
        |> GQL.withNested name .name
        |> GQL.with .email
        |> GQL.withNestedArgs .friends
            friend
            {}
            [ GQL.Person.Friends.limit (Just 10)
            ]


friend : GQL.Person Friend
friend =
    GQL.friend Friend
        |> GQL.with .id
        |> GQL.with .name


name : GQL.Name Name
name =
    GQL.name Name
        |> GQL.with .first
        |> GQL.with .last

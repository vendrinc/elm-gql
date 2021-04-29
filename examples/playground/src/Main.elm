module Main exposing (main)

import GQL
import GQL.Person.Friends
import Html exposing (Html)


main : Html msg
main =
    Html.text "Yes"


type alias Person =
    { id : GQL.ID
    , name : Name
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
    GQL.select.person Person
        |> GQL.person.id
        |> GQL.person.name name
        |> GQL.person.email
        |> GQL.person.friends friend
            [ GQL.Person.Friends.limit (Just 10)
            ]


friend : GQL.Person Friend
friend =
    GQL.select.person Friend
        |> GQL.person.id
        |> GQL.person.name name


name : GQL.Name Name
name =
    GQL.select.name Name
        |> GQL.name.first
        |> GQL.name.last

module Main2 exposing (main)

import GQL.Person.Friends
import HQL as GQL
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
    GQL.select Person
        |> GQL.field GQL.person.id
        |> GQL.field (GQL.person.name name)
        |> GQL.field GQL.person.email
        |> GQL.field
            (GQL.person.friends friend
                [ GQL.Person.Friends.limit (Just 10)
                ]
            )


friend : GQL.Person Friend
friend =
    GQL.select Friend
        |> GQL.field GQL.person.id
        |> GQL.field (GQL.person.name name)


name : GQL.Name Name
name =
    GQL.select Name
        |> GQL.field GQL.name.first
        |> GQL.field GQL.name.last

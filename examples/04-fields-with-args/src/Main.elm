module Main exposing (main)

import GQL
import GQL.User.Friends
import Html exposing (Html)
import Json.Encode


userQuery : GQL.Query (Maybe User)
userQuery =
    GQL.query.user user
        { id = GQL.id "123"
        }


type alias User =
    { name : Name
    , friends : List Friend
    }


user : GQL.User User
user =
    GQL.user User
        |> GQL.nested .name name
        |> GQL.field .friends
            friend
            {}
            [ GQL.User.Friends.limit (Just 5)
            ]


type alias Name =
    { first : String
    , last : String
    }


name : GQL.Name Name
name =
    GQL.name Name
        |> GQL.with .first
        |> GQL.with .last


type alias Friend =
    { id : GQL.ID
    , name : Name
    }


friend : GQL.User Friend
friend =
    GQL.user Friend
        |> GQL.with .id
        |> GQL.nested .name name


main : Html msg
main =
    let
        input =
            GQL.test.input userQuery |> Json.Encode.encode 0

        output =
            """ { "name": { "first": "Ryan", "last": "Haskell-Glatz" }, "friends": [] } """
                |> GQL.test.output userQuery
                |> Debug.toString
    in
    Html.div []
        [ Html.p []
            [ Html.div [] [ Html.text input ]
            , Html.div [] [ Html.text output ]
            ]
        ]

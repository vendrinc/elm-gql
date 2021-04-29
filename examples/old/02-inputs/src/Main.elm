module Main exposing (main)

import GQL
import Html exposing (Html)
import Json.Encode


type alias User =
    { name : String
    , email : Maybe String
    }


userQuery : GQL.Query (Maybe User)
userQuery =
    GQL.query.user user
        { id = GQL.id "123"
        }


usersQuery : GQL.Query (List User)
usersQuery =
    GQL.query.users.create user
        [ GQL.query.users.sort (Just GQL.ASC)
        ]


user : GQL.User User
user =
    GQL.user User
        |> GQL.with .name
        |> GQL.with .email


main : Html msg
main =
    let
        input =
            GQL.test.input userQuery |> Json.Encode.encode 0

        output =
            """ { "id": "123", "name": "Ryan Haskell-Glatz", "email": null } """
                |> GQL.test.output userQuery
                |> Debug.toString

        input2 =
            GQL.test.input usersQuery |> Json.Encode.encode 0

        output2 =
            """[ { "id": "123", "name": "Ryan Haskell-Glatz", "email": null } ]"""
                |> GQL.test.output usersQuery
                |> Debug.toString
    in
    Html.div []
        [ Html.p []
            [ Html.div [] [ Html.text input ]
            , Html.div [] [ Html.text output ]
            ]
        , Html.p []
            [ Html.div [] [ Html.text input2 ]
            , Html.div [] [ Html.text output2 ]
            ]
        ]

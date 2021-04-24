module Main exposing (main)

import GQL
import Html exposing (Html)
import Json.Encode


userQuery : GQL.Query (Maybe User)
userQuery =
    GQL.query.user user
        { id = GQL.id "123"
        }


type alias User =
    { name : Name
    , email : Maybe String
    }


user : GQL.User User
user =
    GQL.user User
        |> GQL.nested .name name
        |> GQL.with .email


type alias Name =
    { first : String
    , last : String
    }


name : GQL.Name Name
name =
    GQL.name Name
        |> GQL.with .first
        |> GQL.with .last


main : Html msg
main =
    let
        input =
            GQL.test.input userQuery |> Json.Encode.encode 0

        output =
            """ { "id": "123", "name": { "first": "Ryan", "middle": null, "last": "Haskell-Glatz" }, "email": null } """
                |> GQL.test.output userQuery
                |> Debug.toString
    in
    Html.div []
        [ Html.p []
            [ Html.div [] [ Html.text input ]
            , Html.div [] [ Html.text output ]
            ]
        ]

module Main exposing (main)

import GQL
import Html exposing (Html)


type alias User =
    { name : String
    , email : Maybe String
    }


query : GQL.User User
query =
    GQL.query.user User
        |> GQL.with .name
        |> GQL.with .email


main : Html msg
main =
    GQL.test """ { "id": "123", "name": "Ryan Haskell-Glatz", "email": null } """
        query
        |> Debug.toString
        |> Html.text

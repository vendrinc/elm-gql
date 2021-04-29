module Main exposing (main)

import GQL
import Html exposing (Html)


main : Html msg
main =
    Html.text "Compiled!"


type alias App =
    { id : GQL.ID
    , slug : String
    , name : String
    }


query : GQL.Query (Maybe App)
query =
    GQL.query.app
        { id = GQL.id "123"
        }
        app


app : GQL.App App
app =
    GQL.select App
        |> GQL.with GQL.app.id
        |> GQL.with GQL.app.slug
        |> GQL.with GQL.app.name

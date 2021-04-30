module Main exposing (main)

import GQL
import GQL.Types
import Html exposing (Html)


main : Html msg
main =
    Html.text "Compiled!"


type alias App =
    { id : GQL.Types.ID
    , slug : String
    , name : String
    }


query : GQL.Types.Query (Maybe App)
query =
    GQL.query.app
        { id = GQL.id "123"
        }
        app


app : GQL.Types.App App
app =
    GQL.select App
        |> GQL.with GQL.app.id
        |> GQL.with GQL.app.slug
        |> GQL.with GQL.app.name

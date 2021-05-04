module Main exposing (main)

import TnGql.Queries.App
import TnGql.Object.App
import Html exposing (Html)


main : Html msg
main =
    Html.text "Compiled!"


type alias App =
    { id : GQL.ID
    , slug : String
    , name : String
    }

appQuery : GQL.Query (Maybe App)
appQuery =
    TnGql.Queries.App.app
        { id = GQL.id "123"
        }
        app


app : TnGql.Object.App App
app =
    Tn.select App
        |> GQL.with GQL.app.id
        |> GQL.with GQL.app.slug
        |> GQL.with GQL.app.name


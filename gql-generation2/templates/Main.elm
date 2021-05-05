module Main exposing (main)

import TnGql.Queries.App
import TnGql.Object.App
import Html exposing (Html)
import GraphQL.Engine as GQL
import TnGql.Object

main : Html msg
main =
    Html.text "Compiled!"


type alias App =
    { slug : String
    , name : String
    }

appQuery : GQL.Selection GQL.Query App
appQuery =
    TnGql.Queries.App.app
        { slug = Just "blissfully"
        , id = Nothing
        }
        app


app : GQL.Selection  TnGql.Object.App App
app =
    GQL.select App
        |> GQL.with TnGql.Object.App.app.slug
        |> GQL.with TnGql.Object.App.app.name


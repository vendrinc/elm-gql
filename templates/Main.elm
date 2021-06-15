module Main exposing (main)

import Browser
import GraphQL.Engine as GQL
import Html exposing (Html)
import Http
import TnG.Object
import TnG.Object.App
import TnG.Queries.App
import TnG.Unions


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- INIT


type alias Model =
    { result : Maybe (Result Http.Error App)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { result = Nothing }
    , GQL.query appQuery
        { url = "https://api.blissfully.com/prod/graphql"
        , headers =
            [ Http.header "Authorization" "nice try, aaron"
            ]
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map GotStuff
    )



-- MSG


type Msg
    = GotStuff (Result Http.Error App)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotStuff result ->
            ( { model | result = Just result }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    Html.text (Debug.toString model)



--


type alias App =
    { slug : String
    , name : String
    }


appQuery : GQL.Selection GQL.Query App
appQuery =
    TnG.Queries.App.app
        [ TnG.Queries.App.appOptions.slug (Just "blissfully")
        ]
        app


app : GQL.Selection TnG.Object.App App
app =
    GQL.select App
        |> GQL.with TnG.Object.App.app.slug
        |> GQL.with TnG.Object.App.app.name

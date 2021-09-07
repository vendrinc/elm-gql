module Main exposing (main)

import Browser
import Html exposing (Html)
import Http
import TnG
import TnG.Input
import TnG.Mutations.UpdateLicense
import TnG.Queries.App
import TnG.Unions
import GraphQL.Engine as GQL exposing (Error)


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
    { result : Maybe (Result GQL.Error App)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { result = Nothing }
    , TnG.query appQuery
        { name = Nothing
        , url = "https://api.blissfully.com/prod/graphql"
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
    = GotStuff (Result GQL.Error App)


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


appQuery : TnG.Query App
appQuery =
    TnG.Queries.App.app
        [ TnG.Queries.App.slug "blissfully"
        ]
        app


app : TnG.App App
app =
    TnG.select App
        |> TnG.with TnG.app.slug
        |> TnG.with TnG.app.name

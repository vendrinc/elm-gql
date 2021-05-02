module Main exposing (main)

import GQL
import GQL.PersonCreateInput
import GQL.PersonUpdateInput
import GQL.SetOptionalString
import Html exposing (Html)


main : Html msg
main =
    Html.text "Compiled!"


type alias App =
    { id : GQL.ID
    , slug : String
    , name : String
    }


type alias Person =
    { id : GQL.ID
    , name : String
    , email : Maybe String
    }


appQuery : GQL.Query (Maybe App)
appQuery =
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


createMutation : GQL.Mutation (Result String Person)
createMutation =
    GQL.mutation.personCreate
        { input =
            GQL.personCreateInput { name = "Ryan Haskell-Glatz" }
                [ GQL.PersonCreateInput.email Nothing
                ]
        }
        personCreateResult


personCreateResult : GQL.PersonCreateResult (Result String Person)
personCreateResult =
    GQL.personCreateResult
        { person = GQL.map Ok person
        , nameAlreadyExistsError = GQL.map Err GQL.nameAlreadyExistsError.message
        }


person : GQL.Person Person
person =
    GQL.select Person
        |> GQL.with GQL.person.id
        |> GQL.with GQL.person.name
        |> GQL.with GQL.person.email



-- UPDATE


updateMutation : GQL.Mutation (Result String Person)
updateMutation =
    GQL.mutation.personUpdate
        { input =
            GQL.personUpdateInput { id = GQL.id "1234" }
                [ GQL.PersonUpdateInput.name
                    (Just (GQL.setRequiredString { value = "Aaron White" }))
                , GQL.PersonUpdateInput.email
                    (Just
                        (GQL.setOptionalString
                            [ GQL.SetOptionalString.value (Just "aaron@blissfully.com")
                            ]
                        )
                    )
                ]
        }
        personUpdateResult


personUpdateResult : GQL.PersonUpdateResult (Result String Person)
personUpdateResult =
    GQL.personUpdateResult
        { person = GQL.map Ok person
        , notFoundError = GQL.map Err GQL.notFoundError.message
        }

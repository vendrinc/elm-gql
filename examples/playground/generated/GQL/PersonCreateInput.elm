module GQL.PersonCreateInput exposing (Optional, email)

import GraphQL.Engine


type alias Optional =
    GraphQL.Engine.Optional PersonCreateInput


type PersonCreateInput
    = PersonCreateInput Never


email : Maybe String -> Optional
email =
    Debug.todo "email"

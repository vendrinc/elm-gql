module GQL.PersonUpdateInput exposing (Optional, email, name)

import GraphQL.Engine


type alias Optional =
    GraphQL.Engine.Optional PersonUpdateInput


type PersonUpdateInput
    = PersonUpdateInput Never


name : Maybe String -> Optional
name =
    Debug.todo "name"


email : Maybe String -> Optional
email =
    Debug.todo "email"

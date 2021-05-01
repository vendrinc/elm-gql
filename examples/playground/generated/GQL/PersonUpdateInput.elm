module GQL.PersonUpdateInput exposing (Optional, email, name)

import GQL.Types
import GraphQL.Engine


type alias Optional =
    GraphQL.Engine.Optional PersonUpdateInput


type PersonUpdateInput
    = PersonUpdateInput Never


name : Maybe GQL.Types.SetRequiredString -> Optional
name =
    Debug.todo "name"


email : Maybe GQL.Types.SetOptionalString -> Optional
email =
    Debug.todo "email"

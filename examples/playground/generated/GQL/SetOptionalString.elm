module GQL.SetOptionalString exposing (Optional, value)

import GraphQL.Engine


type alias Optional =
    GraphQL.Engine.Optional SetOptionalString


type SetOptionalString
    = SetOptionalString Never


value : Maybe String -> Optional
value =
    Debug.todo "value"

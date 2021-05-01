module GQL.Person.Friends exposing (Optional, limit)

import GraphQL.Engine


type alias Optional =
    GraphQL.Engine.Optional Friends


type Friends
    = Friends Never


limit : Maybe Int -> Optional
limit =
    Debug.todo "limit"

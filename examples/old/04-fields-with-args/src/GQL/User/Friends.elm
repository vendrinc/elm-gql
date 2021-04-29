module GQL.User.Friends exposing (Optional, limit)

import GQL.INTERNALS__ as GQL


type alias Optional =
    GQL.Optional GQL.Optional_User_Friends


limit : Maybe Int -> Optional
limit =
    Debug.todo "limit"

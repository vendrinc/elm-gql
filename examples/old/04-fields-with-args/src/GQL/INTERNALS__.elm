module GQL.INTERNALS__ exposing (Optional, Optional_User_Friends, optional)

import Json.Encode as Json


type Optional guard
    = Optional String Json.Value


optional : String -> Json.Value -> Optional guard
optional =
    Optional


type Optional_User_Friends
    = Optional_User_Friends Never

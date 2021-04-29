module GQL.Person.Friends exposing (Optional, limit)


type Optional
    = Optional


limit : Maybe Int -> Optional
limit _ =
    Optional

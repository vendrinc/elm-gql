module GQL.Role exposing (Role(..), list)


type Role
    = ADMIN
    | GUEST


list : List Role
list =
    [ ADMIN
    , GUEST
    ]

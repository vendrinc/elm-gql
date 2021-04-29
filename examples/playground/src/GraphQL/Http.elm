module GraphQL.Http exposing
    ( Operation, get, post, request
    , preview
    , Response(..)
    )

{-|

@docs Operation, get, post, request
@docs preview
@docs Response

-}

import GQL.Internals__ as GQL
import Http


type alias Operation value =
    GQL.Operation value


get :
    { url : String
    , onResponse : Response value -> msg
    , operation : Operation value
    }
    -> Cmd msg
get =
    Debug.todo "get"


post :
    { url : String
    , onResponse : Response value -> msg
    , operation : Operation value
    }
    -> Cmd msg
post =
    Debug.todo "post"


request :
    { url : String
    , onResponse : Response value -> msg
    , operation : Operation value
    , headers : List Http.Header
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Cmd msg
request =
    Debug.todo "request"


type Response value
    = Failure
    | Success value


preview :
    { url : String
    , onResponse : Response value -> msg
    , operation : Operation value
    }
    -> String
preview =
    Debug.todo "preview"

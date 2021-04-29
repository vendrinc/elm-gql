module GraphQL.Engine exposing
    ( Selection, select, with
    , Scalar, scalar
    , field
    )

{-|

@docs Selection, select, with
@docs Scalar, scalar
@docs field

-}

import Json.Decode as Json


type Selection kind value
    = Selection


select : value -> Selection kind value
select =
    Debug.todo "GraphQL.Engine.select"


with : Selection kind field -> Selection kind (field -> value) -> Selection kind value
with =
    Debug.todo "GraphQL.Engine.with"



-- SCALAR


type Scalar kind value
    = Scalar value


scalar : value -> Scalar kind value
scalar =
    Scalar



--- FIELD


field : String -> Json.Decoder value -> Selection kind value
field =
    Debug.todo "field"

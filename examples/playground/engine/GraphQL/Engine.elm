module GraphQL.Engine exposing
    ( Selection, select, with
    , Scalar, scalar
    , field
    , Input, Mutation, Optional, Query, enum
    )

{-|

@docs Selection, select, with
@docs Scalar, scalar
@docs field

-}

import Json.Decode as Json


type Selection kind value
    = Selection


type Query
    = Query


type Mutation
    = Mutation


type Input kind
    = Input


type Optional kind
    = Optional


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



-- ENUM


enum : List ( String, enum ) -> Json.Decoder enum
enum =
    Debug.todo ""



--- FIELD


field : String -> Json.Decoder value -> Selection kind value
field =
    Debug.todo "field"

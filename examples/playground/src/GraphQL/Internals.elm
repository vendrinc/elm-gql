module GraphQL.Internals exposing
    ( Selection, selection
    , Field, field
    , Scalar, scalar
    , Operation, operation
    )

{-|

@docs Selection, selection
@docs Field, field
@docs Scalar, scalar
@docs Operation, operation

-}

import Json.Decode as Json


type Selection value
    = Selection
        { decoder : Json.Decoder value
        }


selection : value -> Selection value
selection value =
    Selection { decoder = Json.succeed value }



-- FIELD


type Field value
    = Field
        { name : String
        , decoder : Json.Decoder value
        , inputs : List ( String, Json.Value )
        }


field : String -> Json.Decoder value -> List ( String, Json.Value ) -> Field value
field name decoder inputs =
    Field
        { name = name
        , decoder = decoder
        , inputs = inputs
        }



-- SCALAR


type Scalar value
    = Scalar value


scalar :
    { fromValue : value -> Scalar value
    , toValue : Scalar value -> value
    }
scalar =
    { fromValue = Scalar
    , toValue = \(Scalar value) -> value
    }



-- OPERATIONS


type Operation value
    = Operation
        { name : String
        , decoder : Json.Decoder value
        , inputs : List ( String, Json.Value )
        }


operation : String -> Json.Decoder value -> List ( String, Json.Value ) -> Operation value
operation name decoder inputs =
    Operation
        { name = name
        , decoder = decoder
        , inputs = inputs
        }

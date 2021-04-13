module GQL exposing
    ( test
    , with
    , query
    , User
    )

{-|


## Selecting data

@docs run, test
@docs with


## Objects

@docs Query, query
@docs User, user

-}

import Http
import Json.Decode as Json



-- SCALARS


type ID
    = ID String



-- OBJECT TYPES


type alias User value =
    Selection
        { id : Field ID
        , name : Field String
        , email : Field (Maybe String)
        }
        value



-- QUERIES


type alias Query a value =
    Selection a value


query :
    { user : value -> User value
    }
query =
    { user =
        define.query
            { id = fields.id "id"
            , name = fields.string "name"
            , email = fields.maybe.string "email"
            }
    }



-- INTERNALS


type Selection selecting value
    = Selection selecting (Json.Decoder value)


type Field value
    = Field (Json.Decoder value)


fields :
    { string : String -> Field String
    , id : String -> Field ID
    , maybe :
        { string : String -> Field (Maybe String)
        }
    }
fields =
    { string = \field -> Field (Json.field field Json.string)
    , id = \field -> Field (Json.field field (Json.map ID Json.string))
    , maybe =
        { string = \field -> Field (Json.field field (Json.maybe Json.string))
        }
    }


with : (a -> Field b) -> Query a (b -> value) -> Query a value
with fn (Selection x selection) =
    let
        (Field decoder) =
            fn x
    in
    Selection x (selection |> Json.andThen (\y -> Json.map y decoder))


define :
    { query : selecting -> value -> Query selecting value
    }
define =
    { query =
        \selecting value ->
            Selection selecting (Json.succeed value)
    }


type Top_Level
    = Top_Level Never


run : (Result Http.Error value -> msg) -> Query a value -> Cmd msg
run toMsg (Selection _ value) =
    Debug.todo ""


test : String -> Query a value -> Result Json.Error value
test jsonString (Selection _ decoder) =
    Json.decodeString decoder jsonString

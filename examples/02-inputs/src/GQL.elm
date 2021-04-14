module GQL exposing
    ( test
    , with
    , Query, query
    , User, user
    , Direction(..), ID, direction, id
    )

{-|


## Selecting data

@docs run, test
@docs with


## Objects

@docs Query, query
@docs User, user

-}

import Json.Decode as Json
import Json.Encode as Encode



-- SCALARS


type alias ID =
    Scalar String ID_


type ID_
    = ID_ Never


id : String -> ID
id =
    Scalar



-- OBJECT TYPES


type alias User value =
    Selection
        { id : Field ID
        , name : Field String
        , email : Field (Maybe String)
        }
        value


user : value -> User value
user value =
    Selection
        { id = fields.id "id"
        , name = fields.string "name"
        , email = fields.maybe.string "email"
        }
        Encode.null
        (Json.succeed value)



-- ENUMS


type Direction
    = ASC
    | DESC


direction :
    { all : List Direction
    , toString : Direction -> String
    }
direction =
    { all = [ ASC, DESC ]
    , toString = Debug.toString
    }



-- QUERIES


query :
    { user : User value -> { id : ID } -> Query (Maybe value)
    , users :
        { create : User value -> List Optional -> Query (List value)
        , sort : Maybe Direction -> Optional
        }
    }
query =
    { user =
        define.query.withRequiredInputs Json.maybe
            (\req ->
                [ ( "id", Encode.string (scalar req.id) )
                ]
            )
    , users =
        { create = define.query.withOptionalInputs Json.list
        , sort = optionals.enum "sort" direction.toString
        }
    }



-- INTERNALS


type Optional
    = Optional String Json.Value


optionals :
    { string : String -> Maybe String -> Optional
    , enum : String -> (value -> String) -> Maybe value -> Optional
    }
optionals =
    { string =
        \label ->
            Maybe.map Encode.string
                >> Maybe.withDefault Encode.null
                >> Optional label
    , enum =
        \label toString ->
            Maybe.map (toString >> Encode.string)
                >> Maybe.withDefault Encode.null
                >> Optional label
    }


type Selection selecting value
    = Selection selecting Json.Value (Json.Decoder value)


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
    , id = \field -> Field (Json.field field (Json.map Scalar Json.string))
    , maybe =
        { string = \field -> Field (Json.field field (Json.maybe Json.string))
        }
    }


with : (a -> Field b) -> Selection a (b -> value) -> Selection a value
with fn (Selection x json selection) =
    let
        (Field decoder) =
            fn x
    in
    Selection x
        json
        (selection |> Json.andThen (\y -> Json.map y decoder))


type Query value
    = Query Json.Value (Json.Decoder value)


fromOptional (Optional l j) =
    ( l, j )


define =
    { query =
        { withRequiredInputs =
            \wrapper encode (Selection _ _ selection) req ->
                Query (req |> encode |> Encode.object) (wrapper selection)
        , withOptionalInputs =
            \wrapper (Selection _ _ selection) opts ->
                Query (Encode.object (List.map fromOptional opts)) (wrapper selection)

        --  withBothInputs =
        -- \decode selecting encode value req opts ->
        --     Selection selecting (Encode.object (encode req ++ List.map (\(Optional label json) -> ( label, json )) opts)) (Json.succeed value)
        -- , withRequiredInputs =
        --     \decode selecting encode value req ->
        --         Selection selecting (Encode.object (encode req)) (Json.succeed value)
        -- , withoutInputs =
        --     \decode selecting value ->
        --         Selection selecting Encode.null (Json.succeed value)
        }
    }


test :
    { input : Query value -> Json.Value
    , output : Query value -> String -> Result Json.Error value
    }
test =
    { input = \(Query json _) -> json
    , output = \(Query _ decoder) str -> Json.decodeString decoder str
    }


type Scalar value guard
    = Scalar value


scalar : Scalar value any -> value
scalar (Scalar value) =
    value

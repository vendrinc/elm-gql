module GQL exposing
    ( test
    , with, nested, field
    , Query, query
    , User, user
    , Name, name
    , Direction(..), ID, direction, id
    )

{-|


## Selecting data

@docs run, test
@docs with, nested, field


## Objects

@docs Query, query
@docs User, user
@docs Name, name

-}

import GQL.User.Friends
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
    Selection User_ value


type User_
    = User_
        { id : Field ID
        , name : Nested Name_
        , friends : FieldWithArgs User_ {} GQL.User.Friends.Optional
        }


type alias User___ =
    { id : Field ID
    , name : Nested Name_
    }


type alias Name value =
    Selection Name_ value


type Name_
    = Name_
        { first : Field String
        , last : Field String
        }


user : value -> User value
user value =
    Selection user_
        Encode.null
        (Json.succeed value)


user_ : User_
user_ =
    User_
        { id = fields.id "id"
        , name = fields.nested "name"
        , friends = fields.withArgs "friends"
        }


name : value -> Name value
name value =
    Selection name_ Encode.null (Json.succeed value)


name_ : Name_
name_ =
    Name_
        { first = fields.string "first"
        , last = fields.string "last"
        }



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


type Nested field
    = Nested String


type FieldWithArgs selection req opt
    = FieldWithArgs


fields :
    { string : String -> Field String
    , id : String -> Field ID
    , maybe :
        { string : String -> Field (Maybe String)
        }
    , nested : String -> Nested field
    , withArgs : String -> FieldWithArgs selection req opt
    }
fields =
    { string = \field_ -> Field (Json.field field_ Json.string)
    , id = \field_ -> Field (Json.field field_ (Json.map Scalar Json.string))
    , maybe =
        { string = \field_ -> Field (Json.field field_ (Json.maybe Json.string))
        }
    , nested = Nested
    , withArgs = Debug.todo ""
    }


with : (a -> Field b) -> Selection a (b -> value) -> Selection a value
with fn (Selection x json toDecoder) =
    let
        (Field decoder) =
            fn x
    in
    Selection x
        json
        (toDecoder |> Json.andThen (\y -> Json.map y decoder))


nested : (a -> Nested b) -> Selection b c -> Selection a (c -> value) -> Selection a value
nested fn (Selection b nestedJson nestedDecoder) (Selection a json toDecoder) =
    let
        (Nested field_) =
            fn a
    in
    Selection a
        json
        (toDecoder |> Json.andThen (\fromC -> Json.field field_ nestedDecoder |> Json.map fromC))


field : (a -> FieldWithArgs b r o) -> Selection b c -> r -> List o -> Selection a (List c -> value) -> Selection a value
field =
    Debug.todo ""


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

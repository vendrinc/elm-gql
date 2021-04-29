module GQL exposing
    ( with, nested
    , test
    , ID, id
    , Query, query
    , User, user
    , Name, name
    )

{-|


## Selecting data

@docs with, nested
@docs test


## Scalars

@docs ID, id


## Objects

@docs Query, query
@docs User, user
@docs Name, name

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
    Selection User_ User__ value


type User_
    = User_ User__


type alias User__ =
    { id : Field ID
    , name : Nested Name__
    , email : Field (Maybe String)
    }


type alias Name value =
    Selection Name_ Name__ value


type Name_
    = Name_ Name__


type alias Name__ =
    { first : Field String
    , middle : Field (Maybe String)
    , last : Field String
    }


user : value -> User value
user value =
    Selection
        (User_
            { id = fields.simple "id" (Json.map Scalar Json.string)
            , name = fields.nested "name"
            , email = fields.simple "email" (Json.maybe Json.string)
            }
        )
        (\(User_ u) -> u)
        Encode.null
        (Json.succeed value)


name : value -> Name value
name value =
    Selection
        (Name_
            { first = fields.simple "first" Json.string
            , middle = fields.simple "middle" (Json.maybe Json.string)
            , last = fields.simple "last" Json.string
            }
        )
        (\(Name_ u) -> u)
        Encode.null
        (Json.succeed value)



-- QUERIES


query :
    { user : User value -> { id : ID } -> Query (Maybe value)
    }
query =
    { user =
        define.query.withRequiredInputs Json.maybe
            (\req ->
                [ ( "id", Encode.string (scalar req.id) )
                ]
            )
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


type Selection custom record value
    = Selection custom (custom -> record) Json.Value (Json.Decoder value)



-- FIELDS


type FieldWithArgs value req opts guard
    = FieldWithArgs { label : String, decoder : Json.Decoder value, args : List ( String, Json.Value ) }


fields :
    { simple : String -> Json.Decoder value -> Field value
    , nested : String -> Nested field
    }
fields =
    { simple = \label decoder -> FieldWithArgs { label = label, decoder = decoder, args = [] }
    , nested = \label -> FieldWithArgs { label = label, decoder = Json.succeed (), args = [] }
    }


type alias Field value =
    FieldWithArgs value {} Never ()


with : (a -> Field b) -> Selection x a (b -> value) -> Selection x a value
with fn (Selection x fromX json toDecoder) =
    let
        (FieldWithArgs { label, decoder }) =
            fn (fromX x)
    in
    Selection x
        fromX
        json
        (toDecoder |> Json.andThen (\y -> Json.map y (Json.field label decoder)))


type alias Nested guard =
    FieldWithArgs () {} Never guard


nested : (a -> Nested b) -> Selection y b c -> Selection x a (c -> value) -> Selection x a value
nested fn (Selection _ _ _ nestedDecoder) (Selection a fromA json toDecoder) =
    let
        (FieldWithArgs { label }) =
            fn (fromA a)
    in
    Selection a
        fromA
        json
        (toDecoder |> Json.andThen (\fromC -> Json.field label nestedDecoder |> Json.map fromC))



-- QUERIES


type Query value
    = Query Json.Value (Json.Decoder value)


fromOptional (Optional l j) =
    ( l, j )


define =
    { query =
        { withRequiredInputs =
            \wrapper encode (Selection _ _ _ selection) req ->
                Query (req |> encode |> Encode.object) (wrapper selection)
        , withOptionalInputs =
            \wrapper (Selection _ _ _ selection) opts ->
                Query (Encode.object (List.map fromOptional opts)) (wrapper selection)

        -- , withBothInputs =
        --     \decode selecting encode value req opts ->
        --         Selection selecting (Encode.object (encode req ++ List.map (\(Optional label json) -> ( label, json )) opts)) (Json.succeed value)
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

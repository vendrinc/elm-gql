module HQL exposing
    ( Query, queries
    , Selection, select
    , Field, field
    , ID, id
    , Name, name
    , Person, person
    )

{-|

@docs Query, queries

@docs Selection, select
@docs Field, field

@docs ID, id
@docs Name, name
@docs Person, person

-}

import GQL.Person.Friends
import HQL.Internals__ as GQL



-- RESERVED


type Query value
    = Query


queries :
    { person : Person person -> { id : ID } -> Query (Maybe person)
    , people : Person person -> Query (List person)
    }
queries =
    { person = Debug.todo "queries.person"
    , people = Debug.todo "queries.people"
    }


type Selection kind value
    = Selection


select : value -> Selection x value
select =
    Debug.todo ""


type Field kind value
    = Field


field : Field kind field -> Selection kind (field -> value) -> Selection kind value
field =
    Debug.todo ""



-- SCALARS


type ID
    = ID String


id : String -> ID
id =
    ID



-- OBJECTS


type alias Person value =
    Selection GQL.Person value


person :
    { id : Field GQL.Person ID
    , name : Name value -> Field GQL.Person value
    , email : Field GQL.Person (Maybe String)
    , friends : Person person -> List GQL.Person.Friends.Optional -> Field GQL.Person (List person)
    }
person =
    { id = Debug.todo "id"
    , name = Debug.todo "name"
    , email = Debug.todo "email"
    , friends = Debug.todo "friends"
    }



-- OBJECTS


type alias Name value =
    Selection GQL.Name value


name :
    { first : Field GQL.Name String
    , last : Field GQL.Name String
    }
name =
    { first = Debug.todo "first"
    , last = Debug.todo "last"
    }

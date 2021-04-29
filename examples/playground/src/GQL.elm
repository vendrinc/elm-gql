module GQL exposing
    ( Query, queries
    , select
    , Name, name
    , Person, person
    , ID, id
    )

{-|

@docs Query, queries

@docs select

@docs Name, name
@docs Person, person

-}

import GQL.Internals__ as GQL
import GQL.Person.Friends



-- RESERVED


type alias Query value =
    GQL.Operation value


queries :
    { person : Person person -> { id : ID } -> Query (Maybe person)
    , people : Person person -> Query (List person)
    }
queries =
    { person = Debug.todo "queries.person"
    , people = Debug.todo "queries.people"
    }


type Field value
    = Field



-- GENERATED


select :
    { person : value -> Person value
    , name : value -> Name value
    }
select =
    { person = Debug.todo ""
    , name = Debug.todo ""
    }



-- SCALARS


type alias ID =
    GQL.ID


id : String -> ID
id =
    Debug.todo "id"



-- OBJECTS


type alias Person value =
    GQL.Person value


person :
    { id : Person (ID -> value) -> Person value
    , name : Name name -> Person (name -> value) -> Person value
    , email : Person (Maybe String -> value) -> Person value
    , friends : Person person -> List GQL.Person.Friends.Optional -> Person (List person -> value) -> Person value
    }
person =
    { id = Debug.todo "id"
    , name = Debug.todo "name"
    , email = Debug.todo "email"
    , friends = Debug.todo "friends"
    }



-- OBJECTS


type alias Name value =
    GQL.Name value


name :
    { first : Name (String -> value) -> Name value
    , last : Name (String -> value) -> Name value
    }
name =
    { first = Debug.todo "first"
    , last = Debug.todo "last"
    }

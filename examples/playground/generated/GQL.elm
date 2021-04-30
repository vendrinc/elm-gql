module GQL exposing
    ( Selection, select, with
    , query, mutation
    , id, timestamp
    , app, person, name, nameAlreadyExistsError, notFoundError
    , personCreateResult, personUpdateResult
    , personCreateInput, personUpdateInput, setRequiredString, setOptionalString
    )

{-|

@docs Selection, select, with

@docs query, mutation

@docs id, timestamp
@docs app, person, name, nameAlreadyExistsError, notFoundError
@docs personCreateResult, personUpdateResult
@docs personCreateInput, personUpdateInput, setRequiredString, setOptionalString

-}

import GQL.Person.Friends
import GQL.Role
import GQL.Types as GQL
import GraphQL.Engine
import Json.Decode as Json
import Scalar
import Time


type alias Selection kind value =
    GraphQL.Engine.Selection kind value


select : value -> Selection kind value
select =
    GraphQL.Engine.select


with : Selection kind field -> Selection kind (field -> value) -> Selection kind value
with =
    GraphQL.Engine.with



-- SCALAR


id : String -> GQL.ID
id =
    GraphQL.Engine.scalar


timestamp : Time.Posix -> GQL.Timestamp
timestamp =
    GraphQL.Engine.scalar



-- OBJECT


query :
    { app : { id : GQL.ID } -> GQL.App value -> GQL.Query (Maybe value)
    , person : { id : GQL.ID } -> GQL.Person value -> GQL.Query (Maybe value)
    }
query =
    { app = Debug.todo "app"
    , person = Debug.todo "person"
    }


mutation :
    { personCreate : { input : GQL.PersonCreateInput } -> GQL.PersonCreateResult value -> GQL.Mutation value
    , personUpdate : { input : GQL.PersonUpdateInput } -> GQL.PersonUpdateResult value -> GQL.Mutation value
    }
mutation =
    { personCreate = Debug.todo "personCreate"
    , personUpdate = Debug.todo "personUpdate"
    }


app :
    { id : GQL.App GQL.ID
    , slug : GQL.App String
    , name : GQL.App String
    }
app =
    { id = Debug.todo "id"
    , slug = Debug.todo "slug"
    , name = Debug.todo "name"
    }


person :
    { id : GQL.Person GQL.ID
    , name : GQL.Person String
    , role : GQL.Person GQL.Role
    , email : GQL.Person String
    , friends : GQL.Person value -> List GQL.Person.Friends.Optional -> GQL.Person (List friend)
    }
person =
    { id = Debug.todo "id"
    , name = Debug.todo "name"
    , role = role |> Debug.todo "role"
    , email = Debug.todo "slug"
    , friends = Debug.todo "friends"
    }


name :
    { first : GQL.Name String
    , middle : GQL.Name (Maybe String)
    , last : GQL.Name String
    }
name =
    { first = Debug.todo "first"
    , middle = Debug.todo "middle"
    , last = Debug.todo "last"
    }


nameAlreadyExistsError :
    { message : GQL.NameAlreadyExistsError String
    }
nameAlreadyExistsError =
    { message = Debug.todo "message"
    }


notFoundError :
    { id : GQL.NotFoundError GQL.ID
    , message : GQL.NotFoundError String
    }
notFoundError =
    { id = Debug.todo "id"
    , message = Debug.todo "message"
    }



-- ENUM DECODERS


role : Json.Decoder GQL.Role
role =
    GraphQL.Engine.enum
        [ ( "ADMIN", GQL.Role.ADMIN )
        , ( "GUEST", GQL.Role.GUEST )
        ]

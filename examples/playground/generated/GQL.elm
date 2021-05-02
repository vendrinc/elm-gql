module GQL exposing
    ( Selection, select, with
    , map, map2, map3, map4, map5
    , Query, query
    , Mutation, mutation
    , ID, id
    , Timestamp, timestamp
    , App, app
    , Person, person
    , Name, name
    , NameAlreadyExistsError, nameAlreadyExistsError
    , NotFoundError, notFoundError
    , Error, error
    , PersonCreateResult, personCreateResult
    , PersonUpdateResult, personUpdateResult
    , PersonCreateInput, personCreateInput
    , PersonUpdateInput, personUpdateInput
    , SetRequiredString, setRequiredString
    , SetOptionalString, setOptionalString
    )

{-|

@docs Selection, select, with
@docs map, map2, map3, map4, map5


## Operations

@docs Query, query
@docs Mutation, mutation


## Scalars

@docs ID, id
@docs Timestamp, timestamp


## Objects

@docs App, app
@docs Person, person
@docs Name, name
@docs NameAlreadyExistsError, nameAlreadyExistsError
@docs NotFoundError, notFoundError


## Interfaces

@docs Error, error


## Unions

@docs PersonCreateResult, personCreateResult
@docs PersonUpdateResult, personUpdateResult


## Inputs

@docs PersonCreateInput, personCreateInput
@docs PersonUpdateInput, personUpdateInput
@docs SetRequiredString, setRequiredString
@docs SetOptionalString, setOptionalString

-}

import Codec exposing (Codec)
import GQL.Person.Friends
import GQL.PersonCreateInput
import GQL.PersonUpdateInput
import GQL.Role
import GQL.SetOptionalString
import GQL.Types as GQL
import GraphQL.Engine
import Json.Decode as Json
import Json.Encode as Encode
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


map : (a -> b) -> Selection kind a -> Selection kind b
map =
    GraphQL.Engine.map


map2 : (a -> b -> c) -> Selection kind a -> Selection kind b -> Selection kind c
map2 =
    GraphQL.Engine.map2


map3 : (a -> b -> c -> d) -> Selection kind a -> Selection kind b -> Selection kind c -> Selection kind d
map3 =
    GraphQL.Engine.map3


map4 : (a -> b -> c -> d -> e) -> Selection kind a -> Selection kind b -> Selection kind c -> Selection kind d -> Selection kind e
map4 =
    GraphQL.Engine.map4


map5 : (a -> b -> c -> d -> e -> f) -> Selection kind a -> Selection kind b -> Selection kind c -> Selection kind d -> Selection kind e -> Selection kind f
map5 =
    GraphQL.Engine.map5



-- OBJECTS
    

type alias Query value =
    GQL.Query value


query :
    { app : { id : GQL.ID } -> GQL.App value -> GQL.Query (Maybe value)
    , person : { id : GQL.ID } -> GQL.Person value -> GQL.Query (Maybe value)
    }
query =
    { app =
        \req_ selection_ ->
            GraphQL.Engine.query "app"
                Json.maybe
                selection_
                [ ( "id", GraphQL.Engine.args.scalar Scalar.codecs.id req_.id )
                ]
    , person =
        \req_ selection_ ->
            GraphQL.Engine.query "person"
                Json.maybe
                selection_
                [ ( "id", GraphQL.Engine.args.scalar Scalar.codecs.id req_.id )
                ]
    }
    

type alias Mutation value =
    GQL.Mutation value


mutation :
    { personCreate : { input : GQL.PersonCreateInput } -> GQL.PersonCreateResult value -> GQL.Mutation value
    , personUpdate : { input : GQL.PersonUpdateInput } -> GQL.PersonUpdateResult value -> GQL.Mutation value
    }
mutation =
    { personCreate =
        \req_ selection_ ->
            GraphQL.Engine.mutation "personCreate"
                identity
                selection_
                [ ( "input", GraphQL.Engine.args.input req_.input )
                ]
    , personUpdate =
        \req_ selection_ ->
            GraphQL.Engine.mutation "personUpdate"
                identity
                selection_
                [ ( "input", GraphQL.Engine.args.input req_.input )
                ]
    }
    

type alias App value =
    GQL.App value


app :
    { id : GQL.App GQL.ID
    , slug : GQL.App String
    , name : GQL.App String
    }
app =
    { id = GraphQL.Engine.fields.scalar "id" Scalar.codecs.id
    , slug = GraphQL.Engine.fields.primitive "slug" Codec.string
    , name = GraphQL.Engine.fields.primitive "name" Codec.string
    }


type alias Person value =
    GQL.Person value


person :
    { id : GQL.Person GQL.ID
    , name : GQL.Person String
    , role : GQL.Person GQL.Role
    , email : GQL.Person (Maybe String)
    , friends : GQL.Person value -> List GQL.Person.Friends.Optional -> GQL.Person (List value)
    }
person =
    { id = GraphQL.Engine.fields.scalar "id" Scalar.codecs.id
    , name = GraphQL.Engine.fields.primitive "name" Codec.string
    , role = GraphQL.Engine.fields.primitive "role" role
    , email = GraphQL.Engine.fields.primitive "email" (Codec.maybe Codec.string)
    , friends = GraphQL.Engine.fields.nestedWithOptionals "friends" Json.list
    }


type alias Name value =
    GQL.Name value


name :
    { first : GQL.Name String
    , middle : GQL.Name (Maybe String)
    , last : GQL.Name String
    }
name =
    { first = GraphQL.Engine.fields.primitive "first" Codec.string
    , middle = GraphQL.Engine.fields.primitive "middle" (Codec.maybe Codec.string)
    , last = GraphQL.Engine.fields.primitive "last" Codec.string
    }


type alias NameAlreadyExistsError value =
    GQL.NameAlreadyExistsError value


nameAlreadyExistsError :
    { message : GQL.NameAlreadyExistsError String
    }
nameAlreadyExistsError =
    { message = GraphQL.Engine.fields.primitive "message" Codec.string
    }


type alias NotFoundError value =
    GQL.NotFoundError value


notFoundError :
    { id : GQL.NotFoundError GQL.ID
    , message : GQL.NotFoundError String
    }
notFoundError =
    { id = GraphQL.Engine.fields.scalar "id" Scalar.codecs.id
    , message = GraphQL.Engine.fields.primitive "message" Codec.string
    }



-- ENUM DECODERS ( Used internally for fields and inputs )


type alias Role =
    GQL.Role.Role


role : Codec GQL.Role
role =
    GraphQL.Engine.enum
        [ ( "ADMIN", GQL.Role.ADMIN )
        , ( "GUEST", GQL.Role.GUEST )
        ]



-- SCALARS


type alias ID =
    GQL.ID


id : String -> GQL.ID
id =
    GraphQL.Engine.toScalar


type alias Timestamp =
    GQL.Timestamp


timestamp : Time.Posix -> GQL.Timestamp
timestamp =
    GraphQL.Engine.toScalar



-- INTERFACES


type alias Error value =
    GQL.Error value


error :
    { message : GQL.Error String
    }
error =
    { message = GraphQL.Engine.fields.primitive "message" Codec.string
    }



-- UNIONS


type alias PersonCreateResult value =
    GQL.PersonCreateResult value


personCreateResult :
    { person : GQL.Person value
    , nameAlreadyExistsError : GQL.NameAlreadyExistsError value
    }
    -> GQL.PersonCreateResult value
personCreateResult opts_ =
    GraphQL.Engine.union
        [ ( "Person", GraphQL.Engine.fragment opts_.person )
        , ( "NameAlreadyExistsError", GraphQL.Engine.fragment opts_.nameAlreadyExistsError )
        ]


type alias PersonUpdateResult value =
    GQL.PersonUpdateResult value


personUpdateResult :
    { person : GQL.Person value
    , notFoundError : GQL.NotFoundError value
    }
    -> GQL.PersonUpdateResult value
personUpdateResult frags_ =
    GraphQL.Engine.union
        [ ( "Person", GraphQL.Engine.fragment frags_.person )
        , ( "NotFoundError", GraphQL.Engine.fragment frags_.notFoundError )
        ]



-- INPUTS


type alias PersonCreateInput =
    GQL.PersonCreateInput


personCreateInput : { name : String } -> List GQL.PersonCreateInput.Optional -> GQL.PersonCreateInput
personCreateInput req_ =
    GraphQL.Engine.input
        [ ( "name", GraphQL.Engine.args.value (Encode.string req_.name) )
        ]


type alias PersonUpdateInput =
    GQL.PersonUpdateInput


personUpdateInput : { id : GQL.ID } -> List GQL.PersonUpdateInput.Optional -> GQL.PersonUpdateInput
personUpdateInput req_ =
    GraphQL.Engine.input
        [ ( "id", GraphQL.Engine.args.scalar Scalar.codecs.id req_.id )
        ]


type alias SetRequiredString =
    GQL.SetRequiredString


setRequiredString : { value : String } -> GQL.SetRequiredString
setRequiredString req_ =
    GraphQL.Engine.input
        [ ( "value", GraphQL.Engine.args.value (Encode.string req_.value) )
        ]
        []


type alias SetOptionalString =
    GQL.SetOptionalString


setOptionalString : List GQL.SetOptionalString.Optional -> GQL.SetOptionalString
setOptionalString =
    GraphQL.Engine.input []

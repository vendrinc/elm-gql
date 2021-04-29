module GQL exposing
    ( Selection, select, with
    , Query, query
    , ID, id
    , App, app
    )

{-|

@docs Selection, select, with
@docs Query, query

@docs ID, id
@docs App, app

-}

import Blissfully as GQL
import GraphQL.Engine
import Json.Decode as Json
import Scalar


type alias Selection kind value =
    GraphQL.Engine.Selection kind value


select : value -> Selection kind value
select =
    GraphQL.Engine.select


with : Selection kind field -> Selection kind (field -> value) -> Selection kind value
with =
    GraphQL.Engine.with



-- SCALAR


type alias ID =
    GQL.ID


id : String -> ID
id =
    GraphQL.Engine.scalar



-- OBJECT


type alias Query value =
    GQL.Query value


query :
    { app : { id : GQL.ID } -> GQL.App value -> GQL.Query (Maybe value)
    }
query =
    { app = \_ _ -> Debug.todo "hehehe"
    }


type alias App value =
    GQL.App value


app :
    { id : App ID
    , slug : App String
    , name : App String
    }
app =
    { id = GraphQL.Engine.field "id" Scalar.decoders.id
    , slug = GraphQL.Engine.field "slug" Json.string
    , name = GraphQL.Engine.field "name" Json.string
    }

module Blissfully exposing (App, ID, Query)

{-| BECAUSE CIRCULAR DEPENDENCIES
-}

import GraphQL.Engine



-- SCALARS


type alias ID =
    GraphQL.Engine.Scalar ID_ String


type ID_
    = ID_ Never



-- OBJECTS


type alias Query value =
    GraphQL.Engine.Selection Query_ value


type Query_
    = Query_ Never


type alias App value =
    GraphQL.Engine.Selection App_ value


type App_
    = App_ Never

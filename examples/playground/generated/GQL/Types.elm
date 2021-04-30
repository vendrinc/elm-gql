module GQL.Types exposing
    ( Query, Mutation
    , App, Person, Name, NameAlreadyExistsError, NotFoundError
    , Role
    , ID, Timestamp
    , Error
    , PersonCreateResult, PersonUpdateResult
    , PersonCreateInput, PersonUpdateInput, SetRequiredString, SetOptionalString
    )

{-|

@docs Query, Mutation

@docs App, Person, Name, NameAlreadyExistsError, NotFoundError

@docs Role

@docs ID, Timestamp

@docs Error

@docs PersonCreateResult, PersonUpdateResult

@docs PersonCreateInput, PersonUpdateInput, SetRequiredString, SetOptionalString

-}

import GQL.Role
import GraphQL.Engine
import Time



-- SCALARS


type alias ID =
    GraphQL.Engine.Scalar ID_ String


type ID_
    = ID_ Never


type alias Timestamp =
    GraphQL.Engine.Scalar Timestamp_ Time.Posix


type Timestamp_
    = Timestamp_ Never



-- OBJECTS


type alias Query value =
    GraphQL.Engine.Selection GraphQL.Engine.Query value


type alias Mutation value =
    GraphQL.Engine.Selection GraphQL.Engine.Mutation value


type alias App value =
    GraphQL.Engine.Selection App_ value


type App_
    = App_ Never


type alias Person value =
    GraphQL.Engine.Selection Person_ value


type Person_
    = Person_ Never


type alias Name value =
    GraphQL.Engine.Selection Name_ value


type Name_
    = Name_ Never


type alias NameAlreadyExistsError value =
    GraphQL.Engine.Selection NameAlreadyExistsError_ value


type NameAlreadyExistsError_
    = NameAlreadyExistsError_ Never


type alias NotFoundError value =
    GraphQL.Engine.Selection NotFoundError_ value


type NotFoundError_
    = NotFoundError_ Never


type alias PersonCreateResult value =
    GraphQL.Engine.Selection PersonCreateResult_ value


type PersonCreateResult_
    = PersonCreateResult_ Never


type alias PersonUpdateResult value =
    GraphQL.Engine.Selection PersonUpdateResult_ value


type PersonUpdateResult_
    = PersonUpdateResult_ Never


type alias Error value =
    GraphQL.Engine.Selection Error_ value


type Error_
    = Error_ Never


type alias PersonCreateInput =
    GraphQL.Engine.Input PersonCreateInput_


type PersonCreateInput_
    = PersonCreateInput_ Never


type alias PersonUpdateInput =
    GraphQL.Engine.Input PersonUpdateInput_


type PersonUpdateInput_
    = PersonUpdateInput_ Never


type alias SetRequiredString =
    GraphQL.Engine.Input SetRequiredString_


type SetRequiredString_
    = SetRequiredString_ Never


type alias SetOptionalString =
    GraphQL.Engine.Input SetOptionalString_


type SetOptionalString_
    = SetOptionalString_ Never


type alias Role =
    GQL.Role.Role

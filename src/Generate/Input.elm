module Generate.Input exposing (..)

{-|

Some helpers to handle inputs types.

-}

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Decode
import Elm.Gen.Json.Encode as Encode
import Elm.Gen.List
import Elm.Gen.Maybe
import Elm.Pattern
import Generate.Common
import GraphQL.Schema
import GraphQL.Schema.Argument
import GraphQL.Schema.Field
import GraphQL.Schema.Type exposing (Type(..))
import Set exposing (Set)
import String
import Utils.String


type Operation
    = Query
    | Mutation


operationToString : Operation -> String.String
operationToString op =
    case op of
        Query ->
            "Query"

        Mutation ->
            "Mutation"


type Wrapped
    = UnwrappedValue
    | InList Wrapped
    | InMaybe Wrapped


getWrap : Type -> Wrapped
getWrap type_ =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            InMaybe (getWrap newType)

        GraphQL.Schema.Type.List_ newType ->
            InList (getWrap newType)

        _ ->
            UnwrappedValue



wrapExpression : Wrapped -> Elm.Expression -> Elm.Expression
wrapExpression wrapper exp =
    case wrapper of
        InList inner ->
            Elm.list
                [ wrapExpression inner exp
                ]

        InMaybe inner ->
            Elm.maybe
                (Just (wrapExpression inner exp))

        UnwrappedValue ->
            exp


splitRequired : List { a | type_ : Type } -> ( List { a | type_ : Type }, List { a | type_ : Type } )
splitRequired args =
    List.partition
        (not << isOptional)
        args


isOptional : { a | type_ : Type } -> Bool
isOptional arg =
    case arg.type_ of
        GraphQL.Schema.Type.Nullable _ ->
            True

        _ ->
            False

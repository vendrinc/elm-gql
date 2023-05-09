module Generate.Input exposing (Operation(..), decodeWrapper, splitRequired, wrapElmType, wrapExpression)

{-| Some helpers to handle inputs types.
-}

import Elm
import Elm.Annotation as Type
import Gen.GraphQL.Engine as Engine
import Gen.Json.Decode as Decode
import GraphQL.Schema exposing (Wrapped(..))


type Operation
    = Query
    | Mutation


wrapElmType : Wrapped -> Type.Annotation -> Type.Annotation
wrapElmType wrapper exp =
    case wrapper of
        InList inner ->
            Type.list
                (wrapElmType inner exp)

        InMaybe inner ->
            Type.maybe
                (wrapElmType inner exp)

        UnwrappedValue ->
            exp


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


splitRequired : List { a | type_ : GraphQL.Schema.Type } -> ( List { a | type_ : GraphQL.Schema.Type }, List { a | type_ : GraphQL.Schema.Type } )
splitRequired args =
    List.partition
        (not << isOptional)
        args


isOptional : { a | type_ : GraphQL.Schema.Type } -> Bool
isOptional arg =
    case arg.type_ of
        GraphQL.Schema.Nullable _ ->
            True

        _ ->
            False


decodeWrapper : Wrapped -> Elm.Expression -> Elm.Expression
decodeWrapper wrap exp =
    case wrap of
        UnwrappedValue ->
            exp

        InList inner ->
            Decode.list
                (decodeWrapper inner exp)

        InMaybe inner ->
            Engine.decodeNullable
                (decodeWrapper inner exp)

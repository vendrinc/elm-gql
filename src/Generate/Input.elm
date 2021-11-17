module Generate.Input exposing (..)

{-| Some helpers to handle inputs types.
-}

import Elm
import Elm.Annotation as Type
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Decode
import GraphQL.Operations.AST as Ast
import GraphQL.Schema
import String


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


getWrap : GraphQL.Schema.Type -> Wrapped
getWrap type_ =
    case type_ of
        GraphQL.Schema.Nullable newType ->
            InMaybe (getWrap newType)

        GraphQL.Schema.List_ newType ->
            InList (getWrap newType)

        _ ->
            UnwrappedValue


gqlType : Wrapped -> String -> String
gqlType wrapped base =
    case wrapped of
        UnwrappedValue ->
            base ++ "!"

        InList inner ->
            "[" ++ gqlType inner base ++ "]"

        InMaybe inner ->
            gqlTypeHelper inner base


gqlTypeHelper : Wrapped -> String -> String
gqlTypeHelper wrapped base =
    case wrapped of
        UnwrappedValue ->
            base

        InList inner ->
            "[" ++ gqlTypeHelper inner base ++ "]"

        InMaybe inner ->
            gqlTypeHelper inner base


getWrapFromAst : Ast.Type -> Wrapped
getWrapFromAst type_ =
    case type_ of
        Ast.Type_ name ->
            UnwrappedValue

        Ast.List_ inner ->
            InList (getWrapFromAst inner)

        Ast.Nullable inner ->
            InMaybe (getWrapFromAst inner)


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

module Generate.Decode exposing (scalar)



import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Json
import Elm.Pattern
import Generate.Common as Common
import Generate.Input as Input exposing (Wrapped(..))
import GraphQL.Schema
import GraphQL.Schema.Object
import GraphQL.Schema.Type exposing (Type(..))
import GraphQL.Schema.Field as Field exposing (Field)
import Utils.String



scalar : String -> Wrapped -> Elm.Expression
scalar scalarName wrapped =
    let
        lowered =
            String.toLower scalarName

        decoder =
            case lowered of
                "string" ->
                    Json.string

                "int" ->
                    Json.int

                "float" ->
                    Json.float


                "boolean" ->
                    Json.bool

                _ ->
                    Elm.valueFrom ( [ "Scalar" ]) (Utils.String.formatValue scalarName)
                        |> Elm.get "decoder"
    in
    decodeWrapper wrapped decoder


decodeWrapper : Wrapped -> Elm.Expression -> Elm.Expression
decodeWrapper wrap exp =
    case wrap of
        UnwrappedValue ->
            exp

        InList inner ->
            Json.list
                (decodeWrapper inner exp)

        InMaybe inner ->
            Engine.decodeNullable
                (decodeWrapper inner exp)

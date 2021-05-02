module GraphQL.Schema.Type exposing
    ( Type(..)
    , decoder
    , toKind
    , toString
    )

import GraphQL.Schema.Kind as Kind exposing (Kind)
import Json.Decode as Json


type Type
    = Scalar String
    | InputObject String
    | Object String
    | Enum String
    | Union String
    | Interface String
    | List_ Type
    | Non_Null Type


decoder : Json.Decoder Type
decoder =
    Json.field "kind" Json.string
        |> Json.andThen fromKind


fromKind : String -> Json.Decoder Type
fromKind kind =
    case kind of
        "SCALAR" ->
            Json.map Scalar nameDecoder

        "INPUT_OBJECT" ->
            Json.map InputObject nameDecoder

        "OBJECT" ->
            Json.map Object nameDecoder

        "ENUM" ->
            Json.map Enum nameDecoder

        "UNION" ->
            Json.map Union nameDecoder

        "INTERFACE" ->
            Json.map Interface nameDecoder

        "LIST" ->
            Json.map List_ (Json.field "ofType" lazyDecoder)

        "NON_NULL" ->
            Json.map Non_Null (Json.field "ofType" lazyDecoder)

        _ ->
            Json.fail ("Unrecognized kind: " ++ kind)


lazyDecoder : Json.Decoder Type
lazyDecoder =
    Json.lazy (\_ -> decoder)


nameDecoder : Json.Decoder String
nameDecoder =
    Json.field "name" Json.string


toString : Type -> String
toString type_ =
    case type_ of
        Scalar name ->
            name

        InputObject name ->
            name

        Object name ->
            name

        Enum name ->
            name

        Union name ->
            name

        Interface name ->
            name

        List_ child ->
            "[" ++ toString child ++ "]"

        Non_Null child ->
            toString child ++ "!"



-- Getting Kind


toKind : Type -> Kind
toKind type_ =
    case type_ of
        Scalar name ->
            Kind.Scalar name

        InputObject name ->
            Kind.InputObject name

        Object name ->
            Kind.Object name

        Enum name ->
            Kind.Enum name

        Union name ->
            Kind.Union name

        Interface name ->
            Kind.Interface name

        List_ child ->
            toKind child

        Non_Null child ->
            toKind child

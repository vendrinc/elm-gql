module GraphQL.Schema.Type exposing
    ( Type(..)
    , decoder
    , toKind
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
    | Nullable Type


decoder : Json.Decoder Type
decoder =
    innerDecoder
        |> Json.map invert


type Inner_Type
    = Inner_Scalar String
    | Inner_InputObject String
    | Inner_Object String
    | Inner_Enum String
    | Inner_Union String
    | Inner_Interface String
    | Inner_List_ Inner_Type
    | Inner_Non_Null Inner_Type


innerDecoder : Json.Decoder Inner_Type
innerDecoder =
    Json.field "kind" Json.string
        |> Json.andThen fromKind


fromKind : String -> Json.Decoder Inner_Type
fromKind kind =
    case kind of
        "SCALAR" ->
            Json.map Inner_Scalar nameDecoder

        "INPUT_OBJECT" ->
            Json.map Inner_InputObject nameDecoder

        "OBJECT" ->
            Json.map Inner_Object nameDecoder

        "ENUM" ->
            Json.map Inner_Enum nameDecoder

        "UNION" ->
            Json.map Inner_Union nameDecoder

        "INTERFACE" ->
            Json.map Inner_Interface nameDecoder

        "LIST" ->
            Json.map Inner_List_ (Json.field "ofType" lazyDecoder)

        "NON_NULL" ->
            Json.map Inner_Non_Null (Json.field "ofType" lazyDecoder)

        _ ->
            Json.fail ("Unrecognized kind: " ++ kind)


lazyDecoder : Json.Decoder Inner_Type
lazyDecoder =
    Json.lazy (\_ -> innerDecoder)


nameDecoder : Json.Decoder String
nameDecoder =
    Json.field "name" Json.string



-- Getting Kind


toKind : Inner_Type -> Kind
toKind type_ =
    case type_ of
        Inner_Scalar name ->
            Kind.Scalar name

        Inner_InputObject name ->
            Kind.InputObject name

        Inner_Object name ->
            Kind.Object name

        Inner_Enum name ->
            Kind.Enum name

        Inner_Union name ->
            Kind.Union name

        Inner_Interface name ->
            Kind.Interface name

        Inner_List_ child ->
            toKind child

        Inner_Non_Null child ->
            toKind child



-- INVERTING NULLABLE TRASH


invert : Inner_Type -> Type
invert =
    invert_ True


invert_ : Bool -> Inner_Type -> Type
invert_ wrappedInNull inner =
    let
        nullable type_ =
            if wrappedInNull then
                Nullable type_

            else
                type_
    in
    case inner of
        Inner_Non_Null inner_ ->
            invert_ False inner_

        Inner_List_ inner_ ->
            nullable (List_ (invert_ True inner_))

        Inner_Scalar value ->
            nullable (Scalar value)

        Inner_InputObject value ->
            nullable (InputObject value)

        Inner_Object value ->
            nullable (Object value)

        Inner_Enum value ->
            nullable (Enum value)

        Inner_Union value ->
            nullable (Union value)

        Inner_Interface value ->
            nullable (Interface value)

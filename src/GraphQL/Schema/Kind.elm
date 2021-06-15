module GraphQL.Schema.Kind exposing
    ( Kind(..)
    , decoder
    , nameOf
    , toString
    )

import Json.Decode as Json


type Kind
    = Object String
    | Scalar String
    | InputObject String
    | Enum String
    | Union String
    | Interface String


kindFromNameAndString : String -> String -> Json.Decoder Kind
kindFromNameAndString name_ kind =
    case kind of
        "OBJECT" ->
            Json.succeed (Object name_)

        "SCALAR" ->
            Json.succeed (Scalar name_)

        "INTERFACE" ->
            Json.succeed (Interface name_)

        "INPUT_OBJECT" ->
            Json.succeed (InputObject name_)

        "ENUM" ->
            Json.succeed (Enum name_)

        "UNION" ->
            Json.succeed (Union name_)

        _ ->
            Json.fail ("Didn't recognize variant kind: " ++ kind)


decoder : Json.Decoder Kind
decoder =
    Json.field "name" Json.string
        |> Json.andThen
            (\n ->
                Json.field "kind" Json.string
                    |> Json.andThen (kindFromNameAndString n)
            )


toString : Kind -> String
toString kind =
    case kind of
        Object name_ ->
            name_

        Scalar name_ ->
            name_

        InputObject name_ ->
            name_

        Enum name_ ->
            name_

        Union name_ ->
            name_

        Interface name_ ->
            name_


nameOf : Kind -> String
nameOf kind =
    case kind of
        Object _ ->
            "Objects"

        Scalar _ ->
            "Scalars"

        InputObject _ ->
            "Input Objects"

        Enum _ ->
            "Enums"

        Union _ ->
            "Unions"

        Interface _ ->
            "Interfaces"

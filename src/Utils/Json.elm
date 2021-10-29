module Utils.Json exposing (apply, filterHidden, nonEmptyString)

import Dict exposing (Dict)
import Json.Decode as Json


apply : Json.Decoder a -> Json.Decoder (a -> b) -> Json.Decoder b
apply =
    Json.map2 (|>)


nonEmptyString : Json.Decoder String
nonEmptyString =
    Json.string
        |> Json.andThen
            (\str ->
                if String.isEmpty (String.trim str) then
                    Json.fail "String was empty."

                else
                    Json.succeed str
            )


filterHidden : Json.Decoder value -> Json.Decoder (Maybe value)
filterHidden decoder_ =
    let
        filterByDirectives : Dict String Json.Value -> Json.Decoder (Maybe value)
        filterByDirectives directives =
            if [ "NoDocs", "Unimplemented" ] |> List.any (\d -> Dict.member d directives) then
                Json.succeed Nothing

            else
                Json.map Just decoder_
    in
    Json.oneOf
        [ Json.field "directives" (Json.dict Json.value)
            |> Json.andThen filterByDirectives
        , Json.map Just decoder_
        ]

module Main exposing (..)

import Json.Decode as Decode exposing (Decoder)

type AppAccessSource
    = GSuite
    | GoogleSAML
    | Okta
    | OneLogin
    | Manual
    | License
    | Integration
    | Microsoft
    | JumpCloud


list : List AppAccessSource
list =
    [ GSuite, GoogleSAML, Okta, OneLogin, Manual, License, Integration, Microsoft, JumpCloud ]

decoder : Decoder AppAccessSource
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "GSuite" ->
                        Decode.succeed GSuite

                    "GoogleSAML" ->
                        Decode.succeed GoogleSAML

                    "Okta" ->
                        Decode.succeed Okta

                    "OneLogin" ->
                        Decode.succeed OneLogin

                    "Manual" ->
                        Decode.succeed Manual

                    "License" ->
                        Decode.succeed License

                    "Integration" ->
                        Decode.succeed Integration

                    "Microsoft" ->
                        Decode.succeed Microsoft

                    "JumpCloud" ->
                        Decode.succeed JumpCloud

                    _ ->
                        Decode.fail ("Invalid AppAccessSource type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )
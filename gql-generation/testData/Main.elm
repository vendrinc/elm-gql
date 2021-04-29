module Main exposing (..)

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

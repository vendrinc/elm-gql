module Utils.String exposing (..)

import String
import String.Extra


{-| Converts a string from the gql to a string format that is amenable to Elm's typesystem.

Generally this means:
1st letter is capitalized
Subsequent letters are capitalized if there is a lowercase letter between it and the first letter.

Sounds weird, but it's the standard for Elm.

Por ejemplo:

    URL -> Url
    ViewID -> ViewId

-}
formatTypename : String -> String
formatTypename name =
    let
        first =
            String.left 1 name

        remaining =
            String.dropLeft 1 name

        body =
            String.foldl
                elmify
                ( False, "" )
                remaining
                |> Tuple.second
    in
    String.toUpper first ++ body



{-
   Same logic as above, but the first letter is lowercase


   |
-}


formatValue : String -> String
formatValue name =
    let
        first =
            String.left 1 name

        remaining =
            String.dropLeft 1 name

        body =
            String.foldl
                elmify
                ( False, "" )
                remaining
                |> Tuple.second
    in
    String.toLower first ++ body


elmify char ( passedLower, gathered ) =
    if Char.isUpper char && passedLower then
        ( Char.isLower char
        , gathered
            ++ String.fromChar char
        )

    else
        ( Char.isLower char
        , gathered
            ++ String.toLower
                (String.fromChar char)
        )

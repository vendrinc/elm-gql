module Gen.Utils.String exposing (call_, formatScalar, formatTypename, formatValue, moduleName_, values_)

{-| 
@docs values_, call_, formatTypename, formatScalar, formatValue, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Utils", "String" ]


{-| {-| Same logic as above, but the first letter is lowercase
-}

formatValue: String -> String
-}
formatValue : String -> Elm.Expression
formatValue formatValueArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "formatValue"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
        )
        [ Elm.string formatValueArg ]


{-| {-| Converts a string from the gql to a string format that is amenable to Elm's typesystem.

Generally this means:
1st letter is capitalized
Subsequent letters are capitalized if there is a lowercase letter between it and the first letter.

Sounds weird, but it's the standard for Elm.

Por ejemplo:

    URL -> Url
    ViewID -> ViewId

-}

formatScalar: String -> String
-}
formatScalar : String -> Elm.Expression
formatScalar formatScalarArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "formatScalar"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
        )
        [ Elm.string formatScalarArg ]


{-| formatTypename: String -> String -}
formatTypename : String -> Elm.Expression
formatTypename formatTypenameArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "formatTypename"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
        )
        [ Elm.string formatTypenameArg ]


call_ :
    { formatValue : Elm.Expression -> Elm.Expression
    , formatScalar : Elm.Expression -> Elm.Expression
    , formatTypename : Elm.Expression -> Elm.Expression
    }
call_ =
    { formatValue =
        \formatValueArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "String" ]
                    , name = "formatValue"
                    , annotation =
                        Just (Type.function [ Type.string ] Type.string)
                    }
                )
                [ formatValueArg ]
    , formatScalar =
        \formatScalarArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "String" ]
                    , name = "formatScalar"
                    , annotation =
                        Just (Type.function [ Type.string ] Type.string)
                    }
                )
                [ formatScalarArg ]
    , formatTypename =
        \formatTypenameArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "String" ]
                    , name = "formatTypename"
                    , annotation =
                        Just (Type.function [ Type.string ] Type.string)
                    }
                )
                [ formatTypenameArg ]
    }


values_ :
    { formatValue : Elm.Expression
    , formatScalar : Elm.Expression
    , formatTypename : Elm.Expression
    }
values_ =
    { formatValue =
        Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "formatValue"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
    , formatScalar =
        Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "formatScalar"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
    , formatTypename =
        Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "formatTypename"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
    }



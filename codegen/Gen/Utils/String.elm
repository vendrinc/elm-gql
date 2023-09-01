module Gen.Utils.String exposing (call_, capitalize, formatJsonFieldName, formatScalar, formatTypename, formatValue, moduleName_, toFilename, values_)

{-| 
@docs moduleName_, formatJsonFieldName, formatValue, formatScalar, formatTypename, capitalize, toFilename, call_, values_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Utils", "String" ]


{-| {-| Same logic as above, but no sanitization
-}

formatJsonFieldName: String -> String
-}
formatJsonFieldName : String -> Elm.Expression
formatJsonFieldName formatJsonFieldNameArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "formatJsonFieldName"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
        )
        [ Elm.string formatJsonFieldNameArg ]


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


{-| capitalize: String -> String -}
capitalize : String -> Elm.Expression
capitalize capitalizeArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "capitalize"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
        )
        [ Elm.string capitalizeArg ]


{-| toFilename: String -> String -}
toFilename : String -> Elm.Expression
toFilename toFilenameArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "toFilename"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
        )
        [ Elm.string toFilenameArg ]


call_ :
    { formatJsonFieldName : Elm.Expression -> Elm.Expression
    , formatValue : Elm.Expression -> Elm.Expression
    , formatScalar : Elm.Expression -> Elm.Expression
    , formatTypename : Elm.Expression -> Elm.Expression
    , capitalize : Elm.Expression -> Elm.Expression
    , toFilename : Elm.Expression -> Elm.Expression
    }
call_ =
    { formatJsonFieldName =
        \formatJsonFieldNameArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "String" ]
                    , name = "formatJsonFieldName"
                    , annotation =
                        Just (Type.function [ Type.string ] Type.string)
                    }
                )
                [ formatJsonFieldNameArg ]
    , formatValue =
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
    , capitalize =
        \capitalizeArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "String" ]
                    , name = "capitalize"
                    , annotation =
                        Just (Type.function [ Type.string ] Type.string)
                    }
                )
                [ capitalizeArg ]
    , toFilename =
        \toFilenameArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "String" ]
                    , name = "toFilename"
                    , annotation =
                        Just (Type.function [ Type.string ] Type.string)
                    }
                )
                [ toFilenameArg ]
    }


values_ :
    { formatJsonFieldName : Elm.Expression
    , formatValue : Elm.Expression
    , formatScalar : Elm.Expression
    , formatTypename : Elm.Expression
    , capitalize : Elm.Expression
    , toFilename : Elm.Expression
    }
values_ =
    { formatJsonFieldName =
        Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "formatJsonFieldName"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
    , formatValue =
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
    , capitalize =
        Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "capitalize"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
    , toFilename =
        Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "toFilename"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
    }
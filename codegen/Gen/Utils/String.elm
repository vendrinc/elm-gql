module Gen.Utils.String exposing (call_, elmify, formatScalar, formatTypename, formatValue, getLeadingUnderscores, getLeadingUnderscoresHelper, moduleName_, sanitize, values_)

{-| 
@docs values_, call_, formatTypename, formatScalar, formatValue, getLeadingUnderscores, getLeadingUnderscoresHelper, elmify, sanitize, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Utils", "String" ]


{-| {-| Note, this should be done in elm-prefab directly!
-}

sanitize: String -> String
-}
sanitize : String -> Elm.Expression
sanitize sanitizeArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "sanitize"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
        )
        [ Elm.string sanitizeArg ]


{-| elmify: Char.Char -> ( Bool, String ) -> ( Bool, String ) -}
elmify : Char.Char -> Elm.Expression -> Elm.Expression
elmify elmifyArg elmifyArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "elmify"
            , annotation =
                Just
                    (Type.function
                        [ Type.char, Type.tuple Type.bool Type.string ]
                        (Type.tuple Type.bool Type.string)
                    )
            }
        )
        [ Elm.char elmifyArg, elmifyArg0 ]


{-| getLeadingUnderscoresHelper: String -> String -> ( String, String ) -}
getLeadingUnderscoresHelper : String -> String -> Elm.Expression
getLeadingUnderscoresHelper getLeadingUnderscoresHelperArg getLeadingUnderscoresHelperArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "getLeadingUnderscoresHelper"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.string ]
                        (Type.tuple Type.string Type.string)
                    )
            }
        )
        [ Elm.string getLeadingUnderscoresHelperArg
        , Elm.string getLeadingUnderscoresHelperArg0
        ]


{-| getLeadingUnderscores: String -> ( String, String ) -}
getLeadingUnderscores : String -> Elm.Expression
getLeadingUnderscores getLeadingUnderscoresArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "getLeadingUnderscores"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.tuple Type.string Type.string)
                    )
            }
        )
        [ Elm.string getLeadingUnderscoresArg ]


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
    { sanitize : Elm.Expression -> Elm.Expression
    , elmify : Elm.Expression -> Elm.Expression -> Elm.Expression
    , getLeadingUnderscoresHelper :
        Elm.Expression -> Elm.Expression -> Elm.Expression
    , getLeadingUnderscores : Elm.Expression -> Elm.Expression
    , formatValue : Elm.Expression -> Elm.Expression
    , formatScalar : Elm.Expression -> Elm.Expression
    , formatTypename : Elm.Expression -> Elm.Expression
    }
call_ =
    { sanitize =
        \sanitizeArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "String" ]
                    , name = "sanitize"
                    , annotation =
                        Just (Type.function [ Type.string ] Type.string)
                    }
                )
                [ sanitizeArg ]
    , elmify =
        \elmifyArg elmifyArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "String" ]
                    , name = "elmify"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.char, Type.tuple Type.bool Type.string ]
                                (Type.tuple Type.bool Type.string)
                            )
                    }
                )
                [ elmifyArg, elmifyArg0 ]
    , getLeadingUnderscoresHelper =
        \getLeadingUnderscoresHelperArg getLeadingUnderscoresHelperArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "String" ]
                    , name = "getLeadingUnderscoresHelper"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string, Type.string ]
                                (Type.tuple Type.string Type.string)
                            )
                    }
                )
                [ getLeadingUnderscoresHelperArg
                , getLeadingUnderscoresHelperArg0
                ]
    , getLeadingUnderscores =
        \getLeadingUnderscoresArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Utils", "String" ]
                    , name = "getLeadingUnderscores"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string ]
                                (Type.tuple Type.string Type.string)
                            )
                    }
                )
                [ getLeadingUnderscoresArg ]
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
    }


values_ :
    { sanitize : Elm.Expression
    , elmify : Elm.Expression
    , getLeadingUnderscoresHelper : Elm.Expression
    , getLeadingUnderscores : Elm.Expression
    , formatValue : Elm.Expression
    , formatScalar : Elm.Expression
    , formatTypename : Elm.Expression
    }
values_ =
    { sanitize =
        Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "sanitize"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
    , elmify =
        Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "elmify"
            , annotation =
                Just
                    (Type.function
                        [ Type.char, Type.tuple Type.bool Type.string ]
                        (Type.tuple Type.bool Type.string)
                    )
            }
    , getLeadingUnderscoresHelper =
        Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "getLeadingUnderscoresHelper"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.string ]
                        (Type.tuple Type.string Type.string)
                    )
            }
    , getLeadingUnderscores =
        Elm.value
            { importFrom = [ "Utils", "String" ]
            , name = "getLeadingUnderscores"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.tuple Type.string Type.string)
                    )
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
    }



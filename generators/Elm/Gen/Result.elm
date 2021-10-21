module Elm.Gen.Result exposing (andThen, fromMaybe, id_, make_, map, map2, map3, map4, map5, mapError, moduleName_, toMaybe, types_, withDefault)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Result" ]


types_ : { result : Type.Annotation -> Type.Annotation -> Type.Annotation }
types_ =
    { result = \arg0 arg1 -> Type.namedWith moduleName_ "Result" [ arg0, arg1 ]
    }


make_ :
    { result :
        { ok : Elm.Expression -> Elm.Expression
        , err : Elm.Expression -> Elm.Expression
        }
    }
make_ =
    { result =
        { ok =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "Ok"
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.var "error", Type.var "value" ]
                        )
                    )
                    [ ar0 ]
        , err =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "Err"
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.var "error", Type.var "value" ]
                        )
                    )
                    [ ar0 ]
        }
    }


{-| Apply a function to a result. If the result is `Ok`, it will be converted.
If the result is an `Err`, the same error value will propagate through.

    map sqrt (Ok 4.0)          == Ok 2.0
    map sqrt (Err "bad input") == Err "bad input"
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "value")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Apply a function if both results are `Ok`. If not, the first `Err` will
propagate through.

    map2 max (Ok 42)   (Ok 13)   == Ok 42
    map2 max (Err "x") (Ok 13)   == Err "x"
    map2 max (Ok 42)   (Err "y") == Err "y"
    map2 max (Err "x") (Err "y") == Err "x"

This can be useful if you have two computations that may fail, and you want
to put them together quickly.
-}
map2 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map2 arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b" ]
                    (Type.var "value")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "b" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-|-}
map3 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map3 arg1 arg2 arg3 arg4 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map3"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c" ]
                    (Type.var "value")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "c" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass, arg2, arg3, arg4 ]


{-|-}
map4 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map4 arg1 arg2 arg3 arg4 arg5 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map4"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c", Type.var "d" ]
                    (Type.var "value")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "c" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "d" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass, arg2, arg3, arg4, arg5 ]


{-|-}
map5 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map5 arg1 arg2 arg3 arg4 arg5 arg6 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map5"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    ]
                    (Type.var "value")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "c" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "d" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "e" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        ]


{-| Chain together a sequence of computations that may fail. It is helpful
to see its definition:

    andThen : (a -> Result e b) -> Result e a -> Result e b
    andThen callback result =
        case result of
          Ok value -> callback value
          Err msg -> Err msg

This means we only continue with the callback if things are going well. For
example, say you need to use (`toInt : String -> Result String Int`) to parse
a month and make sure it is between 1 and 12:

    toValidMonth : Int -> Result String Int
    toValidMonth month =
        if month >= 1 && month <= 12
            then Ok month
            else Err "months must be between 1 and 12"

    toMonth : String -> Result String Int
    toMonth rawString =
        toInt rawString
          |> andThen toValidMonth

    -- toMonth "4" == Ok 4
    -- toMonth "9" == Ok 9
    -- toMonth "a" == Err "cannot parse to an Int"
    -- toMonth "0" == Err "months must be between 1 and 12"

This allows us to come out of a chain of operations with quite a specific error
message. It is often best to create a custom type that explicitly represents
the exact ways your computation may fail. This way it is easy to handle in your
code.
-}
andThen : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
andThen arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "b" ]
                    )
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "b" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| If the result is `Ok` return the value, but if the result is an `Err` then
return a given default value. The following examples try to parse integers.

    Result.withDefault 0 (Ok 123)   == 123
    Result.withDefault 0 (Err "no") == 0
-}
withDefault : Elm.Expression -> Elm.Expression -> Elm.Expression
withDefault arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "withDefault"
            (Type.function
                [ Type.var "a"
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.var "a")
            )
        )
        [ arg1, arg2 ]


{-| Convert to a simpler `Maybe` if the actual error message is not needed or
you need to interact with some code that primarily uses maybes.

    parseInt : String -> Result ParseError Int

    maybeParseInt : String -> Maybe Int
    maybeParseInt string =
        toMaybe (parseInt string)
-}
toMaybe : Elm.Expression -> Elm.Expression
toMaybe arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toMaybe"
            (Type.function
                [ Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.maybe (Type.var "a"))
            )
        )
        [ arg1 ]


{-| Convert from a simple `Maybe` to interact with some code that primarily
uses `Results`.

    parseInt : String -> Maybe Int

    resultParseInt : String -> Result String Int
    resultParseInt string =
        fromMaybe ("error parsing string: " ++ toString string) (parseInt string)
-}
fromMaybe : Elm.Expression -> Elm.Expression -> Elm.Expression
fromMaybe arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromMaybe"
            (Type.function
                [ Type.var "x", Type.maybe (Type.var "a") ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Transform an `Err` value. For example, say the errors we get have too much
information:

    parseInt : String -> Result ParseError Int

    type alias ParseError =
        { message : String
        , code : Int
        , position : (Int,Int)
        }

    mapError .message (parseInt "123") == Ok 123
    mapError .message (parseInt "abc") == Err "char 'a' is not a number"
-}
mapError :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
mapError arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "mapError"
            (Type.function
                [ Type.function [ Type.var "x" ] (Type.var "y")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "y", Type.var "a" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { map : Elm.Expression
    , map2 : Elm.Expression
    , map3 : Elm.Expression
    , map4 : Elm.Expression
    , map5 : Elm.Expression
    , andThen : Elm.Expression
    , withDefault : Elm.Expression
    , toMaybe : Elm.Expression
    , fromMaybe : Elm.Expression
    , mapError : Elm.Expression
    }
id_ =
    { map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "value")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "value" ]
                )
            )
    , map2 =
        Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b" ]
                    (Type.var "value")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "b" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "value" ]
                )
            )
    , map3 =
        Elm.valueWith
            moduleName_
            "map3"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c" ]
                    (Type.var "value")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "c" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "value" ]
                )
            )
    , map4 =
        Elm.valueWith
            moduleName_
            "map4"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c", Type.var "d" ]
                    (Type.var "value")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "c" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "d" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "value" ]
                )
            )
    , map5 =
        Elm.valueWith
            moduleName_
            "map5"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    ]
                    (Type.var "value")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "c" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "d" ]
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "e" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "value" ]
                )
            )
    , andThen =
        Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "b" ]
                    )
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "b" ]
                )
            )
    , withDefault =
        Elm.valueWith
            moduleName_
            "withDefault"
            (Type.function
                [ Type.var "a"
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.var "a")
            )
    , toMaybe =
        Elm.valueWith
            moduleName_
            "toMaybe"
            (Type.function
                [ Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.maybe (Type.var "a"))
            )
    , fromMaybe =
        Elm.valueWith
            moduleName_
            "fromMaybe"
            (Type.function
                [ Type.var "x", Type.maybe (Type.var "a") ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                )
            )
    , mapError =
        Elm.valueWith
            moduleName_
            "mapError"
            (Type.function
                [ Type.function [ Type.var "x" ] (Type.var "y")
                , Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.var "y", Type.var "a" ]
                )
            )
    }



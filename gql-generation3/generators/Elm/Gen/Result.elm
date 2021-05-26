module Elm.Gen.Result exposing (andThen, fromMaybe, id_, map, map2, map3, map4, map5, mapError, moduleName_, toMaybe, withDefault)

import Elm
import Elm.Annotation


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Result" ]


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
    { map = Elm.valueFrom moduleName_ "map"
    , map2 = Elm.valueFrom moduleName_ "map2"
    , map3 = Elm.valueFrom moduleName_ "map3"
    , map4 = Elm.valueFrom moduleName_ "map4"
    , map5 = Elm.valueFrom moduleName_ "map5"
    , andThen = Elm.valueFrom moduleName_ "andThen"
    , withDefault = Elm.valueFrom moduleName_ "withDefault"
    , toMaybe = Elm.valueFrom moduleName_ "toMaybe"
    , fromMaybe = Elm.valueFrom moduleName_ "fromMaybe"
    , mapError = Elm.valueFrom moduleName_ "mapError"
    }


{-| A `Result` is either `Ok` meaning the computation succeeded, or it is an
`Err` meaning that there was some failure.
-}
typeResult :
    { annotation : Elm.Annotation.Annotation
    , ok : Elm.Expression
    , err : Elm.Expression
    }
typeResult =
    { annotation = Elm.Annotation.named moduleName_ "Result"
    , ok = Elm.valueFrom moduleName_ "Ok"
    , err = Elm.valueFrom moduleName_ "Err"
    }


{-| Apply a function to a result. If the result is `Ok`, it will be converted.
If the result is an `Err`, the same error value will propagate through.

    map sqrt (Ok 4.0)          == Ok 2.0
    map sqrt (Err "bad input") == Err "bad input"
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "map") [ arg1 Elm.pass, arg2 ]


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
        (Elm.valueFrom moduleName_ "map2")
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
        (Elm.valueFrom moduleName_ "map3")
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
        (Elm.valueFrom moduleName_ "map4")
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
        (Elm.valueFrom moduleName_ "map5")
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
    Elm.apply (Elm.valueFrom moduleName_ "andThen") [ arg1 Elm.pass, arg2 ]


{-| If the result is `Ok` return the value, but if the result is an `Err` then
return a given default value. The following examples try to parse integers.

    Result.withDefault 0 (Ok 123)   == 123
    Result.withDefault 0 (Err "no") == 0
-}
withDefault : Elm.Expression -> Elm.Expression -> Elm.Expression
withDefault arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "withDefault") [ arg1, arg2 ]


{-| Convert to a simpler `Maybe` if the actual error message is not needed or
you need to interact with some code that primarily uses maybes.

    parseInt : String -> Result ParseError Int

    maybeParseInt : String -> Maybe Int
    maybeParseInt string =
        toMaybe (parseInt string)
-}
toMaybe : Elm.Expression -> Elm.Expression
toMaybe arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "toMaybe") [ arg1 ]


{-| Convert from a simple `Maybe` to interact with some code that primarily
uses `Results`.

    parseInt : String -> Maybe Int

    resultParseInt : String -> Result String Int
    resultParseInt string =
        fromMaybe ("error parsing string: " ++ toString string) (parseInt string)
-}
fromMaybe : Elm.Expression -> Elm.Expression -> Elm.Expression
fromMaybe arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "fromMaybe") [ arg1, arg2 ]


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
    Elm.apply (Elm.valueFrom moduleName_ "mapError") [ arg1 Elm.pass, arg2 ]

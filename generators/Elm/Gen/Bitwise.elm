module Elm.Gen.Bitwise exposing (and, complement, id_, make_, moduleName_, or, shiftLeftBy, shiftRightBy, shiftRightZfBy, types_, xor)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Bitwise" ]


types_ : {}
types_ =
    {}


make_ : {}
make_ =
    {}


{-| Bitwise AND
-}
and : Elm.Expression -> Elm.Expression -> Elm.Expression
and arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "and"
            (Type.function [ Type.int, Type.int ] Type.int)
        )
        [ arg1, arg2 ]


{-| Bitwise OR
-}
or : Elm.Expression -> Elm.Expression -> Elm.Expression
or arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "or"
            (Type.function [ Type.int, Type.int ] Type.int)
        )
        [ arg1, arg2 ]


{-| Bitwise XOR
-}
xor : Elm.Expression -> Elm.Expression -> Elm.Expression
xor arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "xor"
            (Type.function [ Type.int, Type.int ] Type.int)
        )
        [ arg1, arg2 ]


{-| Flip each bit individually, often called bitwise NOT
-}
complement : Elm.Expression -> Elm.Expression
complement arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "complement"
            (Type.function [ Type.int ] Type.int)
        )
        [ arg1 ]


{-| Shift bits to the left by a given offset, filling new bits with zeros.
This can be used to multiply numbers by powers of two.

    shiftLeftBy 1 5 == 10
    shiftLeftBy 5 1 == 32
-}
shiftLeftBy : Elm.Expression -> Elm.Expression -> Elm.Expression
shiftLeftBy arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "shiftLeftBy"
            (Type.function [ Type.int, Type.int ] Type.int)
        )
        [ arg1, arg2 ]


{-| Shift bits to the right by a given offset, filling new bits with
whatever is the topmost bit. This can be used to divide numbers by powers of two.

    shiftRightBy 1  32 == 16
    shiftRightBy 2  32 == 8
    shiftRightBy 1 -32 == -16

This is called an [arithmetic right shift][ars], often written `>>`, and
sometimes called a sign-propagating right shift because it fills empty spots
with copies of the highest bit.

[ars]: https://en.wikipedia.org/wiki/Bitwise_operation#Arithmetic_shift
-}
shiftRightBy : Elm.Expression -> Elm.Expression -> Elm.Expression
shiftRightBy arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "shiftRightBy"
            (Type.function [ Type.int, Type.int ] Type.int)
        )
        [ arg1, arg2 ]


{-| Shift bits to the right by a given offset, filling new bits with zeros.

    shiftRightZfBy 1  32 == 16
    shiftRightZfBy 2  32 == 8
    shiftRightZfBy 1 -32 == 2147483632

This is called an [logical right shift][lrs], often written `>>>`, and
sometimes called a zero-fill right shift because it fills empty spots with
zeros.

[lrs]: https://en.wikipedia.org/wiki/Bitwise_operation#Logical_shift
-}
shiftRightZfBy : Elm.Expression -> Elm.Expression -> Elm.Expression
shiftRightZfBy arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "shiftRightZfBy"
            (Type.function [ Type.int, Type.int ] Type.int)
        )
        [ arg1, arg2 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { and : Elm.Expression
    , or : Elm.Expression
    , xor : Elm.Expression
    , complement : Elm.Expression
    , shiftLeftBy : Elm.Expression
    , shiftRightBy : Elm.Expression
    , shiftRightZfBy : Elm.Expression
    }
id_ =
    { and =
        Elm.valueWith
            moduleName_
            "and"
            (Type.function [ Type.int, Type.int ] Type.int)
    , or =
        Elm.valueWith
            moduleName_
            "or"
            (Type.function [ Type.int, Type.int ] Type.int)
    , xor =
        Elm.valueWith
            moduleName_
            "xor"
            (Type.function [ Type.int, Type.int ] Type.int)
    , complement =
        Elm.valueWith
            moduleName_
            "complement"
            (Type.function [ Type.int ] Type.int)
    , shiftLeftBy =
        Elm.valueWith
            moduleName_
            "shiftLeftBy"
            (Type.function [ Type.int, Type.int ] Type.int)
    , shiftRightBy =
        Elm.valueWith
            moduleName_
            "shiftRightBy"
            (Type.function [ Type.int, Type.int ] Type.int)
    , shiftRightZfBy =
        Elm.valueWith
            moduleName_
            "shiftRightZfBy"
            (Type.function [ Type.int, Type.int ] Type.int)
    }



module Elm.Gen.Char exposing (fromCode, id_, isAlpha, isAlphaNum, isDigit, isHexDigit, isLower, isOctDigit, isUpper, make_, moduleName_, toCode, toLocaleLower, toLocaleUpper, toLower, toUpper, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Char" ]


types_ : { char : Type.Annotation }
types_ =
    { char = Type.named moduleName_ "Char" }


make_ : {}
make_ =
    {}


{-| Detect upper case ASCII characters.

    isUpper 'A' == True
    isUpper 'B' == True
    ...
    isUpper 'Z' == True

    isUpper '0' == False
    isUpper 'a' == False
    isUpper '-' == False
    isUpper 'Σ' == False
-}
isUpper : Elm.Expression -> Elm.Expression
isUpper arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isUpper"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
        )
        [ arg1 ]


{-| Detect lower case ASCII characters.

    isLower 'a' == True
    isLower 'b' == True
    ...
    isLower 'z' == True

    isLower '0' == False
    isLower 'A' == False
    isLower '-' == False
    isLower 'π' == False
-}
isLower : Elm.Expression -> Elm.Expression
isLower arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isLower"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
        )
        [ arg1 ]


{-| Detect upper case and lower case ASCII characters.

    isAlpha 'a' == True
    isAlpha 'b' == True
    isAlpha 'E' == True
    isAlpha 'Y' == True

    isAlpha '0' == False
    isAlpha '-' == False
    isAlpha 'π' == False
-}
isAlpha : Elm.Expression -> Elm.Expression
isAlpha arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isAlpha"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
        )
        [ arg1 ]


{-| Detect upper case and lower case ASCII characters.

    isAlphaNum 'a' == True
    isAlphaNum 'b' == True
    isAlphaNum 'E' == True
    isAlphaNum 'Y' == True
    isAlphaNum '0' == True
    isAlphaNum '7' == True

    isAlphaNum '-' == False
    isAlphaNum 'π' == False
-}
isAlphaNum : Elm.Expression -> Elm.Expression
isAlphaNum arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isAlphaNum"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
        )
        [ arg1 ]


{-| Detect digits `0123456789`

    isDigit '0' == True
    isDigit '1' == True
    ...
    isDigit '9' == True

    isDigit 'a' == False
    isDigit 'b' == False
    isDigit 'A' == False
-}
isDigit : Elm.Expression -> Elm.Expression
isDigit arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isDigit"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
        )
        [ arg1 ]


{-| Detect octal digits `01234567`

    isOctDigit '0' == True
    isOctDigit '1' == True
    ...
    isOctDigit '7' == True

    isOctDigit '8' == False
    isOctDigit 'a' == False
    isOctDigit 'A' == False
-}
isOctDigit : Elm.Expression -> Elm.Expression
isOctDigit arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isOctDigit"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
        )
        [ arg1 ]


{-| Detect hexadecimal digits `0123456789abcdefABCDEF`
-}
isHexDigit : Elm.Expression -> Elm.Expression
isHexDigit arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isHexDigit"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
        )
        [ arg1 ]


{-| Convert to upper case. -}
toUpper : Elm.Expression -> Elm.Expression
toUpper arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toUpper"
            (Type.function
                [ Type.namedWith [ "Char" ] "Char" [] ]
                (Type.namedWith [ "Char" ] "Char" [])
            )
        )
        [ arg1 ]


{-| Convert to lower case. -}
toLower : Elm.Expression -> Elm.Expression
toLower arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toLower"
            (Type.function
                [ Type.namedWith [ "Char" ] "Char" [] ]
                (Type.namedWith [ "Char" ] "Char" [])
            )
        )
        [ arg1 ]


{-| Convert to upper case, according to any locale-specific case mappings. -}
toLocaleUpper : Elm.Expression -> Elm.Expression
toLocaleUpper arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toLocaleUpper"
            (Type.function
                [ Type.namedWith [ "Char" ] "Char" [] ]
                (Type.namedWith [ "Char" ] "Char" [])
            )
        )
        [ arg1 ]


{-| Convert to lower case, according to any locale-specific case mappings. -}
toLocaleLower : Elm.Expression -> Elm.Expression
toLocaleLower arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toLocaleLower"
            (Type.function
                [ Type.namedWith [ "Char" ] "Char" [] ]
                (Type.namedWith [ "Char" ] "Char" [])
            )
        )
        [ arg1 ]


{-| Convert to the corresponding Unicode [code point][cp].

[cp]: https://en.wikipedia.org/wiki/Code_point

    toCode 'A' == 65
    toCode 'B' == 66
    toCode '木' == 0x6728
    toCode '𝌆' == 0x1D306
    toCode '😃' == 0x1F603
-}
toCode : Elm.Expression -> Elm.Expression
toCode arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toCode"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.int)
        )
        [ arg1 ]


{-| Convert a Unicode [code point][cp] to a character.

    fromCode 65      == 'A'
    fromCode 66      == 'B'
    fromCode 0x6728  == '木'
    fromCode 0x1D306 == '𝌆'
    fromCode 0x1F603 == '😃'
    fromCode -1      == '�'

The full range of unicode is from `0` to `0x10FFFF`. With numbers outside that
range, you get [the replacement character][fffd].

[cp]: https://en.wikipedia.org/wiki/Code_point
[fffd]: https://en.wikipedia.org/wiki/Specials_(Unicode_block)#Replacement_character
-}
fromCode : Elm.Expression -> Elm.Expression
fromCode arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromCode"
            (Type.function [ Type.int ] (Type.namedWith [ "Char" ] "Char" []))
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { isUpper : Elm.Expression
    , isLower : Elm.Expression
    , isAlpha : Elm.Expression
    , isAlphaNum : Elm.Expression
    , isDigit : Elm.Expression
    , isOctDigit : Elm.Expression
    , isHexDigit : Elm.Expression
    , toUpper : Elm.Expression
    , toLower : Elm.Expression
    , toLocaleUpper : Elm.Expression
    , toLocaleLower : Elm.Expression
    , toCode : Elm.Expression
    , fromCode : Elm.Expression
    }
id_ =
    { isUpper =
        Elm.valueWith
            moduleName_
            "isUpper"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
    , isLower =
        Elm.valueWith
            moduleName_
            "isLower"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
    , isAlpha =
        Elm.valueWith
            moduleName_
            "isAlpha"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
    , isAlphaNum =
        Elm.valueWith
            moduleName_
            "isAlphaNum"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
    , isDigit =
        Elm.valueWith
            moduleName_
            "isDigit"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
    , isOctDigit =
        Elm.valueWith
            moduleName_
            "isOctDigit"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
    , isHexDigit =
        Elm.valueWith
            moduleName_
            "isHexDigit"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.bool)
    , toUpper =
        Elm.valueWith
            moduleName_
            "toUpper"
            (Type.function
                [ Type.namedWith [ "Char" ] "Char" [] ]
                (Type.namedWith [ "Char" ] "Char" [])
            )
    , toLower =
        Elm.valueWith
            moduleName_
            "toLower"
            (Type.function
                [ Type.namedWith [ "Char" ] "Char" [] ]
                (Type.namedWith [ "Char" ] "Char" [])
            )
    , toLocaleUpper =
        Elm.valueWith
            moduleName_
            "toLocaleUpper"
            (Type.function
                [ Type.namedWith [ "Char" ] "Char" [] ]
                (Type.namedWith [ "Char" ] "Char" [])
            )
    , toLocaleLower =
        Elm.valueWith
            moduleName_
            "toLocaleLower"
            (Type.function
                [ Type.namedWith [ "Char" ] "Char" [] ]
                (Type.namedWith [ "Char" ] "Char" [])
            )
    , toCode =
        Elm.valueWith
            moduleName_
            "toCode"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.int)
    , fromCode =
        Elm.valueWith
            moduleName_
            "fromCode"
            (Type.function [ Type.int ] (Type.namedWith [ "Char" ] "Char" []))
    }



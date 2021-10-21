module Elm.Gen.String exposing (all, any, append, concat, cons, contains, dropLeft, dropRight, endsWith, filter, foldl, foldr, fromChar, fromFloat, fromInt, fromList, id_, indexes, indices, isEmpty, join, left, length, lines, make_, map, moduleName_, pad, padLeft, padRight, repeat, replace, reverse, right, slice, split, startsWith, toFloat, toInt, toList, toLower, toUpper, trim, trimLeft, trimRight, types_, uncons, words)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "String" ]


types_ : { string : Type.Annotation }
types_ =
    { string = Type.named moduleName_ "String" }


make_ : {}
make_ =
    {}


{-| Determine if a string is empty.

    isEmpty "" == True
    isEmpty "the world" == False
-}
isEmpty : Elm.Expression -> Elm.Expression
isEmpty arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isEmpty"
            (Type.function [ Type.string ] Type.bool)
        )
        [ arg1 ]


{-| Get the length of a string.

    length "innumerable" == 11
    length "" == 0

-}
length : Elm.Expression -> Elm.Expression
length arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "length"
            (Type.function [ Type.string ] Type.int)
        )
        [ arg1 ]


{-| Reverse a string.

    reverse "stressed" == "desserts"
-}
reverse : Elm.Expression -> Elm.Expression
reverse arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "reverse"
            (Type.function [ Type.string ] Type.string)
        )
        [ arg1 ]


{-| Repeat a string *n* times.

    repeat 3 "ha" == "hahaha"
-}
repeat : Elm.Expression -> Elm.Expression -> Elm.Expression
repeat arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "repeat"
            (Type.function [ Type.int, Type.string ] Type.string)
        )
        [ arg1, arg2 ]


{-| Replace all occurrences of some substring.

    replace "." "-" "Json.Decode.succeed" == "Json-Decode-succeed"
    replace "," "/" "a,b,c,d,e"           == "a/b/c/d/e"

**Note:** If you need more advanced replacements, check out the
[`elm/parser`][parser] or [`elm/regex`][regex] package.

[parser]: /packages/elm/parser/latest
[regex]: /packages/elm/regex/latest
-}
replace : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
replace arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "replace"
            (Type.function [ Type.string, Type.string, Type.string ] Type.string
            )
        )
        [ arg1, arg2, arg3 ]


{-| Append two strings. You can also use [the `(++)` operator](Basics#++)
to do this.

    append "butter" "fly" == "butterfly"
-}
append : Elm.Expression -> Elm.Expression -> Elm.Expression
append arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "append"
            (Type.function [ Type.string, Type.string ] Type.string)
        )
        [ arg1, arg2 ]


{-| Concatenate many strings into one.

    concat ["never","the","less"] == "nevertheless"
-}
concat : Elm.Expression -> Elm.Expression
concat arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "concat"
            (Type.function [ Type.list Type.string ] Type.string)
        )
        [ arg1 ]


{-| Split a string using a given separator.

    split "," "cat,dog,cow"        == ["cat","dog","cow"]
    split "/" "home/evan/Desktop/" == ["home","evan","Desktop", ""]

-}
split : Elm.Expression -> Elm.Expression -> Elm.Expression
split arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "split"
            (Type.function [ Type.string, Type.string ] (Type.list Type.string))
        )
        [ arg1, arg2 ]


{-| Put many strings together with a given separator.

    join "a" ["H","w","ii","n"]        == "Hawaiian"
    join " " ["cat","dog","cow"]       == "cat dog cow"
    join "/" ["home","evan","Desktop"] == "home/evan/Desktop"
-}
join : Elm.Expression -> Elm.Expression -> Elm.Expression
join arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "join"
            (Type.function [ Type.string, Type.list Type.string ] Type.string)
        )
        [ arg1, arg2 ]


{-| Break a string into words, splitting on chunks of whitespace.

    words "How are \t you? \n Good?" == ["How","are","you?","Good?"]
-}
words : Elm.Expression -> Elm.Expression
words arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "words"
            (Type.function [ Type.string ] (Type.list Type.string))
        )
        [ arg1 ]


{-| Break a string into lines, splitting on newlines.

    lines "How are you?\nGood?" == ["How are you?", "Good?"]
-}
lines : Elm.Expression -> Elm.Expression
lines arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "lines"
            (Type.function [ Type.string ] (Type.list Type.string))
        )
        [ arg1 ]


{-| Take a substring given a start and end index. Negative indexes
are taken starting from the *end* of the list.

    slice  7  9 "snakes on a plane!" == "on"
    slice  0  6 "snakes on a plane!" == "snakes"
    slice  0 -7 "snakes on a plane!" == "snakes on a"
    slice -6 -1 "snakes on a plane!" == "plane"
-}
slice : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
slice arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "slice"
            (Type.function [ Type.int, Type.int, Type.string ] Type.string)
        )
        [ arg1, arg2, arg3 ]


{-| Take *n* characters from the left side of a string.

    left 2 "Mulder" == "Mu"
-}
left : Elm.Expression -> Elm.Expression -> Elm.Expression
left arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "left"
            (Type.function [ Type.int, Type.string ] Type.string)
        )
        [ arg1, arg2 ]


{-| Take *n* characters from the right side of a string.

    right 2 "Scully" == "ly"
-}
right : Elm.Expression -> Elm.Expression -> Elm.Expression
right arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "right"
            (Type.function [ Type.int, Type.string ] Type.string)
        )
        [ arg1, arg2 ]


{-| Drop *n* characters from the left side of a string.

    dropLeft 2 "The Lone Gunmen" == "e Lone Gunmen"
-}
dropLeft : Elm.Expression -> Elm.Expression -> Elm.Expression
dropLeft arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "dropLeft"
            (Type.function [ Type.int, Type.string ] Type.string)
        )
        [ arg1, arg2 ]


{-| Drop *n* characters from the right side of a string.

    dropRight 2 "Cigarette Smoking Man" == "Cigarette Smoking M"
-}
dropRight : Elm.Expression -> Elm.Expression -> Elm.Expression
dropRight arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "dropRight"
            (Type.function [ Type.int, Type.string ] Type.string)
        )
        [ arg1, arg2 ]


{-| See if the second string contains the first one.

    contains "the" "theory" == True
    contains "hat" "theory" == False
    contains "THE" "theory" == False

-}
contains : Elm.Expression -> Elm.Expression -> Elm.Expression
contains arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "contains"
            (Type.function [ Type.string, Type.string ] Type.bool)
        )
        [ arg1, arg2 ]


{-| See if the second string starts with the first one.

    startsWith "the" "theory" == True
    startsWith "ory" "theory" == False
-}
startsWith : Elm.Expression -> Elm.Expression -> Elm.Expression
startsWith arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "startsWith"
            (Type.function [ Type.string, Type.string ] Type.bool)
        )
        [ arg1, arg2 ]


{-| See if the second string ends with the first one.

    endsWith "the" "theory" == False
    endsWith "ory" "theory" == True
-}
endsWith : Elm.Expression -> Elm.Expression -> Elm.Expression
endsWith arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "endsWith"
            (Type.function [ Type.string, Type.string ] Type.bool)
        )
        [ arg1, arg2 ]


{-| Get all of the indexes for a substring in another string.

    indexes "i" "Mississippi"   == [1,4,7,10]
    indexes "ss" "Mississippi"  == [2,5]
    indexes "needle" "haystack" == []
-}
indexes : Elm.Expression -> Elm.Expression -> Elm.Expression
indexes arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "indexes"
            (Type.function [ Type.string, Type.string ] (Type.list Type.int))
        )
        [ arg1, arg2 ]


{-| Alias for `indexes`. -}
indices : Elm.Expression -> Elm.Expression -> Elm.Expression
indices arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "indices"
            (Type.function [ Type.string, Type.string ] (Type.list Type.int))
        )
        [ arg1, arg2 ]


{-| Try to convert a string into an int, failing on improperly formatted strings.

    String.toInt "123" == Just 123
    String.toInt "-42" == Just -42
    String.toInt "3.1" == Nothing
    String.toInt "31a" == Nothing

If you are extracting a number from some raw user input, you will typically
want to use [`Maybe.withDefault`](Maybe#withDefault) to handle bad data:

    Maybe.withDefault 0 (String.toInt "42") == 42
    Maybe.withDefault 0 (String.toInt "ab") == 0
-}
toInt : Elm.Expression -> Elm.Expression
toInt arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toInt"
            (Type.function [ Type.string ] (Type.maybe Type.int))
        )
        [ arg1 ]


{-| Convert an `Int` to a `String`.

    String.fromInt 123 == "123"
    String.fromInt -42 == "-42"

Check out [`Debug.toString`](Debug#toString) to convert *any* value to a string
for debugging purposes.
-}
fromInt : Elm.Expression -> Elm.Expression
fromInt arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromInt"
            (Type.function [ Type.int ] Type.string)
        )
        [ arg1 ]


{-| Try to convert a string into a float, failing on improperly formatted strings.

    String.toFloat "123" == Just 123.0
    String.toFloat "-42" == Just -42.0
    String.toFloat "3.1" == Just 3.1
    String.toFloat "31a" == Nothing

If you are extracting a number from some raw user input, you will typically
want to use [`Maybe.withDefault`](Maybe#withDefault) to handle bad data:

    Maybe.withDefault 0 (String.toFloat "42.5") == 42.5
    Maybe.withDefault 0 (String.toFloat "cats") == 0
-}
toFloat : Elm.Expression -> Elm.Expression
toFloat arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toFloat"
            (Type.function [ Type.string ] (Type.maybe Type.float))
        )
        [ arg1 ]


{-| Convert a `Float` to a `String`.

    String.fromFloat 123 == "123"
    String.fromFloat -42 == "-42"
    String.fromFloat 3.9 == "3.9"

Check out [`Debug.toString`](Debug#toString) to convert *any* value to a string
for debugging purposes.
-}
fromFloat : Elm.Expression -> Elm.Expression
fromFloat arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromFloat"
            (Type.function [ Type.float ] Type.string)
        )
        [ arg1 ]


{-| Create a string from a given character.

    fromChar 'a' == "a"
-}
fromChar : Elm.Expression -> Elm.Expression
fromChar arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromChar"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.string)
        )
        [ arg1 ]


{-| Add a character to the beginning of a string.

    cons 'T' "he truth is out there" == "The truth is out there"
-}
cons : Elm.Expression -> Elm.Expression -> Elm.Expression
cons arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "cons"
            (Type.function
                [ Type.namedWith [ "Char" ] "Char" [], Type.string ]
                Type.string
            )
        )
        [ arg1, arg2 ]


{-| Split a non-empty string into its head and tail. This lets you
pattern match on strings exactly as you would with lists.

    uncons "abc" == Just ('a',"bc")
    uncons ""    == Nothing
-}
uncons : Elm.Expression -> Elm.Expression
uncons arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "uncons"
            (Type.function
                [ Type.string ]
                (Type.maybe
                    (Type.tuple
                        (Type.namedWith [ "Char" ] "Char" [])
                        Type.string
                    )
                )
            )
        )
        [ arg1 ]


{-| Convert a string to a list of characters.

    toList "abc" == ['a','b','c']
    toList "🙈🙉🙊" == ['🙈','🙉','🙊']
-}
toList : Elm.Expression -> Elm.Expression
toList arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toList"
            (Type.function
                [ Type.string ]
                (Type.list (Type.namedWith [ "Char" ] "Char" []))
            )
        )
        [ arg1 ]


{-| Convert a list of characters into a String. Can be useful if you
want to create a string primarily by consing, perhaps for decoding
something.

    fromList ['a','b','c'] == "abc"
    fromList ['🙈','🙉','🙊'] == "🙈🙉🙊"
-}
fromList : Elm.Expression -> Elm.Expression
fromList arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromList"
            (Type.function
                [ Type.list (Type.namedWith [ "Char" ] "Char" []) ]
                Type.string
            )
        )
        [ arg1 ]


{-| Convert a string to all upper case. Useful for case-insensitive comparisons
and VIRTUAL YELLING.

    toUpper "skinner" == "SKINNER"
-}
toUpper : Elm.Expression -> Elm.Expression
toUpper arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toUpper"
            (Type.function [ Type.string ] Type.string)
        )
        [ arg1 ]


{-| Convert a string to all lower case. Useful for case-insensitive comparisons.

    toLower "X-FILES" == "x-files"
-}
toLower : Elm.Expression -> Elm.Expression
toLower arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toLower"
            (Type.function [ Type.string ] Type.string)
        )
        [ arg1 ]


{-| Pad a string on both sides until it has a given length.

    pad 5 ' ' "1"   == "  1  "
    pad 5 ' ' "11"  == "  11 "
    pad 5 ' ' "121" == " 121 "
-}
pad : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
pad arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "pad"
            (Type.function
                [ Type.int, Type.namedWith [ "Char" ] "Char" [], Type.string ]
                Type.string
            )
        )
        [ arg1, arg2, arg3 ]


{-| Pad a string on the left until it has a given length.

    padLeft 5 '.' "1"   == "....1"
    padLeft 5 '.' "11"  == "...11"
    padLeft 5 '.' "121" == "..121"
-}
padLeft : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
padLeft arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "padLeft"
            (Type.function
                [ Type.int, Type.namedWith [ "Char" ] "Char" [], Type.string ]
                Type.string
            )
        )
        [ arg1, arg2, arg3 ]


{-| Pad a string on the right until it has a given length.

    padRight 5 '.' "1"   == "1...."
    padRight 5 '.' "11"  == "11..."
    padRight 5 '.' "121" == "121.."
-}
padRight : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
padRight arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "padRight"
            (Type.function
                [ Type.int, Type.namedWith [ "Char" ] "Char" [], Type.string ]
                Type.string
            )
        )
        [ arg1, arg2, arg3 ]


{-| Get rid of whitespace on both sides of a string.

    trim "  hats  \n" == "hats"
-}
trim : Elm.Expression -> Elm.Expression
trim arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "trim"
            (Type.function [ Type.string ] Type.string)
        )
        [ arg1 ]


{-| Get rid of whitespace on the left of a string.

    trimLeft "  hats  \n" == "hats  \n"
-}
trimLeft : Elm.Expression -> Elm.Expression
trimLeft arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "trimLeft"
            (Type.function [ Type.string ] Type.string)
        )
        [ arg1 ]


{-| Get rid of whitespace on the right of a string.

    trimRight "  hats  \n" == "  hats"
-}
trimRight : Elm.Expression -> Elm.Expression
trimRight arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "trimRight"
            (Type.function [ Type.string ] Type.string)
        )
        [ arg1 ]


{-| Transform every character in a string

    map (\c -> if c == '/' then '.' else c) "a/b/c" == "a.b.c"
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [] ]
                    (Type.namedWith [ "Char" ] "Char" [])
                , Type.string
                ]
                Type.string
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Keep only the characters that pass the test.

    filter isDigit "R2-D2" == "22"
-}
filter : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
filter arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "filter"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [] ]
                    Type.bool
                , Type.string
                ]
                Type.string
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Reduce a string from the left.

    foldl cons "" "time" == "emit"
-}
foldl :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
foldl arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "foldl"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [], Type.var "b" ]
                    (Type.var "b")
                , Type.var "b"
                , Type.string
                ]
                (Type.var "b")
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-| Reduce a string from the right.

    foldr cons "" "time" == "time"
-}
foldr :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
foldr arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "foldr"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [], Type.var "b" ]
                    (Type.var "b")
                , Type.var "b"
                , Type.string
                ]
                (Type.var "b")
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-| Determine whether *any* characters pass the test.

    any isDigit "90210" == True
    any isDigit "R2-D2" == True
    any isDigit "heart" == False
-}
any : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
any arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "any"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [] ]
                    Type.bool
                , Type.string
                ]
                Type.bool
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Determine whether *all* characters pass the test.

    all isDigit "90210" == True
    all isDigit "R2-D2" == False
    all isDigit "heart" == False
-}
all : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
all arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "all"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [] ]
                    Type.bool
                , Type.string
                ]
                Type.bool
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { isEmpty : Elm.Expression
    , length : Elm.Expression
    , reverse : Elm.Expression
    , repeat : Elm.Expression
    , replace : Elm.Expression
    , append : Elm.Expression
    , concat : Elm.Expression
    , split : Elm.Expression
    , join : Elm.Expression
    , words : Elm.Expression
    , lines : Elm.Expression
    , slice : Elm.Expression
    , left : Elm.Expression
    , right : Elm.Expression
    , dropLeft : Elm.Expression
    , dropRight : Elm.Expression
    , contains : Elm.Expression
    , startsWith : Elm.Expression
    , endsWith : Elm.Expression
    , indexes : Elm.Expression
    , indices : Elm.Expression
    , toInt : Elm.Expression
    , fromInt : Elm.Expression
    , toFloat : Elm.Expression
    , fromFloat : Elm.Expression
    , fromChar : Elm.Expression
    , cons : Elm.Expression
    , uncons : Elm.Expression
    , toList : Elm.Expression
    , fromList : Elm.Expression
    , toUpper : Elm.Expression
    , toLower : Elm.Expression
    , pad : Elm.Expression
    , padLeft : Elm.Expression
    , padRight : Elm.Expression
    , trim : Elm.Expression
    , trimLeft : Elm.Expression
    , trimRight : Elm.Expression
    , map : Elm.Expression
    , filter : Elm.Expression
    , foldl : Elm.Expression
    , foldr : Elm.Expression
    , any : Elm.Expression
    , all : Elm.Expression
    }
id_ =
    { isEmpty =
        Elm.valueWith
            moduleName_
            "isEmpty"
            (Type.function [ Type.string ] Type.bool)
    , length =
        Elm.valueWith
            moduleName_
            "length"
            (Type.function [ Type.string ] Type.int)
    , reverse =
        Elm.valueWith
            moduleName_
            "reverse"
            (Type.function [ Type.string ] Type.string)
    , repeat =
        Elm.valueWith
            moduleName_
            "repeat"
            (Type.function [ Type.int, Type.string ] Type.string)
    , replace =
        Elm.valueWith
            moduleName_
            "replace"
            (Type.function [ Type.string, Type.string, Type.string ] Type.string
            )
    , append =
        Elm.valueWith
            moduleName_
            "append"
            (Type.function [ Type.string, Type.string ] Type.string)
    , concat =
        Elm.valueWith
            moduleName_
            "concat"
            (Type.function [ Type.list Type.string ] Type.string)
    , split =
        Elm.valueWith
            moduleName_
            "split"
            (Type.function [ Type.string, Type.string ] (Type.list Type.string))
    , join =
        Elm.valueWith
            moduleName_
            "join"
            (Type.function [ Type.string, Type.list Type.string ] Type.string)
    , words =
        Elm.valueWith
            moduleName_
            "words"
            (Type.function [ Type.string ] (Type.list Type.string))
    , lines =
        Elm.valueWith
            moduleName_
            "lines"
            (Type.function [ Type.string ] (Type.list Type.string))
    , slice =
        Elm.valueWith
            moduleName_
            "slice"
            (Type.function [ Type.int, Type.int, Type.string ] Type.string)
    , left =
        Elm.valueWith
            moduleName_
            "left"
            (Type.function [ Type.int, Type.string ] Type.string)
    , right =
        Elm.valueWith
            moduleName_
            "right"
            (Type.function [ Type.int, Type.string ] Type.string)
    , dropLeft =
        Elm.valueWith
            moduleName_
            "dropLeft"
            (Type.function [ Type.int, Type.string ] Type.string)
    , dropRight =
        Elm.valueWith
            moduleName_
            "dropRight"
            (Type.function [ Type.int, Type.string ] Type.string)
    , contains =
        Elm.valueWith
            moduleName_
            "contains"
            (Type.function [ Type.string, Type.string ] Type.bool)
    , startsWith =
        Elm.valueWith
            moduleName_
            "startsWith"
            (Type.function [ Type.string, Type.string ] Type.bool)
    , endsWith =
        Elm.valueWith
            moduleName_
            "endsWith"
            (Type.function [ Type.string, Type.string ] Type.bool)
    , indexes =
        Elm.valueWith
            moduleName_
            "indexes"
            (Type.function [ Type.string, Type.string ] (Type.list Type.int))
    , indices =
        Elm.valueWith
            moduleName_
            "indices"
            (Type.function [ Type.string, Type.string ] (Type.list Type.int))
    , toInt =
        Elm.valueWith
            moduleName_
            "toInt"
            (Type.function [ Type.string ] (Type.maybe Type.int))
    , fromInt =
        Elm.valueWith
            moduleName_
            "fromInt"
            (Type.function [ Type.int ] Type.string)
    , toFloat =
        Elm.valueWith
            moduleName_
            "toFloat"
            (Type.function [ Type.string ] (Type.maybe Type.float))
    , fromFloat =
        Elm.valueWith
            moduleName_
            "fromFloat"
            (Type.function [ Type.float ] Type.string)
    , fromChar =
        Elm.valueWith
            moduleName_
            "fromChar"
            (Type.function [ Type.namedWith [ "Char" ] "Char" [] ] Type.string)
    , cons =
        Elm.valueWith
            moduleName_
            "cons"
            (Type.function
                [ Type.namedWith [ "Char" ] "Char" [], Type.string ]
                Type.string
            )
    , uncons =
        Elm.valueWith
            moduleName_
            "uncons"
            (Type.function
                [ Type.string ]
                (Type.maybe
                    (Type.tuple
                        (Type.namedWith [ "Char" ] "Char" [])
                        Type.string
                    )
                )
            )
    , toList =
        Elm.valueWith
            moduleName_
            "toList"
            (Type.function
                [ Type.string ]
                (Type.list (Type.namedWith [ "Char" ] "Char" []))
            )
    , fromList =
        Elm.valueWith
            moduleName_
            "fromList"
            (Type.function
                [ Type.list (Type.namedWith [ "Char" ] "Char" []) ]
                Type.string
            )
    , toUpper =
        Elm.valueWith
            moduleName_
            "toUpper"
            (Type.function [ Type.string ] Type.string)
    , toLower =
        Elm.valueWith
            moduleName_
            "toLower"
            (Type.function [ Type.string ] Type.string)
    , pad =
        Elm.valueWith
            moduleName_
            "pad"
            (Type.function
                [ Type.int, Type.namedWith [ "Char" ] "Char" [], Type.string ]
                Type.string
            )
    , padLeft =
        Elm.valueWith
            moduleName_
            "padLeft"
            (Type.function
                [ Type.int, Type.namedWith [ "Char" ] "Char" [], Type.string ]
                Type.string
            )
    , padRight =
        Elm.valueWith
            moduleName_
            "padRight"
            (Type.function
                [ Type.int, Type.namedWith [ "Char" ] "Char" [], Type.string ]
                Type.string
            )
    , trim =
        Elm.valueWith
            moduleName_
            "trim"
            (Type.function [ Type.string ] Type.string)
    , trimLeft =
        Elm.valueWith
            moduleName_
            "trimLeft"
            (Type.function [ Type.string ] Type.string)
    , trimRight =
        Elm.valueWith
            moduleName_
            "trimRight"
            (Type.function [ Type.string ] Type.string)
    , map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [] ]
                    (Type.namedWith [ "Char" ] "Char" [])
                , Type.string
                ]
                Type.string
            )
    , filter =
        Elm.valueWith
            moduleName_
            "filter"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [] ]
                    Type.bool
                , Type.string
                ]
                Type.string
            )
    , foldl =
        Elm.valueWith
            moduleName_
            "foldl"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [], Type.var "b" ]
                    (Type.var "b")
                , Type.var "b"
                , Type.string
                ]
                (Type.var "b")
            )
    , foldr =
        Elm.valueWith
            moduleName_
            "foldr"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [], Type.var "b" ]
                    (Type.var "b")
                , Type.var "b"
                , Type.string
                ]
                (Type.var "b")
            )
    , any =
        Elm.valueWith
            moduleName_
            "any"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [] ]
                    Type.bool
                , Type.string
                ]
                Type.bool
            )
    , all =
        Elm.valueWith
            moduleName_
            "all"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Char" ] "Char" [] ]
                    Type.bool
                , Type.string
                ]
                Type.bool
            )
    }



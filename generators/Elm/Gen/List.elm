module Elm.Gen.List exposing (all, any, append, concat, concatMap, drop, filter, filterMap, foldl, foldr, head, id_, indexedMap, intersperse, isEmpty, length, make_, map, map2, map3, map4, map5, maximum, member, minimum, moduleName_, partition, product, range, repeat, reverse, singleton, sort, sortBy, sortWith, sum, tail, take, types_, unzip)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "List" ]


types_ : {}
types_ =
    {}


make_ : {}
make_ =
    {}


{-| Create a list with only one element:

    singleton 1234 == [1234]
    singleton "hi" == ["hi"]
-}
singleton : Elm.Expression -> Elm.Expression
singleton arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "singleton"
            (Type.function [ Type.var "a" ] (Type.list (Type.var "a")))
        )
        [ arg1 ]


{-| Create a list with *n* copies of a value:

    repeat 3 (0,0) == [(0,0),(0,0),(0,0)]
-}
repeat : Elm.Expression -> Elm.Expression -> Elm.Expression
repeat arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "repeat"
            (Type.function [ Type.int, Type.var "a" ] (Type.list (Type.var "a"))
            )
        )
        [ arg1, arg2 ]


{-| Create a list of numbers, every element increasing by one.
You give the lowest and highest number that should be in the list.

    range 3 6 == [3, 4, 5, 6]
    range 3 3 == [3]
    range 6 3 == []
-}
range : Elm.Expression -> Elm.Expression -> Elm.Expression
range arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "range"
            (Type.function [ Type.int, Type.int ] (Type.list Type.int))
        )
        [ arg1, arg2 ]


{-| Apply a function to every element of a list.

    map sqrt [1,4,9] == [1,2,3]

    map not [True,False,True] == [False,True,False]

So `map func [ a, b, c ]` is the same as `[ func a, func b, func c ]`
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "b"))
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Same as `map` but the function is also applied to the index of each
element (starting at zero).

    indexedMap Tuple.pair ["Tom","Sue","Bob"] == [ (0,"Tom"), (1,"Sue"), (2,"Bob") ]
-}
indexedMap :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
indexedMap arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "indexedMap"
            (Type.function
                [ Type.function [ Type.int, Type.var "a" ] (Type.var "b")
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "b"))
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2 ]


{-| Reduce a list from the left.

    foldl (+)  0  [1,2,3] == 6
    foldl (::) [] [1,2,3] == [3,2,1]

So `foldl step state [1,2,3]` is like saying:

    state
      |> step 1
      |> step 2
      |> step 3
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
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "b")
                , Type.var "b"
                , Type.list (Type.var "a")
                ]
                (Type.var "b")
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-| Reduce a list from the right.

    foldr (+)  0  [1,2,3] == 6
    foldr (::) [] [1,2,3] == [1,2,3]

So `foldr step state [1,2,3]` is like saying:

    state
      |> step 3
      |> step 2
      |> step 1
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
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "b")
                , Type.var "b"
                , Type.list (Type.var "a")
                ]
                (Type.var "b")
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-| Keep elements that satisfy the test.

    filter isEven [1,2,3,4,5,6] == [2,4,6]
-}
filter : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
filter arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "filter"
            (Type.function
                [ Type.function [ Type.var "a" ] Type.bool
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "a"))
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Filter out certain values. For example, maybe you have a bunch of strings
from an untrusted source and you want to turn them into numbers:

    numbers : List Int
    numbers =
      filterMap String.toInt ["3", "hi", "12", "4th", "May"]

    -- numbers == [3, 12]

-}
filterMap :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
filterMap arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "filterMap"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.maybe (Type.var "b"))
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "b"))
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Determine the length of a list.

    length [1,2,3] == 3
-}
length : Elm.Expression -> Elm.Expression
length arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "length"
            (Type.function [ Type.list (Type.var "a") ] Type.int)
        )
        [ arg1 ]


{-| Reverse a list.

    reverse [1,2,3,4] == [4,3,2,1]
-}
reverse : Elm.Expression -> Elm.Expression
reverse arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "reverse"
            (Type.function
                [ Type.list (Type.var "a") ]
                (Type.list (Type.var "a"))
            )
        )
        [ arg1 ]


{-| Figure out whether a list contains a value.

    member 9 [1,2,3,4] == False
    member 4 [1,2,3,4] == True
-}
member : Elm.Expression -> Elm.Expression -> Elm.Expression
member arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "member"
            (Type.function [ Type.var "a", Type.list (Type.var "a") ] Type.bool)
        )
        [ arg1, arg2 ]


{-| Determine if all elements satisfy some test.

    all isEven [2,4] == True
    all isEven [2,3] == False
    all isEven [] == True
-}
all : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
all arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "all"
            (Type.function
                [ Type.function [ Type.var "a" ] Type.bool
                , Type.list (Type.var "a")
                ]
                Type.bool
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Determine if any elements satisfy some test.

    any isEven [2,3] == True
    any isEven [1,3] == False
    any isEven [] == False
-}
any : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
any arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "any"
            (Type.function
                [ Type.function [ Type.var "a" ] Type.bool
                , Type.list (Type.var "a")
                ]
                Type.bool
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Find the maximum element in a non-empty list.

    maximum [1,4,2] == Just 4
    maximum []      == Nothing
-}
maximum : Elm.Expression -> Elm.Expression
maximum arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "maximum"
            (Type.function
                [ Type.list (Type.var "comparable") ]
                (Type.maybe (Type.var "comparable"))
            )
        )
        [ arg1 ]


{-| Find the minimum element in a non-empty list.

    minimum [3,2,1] == Just 1
    minimum []      == Nothing
-}
minimum : Elm.Expression -> Elm.Expression
minimum arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "minimum"
            (Type.function
                [ Type.list (Type.var "comparable") ]
                (Type.maybe (Type.var "comparable"))
            )
        )
        [ arg1 ]


{-| Get the sum of the list elements.

    sum [1,2,3] == 6
    sum [1,1,1] == 3
    sum []      == 0

-}
sum : Elm.Expression -> Elm.Expression
sum arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "sum"
            (Type.function [ Type.list (Type.var "number") ] (Type.var "number")
            )
        )
        [ arg1 ]


{-| Get the product of the list elements.

    product [2,2,2] == 8
    product [3,3,3] == 27
    product []      == 1

-}
product : Elm.Expression -> Elm.Expression
product arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "product"
            (Type.function [ Type.list (Type.var "number") ] (Type.var "number")
            )
        )
        [ arg1 ]


{-| Put two lists together.

    append [1,1,2] [3,5,8] == [1,1,2,3,5,8]
    append ['a','b'] ['c'] == ['a','b','c']

You can also use [the `(++)` operator](Basics#++) to append lists.
-}
append : Elm.Expression -> Elm.Expression -> Elm.Expression
append arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "append"
            (Type.function
                [ Type.list (Type.var "a"), Type.list (Type.var "a") ]
                (Type.list (Type.var "a"))
            )
        )
        [ arg1, arg2 ]


{-| Concatenate a bunch of lists into a single list:

    concat [[1,2],[3],[4,5]] == [1,2,3,4,5]
-}
concat : Elm.Expression -> Elm.Expression
concat arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "concat"
            (Type.function
                [ Type.list (Type.list (Type.var "a")) ]
                (Type.list (Type.var "a"))
            )
        )
        [ arg1 ]


{-| Map a given function onto a list and flatten the resulting lists.

    concatMap f xs == concat (map f xs)
-}
concatMap :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
concatMap arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "concatMap"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.list (Type.var "b"))
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "b"))
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Places the given value between all members of the given list.

    intersperse "on" ["turtles","turtles","turtles"] == ["turtles","on","turtles","on","turtles"]
-}
intersperse : Elm.Expression -> Elm.Expression -> Elm.Expression
intersperse arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "intersperse"
            (Type.function
                [ Type.var "a", Type.list (Type.var "a") ]
                (Type.list (Type.var "a"))
            )
        )
        [ arg1, arg2 ]


{-| Combine two lists, combining them with the given function.
If one list is longer, the extra elements are dropped.

    totals : List Int -> List Int -> List Int
    totals xs ys =
      List.map2 (+) xs ys

    -- totals [1,2,3] [4,5,6] == [5,7,9]

    pairs : List a -> List b -> List (a,b)
    pairs xs ys =
      List.map2 Tuple.pair xs ys

    -- pairs ["alice","bob","chuck"] [2,5,7,8]
    --   == [("alice",2),("bob",5),("chuck",7)]

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
                    (Type.var "result")
                , Type.list (Type.var "a")
                , Type.list (Type.var "b")
                ]
                (Type.list (Type.var "result"))
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
                    (Type.var "result")
                , Type.list (Type.var "a")
                , Type.list (Type.var "b")
                , Type.list (Type.var "c")
                ]
                (Type.list (Type.var "result"))
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
                    (Type.var "result")
                , Type.list (Type.var "a")
                , Type.list (Type.var "b")
                , Type.list (Type.var "c")
                , Type.list (Type.var "d")
                ]
                (Type.list (Type.var "result"))
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
                    (Type.var "result")
                , Type.list (Type.var "a")
                , Type.list (Type.var "b")
                , Type.list (Type.var "c")
                , Type.list (Type.var "d")
                , Type.list (Type.var "e")
                ]
                (Type.list (Type.var "result"))
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        ]


{-| Sort values from lowest to highest

    sort [3,1,5] == [1,3,5]
-}
sort : Elm.Expression -> Elm.Expression
sort arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "sort"
            (Type.function
                [ Type.list (Type.var "comparable") ]
                (Type.list (Type.var "comparable"))
            )
        )
        [ arg1 ]


{-| Sort values by a derived property.

    alice = { name="Alice", height=1.62 }
    bob   = { name="Bob"  , height=1.85 }
    chuck = { name="Chuck", height=1.76 }

    sortBy .name   [chuck,alice,bob] == [alice,bob,chuck]
    sortBy .height [chuck,alice,bob] == [alice,chuck,bob]

    sortBy String.length ["mouse","cat"] == ["cat","mouse"]
-}
sortBy : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
sortBy arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "sortBy"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "comparable")
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "a"))
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Sort values with a custom comparison function.

    sortWith flippedComparison [1,2,3,4,5] == [5,4,3,2,1]

    flippedComparison a b =
        case compare a b of
          LT -> GT
          EQ -> EQ
          GT -> LT

This is also the most general sort function, allowing you
to define any other: `sort == sortWith compare`
-}
sortWith :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
sortWith arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "sortWith"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "a" ]
                    (Type.namedWith [ "Basics" ] "Order" [])
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "a"))
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2 ]


{-| Determine if a list is empty.

    isEmpty [] == True

**Note:** It is usually preferable to use a `case` to test this so you do not
forget to handle the `(x :: xs)` case as well!
-}
isEmpty : Elm.Expression -> Elm.Expression
isEmpty arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isEmpty"
            (Type.function [ Type.list (Type.var "a") ] Type.bool)
        )
        [ arg1 ]


{-| Extract the first element of a list.

    head [1,2,3] == Just 1
    head [] == Nothing

**Note:** It is usually preferable to use a `case` to deconstruct a `List`
because it gives you `(x :: xs)` and you can work with both subparts.
-}
head : Elm.Expression -> Elm.Expression
head arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "head"
            (Type.function
                [ Type.list (Type.var "a") ]
                (Type.maybe (Type.var "a"))
            )
        )
        [ arg1 ]


{-| Extract the rest of the list.

    tail [1,2,3] == Just [2,3]
    tail [] == Nothing

**Note:** It is usually preferable to use a `case` to deconstruct a `List`
because it gives you `(x :: xs)` and you can work with both subparts.
-}
tail : Elm.Expression -> Elm.Expression
tail arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "tail"
            (Type.function
                [ Type.list (Type.var "a") ]
                (Type.maybe (Type.list (Type.var "a")))
            )
        )
        [ arg1 ]


{-| Take the first *n* members of a list.

    take 2 [1,2,3,4] == [1,2]
-}
take : Elm.Expression -> Elm.Expression -> Elm.Expression
take arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "take"
            (Type.function
                [ Type.int, Type.list (Type.var "a") ]
                (Type.list (Type.var "a"))
            )
        )
        [ arg1, arg2 ]


{-| Drop the first *n* members of a list.

    drop 2 [1,2,3,4] == [3,4]
-}
drop : Elm.Expression -> Elm.Expression -> Elm.Expression
drop arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "drop"
            (Type.function
                [ Type.int, Type.list (Type.var "a") ]
                (Type.list (Type.var "a"))
            )
        )
        [ arg1, arg2 ]


{-| Partition a list based on some test. The first list contains all values
that satisfy the test, and the second list contains all the value that do not.

    partition (\x -> x < 3) [0,1,2,3,4,5] == ([0,1,2], [3,4,5])
    partition isEven        [0,1,2,3,4,5] == ([0,2,4], [1,3,5])
-}
partition :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
partition arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "partition"
            (Type.function
                [ Type.function [ Type.var "a" ] Type.bool
                , Type.list (Type.var "a")
                ]
                (Type.tuple
                    (Type.list (Type.var "a"))
                    (Type.list (Type.var "a"))
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Decompose a list of tuples into a tuple of lists.

    unzip [(0, True), (17, False), (1337, True)] == ([0,17,1337], [True,False,True])
-}
unzip : Elm.Expression -> Elm.Expression
unzip arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "unzip"
            (Type.function
                [ Type.list (Type.tuple (Type.var "a") (Type.var "b")) ]
                (Type.tuple
                    (Type.list (Type.var "a"))
                    (Type.list (Type.var "b"))
                )
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { singleton : Elm.Expression
    , repeat : Elm.Expression
    , range : Elm.Expression
    , map : Elm.Expression
    , indexedMap : Elm.Expression
    , foldl : Elm.Expression
    , foldr : Elm.Expression
    , filter : Elm.Expression
    , filterMap : Elm.Expression
    , length : Elm.Expression
    , reverse : Elm.Expression
    , member : Elm.Expression
    , all : Elm.Expression
    , any : Elm.Expression
    , maximum : Elm.Expression
    , minimum : Elm.Expression
    , sum : Elm.Expression
    , product : Elm.Expression
    , append : Elm.Expression
    , concat : Elm.Expression
    , concatMap : Elm.Expression
    , intersperse : Elm.Expression
    , map2 : Elm.Expression
    , map3 : Elm.Expression
    , map4 : Elm.Expression
    , map5 : Elm.Expression
    , sort : Elm.Expression
    , sortBy : Elm.Expression
    , sortWith : Elm.Expression
    , isEmpty : Elm.Expression
    , head : Elm.Expression
    , tail : Elm.Expression
    , take : Elm.Expression
    , drop : Elm.Expression
    , partition : Elm.Expression
    , unzip : Elm.Expression
    }
id_ =
    { singleton =
        Elm.valueWith
            moduleName_
            "singleton"
            (Type.function [ Type.var "a" ] (Type.list (Type.var "a")))
    , repeat =
        Elm.valueWith
            moduleName_
            "repeat"
            (Type.function [ Type.int, Type.var "a" ] (Type.list (Type.var "a"))
            )
    , range =
        Elm.valueWith
            moduleName_
            "range"
            (Type.function [ Type.int, Type.int ] (Type.list Type.int))
    , map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "b"))
            )
    , indexedMap =
        Elm.valueWith
            moduleName_
            "indexedMap"
            (Type.function
                [ Type.function [ Type.int, Type.var "a" ] (Type.var "b")
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "b"))
            )
    , foldl =
        Elm.valueWith
            moduleName_
            "foldl"
            (Type.function
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "b")
                , Type.var "b"
                , Type.list (Type.var "a")
                ]
                (Type.var "b")
            )
    , foldr =
        Elm.valueWith
            moduleName_
            "foldr"
            (Type.function
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "b")
                , Type.var "b"
                , Type.list (Type.var "a")
                ]
                (Type.var "b")
            )
    , filter =
        Elm.valueWith
            moduleName_
            "filter"
            (Type.function
                [ Type.function [ Type.var "a" ] Type.bool
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "a"))
            )
    , filterMap =
        Elm.valueWith
            moduleName_
            "filterMap"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.maybe (Type.var "b"))
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "b"))
            )
    , length =
        Elm.valueWith
            moduleName_
            "length"
            (Type.function [ Type.list (Type.var "a") ] Type.int)
    , reverse =
        Elm.valueWith
            moduleName_
            "reverse"
            (Type.function
                [ Type.list (Type.var "a") ]
                (Type.list (Type.var "a"))
            )
    , member =
        Elm.valueWith
            moduleName_
            "member"
            (Type.function [ Type.var "a", Type.list (Type.var "a") ] Type.bool)
    , all =
        Elm.valueWith
            moduleName_
            "all"
            (Type.function
                [ Type.function [ Type.var "a" ] Type.bool
                , Type.list (Type.var "a")
                ]
                Type.bool
            )
    , any =
        Elm.valueWith
            moduleName_
            "any"
            (Type.function
                [ Type.function [ Type.var "a" ] Type.bool
                , Type.list (Type.var "a")
                ]
                Type.bool
            )
    , maximum =
        Elm.valueWith
            moduleName_
            "maximum"
            (Type.function
                [ Type.list (Type.var "comparable") ]
                (Type.maybe (Type.var "comparable"))
            )
    , minimum =
        Elm.valueWith
            moduleName_
            "minimum"
            (Type.function
                [ Type.list (Type.var "comparable") ]
                (Type.maybe (Type.var "comparable"))
            )
    , sum =
        Elm.valueWith
            moduleName_
            "sum"
            (Type.function [ Type.list (Type.var "number") ] (Type.var "number")
            )
    , product =
        Elm.valueWith
            moduleName_
            "product"
            (Type.function [ Type.list (Type.var "number") ] (Type.var "number")
            )
    , append =
        Elm.valueWith
            moduleName_
            "append"
            (Type.function
                [ Type.list (Type.var "a"), Type.list (Type.var "a") ]
                (Type.list (Type.var "a"))
            )
    , concat =
        Elm.valueWith
            moduleName_
            "concat"
            (Type.function
                [ Type.list (Type.list (Type.var "a")) ]
                (Type.list (Type.var "a"))
            )
    , concatMap =
        Elm.valueWith
            moduleName_
            "concatMap"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.list (Type.var "b"))
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "b"))
            )
    , intersperse =
        Elm.valueWith
            moduleName_
            "intersperse"
            (Type.function
                [ Type.var "a", Type.list (Type.var "a") ]
                (Type.list (Type.var "a"))
            )
    , map2 =
        Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b" ]
                    (Type.var "result")
                , Type.list (Type.var "a")
                , Type.list (Type.var "b")
                ]
                (Type.list (Type.var "result"))
            )
    , map3 =
        Elm.valueWith
            moduleName_
            "map3"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c" ]
                    (Type.var "result")
                , Type.list (Type.var "a")
                , Type.list (Type.var "b")
                , Type.list (Type.var "c")
                ]
                (Type.list (Type.var "result"))
            )
    , map4 =
        Elm.valueWith
            moduleName_
            "map4"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c", Type.var "d" ]
                    (Type.var "result")
                , Type.list (Type.var "a")
                , Type.list (Type.var "b")
                , Type.list (Type.var "c")
                , Type.list (Type.var "d")
                ]
                (Type.list (Type.var "result"))
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
                    (Type.var "result")
                , Type.list (Type.var "a")
                , Type.list (Type.var "b")
                , Type.list (Type.var "c")
                , Type.list (Type.var "d")
                , Type.list (Type.var "e")
                ]
                (Type.list (Type.var "result"))
            )
    , sort =
        Elm.valueWith
            moduleName_
            "sort"
            (Type.function
                [ Type.list (Type.var "comparable") ]
                (Type.list (Type.var "comparable"))
            )
    , sortBy =
        Elm.valueWith
            moduleName_
            "sortBy"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "comparable")
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "a"))
            )
    , sortWith =
        Elm.valueWith
            moduleName_
            "sortWith"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "a" ]
                    (Type.namedWith [ "Basics" ] "Order" [])
                , Type.list (Type.var "a")
                ]
                (Type.list (Type.var "a"))
            )
    , isEmpty =
        Elm.valueWith
            moduleName_
            "isEmpty"
            (Type.function [ Type.list (Type.var "a") ] Type.bool)
    , head =
        Elm.valueWith
            moduleName_
            "head"
            (Type.function
                [ Type.list (Type.var "a") ]
                (Type.maybe (Type.var "a"))
            )
    , tail =
        Elm.valueWith
            moduleName_
            "tail"
            (Type.function
                [ Type.list (Type.var "a") ]
                (Type.maybe (Type.list (Type.var "a")))
            )
    , take =
        Elm.valueWith
            moduleName_
            "take"
            (Type.function
                [ Type.int, Type.list (Type.var "a") ]
                (Type.list (Type.var "a"))
            )
    , drop =
        Elm.valueWith
            moduleName_
            "drop"
            (Type.function
                [ Type.int, Type.list (Type.var "a") ]
                (Type.list (Type.var "a"))
            )
    , partition =
        Elm.valueWith
            moduleName_
            "partition"
            (Type.function
                [ Type.function [ Type.var "a" ] Type.bool
                , Type.list (Type.var "a")
                ]
                (Type.tuple
                    (Type.list (Type.var "a"))
                    (Type.list (Type.var "a"))
                )
            )
    , unzip =
        Elm.valueWith
            moduleName_
            "unzip"
            (Type.function
                [ Type.list (Type.tuple (Type.var "a") (Type.var "b")) ]
                (Type.tuple
                    (Type.list (Type.var "a"))
                    (Type.list (Type.var "b"))
                )
            )
    }



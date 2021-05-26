module Elm.Gen.Array exposing (append, empty, filter, foldl, foldr, fromList, get, id_, indexedMap, initialize, isEmpty, length, map, moduleName_, push, repeat, set, slice, toIndexedList, toList)

import Elm
import Elm.Annotation


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Array" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { empty : Elm.Expression
    , initialize : Elm.Expression
    , repeat : Elm.Expression
    , fromList : Elm.Expression
    , isEmpty : Elm.Expression
    , length : Elm.Expression
    , get : Elm.Expression
    , set : Elm.Expression
    , push : Elm.Expression
    , append : Elm.Expression
    , slice : Elm.Expression
    , toList : Elm.Expression
    , toIndexedList : Elm.Expression
    , map : Elm.Expression
    , indexedMap : Elm.Expression
    , foldl : Elm.Expression
    , foldr : Elm.Expression
    , filter : Elm.Expression
    }
id_ =
    { empty = Elm.valueFrom moduleName_ "empty"
    , initialize = Elm.valueFrom moduleName_ "initialize"
    , repeat = Elm.valueFrom moduleName_ "repeat"
    , fromList = Elm.valueFrom moduleName_ "fromList"
    , isEmpty = Elm.valueFrom moduleName_ "isEmpty"
    , length = Elm.valueFrom moduleName_ "length"
    , get = Elm.valueFrom moduleName_ "get"
    , set = Elm.valueFrom moduleName_ "set"
    , push = Elm.valueFrom moduleName_ "push"
    , append = Elm.valueFrom moduleName_ "append"
    , slice = Elm.valueFrom moduleName_ "slice"
    , toList = Elm.valueFrom moduleName_ "toList"
    , toIndexedList = Elm.valueFrom moduleName_ "toIndexedList"
    , map = Elm.valueFrom moduleName_ "map"
    , indexedMap = Elm.valueFrom moduleName_ "indexedMap"
    , foldl = Elm.valueFrom moduleName_ "foldl"
    , foldr = Elm.valueFrom moduleName_ "foldr"
    , filter = Elm.valueFrom moduleName_ "filter"
    }


{-| Representation of fast immutable arrays. You can create arrays of integers
(`Array Int`) or strings (`Array String`) or any other type of value you can
dream up.
-}
typeArray : { annotation : Elm.Annotation.Annotation }
typeArray =
    { annotation = Elm.Annotation.named moduleName_ "Array" }


{-| Return an empty array.

    length empty == 0
-}
empty : Elm.Expression
empty =
    Elm.valueFrom moduleName_ "empty"


{-| Initialize an array. `initialize n f` creates an array of length `n` with
the element at index `i` initialized to the result of `(f i)`.

    initialize 4 identity    == fromList [0,1,2,3]
    initialize 4 (\n -> n*n) == fromList [0,1,4,9]
    initialize 4 (always 0)  == fromList [0,0,0,0]
-}
initialize :
    Elm.Expression -> (Elm.Expression -> Elm.Expression) -> Elm.Expression
initialize arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "initialize") [ arg1, arg2 Elm.pass ]


{-| Creates an array with a given length, filled with a default element.

    repeat 5 0     == fromList [0,0,0,0,0]
    repeat 3 "cat" == fromList ["cat","cat","cat"]

Notice that `repeat 3 x` is the same as `initialize 3 (always x)`.
-}
repeat : Elm.Expression -> Elm.Expression -> Elm.Expression
repeat arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "repeat") [ arg1, arg2 ]


{-| Create an array from a `List`.
-}
fromList : Elm.Expression -> Elm.Expression
fromList arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "fromList") [ arg1 ]


{-| Determine if an array is empty.

    isEmpty empty == True
-}
isEmpty : Elm.Expression -> Elm.Expression
isEmpty arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "isEmpty") [ arg1 ]


{-| Return the length of an array.

    length (fromList [1,2,3]) == 3
-}
length : Elm.Expression -> Elm.Expression
length arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "length") [ arg1 ]


{-| Return `Just` the element at the index or `Nothing` if the index is out of
range.

    get  0 (fromList [0,1,2]) == Just 0
    get  2 (fromList [0,1,2]) == Just 2
    get  5 (fromList [0,1,2]) == Nothing
    get -1 (fromList [0,1,2]) == Nothing
-}
get : Elm.Expression -> Elm.Expression -> Elm.Expression
get arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "get") [ arg1, arg2 ]


{-| Set the element at a particular index. Returns an updated array.
If the index is out of range, the array is unaltered.

    set 1 7 (fromList [1,2,3]) == fromList [1,7,3]
-}
set : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
set arg1 arg2 arg3 =
    Elm.apply (Elm.valueFrom moduleName_ "set") [ arg1, arg2, arg3 ]


{-| Push an element onto the end of an array.

    push 3 (fromList [1,2]) == fromList [1,2,3]
-}
push : Elm.Expression -> Elm.Expression -> Elm.Expression
push arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "push") [ arg1, arg2 ]


{-| Append two arrays to a new one.

    append (repeat 2 42) (repeat 3 81) == fromList [42,42,81,81,81]
-}
append : Elm.Expression -> Elm.Expression -> Elm.Expression
append arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "append") [ arg1, arg2 ]


{-| Get a sub-section of an array: `(slice start end array)`. The `start` is a
zero-based index where we will start our slice. The `end` is a zero-based index
that indicates the end of the slice. The slice extracts up to but not including
`end`.

    slice  0  3 (fromList [0,1,2,3,4]) == fromList [0,1,2]
    slice  1  4 (fromList [0,1,2,3,4]) == fromList [1,2,3]

Both the `start` and `end` indexes can be negative, indicating an offset from
the end of the array.

    slice  1 -1 (fromList [0,1,2,3,4]) == fromList [1,2,3]
    slice -2  5 (fromList [0,1,2,3,4]) == fromList [3,4]

This makes it pretty easy to `pop` the last element off of an array:
`slice 0 -1 array`
-}
slice : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
slice arg1 arg2 arg3 =
    Elm.apply (Elm.valueFrom moduleName_ "slice") [ arg1, arg2, arg3 ]


{-| Create a list of elements from an array.

    toList (fromList [3,5,8]) == [3,5,8]
-}
toList : Elm.Expression -> Elm.Expression
toList arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "toList") [ arg1 ]


{-| Create an indexed list from an array. Each element of the array will be
paired with its index.

    toIndexedList (fromList ["cat","dog"]) == [(0,"cat"), (1,"dog")]
-}
toIndexedList : Elm.Expression -> Elm.Expression
toIndexedList arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "toIndexedList") [ arg1 ]


{-| Apply a function on every element in an array.

    map sqrt (fromList [1,4,9]) == fromList [1,2,3]
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "map") [ arg1 Elm.pass, arg2 ]


{-| Apply a function on every element with its index as first argument.

    indexedMap (*) (fromList [5,5,5]) == fromList [0,5,10]
-}
indexedMap :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
indexedMap arg1 arg2 =
    Elm.apply
        (Elm.valueFrom moduleName_ "indexedMap")
        [ arg1 Elm.pass Elm.pass, arg2 ]


{-| Reduce an array from the left. Read `foldl` as fold from the left.

    foldl (::) [] (fromList [1,2,3]) == [3,2,1]
-}
foldl :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
foldl arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueFrom moduleName_ "foldl")
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-| Reduce an array from the right. Read `foldr` as fold from the right.

    foldr (+) 0 (repeat 3 5) == 15
-}
foldr :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
foldr arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueFrom moduleName_ "foldr")
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-| Keep elements that pass the test.

    filter isEven (fromList [1,2,3,4,5,6]) == (fromList [2,4,6])
-}
filter : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
filter arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "filter") [ arg1 Elm.pass, arg2 ]

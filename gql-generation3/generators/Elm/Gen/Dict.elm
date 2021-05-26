module Elm.Gen.Dict exposing (diff, empty, filter, foldl, foldr, fromList, get, id_, insert, intersect, isEmpty, keys, map, member, merge, moduleName_, partition, remove, singleton, size, toList, union, update, values)

import Elm
import Elm.Annotation


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Dict" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { empty : Elm.Expression
    , singleton : Elm.Expression
    , insert : Elm.Expression
    , update : Elm.Expression
    , remove : Elm.Expression
    , isEmpty : Elm.Expression
    , member : Elm.Expression
    , get : Elm.Expression
    , size : Elm.Expression
    , keys : Elm.Expression
    , values : Elm.Expression
    , toList : Elm.Expression
    , fromList : Elm.Expression
    , map : Elm.Expression
    , foldl : Elm.Expression
    , foldr : Elm.Expression
    , filter : Elm.Expression
    , partition : Elm.Expression
    , union : Elm.Expression
    , intersect : Elm.Expression
    , diff : Elm.Expression
    , merge : Elm.Expression
    }
id_ =
    { empty = Elm.valueFrom moduleName_ "empty"
    , singleton = Elm.valueFrom moduleName_ "singleton"
    , insert = Elm.valueFrom moduleName_ "insert"
    , update = Elm.valueFrom moduleName_ "update"
    , remove = Elm.valueFrom moduleName_ "remove"
    , isEmpty = Elm.valueFrom moduleName_ "isEmpty"
    , member = Elm.valueFrom moduleName_ "member"
    , get = Elm.valueFrom moduleName_ "get"
    , size = Elm.valueFrom moduleName_ "size"
    , keys = Elm.valueFrom moduleName_ "keys"
    , values = Elm.valueFrom moduleName_ "values"
    , toList = Elm.valueFrom moduleName_ "toList"
    , fromList = Elm.valueFrom moduleName_ "fromList"
    , map = Elm.valueFrom moduleName_ "map"
    , foldl = Elm.valueFrom moduleName_ "foldl"
    , foldr = Elm.valueFrom moduleName_ "foldr"
    , filter = Elm.valueFrom moduleName_ "filter"
    , partition = Elm.valueFrom moduleName_ "partition"
    , union = Elm.valueFrom moduleName_ "union"
    , intersect = Elm.valueFrom moduleName_ "intersect"
    , diff = Elm.valueFrom moduleName_ "diff"
    , merge = Elm.valueFrom moduleName_ "merge"
    }


{-| A dictionary of keys and values. So a `Dict String User` is a dictionary
that lets you look up a `String` (such as user names) and find the associated
`User`.

    import Dict exposing (Dict)

    users : Dict String User
    users =
      Dict.fromList
        [ ("Alice", User "Alice" 28 1.65)
        , ("Bob"  , User "Bob"   19 1.82)
        , ("Chuck", User "Chuck" 33 1.75)
        ]

    type alias User =
      { name : String
      , age : Int
      , height : Float
      }
-}
typeDict : { annotation : Elm.Annotation.Annotation }
typeDict =
    { annotation = Elm.Annotation.named moduleName_ "Dict" }


{-| Create an empty dictionary. -}
empty : Elm.Expression
empty =
    Elm.valueFrom moduleName_ "empty"


{-| Create a dictionary with one key-value pair. -}
singleton : Elm.Expression -> Elm.Expression -> Elm.Expression
singleton arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "singleton") [ arg1, arg2 ]


{-| Insert a key-value pair into a dictionary. Replaces value when there is
a collision. -}
insert : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
insert arg1 arg2 arg3 =
    Elm.apply (Elm.valueFrom moduleName_ "insert") [ arg1, arg2, arg3 ]


{-| Update the value of a dictionary for a specific key with a given function. -}
update :
    Elm.Expression
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
update arg1 arg2 arg3 =
    Elm.apply (Elm.valueFrom moduleName_ "update") [ arg1, arg2 Elm.pass, arg3 ]


{-| Remove a key-value pair from a dictionary. If the key is not found,
no changes are made. -}
remove : Elm.Expression -> Elm.Expression -> Elm.Expression
remove arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "remove") [ arg1, arg2 ]


{-| Determine if a dictionary is empty.

    isEmpty empty == True
-}
isEmpty : Elm.Expression -> Elm.Expression
isEmpty arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "isEmpty") [ arg1 ]


{-| Determine if a key is in a dictionary. -}
member : Elm.Expression -> Elm.Expression -> Elm.Expression
member arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "member") [ arg1, arg2 ]


{-| Get the value associated with a key. If the key is not found, return
`Nothing`. This is useful when you are not sure if a key will be in the
dictionary.

    animals = fromList [ ("Tom", Cat), ("Jerry", Mouse) ]

    get "Tom"   animals == Just Cat
    get "Jerry" animals == Just Mouse
    get "Spike" animals == Nothing

-}
get : Elm.Expression -> Elm.Expression -> Elm.Expression
get arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "get") [ arg1, arg2 ]


{-| Determine the number of key-value pairs in the dictionary. -}
size : Elm.Expression -> Elm.Expression
size arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "size") [ arg1 ]


{-| Get all of the keys in a dictionary, sorted from lowest to highest.

    keys (fromList [(0,"Alice"),(1,"Bob")]) == [0,1]
-}
keys : Elm.Expression -> Elm.Expression
keys arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "keys") [ arg1 ]


{-| Get all of the values in a dictionary, in the order of their keys.

    values (fromList [(0,"Alice"),(1,"Bob")]) == ["Alice", "Bob"]
-}
values : Elm.Expression -> Elm.Expression
values arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "values") [ arg1 ]


{-| Convert a dictionary into an association list of key-value pairs, sorted by keys. -}
toList : Elm.Expression -> Elm.Expression
toList arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "toList") [ arg1 ]


{-| Convert an association list into a dictionary. -}
fromList : Elm.Expression -> Elm.Expression
fromList arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "fromList") [ arg1 ]


{-| Apply a function to all values in a dictionary.
-}
map :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
map arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "map") [ arg1 Elm.pass Elm.pass, arg2 ]


{-| Fold over the key-value pairs in a dictionary from lowest key to highest key.

    import Dict exposing (Dict)

    getAges : Dict String User -> List String
    getAges users =
      Dict.foldl addAge [] users

    addAge : String -> User -> List String -> List String
    addAge _ user ages =
      user.age :: ages

    -- getAges users == [33,19,28]
-}
foldl :
    (Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
foldl arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueFrom moduleName_ "foldl")
        [ arg1 Elm.pass Elm.pass Elm.pass, arg2, arg3 ]


{-| Fold over the key-value pairs in a dictionary from highest key to lowest key.

    import Dict exposing (Dict)

    getAges : Dict String User -> List String
    getAges users =
      Dict.foldr addAge [] users

    addAge : String -> User -> List String -> List String
    addAge _ user ages =
      user.age :: ages

    -- getAges users == [28,19,33]
-}
foldr :
    (Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
foldr arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueFrom moduleName_ "foldr")
        [ arg1 Elm.pass Elm.pass Elm.pass, arg2, arg3 ]


{-| Keep only the key-value pairs that pass the given test. -}
filter :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
filter arg1 arg2 =
    Elm.apply
        (Elm.valueFrom moduleName_ "filter")
        [ arg1 Elm.pass Elm.pass, arg2 ]


{-| Partition a dictionary according to some test. The first dictionary
contains all key-value pairs which passed the test, and the second contains
the pairs that did not.
-}
partition :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
partition arg1 arg2 =
    Elm.apply
        (Elm.valueFrom moduleName_ "partition")
        [ arg1 Elm.pass Elm.pass, arg2 ]


{-| Combine two dictionaries. If there is a collision, preference is given
to the first dictionary.
-}
union : Elm.Expression -> Elm.Expression -> Elm.Expression
union arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "union") [ arg1, arg2 ]


{-| Keep a key-value pair when its key appears in the second dictionary.
Preference is given to values in the first dictionary.
-}
intersect : Elm.Expression -> Elm.Expression -> Elm.Expression
intersect arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "intersect") [ arg1, arg2 ]


{-| Keep a key-value pair when its key does not appear in the second dictionary.
-}
diff : Elm.Expression -> Elm.Expression -> Elm.Expression
diff arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "diff") [ arg1, arg2 ]


{-| The most general way of combining two dictionaries. You provide three
accumulators for when a given key appears:

  1. Only in the left dictionary.
  2. In both dictionaries.
  3. Only in the right dictionary.

You then traverse all the keys from lowest to highest, building up whatever
you want.
-}
merge :
    (Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> (Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
merge arg1 arg2 arg3 arg4 arg5 arg6 =
    Elm.apply
        (Elm.valueFrom moduleName_ "merge")
        [ arg1 Elm.pass Elm.pass Elm.pass
        , arg2 Elm.pass Elm.pass Elm.pass Elm.pass
        , arg3 Elm.pass Elm.pass Elm.pass
        , arg4
        , arg5
        , arg6
        ]

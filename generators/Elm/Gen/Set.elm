module Elm.Gen.Set exposing (diff, empty, filter, foldl, foldr, fromList, id_, insert, intersect, isEmpty, map, member, moduleName_, partition, remove, singleton, size, toList, union)

import Elm
import Elm.Annotation


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Set" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { empty : Elm.Expression
    , singleton : Elm.Expression
    , insert : Elm.Expression
    , remove : Elm.Expression
    , isEmpty : Elm.Expression
    , member : Elm.Expression
    , size : Elm.Expression
    , union : Elm.Expression
    , intersect : Elm.Expression
    , diff : Elm.Expression
    , toList : Elm.Expression
    , fromList : Elm.Expression
    , map : Elm.Expression
    , foldl : Elm.Expression
    , foldr : Elm.Expression
    , filter : Elm.Expression
    , partition : Elm.Expression
    }
id_ =
    { empty = Elm.valueFrom moduleName_ "empty"
    , singleton = Elm.valueFrom moduleName_ "singleton"
    , insert = Elm.valueFrom moduleName_ "insert"
    , remove = Elm.valueFrom moduleName_ "remove"
    , isEmpty = Elm.valueFrom moduleName_ "isEmpty"
    , member = Elm.valueFrom moduleName_ "member"
    , size = Elm.valueFrom moduleName_ "size"
    , union = Elm.valueFrom moduleName_ "union"
    , intersect = Elm.valueFrom moduleName_ "intersect"
    , diff = Elm.valueFrom moduleName_ "diff"
    , toList = Elm.valueFrom moduleName_ "toList"
    , fromList = Elm.valueFrom moduleName_ "fromList"
    , map = Elm.valueFrom moduleName_ "map"
    , foldl = Elm.valueFrom moduleName_ "foldl"
    , foldr = Elm.valueFrom moduleName_ "foldr"
    , filter = Elm.valueFrom moduleName_ "filter"
    , partition = Elm.valueFrom moduleName_ "partition"
    }


{-| Represents a set of unique values. So `(Set Int)` is a set of integers and
`(Set String)` is a set of strings.
-}
typeSet : { annotation : Elm.Annotation.Annotation }
typeSet =
    { annotation = Elm.Annotation.named moduleName_ "Set" }


{-| Create an empty set.
-}
empty : Elm.Expression
empty =
    Elm.valueFrom moduleName_ "empty"


{-| Create a set with one value.
-}
singleton : Elm.Expression -> Elm.Expression
singleton arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "singleton") [ arg1 ]


{-| Insert a value into a set.
-}
insert : Elm.Expression -> Elm.Expression -> Elm.Expression
insert arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "insert") [ arg1, arg2 ]


{-| Remove a value from a set. If the value is not found, no changes are made.
-}
remove : Elm.Expression -> Elm.Expression -> Elm.Expression
remove arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "remove") [ arg1, arg2 ]


{-| Determine if a set is empty.
-}
isEmpty : Elm.Expression -> Elm.Expression
isEmpty arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "isEmpty") [ arg1 ]


{-| Determine if a value is in a set.
-}
member : Elm.Expression -> Elm.Expression -> Elm.Expression
member arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "member") [ arg1, arg2 ]


{-| Determine the number of elements in a set.
-}
size : Elm.Expression -> Elm.Expression
size arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "size") [ arg1 ]


{-| Get the union of two sets. Keep all values.
-}
union : Elm.Expression -> Elm.Expression -> Elm.Expression
union arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "union") [ arg1, arg2 ]


{-| Get the intersection of two sets. Keeps values that appear in both sets.
-}
intersect : Elm.Expression -> Elm.Expression -> Elm.Expression
intersect arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "intersect") [ arg1, arg2 ]


{-| Get the difference between the first set and the second. Keeps values
that do not appear in the second set.
-}
diff : Elm.Expression -> Elm.Expression -> Elm.Expression
diff arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "diff") [ arg1, arg2 ]


{-| Convert a set into a list, sorted from lowest to highest.
-}
toList : Elm.Expression -> Elm.Expression
toList arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "toList") [ arg1 ]


{-| Convert a list into a set, removing any duplicates.
-}
fromList : Elm.Expression -> Elm.Expression
fromList arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "fromList") [ arg1 ]


{-| Map a function onto a set, creating a new set with no duplicates.
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "map") [ arg1 Elm.pass, arg2 ]


{-| Fold over the values in a set, in order from lowest to highest.
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


{-| Fold over the values in a set, in order from highest to lowest.
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


{-| Only keep elements that pass the given test.

    import Set exposing (Set)

    numbers : Set Int
    numbers =
      Set.fromList [-2,-1,0,1,2]

    positives : Set Int
    positives =
      Set.filter (\x -> x > 0) numbers

    -- positives == Set.fromList [1,2]
-}
filter : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
filter arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "filter") [ arg1 Elm.pass, arg2 ]


{-| Create two new sets. The first contains all the elements that passed the
given test, and the second contains all the elements that did not.
-}
partition :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
partition arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "partition") [ arg1 Elm.pass, arg2 ]

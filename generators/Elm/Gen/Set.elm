module Elm.Gen.Set exposing (diff, empty, filter, foldl, foldr, fromList, id_, insert, intersect, isEmpty, make_, map, member, moduleName_, partition, remove, singleton, size, toList, types_, union)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Set" ]


types_ : { set : Type.Annotation -> Type.Annotation }
types_ =
    { set = \arg0 -> Type.namedWith moduleName_ "Set" [ arg0 ] }


make_ : {}
make_ =
    {}


{-| Create an empty set.
-}
empty : Elm.Expression
empty =
    Elm.valueWith
        moduleName_
        "empty"
        (Type.namedWith [ "Set" ] "Set" [ Type.var "a" ])


{-| Create a set with one value.
-}
singleton : Elm.Expression -> Elm.Expression
singleton arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "singleton"
            (Type.function
                [ Type.var "comparable" ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
        )
        [ arg1 ]


{-| Insert a value into a set.
-}
insert : Elm.Expression -> Elm.Expression -> Elm.Expression
insert arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "insert"
            (Type.function
                [ Type.var "comparable"
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
        )
        [ arg1, arg2 ]


{-| Remove a value from a set. If the value is not found, no changes are made.
-}
remove : Elm.Expression -> Elm.Expression -> Elm.Expression
remove arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "remove"
            (Type.function
                [ Type.var "comparable"
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
        )
        [ arg1, arg2 ]


{-| Determine if a set is empty.
-}
isEmpty : Elm.Expression -> Elm.Expression
isEmpty arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isEmpty"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "a" ] ]
                Type.bool
            )
        )
        [ arg1 ]


{-| Determine if a value is in a set.
-}
member : Elm.Expression -> Elm.Expression -> Elm.Expression
member arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "member"
            (Type.function
                [ Type.var "comparable"
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                Type.bool
            )
        )
        [ arg1, arg2 ]


{-| Determine the number of elements in a set.
-}
size : Elm.Expression -> Elm.Expression
size arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "size"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "a" ] ]
                Type.int
            )
        )
        [ arg1 ]


{-| Get the union of two sets. Keep all values.
-}
union : Elm.Expression -> Elm.Expression -> Elm.Expression
union arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "union"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
        )
        [ arg1, arg2 ]


{-| Get the intersection of two sets. Keeps values that appear in both sets.
-}
intersect : Elm.Expression -> Elm.Expression -> Elm.Expression
intersect arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "intersect"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
        )
        [ arg1, arg2 ]


{-| Get the difference between the first set and the second. Keeps values
that do not appear in the second set.
-}
diff : Elm.Expression -> Elm.Expression -> Elm.Expression
diff arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "diff"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
        )
        [ arg1, arg2 ]


{-| Convert a set into a list, sorted from lowest to highest.
-}
toList : Elm.Expression -> Elm.Expression
toList arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toList"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "a" ] ]
                (Type.list (Type.var "a"))
            )
        )
        [ arg1 ]


{-| Convert a list into a set, removing any duplicates.
-}
fromList : Elm.Expression -> Elm.Expression
fromList arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromList"
            (Type.function
                [ Type.list (Type.var "comparable") ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
        )
        [ arg1 ]


{-| Map a function onto a set, creating a new set with no duplicates.
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function
                    [ Type.var "comparable" ]
                    (Type.var "comparable2")
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable2" ])
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Fold over the values in a set, in order from lowest to highest.
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
                , Type.namedWith [ "Set" ] "Set" [ Type.var "a" ]
                ]
                (Type.var "b")
            )
        )
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
        (Elm.valueWith
            moduleName_
            "foldr"
            (Type.function
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "b")
                , Type.var "b"
                , Type.namedWith [ "Set" ] "Set" [ Type.var "a" ]
                ]
                (Type.var "b")
            )
        )
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
    Elm.apply
        (Elm.valueWith
            moduleName_
            "filter"
            (Type.function
                [ Type.function [ Type.var "comparable" ] Type.bool
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Create two new sets. The first contains all the elements that passed the
given test, and the second contains all the elements that did not.
-}
partition :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
partition arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "partition"
            (Type.function
                [ Type.function [ Type.var "comparable" ] Type.bool
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.tuple
                    (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
                    (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


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
    { empty =
        Elm.valueWith
            moduleName_
            "empty"
            (Type.namedWith [ "Set" ] "Set" [ Type.var "a" ])
    , singleton =
        Elm.valueWith
            moduleName_
            "singleton"
            (Type.function
                [ Type.var "comparable" ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
    , insert =
        Elm.valueWith
            moduleName_
            "insert"
            (Type.function
                [ Type.var "comparable"
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
    , remove =
        Elm.valueWith
            moduleName_
            "remove"
            (Type.function
                [ Type.var "comparable"
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
    , isEmpty =
        Elm.valueWith
            moduleName_
            "isEmpty"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "a" ] ]
                Type.bool
            )
    , member =
        Elm.valueWith
            moduleName_
            "member"
            (Type.function
                [ Type.var "comparable"
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                Type.bool
            )
    , size =
        Elm.valueWith
            moduleName_
            "size"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "a" ] ]
                Type.int
            )
    , union =
        Elm.valueWith
            moduleName_
            "union"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
    , intersect =
        Elm.valueWith
            moduleName_
            "intersect"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
    , diff =
        Elm.valueWith
            moduleName_
            "diff"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
    , toList =
        Elm.valueWith
            moduleName_
            "toList"
            (Type.function
                [ Type.namedWith [ "Set" ] "Set" [ Type.var "a" ] ]
                (Type.list (Type.var "a"))
            )
    , fromList =
        Elm.valueWith
            moduleName_
            "fromList"
            (Type.function
                [ Type.list (Type.var "comparable") ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
    , map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function
                    [ Type.var "comparable" ]
                    (Type.var "comparable2")
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable2" ])
            )
    , foldl =
        Elm.valueWith
            moduleName_
            "foldl"
            (Type.function
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "b")
                , Type.var "b"
                , Type.namedWith [ "Set" ] "Set" [ Type.var "a" ]
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
                , Type.namedWith [ "Set" ] "Set" [ Type.var "a" ]
                ]
                (Type.var "b")
            )
    , filter =
        Elm.valueWith
            moduleName_
            "filter"
            (Type.function
                [ Type.function [ Type.var "comparable" ] Type.bool
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
            )
    , partition =
        Elm.valueWith
            moduleName_
            "partition"
            (Type.function
                [ Type.function [ Type.var "comparable" ] Type.bool
                , Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ]
                ]
                (Type.tuple
                    (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
                    (Type.namedWith [ "Set" ] "Set" [ Type.var "comparable" ])
                )
            )
    }



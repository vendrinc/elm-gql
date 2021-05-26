module Elm.Gen.Tuple exposing (first, id_, mapBoth, mapFirst, mapSecond, moduleName_, pair, second)

import Elm


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Tuple" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { pair : Elm.Expression
    , first : Elm.Expression
    , second : Elm.Expression
    , mapFirst : Elm.Expression
    , mapSecond : Elm.Expression
    , mapBoth : Elm.Expression
    }
id_ =
    { pair = Elm.valueFrom moduleName_ "pair"
    , first = Elm.valueFrom moduleName_ "first"
    , second = Elm.valueFrom moduleName_ "second"
    , mapFirst = Elm.valueFrom moduleName_ "mapFirst"
    , mapSecond = Elm.valueFrom moduleName_ "mapSecond"
    , mapBoth = Elm.valueFrom moduleName_ "mapBoth"
    }


{-| Create a 2-tuple.

    -- pair 3 4 == (3, 4)

    zip : List a -> List b -> List (a, b)
    zip xs ys =
      List.map2 Tuple.pair xs ys
-}
pair : Elm.Expression -> Elm.Expression -> Elm.Expression
pair arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "pair") [ arg1, arg2 ]


{-| Extract the first value from a tuple.

    first (3, 4) == 3
    first ("john", "doe") == "john"
-}
first : Elm.Expression -> Elm.Expression
first arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "first") [ arg1 ]


{-| Extract the second value from a tuple.

    second (3, 4) == 4
    second ("john", "doe") == "doe"
-}
second : Elm.Expression -> Elm.Expression
second arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "second") [ arg1 ]


{-| Transform the first value in a tuple.

    import String

    mapFirst String.reverse ("stressed", 16) == ("desserts", 16)
    mapFirst String.length  ("stressed", 16) == (8, 16)
-}
mapFirst :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
mapFirst arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "mapFirst") [ arg1 Elm.pass, arg2 ]


{-| Transform the second value in a tuple.

    mapSecond sqrt   ("stressed", 16) == ("stressed", 4)
    mapSecond negate ("stressed", 16) == ("stressed", -16)
-}
mapSecond :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
mapSecond arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "mapSecond") [ arg1 Elm.pass, arg2 ]


{-| Transform both parts of a tuple.

    import String

    mapBoth String.reverse sqrt  ("stressed", 16) == ("desserts", 4)
    mapBoth String.length negate ("stressed", 16) == (8, -16)
-}
mapBoth :
    (Elm.Expression -> Elm.Expression)
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
mapBoth arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueFrom moduleName_ "mapBoth")
        [ arg1 Elm.pass, arg2 Elm.pass, arg3 ]

module Elm.Gen.Platform.Sub exposing (batch, id_, make_, map, moduleName_, none, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Platform", "Sub" ]


types_ : { sub : Type.Annotation -> Type.Annotation }
types_ =
    { sub = \arg0 -> Type.namedWith moduleName_ "Sub" [ arg0 ] }


make_ : {}
make_ =
    {}


{-| Tell the runtime that there are no subscriptions.
-}
none : Elm.Expression
none =
    Elm.valueWith
        moduleName_
        "none"
        (Type.namedWith [ "Platform", "Sub" ] "Sub" [ Type.var "msg" ])


{-| When you need to subscribe to multiple things, you can create a `batch` of
subscriptions.

**Note:** `Sub.none` and `Sub.batch [ Sub.none, Sub.none ]` and
`Sub.batch []` all do the same thing.
-}
batch : Elm.Expression -> Elm.Expression
batch arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "batch"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "Platform", "Sub" ]
                        "Sub"
                        [ Type.var "msg" ]
                    )
                ]
                (Type.namedWith [ "Platform", "Sub" ] "Sub" [ Type.var "msg" ])
            )
        )
        [ arg1 ]


{-| Transform the messages produced by a subscription.
Very similar to [`Html.map`](/packages/elm/html/latest/Html#map).

This is very rarely useful in well-structured Elm code, so definitely read the
section on [structure][] in the guide before reaching for this!

[structure]: https://guide.elm-lang.org/webapps/structure.html
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "msg")
                , Type.namedWith [ "Platform", "Sub" ] "Sub" [ Type.var "a" ]
                ]
                (Type.namedWith [ "Platform", "Sub" ] "Sub" [ Type.var "msg" ])
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : { none : Elm.Expression, batch : Elm.Expression, map : Elm.Expression }
id_ =
    { none =
        Elm.valueWith
            moduleName_
            "none"
            (Type.namedWith [ "Platform", "Sub" ] "Sub" [ Type.var "msg" ])
    , batch =
        Elm.valueWith
            moduleName_
            "batch"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "Platform", "Sub" ]
                        "Sub"
                        [ Type.var "msg" ]
                    )
                ]
                (Type.namedWith [ "Platform", "Sub" ] "Sub" [ Type.var "msg" ])
            )
    , map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "msg")
                , Type.namedWith [ "Platform", "Sub" ] "Sub" [ Type.var "a" ]
                ]
                (Type.namedWith [ "Platform", "Sub" ] "Sub" [ Type.var "msg" ])
            )
    }



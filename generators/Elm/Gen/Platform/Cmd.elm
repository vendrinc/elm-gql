module Elm.Gen.Platform.Cmd exposing (batch, id_, make_, map, moduleName_, none, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Platform", "Cmd" ]


types_ : { cmd : Type.Annotation -> Type.Annotation }
types_ =
    { cmd = \arg0 -> Type.namedWith moduleName_ "Cmd" [ arg0 ] }


make_ : {}
make_ =
    {}


{-| Tell the runtime that there are no commands.

-}
none : Elm.Expression
none =
    Elm.valueWith
        moduleName_
        "none"
        (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])


{-| When you need the runtime system to perform a couple commands, you
can batch them together. Each is handed to the runtime at the same time,
and since each can perform arbitrary operations in the world, there are
no ordering guarantees about the results.

**Note:** `Cmd.none` and `Cmd.batch [ Cmd.none, Cmd.none ]` and `Cmd.batch []`
all do the same thing.
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
                        [ "Platform", "Cmd" ]
                        "Cmd"
                        [ Type.var "msg" ]
                    )
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
        )
        [ arg1 ]


{-| Transform the messages produced by a command.
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
                , Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "a" ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
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
            (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
    , batch =
        Elm.valueWith
            moduleName_
            "batch"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "Platform", "Cmd" ]
                        "Cmd"
                        [ Type.var "msg" ]
                    )
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
    , map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "msg")
                , Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "a" ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
    }



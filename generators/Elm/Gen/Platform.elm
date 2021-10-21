module Elm.Gen.Platform exposing (id_, make_, moduleName_, sendToApp, sendToSelf, types_, worker)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Platform" ]


types_ :
    { router : Type.Annotation -> Type.Annotation -> Type.Annotation
    , processId : Type.Annotation
    , task : Type.Annotation -> Type.Annotation -> Type.Annotation
    , program :
        Type.Annotation -> Type.Annotation -> Type.Annotation -> Type.Annotation
    }
types_ =
    { router = \arg0 arg1 -> Type.namedWith moduleName_ "Router" [ arg0, arg1 ]
    , processId = Type.named moduleName_ "ProcessId"
    , task = \arg0 arg1 -> Type.namedWith moduleName_ "Task" [ arg0, arg1 ]
    , program =
        \arg0 arg1 arg2 ->
            Type.namedWith moduleName_ "Program" [ arg0, arg1, arg2 ]
    }


make_ : {}
make_ =
    {}


{-| Create a [headless][] program with no user interface.

This is great if you want to use Elm as the &ldquo;brain&rdquo; for something
else. For example, you could send messages out ports to modify the DOM, but do
all the complex logic in Elm.

[headless]: https://en.wikipedia.org/wiki/Headless_software

Initializing a headless program from JavaScript looks like this:

```javascript
var app = Elm.MyThing.init();
```

If you _do_ want to control the user interface in Elm, the [`Browser`][browser]
module has a few ways to create that kind of `Program` instead!

[headless]: https://en.wikipedia.org/wiki/Headless_software
[browser]: /packages/elm/browser/latest/Browser
-}
worker : Elm.Expression -> Elm.Expression
worker arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "worker"
            (Type.function
                [ Type.record
                    [ ( "init"
                      , Type.function
                            [ Type.var "flags" ]
                            (Type.tuple
                                (Type.var "model")
                                (Type.namedWith
                                    [ "Platform", "Cmd" ]
                                    "Cmd"
                                    [ Type.var "msg" ]
                                )
                            )
                      )
                    , ( "update"
                      , Type.function
                            [ Type.var "msg", Type.var "model" ]
                            (Type.tuple
                                (Type.var "model")
                                (Type.namedWith
                                    [ "Platform", "Cmd" ]
                                    "Cmd"
                                    [ Type.var "msg" ]
                                )
                            )
                      )
                    , ( "subscriptions"
                      , Type.function
                            [ Type.var "model" ]
                            (Type.namedWith
                                [ "Platform", "Sub" ]
                                "Sub"
                                [ Type.var "msg" ]
                            )
                      )
                    ]
                ]
                (Type.namedWith
                    [ "Platform" ]
                    "Program"
                    [ Type.var "flags", Type.var "model", Type.var "msg" ]
                )
            )
        )
        [ arg1 ]


{-| Send the router a message for the main loop of your app. This message will
be handled by the overall `update` function, just like events from `Html`.
-}
sendToApp : Elm.Expression -> Elm.Expression -> Elm.Expression
sendToApp arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "sendToApp"
            (Type.function
                [ Type.namedWith
                    [ "Platform" ]
                    "Router"
                    [ Type.var "msg", Type.var "a" ]
                , Type.var "msg"
                ]
                (Type.namedWith
                    [ "Platform" ]
                    "Task"
                    [ Type.var "x", Type.unit ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Send the router a message for your effect manager. This message will
be routed to the `onSelfMsg` function, where you can update the state of your
effect manager as necessary.

As an example, the effect manager for web sockets
-}
sendToSelf : Elm.Expression -> Elm.Expression -> Elm.Expression
sendToSelf arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "sendToSelf"
            (Type.function
                [ Type.namedWith
                    [ "Platform" ]
                    "Router"
                    [ Type.var "a", Type.var "msg" ]
                , Type.var "msg"
                ]
                (Type.namedWith
                    [ "Platform" ]
                    "Task"
                    [ Type.var "x", Type.unit ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { worker : Elm.Expression
    , sendToApp : Elm.Expression
    , sendToSelf : Elm.Expression
    }
id_ =
    { worker =
        Elm.valueWith
            moduleName_
            "worker"
            (Type.function
                [ Type.record
                    [ ( "init"
                      , Type.function
                            [ Type.var "flags" ]
                            (Type.tuple
                                (Type.var "model")
                                (Type.namedWith
                                    [ "Platform", "Cmd" ]
                                    "Cmd"
                                    [ Type.var "msg" ]
                                )
                            )
                      )
                    , ( "update"
                      , Type.function
                            [ Type.var "msg", Type.var "model" ]
                            (Type.tuple
                                (Type.var "model")
                                (Type.namedWith
                                    [ "Platform", "Cmd" ]
                                    "Cmd"
                                    [ Type.var "msg" ]
                                )
                            )
                      )
                    , ( "subscriptions"
                      , Type.function
                            [ Type.var "model" ]
                            (Type.namedWith
                                [ "Platform", "Sub" ]
                                "Sub"
                                [ Type.var "msg" ]
                            )
                      )
                    ]
                ]
                (Type.namedWith
                    [ "Platform" ]
                    "Program"
                    [ Type.var "flags", Type.var "model", Type.var "msg" ]
                )
            )
    , sendToApp =
        Elm.valueWith
            moduleName_
            "sendToApp"
            (Type.function
                [ Type.namedWith
                    [ "Platform" ]
                    "Router"
                    [ Type.var "msg", Type.var "a" ]
                , Type.var "msg"
                ]
                (Type.namedWith
                    [ "Platform" ]
                    "Task"
                    [ Type.var "x", Type.unit ]
                )
            )
    , sendToSelf =
        Elm.valueWith
            moduleName_
            "sendToSelf"
            (Type.function
                [ Type.namedWith
                    [ "Platform" ]
                    "Router"
                    [ Type.var "a", Type.var "msg" ]
                , Type.var "msg"
                ]
                (Type.namedWith
                    [ "Platform" ]
                    "Task"
                    [ Type.var "x", Type.unit ]
                )
            )
    }



module Elm.Gen.Platform exposing (id_, moduleName_, sendToApp, sendToSelf, worker)

import Elm
import Elm.Annotation


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Platform" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { worker : Elm.Expression
    , sendToApp : Elm.Expression
    , sendToSelf : Elm.Expression
    }
id_ =
    { worker = Elm.valueFrom moduleName_ "worker"
    , sendToApp = Elm.valueFrom moduleName_ "sendToApp"
    , sendToSelf = Elm.valueFrom moduleName_ "sendToSelf"
    }


{-| A `Program` describes an Elm program! How does it react to input? Does it
show anything on screen? Etc.
-}
typeProgram : { annotation : Elm.Annotation.Annotation }
typeProgram =
    { annotation = Elm.Annotation.named moduleName_ "Program" }


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
    Elm.apply (Elm.valueFrom moduleName_ "worker") [ arg1 ]


{-| Head over to the documentation for the [`Task`](Task) module for more
information on this. It is only defined here because it is a platform
primitive.
-}
typeTask : { annotation : Elm.Annotation.Annotation }
typeTask =
    { annotation = Elm.Annotation.named moduleName_ "Task" }


{-| Head over to the documentation for the [`Process`](Process) module for
information on this. It is only defined here because it is a platform
primitive.
-}
typeProcessId : { annotation : Elm.Annotation.Annotation }
typeProcessId =
    { annotation = Elm.Annotation.named moduleName_ "ProcessId" }


{-| An effect manager has access to a “router” that routes messages between
the main app and your individual effect manager.
-}
typeRouter : { annotation : Elm.Annotation.Annotation }
typeRouter =
    { annotation = Elm.Annotation.named moduleName_ "Router" }


{-| Send the router a message for the main loop of your app. This message will
be handled by the overall `update` function, just like events from `Html`.
-}
sendToApp : Elm.Expression -> Elm.Expression -> Elm.Expression
sendToApp arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "sendToApp") [ arg1, arg2 ]


{-| Send the router a message for your effect manager. This message will
be routed to the `onSelfMsg` function, where you can update the state of your
effect manager as necessary.

As an example, the effect manager for web sockets
-}
sendToSelf : Elm.Expression -> Elm.Expression -> Elm.Expression
sendToSelf arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "sendToSelf") [ arg1, arg2 ]

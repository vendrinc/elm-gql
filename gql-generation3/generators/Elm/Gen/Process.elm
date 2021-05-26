module Elm.Gen.Process exposing (id_, kill, moduleName_, sleep, spawn)

import Elm
import Elm.Annotation


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Process" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : { spawn : Elm.Expression, sleep : Elm.Expression, kill : Elm.Expression }
id_ =
    { spawn = Elm.valueFrom moduleName_ "spawn"
    , sleep = Elm.valueFrom moduleName_ "sleep"
    , kill = Elm.valueFrom moduleName_ "kill"
    }


{-| A light-weight process that runs concurrently. You can use `spawn` to
get a bunch of different tasks running in different processes. The Elm runtime
will interleave their progress. So if a task is taking too long, we will pause
it at an `andThen` and switch over to other stuff.

**Note:** We make a distinction between *concurrency* which means interleaving
different sequences and *parallelism* which means running different
sequences at the exact same time. For example, a
[time-sharing system](https://en.wikipedia.org/wiki/Time-sharing) is definitely
concurrent, but not necessarily parallel. So even though JS runs within a
single OS-level thread, Elm can still run things concurrently.
-}
aliasId : { annotation : Elm.Annotation.Annotation }
aliasId =
    { annotation = Elm.Annotation.named moduleName_ "Id" }


{-| Run a task in its own light-weight process. In the following example,
`task1` and `task2` will be interleaved. If `task1` makes a long HTTP request
or is just taking a long time, we can hop over to `task2` and do some work
there.

    spawn task1
      |> Task.andThen (\_ -> spawn task2)

**Note:** This creates a relatively restricted kind of `Process` because it
cannot receive any messages. More flexibility for user-defined processes will
come in a later release!
-}
spawn : Elm.Expression -> Elm.Expression
spawn arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "spawn") [ arg1 ]


{-| Block progress on the current process for the given number of milliseconds.
The JavaScript equivalent of this is [`setTimeout`][setTimeout] which lets you
delay work until later.

[setTimeout]: https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setTimeout
-}
sleep : Elm.Expression -> Elm.Expression
sleep arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "sleep") [ arg1 ]


{-| Sometimes you `spawn` a process, but later decide it would be a waste to
have it keep running and doing stuff. The `kill` function will force a process
to bail on whatever task it is running. So if there is an HTTP request in
flight, it will also abort the request.
-}
kill : Elm.Expression -> Elm.Expression
kill arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "kill") [ arg1 ]

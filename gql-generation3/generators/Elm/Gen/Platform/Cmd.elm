module Elm.Gen.Platform.Cmd exposing (batch, id_, map, moduleName_, none)

import Elm
import Elm.Annotation


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Platform", "Cmd" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : { none : Elm.Expression, batch : Elm.Expression, map : Elm.Expression }
id_ =
    { none = Elm.valueFrom moduleName_ "none"
    , batch = Elm.valueFrom moduleName_ "batch"
    , map = Elm.valueFrom moduleName_ "map"
    }


{-| A command is a way of telling Elm, “Hey, I want you to do this thing!”
So if you want to send an HTTP request, you would need to command Elm to do it.
Or if you wanted to ask for geolocation, you would need to command Elm to go
get it.

Every `Cmd` specifies (1) which effects you need access to and (2) the type of
messages that will come back into your application.

**Note:** Do not worry if this seems confusing at first! As with every Elm user
ever, commands will make more sense as you work through [the Elm Architecture
Tutorial](https://guide.elm-lang.org/architecture/) and see how they
fit into a real application!
-}
typeCmd : { annotation : Elm.Annotation.Annotation }
typeCmd =
    { annotation = Elm.Annotation.named moduleName_ "Cmd" }


{-| Tell the runtime that there are no commands.

-}
none : Elm.Expression
none =
    Elm.valueFrom moduleName_ "none"


{-| When you need the runtime system to perform a couple commands, you
can batch them together. Each is handed to the runtime at the same time,
and since each can perform arbitrary operations in the world, there are
no ordering guarantees about the results.

**Note:** `Cmd.none` and `Cmd.batch [ Cmd.none, Cmd.none ]` and `Cmd.batch []`
all do the same thing.
-}
batch : Elm.Expression -> Elm.Expression
batch arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "batch") [ arg1 ]


{-| Transform the messages produced by a command.
Very similar to [`Html.map`](/packages/elm/html/latest/Html#map).

This is very rarely useful in well-structured Elm code, so definitely read the
section on [structure][] in the guide before reaching for this!

[structure]: https://guide.elm-lang.org/webapps/structure.html
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "map") [ arg1 Elm.pass, arg2 ]

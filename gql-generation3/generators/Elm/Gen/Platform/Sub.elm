module Elm.Gen.Platform.Sub exposing (batch, id_, map, moduleName_, none)

import Elm
import Elm.Annotation


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Platform", "Sub" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : { none : Elm.Expression, batch : Elm.Expression, map : Elm.Expression }
id_ =
    { none = Elm.valueFrom moduleName_ "none"
    , batch = Elm.valueFrom moduleName_ "batch"
    , map = Elm.valueFrom moduleName_ "map"
    }


{-| A subscription is a way of telling Elm, “Hey, let me know if anything
interesting happens over there!” So if you want to listen for messages on a web
socket, you would tell Elm to create a subscription. If you want to get clock
ticks, you would tell Elm to subscribe to that. The cool thing here is that
this means *Elm* manages all the details of subscriptions instead of *you*.
So if a web socket goes down, *you* do not need to manually reconnect with an
exponential backoff strategy, *Elm* does this all for you behind the scenes!

Every `Sub` specifies (1) which effects you need access to and (2) the type of
messages that will come back into your application.

**Note:** Do not worry if this seems confusing at first! As with every Elm user
ever, subscriptions will make more sense as you work through [the Elm Architecture
Tutorial](https://guide.elm-lang.org/architecture/) and see how they fit
into a real application!
-}
typeSub : { annotation : Elm.Annotation.Annotation }
typeSub =
    { annotation = Elm.Annotation.named moduleName_ "Sub" }


{-| Tell the runtime that there are no subscriptions.
-}
none : Elm.Expression
none =
    Elm.valueFrom moduleName_ "none"


{-| When you need to subscribe to multiple things, you can create a `batch` of
subscriptions.

**Note:** `Sub.none` and `Sub.batch [ Sub.none, Sub.none ]` and
`Sub.batch []` all do the same thing.
-}
batch : Elm.Expression -> Elm.Expression
batch arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "batch") [ arg1 ]


{-| Transform the messages produced by a subscription.
Very similar to [`Html.map`](/packages/elm/html/latest/Html#map).

This is very rarely useful in well-structured Elm code, so definitely read the
section on [structure][] in the guide before reaching for this!

[structure]: https://guide.elm-lang.org/webapps/structure.html
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "map") [ arg1 Elm.pass, arg2 ]

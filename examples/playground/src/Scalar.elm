module Scalar exposing (codecs)

import Codec exposing (Codec)
import Time


{-| NOTE:
Before we can generate GQL.elm, we'll need to
verify that each scalar has a codec defined here
-}
codecs :
    { id : Codec String
    , timestamp : Codec Time.Posix
    }
codecs =
    { id = Codec.string
    , timestamp =
        Codec.map
            Time.millisToPosix
            Time.posixToMillis
            Codec.int
    }

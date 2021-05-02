module Scalar exposing (codecs)

import Codec exposing (Codec)
import GQL.Types as GQL
import GraphQL.Engine
import Time


{-| NOTE:
Before we can generate GQL.elm, we'll need to
verify that each scalar has a codec defined here
-}
codecs :
    { id : Codec GQL.ID
    , string : Codec String
    , timestamp : Codec Time.Posix
    }
codecs =
    { id = GraphQL.Engine.toScalarCodec Codec.string
    , string = Codec.string
    , timestamp =
        Codec.map
            Time.millisToPosix
            Time.posixToMillis
            Codec.int
    }

module Scalar exposing (..)

-- import Codec exposing (Codec)
-- import GraphQL.Engine
-- import Time


-- {-| NOTE:
-- Before we can generate GQL.elm, we'll need to
-- verify that each scalar has a codec defined here
-- -}
-- codecs :
--     { id : Codec String
--     , string : Codec String
--     , timestamp : Codec Time.Posix
--     }
-- codecs =
--     { id = Codec.string -- GraphQL.Engine.toScalarCodec Codec.string
--     , string = Codec.string
--     , timestamp =
--         Codec.map
--             Time.millisToPosix
--             Time.posixToMillis
--             Codec.int
--     }

test = "Foo"
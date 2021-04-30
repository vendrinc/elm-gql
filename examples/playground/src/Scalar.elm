module Scalar exposing (decoders)

import GQL.Types
import Json.Decode as Json


decoders :
    { id : Json.Decoder GQL.Types.ID
    }
decoders =
    { id = Debug.todo ""
    }

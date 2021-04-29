module Scalar exposing (decoders)

import Blissfully as GQL
import Json.Decode as Json


decoders :
    { id : Json.Decoder GQL.ID
    }
decoders =
    { id = Debug.todo ""
    }

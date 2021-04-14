module GQL.Internals exposing (Field(..), Selection(..), User, fields)

import Json.Decode as Json


type alias User value =
    Selection
        { name : Field String
        , email : Field (Maybe String)
        }
        value


type Selection x value
    = Selection x (Json.Decoder value)


type Field value
    = Field (Json.Decoder value)


fields :
    { string : String -> Field String
    , maybe :
        { string : String -> Field (Maybe String)
        }
    }
fields =
    { string = \field -> Field (Json.field field Json.string)
    , maybe =
        { string = \field -> Field (Json.field field (Json.maybe Json.string))
        }
    }

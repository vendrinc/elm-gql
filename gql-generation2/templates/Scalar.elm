module Scalar exposing (codecs)

import GraphQL.Engine as Engine
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Time


type alias Codec scalar =
    { encode : scalar -> Encode.Value
    , decoder : Decoder scalar
    }


codecs =
    { url =
        { encode = Url.toString >> String.trim >> String.replace " " "%20" >> Encode.string
        , decoder =
            Decode.string
                |> Decode.andThen
                    (\urlString ->
                        case Url.fromString urlString of
                            Nothing ->
                                Decode.fail ("Not a valid url: " ++ urlString)

                            Just url ->
                                Decode.succeed url
                    )
        }
    , dateTime =
        { encode = Iso8601.encode
        , decode = Iso8601.decoder
        }
    , iso4217 =
        { encode = \(Iso4217 raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map Iso4217
        }
    , markdown =
        { encode = \(Markdown raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map Markdown
        }
    , pageCursor =
        { encode = \(PageCursor raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map PageCursor
        }
    , json =
        { encode = \(Json raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map Json
        }
    , viewID =
        { encode = \(ViewID raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map ViewID
        }
    , columnID =
        { encode = \(ColumnID raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map ColumnID
        }
    , surveyID =
        { encode = \(SurveyID raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map SurveyID
        }
    , never =
        { encode = \Never -> Encode.string "Never"
        , decoder = Object.scalarDecoder |> Decode.map (always Never)
        }
    , presence =
        { encode = \Present -> Encode.string "Present"
        , decoder = Object.scalarDecoder |> Decode.map (always Present)
        }
    }


type Id
    = Id String


type SurveyID
    = SurveyID String


type ViewID
    = ViewID String


type ColumnID
    = ColumnID String


type Iso4217
    = Iso4217 String


type Json
    = Json String


type Markdown
    = Markdown String


type alias DateTime =
    Time.Posix


type alias Url =
    Url.Url


type PageCursor
    = PageCursor String


type alias RawCodec val =
    { encoder : val -> Encode.Value
    , decoder : Decode.Decoder val
    }


{-| This is essentially the `Never` we use in the graphql schema.
This is used for empty records on Unions.
However we cant call this Never in Elm because there is already a never.
So, we have Skip instead.
Separately, this type should never be used outside of this module, so we wont expose it.
-}
type Never
    = Never


{-| -}
type Presence
    = Present

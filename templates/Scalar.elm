module Scalar exposing
    ( Codec
    , ColumnId(..)
    , DateTime
    , Id(..)
    , Iso4217(..)
    , Json(..)
    , Markdown(..)
    , Never(..)
    , PageCursor(..)
    , Presence(..)
    , RawCodec
    , SurveyId(..)
    , Url
    , ViewId(..)
    , columnId
    , dateTime
    , fakeUrl
    , id
    , iso4217
    , json
    , markdown
    , never
    , pageCursor
    , presence
    , surveyId
    , url
    , viewId
    )

import GraphQL.Engine as Engine
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Time
import Url


type alias Codec scalar =
    { encode : scalar -> Encode.Value
    , decoder : Decoder scalar
    }


url =
    { encode = Url.toString >> String.trim >> String.replace " " "%20" >> Encode.string
    , decoder =
        Decode.string
            |> Decode.andThen
                (\urlString ->
                    case Url.fromString urlString of
                        Nothing ->
                            Decode.fail ("Not a valid url: " ++ urlString)

                        Just successfulUrl ->
                            Decode.succeed successfulUrl
                )
    }


id =
    { encode = \(Id raw) -> Encode.string raw
    , decoder = Decode.string |> Decode.map Id
    }


dateTime =
    { encode = Iso8601.encode
    , decoder = Iso8601.decoder
    }


iso4217 =
    { encode = \(Iso4217 raw) -> Encode.string raw
    , decoder = Decode.string |> Decode.map Iso4217
    }


markdown =
    { encode = \(Markdown raw) -> Encode.string raw
    , decoder = Decode.string |> Decode.map Markdown
    }


pageCursor =
    { encode = \(PageCursor raw) -> Encode.string raw
    , decoder = Decode.string |> Decode.map PageCursor
    }


json =
    { encode = \(Json raw) -> Encode.string raw
    , decoder = Decode.string |> Decode.map Json
    }


viewId =
    { encode = \(ViewId raw) -> Encode.string raw
    , decoder = Decode.string |> Decode.map ViewId
    }


columnId =
    { encode = \(ColumnId raw) -> Encode.string raw
    , decoder = Decode.string |> Decode.map ColumnId
    }


surveyId =
    { encode = \(SurveyId raw) -> Encode.string raw
    , decoder = Decode.string |> Decode.map SurveyId
    }


never =
    { encode = \Never -> Encode.string "Never"
    , decoder = Decode.string |> Decode.map (always Never)
    }


presence =
    { encode = \Present -> Encode.string "Present"
    , decoder = Decode.string |> Decode.map (always Present)
    }


type Id
    = Id String


type SurveyId
    = SurveyId String


type ViewId
    = ViewId String


type ColumnId
    = ColumnId String


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


fakeUrl : Url
fakeUrl =
    { protocol = Url.Https
    , host = "example.com"
    , port_ = Just 443
    , path = "/"
    , query = Nothing
    , fragment = Nothing
    }

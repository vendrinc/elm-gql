module GraphQL.Schema.Operation exposing (Operation, decoder)

import Dict exposing (Dict)
import GraphQL.Schema.Argument as Argument exposing (Argument)
import GraphQL.Schema.Deprecation as Deprecation exposing (Deprecation)
import GraphQL.Schema.Permission as Permission exposing (Permission)
import GraphQL.Schema.Type as Type exposing (Type)
import Json.Decode as Json
import Utils.Json


type alias Operation =
    { name : String
    , deprecation : Deprecation
    , description : Maybe String
    , arguments : List Argument
    , type_ : Type
    , permissions : List Permission
    }


decoder : Json.Decoder (Dict String Operation)
decoder =
    let
        tupleDecoder : Json.Decoder ( String, Maybe Operation )
        tupleDecoder =
            Json.map2 Tuple.pair
                (Json.field "name" Json.string)
                operationDecoder
    in
    Json.map Dict.fromList
        (Json.field "fields"
            (Json.list tupleDecoder
                |> Json.map
                    (List.filterMap
                        (\( name, maybeOperation ) ->
                            maybeOperation |> Maybe.map (Tuple.pair name)
                        )
                    )
            )
        )


operationDecoder : Json.Decoder (Maybe Operation)
operationDecoder =
    Utils.Json.filterHidden <|
        Json.map6 Operation
            (Json.field "name" Json.string)
            Deprecation.decoder
            (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
            (Json.field "args" (Json.list Argument.decoder))
            (Json.field "type" Type.decoder)
            Permission.decoder

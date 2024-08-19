module GraphQL.InputObject exposing
    ( InputObject, inputObject
    , addField, addOptionalField
    , maybe
    , encode, toFieldList
    , raw
    )

{-|

@docs InputObject, inputObject

@docs addField, addOptionalField

@docs maybe

@docs encode, toFieldList

@docs raw

-}

import GraphQL.Engine exposing (Option(..))
import Json.Encode
import Set


{-| We can also accept:

  - Enum values (unquoted)
  - custom scalars

But we can define anything else in terms of these:

-}
type Argument obj
    = ArgValue Json.Encode.Value String
    | Var String


{-| -}
type InputObject value
    = InputObject String (List ( String, VariableDetails ))


type alias VariableDetails =
    { gqlTypeName : String
    , value : Maybe Json.Encode.Value
    }


{-| -}
inputObject : String -> InputObject value
inputObject name =
    InputObject name []


{-| -}
raw : String -> List ( String, VariableDetails ) -> InputObject value
raw =
    InputObject


{-| -}
addField : String -> String -> Json.Encode.Value -> InputObject value -> InputObject value
addField fieldName gqlFieldType val (InputObject name inputFields) =
    InputObject name
        (inputFields
            ++ [ ( fieldName
                 , { gqlTypeName = gqlFieldType
                   , value = Just val
                   }
                 )
               ]
        )


{-| -}
addOptionalField : String -> String -> Option value -> (value -> Json.Encode.Value) -> InputObject input -> InputObject input
addOptionalField fieldName gqlFieldType optionalValue toJsonValue (InputObject name inputFields) =
    let
        newField =
            case optionalValue of
                Absent ->
                    ( fieldName, { value = Nothing, gqlTypeName = gqlFieldType } )

                Null ->
                    ( fieldName, { value = Just Json.Encode.null, gqlTypeName = gqlFieldType } )

                Present val ->
                    ( fieldName, { value = Just (toJsonValue val), gqlTypeName = gqlFieldType } )
    in
    InputObject name (inputFields ++ [ newField ])


{-| -}
type Optional arg
    = Optional String (Argument arg)


{-| -}
toFieldList : InputObject a -> List ( String, VariableDetails )
toFieldList (InputObject _ fields) =
    fields


{-| -}
encode : InputObject value -> Json.Encode.Value
encode (InputObject _ fields) =
    fields
        |> List.filterMap
            (\( varName, var ) ->
                case var.value of
                    Nothing ->
                        Nothing

                    Just value ->
                        Just ( varName, value )
            )
        |> Json.Encode.object


{-| -}
encodeOptionals : List (Optional arg) -> List ( String, Argument arg )
encodeOptionals opts =
    List.foldl
        (\(Optional optName argument) (( found, gathered ) as skip) ->
            if Set.member optName found then
                skip

            else
                ( Set.insert optName found
                , ( optName, argument ) :: gathered
                )
        )
        ( Set.empty, [] )
        opts
        |> Tuple.second


{-| -}
maybe : (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
maybe encoder maybeA =
    maybeA
        |> Maybe.map encoder
        |> Maybe.withDefault Json.Encode.null

export default (): string => "module GraphQL.Input exposing\n    ( InputObject, inputObject\n    , addField, addOptionalField\n    , maybeScalarEncode\n    , encode, toFieldList\n    )\n\n{-|\n\n@docs InputObject, inputObject\n\n@docs addField, addOptionalField\n\n@docs maybeScalarEncode\n\n@docs encode, toFieldList\n\n-}\n\nimport GraphQL.Engine exposing (Option(..))\nimport Json.Encode\nimport Set\n\n\n{-| We can also accept:\n\n  - Enum values (unquoted)\n  - custom scalars\n\nBut we can define anything else in terms of these:\n\n-}\ntype Argument obj\n    = ArgValue Json.Encode.Value String\n    | Var String\n\n\n{-| -}\ntype InputObject value\n    = InputObject String (List ( String, VariableDetails ))\n\n\ntype alias VariableDetails =\n    { gqlTypeName : String\n    , value : Maybe Json.Encode.Value\n    }\n\n\n{-| -}\ninputObject : String -> InputObject value\ninputObject name =\n    InputObject name []\n\n\n{-| -}\naddField : String -> String -> Json.Encode.Value -> InputObject value -> InputObject value\naddField fieldName gqlFieldType val (InputObject name inputFields) =\n    InputObject name\n        (inputFields\n            ++ [ ( fieldName\n                 , { gqlTypeName = gqlFieldType\n                   , value = Just val\n                   }\n                 )\n               ]\n        )\n\n\n{-| -}\naddOptionalField : String -> String -> Option value -> (value -> Json.Encode.Value) -> InputObject input -> InputObject input\naddOptionalField fieldName gqlFieldType optionalValue toJsonValue (InputObject name inputFields) =\n    let\n        newField =\n            case optionalValue of\n                Absent ->\n                    ( fieldName, { value = Nothing, gqlTypeName = gqlFieldType } )\n\n                Null ->\n                    ( fieldName, { value = Just Json.Encode.null, gqlTypeName = gqlFieldType } )\n\n                Present val ->\n                    ( fieldName, { value = Just (toJsonValue val), gqlTypeName = gqlFieldType } )\n    in\n    InputObject name (inputFields ++ [ newField ])\n\n\n{-| -}\ntype Optional arg\n    = Optional String (Argument arg)\n\n\n{-| -}\ntoFieldList : InputObject a -> List ( String, VariableDetails )\ntoFieldList (InputObject _ fields) =\n    fields\n\n\n{-| -}\nencode : InputObject value -> Json.Encode.Value\nencode (InputObject _ fields) =\n    fields\n        |> List.filterMap\n            (\\( varName, var ) ->\n                case var.value of\n                    Nothing ->\n                        Nothing\n\n                    Just value ->\n                        Just ( varName, value )\n            )\n        |> Json.Encode.object\n\n\n{-| -}\nencodeOptionals : List (Optional arg) -> List ( String, Argument arg )\nencodeOptionals opts =\n    List.foldl\n        (\\(Optional optName argument) (( found, gathered ) as skip) ->\n            if Set.member optName found then\n                skip\n\n            else\n                ( Set.insert optName found\n                , ( optName, argument ) :: gathered\n                )\n        )\n        ( Set.empty, [] )\n        opts\n        |> Tuple.second\n\n\n{-| -}\nmaybeScalarEncode : (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value\nmaybeScalarEncode encoder maybeA =\n    maybeA\n        |> Maybe.map encoder\n        |> Maybe.withDefault Json.Encode.null\n"
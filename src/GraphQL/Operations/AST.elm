module GraphQL.Operations.AST exposing (..)

import Utils.Pretty as Pretty exposing (PrettyPrinter)


type Name
    = Name String


prettyPrintName : Name -> PrettyPrinter -> PrettyPrinter
prettyPrintName (Name value) pp =
    Pretty.write value pp


type alias Variable =
    { name : Name
    }


prettyPrintVariable : Variable -> PrettyPrinter -> PrettyPrinter
prettyPrintVariable variable pp =
    pp
        |> Pretty.write "$"
        |> prettyPrintName variable.name


type Value
    = StringValue String
    | IntValue Int
    | FloatValue Float
    | BoolValue Bool
    | NullValue
    | EnumValue Name
    | VariableValue Variable
    | ObjectValue (List ( Name, Value ))
    | ListValue (List Value)


boolToString b =
    if b then
        "True"

    else
        "False"


prettyPrintValue : Value -> PrettyPrinter -> PrettyPrinter
prettyPrintValue value pp =
    case value of
        StringValue string ->
            Pretty.write ("\"" ++ string ++ "\"") pp

        IntValue int ->
            Pretty.write (String.fromInt int) pp

        FloatValue float ->
            Pretty.write (String.fromFloat float) pp

        BoolValue bool ->
            Pretty.write (String.toLower <| boolToString bool) pp

        NullValue ->
            Pretty.write "null" pp

        EnumValue name ->
            prettyPrintName name pp

        VariableValue variable ->
            prettyPrintVariable variable pp

        ObjectValue fields ->
            pp
                |> Pretty.write "{\n"
                |> Pretty.indent
                |> (\pp_ ->
                        List.foldl
                            (\( name, v ) memo ->
                                memo
                                    |> prettyPrintName name
                                    |> Pretty.write ": "
                                    |> prettyPrintValue v
                                    |> Pretty.write "\n"
                            )
                            pp_
                            fields
                   )
                |> Pretty.unindent
                |> Pretty.write "}"

        ListValue values ->
            pp
                |> Pretty.write "[\n"
                |> Pretty.indent
                |> (\printer ->
                        List.foldl
                            (\v memo ->
                                memo
                                    |> prettyPrintValue v
                                    |> Pretty.write "\n"
                            )
                            printer
                            values
                   )
                |> Pretty.unindent
                |> Pretty.write "]"


type Selection
    = FieldSelection Field
    | FragmentSpreadSelection FragmentSpread
    | InlineFragmentSelection InlineFragment


type alias Field =
    { alias_ : Maybe Name
    , name : Name
    , arguments : List Argument
    , directives : List Directive
    , selectionSet : List Selection
    }


type alias Argument =
    { name : Name
    , value : Value
    }



-- prettyPrintArgument argument =
-- prettyPrintName argument.name ++ ": " ++ prettyPrintValue argument.value


type alias Directive =
    { name : Name
    , arguments : List Argument
    }


type alias FragmentSpread =
    { name : Name
    , directives : List Directive
    }


type alias InlineFragment =
    { typeCondition : NamedType
    , directives : List Directive
    , selectionSet : List Selection
    }


type alias NamedType =
    { name : Name
    }


type alias ListType =
    { type_ : Type
    }


type NonNullType
    = NamedNonNull NamedType
    | ListNonNull ListType


type Type
    = NamedTypeType NamedType
    | ListTypeType ListType
    | NonNullTypeType NonNullType


type alias Fragment =
    { name : Name
    , typeCondition : NamedType
    , directives : List Directive
    , selectionSet : List Selection
    }


type OperationType
    = Query
    | Mutation


type alias Operation =
    { operationType : OperationType
    , name : Maybe Name
    , variableDefinitions : List VariableDefinition
    , directives : List Directive
    , selectionSet : List Selection
    }


type alias VariableDefinition =
    { variable : Variable
    , type_ : Type
    , defaultValue : Maybe Value
    }


type Definition
    = FragmentDefinition Fragment
    | OperationDefinition Operation


type alias Document =
    { definitions : List Definition
    }


prettyPrint : Document -> String
prettyPrint document =
    ""

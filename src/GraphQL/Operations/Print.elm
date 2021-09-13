module GraphQL.Operations.Print exposing (..)

import GraphQL.Operations.AST exposing (..)
import Utils.Pretty as Pretty exposing (PrettyPrinter)


prettyPrint : Document -> String
prettyPrint document =
    ""


prettyPrintVariable : Variable -> PrettyPrinter -> PrettyPrinter
prettyPrintVariable variable pp =
    pp
        |> Pretty.write "$"
        |> prettyPrintName variable.name


prettyPrintName : Name -> PrettyPrinter -> PrettyPrinter
prettyPrintName (Name value) pp =
    Pretty.write value pp


boolToString : Bool -> String
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

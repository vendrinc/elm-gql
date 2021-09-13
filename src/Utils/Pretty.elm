module Utils.Pretty exposing (..)

type PrettyPrinter
    = PrettyPrinter Int String


indent : PrettyPrinter -> PrettyPrinter
indent (PrettyPrinter i s) =
    PrettyPrinter (i + 2) s


unindent : PrettyPrinter -> PrettyPrinter
unindent (PrettyPrinter i s) =
    if i == 0 then
        PrettyPrinter i s
    else
        PrettyPrinter (i - 2) s


write : String -> PrettyPrinter -> PrettyPrinter
write value (PrettyPrinter i s) =
    if String.isEmpty s then
        value
            |> ((++) (String.repeat i " "))
            |> String.split "\n"
            |> String.join ("\n" ++ String.repeat i " ")
            |> PrettyPrinter i
    else
        value
            |> String.split "\n"
            |> String.join ("\n" ++ String.repeat i " ")
            |> PrettyPrinter i


start : PrettyPrinter
start =
    PrettyPrinter 0 ""


toString : PrettyPrinter -> String
toString (PrettyPrinter i s) =
    s
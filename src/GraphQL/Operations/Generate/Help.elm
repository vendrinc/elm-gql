module GraphQL.Operations.Generate.Help exposing (renderStandardComment, replaceFilePath)


replaceFilePath : String -> { a | path : String } -> { a | path : String }
replaceFilePath newPath file =
    { file
        | path = newPath
    }


renderStandardComment :
    List
        { group : Maybe String
        , members : List String
        }
    -> String
renderStandardComment groups =
    if List.isEmpty groups then
        ""

    else
        List.foldl
            (\grouped str ->
                str ++ "@docs " ++ String.join ", " grouped.members ++ "\n\n"
            )
            "\n\n"
            groups

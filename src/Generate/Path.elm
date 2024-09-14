module Generate.Path exposing (Paths, fragment, fragmentGlobal, operation)

import Utils.String


isDot : String -> Bool
isDot str =
    str == "."


fragment :
    { name : String

    -- all the dirs between CWD and the GQL file
    , path : String

    -- all the directories between CWD and the Elm root
    , queryDir : List String
    }
    -> Paths
fragment { name, path, queryDir } =
    let
        fragName =
            Utils.String.formatTypename name

        moduleName =
            pathFromElmRootToGqlFile ++ [ "Fragments", fragName ]

        -- The path between elm root and the gql file
        pathFromElmRootToGqlFile =
            path
                |> String.split "/"
                |> List.map
                    (String.replace ".gql" ""
                        >> String.replace ".graphql" ""
                    )
                |> removePrefix (List.filter (not << isDot) queryDir)
                |> List.map
                    Utils.String.formatTypename

        filePathPieces =
            queryDir
                ++ pathFromElmRootToGqlFile
                ++ [ "Fragments", fragName ]

        mockFilePathPieces =
            queryDir
                ++ pathFromElmRootToGqlFile
                ++ [ "Mock", "Fragments", fragName ]
    in
    { modulePath = moduleName
    , mockModulePath = pathFromElmRootToGqlFile ++ [ "Mock", "Fragments", fragName ]
    , filePath =
        String.join "/" filePathPieces ++ ".elm"
    , mockModuleFilePath =
        String.join "/" mockFilePathPieces ++ ".elm"
    }


fragmentGlobal :
    { name : String
    , namespace : String

    -- all the dirs between CWD and the GQL file
    , path : String

    -- all the directories between CWD and the Elm root
    , queryDir : List String
    }
    -> Paths
fragmentGlobal { name, path, queryDir, namespace } =
    let
        fragName =
            Utils.String.formatTypename name

        moduleName =
            [ namespace, "Fragments", fragName ]

        -- The path between elm root and the gql file
        pathFromElmRootToGqlFile =
            path
                |> String.split "/"
                |> List.map
                    (String.replace ".gql" ""
                        >> String.replace ".graphql" ""
                    )
                |> removePrefix (List.filter (not << isDot) queryDir)
                |> List.map
                    Utils.String.formatTypename

        filePathPieces =
            queryDir
                ++ pathFromElmRootToGqlFile
                ++ [ namespace, "Fragments", fragName ]

        mockFilePathPieces =
            queryDir
                ++ pathFromElmRootToGqlFile
                ++ [ namespace, "Mock", "Fragments", fragName ]
    in
    { modulePath = moduleName
    , mockModulePath = [ namespace, "Mock", "Fragments", fragName ]
    , filePath =
        String.join "/" filePathPieces ++ ".elm"
    , mockModuleFilePath =
        String.join "/" mockFilePathPieces ++ ".elm"
    }


type alias Paths =
    { modulePath : List String
    , mockModulePath : List String
    , filePath : String
    , mockModuleFilePath : String
    }


operation :
    { name : String

    -- all the dirs between CWD and the GQL file
    , path : String

    -- all the directories between CWD and the Elm root
    , queryDir : List String
    }
    ->
        { modulePath : List String
        , mockModulePath : List String
        , filePath : String
        , mockModuleFilePath : String
        }
operation { name, path, queryDir } =
    let
        fragName =
            Utils.String.formatTypename name

        -- The path between elm root and the gql file
        pathFromElmRootToGqlFile =
            path
                |> String.split "/"
                |> List.map
                    (String.replace ".gql" ""
                        >> String.replace ".graphql" ""
                    )
                |> removePrefix (List.filter (not << isDot) queryDir)
                |> List.map Utils.String.formatTypename

        filePathPieces =
            queryDir
                ++ pathFromElmRootToGqlFile
                ++ [ fragName ]

        mockFilePathPieces =
            queryDir
                ++ pathFromElmRootToGqlFile
                ++ [ "Mock", fragName ]
    in
    { modulePath = pathFromElmRootToGqlFile ++ [ fragName ]
    , mockModulePath = pathFromElmRootToGqlFile ++ [ "Mock", fragName ]
    , filePath =
        String.join "/" filePathPieces ++ ".elm"
    , mockModuleFilePath =
        String.join "/" mockFilePathPieces ++ ".elm"
    }


removePrefix prefix list =
    case prefix of
        [] ->
            list

        _ :: remainPref ->
            case list of
                [] ->
                    list

                _ :: remain ->
                    removePrefix remainPref remain

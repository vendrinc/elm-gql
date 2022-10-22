module Generate.Path exposing (fragment, operation)

import Utils.String


fragment :
    { name : String

    -- all the dirs between CWD and the GQL file
    , path : String

    -- all the directories between CWD and the Elm root
    , gqlDir : List String
    }
    -> { modulePath : List String, filePath : String }
fragment { name, path, gqlDir } =
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
                |> removePrefix gqlDir
                |> List.map Utils.String.formatTypename

        filePathPieces =
            gqlDir
                ++ pathFromElmRootToGqlFile
                ++ [ "Fragments", fragName ]
    in
    { modulePath = pathFromElmRootToGqlFile ++ [ "Fragments", fragName ]
    , filePath =
        String.join "/" filePathPieces ++ ".elm"
    }


operation :
    { name : String

    -- all the dirs between CWD and the GQL file
    , path : String

    -- all the directories between CWD and the Elm root
    , gqlDir : List String
    }
    -> { modulePath : List String, filePath : String }
operation { name, path, gqlDir } =
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
                |> removePrefix gqlDir
                |> List.map Utils.String.formatTypename

        filePathPieces =
            gqlDir
                ++ pathFromElmRootToGqlFile
                ++ [ fragName ]
    in
    { modulePath = pathFromElmRootToGqlFile ++ [ fragName ]
    , filePath =
        String.join "/" filePathPieces ++ ".elm"
    }


removePrefix prefix list =
    case prefix of
        [] ->
            list

        pref :: remainPref ->
            case list of
                [] ->
                    list

                first :: remain ->
                    removePrefix remainPref remain

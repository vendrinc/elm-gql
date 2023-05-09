module Generate.Common exposing (modules)

import Utils.String


modules =
    { enum =
        \namespace enumName ->
            [ namespace.enums
            , "Enum"
            , Utils.String.formatTypename enumName
            ]
    , enumSourceModule =
        \namespace enumName ->
            [ namespace.namespace
            , "Enum"
            , Utils.String.formatTypename enumName
            ]
    , query =
        \namespace queryName ->
            [ namespace
            , "Queries"
            , Utils.String.formatTypename queryName
            ]
    , mutation =
        \namespace mutationName ->
            [ namespace
            , "Mutations"
            , Utils.String.formatTypename mutationName
            ]
    , input =
        \namespace name ->
            [ namespace
            , Utils.String.formatTypename name
            ]
    }

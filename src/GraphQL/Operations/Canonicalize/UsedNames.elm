module GraphQL.Operations.Canonicalize.UsedNames exposing
    ( UsedNames, init
    , addLevel, addLevelKeepSiblingStack, dropLevel, dropLevelNotSiblings, getGlobalName
    , saveSibling, siblingCollision
    , Sibling, levelFromField
    )

{-|

@docs UsedNames, init

@docs addLevel, addLevelKeepSiblingStack, dropLevel, dropLevelNotSiblings, getGlobalName

@docs saveSibling, siblingCollision

-}

import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can


init : List String -> UsedNames
init names =
    UsedNames
        { siblingAliases = []
        , siblingStack = []
        , breadcrumbs = []
        , globalNames =
            List.map formatTypename names
        }


type UsedNames
    = UsedNames
        -- sibling errors will cause a compiler error if there is a collision
        { siblingAliases : List Sibling
        , siblingStack : List (List Sibling)

        -- All parent aliased names
        -- we keep track of if something is an alias because
        -- it can be really intuitive to just use aliases to generate names
        , breadcrumbs :
            List
                { name : String
                , isAlias : Bool
                }

        -- All global field aliases
        , globalNames : List String
        }


type alias Sibling =
    { aliasedName : String
    , selection : List AST.Selection
    }


builtinNames : List String
builtinNames =
    [ "List"
    , "String"
    , "Maybe"
    , "Result"
    , "Bool"
    , "Float"
    , "Int"
    ]


formatTypename : String -> String
formatTypename name =
    let
        first =
            String.left 1 name

        uppercase =
            String.toUpper first ++ String.dropLeft 1 name
    in
    if List.member uppercase builtinNames then
        uppercase ++ "_"

    else
        uppercase


saveSibling : Sibling -> UsedNames -> UsedNames
saveSibling sibling (UsedNames used) =
    UsedNames
        { used
            | siblingAliases = sibling :: used.siblingAliases
        }


siblingCollision : Sibling -> UsedNames -> Bool
siblingCollision sib (UsedNames used) =
    List.any
        (\sibAlias ->
            if sibAlias.aliasedName == sib.aliasedName then
                sibAlias.selection /= sib.selection

            else
                False
        )
        used.siblingAliases


{-|

    This will retrieve a globally unique name.
    The intention is that an aliased name is passed in.
    If it's used, then this returns nothing
    and the query should fail to compile.
    If not, then a new globally unique name is returend that can be used for code generation.

-}
getGlobalName : String -> UsedNames -> { globalName : String, used : UsedNames }
getGlobalName rawName (UsedNames used) =
    if rawName == "__typename" then
        { used = UsedNames used
        , globalName = "__typename"
        }

    else
        let
            name =
                formatTypename rawName

            newGlobalName =
                if List.member name used.globalNames then
                    let
                        allAliases =
                            List.filter .isAlias used.breadcrumbs
                    in
                    case allAliases of
                        [] ->
                            case used.breadcrumbs of
                                [] ->
                                    -- shouldnt happen
                                    name

                                top :: _ ->
                                    let
                                        unaliasedName =
                                            top.name ++ "_" ++ name
                                    in
                                    if List.member unaliasedName used.globalNames then
                                        String.join "_" (List.reverse (List.map .name used.breadcrumbs)) ++ "_" ++ name

                                    else
                                        unaliasedName

                        topAlias :: _ ->
                            let
                                aliasedName =
                                    topAlias.name ++ "_" ++ name
                            in
                            if List.member aliasedName used.globalNames then
                                String.join "_" (List.reverse (List.map .name used.breadcrumbs)) ++ "_" ++ name

                            else
                                aliasedName

                else
                    name
        in
        { used =
            UsedNames
                { used
                    | globalNames =
                        newGlobalName :: used.globalNames
                }
        , globalName = newGlobalName
        }


levelFromField :
    { field
        | name : AST.Name
        , alias_ : Maybe AST.Name
    }
    ->
        { name : String
        , isAlias : Bool
        }
levelFromField field =
    let
        aliased =
            field.alias_
                |> Maybe.withDefault field.name
                |> convertName
                |> Can.nameToString
    in
    { name = formatTypename aliased
    , isAlias = field.alias_ /= Nothing
    }


{-|

    levels should be the alias name

-}
addLevel :
    { name : String
    , isAlias : Bool
    }
    -> UsedNames
    -> UsedNames
addLevel level (UsedNames used) =
    UsedNames
        { used
            | breadcrumbs =
                { name = formatTypename level.name
                , isAlias = level.isAlias
                }
                    :: used.breadcrumbs
            , siblingStack = used.siblingAliases :: used.siblingStack
            , siblingAliases = []
        }


{-|

    levels should be the alias name

-}
addLevelKeepSiblingStack :
    { name : String
    , isAlias : Bool
    }
    -> UsedNames
    -> UsedNames
addLevelKeepSiblingStack level (UsedNames used) =
    UsedNames
        { used
            | breadcrumbs =
                { name = formatTypename level.name
                , isAlias = level.isAlias
                }
                    :: used.breadcrumbs
        }


convertName : AST.Name -> Can.Name
convertName (AST.Name str) =
    Can.Name str


{-| -}
dropLevelNotSiblings : UsedNames -> UsedNames
dropLevelNotSiblings (UsedNames used) =
    UsedNames
        { used
            | breadcrumbs = List.drop 1 used.breadcrumbs
        }


{-| -}
dropLevel : UsedNames -> UsedNames
dropLevel (UsedNames used) =
    UsedNames
        { used
            | breadcrumbs = List.drop 1 used.breadcrumbs
            , siblingStack = List.drop 1 used.siblingStack
            , siblingAliases =
                List.head used.siblingStack
                    |> Maybe.withDefault []
        }

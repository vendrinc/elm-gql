module GraphQL.Operations.Canonicalize.UsedNames exposing
    ( UsedNames, init
    , addLevel, dropLevel, getGlobalName
    , saveSibling, resetSiblings, siblingCollision
    , levelFromField
    )

{-|

@docs UsedNames, init

@docs addLevel, dropLevel, getGlobalName

@docs saveSibling, resetSiblings, siblingCollision

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
        { siblingAliases : List String
        , siblingStack : List (List String)

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


saveSibling : String -> UsedNames -> UsedNames
saveSibling name (UsedNames used) =
    UsedNames
        { used
            | siblingAliases = formatTypename name :: used.siblingAliases
        }


siblingCollision : String -> UsedNames -> Bool
siblingCollision name (UsedNames used) =
    List.member (formatTypename name) used.siblingAliases


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

                                top :: remain ->
                                    let
                                        unaliasedName =
                                            top.name ++ "_" ++ name
                                    in
                                    if List.member unaliasedName used.globalNames then
                                        String.join "_" (List.reverse (List.map .name used.breadcrumbs)) ++ "_" ++ name

                                    else
                                        unaliasedName

                        topAlias :: remainingAliases ->
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


convertName : AST.Name -> Can.Name
convertName (AST.Name str) =
    Can.Name str


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


{-| -}
resetSiblings : UsedNames -> UsedNames -> UsedNames
resetSiblings (UsedNames to) (UsedNames used) =
    UsedNames
        { used
            | siblingAliases =
                to.siblingAliases
        }

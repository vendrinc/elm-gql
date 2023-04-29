module GraphQL.Operations.Canonicalize.Cache exposing
    ( init, Cache
    , addVars, addFragment
    , addLevel, addLevelKeepSiblingStack, getGlobalName
    , dropLevel, dropLevelNotSiblings
    , saveSibling, siblingCollision
    , levelFromField
    , enum, field, inputObject, mutation, query, scalar
    )

{-|

@docs init, Cache

@docs addVars, addFragment


## Name Usage

@docs addLevel, addLevelKeepSiblingStack, getGlobalName

@docs dropLevel, dropLevelNotSiblings

@docs saveSibling, siblingCollision

@docs levelFromField


## Tracking Usage

@docs enum, field, inputObject, interface, mutation, query, scalar

-}

import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Canonicalize.UsedNames as UsedNames
import GraphQL.Schema
import GraphQL.Usage as Usage


init : { reservedNames : List String } -> Cache
init options =
    { varTypes = []
    , fragmentsUsed = []
    , usedNames = UsedNames.init options.reservedNames
    , usage = Usage.init
    }


type alias Cache =
    { varTypes : List ( String, GraphQL.Schema.Type )
    , fragmentsUsed :
        -- NOTE: WE capture alongsideOtherFields in order to inform code generation
        -- If the fragment is selected by itself, then we can generate a record specifically for that fragment
        -- otherwise, we only generate stuff for it's downstream stuff.
        List
            { fragment : Can.Fragment
            , alongsideOtherFields : Bool
            }
    , usedNames : UsedNames.UsedNames
    , usage : Usage.Usages
    }


addVars : List ( String, GraphQL.Schema.Type ) -> Cache -> Cache
addVars vars cache =
    { varTypes =
        vars ++ cache.varTypes
    , fragmentsUsed = cache.fragmentsUsed
    , usedNames = cache.usedNames
    , usage = cache.usage
    }


addFragment :
    { fragment : Can.Fragment
    , alongsideOtherFields : Bool
    }
    -> Cache
    -> Cache
addFragment frag cache =
    { varTypes =
        cache.varTypes
    , fragmentsUsed = frag :: cache.fragmentsUsed
    , usedNames = cache.usedNames
    , usage = cache.usage
    }



{- Track used names -}


onNames : (UsedNames.UsedNames -> UsedNames.UsedNames) -> Cache -> Cache
onNames fn cache =
    { cache
        | usedNames = fn cache.usedNames
    }


addLevelKeepSiblingStack :
    { name : String
    , isAlias : Bool
    }
    -> Cache
    -> Cache
addLevelKeepSiblingStack options =
    onNames (UsedNames.addLevelKeepSiblingStack options)


addLevel :
    { name : String
    , isAlias : Bool
    }
    -> Cache
    -> Cache
addLevel level =
    onNames (UsedNames.addLevel level)


dropLevel : Cache -> Cache
dropLevel =
    onNames UsedNames.dropLevel


dropLevelNotSiblings : Cache -> Cache
dropLevelNotSiblings =
    onNames UsedNames.dropLevelNotSiblings


getGlobalName : String -> Cache -> { globalName : String, used : Cache }
getGlobalName rawName cache =
    let
        { used, globalName } =
            UsedNames.getGlobalName rawName cache.usedNames
    in
    { globalName = globalName
    , used =
        { cache
            | usedNames = used
        }
    }


saveSibling :
    UsedNames.Sibling
    -> Cache
    -> Cache
saveSibling sibling =
    onNames (UsedNames.saveSibling sibling)


siblingCollision :
    UsedNames.Sibling
    -> Cache
    -> Bool
siblingCollision sibling cache =
    UsedNames.siblingCollision sibling cache.usedNames


levelFromField :
    { field
        | name : AST.Name
        , alias_ : Maybe AST.Name
    }
    ->
        { name : String
        , isAlias : Bool
        }
levelFromField =
    UsedNames.levelFromField



{- Tracking Usage -}


type alias FilePath =
    String


onUsage : (Usage.Usages -> Usage.Usages) -> Cache -> Cache
onUsage fn cache =
    { cache
        | usage = fn cache.usage
    }


query : String -> FilePath -> Cache -> Cache
query name file =
    onUsage (Usage.query name file)


mutation : String -> FilePath -> Cache -> Cache
mutation name file =
    onUsage (Usage.mutation name file)


field : String -> String -> FilePath -> Cache -> Cache
field name fieldName path =
    onUsage (Usage.field name fieldName path)


scalar : String -> FilePath -> Cache -> Cache
scalar name path =
    onUsage (Usage.scalar name path)


enum : String -> FilePath -> Cache -> Cache
enum name path =
    onUsage (Usage.enum name path)


inputObject : String -> String -> FilePath -> Cache -> Cache
inputObject name fieldName path =
    onUsage (Usage.inputObject name fieldName path)

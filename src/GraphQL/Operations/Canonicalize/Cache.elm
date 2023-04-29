module GraphQL.Operations.Canonicalize.Cache exposing
    ( init, Cache
    , addVars, addFragment
    , addLevel, addLevelKeepSiblingStack, getGlobalName
    , dropLevel, dropLevelNotSiblings
    , saveSibling, siblingCollision
    , levelFromField
    )

{-|

@docs init, Cache

@docs addVars, addFragment


## Name Usage

@docs addLevel, addLevelKeepSiblingStack, getGlobalName

@docs dropLevel, dropLevelNotSiblings

@docs saveSibling, siblingCollision

@docs levelFromField

-}

import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Canonicalize.UsedNames as UsedNames
import GraphQL.Schema
import GraphQL.Usage


init : { reservedNames : List String } -> Cache
init options =
    { varTypes = []
    , fragmentsUsed = []
    , usedNames = UsedNames.init options.reservedNames
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
    }


addVars : List ( String, GraphQL.Schema.Type ) -> Cache -> Cache
addVars vars cache =
    { varTypes =
        vars ++ cache.varTypes
    , fragmentsUsed = cache.fragmentsUsed
    , usedNames = cache.usedNames
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
    }



-- merge : Cache -> Cache -> Cache
-- merge one two =
--     { varTypes =
--         one.varTypes ++ two.varTypes
--     , fragmentsUsed =
--         one.fragmentsUsed ++ two.fragmentsUsed
--     , usedNames = one.usedNames
--     }
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

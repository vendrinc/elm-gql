module GraphQL.Operations.Canonicalize.Cache exposing
    ( empty, Cache, merge
    , addVars, addFragment
    )

{-|

@docs empty, Cache, merge

@docs addVars, addFragment

-}

import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Schema


empty : Cache
empty =
    { varTypes = []
    , fragmentsUsed = []
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
    }


addVars : List ( String, GraphQL.Schema.Type ) -> Cache -> Cache
addVars vars cache =
    { varTypes =
        vars ++ cache.varTypes
    , fragmentsUsed = cache.fragmentsUsed
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
    }


merge : Cache -> Cache -> Cache
merge one two =
    { varTypes =
        one.varTypes ++ two.varTypes
    , fragmentsUsed =
        one.fragmentsUsed ++ two.fragmentsUsed
    }

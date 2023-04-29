module GraphQL.Usage exposing
    ( Usage, init
    , enum, field, input, interface, mutation, query, scalar, union
    )

{-|

@docs Usage, init

@docs enum, field, input, interface, mutation, query, scalar, union

@docs toUnusedReport

-}

import GraphQL.Schema


init : Usages
init =
    Usages []


type Usages
    = Usages (List Usage)


type alias Usage =
    { usedIn : FilePath
    , type_ : Type
    }


type alias FilePath =
    String


type Type
    = Query String
    | Mutation String
    | Object
        { name : String
        , field : String
        }
    | Scalar String
    | InputObject
        { name : String
        , field : String
        }
    | Enum String
    | Union
        { name : String
        }
    | Interface
        { name : String
        , field : String
        }


query : String -> FilePath -> Usages -> Usages
query name =
    used (Query name)


mutation : String -> FilePath -> Usages -> Usages
mutation name =
    used (Mutation name)


field : String -> String -> FilePath -> Usages -> Usages
field name fieldName =
    used (Object { name = name, field = fieldName })


scalar : String -> FilePath -> Usages -> Usages
scalar name =
    used (Scalar name)


enum : String -> FilePath -> Usages -> Usages
enum name =
    used (Enum name)


union : String -> FilePath -> Usages -> Usages
union name =
    used (Union { name = name })


input : String -> String -> FilePath -> Usages -> Usages
input name fieldName =
    used (InputObject { name = name, field = fieldName })


interface : String -> String -> FilePath -> Usages -> Usages
interface name fieldName =
    used (Interface { name = name, field = fieldName })


used : Type -> FilePath -> Usages -> Usages
used kind filepath (Usages list) =
    let
        new =
            { usedIn = filepath
            , type_ = kind
            }
    in
    Usages (new :: list)


merge : Usages -> Usages -> Usages
merge (Usages one) (Usages two) =
    Usages (one ++ two)


{-| Returns a schema of only things that are unused
-}
toUnusedReport : Usages -> GraphQL.Schema.Schema -> GraphQL.Schema.Schema
toUnusedReport usages schema =
    { queries = schema.queries
    , mutations = schema.mutations
    , objects = schema.objects
    , scalars = schema.scalars
    , inputObjects = schema.inputObjects
    , enums = schema.enums
    , unions = schema.unions
    , interfaces = schema.interfaces
    }
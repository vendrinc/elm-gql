module GraphQL.Usage exposing
    ( Usages, init
    , enum, field, inputObject, mutation, query, scalar
    )

{-|

@docs Usages, init

@docs enum, field, inputObject, interface, mutation, query, scalar

@docs toUnusedReport

-}

import Dict
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
    | Field
        { name : String
        , field : String
        }
    | Scalar String
    | InputObject
        { name : String
        , field : String
        }
    | Enum String


query : String -> FilePath -> Usages -> Usages
query name =
    used (Query name)


mutation : String -> FilePath -> Usages -> Usages
mutation name =
    used (Mutation name)


field : String -> String -> FilePath -> Usages -> Usages
field name fieldName =
    used (Field { name = name, field = fieldName })


scalar : String -> FilePath -> Usages -> Usages
scalar name =
    used (Scalar name)


enum : String -> FilePath -> Usages -> Usages
enum name =
    used (Enum name)


inputObject : String -> String -> FilePath -> Usages -> Usages
inputObject name fieldName =
    used (InputObject { name = name, field = fieldName })


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
toUnusedReport (Usages usages) schema =
    { queries = remove RemoveQuery usages schema.queries
    , mutations = remove RemoveMutation usages schema.mutations
    , objects = removeField usages schema.objects
    , scalars = remove RemoveScalar usages schema.scalars
    , inputObjects = Dict.empty --schema.inputObjects
    , enums = remove RemoveEnum usages schema.enums
    , unions = Dict.empty --schema.unions
    , interfaces = removeField usages schema.interfaces
    }


type RemoveType
    = RemoveQuery
    | RemoveMutation
    | RemoveScalar
    | RemoveInputObject
    | RemoveEnum


remove toRemove usages dict =
    List.foldl (removeItem toRemove) dict usages


removeItem toRemove usage dict =
    case toRemove of
        RemoveQuery ->
            case usage.type_ of
                Query queryName ->
                    Dict.remove queryName dict

                _ ->
                    dict

        RemoveMutation ->
            case usage.type_ of
                Mutation mutationName ->
                    Dict.remove mutationName dict

                _ ->
                    dict

        RemoveScalar ->
            case usage.type_ of
                Scalar scalarName ->
                    Dict.remove scalarName dict

                _ ->
                    dict

        RemoveInputObject ->
            dict

        RemoveEnum ->
            case usage.type_ of
                Enum enumName ->
                    Dict.remove enumName dict

                _ ->
                    dict


removeField usages dict =
    List.foldl removeFieldItem dict usages


removeFieldItem usage dict =
    case usage.type_ of
        Field usedField ->
            -- Dict.remove queryName dict
            case Dict.get usedField.name dict of
                Nothing ->
                    -- already marked as used
                    dict

                Just usedObject ->
                    case List.filter (\usedObjectField -> usedObjectField.name /= usedField.field) usedObject.fields of
                        [] ->
                            Dict.remove usedField.name dict

                        newFields ->
                            dict
                                |> Dict.insert usedField.name
                                    { usedObject | fields = newFields }

        _ ->
            dict

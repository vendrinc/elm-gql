module GraphQL.Operations.Canonicalize exposing (canonicalize, errorToString)

{-| -}

import Dict exposing (Dict)
import Generate.Input
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Schema
import GraphQL.Schema.Argument as Arg
import GraphQL.Schema.Kind as Kind
import GraphQL.Schema.Object as Object
import GraphQL.Schema.Operation as Operation
import GraphQL.Schema.Type as Type
import GraphQL.Schema.Union as Union


type Error
    = Error
        { coords : Coords
        , error : ErrorDetails
        }


todo : String -> Error
todo msg =
    Error
        { coords =
            { start = zeroPosition
            , end = zeroPosition
            }
        , error = Todo msg
        }


error : ErrorDetails -> Error
error deets =
    Error
        { coords = { start = zeroPosition, end = zeroPosition }
        , error = deets
        }


zeroPosition : Position
zeroPosition =
    { line = 0
    , char = 0
    }


type alias Coords =
    { start : Position
    , end : Position
    }


type alias Position =
    { line : Int
    , char : Int
    }


type ErrorDetails
    = Todo String
    | QueryUnknown String
    | EnumUnknown String
    | ObjectUnknown String
    | UnionUnknown String
    | UnknownArgName String
    | FieldUnknown
        { object : String
        , field : String
        }


errorToString : Error -> String
errorToString (Error details) =
    case details.error of
        Todo msg ->
            "Todo: " ++ msg

        EnumUnknown name ->
            "Unknown Enum: " ++ name

        QueryUnknown name ->
            "Unknown Query: " ++ name

        ObjectUnknown name ->
            "Unknown Object: " ++ name

        UnionUnknown name ->
            "Unknown Union: " ++ name

        UnknownArgName name ->
            "Unknown argument named: " ++ name

        FieldUnknown field ->
            "Unknown Field: " ++ field.object ++ "." ++ field.field


type CanResult success
    = CanError (List Error)
    | CanSuccess VarCache success


err : List Error -> CanResult success
err =
    CanError


success : VarCache -> success -> CanResult success
success =
    CanSuccess


emptySuccess : CanResult (List a)
emptySuccess =
    CanSuccess emptyCache []


canonicalize : GraphQL.Schema.Schema -> AST.Document -> Result (List Error) Can.Document
canonicalize schema doc =
    let
        fragments =
            getFragments schema doc
    in
    case reduce (canonicalizeDefinition schema) doc.definitions (CanSuccess fragments []) of
        CanSuccess cache defs ->
            case reduceOld (replaceVarTypes cache) defs (Ok []) of
                Ok defsWithVars ->
                    Ok { definitions = defsWithVars }

                Err errorMsg ->
                    Err errorMsg

        CanError errorMsg ->
            Err errorMsg


replaceVarTypes : VarCache -> Can.Definition -> Result (List Error) Can.Definition
replaceVarTypes cache (Can.Operation def) =
    case reduceOld (getVarTypeNamed cache.varTypes) def.variableDefinitions (Ok []) of
        Ok varDefs ->
            Ok
                (Can.Operation
                    { def
                        | variableDefinitions =
                            varDefs
                    }
                )

        Err errMsg ->
            Err errMsg


getVarTypeNamed : List ( String, Type.Type ) -> Can.VariableDefinition -> Result (List Error) Can.VariableDefinition
getVarTypeNamed vars target =
    let
        targetName =
            Can.nameToString target.variable.name

        found =
            List.filter
                (\( varName, var ) ->
                    varName == targetName
                )
                vars
                |> List.head
    in
    case found of
        Nothing ->
            Err [ error (UnknownArgName ("CANON" ++ targetName)) ]

        Just ( _, varType ) ->
            Ok
                { target
                    | schemaType = varType
                }


type alias VarCache =
    { varTypes : List ( String, Type.Type )
    , fragments : Dict String AST.FragmentDetails
    }


emptyCache : VarCache
emptyCache =
    { varTypes = []
    , fragments = Dict.empty
    }


addVars vars cache =
    { fragments = cache.fragments
    , varTypes =
        -- NOTE, there is an opporunity to check if there is avariable collision here
        -- not a problem if there is a collision, only if they have conflicting gql types
        vars ++ cache.varTypes
    }


mergeCaches one two =
    { fragments = one.fragments
    , varTypes =
        -- NOTE, there is an opporunity to check if there is avariable collision here
        -- not a problem if there is a collision, only if they have conflicting gql types
        one.varTypes ++ two.varTypes
    }


getFragments : GraphQL.Schema.Schema -> AST.Document -> VarCache
getFragments schema doc =
    gatherFragmentsFromDefinitions schema emptyCache doc.definitions


gatherFragmentsFromDefinitions schema cache defs =
    case defs of
        [] ->
            cache

        (AST.Operation op) :: remain ->
            cache

        (AST.Fragment frag) :: remain ->
            gatherFragmentsFromDefinitions schema
                { cache
                    | fragments =
                        Dict.insert
                            (AST.nameToString frag.name)
                            frag
                            cache.fragments
                }
                remain


reduce :
    (item -> CanResult result)
    -> List item
    -> CanResult (List result)
    -> CanResult (List result)
reduce isValid items res =
    case items of
        [] ->
            res

        top :: remain ->
            case isValid top of
                CanSuccess cache valid ->
                    case res of
                        CanSuccess existingCache existing ->
                            reduce isValid
                                remain
                                (CanSuccess (mergeCaches cache existingCache) (valid :: existing))

                        CanError _ ->
                            res

                CanError errorMessage ->
                    let
                        newResult =
                            case res of
                                CanSuccess _ _ ->
                                    CanError errorMessage

                                CanError existingErrors ->
                                    CanError (errorMessage ++ existingErrors)
                    in
                    reduce isValid remain newResult


reduceOld :
    (item -> Result (List Error) result)
    -> List item
    -> Result (List Error) (List result)
    -> Result (List Error) (List result)
reduceOld isValid items res =
    case items of
        [] ->
            res

        top :: remain ->
            case isValid top of
                Ok valid ->
                    case res of
                        Ok existing ->
                            reduceOld isValid
                                remain
                                (Ok (valid :: existing))

                        Err _ ->
                            res

                Err errorMessage ->
                    let
                        newResult =
                            case res of
                                Ok _ ->
                                    Err errorMessage

                                Err existingErrors ->
                                    Err (errorMessage ++ existingErrors)
                    in
                    reduceOld isValid remain newResult


convertName : AST.Name -> Can.Name
convertName (AST.Name str) =
    Can.Name str


canonicalizeDefinition : GraphQL.Schema.Schema -> AST.Definition -> CanResult Can.Definition
canonicalizeDefinition schema def =
    case def of
        AST.Fragment details ->
            Debug.todo "There is no concept of fragment in Can.Definition"

        AST.Operation details ->
            let
                fieldResult =
                    reduce (canonicalizeOperation schema details.operationType) details.fields emptySuccess
            in
            case fieldResult of
                CanSuccess cache fields ->
                    CanSuccess cache <|
                        Can.Operation
                            { operationType =
                                case details.operationType of
                                    AST.Query ->
                                        Can.Query

                                    AST.Mutation ->
                                        Can.Mutation
                            , name = Maybe.map convertName details.name
                            , variableDefinitions =
                                List.map
                                    toCanonVariable
                                    details.variableDefinitions
                            , directives =
                                List.map convertDirective details.directives
                            , fields = fields
                            }

                CanError errorMsg ->
                    CanError errorMsg


toCanonVariable : AST.VariableDefinition -> Can.VariableDefinition
toCanonVariable def =
    { variable = { name = convertName def.variable.name }
    , type_ = def.type_
    , defaultValue = def.defaultValue
    , schemaType = Type.Scalar "Unknown"
    }


canonicalizeOperation : GraphQL.Schema.Schema -> AST.OperationType -> AST.Selection -> CanResult Can.Selection
canonicalizeOperation schema op selection =
    case selection of
        AST.Field field ->
            let
                matched =
                    case op of
                        AST.Query ->
                            Dict.get (AST.nameToString field.name) schema.queries

                        AST.Mutation ->
                            Dict.get (AST.nameToString field.name) schema.mutations
            in
            case matched of
                Nothing ->
                    err [ error (QueryUnknown (AST.nameToString field.name)) ]

                Just query ->
                    case query.type_ of
                        Type.Scalar name ->
                            CanSuccess emptyCache
                                (Can.FieldScalar
                                    { alias_ = Maybe.map convertName field.alias_
                                    , name = convertName field.name
                                    , arguments = []
                                    , directives = List.map convertDirective field.directives
                                    , type_ = query.type_
                                    }
                                )

                        Type.InputObject name ->
                            err [ todo "Invalid schema!  Weird InputObject" ]

                        Type.Object name ->
                            case Dict.get name schema.objects of
                                Nothing ->
                                    err [ error (ObjectUnknown name) ]

                                Just obj ->
                                    let
                                        argValidation =
                                            reduceOld (validateArg query) field.arguments (Ok [])

                                        selectionResult =
                                            reduce (canonicalizeField schema obj) field.selection emptySuccess
                                    in
                                    case argValidation of
                                        Ok vars ->
                                            case selectionResult of
                                                CanSuccess cache canSelection ->
                                                    CanSuccess (addVars vars cache)
                                                        (Can.FieldObject
                                                            { alias_ = Maybe.map convertName field.alias_
                                                            , name = convertName field.name
                                                            , arguments = []
                                                            , directives = List.map convertDirective field.directives
                                                            , selection = canSelection
                                                            , object = obj
                                                            , wrapper = Generate.Input.getWrap query.type_
                                                            }
                                                        )

                                                CanError errorMsg ->
                                                    CanError errorMsg

                                        Err errors ->
                                            CanError errors

                        Type.Enum name ->
                            CanSuccess emptyCache
                                (Can.FieldScalar
                                    { alias_ = Maybe.map convertName field.alias_
                                    , name = convertName field.name
                                    , arguments = []
                                    , directives = List.map convertDirective field.directives
                                    , type_ = query.type_
                                    }
                                )

                        Type.Union name ->
                            case Dict.get name schema.unions of
                                Nothing ->
                                    err [ error (UnionUnknown name) ]

                                Just union ->
                                    case extractUnionTags union.variants [] of
                                        Nothing ->
                                            err [ todo "Things in a union are not objects!" ]

                                        Just vars ->
                                            let
                                                -- args = reduceOld (validateArg union) field.arguments (Ok [])
                                                selectionResult =
                                                    reduce (canonicalizeUnionField schema union vars) field.selection emptySuccess
                                            in
                                            case selectionResult of
                                                CanSuccess cache canSelection ->
                                                    CanSuccess cache
                                                        (Can.FieldUnion
                                                            { alias_ = Maybe.map convertName field.alias_
                                                            , name = convertName field.name
                                                            , arguments = []
                                                            , directives = List.map convertDirective field.directives
                                                            , selection = canSelection
                                                            , union = union
                                                            , wrapper = Generate.Input.getWrap query.type_
                                                            }
                                                        )

                                                CanError errorMsg ->
                                                    CanError errorMsg

                        Type.Interface name ->
                            err [ todo "Handle more object types!" ]

                        Type.List_ inner ->
                            err [ todo "Handle more object types!" ]

                        Type.Nullable inner ->
                            err [ todo "Handle more object types!" ]

        AST.FragmentSpreadSelection frag ->
            err [ todo "Fragments in unions aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            err [ todo "Unions not supported yet" ]


validateArg : { node | arguments : List Arg.Argument } -> AST.Argument -> Result (List Error) ( String, Type.Type )
validateArg spec argInGql =
    case argInGql.value of
        AST.Var var ->
            let
                varname =
                    AST.nameToString var.name

                fieldname =
                    AST.nameToString argInGql.name
            in
            case List.head (List.filter (\a -> a.name == fieldname) spec.arguments) of
                Nothing ->
                    Err [ error (UnknownArgName varname) ]

                Just schemaVar ->
                    Ok ( varname, schemaVar.type_ )

        _ ->
            Err [ error (Todo "All inputs must be variables for now.  No inline values.") ]


canonicalizeField : GraphQL.Schema.Schema -> Object.Object -> AST.Selection -> CanResult Can.Selection
canonicalizeField schema object selection =
    case selection of
        AST.Field field ->
            let
                fieldName =
                    AST.nameToString field.name
            in
            if fieldName == "__typename" then
                CanSuccess emptyCache
                    (Can.FieldScalar
                        { alias_ = Maybe.map convertName field.alias_
                        , name = convertName field.name
                        , arguments = []
                        , directives = List.map convertDirective field.directives
                        , type_ = Type.Scalar "typename"
                        }
                    )

            else
                let
                    matchedField =
                        object.fields
                            |> List.filter (\fld -> fld.name == fieldName)
                            |> List.head
                in
                case matchedField of
                    Just matched ->
                        canonicalizeFieldType schema object field matched.type_ selection matched.type_

                    Nothing ->
                        err [ error (FieldUnknown { object = object.name, field = fieldName }) ]

        AST.FragmentSpreadSelection frag ->
            err [ todo "Fragments in objects aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            err [ todo "Inline fragments are not allowed" ]


convertDirective dir =
    { name = convertName dir.name
    , arguments =
        List.map
            (\arg ->
                { name = convertName arg.name
                , value = arg.value
                }
            )
            dir.arguments
    }


{-|

    For `field`, we are matching it up with types from `schema`

-}
canonicalizeFieldType : GraphQL.Schema.Schema -> Object.Object -> AST.FieldDetails -> Type.Type -> AST.Selection -> Type.Type -> CanResult Can.Selection
canonicalizeFieldType schema object field type_ selection originalType =
    case type_ of
        Type.Scalar name ->
            success emptyCache
                (Can.FieldScalar
                    { alias_ = Maybe.map convertName field.alias_
                    , name = convertName field.name
                    , arguments = []
                    , directives = List.map convertDirective field.directives
                    , type_ = originalType
                    }
                )

        Type.InputObject name ->
            err [ todo "Invalid schema!  Weird InputObject" ]

        Type.Object name ->
            case Dict.get name schema.objects of
                Nothing ->
                    err [ error (ObjectUnknown name) ]

                Just obj ->
                    let
                        -- argValidation = reduceOld (validateArg obj) field.arguments (Ok [])
                        selectionResult =
                            reduce (canonicalizeField schema obj) field.selection emptySuccess
                    in
                    case selectionResult of
                        CanSuccess var canSelection ->
                            CanSuccess var
                                (Can.FieldObject
                                    { alias_ = Maybe.map convertName field.alias_
                                    , name = convertName field.name
                                    , arguments = []
                                    , directives = List.map convertDirective field.directives
                                    , selection = canSelection
                                    , object = obj
                                    , wrapper = Generate.Input.getWrap originalType
                                    }
                                )

                        CanError errorMsg ->
                            CanError errorMsg

        Type.Enum name ->
            case Dict.get name schema.enums of
                Nothing ->
                    err [ error (EnumUnknown name) ]

                Just enum ->
                    CanSuccess emptyCache
                        (Can.FieldEnum
                            { alias_ = Maybe.map convertName field.alias_
                            , name = convertName field.name
                            , arguments = []
                            , directives = List.map convertDirective field.directives
                            , enumName = enum.name
                            , values = enum.values
                            , wrapper = Generate.Input.getWrap originalType
                            }
                        )

        Type.Union name ->
            case Dict.get name schema.unions of
                Nothing ->
                    err [ error (UnionUnknown name) ]

                Just union ->
                    case extractUnionTags union.variants [] of
                        Nothing ->
                            err [ todo "Things in a union are not objects!" ]

                        Just vars ->
                            let
                                --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                                selectionResult =
                                    reduce (canonicalizeUnionField schema union vars) field.selection emptySuccess
                            in
                            case selectionResult of
                                CanSuccess cache canSelection ->
                                    CanSuccess cache
                                        (Can.FieldUnion
                                            { alias_ = Maybe.map convertName field.alias_
                                            , name = convertName field.name
                                            , arguments = []
                                            , directives = List.map convertDirective field.directives
                                            , selection = canSelection
                                            , union = union
                                            , wrapper = Generate.Input.getWrap originalType
                                            }
                                        )

                                CanError errorMsg ->
                                    CanError errorMsg

        Type.Interface name ->
            err [ todo "Field Interfaces!" ]

        Type.List_ inner ->
            canonicalizeFieldType schema object field inner selection originalType

        Type.Nullable inner ->
            canonicalizeFieldType schema object field inner selection originalType


extractUnionTags : List Union.Variant -> List String -> Maybe (List String)
extractUnionTags vars captured =
    case vars of
        [] ->
            Just captured

        top :: remain ->
            case top.kind of
                Kind.Object name ->
                    extractUnionTags remain (name :: captured)

                _ ->
                    Nothing


canonicalizeUnionField : GraphQL.Schema.Schema -> Union.Union -> List String -> AST.Selection -> CanResult Can.Selection
canonicalizeUnionField schema union remainingAllowedTags selection =
    case selection of
        AST.Field field ->
            let
                fieldName =
                    AST.nameToString field.name
            in
            --- NOTE, we could probably be more sophisticated here!
            if fieldName == "__typename" then
                CanSuccess emptyCache
                    (Can.FieldScalar
                        { alias_ = Maybe.map convertName field.alias_
                        , name = convertName field.name
                        , arguments = []
                        , directives = List.map convertDirective field.directives
                        , type_ = Type.Scalar "typename"
                        }
                    )

            else
                err [ todo "Common selections not allowed for gql unions" ]

        AST.FragmentSpreadSelection frag ->
            err [ todo "Fragments in objects aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            let
                tag =
                    AST.nameToString inline.tag

                ( tagMatches, leftOvertags ) =
                    matchTag tag remainingAllowedTags ( False, [] )
            in
            if tagMatches then
                case Dict.get tag schema.objects of
                    Nothing ->
                        err [ error (ObjectUnknown tag) ]

                    Just obj ->
                        let
                            --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                            selectionResult =
                                reduce (\sel -> canonicalizeField schema obj sel) inline.selection emptySuccess
                        in
                        case selectionResult of
                            CanSuccess cache canSelection ->
                                CanSuccess cache
                                    (Can.UnionCase
                                        { tag = Can.Name tag
                                        , directives = List.map convertDirective inline.directives
                                        , selection = canSelection
                                        }
                                    )

                            CanError errorMsg ->
                                CanError errorMsg

            else
                err [ todo (tag ++ " does not match!") ]


matchTag : String -> List String -> ( Bool, List String ) -> ( Bool, List String )
matchTag tag tags ( matched, captured ) =
    case tags of
        [] ->
            ( matched, captured )

        top :: remain ->
            if top == tag then
                ( True, remain ++ captured )

            else
                matchTag tag
                    remain
                    ( matched, top :: captured )

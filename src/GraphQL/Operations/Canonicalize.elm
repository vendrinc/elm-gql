module GraphQL.Operations.Canonicalize exposing (canonicalize, errorToString)

{-| -}

import Dict exposing (Dict)
import Generate.Input
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Schema
import GraphQL.Schema.Enum as Enum
import GraphQL.Schema.Field as Field
import GraphQL.Schema.InputObject as Input
import GraphQL.Schema.Interface as Interface
import GraphQL.Schema.Kind as Kind
import GraphQL.Schema.Object as Object
import GraphQL.Schema.Operation as Operation
import GraphQL.Schema.Scalar as Scalar
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

        FieldUnknown field ->
            "Unknown Field: " ++ field.object ++ "." ++ field.field


canonicalize : GraphQL.Schema.Schema -> AST.Document -> Result (List Error) Can.Document
canonicalize schema doc =
    let
        variableCache = gatherVariableTypeCache schema doc
    in
    case reduce (canonicalizeDefinition schema) doc.definitions (Ok []) of
        Ok result ->
            Ok { definitions = result }

        Err err ->
            Err err


type alias VarCache =
    { varTypes : Dict String (Result String Type.Type)
    , fragments : Dict String (AST.FragmentDetails)
    }
emptyCache : VarCache
emptyCache = 
    { varTypes = Dict.empty
    , fragments = Dict.empty

    }

gatherVariableTypeCache : GraphQL.Schema.Schema -> AST.Document -> VarCache
gatherVariableTypeCache schema doc =
    gatherVarFromDefinition schema emptyCache doc.definitions 

gatherVarFromDefinition schema cache defs =
    case defs of
        [] ->
            cache

        (AST.Operation op) :: remain ->
            gatherVarFromDefinition schema 
                (gatherVarFromSelection schema cache op.fields)
                remain

        (AST.Fragment frag) :: remain ->
            let
                updatedFragments = 
                    gatherVarFromSelection schema cache frag.selection
            in
            gatherVarFromDefinition schema
                { updatedFragments | fragments =
                    Dict.insert
                        (AST.nameToString frag.name)
                        frag
                        updatedFragments.fragments
                }
                remain
gatherVarFromSelection schema cache sels =
    case sels of
        [] ->
            cache
        
        (AST.Field field) :: remain ->
            cache

        (AST.FragmentSpreadSelection spread) :: remain ->
            cache
        
        (AST.InlineFragmentSelection inline) :: remain ->
            cache

reduce :
    (item -> Result (List Error) result)
    -> List item
    -> Result (List Error) (List result)
    -> Result (List Error) (List result)
reduce isValid items res =
    case items of
        [] ->
            res

        top :: remain ->
            case isValid top of
                Ok valid ->
                    case res of
                        Ok existing ->
                            reduce isValid
                                remain
                                (Ok (valid :: existing))

                        Err err ->
                            res

                Err err ->
                    let
                        newResult =
                            case res of
                                Ok _ ->
                                    Err err

                                Err existingErrors ->
                                    Err (err ++ existingErrors)
                    in
                    reduce isValid remain newResult


convertName : AST.Name -> Can.Name
convertName (AST.Name str) =
    Can.Name str


canonicalizeDefinition : GraphQL.Schema.Schema -> AST.Definition -> Result (List Error) Can.Definition
canonicalizeDefinition schema def =
    case def of
        AST.Fragment details ->
            Err [ todo "Top level fragments are not supported yet!" ]

        AST.Operation details ->
            let
                fieldResult =
                    reduce (canonicalizeOperation schema details.operationType) details.fields (Ok [])
            in
            case fieldResult of
                Ok fields ->
                    Ok <|
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

                Err err ->
                    Err err

              


toCanonVariable : AST.VariableDefinition -> Can.VariableDefinition
toCanonVariable def =
    { variable = { name = convertName def.variable.name }
    , type_ = def.type_
    , defaultValue = def.defaultValue
    -- , schemaType = Err "Unknown"
    }


canonicalizeOperation : GraphQL.Schema.Schema -> AST.OperationType -> AST.Selection -> Result (List Error) Can.Selection
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
                    Err [ error (QueryUnknown (AST.nameToString field.name)) ]

                Just query ->
                    case query.type_ of
                        Type.Scalar name ->
                            Ok
                                (Can.FieldScalar
                                    { alias_ = Maybe.map convertName field.alias_
                                    , name = convertName field.name
                                    , arguments = []
                                    , directives = List.map convertDirective field.directives
                                    , type_ = query.type_
                                    }
                                )

                        Type.InputObject name ->
                            Err [ todo "Invalid schema!  Weird InputObject" ]

                        Type.Object name ->
                            case Dict.get name schema.objects of
                                Nothing ->
                                    Err [ error (ObjectUnknown name) ]

                                Just obj ->
                                    let
                                        --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                                        selectionResult =
                                            reduce (canonicalizeField schema obj) field.selection (Ok [])
                                    in
                                    case selectionResult of
                                        Ok canSelection ->
                                            Ok
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

                                        Err err ->
                                            Err err

                        Type.Enum name ->
                            Ok
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
                                    Err [ error (UnionUnknown name) ]

                                Just union ->
                                    case extractUnionTags union.variants [] of
                                        Nothing ->
                                            Err [ todo "Things in a union are not objects!" ]

                                        Just vars ->
                                            let
                                                --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                                                selectionResult =
                                                    reduce (canonicalizeUnionField schema union vars) field.selection (Ok [])
                                            in
                                            case selectionResult of
                                                Ok canSelection ->
                                                    Ok
                                                        (Can.FieldUnion
                                                            { alias_ = Maybe.map convertName field.alias_
                                                            , name = convertName field.name
                                                            , arguments = []
                                                            , directives = List.map convertDirective field.directives
                                                            , selection = canSelection
                                                            , union = union
                                                            }
                                                        )

                                                Err err ->
                                                    Err err

                        Type.Interface name ->
                            Err [ todo "Handle more object types!" ]

                        Type.List_ inner ->
                            Err [ todo "Handle more object types!" ]

                        Type.Nullable inner ->
                            Err [ todo "Handle more object types!" ]

        AST.FragmentSpreadSelection frag ->
            Err [ todo "Fragments in unions aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            Err [ todo "Unions not supported yet" ]


canonicalizeField : GraphQL.Schema.Schema -> Object.Object -> AST.Selection -> Result (List Error) Can.Selection
canonicalizeField schema object selection =
    case selection of
        AST.Field field ->
            let
                fieldName =
                    AST.nameToString field.name
            in
            if fieldName == "__typename" then
                Ok
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
                        Err [ error (FieldUnknown { object = object.name, field = fieldName }) ]

        AST.FragmentSpreadSelection frag ->
            Err [ todo "Fragments in objects aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            Err [ todo "Inline fragments are not allowed" ]

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
canonicalizeFieldType : GraphQL.Schema.Schema -> Object.Object -> AST.FieldDetails -> Type.Type -> AST.Selection -> Type.Type -> Result (List Error) Can.Selection
canonicalizeFieldType schema object field type_ selection originalType =
    case type_ of
        Type.Scalar name ->
            Ok
                (Can.FieldScalar
                    { alias_ = Maybe.map convertName field.alias_
                    , name = convertName field.name
                    , arguments = []
                    , directives = List.map convertDirective field.directives
                    , type_ = originalType
                    }
                )

        Type.InputObject name ->
            Err [ todo "Invalid schema!  Weird InputObject" ]

        Type.Object name ->
            case Dict.get name schema.objects of
                Nothing ->
                    Err [ error (ObjectUnknown name) ]

                Just obj ->
                    let
                        --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                        selectionResult =
                            reduce (canonicalizeField schema obj) field.selection (Ok [])
                    in
                    case selectionResult of
                        Ok canSelection ->
                            Ok
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

                        Err err ->
                            Err err

        Type.Enum name ->
            case Dict.get name schema.enums of
                Nothing ->
                    Err [ error (EnumUnknown name) ]

                Just enum ->
                    Ok
                        (Can.FieldEnum
                            { alias_ = Maybe.map convertName field.alias_
                            , name = convertName field.name
                            , arguments = []
                            , directives = List.map convertDirective field.directives
                            , enumName = enum.name
                            , values = enum.values
                            }
                        )

        Type.Union name ->
            -- Err [ todo "Field Unions" ]
            case Dict.get name schema.unions of
                Nothing ->
                    Err [ error (UnionUnknown name) ]

                Just union ->
                    case extractUnionTags union.variants [] of
                        Nothing ->
                            Err [ todo "Things in a union are not objects!" ]

                        Just vars ->
                            let
                                --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                                selectionResult =
                                    reduce (canonicalizeUnionField schema union vars) field.selection (Ok [])
                            in
                            case selectionResult of
                                Ok canSelection ->
                                    Ok
                                        (Can.FieldUnion
                                            { alias_ = Maybe.map convertName field.alias_
                                            , name = convertName field.name
                                            , arguments = []
                                            , directives = List.map convertDirective field.directives
                                            , selection = canSelection
                                            , union = union
                                            }
                                        )

                                Err err ->
                                    Err err

        Type.Interface name ->
            Err [ todo "Field Interfaces!" ]

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


canonicalizeUnionField : GraphQL.Schema.Schema -> Union.Union -> List String -> AST.Selection -> Result (List Error) Can.Selection
canonicalizeUnionField schema union remainingAllowedTags selection =
    case selection of
        AST.Field field ->
            let
                fieldName =
                    AST.nameToString field.name
            in
            --- NOTE, we could probably be more sophisticated here!
            if fieldName == "__typename" then
                Ok
                    (Can.FieldScalar
                        { alias_ = Maybe.map convertName field.alias_
                        , name = convertName field.name
                        , arguments = []
                        , directives = List.map convertDirective field.directives
                        , type_ = Type.Scalar "typename"
                        }
                    )

            else
                Err [ todo "Common selections not allowed for gql unions" ]

        AST.FragmentSpreadSelection frag ->
            Err [ todo "Fragments in objects aren't suported yet!" ]

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
                        Err [ error (ObjectUnknown tag) ]

                    Just obj ->
                        let
                            --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                            selectionResult =
                                reduce (\sel -> canonicalizeField schema obj sel) inline.selection (Ok [])
                        in
                        case selectionResult of
                            Ok canSelection ->
                                Ok
                                    (Can.UnionCase
                                        { tag = Can.Name tag
                                        , directives = List.map convertDirective inline.directives
                                        , selection = canSelection
                                        }
                                    )

                            Err err ->
                                Err err

            else
                Err [ todo (tag ++ " does not match!") ]


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

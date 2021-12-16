module GraphQL.Operations.Canonicalize exposing (canonicalize, errorToString)

{-| -}

import Dict exposing (Dict)
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Schema
import Print


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
    | UnusedVariable
        { name : String
        , knownVariables : List String
        }
    | UndeclaredVariable
        { name : String
        , knownVariables : List String
        }
    | VariableIssueSummary VariableSummary


type alias VariableSummary =
    { declared : List DeclaredVariable
    , valid : List Can.VariableDefinition
    , issues : List VarIssue
    , suggestions : List SuggestedVariable
    }


type alias DeclaredVariable =
    { name : String
    , type_ : Maybe String
    }


type VarIssue
    = Unused { name : String, possibly : List String }
    | UnexpectedType
        { name : String
        , found : Maybe String
        , expected : String
        }
    | Undeclared { name : String, possibly : List String }


type alias SuggestedVariable =
    { name : String
    , type_ : String
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

        UnusedVariable unused ->
            "Unused variable: " ++ unused.name

        UndeclaredVariable undeclared ->
            "Undeclared variable: " ++ undeclared.name

        VariableIssueSummary summary ->
            case summary.declared of
                [] ->
                    String.join "\n"
                        [ "It looks like no variables are declared."
                        , "Here's what I think the variables should be:"
                        , Print.block
                            (List.map
                                renderSuggestion
                                (List.reverse summary.suggestions)
                            )
                        ]

                _ ->
                    String.join "\n"
                        [ "I found the following variables:"
                        , Print.block
                            (List.map
                                renderDeclared
                                (List.reverse summary.declared)
                            )
                        , if List.length summary.issues == 1 then
                            "But I ran into an issue:"

                          else
                            "But I ran into a few issues:"
                        , Print.block
                            (List.concatMap
                                renderIssue
                                summary.issues
                            )
                        , "Here's what I think the variables should be:"
                        , Print.block
                            (List.map
                                renderSuggestion
                                (List.reverse summary.suggestions)
                            )
                        ]


renderDeclared : DeclaredVariable -> String
renderDeclared declared =
    case declared.type_ of
        Nothing ->
            Print.yellow ("$" ++ declared.name)

        Just declaredType ->
            Print.yellow ("$" ++ declared.name) ++ Print.grey ": " ++ Print.cyan declaredType


renderSuggestion : SuggestedVariable -> String
renderSuggestion sug =
    Print.yellow ("$" ++ sug.name) ++ Print.grey ": " ++ Print.cyan sug.type_


renderIssue : VarIssue -> List String
renderIssue issue =
    case issue of
        Unused var ->
            [ Print.yellow ("$" ++ var.name) ++ " is unused." ]

        UnexpectedType var ->
            case var.found of
                Nothing ->
                    [ Print.yellow ("$" ++ var.name) ++ " has no type declaration" ]

                Just foundType ->
                    let
                        variableName =
                            "$" ++ var.name
                    in
                    [ Print.yellow variableName
                        ++ " is declared as "
                        ++ Print.cyan foundType
                    , String.repeat (String.length variableName - 6) " "
                        ++ "but is expected to be "
                        ++ Print.cyan var.expected
                    ]

        Undeclared var ->
            [ Print.yellow ("$" ++ var.name) ++ " is undeclared (missing from the top)." ]


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


getVarTypeNamed : List ( String, GraphQL.Schema.Type ) -> Can.VariableDefinition -> Result (List Error) Can.VariableDefinition
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
    { varTypes : List ( String, GraphQL.Schema.Type )
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


gatherFragmentsFromDefinitions : GraphQL.Schema.Schema -> VarCache -> List AST.Definition -> VarCache
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


reduceConcat :
    (item -> Result (List Error) (List result))
    -> List item
    -> Result (List Error) (List result)
    -> Result (List Error) (List result)
reduceConcat isValid items res =
    case items of
        [] ->
            res

        top :: remain ->
            case isValid top of
                Ok valid ->
                    case res of
                        Ok existing ->
                            reduceConcat isValid
                                remain
                                (Ok (valid ++ existing))

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
                    reduceConcat isValid remain newResult


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
                    let
                        variableSummary =
                            List.foldl
                                verifyVariables
                                { declared = []
                                , valid = []
                                , issues = []
                                , suggestions = []
                                }
                                (mergeVars cache.varTypes details.variableDefinitions)
                    in
                    if not (List.isEmpty variableSummary.issues) then
                        CanError
                            [ error
                                (VariableIssueSummary variableSummary)
                            ]

                    else
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
                                    variableSummary.valid
                                , directives =
                                    List.map convertDirective details.directives
                                , fields = fields
                                }

                CanError errorMsg ->
                    CanError errorMsg


{-| The AST.Type is the type declared at the top of the document.

The Schema.Type is what is in the schema.

-}
doTypesMatch : GraphQL.Schema.Type -> AST.Type -> Bool
doTypesMatch schemaType astType =
    case astType of
        AST.Type_ astName ->
            case schemaType of
                GraphQL.Schema.Scalar schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.InputObject schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.Object schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.Enum schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.Union schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.Interface schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.List_ inner ->
                    False

                GraphQL.Schema.Nullable inner ->
                    False

        AST.Nullable innerAST ->
            case schemaType of
                GraphQL.Schema.Nullable innerSchema ->
                    doTypesMatch innerSchema innerAST

                _ ->
                    False

        AST.List_ innerAST ->
            case schemaType of
                GraphQL.Schema.List_ innerSchema ->
                    doTypesMatch innerSchema innerAST

                _ ->
                    False


verifyVariables :
    { name : String
    , definition : Maybe AST.VariableDefinition
    , inOperation : Maybe GraphQL.Schema.Type
    }
    -> VariableSummary
    -> VariableSummary
verifyVariables item summary =
    case ( item.definition, item.inOperation ) of
        ( Just def, Just inOp ) ->
            -- check to make sure the variables are unifiable
            let
                valid =
                    { variable = { name = convertName def.variable.name }
                    , type_ = def.type_
                    , defaultValue = def.defaultValue
                    , schemaType = inOp
                    }

                typeString =
                    GraphQL.Schema.typeToString inOp

                declared =
                    { name = AST.nameToString def.variable.name
                    , type_ =
                        Just
                            (AST.typeToGqlString def.type_)
                    }

                suggestion =
                    { name = AST.nameToString def.variable.name
                    , type_ = typeString
                    }

                typesMatch =
                    doTypesMatch inOp def.type_
            in
            { declared = declared :: summary.declared
            , valid = valid :: summary.valid
            , issues =
                if typesMatch then
                    summary.issues

                else
                    UnexpectedType
                        { name = item.name
                        , found = Just (AST.typeToGqlString def.type_)
                        , expected = typeString
                        }
                        :: summary.issues
            , suggestions = suggestion :: summary.suggestions
            }

        ( Just def, Nothing ) ->
            { declared =
                { name = AST.nameToString def.variable.name
                , type_ = Nothing
                }
                    :: summary.declared
            , valid = summary.valid
            , issues =
                Unused
                    { name = item.name
                    , possibly = []
                    }
                    :: summary.issues
            , suggestions =
                summary.suggestions
            }

        ( Nothing, Just inOp ) ->
            let
                suggestion =
                    { name = item.name
                    , type_ = GraphQL.Schema.typeToString inOp
                    }
            in
            { declared = summary.declared
            , valid = summary.valid
            , issues =
                Undeclared
                    { name = item.name
                    , possibly = []
                    }
                    :: summary.issues
            , suggestions = suggestion :: summary.suggestions
            }

        ( Nothing, Nothing ) ->
            summary


mergeVars :
    List ( String, GraphQL.Schema.Type )
    -> List AST.VariableDefinition
    ->
        List
            { name : String
            , definition : Maybe AST.VariableDefinition
            , inOperation : Maybe GraphQL.Schema.Type
            }
mergeVars varTypes variableDefinitions =
    let
        allNames =
            List.foldl
                (\varName found ->
                    if List.member varName found then
                        found

                    else
                        varName :: found
                )
                []
                (List.map (.variable >> .name >> AST.nameToString) variableDefinitions
                    ++ List.map Tuple.first varTypes
                )
                |> List.reverse
    in
    List.map
        (\name ->
            { name = name
            , definition =
                List.foldl
                    (\def found ->
                        case found of
                            Nothing ->
                                if AST.nameToString def.variable.name == name then
                                    Just def

                                else
                                    found

                            _ ->
                                found
                    )
                    Nothing
                    variableDefinitions
            , inOperation =
                find name varTypes
            }
        )
        allNames


validateTopLevelVariables cache varDef =
    let
        varName =
            AST.nameToString varDef.variable.name
    in
    case find varName cache.varTypes of
        Nothing ->
            Err
                [ UnusedVariable
                    { name = varName
                    , knownVariables = List.map Tuple.first cache.varTypes
                    }
                    |> error
                ]

        Just varType ->
            Ok
                { definition = varDef
                , inOperation = varType
                }


find : String -> List ( String, a ) -> Maybe a
find str items =
    case items of
        [] ->
            Nothing

        ( key, val ) :: remain ->
            if str == key then
                Just val

            else
                find str remain


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
                    let
                        argValidation =
                            reduceConcat (validateArg schema query) field.arguments (Ok [])
                    in
                    case query.type_ of
                        GraphQL.Schema.Scalar name ->
                            CanSuccess emptyCache
                                (Can.FieldScalar
                                    { alias_ = Maybe.map convertName field.alias_
                                    , name = convertName field.name
                                    , arguments = field.arguments
                                    , directives = List.map convertDirective field.directives
                                    , type_ = query.type_
                                    }
                                )

                        GraphQL.Schema.InputObject name ->
                            err [ todo "Invalid schema!  Weird InputObject" ]

                        GraphQL.Schema.Object name ->
                            case Dict.get name schema.objects of
                                Nothing ->
                                    err [ error (ObjectUnknown name) ]

                                Just obj ->
                                    let
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
                                                            , arguments = field.arguments
                                                            , directives = List.map convertDirective field.directives
                                                            , selection = canSelection
                                                            , object = obj
                                                            , wrapper = GraphQL.Schema.getWrap query.type_
                                                            }
                                                        )

                                                CanError errorMsg ->
                                                    CanError errorMsg

                                        Err errors ->
                                            CanError errors

                        GraphQL.Schema.Enum name ->
                             case Dict.get name schema.enums of
                                Nothing ->
                                    err [ error (EnumUnknown name) ]

                                Just enum ->
                                     case argValidation of
                                        Ok vars ->
                                            CanSuccess (addVars vars emptyCache)
                                                (Can.FieldEnum
                                                    { alias_ = Maybe.map convertName field.alias_
                                                    , name = convertName field.name
                                                    , arguments = field.arguments
                                                    , directives = List.map convertDirective field.directives
                                                    , enumName = enum.name
                                                    , values = enum.values
                                                    , wrapper = GraphQL.Schema.getWrap query.type_
                                                    }
                                                )

                                        Err errors ->
                                            CanError errors

                        GraphQL.Schema.Union name ->
                            case Dict.get name schema.unions of
                                Nothing ->
                                    err [ error (UnionUnknown name) ]

                                Just union ->
                                    case extractUnionTags union.variants [] of
                                        Nothing ->
                                            err [ todo "Things in a union are not objects!" ]

                                        Just vars ->
                                            let
                                                selectionResult =
                                                    reduce (canonicalizeUnionField schema union vars) field.selection emptySuccess
                                            in
                                            case argValidation of
                                                Ok validatedArgs ->
                                                    case selectionResult of
                                                        CanSuccess cache canSelection ->
                                                            CanSuccess (addVars validatedArgs cache)
                                                                (Can.FieldUnion
                                                                    { alias_ = Maybe.map convertName field.alias_
                                                                    , name = convertName field.name
                                                                    , arguments = field.arguments
                                                                    , directives = List.map convertDirective field.directives
                                                                    , selection = canSelection
                                                                    , union = union
                                                                    , wrapper = GraphQL.Schema.getWrap query.type_
                                                                    }
                                                                )

                                                        CanError errorMsg ->
                                                            CanError errorMsg

                                                Err errors ->
                                                    CanError errors

                        GraphQL.Schema.Interface name ->
                            err [ todo "Handle more object types!" ]

                        GraphQL.Schema.List_ inner ->
                            err [ todo "Handle more object types!" ]

                        GraphQL.Schema.Nullable inner ->
                            err [ todo "Handle more object types!" ]

        AST.FragmentSpreadSelection frag ->
            err [ todo "Fragments in unions aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            err [ todo "Unions not supported yet" ]


{-|

    schema:
        The actual schema

    spec:
        The schema definitions for the arguments present on this node

    argsInQuery:
        The arguments in the operation itself(i.e. the gql file)

This function is just gathering what the type should be for the top level arguments.

-}
validateArg :
    GraphQL.Schema.Schema
    -> { node | arguments : List GraphQL.Schema.Argument }
    -> AST.Argument
    -> Result (List Error) (List ( String, GraphQL.Schema.Type ))
validateArg schema spec argInQuery =
    let
        fieldname =
            AST.nameToString argInQuery.name
    in
    case argInQuery.value of
        AST.Var var ->
            let
                varname =
                    AST.nameToString var.name
            in
            case List.head (List.filter (\a -> a.name == fieldname) spec.arguments) of
                Nothing ->
                    Err [ error (UnknownArgName fieldname) ]

                Just schemaVar ->
                    Ok [ ( varname, schemaVar.type_ ) ]

        AST.Object keyValues ->
            case List.head (List.filter (\a -> a.name == fieldname) spec.arguments) of
                Nothing ->
                    Err [ error (UnknownArgName fieldname) ]

                Just schemaVar ->
                    case schemaVar.type_ of
                        GraphQL.Schema.InputObject inputObjectName ->
                            case Dict.get inputObjectName schema.inputObjects of
                                Nothing ->
                                    Err [ error (UnknownArgName fieldname) ]

                                Just inputObject ->
                                    reduceOld
                                        (\( keyName, value ) ->
                                            case value of
                                                AST.Var var ->
                                                    let
                                                        varname =
                                                            AST.nameToString var.name

                                                        key =
                                                            AST.nameToString keyName
                                                    in
                                                    case List.head (List.filter (\a -> a.name == key) inputObject.fields) of
                                                        Nothing ->
                                                            Err [ error (Todo "All inputs must be variables for now.  No inline values.") ]

                                                        Just field ->
                                                            Ok ( varname, field.type_ )

                                                _ ->
                                                    Err [ error (Todo "All inputs must be variables for now.  No inline values.") ]
                                        )
                                        keyValues
                                        (Ok [])

                        _ ->
                            Err [ error (UnknownArgName fieldname) ]

        _ ->
            Err [ error (Todo "All inputs must be variables for now.  No inline values.") ]


canonicalizeField : GraphQL.Schema.Schema -> GraphQL.Schema.ObjectDetails -> AST.Selection -> CanResult Can.Selection
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
                        , type_ = GraphQL.Schema.Scalar "typename"
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
                        canonicalizeFieldType schema object field matched.type_ selection matched

                    Nothing ->
                        err [ error (FieldUnknown { object = object.name, field = fieldName }) ]

        AST.FragmentSpreadSelection frag ->
            err [ todo "Fragments in objects aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            err [ todo "Inline fragments are not allowed" ]


convertDirective dir =
    { name = convertName dir.name
    , arguments =
        dir.arguments
    }


{-|

    For `field`, we are matching it up with types from `schema`

-}
canonicalizeFieldType :
    GraphQL.Schema.Schema
    -> GraphQL.Schema.ObjectDetails
    -> AST.FieldDetails
    -> GraphQL.Schema.Type
    -> AST.Selection
    -> GraphQL.Schema.Field
    -> CanResult Can.Selection
canonicalizeFieldType schema object field type_ selection schemaField =
    let
        argValidation =
            reduceConcat (validateArg schema schemaField) field.arguments (Ok [])
    in
    case argValidation of
        Err errors ->
            CanError errors

        Ok vars ->
            case type_ of
                GraphQL.Schema.Scalar name ->
                    success (addVars vars emptyCache)
                        (Can.FieldScalar
                            { alias_ = Maybe.map convertName field.alias_
                            , name = convertName field.name
                            , arguments = []
                            , directives = List.map convertDirective field.directives
                            , type_ = schemaField.type_
                            }
                        )

                GraphQL.Schema.InputObject name ->
                    err [ todo "Invalid schema!  Weird InputObject" ]

                GraphQL.Schema.Object name ->
                    case Dict.get name schema.objects of
                        Nothing ->
                            err [ error (ObjectUnknown name) ]

                        Just obj ->
                            let
                                selectionResult =
                                    reduce (canonicalizeField schema obj) field.selection emptySuccess
                            in
                            case selectionResult of
                                CanSuccess cache canSelection ->
                                    CanSuccess (addVars vars cache)
                                        (Can.FieldObject
                                            { alias_ = Maybe.map convertName field.alias_
                                            , name = convertName field.name
                                            , arguments = field.arguments
                                            , directives = List.map convertDirective field.directives
                                            , selection = canSelection
                                            , object = obj
                                            , wrapper = GraphQL.Schema.getWrap schemaField.type_
                                            }
                                        )

                                CanError errorMsg ->
                                    CanError errorMsg

                GraphQL.Schema.Enum name ->
                    case Dict.get name schema.enums of
                        Nothing ->
                            err [ error (EnumUnknown name) ]

                        Just enum ->
                            CanSuccess (addVars vars emptyCache)
                                (Can.FieldEnum
                                    { alias_ = Maybe.map convertName field.alias_
                                    , name = convertName field.name
                                    , arguments = field.arguments
                                    , directives = List.map convertDirective field.directives
                                    , enumName = enum.name
                                    , values = enum.values
                                    , wrapper = GraphQL.Schema.getWrap schemaField.type_
                                    }
                                )

                GraphQL.Schema.Union name ->
                    case Dict.get name schema.unions of
                        Nothing ->
                            err [ error (UnionUnknown name) ]

                        Just union ->
                            case extractUnionTags union.variants [] of
                                Nothing ->
                                    err [ todo "Things in a union are not objects!" ]

                                Just variants ->
                                    let
                                        selectionResult =
                                            reduce (canonicalizeUnionField schema union variants) field.selection emptySuccess
                                    in
                                    case selectionResult of
                                        CanSuccess cache canSelection ->
                                            CanSuccess (addVars vars cache)
                                                (Can.FieldUnion
                                                    { alias_ = Maybe.map convertName field.alias_
                                                    , name = convertName field.name
                                                    , arguments = []
                                                    , directives = List.map convertDirective field.directives
                                                    , selection = canSelection
                                                    , union = union
                                                    , wrapper = GraphQL.Schema.getWrap schemaField.type_
                                                    }
                                                )

                                        CanError errorMsg ->
                                            CanError errorMsg

                GraphQL.Schema.Interface name ->
                    err [ todo "Field Interfaces!" ]

                GraphQL.Schema.List_ inner ->
                    canonicalizeFieldType schema object field inner selection schemaField

                GraphQL.Schema.Nullable inner ->
                    canonicalizeFieldType schema object field inner selection schemaField


extractUnionTags : List GraphQL.Schema.Variant -> List String -> Maybe (List String)
extractUnionTags vars captured =
    case vars of
        [] ->
            Just captured

        top :: remain ->
            case top.kind of
                GraphQL.Schema.ObjectKind name ->
                    extractUnionTags remain (name :: captured)

                _ ->
                    Nothing


canonicalizeUnionField : GraphQL.Schema.Schema -> GraphQL.Schema.UnionDetails -> List String -> AST.Selection -> CanResult Can.Selection
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
                        , type_ = GraphQL.Schema.Scalar "typename"
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

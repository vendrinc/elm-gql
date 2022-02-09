module GraphQL.Operations.Canonicalize exposing (canonicalize, cyan, errorToString)

{-| -}

import Dict exposing (Dict)
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Schema
import Internal.Compiler exposing (formatValue)


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
    | UndeclaredVariable
        { name : String
        , knownVariables : List String
        }
    | VariableIssueSummary VariableSummary
    | FieldAliasRequired
        { fieldName : String
        }
    | NonExhaustiveVariants
        { unionName : String
        , leftOver : List String
        }
    | MissingTypename
        { tag : String
        }
    | EmptyUnionVariantSelection
        { tag : String
        }
    | IncorrectInlineInput
        { schema : GraphQL.Schema.Type
        , arg : String
        , found : AST.Value
        }


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



{- Error rendering -}


{-| An indented block with a newline above and below
-}
block : List String -> String
block lines =
    "\n    " ++ String.join "\n    " lines ++ "\n"



{-
   If more colors are wanted, this is a good reference:
   https://github.com/chalk/chalk/blob/main/source/vendor/ansi-styles/index.js
-}


cyan : String -> String
cyan str =
    color 36 39 str


yellow : String -> String
yellow str =
    color 33 39 str


green : String -> String
green str =
    color 32 39 str


red : String -> String
red str =
    color 31 39 str


grey : String -> String
grey str =
    color 90 39 str


color : Int -> Int -> String -> String
color openCode closeCode content =
    let
        delim code =
            --"\\u001B[" ++ String.fromInt code ++ "m"
            "\u{001B}[" ++ String.fromInt code ++ "m"
    in
    delim openCode ++ content ++ delim closeCode



{- -}


errorToString : Error -> String
errorToString (Error details) =
    case details.error of
        Todo msg ->
            "Todo: " ++ msg

        EnumUnknown name ->
            String.join "\n"
                [ "I don't recognize this name:"
                , block
                    [ yellow name ]
                , "Add an alias to one of them so there's no confusion!"
                ]

        QueryUnknown name ->
            String.join "\n"
                [ "I don't recognize this query:"
                , block
                    [ yellow name ]
                , "Add an alias to one of them so there's no confusion!"
                ]

        ObjectUnknown name ->
            String.join "\n"
                [ "I don't recognize this object:"
                , block
                    [ yellow name ]
                , "Add an alias to one of them so there's no confusion!"
                ]

        UnionUnknown name ->
            String.join "\n"
                [ "I don't recognize this union:"
                , block
                    [ yellow name ]
                , "Add an alias to one of them so there's no confusion!"
                ]

        UnknownArgName name ->
            "Unknown argument named: " ++ name

        FieldUnknown field ->
            String.join "\n"
                [ "You're trying to access"
                , block
                    [ cyan (field.object ++ "." ++ field.field)
                    ]
                , "But I don't see a " ++ cyan field.field ++ " field on " ++ cyan field.object
                ]

        UndeclaredVariable undeclared ->
            "Undeclared variable: " ++ undeclared.name

        FieldAliasRequired deets ->
            String.join "\n"
                [ "I found two fields that have the same name:"
                , block
                    [ yellow deets.fieldName ]
                , "Add an alias to one of them so there's no confusion!"
                ]

        NonExhaustiveVariants deets ->
            String.join "\n"
                [ "There are still some variants that have not been covered for " ++ cyan deets.unionName
                , block
                    (List.map yellow deets.leftOver)
                , "Add them to your query so that we know what data to select if they show up!"
                ]

        MissingTypename deets ->
            String.join "\n"
                [ cyan deets.tag ++ " needs to select for " ++ yellow "__typename"
                , block
                    [ "... on " ++ deets.tag ++ " {"
                    , yellow "    __typename"
                    , grey "    # ... other fields"
                    , "}"
                    ]
                , "If we don't have this, then we can't be totally sure what type is returned."
                ]

        EmptyUnionVariantSelection deets ->
            String.join "\n"
                [ cyan deets.tag ++ " needs to select at least one field."
                , block
                    [ "... on " ++ deets.tag ++ " {"
                    , yellow "    __typename"
                    , "}"
                    ]
                , "If you don't need any more data, just add " ++ yellow "__typename"
                ]

        IncorrectInlineInput deets ->
            String.join "\n"
                [ cyan deets.arg ++ " has the wrong type. I was expecting:"
                , block
                    [ yellow (GraphQL.Schema.typeToString deets.schema)
                    ]
                , "But found:"
                , block
                    [ yellow (AST.valueToString deets.found)
                    ]
                ]

        VariableIssueSummary summary ->
            case summary.declared of
                [] ->
                    String.join "\n"
                        [ "It looks like no variables are declared."
                        , "Here's what I think the variables should be:"
                        , block
                            (List.map
                                renderSuggestion
                                (List.reverse summary.suggestions)
                            )
                        ]

                _ ->
                    String.join "\n"
                        [ "I found the following variables:"
                        , block
                            (List.map
                                renderDeclared
                                (List.reverse summary.declared)
                            )
                        , if List.length summary.issues == 1 then
                            "But I ran into an issue:"

                          else
                            "But I ran into a few issues:"
                        , block
                            (List.concatMap
                                renderIssue
                                summary.issues
                            )
                        , "Here's what I think the variables should be:"
                        , block
                            (List.map
                                renderSuggestion
                                (List.reverse summary.suggestions)
                            )
                        ]


renderDeclared : DeclaredVariable -> String
renderDeclared declared =
    case declared.type_ of
        Nothing ->
            yellow ("$" ++ declared.name)

        Just declaredType ->
            yellow ("$" ++ declared.name) ++ grey ": " ++ cyan declaredType


renderSuggestion : SuggestedVariable -> String
renderSuggestion sug =
    yellow ("$" ++ sug.name) ++ grey ": " ++ cyan sug.type_


renderIssue : VarIssue -> List String
renderIssue issue =
    case issue of
        Unused var ->
            [ yellow ("$" ++ var.name) ++ " is unused." ]

        UnexpectedType var ->
            case var.found of
                Nothing ->
                    [ yellow ("$" ++ var.name) ++ " has no type declaration" ]

                Just foundType ->
                    let
                        variableName =
                            "$" ++ var.name
                    in
                    [ yellow variableName
                        ++ " is declared as "
                        ++ cyan foundType
                    , String.repeat (String.length variableName - 6) " "
                        ++ "but is expected to be "
                        ++ cyan var.expected
                    ]

        Undeclared var ->
            [ yellow ("$" ++ var.name) ++ " is undeclared (missing from the top)." ]


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

                GraphQL.Schema.Nullable innerSchema ->
                    -- the query can mark something as required even if it's optional in the schema
                    doTypesMatch innerSchema astType

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
            , suggestions =
                if typesMatch then
                    -- we do this so that when we print an error message
                    -- If the user has specified that this is a required value
                    -- but the schema says it's optional
                    -- we maintain the required-ness
                    { name = AST.nameToString def.variable.name
                    , type_ =
                        AST.typeToGqlString def.type_
                    }
                        :: summary.suggestions

                else
                    suggestion :: summary.suggestions
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


canonicalizeOperation :
    GraphQL.Schema.Schema
    -> AST.OperationType
    -> AST.Selection
    -> CanResult Can.Selection
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
                    canonicalizeFieldType schema field query.type_ [] selection query
                        |> Tuple.second

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

This function both

1.  gathers variables that should be at the top of the query.

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
    case List.head (List.filter (\a -> a.name == fieldname) spec.arguments) of
        Nothing ->
            Err [ error (UnknownArgName ("truly unknown" ++ fieldname)) ]

        Just schemaVar ->
            case validateInput schema schemaVar.type_ fieldname argInQuery.value of
                Valid vars ->
                    Ok vars

                InputError errorDetails ->
                    Err [ error errorDetails ]

                Mismatch ->
                    Err
                        [ error
                            (IncorrectInlineInput
                                { schema = schemaVar.type_
                                , arg = fieldname
                                , found = argInQuery.value
                                }
                            )
                        ]


type InputValidation
    = Valid (List ( String, GraphQL.Schema.Type ))
    | InputError ErrorDetails
    | Mismatch


validateInput :
    GraphQL.Schema.Schema
    -> GraphQL.Schema.Type
    -> String
    -> AST.Value
    -> InputValidation
validateInput schema schemaType fieldName astValue =
    case astValue of
        AST.Var var ->
            let
                varname =
                    AST.nameToString var.name
            in
            Valid [ ( varname, schemaType ) ]

        AST.Object keyValues ->
            case schemaType of
                GraphQL.Schema.InputObject inputObjectName ->
                    case Dict.get inputObjectName schema.inputObjects of
                        Nothing ->
                            InputError (UnknownArgName fieldName)

                        Just inputObject ->
                            validateObject schema fieldName keyValues inputObject

                GraphQL.Schema.Nullable (GraphQL.Schema.InputObject inputObjectName) ->
                    case Dict.get inputObjectName schema.inputObjects of
                        Nothing ->
                            InputError (UnknownArgName fieldName)

                        Just inputObject ->
                            validateObject schema fieldName keyValues inputObject

                _ ->
                    InputError (UnknownArgName fieldName)

        AST.Str str ->
            case schemaType of
                GraphQL.Schema.Scalar "Int" ->
                    Mismatch

                GraphQL.Schema.Scalar "Float" ->
                    Mismatch

                GraphQL.Schema.Scalar "Boolean" ->
                    Mismatch

                GraphQL.Schema.Scalar _ ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput schema inner fieldName astValue

                _ ->
                    Mismatch

        AST.Integer int ->
            case schemaType of
                GraphQL.Schema.Scalar "Int" ->
                    Valid []

                GraphQL.Schema.Scalar "Float" ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput schema inner fieldName astValue

                _ ->
                    Mismatch

        AST.Decimal float ->
            case schemaType of
                GraphQL.Schema.Scalar "Float" ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput schema inner fieldName astValue

                _ ->
                    Mismatch

        AST.Boolean bool ->
            case schemaType of
                GraphQL.Schema.Scalar "Boolean" ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput schema inner fieldName astValue

                _ ->
                    Mismatch

        AST.Null ->
            case schemaType of
                GraphQL.Schema.Nullable _ ->
                    Valid []

                _ ->
                    Mismatch

        AST.Enum enumName ->
            case schemaType of
                GraphQL.Schema.Enum _ ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput schema inner fieldName astValue

                _ ->
                    Mismatch

        AST.ListValue list ->
            case schemaType of
                GraphQL.Schema.List_ innerList ->
                    List.foldl
                        (\item current ->
                            case current of
                                Valid validArgs ->
                                    case validateInput schema innerList fieldName item of
                                        Valid newArgs ->
                                            Valid (newArgs ++ validArgs)

                                        validationError ->
                                            validationError

                                _ ->
                                    current
                        )
                        (Valid [])
                        list

                GraphQL.Schema.Nullable inner ->
                    validateInput schema inner fieldName astValue

                _ ->
                    Mismatch


validateObject schema fieldName keyValues inputObject =
    List.foldl
        (\( keyName, value ) current ->
            let
                key =
                    AST.nameToString keyName
            in
            case current of
                Valid argValues ->
                    case List.head (List.filter (\a -> a.name == key) inputObject.fields) of
                        Nothing ->
                            InputError (Todo "1. All inputs must be variables for now.  No inline values.")

                        Just field ->
                            case validateInput schema field.type_ fieldName value of
                                Valid fieldArgs ->
                                    Valid (argValues ++ fieldArgs)

                                validationError ->
                                    validationError

                _ ->
                    current
        )
        (Valid [])
        keyValues


type alias UsedNames =
    List String


emptyUsedNames : UsedNames
emptyUsedNames =
    []


canonicalizeField :
    GraphQL.Schema.Schema
    -> GraphQL.Schema.ObjectDetails
    -> AST.Selection
    ->
        { result : CanResult (List Can.Selection)
        , fieldNames : UsedNames
        }
    ->
        { result : CanResult (List Can.Selection)
        , fieldNames : UsedNames
        }
canonicalizeField schema object selection found =
    case selection of
        AST.Field field ->
            let
                fieldName =
                    AST.nameToString field.name

                aliased =
                    AST.getAliasedName field
            in
            if List.member aliased found.fieldNames then
                { result =
                    err
                        [ error
                            (FieldAliasRequired
                                { fieldName = aliased
                                }
                            )
                        ]
                , fieldNames = found.fieldNames
                }

            else if fieldName == "__typename" then
                { result =
                    addToResult emptyCache
                        (Can.FieldScalar
                            { alias_ = Maybe.map convertName field.alias_
                            , name = convertName field.name
                            , arguments = []
                            , directives = List.map convertDirective field.directives
                            , type_ = GraphQL.Schema.Scalar "typename"
                            }
                        )
                        found.result
                , fieldNames = found.fieldNames
                }

            else
                let
                    matchedField =
                        object.fields
                            |> List.filter (\fld -> fld.name == fieldName)
                            |> List.head
                in
                case matchedField of
                    Just matched ->
                        let
                            ( newNames, cannedSelection ) =
                                canonicalizeFieldType schema
                                    field
                                    matched.type_
                                    (aliased :: found.fieldNames)
                                    selection
                                    matched
                        in
                        { result =
                            case cannedSelection of
                                CanSuccess cache sel ->
                                    addToResult cache sel found.result

                                CanError errMsg ->
                                    CanError errMsg
                        , fieldNames = newNames
                        }

                    Nothing ->
                        { result =
                            err
                                [ error
                                    (FieldUnknown
                                        { object = object.name
                                        , field = fieldName
                                        }
                                    )
                                ]
                        , fieldNames = found.fieldNames
                        }

        AST.FragmentSpreadSelection frag ->
            { result = err [ todo "Fragments in objects aren't suported yet!" ]
            , fieldNames = found.fieldNames
            }

        AST.InlineFragmentSelection inline ->
            { result = err [ todo "Inline fragments are not allowed" ]
            , fieldNames = found.fieldNames
            }


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
    -> AST.FieldDetails
    -> GraphQL.Schema.Type
    -> UsedNames
    -> AST.Selection
    -> GraphQL.Schema.Field
    -> ( UsedNames, CanResult Can.Selection )
canonicalizeFieldType schema field type_ usedNames selection schemaField =
    let
        argValidation =
            reduceConcat (validateArg schema schemaField) field.arguments (Ok [])
    in
    case argValidation of
        Err errors ->
            ( usedNames, CanError errors )

        Ok vars ->
            case type_ of
                GraphQL.Schema.Scalar name ->
                    ( usedNames
                    , success (addVars vars emptyCache)
                        (Can.FieldScalar
                            { alias_ = Maybe.map convertName field.alias_
                            , name = convertName field.name
                            , arguments = []
                            , directives = List.map convertDirective field.directives
                            , type_ = schemaField.type_
                            }
                        )
                    )

                GraphQL.Schema.InputObject name ->
                    ( usedNames, err [ todo "Invalid schema!  Weird InputObject" ] )

                GraphQL.Schema.Object name ->
                    case Dict.get name schema.objects of
                        Nothing ->
                            ( usedNames, err [ error (ObjectUnknown name) ] )

                        Just obj ->
                            let
                                selectionResult =
                                    List.foldl
                                        (canonicalizeField schema obj)
                                        { result = emptySuccess
                                        , fieldNames = emptyUsedNames
                                        }
                                        field.selection
                            in
                            case selectionResult.result of
                                CanSuccess cache canSelection ->
                                    ( usedNames
                                    , CanSuccess (addVars vars cache)
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
                                    )

                                CanError errorMsg ->
                                    ( usedNames, CanError errorMsg )

                GraphQL.Schema.Enum name ->
                    case Dict.get name schema.enums of
                        Nothing ->
                            ( usedNames, err [ error (EnumUnknown name) ] )

                        Just enum ->
                            ( usedNames
                            , CanSuccess (addVars vars emptyCache)
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
                            )

                GraphQL.Schema.Union name ->
                    case Dict.get name schema.unions of
                        Nothing ->
                            ( usedNames, err [ error (UnionUnknown name) ] )

                        Just union ->
                            case extractUnionTags union.variants [] of
                                Nothing ->
                                    ( usedNames, err [ todo "Things in a union are not objects!" ] )

                                Just variants ->
                                    let
                                        selectsForTypename =
                                            List.any
                                                (\sel ->
                                                    case sel of
                                                        AST.Field firstField ->
                                                            case AST.nameToString firstField.name of
                                                                "__typename" ->
                                                                    True

                                                                _ ->
                                                                    False

                                                        _ ->
                                                            False
                                                )
                                                field.selection

                                        selectionResult =
                                            List.foldl
                                                (canonicalizeUnionField schema union)
                                                { result = emptySuccess
                                                , fieldNames = emptyUsedNames
                                                , variants = variants
                                                , typenameAlreadySelected = selectsForTypename
                                                }
                                                field.selection
                                    in
                                    case selectionResult.result of
                                        CanSuccess cache canSelection ->
                                            ( selectionResult.fieldNames
                                            , case selectionResult.variants of
                                                [] ->
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

                                                leftover ->
                                                    err
                                                        [ error
                                                            (NonExhaustiveVariants
                                                                { unionName = name
                                                                , leftOver = leftover
                                                                }
                                                            )
                                                        ]
                                            )

                                        CanError errorMsg ->
                                            ( selectionResult.fieldNames, CanError errorMsg )

                GraphQL.Schema.Interface name ->
                    ( usedNames, err [ todo "Field Interfaces!" ] )

                GraphQL.Schema.List_ inner ->
                    canonicalizeFieldType schema field inner usedNames selection schemaField

                GraphQL.Schema.Nullable inner ->
                    canonicalizeFieldType schema field inner usedNames selection schemaField


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


addToResult newCache newItem result =
    case result of
        CanSuccess cache existing ->
            CanSuccess (mergeCaches newCache cache) (newItem :: existing)

        CanError errs ->
            CanError errs


canonicalizeUnionField :
    GraphQL.Schema.Schema
    -> GraphQL.Schema.UnionDetails
    -> AST.Selection
    ->
        { result : CanResult (List Can.Selection)
        , fieldNames : UsedNames
        , variants : List String
        , typenameAlreadySelected : Bool
        }
    ->
        { result : CanResult (List Can.Selection)
        , fieldNames : UsedNames
        , variants : List String
        , typenameAlreadySelected : Bool
        }
canonicalizeUnionField schema union selection found =
    case selection of
        AST.Field field ->
            let
                fieldName =
                    AST.nameToString field.name
            in
            --- NOTE, we could probably be more sophisticated here!
            if fieldName == "__typename" then
                { result =
                    addToResult emptyCache
                        (Can.FieldScalar
                            { alias_ = Maybe.map convertName field.alias_
                            , name = convertName field.name
                            , arguments = []
                            , directives = List.map convertDirective field.directives
                            , type_ = GraphQL.Schema.Scalar "typename"
                            }
                        )
                        found.result
                , fieldNames = found.fieldNames
                , variants = found.variants
                , typenameAlreadySelected = found.typenameAlreadySelected
                }

            else
                { result =
                    err [ todo "Common selections not allowed for gql unions" ]
                , fieldNames = found.fieldNames
                , variants = found.variants
                , typenameAlreadySelected = found.typenameAlreadySelected
                }

        AST.FragmentSpreadSelection frag ->
            { result =
                err [ todo "Fragments in objects aren't suported yet!" ]
            , fieldNames = found.fieldNames
            , variants = found.variants
            , typenameAlreadySelected = found.typenameAlreadySelected
            }

        AST.InlineFragmentSelection inline ->
            case inline.selection of
                [] ->
                    { result =
                        err [ error (EmptyUnionVariantSelection { tag = AST.nameToString inline.tag }) ]
                    , fieldNames = found.fieldNames
                    , variants = found.variants
                    , typenameAlreadySelected = found.typenameAlreadySelected
                    }

                _ ->
                    let
                        tag =
                            AST.nameToString inline.tag

                        ( tagMatches, leftOvertags ) =
                            matchTag tag found.variants ( False, [] )
                    in
                    if tagMatches then
                        case Dict.get tag schema.objects of
                            Nothing ->
                                { result =
                                    err [ error (ObjectUnknown tag) ]
                                , fieldNames = found.fieldNames
                                , variants = leftOvertags
                                , typenameAlreadySelected = found.typenameAlreadySelected
                                }

                            Just obj ->
                                let
                                    selectsForTypename =
                                        if found.typenameAlreadySelected then
                                            True

                                        else
                                            List.any
                                                (\sel ->
                                                    case sel of
                                                        AST.Field firstField ->
                                                            case AST.nameToString firstField.name of
                                                                "__typename" ->
                                                                    True

                                                                _ ->
                                                                    False

                                                        _ ->
                                                            False
                                                )
                                                inline.selection

                                    selectionResult =
                                        List.foldl
                                            (canonicalizeField schema obj)
                                            { result = emptySuccess
                                            , fieldNames = found.fieldNames
                                            }
                                            inline.selection
                                in
                                if selectsForTypename then
                                    case selectionResult.result of
                                        CanSuccess cache canSelection ->
                                            { result =
                                                addToResult cache
                                                    (Can.UnionCase
                                                        { tag = Can.Name tag
                                                        , directives = List.map convertDirective inline.directives
                                                        , selection = canSelection
                                                        }
                                                    )
                                                    found.result
                                            , fieldNames = selectionResult.fieldNames
                                            , variants = leftOvertags
                                            , typenameAlreadySelected = found.typenameAlreadySelected
                                            }

                                        CanError errorMsg ->
                                            { result =
                                                CanError errorMsg
                                            , fieldNames = selectionResult.fieldNames
                                            , variants = leftOvertags
                                            , typenameAlreadySelected = found.typenameAlreadySelected
                                            }

                                else
                                    { result =
                                        err [ error (MissingTypename { tag = AST.nameToString inline.tag }) ]
                                    , fieldNames = found.fieldNames
                                    , variants = found.variants
                                    , typenameAlreadySelected = found.typenameAlreadySelected
                                    }

                    else
                        { result =
                            err [ todo (tag ++ " does not match!") ]
                        , fieldNames = found.fieldNames
                        , variants = found.variants
                        , typenameAlreadySelected = found.typenameAlreadySelected
                        }


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

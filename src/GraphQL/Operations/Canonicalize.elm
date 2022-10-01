module GraphQL.Operations.Canonicalize exposing (canonicalize, cyan, errorToString)

{-| -}

import Dict exposing (Dict)
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Schema


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
    = QueryUnknown String
    | EnumUnknown String
    | ObjectUnknown String
    | InterfaceUnknown String
    | UnionUnknown String
    | UnknownArgs
        { field : String
        , unknownArgs : List String
        , allowedArgs : List GraphQL.Schema.Argument
        }
    | EmptySelection
        { field : String
        , fieldType : String
        , options : List { field : String, type_ : String }
        }
    | FieldUnknown
        { object : String
        , field : String
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
    | FragmentNotFound
        { found : String
        , object : String
        , options :
            List Can.Fragment
        }
    | FragmentTargetDoesntExist
        { fragmentName : String
        , typeCondition : String
        }
    | FragmentDuplicateFound
        { firstName : String
        , firstTypeCondition : String
        , firstFieldCount : Int
        , secondName : String
        , secondTypeCondition : String
        , secondFieldCount : Int
        }
    | Todo String


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
                ]

        QueryUnknown name ->
            String.join "\n"
                [ "I don't recognize this query:"
                , block
                    [ yellow name ]
                ]

        ObjectUnknown name ->
            String.join "\n"
                [ "I don't recognize this object:"
                , block
                    [ yellow name ]
                ]

        InterfaceUnknown name ->
            String.join "\n"
                [ "I don't recognize this interface:"
                , block
                    [ yellow name ]
                ]

        UnionUnknown name ->
            String.join "\n"
                [ "I don't recognize this union:"
                , block
                    [ yellow name ]
                ]

        FieldUnknown field ->
            String.join "\n"
                [ "You're trying to access"
                , block
                    [ cyan (field.object ++ "." ++ field.field)
                    ]
                , "But I don't see a " ++ cyan field.field ++ " field on " ++ cyan field.object
                ]

        UnknownArgs deets ->
            case deets.allowedArgs of
                [] ->
                    String.join "\n"
                        [ yellow deets.field ++ " has the following arguments:"
                        , block
                            (List.map yellow deets.unknownArgs)
                        , "but the GQL schema says it can't have any!"
                        , "Maybe the arguments are on the wrong field?"
                        ]

                _ ->
                    String.join "\n"
                        [ yellow deets.field ++ " has these arguments, but I don't recognize them!"
                        , block
                            (List.map yellow deets.unknownArgs)
                        , "Here are the arguments that this field can have:"
                        , block
                            (List.map
                                (\opt ->
                                    yellow opt.name ++ ": " ++ cyan (GraphQL.Schema.typeToString opt.type_)
                                )
                                deets.allowedArgs
                            )
                        ]

        EmptySelection deets ->
            String.join "\n"
                [ "This field isn't selecting anything"
                , block
                    [ yellow deets.field ]
                , "But it is a " ++ yellow deets.fieldType ++ ", which needs to select some fields."
                , "You can either remove it or select some of the following fields:"
                , block
                    (List.map
                        (\opt ->
                            yellow opt.field ++ ": " ++ cyan opt.type_
                        )
                        deets.options
                    )
                ]

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

        FragmentNotFound deets ->
            let
                fragmentsThatMatchThisObject =
                    List.filter
                        (\frag ->
                            deets.object == Can.nameToString frag.typeCondition
                        )
                        deets.options
            in
            case fragmentsThatMatchThisObject of
                [] ->
                    case deets.options of
                        [] ->
                            String.join "\n"
                                [ "I found a usage of a fragment named " ++ cyan deets.found ++ ", but I don't see any fragments defined in this document!"
                                , "You could add one by adding this if you want."
                                , block
                                    [ cyan "fragment" ++ " on " ++ yellow deets.object ++ " {"
                                    , "    # select some fields here!"
                                    , "}"
                                    ]
                                , "Check out https://graphql.org/learn/queries/#fragments to learn more!"
                                ]

                        _ ->
                            String.join "\n"
                                [ "I don't recognize the fragment named " ++ cyan deets.found ++ "."
                                , "Here are the fragments I know about."
                                , block
                                    (List.map (yellow << Can.nameToString << .name)
                                        deets.options
                                    )
                                ]

                [ single ] ->
                    String.join "\n"
                        [ "I don't recognize the fragment named " ++ cyan deets.found ++ "."
                        , "Do you mean?"
                        , block
                            (List.map (yellow << Can.nameToString << .name)
                                fragmentsThatMatchThisObject
                            )
                        ]

                _ ->
                    String.join "\n"
                        [ "I don't recognize the fragment named " ++ cyan deets.found ++ "."
                        , "Do you mean one of these?"
                        , block
                            (List.map (yellow << Can.nameToString << .name)
                                fragmentsThatMatchThisObject
                            )
                        ]

        FragmentTargetDoesntExist deets ->
            String.join "\n"
                [ "I found this fragment:"
                , block
                    [ "fragment " ++ cyan deets.fragmentName ++ " on " ++ yellow deets.typeCondition
                    ]
                , "But I wasn't able to find " ++ yellow deets.typeCondition ++ " in the schema."
                , "Is there a typo?"
                ]

        FragmentDuplicateFound deets ->
            if deets.firstTypeCondition == deets.secondTypeCondition && deets.firstFieldCount == deets.secondFieldCount then
                String.join "\n"
                    [ "I found two fragments with the name " ++ yellow deets.firstName
                    , "Maybe they're just duplicates?"
                    , "Fragments need to have globally unique names. Can you rename one?"
                    ]

            else
                String.join "\n"
                    [ "I found two fragments with the name " ++ yellow deets.firstName
                    , block
                        [ "fragment " ++ cyan deets.firstName ++ " on " ++ yellow deets.firstTypeCondition
                        , "fragment " ++ cyan deets.secondName ++ " on " ++ yellow deets.secondTypeCondition
                        ]
                    , "Fragments need to have globally unique names. Can you rename one?"
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
        fragmentResult =
            List.foldl
                (getFragments
                    schema
                )
                (Ok Dict.empty)
                doc.definitions
    in
    case fragmentResult of
        Err fragErrorDetails ->
            Err (List.map error fragErrorDetails)

        Ok fragments ->
            let
                canonicalizedFragments =
                    List.foldl
                        (canonicalizeFragment schema)
                        (CanSuccess emptyCache Dict.empty)
                        (List.sortBy AST.fragmentCount
                            (Dict.values fragments)
                        )
            in
            case canonicalizedFragments of
                CanSuccess fragmentCacne canonicalFrags ->
                    let
                        canonicalizedDefinitions =
                            reduce
                                (canonicalizeDefinition
                                    { schema = schema
                                    , fragments =
                                        canonicalFrags
                                    }
                                )
                                doc.definitions
                                emptySuccess
                    in
                    case canonicalizedDefinitions of
                        CanSuccess cache defs ->
                            Ok
                                { definitions = defs
                                , fragments = Dict.values canonicalFrags
                                }

                        CanError errorMsg ->
                            Err errorMsg

                CanError errorMsg ->
                    Err errorMsg


type alias References =
    { schema : GraphQL.Schema.Schema
    , fragments : Dict String Can.Fragment
    }


type alias VarCache =
    { varTypes : List ( String, GraphQL.Schema.Type )
    }


emptyCache : VarCache
emptyCache =
    { varTypes = []
    }


addVars vars cache =
    { varTypes =
        -- NOTE, there is an opporunity to check if there is avariable collision here
        -- not a problem if there is a collision, only if they have conflicting gql types
        vars ++ cache.varTypes
    }


mergeCaches one two =
    { varTypes =
        -- NOTE, there is an opporunity to check if there is avariable collision here
        -- not a problem if there is a collision, only if they have conflicting gql types
        one.varTypes ++ two.varTypes
    }


getFragments :
    GraphQL.Schema.Schema
    -> AST.Definition
    -> Result (List ErrorDetails) (Dict String AST.FragmentDetails)
    -> Result (List ErrorDetails) (Dict String AST.FragmentDetails)
getFragments schema def result =
    case result of
        Err errs ->
            Err errs

        Ok frags ->
            case def of
                AST.Operation op ->
                    result

                AST.Fragment frag ->
                    let
                        name =
                            AST.nameToString frag.name
                    in
                    case Dict.get name frags of
                        Nothing ->
                            frags
                                |> Dict.insert
                                    (AST.nameToString frag.name)
                                    frag
                                |> Ok

                        Just found ->
                            Err
                                [ FragmentDuplicateFound
                                    { firstName = AST.nameToString frag.name
                                    , firstTypeCondition = AST.nameToString frag.typeCondition
                                    , firstFieldCount = List.length frag.selection
                                    , secondName = AST.nameToString found.name
                                    , secondTypeCondition = AST.nameToString found.typeCondition
                                    , secondFieldCount = List.length found.selection
                                    }
                                ]


reduce :
    (item -> Maybe (CanResult result))
    -> List item
    -> CanResult (List result)
    -> CanResult (List result)
reduce isValid items res =
    case items of
        [] ->
            res

        top :: remain ->
            case isValid top of
                Nothing ->
                    reduce isValid remain res

                Just (CanSuccess cache valid) ->
                    case res of
                        CanSuccess existingCache existing ->
                            reduce isValid
                                remain
                                (CanSuccess (mergeCaches cache existingCache) (valid :: existing))

                        CanError _ ->
                            res

                Just (CanError errorMessage) ->
                    let
                        newResult =
                            case res of
                                CanSuccess _ _ ->
                                    CanError errorMessage

                                CanError existingErrors ->
                                    CanError (errorMessage ++ existingErrors)
                    in
                    reduce isValid remain newResult


convertName : AST.Name -> Can.Name
convertName (AST.Name str) =
    Can.Name str


canonicalizeDefinition :
    References
    -> AST.Definition
    -> Maybe (CanResult Can.Definition)
canonicalizeDefinition refs def =
    case def of
        AST.Fragment details ->
            Nothing

        AST.Operation details ->
            let
                globalOperationName =
                    Maybe.map convertName details.name

                operationType =
                    case details.operationType of
                        AST.Query ->
                            Can.Query

                        AST.Mutation ->
                            Can.Mutation

                initialNameCache =
                    UsedNames
                        { siblingAliases = []
                        , siblingStack = []
                        , breadcrumbs = []
                        , globalNames =
                            []
                        }
                        |> getGlobalName
                            (globalOperationName
                                |> Maybe.map Can.nameToString
                                |> Maybe.withDefault (opTypeName operationType)
                            )

                fieldResult =
                    List.foldl
                        (\field ( used, result ) ->
                            case result of
                                CanSuccess oldCache oldItems ->
                                    let
                                        ( newUsed, newResult ) =
                                            canonicalizeOperation
                                                refs
                                                details.operationType
                                                used
                                                field
                                    in
                                    ( newUsed
                                    , case newResult of
                                        CanError errorMessage ->
                                            CanError errorMessage

                                        CanSuccess newCache validItem ->
                                            CanSuccess
                                                (mergeCaches oldCache newCache)
                                                (validItem :: oldItems)
                                    )

                                CanError _ ->
                                    ( used, result )
                        )
                        ( initialNameCache.used
                        , emptySuccess
                        )
                        details.fields
            in
            Just <|
                case Tuple.second fieldResult of
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
                                        operationType
                                    , name = globalOperationName
                                    , variableDefinitions =
                                        variableSummary.valid
                                    , directives =
                                        List.map convertDirective details.directives
                                    , fields = fields
                                    }

                    CanError errorMsg ->
                        CanError errorMsg


opTypeName : Can.OperationType -> String
opTypeName op =
    case op of
        Can.Query ->
            "Query"

        Can.Mutation ->
            "Mutation"


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
    References
    -> AST.OperationType
    -> UsedNames
    -> AST.Selection
    -> ( UsedNames, CanResult Can.Field )
canonicalizeOperation refs op used selection =
    case selection of
        AST.Field field ->
            let
                desiredName =
                    field.alias_
                        |> Maybe.withDefault field.name
                        |> convertName
                        |> Can.nameToString

                matched =
                    case op of
                        AST.Query ->
                            Dict.get (AST.nameToString field.name) refs.schema.queries

                        AST.Mutation ->
                            Dict.get (AST.nameToString field.name) refs.schema.mutations
            in
            case matched of
                Nothing ->
                    ( used, err [ error (QueryUnknown (AST.nameToString field.name)) ] )

                Just query ->
                    canonicalizeFieldType refs
                        field
                        used
                        query
                        |> Tuple.mapFirst dropLevel

        AST.FragmentSpreadSelection frag ->
            ( used, err [ todo "Fragments in unions aren't suported yet!" ] )

        AST.InlineFragmentSelection inline ->
            -- This is when we're selecting a union fragment
            ( used, err [ todo "Unions not supported yet" ] )


type InputValidation
    = Valid (List ( String, GraphQL.Schema.Type ))
    | InputError ErrorDetails
    | Mismatch


validateInput :
    References
    -> GraphQL.Schema.Type
    -> String
    -> AST.Value
    -> InputValidation
validateInput refs schemaType fieldName astValue =
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
                    case Dict.get inputObjectName refs.schema.inputObjects of
                        Nothing ->
                            Mismatch

                        Just inputObject ->
                            validateObject refs fieldName keyValues inputObject

                GraphQL.Schema.Nullable (GraphQL.Schema.InputObject inputObjectName) ->
                    case Dict.get inputObjectName refs.schema.inputObjects of
                        Nothing ->
                            Mismatch

                        Just inputObject ->
                            validateObject refs fieldName keyValues inputObject

                _ ->
                    Mismatch

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
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch

        AST.Integer int ->
            case schemaType of
                GraphQL.Schema.Scalar "Int" ->
                    Valid []

                GraphQL.Schema.Scalar "Float" ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch

        AST.Decimal float ->
            case schemaType of
                GraphQL.Schema.Scalar "Float" ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch

        AST.Boolean bool ->
            case schemaType of
                GraphQL.Schema.Scalar "Boolean" ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput refs inner fieldName astValue

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
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch

        AST.ListValue list ->
            case schemaType of
                GraphQL.Schema.List_ innerList ->
                    List.foldl
                        (\item current ->
                            case current of
                                Valid validArgs ->
                                    case validateInput refs innerList fieldName item of
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
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch


validateObject refs fieldName keyValues inputObject =
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
                            Mismatch

                        Just field ->
                            case validateInput refs field.type_ fieldName value of
                                Valid fieldArgs ->
                                    Valid (argValues ++ fieldArgs)

                                validationError ->
                                    validationError

                _ ->
                    current
        )
        (Valid [])
        keyValues


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


{-| -}
getFragmentOverrideName : List AST.Selection -> String -> String
getFragmentOverrideName selectedFields name =
    case selectedFields of
        [ AST.FragmentSpreadSelection fragment ] ->
            AST.nameToString fragment.name

        _ ->
            name


{-| -}
getGlobalNameWithFragmentAlias : List AST.Selection -> String -> UsedNames -> { globalName : String, used : UsedNames }
getGlobalNameWithFragmentAlias selection name usedNames =
    getGlobalName (getFragmentOverrideName selection name)
        usedNames


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

    levels should be the alias name

-}
addLevel :
    { field
        | name : AST.Name
        , alias_ : Maybe AST.Name
    }
    -> UsedNames
    -> UsedNames
addLevel field (UsedNames used) =
    let
        aliased =
            field.alias_
                |> Maybe.withDefault field.name
                |> convertName
                |> Can.nameToString
    in
    UsedNames
        { used
            | breadcrumbs =
                { name = formatTypename aliased
                , isAlias = field.alias_ /= Nothing
                }
                    :: used.breadcrumbs
            , siblingStack = used.siblingAliases :: used.siblingStack
            , siblingAliases = []
        }


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


canonicalizeFragment :
    GraphQL.Schema.Schema
    -> AST.FragmentDetails
    -> CanResult (Dict String Can.Fragment)
    -> CanResult (Dict String Can.Fragment)
canonicalizeFragment schema frag currentResult =
    case currentResult of
        CanError errMsg ->
            CanError errMsg

        CanSuccess cache existingFrags ->
            let
                typeCondition =
                    AST.nameToString frag.typeCondition
            in
            case Dict.get typeCondition schema.objects of
                Just obj ->
                    let
                        aliasedName =
                            frag.name
                                |> AST.nameToString

                        selectionResult =
                            List.foldl
                                (canonicalizeField
                                    { schema = schema
                                    , fragments = existingFrags
                                    }
                                    obj
                                )
                                { result = CanSuccess cache []
                                , fieldNames =
                                    UsedNames
                                        { siblingAliases = []
                                        , siblingStack = []
                                        , breadcrumbs = []
                                        , globalNames =
                                            []
                                        }
                                }
                                frag.selection
                    in
                    case selectionResult.result of
                        CanSuccess newCache selection ->
                            CanSuccess newCache
                                (existingFrags
                                    |> Dict.insert (AST.nameToString frag.name)
                                        { name = convertName frag.name
                                        , typeCondition = convertName frag.typeCondition
                                        , directives = List.map convertDirective frag.directives
                                        , selection =
                                            Can.FragmentObject
                                                { selection = selection }
                                        }
                                )

                        CanError errorMsg ->
                            CanError errorMsg

                Nothing ->
                    case Dict.get typeCondition schema.interfaces of
                        Just interface ->
                            CanError
                                [ error <|
                                    FragmentTargetDoesntExist
                                        { fragmentName = AST.nameToString frag.name
                                        , typeCondition = AST.nameToString frag.typeCondition
                                        }
                                ]

                        Nothing ->
                            case Dict.get typeCondition schema.unions of
                                Just union ->
                                    CanError
                                        [ error <|
                                            FragmentTargetDoesntExist
                                                { fragmentName = AST.nameToString frag.name
                                                , typeCondition = AST.nameToString frag.typeCondition
                                                }
                                        ]

                                Nothing ->
                                    CanError
                                        [ error <|
                                            FragmentTargetDoesntExist
                                                { fragmentName = AST.nameToString frag.name
                                                , typeCondition = AST.nameToString frag.typeCondition
                                                }
                                        ]


canonicalizeVariantSelection refs usedNames unionOrInterface selection variants =
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
                selection

        selectionResult =
            List.foldl
                (canonicalizeFieldWithVariants refs
                    { name = unionOrInterface.name
                    , description = unionOrInterface.description
                    , fields = []
                    }
                )
                { result = emptySuccess
                , capturedVariants = []
                , fieldNames =
                    usedNames
                , variants = variants
                , typenameAlreadySelected = selectsForTypename
                }
                selection

        ( remainingUsedNames, remaining ) =
            List.foldl
                gatherRemaining
                ( selectionResult.fieldNames
                , []
                )
                selectionResult.variants
    in
    case selectionResult.result of
        CanSuccess cache canSelection ->
            ( remainingUsedNames
                |> dropLevel
            , CanSuccess cache
                { selection = canSelection
                , variants = selectionResult.capturedVariants
                , remainingTags =
                    List.reverse remaining
                }
            )

        CanError errorMsg ->
            ( remainingUsedNames, CanError errorMsg )


{-| -}
canonicalizeField :
    References
    ->
        { obj
            | name : String
            , description : Maybe String
            , fields : List GraphQL.Schema.Field
        }
    -> AST.Selection
    ->
        { result : CanResult (List Can.Field)
        , fieldNames : UsedNames
        }
    ->
        { result : CanResult (List Can.Field)
        , fieldNames : UsedNames
        }
canonicalizeField refs object selection found =
    case selection of
        AST.Field field ->
            let
                fieldName =
                    AST.nameToString field.name

                aliased =
                    AST.getAliasedName field
            in
            if siblingCollision aliased found.fieldNames then
                -- There has been a collision, abort!
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
                        (Can.Field
                            { alias_ = Maybe.map convertName field.alias_
                            , name = convertName field.name
                            , globalAlias =
                                field.alias_
                                    |> Maybe.withDefault field.name
                                    |> convertName
                            , arguments = []
                            , directives = List.map convertDirective field.directives
                            , wrapper = GraphQL.Schema.UnwrappedValue
                            , selection =
                                Can.FieldScalar (GraphQL.Schema.Scalar "typename")
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
                                canonicalizeFieldType refs
                                    field
                                    found.fieldNames
                                    matched
                        in
                        { result =
                            case cannedSelection of
                                CanSuccess cache sel ->
                                    addToResult cache sel found.result

                                CanError errMsg ->
                                    CanError errMsg
                        , fieldNames =
                            newNames
                                |> saveSibling aliased
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
            let
                fragName =
                    AST.nameToString frag.name
            in
            case Dict.get fragName refs.fragments of
                Nothing ->
                    { result =
                        err
                            [ error <|
                                FragmentNotFound
                                    { found = fragName
                                    , object = object.name
                                    , options =
                                        Dict.values refs.fragments
                                    }
                            ]
                    , fieldNames = found.fieldNames
                    }

                Just foundFrag ->
                    if Can.nameToString foundFrag.typeCondition == object.name then
                        { result =
                            addToResult emptyCache
                                (Can.Frag
                                    { fragment = foundFrag
                                    , directives =
                                        frag.directives
                                            |> List.map
                                                convertDirective
                                    }
                                )
                                found.result
                        , fieldNames = found.fieldNames
                        }

                    else
                        { result =
                            err
                                [ error <|
                                    FragmentNotFound
                                        { found = fragName
                                        , object = object.name
                                        , options =
                                            Dict.values refs.fragments
                                        }
                                ]
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


canonicalizeFieldType :
    References
    -> AST.FieldDetails
    -> UsedNames
    -> GraphQL.Schema.Field
    ->
        ( UsedNames
        , CanResult Can.Field
        )
canonicalizeFieldType refs field usedNames schemaField =
    canonicalizeFieldTypeHelper refs field schemaField.type_ usedNames emptyCache schemaField


canonicalizeArguments refs schemaArguments arguments =
    List.foldl
        (\arg found ->
            let
                fieldname =
                    AST.nameToString arg.name
            in
            case List.head (List.filter (\a -> a.name == fieldname) schemaArguments) of
                Nothing ->
                    { found
                        | unknown =
                            fieldname :: found.unknown
                    }

                Just schemaVar ->
                    case validateInput refs schemaVar.type_ fieldname arg.value of
                        Valid vars ->
                            { found
                                | valid =
                                    vars ++ found.valid
                            }

                        InputError errorDetails ->
                            { found
                                | errs =
                                    error errorDetails :: found.errs
                            }

                        Mismatch ->
                            { found
                                | errs =
                                    error
                                        (IncorrectInlineInput
                                            { schema = schemaVar.type_
                                            , arg = fieldname
                                            , found = arg.value
                                            }
                                        )
                                        :: found.errs
                            }
        )
        { valid = []
        , unknown = []
        , errs = []
        }
        arguments


{-|

    For `field`, we are matching it up with types from `schema`

-}
canonicalizeFieldTypeHelper :
    References
    -> AST.FieldDetails
    -> GraphQL.Schema.Type
    -> UsedNames
    -> VarCache
    -> GraphQL.Schema.Field
    -> ( UsedNames, CanResult Can.Field )
canonicalizeFieldTypeHelper refs field type_ usedNames initialVarCache schemaField =
    let
        argValidation =
            canonicalizeArguments refs schemaField.arguments field.arguments
    in
    if not (List.isEmpty argValidation.unknown) then
        ( usedNames
        , CanError
            [ error <|
                UnknownArgs
                    { field = AST.nameToString field.name
                    , unknownArgs = argValidation.unknown
                    , allowedArgs =
                        schemaField.arguments
                    }
            ]
        )

    else if not (List.isEmpty argValidation.errs) then
        ( usedNames, CanError argValidation.errs )

    else
        let
            vars =
                List.reverse argValidation.valid

            newCache =
                addVars vars initialVarCache
        in
        case type_ of
            GraphQL.Schema.Scalar name ->
                ( usedNames
                , success newCache
                    (Can.Field
                        { alias_ = Maybe.map convertName field.alias_
                        , name = convertName field.name
                        , globalAlias =
                            field.alias_
                                |> Maybe.withDefault field.name
                                |> convertName
                        , arguments = []
                        , directives = List.map convertDirective field.directives
                        , wrapper = GraphQL.Schema.getWrap schemaField.type_
                        , selection =
                            Can.FieldScalar schemaField.type_
                        }
                    )
                )

            GraphQL.Schema.InputObject name ->
                ( usedNames
                , err [ todo "Invalid schema!  Weird InputObject" ]
                )

            GraphQL.Schema.Object name ->
                case Dict.get name refs.schema.objects of
                    Nothing ->
                        ( usedNames, err [ error (ObjectUnknown name) ] )

                    Just obj ->
                        canonicalizeObject refs
                            field
                            usedNames
                            schemaField
                            newCache
                            obj

            GraphQL.Schema.Enum name ->
                case Dict.get name refs.schema.enums of
                    Nothing ->
                        ( usedNames, err [ error (EnumUnknown name) ] )

                    Just enum ->
                        ( usedNames
                        , CanSuccess newCache
                            (Can.Field
                                { alias_ = Maybe.map convertName field.alias_
                                , name = convertName field.name
                                , globalAlias =
                                    field.alias_
                                        |> Maybe.withDefault field.name
                                        |> convertName
                                , arguments = []
                                , directives = List.map convertDirective field.directives
                                , wrapper = GraphQL.Schema.getWrap schemaField.type_
                                , selection =
                                    Can.FieldEnum
                                        { enumName = enum.name
                                        , values = enum.values
                                        }
                                }
                            )
                        )

            GraphQL.Schema.Union name ->
                case Dict.get name refs.schema.unions of
                    Nothing ->
                        ( usedNames, err [ error (UnionUnknown name) ] )

                    Just union ->
                        case extractUnionTags union.variants [] of
                            Nothing ->
                                ( usedNames, err [ todo "Things in a union are not objects!" ] )

                            Just variants ->
                                let
                                    aliasedName =
                                        field.alias_
                                            |> Maybe.withDefault field.name
                                            |> convertName
                                            |> Can.nameToString

                                    global =
                                        getGlobalNameWithFragmentAlias
                                            field.selection
                                            aliasedName
                                            usedNames

                                    ( finalUsedNames, canVarSelectionResult ) =
                                        canonicalizeVariantSelection refs
                                            (global.used
                                                |> addLevel field
                                            )
                                            union
                                            field.selection
                                            variants
                                in
                                ( finalUsedNames
                                , case canVarSelectionResult of
                                    CanSuccess cache variantSelection ->
                                        CanSuccess (mergeCaches newCache cache)
                                            (Can.Field
                                                { alias_ = Maybe.map convertName field.alias_
                                                , name = convertName field.name
                                                , globalAlias =
                                                    Can.Name global.globalName
                                                , arguments = []
                                                , directives = List.map convertDirective field.directives
                                                , wrapper = GraphQL.Schema.getWrap schemaField.type_
                                                , selection =
                                                    Can.FieldUnion variantSelection
                                                }
                                            )

                                    CanError errorMsg ->
                                        CanError errorMsg
                                )

            GraphQL.Schema.Interface name ->
                case Dict.get name refs.schema.interfaces of
                    Nothing ->
                        ( usedNames, err [ error (UnionUnknown name) ] )

                    Just interface ->
                        let
                            variants =
                                List.foldl getInterfaceNames [] interface.implementedBy

                            aliasedName =
                                field.alias_
                                    |> Maybe.withDefault field.name
                                    |> convertName
                                    |> Can.nameToString

                            global =
                                getGlobalNameWithFragmentAlias
                                    field.selection
                                    aliasedName
                                    usedNames

                            ( finalUsedNames, canVarSelectionResult ) =
                                canonicalizeVariantSelection refs
                                    (global.used
                                        |> addLevel field
                                    )
                                    interface
                                    field.selection
                                    variants
                        in
                        ( finalUsedNames
                        , case canVarSelectionResult of
                            CanSuccess cache variantSelection ->
                                CanSuccess (mergeCaches newCache cache)
                                    (Can.Field
                                        { alias_ = Maybe.map convertName field.alias_
                                        , name = convertName field.name
                                        , globalAlias =
                                            Can.Name global.globalName
                                        , arguments = []
                                        , directives = List.map convertDirective field.directives
                                        , wrapper = GraphQL.Schema.getWrap schemaField.type_
                                        , selection =
                                            Can.FieldInterface variantSelection
                                        }
                                    )

                            CanError errorMsg ->
                                CanError errorMsg
                        )

            GraphQL.Schema.List_ inner ->
                canonicalizeFieldTypeHelper refs field inner usedNames newCache schemaField

            GraphQL.Schema.Nullable inner ->
                canonicalizeFieldTypeHelper refs field inner usedNames newCache schemaField


gatherRemaining tag ( used, gathered ) =
    let
        global =
            getGlobalName tag used
    in
    ( global.used
    , { globalAlias = Can.Name global.globalName
      , tag = Can.Name tag
      }
        :: gathered
    )


canonicalizeObject :
    References
    -> AST.FieldDetails
    -> UsedNames
    -> GraphQL.Schema.Field
    -> VarCache
    -> GraphQL.Schema.ObjectDetails
    -> ( UsedNames, CanResult Can.Field )
canonicalizeObject refs field usedNames schemaField varCache obj =
    case field.selection of
        [] ->
            -- This is an object with no selection, which isn't allowed for gql.
            ( usedNames
            , err
                [ error
                    (EmptySelection
                        { field =
                            case field.alias_ of
                                Nothing ->
                                    AST.nameToString field.name

                                Just alias ->
                                    AST.nameToString alias
                                        ++ ": "
                                        ++ AST.nameToString field.name
                        , fieldType = obj.name
                        , options =
                            List.map
                                (\f ->
                                    { field = f.name
                                    , type_ = GraphQL.Schema.typeToString f.type_
                                    }
                                )
                                obj.fields
                        }
                    )
                ]
            )

        _ ->
            let
                aliasedName =
                    field.alias_
                        |> Maybe.withDefault field.name
                        |> convertName
                        |> Can.nameToString

                global =
                    getGlobalNameWithFragmentAlias field.selection
                        aliasedName
                        usedNames

                selectionResult =
                    List.foldl
                        (canonicalizeField refs obj)
                        { result = emptySuccess
                        , fieldNames =
                            global.used
                                |> addLevel field
                        }
                        field.selection
            in
            case selectionResult.result of
                CanSuccess cache canSelection ->
                    if siblingCollision aliasedName global.used then
                        ( selectionResult.fieldNames
                            |> dropLevel
                        , err
                            [ error
                                (FieldAliasRequired
                                    { fieldName = aliasedName
                                    }
                                )
                            ]
                        )

                    else
                        ( selectionResult.fieldNames
                            |> dropLevel
                            |> saveSibling aliasedName
                        , CanSuccess (mergeCaches varCache cache)
                            (Can.Field
                                { alias_ = Maybe.map convertName field.alias_
                                , name = convertName field.name
                                , globalAlias = Can.Name global.globalName
                                , arguments = field.arguments
                                , directives = List.map convertDirective field.directives
                                , wrapper = GraphQL.Schema.getWrap schemaField.type_
                                , selection =
                                    Can.FieldObject canSelection
                                }
                            )
                        )

                CanError errorMsg ->
                    ( global.used, CanError errorMsg )


getInterfaceNames kind found =
    case kind of
        GraphQL.Schema.ObjectKind name ->
            name :: found

        _ ->
            found


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


addCache newCache result =
    case result of
        CanSuccess cache existing ->
            CanSuccess (mergeCaches newCache cache) existing

        CanError errs ->
            CanError errs


canonicalizeFieldWithVariants :
    References
    ->
        { obj
            | name : String
            , description : Maybe String
            , fields : List GraphQL.Schema.Field
        }
    -> AST.Selection
    ->
        { result : CanResult (List Can.Field)
        , fieldNames : UsedNames
        , variants : List String
        , capturedVariants : List Can.VariantCase
        , typenameAlreadySelected : Bool
        }
    ->
        { result : CanResult (List Can.Field)
        , fieldNames : UsedNames
        , variants : List String
        , capturedVariants : List Can.VariantCase
        , typenameAlreadySelected : Bool
        }
canonicalizeFieldWithVariants refs unionOrInterface selection found =
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
                        (Can.Field
                            { alias_ = Maybe.map convertName field.alias_
                            , name = convertName field.name
                            , globalAlias =
                                field.alias_
                                    |> Maybe.withDefault field.name
                                    |> convertName
                            , arguments = []
                            , directives = List.map convertDirective field.directives
                            , wrapper = GraphQL.Schema.UnwrappedValue
                            , selection =
                                Can.FieldScalar (GraphQL.Schema.Scalar "typename")
                            }
                        )
                        found.result
                , fieldNames = found.fieldNames
                , variants = found.variants
                , capturedVariants = found.capturedVariants
                , typenameAlreadySelected = True
                }

            else
                let
                    canned =
                        canonicalizeField refs
                            unionOrInterface
                            selection
                            { result = found.result
                            , fieldNames = found.fieldNames
                            }
                in
                { result =
                    canned.result
                , fieldNames = canned.fieldNames
                , variants = found.variants
                , capturedVariants = found.capturedVariants
                , typenameAlreadySelected = found.typenameAlreadySelected
                }

        AST.FragmentSpreadSelection frag ->
            { result =
                err [ todo "Fragments in objects aren't suported yet!" ]
            , fieldNames = found.fieldNames
            , variants = found.variants
            , capturedVariants = found.capturedVariants
            , typenameAlreadySelected = found.typenameAlreadySelected
            }

        AST.InlineFragmentSelection inline ->
            case inline.selection of
                [] ->
                    { result =
                        err [ error (EmptyUnionVariantSelection { tag = AST.nameToString inline.tag }) ]
                    , fieldNames = found.fieldNames
                    , variants = found.variants
                    , capturedVariants = found.capturedVariants
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
                        case Dict.get tag refs.schema.objects of
                            Nothing ->
                                { result =
                                    err [ error (ObjectUnknown tag) ]
                                , fieldNames = found.fieldNames
                                , variants = leftOvertags
                                , capturedVariants = found.capturedVariants
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
                                            (\sel cursor ->
                                                let
                                                    canoned =
                                                        canonicalizeField refs obj sel cursor
                                                in
                                                { canoned
                                                    | fieldNames =
                                                        -- the weird thing we're doing here is so that field-name-collision
                                                        -- does not occur within a UnionCase
                                                        -- meaning separate UnionCases can use the same names and not collide.
                                                        resetSiblings cursor.fieldNames
                                                            canoned.fieldNames
                                                }
                                            )
                                            { result = emptySuccess
                                            , fieldNames = found.fieldNames
                                            }
                                            inline.selection
                                in
                                if selectsForTypename then
                                    case selectionResult.result of
                                        CanSuccess cache canSelection ->
                                            let
                                                global =
                                                    getGlobalName tag selectionResult.fieldNames

                                                globalDetailsAlias =
                                                    getGlobalNameWithFragmentAlias
                                                        inline.selection
                                                        (global.globalName ++ "_Details")
                                                        global.used
                                            in
                                            { result =
                                                found.result
                                                    |> addCache cache

                                            -- selectionResult.result
                                            , capturedVariants =
                                                { tag = Can.Name tag
                                                , globalTagName = Can.Name global.globalName
                                                , globalDetailsAlias = Can.Name (global.globalName ++ "_Details")
                                                , directives = List.map convertDirective inline.directives
                                                , selection = canSelection
                                                }
                                                    :: found.capturedVariants
                                            , fieldNames = global.used
                                            , variants = leftOvertags
                                            , typenameAlreadySelected = found.typenameAlreadySelected
                                            }

                                        CanError errorMsg ->
                                            { result =
                                                CanError errorMsg
                                            , capturedVariants = found.capturedVariants
                                            , fieldNames = selectionResult.fieldNames
                                            , variants = leftOvertags
                                            , typenameAlreadySelected = found.typenameAlreadySelected
                                            }

                                else
                                    { result =
                                        err [ error (MissingTypename { tag = AST.nameToString inline.tag }) ]
                                    , fieldNames = found.fieldNames
                                    , capturedVariants = found.capturedVariants
                                    , variants = found.variants
                                    , typenameAlreadySelected = found.typenameAlreadySelected
                                    }

                    else
                        { result =
                            err [ todo (tag ++ " does not match!") ]
                        , fieldNames = found.fieldNames
                        , variants = found.variants
                        , capturedVariants = found.capturedVariants
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

module GraphQL.Operations.Canonicalize exposing (canonicalize, cyan, errorToString)

{-| -}

import Dict exposing (Dict)
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Canonicalize.Cache as Cache
import GraphQL.Operations.Canonicalize.UsedNames as UsedNames
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
    | FragmentVariableIssue FragmentVariableSummary
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
    | FragmentSelectionNotAllowedInObjects
        { fragment : AST.InlineFragment
        , objectName : String
        }
    | FragmentInlineTopLevel
        { fragment : AST.InlineFragment
        }
    | Todo String


type alias VariableSummary =
    { declared : List DeclaredVariable
    , valid : List Can.VariableDefinition
    , issues : List VarIssue
    , suggestions : List SuggestedVariable
    }


type alias FragmentVariableSummary =
    { fragmentName : String
    , declared : List { name : String, type_ : String }
    , used : List { name : String, type_ : String }
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

        FragmentSelectionNotAllowedInObjects deets ->
            String.join "\n"
                [ "I found a fragment named " ++ yellow (AST.nameToString deets.fragment.tag)
                , "but it is inside the object named " ++ cyan deets.objectName ++ ", which is neither an interface or a union."
                , "Is it in the right place?"
                ]

        FragmentInlineTopLevel deets ->
            String.join "\n"
                [ "I found an inline fragment named " ++ yellow (AST.nameToString deets.fragment.tag) ++ " at the top level of the query."
                , "But this sort of fragment must be inside a union or an interface."
                , "Is it in the right place?"
                ]

        VariableIssueSummary summary ->
            case summary.declared of
                [] ->
                    String.join "\n"
                        [ "I wasn't able to find any declared variables."
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

        FragmentVariableIssue summary ->
            String.join "\n"
                [ "It looks like the " ++ cyan summary.fragmentName ++ " fragment uses the following variables:"
                , block
                    (List.map
                        renderVariable
                        summary.used
                    )
                , "But the only variables that are declared are"
                , block
                    (List.map
                        renderVariable
                        summary.declared
                    )
                ]


renderVariable : { name : String, type_ : String } -> String
renderVariable var =
    yellow var.name ++ cyan ": " ++ yellow var.type_


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
    | CanSuccess Cache.Cache success


type alias References =
    { schema : GraphQL.Schema.Schema
    , fragments : Dict String Can.Fragment
    }


err : List Error -> CanResult success
err =
    CanError


success : Cache.Cache -> success -> CanResult success
success =
    CanSuccess


emptySuccess : CanResult (List a)
emptySuccess =
    CanSuccess Cache.empty []


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
                usedNames =
                    UsedNames.empty

                ( fragUsedNames, canonicalizedFragments ) =
                    List.foldl
                        (canonicalizeFragment schema)
                        ( usedNames, CanSuccess Cache.empty Dict.empty )
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
                                    fragUsedNames
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
                                (CanSuccess (Cache.merge cache existingCache) (valid :: existing))

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
    -> UsedNames.UsedNames
    -> AST.Definition
    -> Maybe (CanResult Can.Definition)
canonicalizeDefinition refs usedNames def =
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
                    usedNames
                        |> UsedNames.getGlobalName
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
                                                (Cache.merge oldCache newCache)
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

                            fragmentVariableIssues =
                                List.filterMap
                                    (fragmentVariableErrors details.variableDefinitions)
                                    (List.map .fragment cache.fragmentsUsed)
                        in
                        if not (List.isEmpty variableSummary.issues) then
                            CanError
                                [ error
                                    (VariableIssueSummary variableSummary)
                                ]

                        else if not (List.isEmpty fragmentVariableIssues) then
                            CanError
                                (List.map
                                    (error << FragmentVariableIssue)
                                    fragmentVariableIssues
                                )

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
                                    , fragmentsUsed = cache.fragmentsUsed
                                    }

                    CanError errorMsg ->
                        CanError errorMsg


fragmentVariableErrors : List AST.VariableDefinition -> Can.Fragment -> Maybe FragmentVariableSummary
fragmentVariableErrors varDefs frag =
    let
        varSummary =
            { fragmentName = Can.nameToString frag.name
            , declared =
                List.map
                    (\def ->
                        { name = AST.nameToString def.variable.name
                        , type_ = AST.typeToGqlString def.type_
                        }
                    )
                    varDefs
            , used =
                List.map
                    (\( name, varType ) ->
                        { name = name
                        , type_ = GraphQL.Schema.typeToString varType
                        }
                    )
                    frag.usedVariables
            }

        variableIssue ( name, varType ) existingIssue =
            case existingIssue of
                Just _ ->
                    existingIssue

                _ ->
                    case List.head (List.filter (\def -> AST.nameToString def.variable.name == name) varDefs) of
                        Nothing ->
                            Just varSummary

                        Just found ->
                            if String.toLower (AST.typeToGqlString found.type_) == String.toLower (GraphQL.Schema.typeToString varType) then
                                Nothing

                            else
                                Just varSummary
    in
    List.foldl variableIssue Nothing frag.usedVariables


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
    -> UsedNames.UsedNames
    -> AST.Selection
    -> ( UsedNames.UsedNames, CanResult Can.Field )
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
                        |> Tuple.mapFirst UsedNames.dropLevel

        AST.FragmentSpreadSelection frag ->
            ( used, err [ todo "Top level Fragments aren't suported yet!" ] )

        AST.InlineFragmentSelection inline ->
            -- This is when we're selecting a union fragment
            ( used, err [ error (FragmentInlineTopLevel { fragment = inline }) ] )


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


{-| -}
getFragmentOverrideName : List AST.Selection -> String -> String
getFragmentOverrideName selectedFields name =
    case selectedFields of
        [ AST.FragmentSpreadSelection fragment ] ->
            AST.nameToString fragment.name

        _ ->
            name


selectsSingleFragment : List AST.Selection -> Maybe String
selectsSingleFragment fields =
    case fields of
        [ AST.FragmentSpreadSelection fragment ] ->
            Just (AST.nameToString fragment.name)

        _ ->
            Nothing


{-| -}
getGlobalNameWithFragmentAlias :
    List AST.Selection
    -> String
    -> UsedNames.UsedNames
    ->
        { globalName : String
        , used : UsedNames.UsedNames
        }
getGlobalNameWithFragmentAlias selection name usedNames =
    case selectsSingleFragment selection of
        Nothing ->
            UsedNames.getGlobalName name
                usedNames

        Just fragName ->
            { globalName = fragName
            , used = usedNames
            }


canonicalizeFragment :
    GraphQL.Schema.Schema
    -> AST.FragmentDetails
    -> ( UsedNames.UsedNames, CanResult (Dict String Can.Fragment) )
    -> ( UsedNames.UsedNames, CanResult (Dict String Can.Fragment) )
canonicalizeFragment schema frag ( usedNames, currentResult ) =
    case currentResult of
        CanError errMsg ->
            ( usedNames, CanError errMsg )

        CanSuccess cache existingFrags ->
            let
                typeCondition =
                    AST.nameToString frag.typeCondition
            in
            case Dict.get typeCondition schema.objects of
                Just obj ->
                    let
                        selectionResult =
                            List.foldl
                                (canonicalizeField
                                    { schema = schema
                                    , fragments = existingFrags
                                    }
                                    obj
                                )
                                { result = CanSuccess Cache.empty []
                                , fieldNames =
                                    usedNames
                                        |> UsedNames.addLevel
                                            { name = AST.nameToString frag.name
                                            , isAlias = False
                                            }
                                }
                                frag.selection
                    in
                    ( selectionResult.fieldNames
                    , case selectionResult.result of
                        CanSuccess fragmentSpecificCache selection ->
                            CanSuccess fragmentSpecificCache
                                (existingFrags
                                    |> Dict.insert (AST.nameToString frag.name)
                                        { name = convertName frag.name
                                        , typeCondition = convertName frag.typeCondition
                                        , usedVariables = fragmentSpecificCache.varTypes
                                        , fragmentsUsed =
                                            List.map (.fragment >> .name) fragmentSpecificCache.fragmentsUsed
                                        , directives = List.map convertDirective frag.directives
                                        , selection =
                                            Can.FragmentObject
                                                { selection = selection }
                                        }
                                )

                        CanError errorMsg ->
                            CanError errorMsg
                    )

                Nothing ->
                    case Dict.get typeCondition schema.interfaces of
                        Just interface ->
                            let
                                variants =
                                    List.foldl getInterfaceNames [] interface.implementedBy

                                ( finalUsedNames, canVarSelectionResult ) =
                                    canonicalizeVariantSelection
                                        { schema = schema
                                        , fragments = existingFrags
                                        }
                                        (usedNames
                                            |> UsedNames.addLevel
                                                { name = AST.nameToString frag.name
                                                , isAlias = False
                                                }
                                        )
                                        { name = interface.name
                                        , description = interface.description
                                        , fields = interface.fields
                                        }
                                        frag.selection
                                        variants
                            in
                            ( finalUsedNames
                            , case canVarSelectionResult of
                                CanSuccess fragmentSpecificCache selection ->
                                    CanSuccess fragmentSpecificCache
                                        (existingFrags
                                            |> Dict.insert (AST.nameToString frag.name)
                                                { name = convertName frag.name
                                                , typeCondition = convertName frag.typeCondition
                                                , usedVariables = fragmentSpecificCache.varTypes
                                                , fragmentsUsed = List.map (.fragment >> .name) fragmentSpecificCache.fragmentsUsed
                                                , directives = List.map convertDirective frag.directives
                                                , selection =
                                                    Can.FragmentInterface selection
                                                }
                                        )

                                CanError errorMsg ->
                                    CanError errorMsg
                            )

                        Nothing ->
                            case Dict.get typeCondition schema.unions of
                                Just union ->
                                    let
                                        variants =
                                            Maybe.withDefault [] <| extractUnionTags union.variants []

                                        ( finalUsedNames, canVarSelectionResult ) =
                                            canonicalizeVariantSelection
                                                { schema = schema
                                                , fragments = existingFrags
                                                }
                                                (usedNames
                                                    |> UsedNames.addLevel
                                                        { name = AST.nameToString frag.name
                                                        , isAlias = False
                                                        }
                                                )
                                                { name = union.name
                                                , description = union.description
                                                , fields = []
                                                }
                                                frag.selection
                                                variants
                                    in
                                    ( finalUsedNames
                                    , case canVarSelectionResult of
                                        CanSuccess fragmentSpecificCache selection ->
                                            CanSuccess fragmentSpecificCache
                                                (existingFrags
                                                    |> Dict.insert (AST.nameToString frag.name)
                                                        { name = convertName frag.name
                                                        , typeCondition = convertName frag.typeCondition
                                                        , usedVariables = fragmentSpecificCache.varTypes
                                                        , fragmentsUsed =
                                                            List.map (.fragment >> .name) fragmentSpecificCache.fragmentsUsed
                                                        , directives = List.map convertDirective frag.directives
                                                        , selection =
                                                            Can.FragmentUnion selection
                                                        }
                                                )

                                        CanError errorMsg ->
                                            CanError errorMsg
                                    )

                                Nothing ->
                                    ( usedNames
                                    , CanError
                                        [ error <|
                                            FragmentTargetDoesntExist
                                                { fragmentName = AST.nameToString frag.name
                                                , typeCondition = AST.nameToString frag.typeCondition
                                                }
                                        ]
                                    )


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
                    unionOrInterface
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
                |> UsedNames.dropLevel
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
        , fieldNames : UsedNames.UsedNames
        }
    ->
        { result : CanResult (List Can.Field)
        , fieldNames : UsedNames.UsedNames
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
            if UsedNames.siblingCollision aliased found.fieldNames then
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
                    addToResult Cache.empty
                        (Can.Field
                            { alias_ = Maybe.map convertName field.alias_
                            , name = convertName field.name
                            , globalAlias =
                                field.alias_
                                    |> Maybe.withDefault field.name
                                    |> convertName
                            , selectsOnlyFragment = Nothing
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
                                |> UsedNames.saveSibling aliased
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
                            found.result
                                |> addToResult
                                    (Cache.empty
                                        |> Cache.addFragment
                                            { fragment = foundFrag
                                            , alongsideOtherFields = False
                                            }
                                    )
                                    (Can.Frag
                                        { fragment = foundFrag
                                        , directives =
                                            frag.directives
                                                |> List.map
                                                    convertDirective
                                        }
                                    )
                        , fieldNames =
                            found.fieldNames
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
            { result =
                err
                    [ error
                        (FragmentSelectionNotAllowedInObjects
                            { fragment = inline
                            , objectName = object.name
                            }
                        )
                    ]
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
    -> UsedNames.UsedNames
    -> GraphQL.Schema.Field
    ->
        ( UsedNames.UsedNames
        , CanResult Can.Field
        )
canonicalizeFieldType refs field usedNames schemaField =
    canonicalizeFieldTypeHelper refs field schemaField.type_ usedNames Cache.empty schemaField


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
    -> UsedNames.UsedNames
    -> Cache.Cache
    -> GraphQL.Schema.Field
    -> ( UsedNames.UsedNames, CanResult Can.Field )
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
                initialVarCache |> Cache.addVars vars
        in
        case type_ of
            GraphQL.Schema.Scalar name ->
                ( usedNames
                , success newCache
                    (Can.Field
                        { alias_ = Maybe.map convertName field.alias_
                        , name = convertName field.name
                        , selectsOnlyFragment = Nothing
                        , globalAlias =
                            field.alias_
                                |> Maybe.withDefault field.name
                                |> convertName
                        , arguments = []
                        , directives = List.map convertDirective field.directives
                        , wrapper = GraphQL.Schema.getWrap schemaField.type_
                        , selection =
                            Can.FieldScalar (GraphQL.Schema.getInner schemaField.type_)
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
                                , selectsOnlyFragment = Nothing
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
                                                |> UsedNames.addLevel (UsedNames.levelFromField field)
                                            )
                                            { name = union.name
                                            , description = union.description

                                            -- Note, unions dont have any fields themselves, unlick interfaces
                                            , fields = []
                                            }
                                            field.selection
                                            variants
                                in
                                ( finalUsedNames
                                , case canVarSelectionResult of
                                    CanSuccess cache variantSelection ->
                                        CanSuccess (Cache.merge newCache cache)
                                            (Can.Field
                                                { alias_ = Maybe.map convertName field.alias_
                                                , name = convertName field.name
                                                , globalAlias =
                                                    Can.Name global.globalName
                                                , selectsOnlyFragment = selectsSingleFragment field.selection
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
                                        |> UsedNames.addLevel (UsedNames.levelFromField field)
                                    )
                                    { name = interface.name
                                    , description = interface.description
                                    , fields = interface.fields
                                    }
                                    field.selection
                                    variants
                        in
                        ( finalUsedNames
                        , case canVarSelectionResult of
                            CanSuccess cache variantSelection ->
                                CanSuccess (Cache.merge newCache cache)
                                    (Can.Field
                                        { alias_ = Maybe.map convertName field.alias_
                                        , name = convertName field.name
                                        , globalAlias =
                                            Can.Name global.globalName
                                        , selectsOnlyFragment = selectsSingleFragment field.selection
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
            UsedNames.getGlobalName tag used
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
    -> UsedNames.UsedNames
    -> GraphQL.Schema.Field
    -> Cache.Cache
    -> GraphQL.Schema.ObjectDetails
    -> ( UsedNames.UsedNames, CanResult Can.Field )
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
                                |> UsedNames.addLevel (UsedNames.levelFromField field)
                        }
                        field.selection
            in
            case selectionResult.result of
                CanSuccess cache canSelection ->
                    if UsedNames.siblingCollision aliasedName global.used then
                        ( selectionResult.fieldNames
                            |> UsedNames.dropLevel
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
                            |> UsedNames.dropLevel
                            |> UsedNames.saveSibling aliasedName
                        , CanSuccess (Cache.merge varCache cache)
                            (Can.Field
                                { alias_ = Maybe.map convertName field.alias_
                                , name = convertName field.name
                                , globalAlias = Can.Name global.globalName
                                , selectsOnlyFragment = selectsSingleFragment field.selection
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


{-| Members of a union can only be objects:
<https://spec.graphql.org/June2018/#sec-Unions>

Some more details: <https://github.com/graphql/graphql-js/issues/451>

-}
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
            CanSuccess (Cache.merge newCache cache) (newItem :: existing)

        CanError errs ->
            CanError errs


addCache newCache result =
    case result of
        CanSuccess cache existing ->
            CanSuccess (Cache.merge newCache cache) existing

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
        , fieldNames : UsedNames.UsedNames
        , variants : List String
        , capturedVariants : List Can.VariantCase
        , typenameAlreadySelected : Bool
        }
    ->
        { result : CanResult (List Can.Field)
        , fieldNames : UsedNames.UsedNames
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
            if fieldName == "__typename" then
                { result =
                    addToResult Cache.empty
                        (Can.Field
                            { alias_ = Maybe.map convertName field.alias_
                            , name = convertName field.name
                            , globalAlias =
                                field.alias_
                                    |> Maybe.withDefault field.name
                                    |> convertName
                            , selectsOnlyFragment = Nothing
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
                            , fieldNames =
                                found.fieldNames
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
                                    , object = unionOrInterface.name
                                    , options =
                                        Dict.values refs.fragments
                                    }
                            ]
                    , fieldNames = found.fieldNames
                    , variants = found.variants
                    , capturedVariants = found.capturedVariants
                    , typenameAlreadySelected = found.typenameAlreadySelected
                    }

                Just foundFrag ->
                    if Can.nameToString foundFrag.typeCondition == unionOrInterface.name then
                        { result =
                            found.result
                                |> addToResult
                                    (Cache.empty
                                        |> Cache.addFragment
                                            { fragment = foundFrag
                                            , alongsideOtherFields = False
                                            }
                                    )
                                    (Can.Frag
                                        { fragment = foundFrag
                                        , directives =
                                            frag.directives
                                                |> List.map
                                                    convertDirective
                                        }
                                    )
                        , fieldNames =
                            found.fieldNames
                        , variants = found.variants
                        , capturedVariants = found.capturedVariants
                        , typenameAlreadySelected = found.typenameAlreadySelected
                        }

                    else
                        { result =
                            err
                                [ error <|
                                    FragmentNotFound
                                        { found = fragName
                                        , object = unionOrInterface.name
                                        , options =
                                            Dict.values refs.fragments
                                        }
                                ]
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
                                                        UsedNames.resetSiblings cursor.fieldNames
                                                            canoned.fieldNames
                                                }
                                            )
                                            { result = emptySuccess
                                            , fieldNames =
                                                found.fieldNames
                                                    |> UsedNames.addLevel
                                                        { name = tag
                                                        , isAlias = False
                                                        }
                                            }
                                            inline.selection
                                in
                                if selectsForTypename then
                                    case selectionResult.result of
                                        CanSuccess cache canSelection ->
                                            let
                                                global =
                                                    UsedNames.getGlobalName tag
                                                        (selectionResult.fieldNames
                                                            |> UsedNames.dropLevel
                                                        )

                                                globalDetailsAlias =
                                                    getGlobalNameWithFragmentAlias
                                                        inline.selection
                                                        (global.globalName ++ "_Details")
                                                        global.used
                                            in
                                            { result =
                                                found.result
                                                    |> addCache cache
                                            , capturedVariants =
                                                { tag = Can.Name tag
                                                , globalTagName = Can.Name global.globalName
                                                , globalDetailsAlias = Can.Name globalDetailsAlias.globalName
                                                , directives = List.map convertDirective inline.directives
                                                , selection = canSelection
                                                }
                                                    :: found.capturedVariants
                                            , fieldNames = globalDetailsAlias.used
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

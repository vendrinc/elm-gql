module GraphQL.Operations.Canonicalize.Error exposing
    ( Coords
    , DeclaredVariable
    , Error(..)
    , ErrorDetails(..)
    , ExplanantionDetails(..)
    , FragmentVariableSummary
    , Position
    , SuggestedVariable
    , VarIssue(..)
    , VariableSummary
    , error
    , render
    )

import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Schema


render : { path : String, errors : List Error } -> { title : String, description : String }
render { path, errors } =
    case errors of
        [ single ] ->
            { title = formatTitle (toTitle single) path
            , description =
                toDescription single
            }

        _ ->
            { title = formatTitle "ELM GQL" path
            , description =
                List.map toDescription errors
                    |> String.join (cyan "\n-------------------\n\n")
            }


formatTitle : String -> String -> String
formatTitle title path =
    let
        middle =
            "-" |> String.repeat (78 - (String.length title + 2 + String.length path))
    in
    title ++ middle ++ path


type Error
    = Error
        { coords : Coords
        , error : ErrorDetails
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
    = UnableToParse { description : String }
    | QueryUnknown String
    | EnumUnknown String
    | ObjectUnknown String
    | UnionUnknown String
    | TopLevelFragmentsNotAllowed { fragmentName : String }
    | FoundSelectionOfInputObject { fieldName : String, inputObjectName : String }
    | UnionVariantNotFound
        { found : String
        , objectOrInterfaceName : String
        , knownVariants : List String
        }
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
    | FragmentCyclicDependency { fragments : List AST.FragmentDetails }
    | GlobalFragmentPresent
        { fragmentsDuplicatingGlobalOnes : List String
        }
    | GlobalFragmentNameFilenameMismatch
        { filename : String
        , fragmentName : String
        }
    | GlobalFragmentTooMuchStuff
    | Explanation
        { query : String
        , explanation : ExplanantionDetails
        }


type ExplanantionDetails
    = Operation AST.OperationType (List ( String, GraphQL.Schema.Type ))
    | Object
        { name : String
        , fields : List GraphQL.Schema.Field
        }
    | Union
        { name : String
        , fields : List GraphQL.Schema.Field
        , tags : List String
        }
    | Interface
        { name : String
        , fields : List GraphQL.Schema.Field
        , tags : List String
        }


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
block items =
    "\n    " ++ String.join "\n    " items ++ "\n"


lines : List String -> String
lines items =
    String.join "\n" items ++ "\n"



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


toTitle : Error -> String
toTitle (Error details) =
    case details.error of
        UnableToParse _ ->
            "Unable to parse query"

        TopLevelFragmentsNotAllowed errorDetails ->
            "Fragment not allowed"

        FoundSelectionOfInputObject errorDetails ->
            "Selection of InputObject not allowed"

        UnionVariantNotFound errorDetails ->
            "Union variant not found"

        FragmentCyclicDependency { fragments } ->
            "Cyclic fragment"

        EnumUnknown name ->
            "Unknown Enum"

        QueryUnknown name ->
            "Unknown Query"

        ObjectUnknown name ->
            "Unknown Object"

        UnionUnknown name ->
            "Unknown Union"

        FieldUnknown field ->
            "Unknown field"

        UnknownArgs deets ->
            "Unknown arguments"

        EmptySelection deets ->
            "Empty selection"

        FieldAliasRequired deets ->
            "Alias required"

        MissingTypename deets ->
            "Missing typename"

        EmptyUnionVariantSelection deets ->
            "Empty selection"

        IncorrectInlineInput deets ->
            "Incorrect input"

        FragmentNotFound deets ->
            "Fragment not found"

        FragmentTargetDoesntExist deets ->
            "Unknown fragment target"

        FragmentDuplicateFound deets ->
            "Duplicate fragment"

        FragmentSelectionNotAllowedInObjects deets ->
            "Fragment doesn't match"

        FragmentInlineTopLevel deets ->
            "Fragment not allowed"

        VariableIssueSummary summary ->
            "Variable issue"

        FragmentVariableIssue summary ->
            "Fragment variable issue"

        Explanation { query, explanation } ->
            "Explanation"

        GlobalFragmentNameFilenameMismatch _ ->
            "Fragment name and filename mismatch"

        GlobalFragmentTooMuchStuff ->
            "Too much stuff in global fragment"

        GlobalFragmentPresent _ ->
            "Duplicate of global fragment"


toDescription : Error -> String
toDescription (Error details) =
    case details.error of
        UnableToParse { description } ->
            description

        TopLevelFragmentsNotAllowed errorDetails ->
            String.join "\n"
                [ "I found a top level fragment"
                , block
                    [ yellow errorDetails.fragmentName ]
                , "But fragments aren't allowed at the top level."
                ]

        FoundSelectionOfInputObject errorDetails ->
            String.join "\n"
                [ "I found a field, " ++ cyan errorDetails.fieldName ++ ", that seems to be selecting from an InputObject"
                , block
                    [ yellow errorDetails.inputObjectName ]
                , "That's very confusing!  If you run into this error, report it to the elm-gql repo as it should be possible to do."
                ]

        UnionVariantNotFound errorDetails ->
            String.join "\n"
                [ "I found a variant, " ++ cyan errorDetails.found ++ ", that doesn't exist on " ++ yellow errorDetails.objectOrInterfaceName
                , ""
                , "Here are the variants that I know about:"
                , block
                    (List.map
                        yellow
                        errorDetails.knownVariants
                    )
                ]

        FragmentCyclicDependency { fragments } ->
            String.join "\n"
                [ "I found two fragments that depend on each other"
                , block
                    (List.map (cyan << AST.nameToString << .name) fragments)
                , "Is there a way to rewrite your query so that they don't depend on each other?"
                ]

        EnumUnknown name ->
            String.join "\n"
                [ "I don't recognize this Enum:"
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

                fragmentsThatMatchThisName =
                    List.filter
                        (\frag ->
                            deets.found == Can.nameToString frag.name
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
                                    [ cyan "fragment " ++ cyan deets.found ++ " on " ++ yellow deets.object ++ " {"
                                    , "    # select some fields here!"
                                    , "}"
                                    ]
                                , "Check out https://graphql.org/learn/queries/#fragments to learn more!"
                                ]

                        _ ->
                            let
                                preamble =
                                    [ cyan ("..." ++ deets.found) ++ " looks a little weird to me."
                                    , "From where it is in the query, it should select from " ++ yellow deets.object ++ "."
                                    , "But I wasn't able to find a fragment with this name that selects from " ++ yellow deets.object ++ "."
                                    ]

                                specifics =
                                    case fragmentsThatMatchThisName of
                                        [] ->
                                            [ "Here are the fragments I know about."
                                            , block
                                                (List.map (yellow << fragmentName)
                                                    deets.options
                                                )
                                            ]

                                        [ _ ] ->
                                            [ "I found this fragment, is it selecting from the wrong thing?"
                                            , block
                                                (List.map (yellow << fragmentName)
                                                    fragmentsThatMatchThisName
                                                )
                                            ]

                                        _ ->
                                            [ "Here are the fragments I know about."
                                            , block
                                                (List.map (yellow << fragmentName)
                                                    deets.options
                                                )
                                            ]
                            in
                            String.join "\n"
                                (preamble ++ specifics)

                [ _ ] ->
                    String.join "\n"
                        [ "I don't recognize the fragment named " ++ cyan deets.found ++ "."
                        , "Do you mean?"
                        , block
                            (List.map (yellow << fragmentName)
                                fragmentsThatMatchThisObject
                            )
                        ]

                _ ->
                    String.join "\n"
                        [ "I don't recognize the fragment named " ++ cyan deets.found ++ "."
                        , "Do you mean one of these?"
                        , block
                            (List.map (yellow << fragmentName)
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

        Explanation { query, explanation } ->
            case explanation of
                Operation opType fields ->
                    String.join "\n"
                        [ "I found a '?' in a "
                            ++ (case opType of
                                    AST.Query ->
                                        "query."

                                    AST.Mutation ->
                                        "mutation."

                                    AST.Subscription ->
                                        "subscription."
                               )
                        , yellow
                            ((case opType of
                                AST.Query ->
                                    "Queries "

                                AST.Mutation ->
                                    "Mutations "

                                AST.Subscription ->
                                    "Subscriptions "
                             )
                                ++ " available"
                            )
                        , lines
                            (searchBlock
                                { query = query
                                , toSearchString = Tuple.first
                                , render =
                                    \( fieldName, type_ ) ->
                                        [ yellow fieldName ++ grey (" # " ++ GraphQL.Schema.typeToString type_) ]
                                }
                                fields
                            )
                        ]

                Object { name, fields } ->
                    String.join "\n"
                        [ "I found a '?' in your query, here's what I can tell you about it."
                        , "It's on an Object named " ++ cyan name ++ " that has the following fields:"
                        , lines
                            (searchBlock
                                { query = query
                                , toSearchString = .name
                                , render = renderFieldExplanation
                                }
                                fields
                            )
                        ]

                Union { name, fields, tags } ->
                    String.join "\n"
                        [ "I found a '?' in your query, here's what I can tell you about it."
                        , "It's on a Union named " ++ cyan name ++ " that has the following types:"
                        , lines
                            (searchBlock
                                { query = query
                                , toSearchString = \tag -> tag
                                , render =
                                    \tag ->
                                        [ "... on " ++ cyan tag ++ " {"
                                        , grey "    # select some fields here!"
                                        , "}"
                                        ]
                                }
                                tags
                            )
                        ]

                Interface { name, fields, tags } ->
                    String.join "\n"
                        [ "I found a '?' in your query, here's what I can tell you about it."
                        , "It's on an Interface named " ++ cyan name ++ " that has the following fields:"
                        , block
                            (searchBlock
                                { query = query
                                , toSearchString = .name
                                , render = renderFieldExplanation
                                }
                                fields
                            )
                        , yellow "and the following types:"
                        , lines
                            (searchBlock
                                { query = query
                                , toSearchString = \tag -> tag
                                , render =
                                    \tag ->
                                        [ "... on " ++ cyan tag ++ " {"
                                        , grey "    # select some fields here!"
                                        , "}"
                                        ]
                                }
                                tags
                            )
                        ]

        GlobalFragmentNameFilenameMismatch errorDetails ->
            String.join "\n"
                [ "The filename and the fragment name don't match"
                , block
                    [ yellow errorDetails.filename
                    , yellow errorDetails.fragmentName
                    ]
                ]

        GlobalFragmentTooMuchStuff ->
            String.join "\n"
                [ "Global fragment files can only contain one fragment definition, but I found some other stuff in there."
                , "Also, make sure to name your fragment the same as the filename!"
                ]

        GlobalFragmentPresent { fragmentsDuplicatingGlobalOnes } ->
            case fragmentsDuplicatingGlobalOnes of
                [ single ] ->
                    String.join "\n"
                        [ "I found a fragment that collides with a globally defined one: "
                        , block
                            [ yellow single ]
                        ]

                _ ->
                    String.join "\n"
                        [ "I found some fragments that collide with  "
                        , block
                            (List.map yellow fragmentsDuplicatingGlobalOnes)
                        ]


queryNotice : String
queryNotice =
    grey "Search by typing a filter after the '?',(Such as ?user to search for fields that contain user)"


limit : Int
limit =
    20


searchBlock :
    { query : String
    , toSearchString : item -> String
    , render : item -> List String
    }
    -> List item
    -> List String
searchBlock options items =
    let
        ( finalCount, renderedItems ) =
            items
                |> List.sortBy options.toSearchString
                |> List.foldl
                    (\item ( count, rendered ) ->
                        let
                            searchString =
                                options.toSearchString item
                        in
                        if String.contains (String.toLower options.query) (String.toLower searchString) then
                            ( count + 1
                            , if count <= limit then
                                rendered ++ options.render item

                              else
                                rendered
                            )

                        else
                            ( count, rendered )
                    )
                    ( 0, [] )

        final =
            if finalCount > limit then
                List.filterMap identity
                    [ Just (grey ("...and " ++ String.fromInt (finalCount - limit) ++ " more"))
                    , if String.isEmpty (String.trim options.query) then
                        Just queryNotice

                      else
                        Nothing
                    ]

            else if String.isEmpty (String.trim options.query) then
                []

            else
                [ grey "Only showing values that match the query: " ++ cyan ("?" ++ options.query)
                ]

        finalItems =
            case renderedItems of
                [] ->
                    [ grey "Nothing found"
                    ]

                _ ->
                    renderedItems
    in
    [ block finalItems ] ++ final


renderFieldExplanation : GraphQL.Schema.Field -> List String
renderFieldExplanation field =
    if GraphQL.Schema.isScalar field.type_ then
        [ yellow field.name ++ grey (" # " ++ GraphQL.Schema.typeToString field.type_) ]

    else
        [ yellow field.name ++ " { " ++ grey ("# " ++ GraphQL.Schema.typeToString field.type_) ++ "}"
        ]


fragmentName : Can.Fragment -> String
fragmentName frag =
    Can.nameToString frag.name ++ " on " ++ Can.nameToString frag.typeCondition


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

module Gen.GraphQL.Operations.Canonicalize.Error exposing (annotation_, call_, caseOf_, cyan, error, make_, moduleName_, toString, todo, values_)

{-| 
@docs values_, call_, caseOf_, make_, annotation_, todo, error, cyan, toString, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize", "Error" ]


{-| toString: Error -> String -}
toString : Elm.Expression -> Elm.Expression
toString toStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            , name = "toString"
            , annotation =
                Just
                    (Type.function [ Type.namedWith [] "Error" [] ] Type.string)
            }
        )
        [ toStringArg ]


{-| cyan: String -> String -}
cyan : String -> Elm.Expression
cyan cyanArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            , name = "cyan"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
        )
        [ Elm.string cyanArg ]


{-| error: ErrorDetails -> Error -}
error : Elm.Expression -> Elm.Expression
error errorArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            , name = "error"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "ErrorDetails" [] ]
                        (Type.namedWith [] "Error" [])
                    )
            }
        )
        [ errorArg ]


{-| todo: String -> Error -}
todo : String -> Elm.Expression
todo todoArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            , name = "todo"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith [] "Error" [])
                    )
            }
        )
        [ Elm.string todoArg ]


annotation_ :
    { fragmentVariableSummary : Type.Annotation
    , variableSummary : Type.Annotation
    , varIssue : Type.Annotation
    , errorDetails : Type.Annotation
    , error : Type.Annotation
    }
annotation_ =
    { fragmentVariableSummary =
        Type.alias
            moduleName_
            "FragmentVariableSummary"
            []
            (Type.record
                [ ( "fragmentName", Type.string )
                , ( "declared"
                  , Type.list
                        (Type.record
                            [ ( "name", Type.string )
                            , ( "type_", Type.string )
                            ]
                        )
                  )
                , ( "used"
                  , Type.list
                        (Type.record
                            [ ( "name", Type.string )
                            , ( "type_", Type.string )
                            ]
                        )
                  )
                ]
            )
    , variableSummary =
        Type.alias
            moduleName_
            "VariableSummary"
            []
            (Type.record
                [ ( "declared"
                  , Type.list (Type.namedWith [] "DeclaredVariable" [])
                  )
                , ( "valid"
                  , Type.list (Type.namedWith [ "Can" ] "VariableDefinition" [])
                  )
                , ( "issues", Type.list (Type.namedWith [] "VarIssue" []) )
                , ( "suggestions"
                  , Type.list (Type.namedWith [] "SuggestedVariable" [])
                  )
                ]
            )
    , varIssue =
        Type.namedWith
            [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            "VarIssue"
            []
    , errorDetails =
        Type.namedWith
            [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            "ErrorDetails"
            []
    , error =
        Type.namedWith
            [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            "Error"
            []
    }


make_ :
    { fragmentVariableSummary :
        { fragmentName : Elm.Expression
        , declared : Elm.Expression
        , used : Elm.Expression
        }
        -> Elm.Expression
    , variableSummary :
        { declared : Elm.Expression
        , valid : Elm.Expression
        , issues : Elm.Expression
        , suggestions : Elm.Expression
        }
        -> Elm.Expression
    , unused : Elm.Expression -> Elm.Expression
    , unexpectedType : Elm.Expression -> Elm.Expression
    , undeclared : Elm.Expression -> Elm.Expression
    , queryUnknown : Elm.Expression -> Elm.Expression
    , enumUnknown : Elm.Expression -> Elm.Expression
    , objectUnknown : Elm.Expression -> Elm.Expression
    , unionUnknown : Elm.Expression -> Elm.Expression
    , unknownArgs : Elm.Expression -> Elm.Expression
    , emptySelection : Elm.Expression -> Elm.Expression
    , fieldUnknown : Elm.Expression -> Elm.Expression
    , variableIssueSummary : Elm.Expression -> Elm.Expression
    , fragmentVariableIssue : Elm.Expression -> Elm.Expression
    , fieldAliasRequired : Elm.Expression -> Elm.Expression
    , missingTypename : Elm.Expression -> Elm.Expression
    , emptyUnionVariantSelection : Elm.Expression -> Elm.Expression
    , incorrectInlineInput : Elm.Expression -> Elm.Expression
    , fragmentNotFound : Elm.Expression -> Elm.Expression
    , fragmentTargetDoesntExist : Elm.Expression -> Elm.Expression
    , fragmentDuplicateFound : Elm.Expression -> Elm.Expression
    , fragmentSelectionNotAllowedInObjects : Elm.Expression -> Elm.Expression
    , fragmentInlineTopLevel : Elm.Expression -> Elm.Expression
    , todo : Elm.Expression -> Elm.Expression
    , error : Elm.Expression -> Elm.Expression
    }
make_ =
    { fragmentVariableSummary =
        \fragmentVariableSummary_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    "FragmentVariableSummary"
                    []
                    (Type.record
                        [ ( "fragmentName", Type.string )
                        , ( "declared"
                          , Type.list
                                (Type.record
                                    [ ( "name", Type.string )
                                    , ( "type_", Type.string )
                                    ]
                                )
                          )
                        , ( "used"
                          , Type.list
                                (Type.record
                                    [ ( "name", Type.string )
                                    , ( "type_", Type.string )
                                    ]
                                )
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair
                        "fragmentName"
                        fragmentVariableSummary_args.fragmentName
                    , Tuple.pair
                        "declared"
                        fragmentVariableSummary_args.declared
                    , Tuple.pair "used" fragmentVariableSummary_args.used
                    ]
                )
    , variableSummary =
        \variableSummary_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    "VariableSummary"
                    []
                    (Type.record
                        [ ( "declared"
                          , Type.list (Type.namedWith [] "DeclaredVariable" [])
                          )
                        , ( "valid"
                          , Type.list
                                (Type.namedWith
                                    [ "Can" ]
                                    "VariableDefinition"
                                    []
                                )
                          )
                        , ( "issues"
                          , Type.list (Type.namedWith [] "VarIssue" [])
                          )
                        , ( "suggestions"
                          , Type.list (Type.namedWith [] "SuggestedVariable" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "declared" variableSummary_args.declared
                    , Tuple.pair "valid" variableSummary_args.valid
                    , Tuple.pair "issues" variableSummary_args.issues
                    , Tuple.pair "suggestions" variableSummary_args.suggestions
                    ]
                )
    , unused =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "Unused"
                    , annotation = Just (Type.namedWith [] "VarIssue" [])
                    }
                )
                [ ar0 ]
    , unexpectedType =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "UnexpectedType"
                    , annotation = Just (Type.namedWith [] "VarIssue" [])
                    }
                )
                [ ar0 ]
    , undeclared =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "Undeclared"
                    , annotation = Just (Type.namedWith [] "VarIssue" [])
                    }
                )
                [ ar0 ]
    , queryUnknown =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "QueryUnknown"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , enumUnknown =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "EnumUnknown"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , objectUnknown =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "ObjectUnknown"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , unionUnknown =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "UnionUnknown"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , unknownArgs =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "UnknownArgs"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , emptySelection =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "EmptySelection"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , fieldUnknown =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "FieldUnknown"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , variableIssueSummary =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "VariableIssueSummary"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , fragmentVariableIssue =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "FragmentVariableIssue"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , fieldAliasRequired =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "FieldAliasRequired"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , missingTypename =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "MissingTypename"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , emptyUnionVariantSelection =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "EmptyUnionVariantSelection"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , incorrectInlineInput =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "IncorrectInlineInput"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , fragmentNotFound =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "FragmentNotFound"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , fragmentTargetDoesntExist =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "FragmentTargetDoesntExist"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , fragmentDuplicateFound =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "FragmentDuplicateFound"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , fragmentSelectionNotAllowedInObjects =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "FragmentSelectionNotAllowedInObjects"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , fragmentInlineTopLevel =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "FragmentInlineTopLevel"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , todo =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "Todo"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , error =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "Error"
                    , annotation = Just (Type.namedWith [] "Error" [])
                    }
                )
                [ ar0 ]
    }


caseOf_ :
    { varIssue :
        Elm.Expression
        -> { varIssueTags_0_0
            | unused : Elm.Expression -> Elm.Expression
            , unexpectedType : Elm.Expression -> Elm.Expression
            , undeclared : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , errorDetails :
        Elm.Expression
        -> { errorDetailsTags_1_0
            | queryUnknown : Elm.Expression -> Elm.Expression
            , enumUnknown : Elm.Expression -> Elm.Expression
            , objectUnknown : Elm.Expression -> Elm.Expression
            , unionUnknown : Elm.Expression -> Elm.Expression
            , unknownArgs : Elm.Expression -> Elm.Expression
            , emptySelection : Elm.Expression -> Elm.Expression
            , fieldUnknown : Elm.Expression -> Elm.Expression
            , variableIssueSummary : Elm.Expression -> Elm.Expression
            , fragmentVariableIssue : Elm.Expression -> Elm.Expression
            , fieldAliasRequired : Elm.Expression -> Elm.Expression
            , missingTypename : Elm.Expression -> Elm.Expression
            , emptyUnionVariantSelection : Elm.Expression -> Elm.Expression
            , incorrectInlineInput : Elm.Expression -> Elm.Expression
            , fragmentNotFound : Elm.Expression -> Elm.Expression
            , fragmentTargetDoesntExist : Elm.Expression -> Elm.Expression
            , fragmentDuplicateFound : Elm.Expression -> Elm.Expression
            , fragmentSelectionNotAllowedInObjects :
                Elm.Expression -> Elm.Expression
            , fragmentInlineTopLevel : Elm.Expression -> Elm.Expression
            , todo : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , error :
        Elm.Expression
        -> { errorTags_2_0 | error : Elm.Expression -> Elm.Expression }
        -> Elm.Expression
    }
caseOf_ =
    { varIssue =
        \varIssueExpression varIssueTags ->
            Elm.Case.custom
                varIssueExpression
                (Type.namedWith
                    [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    "VarIssue"
                    []
                )
                [ Elm.Case.branch1
                    "Unused"
                    ( "one"
                    , Type.record
                        [ ( "name", Type.string )
                        , ( "possibly", Type.list Type.string )
                        ]
                    )
                    varIssueTags.unused
                , Elm.Case.branch1
                    "UnexpectedType"
                    ( "one"
                    , Type.record
                        [ ( "name", Type.string )
                        , ( "found", Type.namedWith [] "Maybe" [ Type.string ] )
                        , ( "expected", Type.string )
                        ]
                    )
                    varIssueTags.unexpectedType
                , Elm.Case.branch1
                    "Undeclared"
                    ( "one"
                    , Type.record
                        [ ( "name", Type.string )
                        , ( "possibly", Type.list Type.string )
                        ]
                    )
                    varIssueTags.undeclared
                ]
    , errorDetails =
        \errorDetailsExpression errorDetailsTags ->
            Elm.Case.custom
                errorDetailsExpression
                (Type.namedWith
                    [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    "ErrorDetails"
                    []
                )
                [ Elm.Case.branch1
                    "QueryUnknown"
                    ( "string.String", Type.string )
                    errorDetailsTags.queryUnknown
                , Elm.Case.branch1
                    "EnumUnknown"
                    ( "string.String", Type.string )
                    errorDetailsTags.enumUnknown
                , Elm.Case.branch1
                    "ObjectUnknown"
                    ( "string.String", Type.string )
                    errorDetailsTags.objectUnknown
                , Elm.Case.branch1
                    "UnionUnknown"
                    ( "string.String", Type.string )
                    errorDetailsTags.unionUnknown
                , Elm.Case.branch1
                    "UnknownArgs"
                    ( "one"
                    , Type.record
                        [ ( "field", Type.string )
                        , ( "unknownArgs", Type.list Type.string )
                        , ( "allowedArgs"
                          , Type.list
                                (Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Argument"
                                    []
                                )
                          )
                        ]
                    )
                    errorDetailsTags.unknownArgs
                , Elm.Case.branch1
                    "EmptySelection"
                    ( "one"
                    , Type.record
                        [ ( "field", Type.string )
                        , ( "fieldType", Type.string )
                        , ( "options"
                          , Type.list
                                (Type.record
                                    [ ( "field", Type.string )
                                    , ( "type_", Type.string )
                                    ]
                                )
                          )
                        ]
                    )
                    errorDetailsTags.emptySelection
                , Elm.Case.branch1
                    "FieldUnknown"
                    ( "one"
                    , Type.record
                        [ ( "object", Type.string ), ( "field", Type.string ) ]
                    )
                    errorDetailsTags.fieldUnknown
                , Elm.Case.branch1
                    "VariableIssueSummary"
                    ( "variableSummary"
                    , Type.namedWith [] "VariableSummary" []
                    )
                    errorDetailsTags.variableIssueSummary
                , Elm.Case.branch1
                    "FragmentVariableIssue"
                    ( "fragmentVariableSummary"
                    , Type.namedWith [] "FragmentVariableSummary" []
                    )
                    errorDetailsTags.fragmentVariableIssue
                , Elm.Case.branch1
                    "FieldAliasRequired"
                    ( "one", Type.record [ ( "fieldName", Type.string ) ] )
                    errorDetailsTags.fieldAliasRequired
                , Elm.Case.branch1
                    "MissingTypename"
                    ( "one", Type.record [ ( "tag", Type.string ) ] )
                    errorDetailsTags.missingTypename
                , Elm.Case.branch1
                    "EmptyUnionVariantSelection"
                    ( "one", Type.record [ ( "tag", Type.string ) ] )
                    errorDetailsTags.emptyUnionVariantSelection
                , Elm.Case.branch1
                    "IncorrectInlineInput"
                    ( "one"
                    , Type.record
                        [ ( "schema"
                          , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                          )
                        , ( "arg", Type.string )
                        , ( "found", Type.namedWith [ "AST" ] "Value" [] )
                        ]
                    )
                    errorDetailsTags.incorrectInlineInput
                , Elm.Case.branch1
                    "FragmentNotFound"
                    ( "one"
                    , Type.record
                        [ ( "found", Type.string )
                        , ( "object", Type.string )
                        , ( "options"
                          , Type.list (Type.namedWith [ "Can" ] "Fragment" [])
                          )
                        ]
                    )
                    errorDetailsTags.fragmentNotFound
                , Elm.Case.branch1
                    "FragmentTargetDoesntExist"
                    ( "one"
                    , Type.record
                        [ ( "fragmentName", Type.string )
                        , ( "typeCondition", Type.string )
                        ]
                    )
                    errorDetailsTags.fragmentTargetDoesntExist
                , Elm.Case.branch1
                    "FragmentDuplicateFound"
                    ( "one"
                    , Type.record
                        [ ( "firstName", Type.string )
                        , ( "firstTypeCondition", Type.string )
                        , ( "firstFieldCount", Type.int )
                        , ( "secondName", Type.string )
                        , ( "secondTypeCondition", Type.string )
                        , ( "secondFieldCount", Type.int )
                        ]
                    )
                    errorDetailsTags.fragmentDuplicateFound
                , Elm.Case.branch1
                    "FragmentSelectionNotAllowedInObjects"
                    ( "one"
                    , Type.record
                        [ ( "fragment"
                          , Type.namedWith [ "AST" ] "InlineFragment" []
                          )
                        , ( "objectName", Type.string )
                        ]
                    )
                    errorDetailsTags.fragmentSelectionNotAllowedInObjects
                , Elm.Case.branch1
                    "FragmentInlineTopLevel"
                    ( "one"
                    , Type.record
                        [ ( "fragment"
                          , Type.namedWith [ "AST" ] "InlineFragment" []
                          )
                        ]
                    )
                    errorDetailsTags.fragmentInlineTopLevel
                , Elm.Case.branch1
                    "Todo"
                    ( "string.String", Type.string )
                    errorDetailsTags.todo
                ]
    , error =
        \errorExpression errorTags ->
            Elm.Case.custom
                errorExpression
                (Type.namedWith
                    [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    "Error"
                    []
                )
                [ Elm.Case.branch1
                    "Error"
                    ( "one"
                    , Type.record
                        [ ( "coords", Type.namedWith [] "Coords" [] )
                        , ( "error", Type.namedWith [] "ErrorDetails" [] )
                        ]
                    )
                    errorTags.error
                ]
    }


call_ :
    { toString : Elm.Expression -> Elm.Expression
    , cyan : Elm.Expression -> Elm.Expression
    , error : Elm.Expression -> Elm.Expression
    , todo : Elm.Expression -> Elm.Expression
    }
call_ =
    { toString =
        \toStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "toString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Error" [] ]
                                Type.string
                            )
                    }
                )
                [ toStringArg ]
    , cyan =
        \cyanArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "cyan"
                    , annotation =
                        Just (Type.function [ Type.string ] Type.string)
                    }
                )
                [ cyanArg ]
    , error =
        \errorArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "error"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "ErrorDetails" [] ]
                                (Type.namedWith [] "Error" [])
                            )
                    }
                )
                [ errorArg ]
    , todo =
        \todoArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "todo"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string ]
                                (Type.namedWith [] "Error" [])
                            )
                    }
                )
                [ todoArg ]
    }


values_ :
    { toString : Elm.Expression
    , cyan : Elm.Expression
    , error : Elm.Expression
    , todo : Elm.Expression
    }
values_ =
    { toString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            , name = "toString"
            , annotation =
                Just
                    (Type.function [ Type.namedWith [] "Error" [] ] Type.string)
            }
    , cyan =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            , name = "cyan"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
    , error =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            , name = "error"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "ErrorDetails" [] ]
                        (Type.namedWith [] "Error" [])
                    )
            }
    , todo =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            , name = "todo"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith [] "Error" [])
                    )
            }
    }



module Gen.GraphQL.Operations.Canonicalize.Error exposing (annotation_, call_, caseOf_, error, make_, moduleName_, render, values_)

{-| 
@docs moduleName_, error, render, annotation_, make_, caseOf_, call_, values_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize", "Error" ]


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


{-| render: 
    { path : String, errors : List Error }
    -> { title : String, description : String }
-}
render : { path : String, errors : List Elm.Expression } -> Elm.Expression
render renderArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            , name = "render"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "path", Type.string )
                            , ( "errors"
                              , Type.list (Type.namedWith [] "Error" [])
                              )
                            ]
                        ]
                        (Type.record
                            [ ( "title", Type.string )
                            , ( "description", Type.string )
                            ]
                        )
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "path" (Elm.string renderArg.path)
            , Tuple.pair "errors" (Elm.list renderArg.errors)
            ]
        ]


annotation_ :
    { suggestedVariable : Type.Annotation
    , declaredVariable : Type.Annotation
    , fragmentVariableSummary : Type.Annotation
    , variableSummary : Type.Annotation
    , position : Type.Annotation
    , coords : Type.Annotation
    , varIssue : Type.Annotation
    , explanantionDetails : Type.Annotation
    , errorDetails : Type.Annotation
    , error : Type.Annotation
    }
annotation_ =
    { suggestedVariable =
        Type.alias
            moduleName_
            "SuggestedVariable"
            []
            (Type.record [ ( "name", Type.string ), ( "type_", Type.string ) ])
    , declaredVariable =
        Type.alias
            moduleName_
            "DeclaredVariable"
            []
            (Type.record
                [ ( "name", Type.string )
                , ( "type_", Type.namedWith [] "Maybe" [ Type.string ] )
                ]
            )
    , fragmentVariableSummary =
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
    , position =
        Type.alias
            moduleName_
            "Position"
            []
            (Type.record [ ( "line", Type.int ), ( "char", Type.int ) ])
    , coords =
        Type.alias
            moduleName_
            "Coords"
            []
            (Type.record
                [ ( "start", Type.namedWith [] "Position" [] )
                , ( "end", Type.namedWith [] "Position" [] )
                ]
            )
    , varIssue =
        Type.namedWith
            [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            "VarIssue"
            []
    , explanantionDetails =
        Type.namedWith
            [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            "ExplanantionDetails"
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
    { suggestedVariable :
        { name : Elm.Expression, type_ : Elm.Expression } -> Elm.Expression
    , declaredVariable :
        { name : Elm.Expression, type_ : Elm.Expression } -> Elm.Expression
    , fragmentVariableSummary :
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
    , position :
        { line : Elm.Expression, char : Elm.Expression } -> Elm.Expression
    , coords :
        { start : Elm.Expression, end : Elm.Expression } -> Elm.Expression
    , unused : Elm.Expression -> Elm.Expression
    , unexpectedType : Elm.Expression -> Elm.Expression
    , undeclared : Elm.Expression -> Elm.Expression
    , operation : Elm.Expression -> Elm.Expression -> Elm.Expression
    , object : Elm.Expression -> Elm.Expression
    , union : Elm.Expression -> Elm.Expression
    , interface : Elm.Expression -> Elm.Expression
    , unableToParse : Elm.Expression -> Elm.Expression
    , queryUnknown : Elm.Expression -> Elm.Expression
    , enumUnknown : Elm.Expression -> Elm.Expression
    , objectUnknown : Elm.Expression -> Elm.Expression
    , unionUnknown : Elm.Expression -> Elm.Expression
    , topLevelFragmentsNotAllowed : Elm.Expression -> Elm.Expression
    , foundSelectionOfInputObject : Elm.Expression -> Elm.Expression
    , unionVariantNotFound : Elm.Expression -> Elm.Expression
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
    , fragmentCyclicDependency : Elm.Expression -> Elm.Expression
    , globalFragmentNameFilenameMismatch : Elm.Expression -> Elm.Expression
    , globalFragmentTooMuchStuff : Elm.Expression
    , explanation : Elm.Expression -> Elm.Expression
    , error : Elm.Expression -> Elm.Expression
    }
make_ =
    { suggestedVariable =
        \suggestedVariable_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    "SuggestedVariable"
                    []
                    (Type.record
                        [ ( "name", Type.string ), ( "type_", Type.string ) ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" suggestedVariable_args.name
                    , Tuple.pair "type_" suggestedVariable_args.type_
                    ]
                )
    , declaredVariable =
        \declaredVariable_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    "DeclaredVariable"
                    []
                    (Type.record
                        [ ( "name", Type.string )
                        , ( "type_", Type.namedWith [] "Maybe" [ Type.string ] )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" declaredVariable_args.name
                    , Tuple.pair "type_" declaredVariable_args.type_
                    ]
                )
    , fragmentVariableSummary =
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
    , position =
        \position_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    "Position"
                    []
                    (Type.record [ ( "line", Type.int ), ( "char", Type.int ) ])
                )
                (Elm.record
                    [ Tuple.pair "line" position_args.line
                    , Tuple.pair "char" position_args.char
                    ]
                )
    , coords =
        \coords_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    "Coords"
                    []
                    (Type.record
                        [ ( "start", Type.namedWith [] "Position" [] )
                        , ( "end", Type.namedWith [] "Position" [] )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "start" coords_args.start
                    , Tuple.pair "end" coords_args.end
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
    , operation =
        \ar0 ar1 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "Operation"
                    , annotation =
                        Just (Type.namedWith [] "ExplanantionDetails" [])
                    }
                )
                [ ar0, ar1 ]
    , object =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "Object"
                    , annotation =
                        Just (Type.namedWith [] "ExplanantionDetails" [])
                    }
                )
                [ ar0 ]
    , union =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "Union"
                    , annotation =
                        Just (Type.namedWith [] "ExplanantionDetails" [])
                    }
                )
                [ ar0 ]
    , interface =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "Interface"
                    , annotation =
                        Just (Type.namedWith [] "ExplanantionDetails" [])
                    }
                )
                [ ar0 ]
    , unableToParse =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "UnableToParse"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
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
    , topLevelFragmentsNotAllowed =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "TopLevelFragmentsNotAllowed"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , foundSelectionOfInputObject =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "FoundSelectionOfInputObject"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , unionVariantNotFound =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "UnionVariantNotFound"
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
    , fragmentCyclicDependency =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "FragmentCyclicDependency"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , globalFragmentNameFilenameMismatch =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "GlobalFragmentNameFilenameMismatch"
                    , annotation = Just (Type.namedWith [] "ErrorDetails" [])
                    }
                )
                [ ar0 ]
    , globalFragmentTooMuchStuff =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            , name = "GlobalFragmentTooMuchStuff"
            , annotation = Just (Type.namedWith [] "ErrorDetails" [])
            }
    , explanation =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "Explanation"
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
    , explanantionDetails :
        Elm.Expression
        -> { explanantionDetailsTags_1_0
            | operation : Elm.Expression -> Elm.Expression -> Elm.Expression
            , object : Elm.Expression -> Elm.Expression
            , union : Elm.Expression -> Elm.Expression
            , interface : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , errorDetails :
        Elm.Expression
        -> { errorDetailsTags_2_0
            | unableToParse : Elm.Expression -> Elm.Expression
            , queryUnknown : Elm.Expression -> Elm.Expression
            , enumUnknown : Elm.Expression -> Elm.Expression
            , objectUnknown : Elm.Expression -> Elm.Expression
            , unionUnknown : Elm.Expression -> Elm.Expression
            , topLevelFragmentsNotAllowed : Elm.Expression -> Elm.Expression
            , foundSelectionOfInputObject : Elm.Expression -> Elm.Expression
            , unionVariantNotFound : Elm.Expression -> Elm.Expression
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
            , fragmentCyclicDependency : Elm.Expression -> Elm.Expression
            , globalFragmentNameFilenameMismatch :
                Elm.Expression -> Elm.Expression
            , globalFragmentTooMuchStuff : Elm.Expression
            , explanation : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , error :
        Elm.Expression
        -> { errorTags_3_0 | error : Elm.Expression -> Elm.Expression }
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
    , explanantionDetails =
        \explanantionDetailsExpression explanantionDetailsTags ->
            Elm.Case.custom
                explanantionDetailsExpression
                (Type.namedWith
                    [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    "ExplanantionDetails"
                    []
                )
                [ Elm.Case.branch2
                    "Operation"
                    ( "aST.OperationType"
                    , Type.namedWith [ "AST" ] "OperationType" []
                    )
                    ( "list.List"
                    , Type.list
                        (Type.tuple
                            Type.string
                            (Type.namedWith [ "GraphQL", "Schema" ] "Type" [])
                        )
                    )
                    explanantionDetailsTags.operation
                , Elm.Case.branch1
                    "Object"
                    ( "one"
                    , Type.record
                        [ ( "name", Type.string )
                        , ( "fields"
                          , Type.list
                                (Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Field"
                                    []
                                )
                          )
                        ]
                    )
                    explanantionDetailsTags.object
                , Elm.Case.branch1
                    "Union"
                    ( "one"
                    , Type.record
                        [ ( "name", Type.string )
                        , ( "fields"
                          , Type.list
                                (Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Field"
                                    []
                                )
                          )
                        , ( "tags", Type.list Type.string )
                        ]
                    )
                    explanantionDetailsTags.union
                , Elm.Case.branch1
                    "Interface"
                    ( "one"
                    , Type.record
                        [ ( "name", Type.string )
                        , ( "fields"
                          , Type.list
                                (Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Field"
                                    []
                                )
                          )
                        , ( "tags", Type.list Type.string )
                        ]
                    )
                    explanantionDetailsTags.interface
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
                    "UnableToParse"
                    ( "one", Type.record [ ( "description", Type.string ) ] )
                    errorDetailsTags.unableToParse
                , Elm.Case.branch1
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
                    "TopLevelFragmentsNotAllowed"
                    ( "one", Type.record [ ( "fragmentName", Type.string ) ] )
                    errorDetailsTags.topLevelFragmentsNotAllowed
                , Elm.Case.branch1
                    "FoundSelectionOfInputObject"
                    ( "one"
                    , Type.record
                        [ ( "fieldName", Type.string )
                        , ( "inputObjectName", Type.string )
                        ]
                    )
                    errorDetailsTags.foundSelectionOfInputObject
                , Elm.Case.branch1
                    "UnionVariantNotFound"
                    ( "one"
                    , Type.record
                        [ ( "found", Type.string )
                        , ( "objectOrInterfaceName", Type.string )
                        , ( "knownVariants", Type.list Type.string )
                        ]
                    )
                    errorDetailsTags.unionVariantNotFound
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
                    "FragmentCyclicDependency"
                    ( "one"
                    , Type.record
                        [ ( "fragments"
                          , Type.list
                                (Type.namedWith [ "AST" ] "FragmentDetails" [])
                          )
                        ]
                    )
                    errorDetailsTags.fragmentCyclicDependency
                , Elm.Case.branch1
                    "GlobalFragmentNameFilenameMismatch"
                    ( "one"
                    , Type.record
                        [ ( "filename", Type.string )
                        , ( "fragmentName", Type.string )
                        ]
                    )
                    errorDetailsTags.globalFragmentNameFilenameMismatch
                , Elm.Case.branch0
                    "GlobalFragmentTooMuchStuff"
                    errorDetailsTags.globalFragmentTooMuchStuff
                , Elm.Case.branch1
                    "Explanation"
                    ( "one"
                    , Type.record
                        [ ( "query", Type.string )
                        , ( "explanation"
                          , Type.namedWith [] "ExplanantionDetails" []
                          )
                        ]
                    )
                    errorDetailsTags.explanation
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
    { error : Elm.Expression -> Elm.Expression
    , render : Elm.Expression -> Elm.Expression
    }
call_ =
    { error =
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
    , render =
        \renderArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Error" ]
                    , name = "render"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "path", Type.string )
                                    , ( "errors"
                                      , Type.list (Type.namedWith [] "Error" [])
                                      )
                                    ]
                                ]
                                (Type.record
                                    [ ( "title", Type.string )
                                    , ( "description", Type.string )
                                    ]
                                )
                            )
                    }
                )
                [ renderArg ]
    }


values_ : { error : Elm.Expression, render : Elm.Expression }
values_ =
    { error =
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
    , render =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Error" ]
            , name = "render"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "path", Type.string )
                            , ( "errors"
                              , Type.list (Type.namedWith [] "Error" [])
                              )
                            ]
                        ]
                        (Type.record
                            [ ( "title", Type.string )
                            , ( "description", Type.string )
                            ]
                        )
                    )
            }
    }
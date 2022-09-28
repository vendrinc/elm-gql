module Gen.GraphQL.Operations.CanonicalAST exposing (addArgValue, addExp, addLevelToCursor, addString, aliasedName, aliasedNameExp, annotation_, argToString, argValToString, brackets, call_, caseOf_, commit, foldToString, getAliasedFieldName, getAliasedName, getWrapper, initCursor, isTypeNameSelection, make_, moduleName_, nameToString, operationLabel, operationName, removeLevelToCursor, renderArguments, renderArgumentsExp, renderSelection, renderSelectionExp, renderVariantFragmentToExp, selectionToExpressionString, selectionToString, toRendererExpression, toString, toStringFields, typeToString, unwrap, values_, variantFragmentToString)

{-| 
@docs values_, call_, caseOf_, make_, annotation_, isTypeNameSelection, getAliasedName, getAliasedFieldName, nameToString, toString, operationLabel, toStringFields, selectionToString, variantFragmentToString, renderSelection, renderArguments, argToString, argValToString, aliasedName, foldToString, operationName, brackets, getWrapper, typeToString, unwrap, toRendererExpression, initCursor, addLevelToCursor, removeLevelToCursor, commit, addString, addExp, selectionToExpressionString, aliasedNameExp, renderArgumentsExp, addArgValue, renderSelectionExp, renderVariantFragmentToExp, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "CanonicalAST" ]


{-| renderVariantFragmentToExp: UnionCaseDetails -> RenderingCursor -> RenderingCursor -}
renderVariantFragmentToExp : Elm.Expression -> Elm.Expression -> Elm.Expression
renderVariantFragmentToExp renderVariantFragmentToExpArg renderVariantFragmentToExpArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "renderVariantFragmentToExp"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "UnionCaseDetails" []
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ renderVariantFragmentToExpArg, renderVariantFragmentToExpArg0 ]


{-| renderSelectionExp: List Selection -> RenderingCursor -> RenderingCursor -}
renderSelectionExp : List Elm.Expression -> Elm.Expression -> Elm.Expression
renderSelectionExp renderSelectionExpArg renderSelectionExpArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "renderSelectionExp"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [] "Selection" [])
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ Elm.list renderSelectionExpArg, renderSelectionExpArg0 ]


{-| addArgValue: AST.Value -> RenderingCursor -> RenderingCursor -}
addArgValue : Elm.Expression -> Elm.Expression -> Elm.Expression
addArgValue addArgValueArg addArgValueArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "addArgValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "AST" ] "Value" []
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ addArgValueArg, addArgValueArg0 ]


{-| renderArgumentsExp: List Argument -> RenderingCursor -> RenderingCursor -}
renderArgumentsExp : List Elm.Expression -> Elm.Expression -> Elm.Expression
renderArgumentsExp renderArgumentsExpArg renderArgumentsExpArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "renderArgumentsExp"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [] "Argument" [])
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ Elm.list renderArgumentsExpArg, renderArgumentsExpArg0 ]


{-| aliasedNameExp: { a | alias_ : Maybe Name, name : Name } -> RenderingCursor -> RenderingCursor -}
aliasedNameExp :
    { a | alias_ : Elm.Expression, name : Elm.Expression }
    -> Elm.Expression
    -> Elm.Expression
aliasedNameExp aliasedNameExpArg aliasedNameExpArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "aliasedNameExp"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "a"
                            [ ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [] "Name" [] ]
                              )
                            , ( "name", Type.namedWith [] "Name" [] )
                            ]
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "alias_" aliasedNameExpArg.alias_
            , Tuple.pair "name" aliasedNameExpArg.name
            ]
        , aliasedNameExpArg0
        ]


{-| selectionToExpressionString: Selection -> RenderingCursor -> RenderingCursor -}
selectionToExpressionString : Elm.Expression -> Elm.Expression -> Elm.Expression
selectionToExpressionString selectionToExpressionStringArg selectionToExpressionStringArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "selectionToExpressionString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Selection" []
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ selectionToExpressionStringArg, selectionToExpressionStringArg0 ]


{-| addExp: Elm.Expression -> RenderingCursor -> RenderingCursor -}
addExp : Elm.Expression -> Elm.Expression -> Elm.Expression
addExp addExpArg addExpArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "addExp"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Elm" ] "Expression" []
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ addExpArg, addExpArg0 ]


{-| addString: String -> RenderingCursor -> RenderingCursor -}
addString : String -> Elm.Expression -> Elm.Expression
addString addStringArg addStringArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "addString"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "RenderingCursor" [] ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ Elm.string addStringArg, addStringArg0 ]


{-| commit: RenderingCursor -> RenderingCursor -}
commit : Elm.Expression -> Elm.Expression
commit commitArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "commit"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "RenderingCursor" [] ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ commitArg ]


{-| removeLevelToCursor: RenderingCursor -> RenderingCursor -}
removeLevelToCursor : Elm.Expression -> Elm.Expression
removeLevelToCursor removeLevelToCursorArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "removeLevelToCursor"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "RenderingCursor" [] ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ removeLevelToCursorArg ]


{-| addLevelToCursor: RenderingCursor -> RenderingCursor -}
addLevelToCursor : Elm.Expression -> Elm.Expression
addLevelToCursor addLevelToCursorArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "addLevelToCursor"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "RenderingCursor" [] ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ addLevelToCursorArg ]


{-| initCursor: Elm.Expression -> RenderingCursor -}
initCursor : Elm.Expression -> Elm.Expression
initCursor initCursorArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "initCursor"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Elm" ] "Expression" [] ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
        )
        [ initCursorArg ]


{-| {-| We want to render a string of this, but with a `version`

The version is an Int, which represents if there are other queries batched with it.

-}

toRendererExpression: Elm.Expression -> Definition -> Elm.Expression
-}
toRendererExpression : Elm.Expression -> Elm.Expression -> Elm.Expression
toRendererExpression toRendererExpressionArg toRendererExpressionArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "toRendererExpression"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Elm" ] "Expression" []
                        , Type.namedWith [] "Definition" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ toRendererExpressionArg, toRendererExpressionArg0 ]


{-| unwrap: Wrapper -> String -> String -}
unwrap : Elm.Expression -> String -> Elm.Expression
unwrap unwrapArg unwrapArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "unwrap"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapper" [], Type.string ]
                        Type.string
                    )
            }
        )
        [ unwrapArg, Elm.string unwrapArg0 ]


{-| typeToString: Wrapper -> AST.Type -> String -}
typeToString : Elm.Expression -> Elm.Expression -> Elm.Expression
typeToString typeToStringArg typeToStringArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "typeToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapper" []
                        , Type.namedWith [ "AST" ] "Type" []
                        ]
                        Type.string
                    )
            }
        )
        [ typeToStringArg, typeToStringArg0 ]


{-| {-|

    Type ->
        Required Val

    Nullable Type ->
        Val

-}

getWrapper: AST.Type -> Wrapper -> Wrapper
-}
getWrapper : Elm.Expression -> Elm.Expression -> Elm.Expression
getWrapper getWrapperArg getWrapperArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "getWrapper"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "AST" ] "Type" []
                        , Type.namedWith [] "Wrapper" []
                        ]
                        (Type.namedWith [] "Wrapper" [])
                    )
            }
        )
        [ getWrapperArg, getWrapperArg0 ]


{-| brackets: String -> String -}
brackets : String -> Elm.Expression
brackets bracketsArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "brackets"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
        )
        [ Elm.string bracketsArg ]


{-| operationName: OperationType -> String -}
operationName : Elm.Expression -> Elm.Expression
operationName operationNameArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "operationName"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "OperationType" [] ]
                        Type.string
                    )
            }
        )
        [ operationNameArg ]


{-| foldToString: String -> (a -> String) -> List a -> String -}
foldToString :
    String
    -> (Elm.Expression -> Elm.Expression)
    -> List Elm.Expression
    -> Elm.Expression
foldToString foldToStringArg foldToStringArg0 foldToStringArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "foldToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.function [ Type.var "a" ] Type.string
                        , Type.list (Type.var "a")
                        ]
                        Type.string
                    )
            }
        )
        [ Elm.string foldToStringArg
        , Elm.functionReduced "foldToStringUnpack" foldToStringArg0
        , Elm.list foldToStringArg1
        ]


{-| aliasedName: { a | alias_ : Maybe Name, name : Name } -> String -}
aliasedName :
    { a | alias_ : Elm.Expression, name : Elm.Expression } -> Elm.Expression
aliasedName aliasedNameArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "aliasedName"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "a"
                            [ ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [] "Name" [] ]
                              )
                            , ( "name", Type.namedWith [] "Name" [] )
                            ]
                        ]
                        Type.string
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "alias_" aliasedNameArg.alias_
            , Tuple.pair "name" aliasedNameArg.name
            ]
        ]


{-| argValToString: AST.Value -> String -}
argValToString : Elm.Expression -> Elm.Expression
argValToString argValToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "argValToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "AST" ] "Value" [] ]
                        Type.string
                    )
            }
        )
        [ argValToStringArg ]


{-| argToString: Argument -> String -}
argToString : Elm.Expression -> Elm.Expression
argToString argToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "argToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Argument" [] ]
                        Type.string
                    )
            }
        )
        [ argToStringArg ]


{-| renderArguments: List Argument -> String -}
renderArguments : List Elm.Expression -> Elm.Expression
renderArguments renderArgumentsArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "renderArguments"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [] "Argument" []) ]
                        Type.string
                    )
            }
        )
        [ Elm.list renderArgumentsArg ]


{-| renderSelection: List Selection -> String -}
renderSelection : List Elm.Expression -> Elm.Expression
renderSelection renderSelectionArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "renderSelection"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [] "Selection" []) ]
                        Type.string
                    )
            }
        )
        [ Elm.list renderSelectionArg ]


{-| variantFragmentToString: UnionCaseDetails -> String -}
variantFragmentToString : Elm.Expression -> Elm.Expression
variantFragmentToString variantFragmentToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "variantFragmentToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "UnionCaseDetails" [] ]
                        Type.string
                    )
            }
        )
        [ variantFragmentToStringArg ]


{-| selectionToString: Selection -> String -}
selectionToString : Elm.Expression -> Elm.Expression
selectionToString selectionToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "selectionToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Selection" [] ]
                        Type.string
                    )
            }
        )
        [ selectionToStringArg ]


{-| {-| Only render the fields of the query, but with no outer brackets
-}

toStringFields: Definition -> String
-}
toStringFields : Elm.Expression -> Elm.Expression
toStringFields toStringFieldsArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "toStringFields"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Definition" [] ]
                        Type.string
                    )
            }
        )
        [ toStringFieldsArg ]


{-| {-| Only render the fields of the query, but with no outer brackets
-}

operationLabel: Definition -> Maybe String
-}
operationLabel : Elm.Expression -> Elm.Expression
operationLabel operationLabelArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "operationLabel"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Definition" [] ]
                        (Type.namedWith [] "Maybe" [ Type.string ])
                    )
            }
        )
        [ operationLabelArg ]


{-| {-| -}

toString: Definition -> String
-}
toString : Elm.Expression -> Elm.Expression
toString toStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "toString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Definition" [] ]
                        Type.string
                    )
            }
        )
        [ toStringArg ]


{-| nameToString: Name -> String -}
nameToString : Elm.Expression -> Elm.Expression
nameToString nameToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "nameToString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Name" [] ] Type.string)
            }
        )
        [ nameToStringArg ]


{-| getAliasedFieldName: { field | alias_ : Maybe Name, name : Name } -> String -}
getAliasedFieldName :
    { field | alias_ : Elm.Expression, name : Elm.Expression } -> Elm.Expression
getAliasedFieldName getAliasedFieldNameArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "getAliasedFieldName"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "field"
                            [ ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [] "Name" [] ]
                              )
                            , ( "name", Type.namedWith [] "Name" [] )
                            ]
                        ]
                        Type.string
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "alias_" getAliasedFieldNameArg.alias_
            , Tuple.pair "name" getAliasedFieldNameArg.name
            ]
        ]


{-| getAliasedName: { details | name : Name, alias_ : Maybe Name } -> String -}
getAliasedName :
    { details | name : Elm.Expression, alias_ : Elm.Expression }
    -> Elm.Expression
getAliasedName getAliasedNameArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "getAliasedName"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "details"
                            [ ( "name", Type.namedWith [] "Name" [] )
                            , ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [] "Name" [] ]
                              )
                            ]
                        ]
                        Type.string
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" getAliasedNameArg.name
            , Tuple.pair "alias_" getAliasedNameArg.alias_
            ]
        ]


{-| isTypeNameSelection: Selection -> Bool -}
isTypeNameSelection : Elm.Expression -> Elm.Expression
isTypeNameSelection isTypeNameSelectionArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "isTypeNameSelection"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Selection" [] ]
                        Type.bool
                    )
            }
        )
        [ isTypeNameSelectionArg ]


annotation_ :
    { renderingCursor : Type.Annotation
    , unionCaseDetails : Type.Annotation
    , fieldEnumDetails : Type.Annotation
    , fieldScalarDetails : Type.Annotation
    , interfaceCase : Type.Annotation
    , fieldInterfaceDetails : Type.Annotation
    , fieldUnionDetails : Type.Annotation
    , fieldObjectDetails : Type.Annotation
    , fragmentDetails : Type.Annotation
    , variable : Type.Annotation
    , variableDefinition : Type.Annotation
    , argument : Type.Annotation
    , directive : Type.Annotation
    , operationDetails : Type.Annotation
    , document : Type.Annotation
    , wrapper : Type.Annotation
    , name : Type.Annotation
    , selection : Type.Annotation
    , operationType : Type.Annotation
    , definition : Type.Annotation
    }
annotation_ =
    { renderingCursor =
        Type.alias
            moduleName_
            "RenderingCursor"
            []
            (Type.record
                [ ( "string", Type.string )
                , ( "exp"
                  , Type.namedWith
                        []
                        "Maybe"
                        [ Type.namedWith [ "Elm" ] "Expression" [] ]
                  )
                , ( "depth", Type.int )
                , ( "version", Type.namedWith [ "Elm" ] "Expression" [] )
                ]
            )
    , unionCaseDetails =
        Type.alias
            moduleName_
            "UnionCaseDetails"
            []
            (Type.record
                [ ( "tag", Type.namedWith [] "Name" [] )
                , ( "globalTagName", Type.namedWith [] "Name" [] )
                , ( "globalDetailsAlias", Type.namedWith [] "Name" [] )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                , ( "selection", Type.list (Type.namedWith [] "Selection" []) )
                ]
            )
    , fieldEnumDetails =
        Type.alias
            moduleName_
            "FieldEnumDetails"
            []
            (Type.record
                [ ( "alias_"
                  , Type.namedWith [] "Maybe" [ Type.namedWith [] "Name" [] ]
                  )
                , ( "name", Type.namedWith [] "Name" [] )
                , ( "arguments", Type.list (Type.namedWith [] "Argument" []) )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                , ( "enumName", Type.string )
                , ( "values"
                  , Type.list
                        (Type.record
                            [ ( "name", Type.string )
                            , ( "description"
                              , Type.namedWith [] "Maybe" [ Type.string ]
                              )
                            ]
                        )
                  )
                , ( "wrapper"
                  , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                  )
                ]
            )
    , fieldScalarDetails =
        Type.alias
            moduleName_
            "FieldScalarDetails"
            []
            (Type.record
                [ ( "alias_"
                  , Type.namedWith [] "Maybe" [ Type.namedWith [] "Name" [] ]
                  )
                , ( "name", Type.namedWith [] "Name" [] )
                , ( "arguments", Type.list (Type.namedWith [] "Argument" []) )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                , ( "type_", Type.namedWith [ "GraphQL", "Schema" ] "Type" [] )
                ]
            )
    , interfaceCase =
        Type.alias
            moduleName_
            "InterfaceCase"
            []
            (Type.record
                [ ( "tag", Type.namedWith [] "Name" [] )
                , ( "globalTagName", Type.namedWith [] "Name" [] )
                , ( "globalDetailsAlias", Type.namedWith [] "Name" [] )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                , ( "selection", Type.list (Type.namedWith [] "Selection" []) )
                ]
            )
    , fieldInterfaceDetails =
        Type.alias
            moduleName_
            "FieldInterfaceDetails"
            []
            (Type.record
                [ ( "alias_"
                  , Type.namedWith [] "Maybe" [ Type.namedWith [] "Name" [] ]
                  )
                , ( "name", Type.namedWith [] "Name" [] )
                , ( "globalAlias", Type.namedWith [] "Name" [] )
                , ( "arguments", Type.list (Type.namedWith [] "Argument" []) )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                , ( "selection", Type.list (Type.namedWith [] "Selection" []) )
                , ( "variants"
                  , Type.list (Type.namedWith [] "InterfaceCase" [])
                  )
                , ( "remainingTags"
                  , Type.list
                        (Type.record
                            [ ( "tag", Type.namedWith [] "Name" [] )
                            , ( "globalAlias", Type.namedWith [] "Name" [] )
                            ]
                        )
                  )
                , ( "wrapper"
                  , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                  )
                ]
            )
    , fieldUnionDetails =
        Type.alias
            moduleName_
            "FieldUnionDetails"
            []
            (Type.record
                [ ( "alias_"
                  , Type.namedWith [] "Maybe" [ Type.namedWith [] "Name" [] ]
                  )
                , ( "name", Type.namedWith [] "Name" [] )
                , ( "globalAlias", Type.namedWith [] "Name" [] )
                , ( "arguments", Type.list (Type.namedWith [] "Argument" []) )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                , ( "selection", Type.list (Type.namedWith [] "Selection" []) )
                , ( "variants"
                  , Type.list (Type.namedWith [] "UnionCaseDetails" [])
                  )
                , ( "remainingTags"
                  , Type.list
                        (Type.record
                            [ ( "tag", Type.namedWith [] "Name" [] )
                            , ( "globalAlias", Type.namedWith [] "Name" [] )
                            ]
                        )
                  )
                , ( "wrapper"
                  , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                  )
                ]
            )
    , fieldObjectDetails =
        Type.alias
            moduleName_
            "FieldObjectDetails"
            []
            (Type.record
                [ ( "alias_"
                  , Type.namedWith [] "Maybe" [ Type.namedWith [] "Name" [] ]
                  )
                , ( "name", Type.namedWith [] "Name" [] )
                , ( "globalAlias", Type.namedWith [] "Name" [] )
                , ( "arguments", Type.list (Type.namedWith [] "Argument" []) )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                , ( "selection", Type.list (Type.namedWith [] "Selection" []) )
                , ( "wrapper"
                  , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                  )
                ]
            )
    , fragmentDetails =
        Type.alias
            moduleName_
            "FragmentDetails"
            []
            (Type.record
                [ ( "fragment", Type.namedWith [ "AST" ] "FragmentDetails" [] )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                ]
            )
    , variable =
        Type.alias
            moduleName_
            "Variable"
            []
            (Type.record [ ( "name", Type.namedWith [] "Name" [] ) ])
    , variableDefinition =
        Type.alias
            moduleName_
            "VariableDefinition"
            []
            (Type.record
                [ ( "variable", Type.namedWith [] "Variable" [] )
                , ( "type_", Type.namedWith [ "AST" ] "Type" [] )
                , ( "defaultValue"
                  , Type.namedWith
                        []
                        "Maybe"
                        [ Type.namedWith [ "AST" ] "Value" [] ]
                  )
                , ( "schemaType"
                  , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                  )
                ]
            )
    , argument =
        Type.alias
            moduleName_
            "Argument"
            []
            (Type.namedWith [ "AST" ] "Argument" [])
    , directive =
        Type.alias
            moduleName_
            "Directive"
            []
            (Type.record
                [ ( "name", Type.namedWith [] "Name" [] )
                , ( "arguments", Type.list (Type.namedWith [] "Argument" []) )
                ]
            )
    , operationDetails =
        Type.alias
            moduleName_
            "OperationDetails"
            []
            (Type.record
                [ ( "operationType", Type.namedWith [] "OperationType" [] )
                , ( "name"
                  , Type.namedWith [] "Maybe" [ Type.namedWith [] "Name" [] ]
                  )
                , ( "variableDefinitions"
                  , Type.list (Type.namedWith [] "VariableDefinition" [])
                  )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                , ( "fields", Type.list (Type.namedWith [] "Selection" []) )
                ]
            )
    , document =
        Type.alias
            moduleName_
            "Document"
            []
            (Type.record
                [ ( "definitions"
                  , Type.list (Type.namedWith [] "Definition" [])
                  )
                , ( "fragments"
                  , Type.list (Type.namedWith [ "AST" ] "FragmentDetails" [])
                  )
                ]
            )
    , wrapper =
        Type.namedWith [ "GraphQL", "Operations", "CanonicalAST" ] "Wrapper" []
    , name =
        Type.namedWith [ "GraphQL", "Operations", "CanonicalAST" ] "Name" []
    , selection =
        Type.namedWith
            [ "GraphQL", "Operations", "CanonicalAST" ]
            "Selection"
            []
    , operationType =
        Type.namedWith
            [ "GraphQL", "Operations", "CanonicalAST" ]
            "OperationType"
            []
    , definition =
        Type.namedWith
            [ "GraphQL", "Operations", "CanonicalAST" ]
            "Definition"
            []
    }


make_ :
    { renderingCursor :
        { string : Elm.Expression
        , exp : Elm.Expression
        , depth : Elm.Expression
        , version : Elm.Expression
        }
        -> Elm.Expression
    , unionCaseDetails :
        { tag : Elm.Expression
        , globalTagName : Elm.Expression
        , globalDetailsAlias : Elm.Expression
        , directives : Elm.Expression
        , selection : Elm.Expression
        }
        -> Elm.Expression
    , fieldEnumDetails :
        { alias_ : Elm.Expression
        , name : Elm.Expression
        , arguments : Elm.Expression
        , directives : Elm.Expression
        , enumName : Elm.Expression
        , values : Elm.Expression
        , wrapper : Elm.Expression
        }
        -> Elm.Expression
    , fieldScalarDetails :
        { alias_ : Elm.Expression
        , name : Elm.Expression
        , arguments : Elm.Expression
        , directives : Elm.Expression
        , type_ : Elm.Expression
        }
        -> Elm.Expression
    , interfaceCase :
        { tag : Elm.Expression
        , globalTagName : Elm.Expression
        , globalDetailsAlias : Elm.Expression
        , directives : Elm.Expression
        , selection : Elm.Expression
        }
        -> Elm.Expression
    , fieldInterfaceDetails :
        { alias_ : Elm.Expression
        , name : Elm.Expression
        , globalAlias : Elm.Expression
        , arguments : Elm.Expression
        , directives : Elm.Expression
        , selection : Elm.Expression
        , variants : Elm.Expression
        , remainingTags : Elm.Expression
        , wrapper : Elm.Expression
        }
        -> Elm.Expression
    , fieldUnionDetails :
        { alias_ : Elm.Expression
        , name : Elm.Expression
        , globalAlias : Elm.Expression
        , arguments : Elm.Expression
        , directives : Elm.Expression
        , selection : Elm.Expression
        , variants : Elm.Expression
        , remainingTags : Elm.Expression
        , wrapper : Elm.Expression
        }
        -> Elm.Expression
    , fieldObjectDetails :
        { alias_ : Elm.Expression
        , name : Elm.Expression
        , globalAlias : Elm.Expression
        , arguments : Elm.Expression
        , directives : Elm.Expression
        , selection : Elm.Expression
        , wrapper : Elm.Expression
        }
        -> Elm.Expression
    , fragmentDetails :
        { fragment : Elm.Expression, directives : Elm.Expression }
        -> Elm.Expression
    , variable : { name : Elm.Expression } -> Elm.Expression
    , variableDefinition :
        { variable : Elm.Expression
        , type_ : Elm.Expression
        , defaultValue : Elm.Expression
        , schemaType : Elm.Expression
        }
        -> Elm.Expression
    , directive :
        { name : Elm.Expression, arguments : Elm.Expression } -> Elm.Expression
    , operationDetails :
        { operationType : Elm.Expression
        , name : Elm.Expression
        , variableDefinitions : Elm.Expression
        , directives : Elm.Expression
        , fields : Elm.Expression
        }
        -> Elm.Expression
    , document :
        { definitions : Elm.Expression, fragments : Elm.Expression }
        -> Elm.Expression
    , inList : Elm.Expression -> Elm.Expression -> Elm.Expression
    , val : Elm.Expression -> Elm.Expression
    , name : Elm.Expression -> Elm.Expression
    , fieldObject : Elm.Expression -> Elm.Expression
    , fieldUnion : Elm.Expression -> Elm.Expression
    , fieldScalar : Elm.Expression -> Elm.Expression
    , fieldEnum : Elm.Expression -> Elm.Expression
    , fieldInterface : Elm.Expression -> Elm.Expression
    , fieldFragment : Elm.Expression -> Elm.Expression
    , query : Elm.Expression
    , mutation : Elm.Expression
    , operation : Elm.Expression -> Elm.Expression
    }
make_ =
    { renderingCursor =
        \renderingCursor_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "RenderingCursor"
                    []
                    (Type.record
                        [ ( "string", Type.string )
                        , ( "exp"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [ "Elm" ] "Expression" [] ]
                          )
                        , ( "depth", Type.int )
                        , ( "version"
                          , Type.namedWith [ "Elm" ] "Expression" []
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "string" renderingCursor_args.string
                    , Tuple.pair "exp" renderingCursor_args.exp
                    , Tuple.pair "depth" renderingCursor_args.depth
                    , Tuple.pair "version" renderingCursor_args.version
                    ]
                )
    , unionCaseDetails =
        \unionCaseDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "UnionCaseDetails"
                    []
                    (Type.record
                        [ ( "tag", Type.namedWith [] "Name" [] )
                        , ( "globalTagName", Type.namedWith [] "Name" [] )
                        , ( "globalDetailsAlias", Type.namedWith [] "Name" [] )
                        , ( "directives"
                          , Type.list (Type.namedWith [] "Directive" [])
                          )
                        , ( "selection"
                          , Type.list (Type.namedWith [] "Selection" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "tag" unionCaseDetails_args.tag
                    , Tuple.pair
                        "globalTagName"
                        unionCaseDetails_args.globalTagName
                    , Tuple.pair
                        "globalDetailsAlias"
                        unionCaseDetails_args.globalDetailsAlias
                    , Tuple.pair "directives" unionCaseDetails_args.directives
                    , Tuple.pair "selection" unionCaseDetails_args.selection
                    ]
                )
    , fieldEnumDetails =
        \fieldEnumDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "FieldEnumDetails"
                    []
                    (Type.record
                        [ ( "alias_"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [] "Name" [] ]
                          )
                        , ( "name", Type.namedWith [] "Name" [] )
                        , ( "arguments"
                          , Type.list (Type.namedWith [] "Argument" [])
                          )
                        , ( "directives"
                          , Type.list (Type.namedWith [] "Directive" [])
                          )
                        , ( "enumName", Type.string )
                        , ( "values"
                          , Type.list
                                (Type.record
                                    [ ( "name", Type.string )
                                    , ( "description"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.string ]
                                      )
                                    ]
                                )
                          )
                        , ( "wrapper"
                          , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "alias_" fieldEnumDetails_args.alias_
                    , Tuple.pair "name" fieldEnumDetails_args.name
                    , Tuple.pair "arguments" fieldEnumDetails_args.arguments
                    , Tuple.pair "directives" fieldEnumDetails_args.directives
                    , Tuple.pair "enumName" fieldEnumDetails_args.enumName
                    , Tuple.pair "values" fieldEnumDetails_args.values
                    , Tuple.pair "wrapper" fieldEnumDetails_args.wrapper
                    ]
                )
    , fieldScalarDetails =
        \fieldScalarDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "FieldScalarDetails"
                    []
                    (Type.record
                        [ ( "alias_"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [] "Name" [] ]
                          )
                        , ( "name", Type.namedWith [] "Name" [] )
                        , ( "arguments"
                          , Type.list (Type.namedWith [] "Argument" [])
                          )
                        , ( "directives"
                          , Type.list (Type.namedWith [] "Directive" [])
                          )
                        , ( "type_"
                          , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "alias_" fieldScalarDetails_args.alias_
                    , Tuple.pair "name" fieldScalarDetails_args.name
                    , Tuple.pair "arguments" fieldScalarDetails_args.arguments
                    , Tuple.pair "directives" fieldScalarDetails_args.directives
                    , Tuple.pair "type_" fieldScalarDetails_args.type_
                    ]
                )
    , interfaceCase =
        \interfaceCase_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "InterfaceCase"
                    []
                    (Type.record
                        [ ( "tag", Type.namedWith [] "Name" [] )
                        , ( "globalTagName", Type.namedWith [] "Name" [] )
                        , ( "globalDetailsAlias", Type.namedWith [] "Name" [] )
                        , ( "directives"
                          , Type.list (Type.namedWith [] "Directive" [])
                          )
                        , ( "selection"
                          , Type.list (Type.namedWith [] "Selection" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "tag" interfaceCase_args.tag
                    , Tuple.pair
                        "globalTagName"
                        interfaceCase_args.globalTagName
                    , Tuple.pair
                        "globalDetailsAlias"
                        interfaceCase_args.globalDetailsAlias
                    , Tuple.pair "directives" interfaceCase_args.directives
                    , Tuple.pair "selection" interfaceCase_args.selection
                    ]
                )
    , fieldInterfaceDetails =
        \fieldInterfaceDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "FieldInterfaceDetails"
                    []
                    (Type.record
                        [ ( "alias_"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [] "Name" [] ]
                          )
                        , ( "name", Type.namedWith [] "Name" [] )
                        , ( "globalAlias", Type.namedWith [] "Name" [] )
                        , ( "arguments"
                          , Type.list (Type.namedWith [] "Argument" [])
                          )
                        , ( "directives"
                          , Type.list (Type.namedWith [] "Directive" [])
                          )
                        , ( "selection"
                          , Type.list (Type.namedWith [] "Selection" [])
                          )
                        , ( "variants"
                          , Type.list (Type.namedWith [] "InterfaceCase" [])
                          )
                        , ( "remainingTags"
                          , Type.list
                                (Type.record
                                    [ ( "tag", Type.namedWith [] "Name" [] )
                                    , ( "globalAlias"
                                      , Type.namedWith [] "Name" []
                                      )
                                    ]
                                )
                          )
                        , ( "wrapper"
                          , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "alias_" fieldInterfaceDetails_args.alias_
                    , Tuple.pair "name" fieldInterfaceDetails_args.name
                    , Tuple.pair
                        "globalAlias"
                        fieldInterfaceDetails_args.globalAlias
                    , Tuple.pair
                        "arguments"
                        fieldInterfaceDetails_args.arguments
                    , Tuple.pair
                        "directives"
                        fieldInterfaceDetails_args.directives
                    , Tuple.pair
                        "selection"
                        fieldInterfaceDetails_args.selection
                    , Tuple.pair "variants" fieldInterfaceDetails_args.variants
                    , Tuple.pair
                        "remainingTags"
                        fieldInterfaceDetails_args.remainingTags
                    , Tuple.pair "wrapper" fieldInterfaceDetails_args.wrapper
                    ]
                )
    , fieldUnionDetails =
        \fieldUnionDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "FieldUnionDetails"
                    []
                    (Type.record
                        [ ( "alias_"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [] "Name" [] ]
                          )
                        , ( "name", Type.namedWith [] "Name" [] )
                        , ( "globalAlias", Type.namedWith [] "Name" [] )
                        , ( "arguments"
                          , Type.list (Type.namedWith [] "Argument" [])
                          )
                        , ( "directives"
                          , Type.list (Type.namedWith [] "Directive" [])
                          )
                        , ( "selection"
                          , Type.list (Type.namedWith [] "Selection" [])
                          )
                        , ( "variants"
                          , Type.list (Type.namedWith [] "UnionCaseDetails" [])
                          )
                        , ( "remainingTags"
                          , Type.list
                                (Type.record
                                    [ ( "tag", Type.namedWith [] "Name" [] )
                                    , ( "globalAlias"
                                      , Type.namedWith [] "Name" []
                                      )
                                    ]
                                )
                          )
                        , ( "wrapper"
                          , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "alias_" fieldUnionDetails_args.alias_
                    , Tuple.pair "name" fieldUnionDetails_args.name
                    , Tuple.pair
                        "globalAlias"
                        fieldUnionDetails_args.globalAlias
                    , Tuple.pair "arguments" fieldUnionDetails_args.arguments
                    , Tuple.pair "directives" fieldUnionDetails_args.directives
                    , Tuple.pair "selection" fieldUnionDetails_args.selection
                    , Tuple.pair "variants" fieldUnionDetails_args.variants
                    , Tuple.pair
                        "remainingTags"
                        fieldUnionDetails_args.remainingTags
                    , Tuple.pair "wrapper" fieldUnionDetails_args.wrapper
                    ]
                )
    , fieldObjectDetails =
        \fieldObjectDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "FieldObjectDetails"
                    []
                    (Type.record
                        [ ( "alias_"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [] "Name" [] ]
                          )
                        , ( "name", Type.namedWith [] "Name" [] )
                        , ( "globalAlias", Type.namedWith [] "Name" [] )
                        , ( "arguments"
                          , Type.list (Type.namedWith [] "Argument" [])
                          )
                        , ( "directives"
                          , Type.list (Type.namedWith [] "Directive" [])
                          )
                        , ( "selection"
                          , Type.list (Type.namedWith [] "Selection" [])
                          )
                        , ( "wrapper"
                          , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "alias_" fieldObjectDetails_args.alias_
                    , Tuple.pair "name" fieldObjectDetails_args.name
                    , Tuple.pair
                        "globalAlias"
                        fieldObjectDetails_args.globalAlias
                    , Tuple.pair "arguments" fieldObjectDetails_args.arguments
                    , Tuple.pair "directives" fieldObjectDetails_args.directives
                    , Tuple.pair "selection" fieldObjectDetails_args.selection
                    , Tuple.pair "wrapper" fieldObjectDetails_args.wrapper
                    ]
                )
    , fragmentDetails =
        \fragmentDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "FragmentDetails"
                    []
                    (Type.record
                        [ ( "fragment"
                          , Type.namedWith [ "AST" ] "FragmentDetails" []
                          )
                        , ( "directives"
                          , Type.list (Type.namedWith [] "Directive" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "fragment" fragmentDetails_args.fragment
                    , Tuple.pair "directives" fragmentDetails_args.directives
                    ]
                )
    , variable =
        \variable_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "Variable"
                    []
                    (Type.record [ ( "name", Type.namedWith [] "Name" [] ) ])
                )
                (Elm.record [ Tuple.pair "name" variable_args.name ])
    , variableDefinition =
        \variableDefinition_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "VariableDefinition"
                    []
                    (Type.record
                        [ ( "variable", Type.namedWith [] "Variable" [] )
                        , ( "type_", Type.namedWith [ "AST" ] "Type" [] )
                        , ( "defaultValue"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [ "AST" ] "Value" [] ]
                          )
                        , ( "schemaType"
                          , Type.namedWith [ "GraphQL", "Schema" ] "Type" []
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "variable" variableDefinition_args.variable
                    , Tuple.pair "type_" variableDefinition_args.type_
                    , Tuple.pair
                        "defaultValue"
                        variableDefinition_args.defaultValue
                    , Tuple.pair "schemaType" variableDefinition_args.schemaType
                    ]
                )
    , directive =
        \directive_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "Directive"
                    []
                    (Type.record
                        [ ( "name", Type.namedWith [] "Name" [] )
                        , ( "arguments"
                          , Type.list (Type.namedWith [] "Argument" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" directive_args.name
                    , Tuple.pair "arguments" directive_args.arguments
                    ]
                )
    , operationDetails =
        \operationDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "OperationDetails"
                    []
                    (Type.record
                        [ ( "operationType"
                          , Type.namedWith [] "OperationType" []
                          )
                        , ( "name"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [] "Name" [] ]
                          )
                        , ( "variableDefinitions"
                          , Type.list
                                (Type.namedWith [] "VariableDefinition" [])
                          )
                        , ( "directives"
                          , Type.list (Type.namedWith [] "Directive" [])
                          )
                        , ( "fields"
                          , Type.list (Type.namedWith [] "Selection" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair
                        "operationType"
                        operationDetails_args.operationType
                    , Tuple.pair "name" operationDetails_args.name
                    , Tuple.pair
                        "variableDefinitions"
                        operationDetails_args.variableDefinitions
                    , Tuple.pair "directives" operationDetails_args.directives
                    , Tuple.pair "fields" operationDetails_args.fields
                    ]
                )
    , document =
        \document_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "Document"
                    []
                    (Type.record
                        [ ( "definitions"
                          , Type.list (Type.namedWith [] "Definition" [])
                          )
                        , ( "fragments"
                          , Type.list
                                (Type.namedWith [ "AST" ] "FragmentDetails" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "definitions" document_args.definitions
                    , Tuple.pair "fragments" document_args.fragments
                    ]
                )
    , inList =
        \ar0 ar1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "InList"
                    , annotation = Just (Type.namedWith [] "Wrapper" [])
                    }
                )
                [ ar0, ar1 ]
    , val =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "Val"
                    , annotation = Just (Type.namedWith [] "Wrapper" [])
                    }
                )
                [ ar0 ]
    , name =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "Name"
                    , annotation = Just (Type.namedWith [] "Name" [])
                    }
                )
                [ ar0 ]
    , fieldObject =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "FieldObject"
                    , annotation = Just (Type.namedWith [] "Selection" [])
                    }
                )
                [ ar0 ]
    , fieldUnion =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "FieldUnion"
                    , annotation = Just (Type.namedWith [] "Selection" [])
                    }
                )
                [ ar0 ]
    , fieldScalar =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "FieldScalar"
                    , annotation = Just (Type.namedWith [] "Selection" [])
                    }
                )
                [ ar0 ]
    , fieldEnum =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "FieldEnum"
                    , annotation = Just (Type.namedWith [] "Selection" [])
                    }
                )
                [ ar0 ]
    , fieldInterface =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "FieldInterface"
                    , annotation = Just (Type.namedWith [] "Selection" [])
                    }
                )
                [ ar0 ]
    , fieldFragment =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "FieldFragment"
                    , annotation = Just (Type.namedWith [] "Selection" [])
                    }
                )
                [ ar0 ]
    , query =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "Query"
            , annotation = Just (Type.namedWith [] "OperationType" [])
            }
    , mutation =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "Mutation"
            , annotation = Just (Type.namedWith [] "OperationType" [])
            }
    , operation =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "Operation"
                    , annotation = Just (Type.namedWith [] "Definition" [])
                    }
                )
                [ ar0 ]
    }


caseOf_ :
    { wrapper :
        Elm.Expression
        -> { wrapperTags_0_0
            | inList : Elm.Expression -> Elm.Expression -> Elm.Expression
            , val : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , name :
        Elm.Expression
        -> { nameTags_1_0 | name : Elm.Expression -> Elm.Expression }
        -> Elm.Expression
    , selection :
        Elm.Expression
        -> { selectionTags_2_0
            | fieldObject : Elm.Expression -> Elm.Expression
            , fieldUnion : Elm.Expression -> Elm.Expression
            , fieldScalar : Elm.Expression -> Elm.Expression
            , fieldEnum : Elm.Expression -> Elm.Expression
            , fieldInterface : Elm.Expression -> Elm.Expression
            , fieldFragment : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , operationType :
        Elm.Expression
        -> { operationTypeTags_3_0
            | query : Elm.Expression
            , mutation : Elm.Expression
        }
        -> Elm.Expression
    , definition :
        Elm.Expression
        -> { definitionTags_4_0 | operation : Elm.Expression -> Elm.Expression }
        -> Elm.Expression
    }
caseOf_ =
    { wrapper =
        \wrapperExpression wrapperTags ->
            Elm.Case.custom
                wrapperExpression
                (Type.namedWith
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "Wrapper"
                    []
                )
                [ Elm.Case.branch2
                    "InList"
                    ( "one", Type.record [ ( "required", Type.bool ) ] )
                    ( "wrapper", Type.namedWith [] "Wrapper" [] )
                    wrapperTags.inList
                , Elm.Case.branch1
                    "Val"
                    ( "one", Type.record [ ( "required", Type.bool ) ] )
                    wrapperTags.val
                ]
    , name =
        \nameExpression nameTags ->
            Elm.Case.custom
                nameExpression
                (Type.namedWith
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "Name"
                    []
                )
                [ Elm.Case.branch1
                    "Name"
                    ( "string.String", Type.string )
                    nameTags.name
                ]
    , selection =
        \selectionExpression selectionTags ->
            Elm.Case.custom
                selectionExpression
                (Type.namedWith
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "Selection"
                    []
                )
                [ Elm.Case.branch1
                    "FieldObject"
                    ( "fieldObjectDetails"
                    , Type.namedWith [] "FieldObjectDetails" []
                    )
                    selectionTags.fieldObject
                , Elm.Case.branch1
                    "FieldUnion"
                    ( "fieldUnionDetails"
                    , Type.namedWith [] "FieldUnionDetails" []
                    )
                    selectionTags.fieldUnion
                , Elm.Case.branch1
                    "FieldScalar"
                    ( "fieldScalarDetails"
                    , Type.namedWith [] "FieldScalarDetails" []
                    )
                    selectionTags.fieldScalar
                , Elm.Case.branch1
                    "FieldEnum"
                    ( "fieldEnumDetails"
                    , Type.namedWith [] "FieldEnumDetails" []
                    )
                    selectionTags.fieldEnum
                , Elm.Case.branch1
                    "FieldInterface"
                    ( "fieldInterfaceDetails"
                    , Type.namedWith [] "FieldInterfaceDetails" []
                    )
                    selectionTags.fieldInterface
                , Elm.Case.branch1
                    "FieldFragment"
                    ( "fragmentDetails"
                    , Type.namedWith [] "FragmentDetails" []
                    )
                    selectionTags.fieldFragment
                ]
    , operationType =
        \operationTypeExpression operationTypeTags ->
            Elm.Case.custom
                operationTypeExpression
                (Type.namedWith
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "OperationType"
                    []
                )
                [ Elm.Case.branch0 "Query" operationTypeTags.query
                , Elm.Case.branch0 "Mutation" operationTypeTags.mutation
                ]
    , definition =
        \definitionExpression definitionTags ->
            Elm.Case.custom
                definitionExpression
                (Type.namedWith
                    [ "GraphQL", "Operations", "CanonicalAST" ]
                    "Definition"
                    []
                )
                [ Elm.Case.branch1
                    "Operation"
                    ( "operationDetails"
                    , Type.namedWith [] "OperationDetails" []
                    )
                    definitionTags.operation
                ]
    }


call_ :
    { renderVariantFragmentToExp :
        Elm.Expression -> Elm.Expression -> Elm.Expression
    , renderSelectionExp : Elm.Expression -> Elm.Expression -> Elm.Expression
    , addArgValue : Elm.Expression -> Elm.Expression -> Elm.Expression
    , renderArgumentsExp : Elm.Expression -> Elm.Expression -> Elm.Expression
    , aliasedNameExp : Elm.Expression -> Elm.Expression -> Elm.Expression
    , selectionToExpressionString :
        Elm.Expression -> Elm.Expression -> Elm.Expression
    , addExp : Elm.Expression -> Elm.Expression -> Elm.Expression
    , addString : Elm.Expression -> Elm.Expression -> Elm.Expression
    , commit : Elm.Expression -> Elm.Expression
    , removeLevelToCursor : Elm.Expression -> Elm.Expression
    , addLevelToCursor : Elm.Expression -> Elm.Expression
    , initCursor : Elm.Expression -> Elm.Expression
    , toRendererExpression : Elm.Expression -> Elm.Expression -> Elm.Expression
    , unwrap : Elm.Expression -> Elm.Expression -> Elm.Expression
    , typeToString : Elm.Expression -> Elm.Expression -> Elm.Expression
    , getWrapper : Elm.Expression -> Elm.Expression -> Elm.Expression
    , brackets : Elm.Expression -> Elm.Expression
    , operationName : Elm.Expression -> Elm.Expression
    , foldToString :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , aliasedName : Elm.Expression -> Elm.Expression
    , argValToString : Elm.Expression -> Elm.Expression
    , argToString : Elm.Expression -> Elm.Expression
    , renderArguments : Elm.Expression -> Elm.Expression
    , renderSelection : Elm.Expression -> Elm.Expression
    , variantFragmentToString : Elm.Expression -> Elm.Expression
    , selectionToString : Elm.Expression -> Elm.Expression
    , toStringFields : Elm.Expression -> Elm.Expression
    , operationLabel : Elm.Expression -> Elm.Expression
    , toString : Elm.Expression -> Elm.Expression
    , nameToString : Elm.Expression -> Elm.Expression
    , getAliasedFieldName : Elm.Expression -> Elm.Expression
    , getAliasedName : Elm.Expression -> Elm.Expression
    , isTypeNameSelection : Elm.Expression -> Elm.Expression
    }
call_ =
    { renderVariantFragmentToExp =
        \renderVariantFragmentToExpArg renderVariantFragmentToExpArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "renderVariantFragmentToExp"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "UnionCaseDetails" []
                                , Type.namedWith [] "RenderingCursor" []
                                ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ renderVariantFragmentToExpArg
                , renderVariantFragmentToExpArg0
                ]
    , renderSelectionExp =
        \renderSelectionExpArg renderSelectionExpArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "renderSelectionExp"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list (Type.namedWith [] "Selection" [])
                                , Type.namedWith [] "RenderingCursor" []
                                ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ renderSelectionExpArg, renderSelectionExpArg0 ]
    , addArgValue =
        \addArgValueArg addArgValueArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "addArgValue"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "AST" ] "Value" []
                                , Type.namedWith [] "RenderingCursor" []
                                ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ addArgValueArg, addArgValueArg0 ]
    , renderArgumentsExp =
        \renderArgumentsExpArg renderArgumentsExpArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "renderArgumentsExp"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list (Type.namedWith [] "Argument" [])
                                , Type.namedWith [] "RenderingCursor" []
                                ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ renderArgumentsExpArg, renderArgumentsExpArg0 ]
    , aliasedNameExp =
        \aliasedNameExpArg aliasedNameExpArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "aliasedNameExp"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.extensible
                                    "a"
                                    [ ( "alias_"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.namedWith [] "Name" [] ]
                                      )
                                    , ( "name", Type.namedWith [] "Name" [] )
                                    ]
                                , Type.namedWith [] "RenderingCursor" []
                                ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ aliasedNameExpArg, aliasedNameExpArg0 ]
    , selectionToExpressionString =
        \selectionToExpressionStringArg selectionToExpressionStringArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "selectionToExpressionString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Selection" []
                                , Type.namedWith [] "RenderingCursor" []
                                ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ selectionToExpressionStringArg
                , selectionToExpressionStringArg0
                ]
    , addExp =
        \addExpArg addExpArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "addExp"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Elm" ] "Expression" []
                                , Type.namedWith [] "RenderingCursor" []
                                ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ addExpArg, addExpArg0 ]
    , addString =
        \addStringArg addStringArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "addString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "RenderingCursor" []
                                ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ addStringArg, addStringArg0 ]
    , commit =
        \commitArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "commit"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "RenderingCursor" [] ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ commitArg ]
    , removeLevelToCursor =
        \removeLevelToCursorArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "removeLevelToCursor"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "RenderingCursor" [] ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ removeLevelToCursorArg ]
    , addLevelToCursor =
        \addLevelToCursorArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "addLevelToCursor"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "RenderingCursor" [] ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ addLevelToCursorArg ]
    , initCursor =
        \initCursorArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "initCursor"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Elm" ] "Expression" [] ]
                                (Type.namedWith [] "RenderingCursor" [])
                            )
                    }
                )
                [ initCursorArg ]
    , toRendererExpression =
        \toRendererExpressionArg toRendererExpressionArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "toRendererExpression"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Elm" ] "Expression" []
                                , Type.namedWith [] "Definition" []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ toRendererExpressionArg, toRendererExpressionArg0 ]
    , unwrap =
        \unwrapArg unwrapArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "unwrap"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Wrapper" [], Type.string ]
                                Type.string
                            )
                    }
                )
                [ unwrapArg, unwrapArg0 ]
    , typeToString =
        \typeToStringArg typeToStringArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "typeToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Wrapper" []
                                , Type.namedWith [ "AST" ] "Type" []
                                ]
                                Type.string
                            )
                    }
                )
                [ typeToStringArg, typeToStringArg0 ]
    , getWrapper =
        \getWrapperArg getWrapperArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "getWrapper"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "AST" ] "Type" []
                                , Type.namedWith [] "Wrapper" []
                                ]
                                (Type.namedWith [] "Wrapper" [])
                            )
                    }
                )
                [ getWrapperArg, getWrapperArg0 ]
    , brackets =
        \bracketsArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "brackets"
                    , annotation =
                        Just (Type.function [ Type.string ] Type.string)
                    }
                )
                [ bracketsArg ]
    , operationName =
        \operationNameArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "operationName"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "OperationType" [] ]
                                Type.string
                            )
                    }
                )
                [ operationNameArg ]
    , foldToString =
        \foldToStringArg foldToStringArg0 foldToStringArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "foldToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.function [ Type.var "a" ] Type.string
                                , Type.list (Type.var "a")
                                ]
                                Type.string
                            )
                    }
                )
                [ foldToStringArg, foldToStringArg0, foldToStringArg1 ]
    , aliasedName =
        \aliasedNameArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "aliasedName"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.extensible
                                    "a"
                                    [ ( "alias_"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.namedWith [] "Name" [] ]
                                      )
                                    , ( "name", Type.namedWith [] "Name" [] )
                                    ]
                                ]
                                Type.string
                            )
                    }
                )
                [ aliasedNameArg ]
    , argValToString =
        \argValToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "argValToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "AST" ] "Value" [] ]
                                Type.string
                            )
                    }
                )
                [ argValToStringArg ]
    , argToString =
        \argToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "argToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Argument" [] ]
                                Type.string
                            )
                    }
                )
                [ argToStringArg ]
    , renderArguments =
        \renderArgumentsArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "renderArguments"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list (Type.namedWith [] "Argument" []) ]
                                Type.string
                            )
                    }
                )
                [ renderArgumentsArg ]
    , renderSelection =
        \renderSelectionArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "renderSelection"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list (Type.namedWith [] "Selection" []) ]
                                Type.string
                            )
                    }
                )
                [ renderSelectionArg ]
    , variantFragmentToString =
        \variantFragmentToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "variantFragmentToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "UnionCaseDetails" [] ]
                                Type.string
                            )
                    }
                )
                [ variantFragmentToStringArg ]
    , selectionToString =
        \selectionToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "selectionToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Selection" [] ]
                                Type.string
                            )
                    }
                )
                [ selectionToStringArg ]
    , toStringFields =
        \toStringFieldsArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "toStringFields"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Definition" [] ]
                                Type.string
                            )
                    }
                )
                [ toStringFieldsArg ]
    , operationLabel =
        \operationLabelArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "operationLabel"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Definition" [] ]
                                (Type.namedWith [] "Maybe" [ Type.string ])
                            )
                    }
                )
                [ operationLabelArg ]
    , toString =
        \toStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "toString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Definition" [] ]
                                Type.string
                            )
                    }
                )
                [ toStringArg ]
    , nameToString =
        \nameToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "nameToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Name" [] ]
                                Type.string
                            )
                    }
                )
                [ nameToStringArg ]
    , getAliasedFieldName =
        \getAliasedFieldNameArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "getAliasedFieldName"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.extensible
                                    "field"
                                    [ ( "alias_"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.namedWith [] "Name" [] ]
                                      )
                                    , ( "name", Type.namedWith [] "Name" [] )
                                    ]
                                ]
                                Type.string
                            )
                    }
                )
                [ getAliasedFieldNameArg ]
    , getAliasedName =
        \getAliasedNameArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "getAliasedName"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.extensible
                                    "details"
                                    [ ( "name", Type.namedWith [] "Name" [] )
                                    , ( "alias_"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.namedWith [] "Name" [] ]
                                      )
                                    ]
                                ]
                                Type.string
                            )
                    }
                )
                [ getAliasedNameArg ]
    , isTypeNameSelection =
        \isTypeNameSelectionArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
                    , name = "isTypeNameSelection"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Selection" [] ]
                                Type.bool
                            )
                    }
                )
                [ isTypeNameSelectionArg ]
    }


values_ :
    { renderVariantFragmentToExp : Elm.Expression
    , renderSelectionExp : Elm.Expression
    , addArgValue : Elm.Expression
    , renderArgumentsExp : Elm.Expression
    , aliasedNameExp : Elm.Expression
    , selectionToExpressionString : Elm.Expression
    , addExp : Elm.Expression
    , addString : Elm.Expression
    , commit : Elm.Expression
    , removeLevelToCursor : Elm.Expression
    , addLevelToCursor : Elm.Expression
    , initCursor : Elm.Expression
    , toRendererExpression : Elm.Expression
    , unwrap : Elm.Expression
    , typeToString : Elm.Expression
    , getWrapper : Elm.Expression
    , brackets : Elm.Expression
    , operationName : Elm.Expression
    , foldToString : Elm.Expression
    , aliasedName : Elm.Expression
    , argValToString : Elm.Expression
    , argToString : Elm.Expression
    , renderArguments : Elm.Expression
    , renderSelection : Elm.Expression
    , variantFragmentToString : Elm.Expression
    , selectionToString : Elm.Expression
    , toStringFields : Elm.Expression
    , operationLabel : Elm.Expression
    , toString : Elm.Expression
    , nameToString : Elm.Expression
    , getAliasedFieldName : Elm.Expression
    , getAliasedName : Elm.Expression
    , isTypeNameSelection : Elm.Expression
    }
values_ =
    { renderVariantFragmentToExp =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "renderVariantFragmentToExp"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "UnionCaseDetails" []
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , renderSelectionExp =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "renderSelectionExp"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [] "Selection" [])
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , addArgValue =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "addArgValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "AST" ] "Value" []
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , renderArgumentsExp =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "renderArgumentsExp"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [] "Argument" [])
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , aliasedNameExp =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "aliasedNameExp"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "a"
                            [ ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [] "Name" [] ]
                              )
                            , ( "name", Type.namedWith [] "Name" [] )
                            ]
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , selectionToExpressionString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "selectionToExpressionString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Selection" []
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , addExp =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "addExp"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Elm" ] "Expression" []
                        , Type.namedWith [] "RenderingCursor" []
                        ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , addString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "addString"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "RenderingCursor" [] ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , commit =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "commit"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "RenderingCursor" [] ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , removeLevelToCursor =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "removeLevelToCursor"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "RenderingCursor" [] ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , addLevelToCursor =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "addLevelToCursor"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "RenderingCursor" [] ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , initCursor =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "initCursor"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Elm" ] "Expression" [] ]
                        (Type.namedWith [] "RenderingCursor" [])
                    )
            }
    , toRendererExpression =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "toRendererExpression"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Elm" ] "Expression" []
                        , Type.namedWith [] "Definition" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    , unwrap =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "unwrap"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapper" [], Type.string ]
                        Type.string
                    )
            }
    , typeToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "typeToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Wrapper" []
                        , Type.namedWith [ "AST" ] "Type" []
                        ]
                        Type.string
                    )
            }
    , getWrapper =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "getWrapper"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "AST" ] "Type" []
                        , Type.namedWith [] "Wrapper" []
                        ]
                        (Type.namedWith [] "Wrapper" [])
                    )
            }
    , brackets =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "brackets"
            , annotation = Just (Type.function [ Type.string ] Type.string)
            }
    , operationName =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "operationName"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "OperationType" [] ]
                        Type.string
                    )
            }
    , foldToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "foldToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.function [ Type.var "a" ] Type.string
                        , Type.list (Type.var "a")
                        ]
                        Type.string
                    )
            }
    , aliasedName =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "aliasedName"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "a"
                            [ ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [] "Name" [] ]
                              )
                            , ( "name", Type.namedWith [] "Name" [] )
                            ]
                        ]
                        Type.string
                    )
            }
    , argValToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "argValToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "AST" ] "Value" [] ]
                        Type.string
                    )
            }
    , argToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "argToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Argument" [] ]
                        Type.string
                    )
            }
    , renderArguments =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "renderArguments"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [] "Argument" []) ]
                        Type.string
                    )
            }
    , renderSelection =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "renderSelection"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [] "Selection" []) ]
                        Type.string
                    )
            }
    , variantFragmentToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "variantFragmentToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "UnionCaseDetails" [] ]
                        Type.string
                    )
            }
    , selectionToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "selectionToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Selection" [] ]
                        Type.string
                    )
            }
    , toStringFields =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "toStringFields"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Definition" [] ]
                        Type.string
                    )
            }
    , operationLabel =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "operationLabel"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Definition" [] ]
                        (Type.namedWith [] "Maybe" [ Type.string ])
                    )
            }
    , toString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "toString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Definition" [] ]
                        Type.string
                    )
            }
    , nameToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "nameToString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Name" [] ] Type.string)
            }
    , getAliasedFieldName =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "getAliasedFieldName"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "field"
                            [ ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [] "Name" [] ]
                              )
                            , ( "name", Type.namedWith [] "Name" [] )
                            ]
                        ]
                        Type.string
                    )
            }
    , getAliasedName =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "getAliasedName"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "details"
                            [ ( "name", Type.namedWith [] "Name" [] )
                            , ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [] "Name" [] ]
                              )
                            ]
                        ]
                        Type.string
                    )
            }
    , isTypeNameSelection =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "CanonicalAST" ]
            , name = "isTypeNameSelection"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Selection" [] ]
                        Type.bool
                    )
            }
    }



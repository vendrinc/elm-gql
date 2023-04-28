module Gen.GraphQL.Operations.AST exposing (annotation_, call_, caseOf_, fragmentCount, getAliasedName, make_, moduleName_, nameToString, typeToGqlString, valueToString, values_)

{-| 
@docs values_, call_, caseOf_, make_, annotation_, getAliasedName, nameToString, valueToString, typeToGqlString, fragmentCount, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "AST" ]


{-| {-| Bfore canonicalizing fragments, we need to order them so that fragments with no fragments start first
-}

fragmentCount: FragmentDetails -> Int
-}
fragmentCount : Elm.Expression -> Elm.Expression
fragmentCount fragmentCountArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "fragmentCount"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "FragmentDetails" [] ]
                        Type.int
                    )
            }
        )
        [ fragmentCountArg ]


{-| typeToGqlString: Type -> String -}
typeToGqlString : Elm.Expression -> Elm.Expression
typeToGqlString typeToGqlStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "typeToGqlString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Type" [] ] Type.string)
            }
        )
        [ typeToGqlStringArg ]


{-| valueToString: Value -> String -}
valueToString : Elm.Expression -> Elm.Expression
valueToString valueToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "valueToString"
            , annotation =
                Just
                    (Type.function [ Type.namedWith [] "Value" [] ] Type.string)
            }
        )
        [ valueToStringArg ]


{-| nameToString: Name -> String -}
nameToString : Elm.Expression -> Elm.Expression
nameToString nameToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "nameToString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Name" [] ] Type.string)
            }
        )
        [ nameToStringArg ]


{-| getAliasedName: FieldDetails -> String -}
getAliasedName : Elm.Expression -> Elm.Expression
getAliasedName getAliasedNameArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "getAliasedName"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "FieldDetails" [] ]
                        Type.string
                    )
            }
        )
        [ getAliasedNameArg ]


annotation_ :
    { directive : Type.Annotation
    , argument : Type.Annotation
    , inlineFragment : Type.Annotation
    , fragmentSpread : Type.Annotation
    , fieldDetails : Type.Annotation
    , variable : Type.Annotation
    , variableDefinition : Type.Annotation
    , operationDetails : Type.Annotation
    , fragmentDetails : Type.Annotation
    , document : Type.Annotation
    , wrapper : Type.Annotation
    , type_ : Type.Annotation
    , value : Type.Annotation
    , name : Type.Annotation
    , selection : Type.Annotation
    , operationType : Type.Annotation
    , definition : Type.Annotation
    }
annotation_ =
    { directive =
        Type.alias
            moduleName_
            "Directive"
            []
            (Type.record
                [ ( "name", Type.namedWith [] "Name" [] )
                , ( "arguments", Type.list (Type.namedWith [] "Argument" []) )
                ]
            )
    , argument =
        Type.alias
            moduleName_
            "Argument"
            []
            (Type.record
                [ ( "name", Type.namedWith [] "Name" [] )
                , ( "value", Type.namedWith [] "Value" [] )
                ]
            )
    , inlineFragment =
        Type.alias
            moduleName_
            "InlineFragment"
            []
            (Type.record
                [ ( "tag", Type.namedWith [] "Name" [] )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                , ( "selection", Type.list (Type.namedWith [] "Selection" []) )
                ]
            )
    , fragmentSpread =
        Type.alias
            moduleName_
            "FragmentSpread"
            []
            (Type.record
                [ ( "name", Type.namedWith [] "Name" [] )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                ]
            )
    , fieldDetails =
        Type.alias
            moduleName_
            "FieldDetails"
            []
            (Type.record
                [ ( "alias_"
                  , Type.namedWith [] "Maybe" [ Type.namedWith [] "Name" [] ]
                  )
                , ( "name", Type.namedWith [] "Name" [] )
                , ( "arguments", Type.list (Type.namedWith [] "Argument" []) )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                , ( "selection", Type.list (Type.namedWith [] "Selection" []) )
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
                , ( "type_", Type.namedWith [] "Type" [] )
                , ( "defaultValue"
                  , Type.namedWith [] "Maybe" [ Type.namedWith [] "Value" [] ]
                  )
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
    , fragmentDetails =
        Type.alias
            moduleName_
            "FragmentDetails"
            []
            (Type.record
                [ ( "name", Type.namedWith [] "Name" [] )
                , ( "typeCondition", Type.namedWith [] "Name" [] )
                , ( "directives", Type.list (Type.namedWith [] "Directive" []) )
                , ( "selection", Type.list (Type.namedWith [] "Selection" []) )
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
                ]
            )
    , wrapper = Type.namedWith [ "GraphQL", "Operations", "AST" ] "Wrapper" []
    , type_ = Type.namedWith [ "GraphQL", "Operations", "AST" ] "Type" []
    , value = Type.namedWith [ "GraphQL", "Operations", "AST" ] "Value" []
    , name = Type.namedWith [ "GraphQL", "Operations", "AST" ] "Name" []
    , selection =
        Type.namedWith [ "GraphQL", "Operations", "AST" ] "Selection" []
    , operationType =
        Type.namedWith [ "GraphQL", "Operations", "AST" ] "OperationType" []
    , definition =
        Type.namedWith [ "GraphQL", "Operations", "AST" ] "Definition" []
    }


make_ :
    { directive :
        { name : Elm.Expression, arguments : Elm.Expression } -> Elm.Expression
    , argument :
        { name : Elm.Expression, value : Elm.Expression } -> Elm.Expression
    , inlineFragment :
        { tag : Elm.Expression
        , directives : Elm.Expression
        , selection : Elm.Expression
        }
        -> Elm.Expression
    , fragmentSpread :
        { name : Elm.Expression, directives : Elm.Expression } -> Elm.Expression
    , fieldDetails :
        { alias_ : Elm.Expression
        , name : Elm.Expression
        , arguments : Elm.Expression
        , directives : Elm.Expression
        , selection : Elm.Expression
        }
        -> Elm.Expression
    , variable : { name : Elm.Expression } -> Elm.Expression
    , variableDefinition :
        { variable : Elm.Expression
        , type_ : Elm.Expression
        , defaultValue : Elm.Expression
        }
        -> Elm.Expression
    , operationDetails :
        { operationType : Elm.Expression
        , name : Elm.Expression
        , variableDefinitions : Elm.Expression
        , directives : Elm.Expression
        , fields : Elm.Expression
        }
        -> Elm.Expression
    , fragmentDetails :
        { name : Elm.Expression
        , typeCondition : Elm.Expression
        , directives : Elm.Expression
        , selection : Elm.Expression
        }
        -> Elm.Expression
    , document : { definitions : Elm.Expression } -> Elm.Expression
    , val : Elm.Expression -> Elm.Expression
    , type_ : Elm.Expression -> Elm.Expression
    , list_ : Elm.Expression -> Elm.Expression
    , nullable : Elm.Expression -> Elm.Expression
    , str : Elm.Expression -> Elm.Expression
    , integer : Elm.Expression -> Elm.Expression
    , decimal : Elm.Expression -> Elm.Expression
    , boolean : Elm.Expression -> Elm.Expression
    , null : Elm.Expression
    , enum : Elm.Expression -> Elm.Expression
    , var : Elm.Expression -> Elm.Expression
    , object : Elm.Expression -> Elm.Expression
    , listValue : Elm.Expression -> Elm.Expression
    , name : Elm.Expression -> Elm.Expression
    , field : Elm.Expression -> Elm.Expression
    , fragmentSpreadSelection : Elm.Expression -> Elm.Expression
    , inlineFragmentSelection : Elm.Expression -> Elm.Expression
    , query : Elm.Expression
    , mutation : Elm.Expression
    , fragment : Elm.Expression -> Elm.Expression
    , operation : Elm.Expression -> Elm.Expression
    }
make_ =
    { directive =
        \directive_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "AST" ]
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
    , argument =
        \argument_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "AST" ]
                    "Argument"
                    []
                    (Type.record
                        [ ( "name", Type.namedWith [] "Name" [] )
                        , ( "value", Type.namedWith [] "Value" [] )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" argument_args.name
                    , Tuple.pair "value" argument_args.value
                    ]
                )
    , inlineFragment =
        \inlineFragment_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "AST" ]
                    "InlineFragment"
                    []
                    (Type.record
                        [ ( "tag", Type.namedWith [] "Name" [] )
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
                    [ Tuple.pair "tag" inlineFragment_args.tag
                    , Tuple.pair "directives" inlineFragment_args.directives
                    , Tuple.pair "selection" inlineFragment_args.selection
                    ]
                )
    , fragmentSpread =
        \fragmentSpread_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "AST" ]
                    "FragmentSpread"
                    []
                    (Type.record
                        [ ( "name", Type.namedWith [] "Name" [] )
                        , ( "directives"
                          , Type.list (Type.namedWith [] "Directive" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" fragmentSpread_args.name
                    , Tuple.pair "directives" fragmentSpread_args.directives
                    ]
                )
    , fieldDetails =
        \fieldDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "AST" ]
                    "FieldDetails"
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
                        , ( "selection"
                          , Type.list (Type.namedWith [] "Selection" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "alias_" fieldDetails_args.alias_
                    , Tuple.pair "name" fieldDetails_args.name
                    , Tuple.pair "arguments" fieldDetails_args.arguments
                    , Tuple.pair "directives" fieldDetails_args.directives
                    , Tuple.pair "selection" fieldDetails_args.selection
                    ]
                )
    , variable =
        \variable_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "AST" ]
                    "Variable"
                    []
                    (Type.record [ ( "name", Type.namedWith [] "Name" [] ) ])
                )
                (Elm.record [ Tuple.pair "name" variable_args.name ])
    , variableDefinition =
        \variableDefinition_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "AST" ]
                    "VariableDefinition"
                    []
                    (Type.record
                        [ ( "variable", Type.namedWith [] "Variable" [] )
                        , ( "type_", Type.namedWith [] "Type" [] )
                        , ( "defaultValue"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [] "Value" [] ]
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
                    ]
                )
    , operationDetails =
        \operationDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "AST" ]
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
    , fragmentDetails =
        \fragmentDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "AST" ]
                    "FragmentDetails"
                    []
                    (Type.record
                        [ ( "name", Type.namedWith [] "Name" [] )
                        , ( "typeCondition", Type.namedWith [] "Name" [] )
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
                    [ Tuple.pair "name" fragmentDetails_args.name
                    , Tuple.pair
                        "typeCondition"
                        fragmentDetails_args.typeCondition
                    , Tuple.pair "directives" fragmentDetails_args.directives
                    , Tuple.pair "selection" fragmentDetails_args.selection
                    ]
                )
    , document =
        \document_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "AST" ]
                    "Document"
                    []
                    (Type.record
                        [ ( "definitions"
                          , Type.list (Type.namedWith [] "Definition" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "definitions" document_args.definitions ]
                )
    , val =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Val"
                    , annotation = Just (Type.namedWith [] "Wrapper" [])
                    }
                )
                [ ar0 ]
    , type_ =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Type_"
                    , annotation = Just (Type.namedWith [] "Type" [])
                    }
                )
                [ ar0 ]
    , list_ =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "List_"
                    , annotation = Just (Type.namedWith [] "Type" [])
                    }
                )
                [ ar0 ]
    , nullable =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Nullable"
                    , annotation = Just (Type.namedWith [] "Type" [])
                    }
                )
                [ ar0 ]
    , str =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Str"
                    , annotation = Just (Type.namedWith [] "Value" [])
                    }
                )
                [ ar0 ]
    , integer =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Integer"
                    , annotation = Just (Type.namedWith [] "Value" [])
                    }
                )
                [ ar0 ]
    , decimal =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Decimal"
                    , annotation = Just (Type.namedWith [] "Value" [])
                    }
                )
                [ ar0 ]
    , boolean =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Boolean"
                    , annotation = Just (Type.namedWith [] "Value" [])
                    }
                )
                [ ar0 ]
    , null =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "Null"
            , annotation = Just (Type.namedWith [] "Value" [])
            }
    , enum =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Enum"
                    , annotation = Just (Type.namedWith [] "Value" [])
                    }
                )
                [ ar0 ]
    , var =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Var"
                    , annotation = Just (Type.namedWith [] "Value" [])
                    }
                )
                [ ar0 ]
    , object =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Object"
                    , annotation = Just (Type.namedWith [] "Value" [])
                    }
                )
                [ ar0 ]
    , listValue =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "ListValue"
                    , annotation = Just (Type.namedWith [] "Value" [])
                    }
                )
                [ ar0 ]
    , name =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Name"
                    , annotation = Just (Type.namedWith [] "Name" [])
                    }
                )
                [ ar0 ]
    , field =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Field"
                    , annotation = Just (Type.namedWith [] "Selection" [])
                    }
                )
                [ ar0 ]
    , fragmentSpreadSelection =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "FragmentSpreadSelection"
                    , annotation = Just (Type.namedWith [] "Selection" [])
                    }
                )
                [ ar0 ]
    , inlineFragmentSelection =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "InlineFragmentSelection"
                    , annotation = Just (Type.namedWith [] "Selection" [])
                    }
                )
                [ ar0 ]
    , query =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "Query"
            , annotation = Just (Type.namedWith [] "OperationType" [])
            }
    , mutation =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "Mutation"
            , annotation = Just (Type.namedWith [] "OperationType" [])
            }
    , fragment =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Fragment"
                    , annotation = Just (Type.namedWith [] "Definition" [])
                    }
                )
                [ ar0 ]
    , operation =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "Operation"
                    , annotation = Just (Type.namedWith [] "Definition" [])
                    }
                )
                [ ar0 ]
    }


caseOf_ :
    { wrapper :
        Elm.Expression
        -> { wrapperTags_0_0 | val : Elm.Expression -> Elm.Expression }
        -> Elm.Expression
    , type_ :
        Elm.Expression
        -> { typeTags_1_0
            | type_ : Elm.Expression -> Elm.Expression
            , list_ : Elm.Expression -> Elm.Expression
            , nullable : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , value :
        Elm.Expression
        -> { valueTags_2_0
            | str : Elm.Expression -> Elm.Expression
            , integer : Elm.Expression -> Elm.Expression
            , decimal : Elm.Expression -> Elm.Expression
            , boolean : Elm.Expression -> Elm.Expression
            , null : Elm.Expression
            , enum : Elm.Expression -> Elm.Expression
            , var : Elm.Expression -> Elm.Expression
            , object : Elm.Expression -> Elm.Expression
            , listValue : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , name :
        Elm.Expression
        -> { nameTags_3_0 | name : Elm.Expression -> Elm.Expression }
        -> Elm.Expression
    , selection :
        Elm.Expression
        -> { selectionTags_4_0
            | field : Elm.Expression -> Elm.Expression
            , fragmentSpreadSelection : Elm.Expression -> Elm.Expression
            , inlineFragmentSelection : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , operationType :
        Elm.Expression
        -> { operationTypeTags_5_0
            | query : Elm.Expression
            , mutation : Elm.Expression
        }
        -> Elm.Expression
    , definition :
        Elm.Expression
        -> { definitionTags_6_0
            | fragment : Elm.Expression -> Elm.Expression
            , operation : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    }
caseOf_ =
    { wrapper =
        \wrapperExpression wrapperTags ->
            Elm.Case.custom
                wrapperExpression
                (Type.namedWith [ "GraphQL", "Operations", "AST" ] "Wrapper" [])
                [ Elm.Case.branch1
                    "Val"
                    ( "one", Type.record [ ( "required", Type.bool ) ] )
                    wrapperTags.val
                ]
    , type_ =
        \typeExpression typeTags ->
            Elm.Case.custom
                typeExpression
                (Type.namedWith [ "GraphQL", "Operations", "AST" ] "Type" [])
                [ Elm.Case.branch1
                    "Type_"
                    ( "name", Type.namedWith [] "Name" [] )
                    typeTags.type_
                , Elm.Case.branch1
                    "List_"
                    ( "type_", Type.namedWith [] "Type" [] )
                    typeTags.list_
                , Elm.Case.branch1
                    "Nullable"
                    ( "type_", Type.namedWith [] "Type" [] )
                    typeTags.nullable
                ]
    , value =
        \valueExpression valueTags ->
            Elm.Case.custom
                valueExpression
                (Type.namedWith [ "GraphQL", "Operations", "AST" ] "Value" [])
                [ Elm.Case.branch1
                    "Str"
                    ( "string.String", Type.string )
                    valueTags.str
                , Elm.Case.branch1
                    "Integer"
                    ( "basics.Int", Type.int )
                    valueTags.integer
                , Elm.Case.branch1
                    "Decimal"
                    ( "basics.Float", Type.float )
                    valueTags.decimal
                , Elm.Case.branch1
                    "Boolean"
                    ( "basics.Bool", Type.bool )
                    valueTags.boolean
                , Elm.Case.branch0 "Null" valueTags.null
                , Elm.Case.branch1
                    "Enum"
                    ( "name", Type.namedWith [] "Name" [] )
                    valueTags.enum
                , Elm.Case.branch1
                    "Var"
                    ( "variable", Type.namedWith [] "Variable" [] )
                    valueTags.var
                , Elm.Case.branch1
                    "Object"
                    ( "list.List"
                    , Type.list
                        (Type.tuple
                            (Type.namedWith [] "Name" [])
                            (Type.namedWith [] "Value" [])
                        )
                    )
                    valueTags.object
                , Elm.Case.branch1
                    "ListValue"
                    ( "list.List", Type.list (Type.namedWith [] "Value" []) )
                    valueTags.listValue
                ]
    , name =
        \nameExpression nameTags ->
            Elm.Case.custom
                nameExpression
                (Type.namedWith [ "GraphQL", "Operations", "AST" ] "Name" [])
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
                    [ "GraphQL", "Operations", "AST" ]
                    "Selection"
                    []
                )
                [ Elm.Case.branch1
                    "Field"
                    ( "fieldDetails", Type.namedWith [] "FieldDetails" [] )
                    selectionTags.field
                , Elm.Case.branch1
                    "FragmentSpreadSelection"
                    ( "fragmentSpread", Type.namedWith [] "FragmentSpread" [] )
                    selectionTags.fragmentSpreadSelection
                , Elm.Case.branch1
                    "InlineFragmentSelection"
                    ( "inlineFragment", Type.namedWith [] "InlineFragment" [] )
                    selectionTags.inlineFragmentSelection
                ]
    , operationType =
        \operationTypeExpression operationTypeTags ->
            Elm.Case.custom
                operationTypeExpression
                (Type.namedWith
                    [ "GraphQL", "Operations", "AST" ]
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
                    [ "GraphQL", "Operations", "AST" ]
                    "Definition"
                    []
                )
                [ Elm.Case.branch1
                    "Fragment"
                    ( "fragmentDetails"
                    , Type.namedWith [] "FragmentDetails" []
                    )
                    definitionTags.fragment
                , Elm.Case.branch1
                    "Operation"
                    ( "operationDetails"
                    , Type.namedWith [] "OperationDetails" []
                    )
                    definitionTags.operation
                ]
    }


call_ :
    { fragmentCount : Elm.Expression -> Elm.Expression
    , typeToGqlString : Elm.Expression -> Elm.Expression
    , valueToString : Elm.Expression -> Elm.Expression
    , nameToString : Elm.Expression -> Elm.Expression
    , getAliasedName : Elm.Expression -> Elm.Expression
    }
call_ =
    { fragmentCount =
        \fragmentCountArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "fragmentCount"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "FragmentDetails" [] ]
                                Type.int
                            )
                    }
                )
                [ fragmentCountArg ]
    , typeToGqlString =
        \typeToGqlStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "typeToGqlString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Type" [] ]
                                Type.string
                            )
                    }
                )
                [ typeToGqlStringArg ]
    , valueToString =
        \valueToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "valueToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Value" [] ]
                                Type.string
                            )
                    }
                )
                [ valueToStringArg ]
    , nameToString =
        \nameToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
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
    , getAliasedName =
        \getAliasedNameArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "AST" ]
                    , name = "getAliasedName"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "FieldDetails" [] ]
                                Type.string
                            )
                    }
                )
                [ getAliasedNameArg ]
    }


values_ :
    { fragmentCount : Elm.Expression
    , typeToGqlString : Elm.Expression
    , valueToString : Elm.Expression
    , nameToString : Elm.Expression
    , getAliasedName : Elm.Expression
    }
values_ =
    { fragmentCount =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "fragmentCount"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "FragmentDetails" [] ]
                        Type.int
                    )
            }
    , typeToGqlString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "typeToGqlString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Type" [] ] Type.string)
            }
    , valueToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "valueToString"
            , annotation =
                Just
                    (Type.function [ Type.namedWith [] "Value" [] ] Type.string)
            }
    , nameToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "nameToString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Name" [] ] Type.string)
            }
    , getAliasedName =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "AST" ]
            , name = "getAliasedName"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "FieldDetails" [] ]
                        Type.string
                    )
            }
    }



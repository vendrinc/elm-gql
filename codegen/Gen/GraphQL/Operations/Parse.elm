module Gen.GraphQL.Operations.Parse exposing (aliasedName, argument, arguments, argumentsOpt, boolValue, call_, chars, comment, deadEndToString, defaultValue, definition, directive, directives, directivesHelper, document, enumValue, errorToString, escapables, field_, fragment, ifProgress, ignoreChars, inlineOrSpread_, intOrFloat, keywords, kvp, kvp_, listType, listValue, moduleName_, multiOr, name, nameOpt, nullValue, objectValue, operation, operationType, parse, peek, problemToString, selectionSet, stringValue, type_, value, values_, variable, variableDefinition, variableDefinitions, ws)

{-| 
@docs values_, call_, multiOr, escapables, keywords, ignoreChars, chars, ws, name, variable, boolValue, intOrFloat, stringValue, enumValue, listValue, kvp_, objectValue, nullValue, value, kvp, selectionSet, comment, inlineOrSpread_, field_, aliasedName, argument, arguments, argumentsOpt, directive, directives, directivesHelper, fragment, nameOpt, operationType, defaultValue, listType, type_, variableDefinition, variableDefinitions, operation, definition, document, parse, ifProgress, errorToString, deadEndToString, problemToString, peek, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Parse" ]


{-| peek: (String -> String) -> Parser thing -> Parser thing -}
peek : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
peek peekArg peekArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "peek"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.string ] Type.string
                        , Type.namedWith [] "Parser" [ Type.var "thing" ]
                        ]
                        (Type.namedWith [] "Parser" [ Type.var "thing" ])
                    )
            }
        )
        [ Elm.functionReduced "peekUnpack" peekArg, peekArg0 ]


{-| problemToString: Parser.Problem -> String -}
problemToString : Elm.Expression -> Elm.Expression
problemToString problemToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "problemToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Parser" ] "Problem" [] ]
                        Type.string
                    )
            }
        )
        [ problemToStringArg ]


{-| deadEndToString: Parser.DeadEnd -> String -}
deadEndToString : Elm.Expression -> Elm.Expression
deadEndToString deadEndToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "deadEndToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Parser" ] "DeadEnd" [] ]
                        Type.string
                    )
            }
        )
        [ deadEndToStringArg ]


{-| errorToString: List Parser.DeadEnd -> String -}
errorToString : List Elm.Expression -> Elm.Expression
errorToString errorToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "errorToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [ "Parser" ] "DeadEnd" []) ]
                        Type.string
                    )
            }
        )
        [ Elm.list errorToStringArg ]


{-| ifProgress: (step -> done) -> Parser step -> Parser (Step step done) -}
ifProgress :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
ifProgress ifProgressArg ifProgressArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "ifProgress"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "step" ] (Type.var "done")
                        , Type.namedWith [] "Parser" [ Type.var "step" ]
                        ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.namedWith
                                []
                                "Step"
                                [ Type.var "step", Type.var "done" ]
                            ]
                        )
                    )
            }
        )
        [ Elm.functionReduced "ifProgressUnpack" ifProgressArg, ifProgressArg0 ]


{-| parse: String -> Result (List Parser.DeadEnd) AST.Document -}
parse : String -> Elm.Expression
parse parseArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "parse"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list
                                (Type.namedWith [ "Parser" ] "DeadEnd" [])
                            , Type.namedWith [ "AST" ] "Document" []
                            ]
                        )
                    )
            }
        )
        [ Elm.string parseArg ]


{-| document: Parser AST.Document -}
document : Elm.Expression
document =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "document"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Document" [] ]
                )
        }


{-| definition: Parser AST.Definition -}
definition : Elm.Expression
definition =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "definition"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Definition" [] ]
                )
        }


{-| operation: Parser AST.OperationDetails -}
operation : Elm.Expression
operation =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "operation"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "OperationDetails" [] ]
                )
        }


{-| variableDefinitions: Parser (List AST.VariableDefinition) -}
variableDefinitions : Elm.Expression
variableDefinitions =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "variableDefinitions"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.list
                        (Type.namedWith [ "AST" ] "VariableDefinition" [])
                    ]
                )
        }


{-| variableDefinition: Parser AST.VariableDefinition -}
variableDefinition : Elm.Expression
variableDefinition =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "variableDefinition"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "VariableDefinition" [] ]
                )
        }


{-| type_: Parser AST.Type -}
type_ : Elm.Expression
type_ =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "type_"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Type" [] ]
                )
        }


{-| listType: (() -> Parser AST.Type) -> Parser AST.Type -}
listType : (Elm.Expression -> Elm.Expression) -> Elm.Expression
listType listTypeArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "listType"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.unit ]
                            (Type.namedWith
                                []
                                "Parser"
                                [ Type.namedWith [ "AST" ] "Type" [] ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.namedWith [ "AST" ] "Type" [] ]
                        )
                    )
            }
        )
        [ Elm.functionReduced "listTypeUnpack" listTypeArg ]


{-| defaultValue: Parser (Maybe AST.Value) -}
defaultValue : Elm.Expression
defaultValue =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "defaultValue"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith
                        []
                        "Maybe"
                        [ Type.namedWith [ "AST" ] "Value" [] ]
                    ]
                )
        }


{-| operationType: Parser AST.OperationType -}
operationType : Elm.Expression
operationType =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "operationType"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "OperationType" [] ]
                )
        }


{-| nameOpt: Parser (Maybe AST.Name) -}
nameOpt : Elm.Expression
nameOpt =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "nameOpt"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith
                        []
                        "Maybe"
                        [ Type.namedWith [ "AST" ] "Name" [] ]
                    ]
                )
        }


{-| fragment: Parser AST.FragmentDetails -}
fragment : Elm.Expression
fragment =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "fragment"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "FragmentDetails" [] ]
                )
        }


{-| directivesHelper: 
    List AST.Directive
    -> Parser (Parser.Step (List AST.Directive) (List AST.Directive))
-}
directivesHelper : List Elm.Expression -> Elm.Expression
directivesHelper directivesHelperArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "directivesHelper"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [ "AST" ] "Directive" []) ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.namedWith
                                [ "Parser" ]
                                "Step"
                                [ Type.list
                                    (Type.namedWith [ "AST" ] "Directive" [])
                                , Type.list
                                    (Type.namedWith [ "AST" ] "Directive" [])
                                ]
                            ]
                        )
                    )
            }
        )
        [ Elm.list directivesHelperArg ]


{-| directives: Parser (List AST.Directive) -}
directives : Elm.Expression
directives =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "directives"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.list (Type.namedWith [ "AST" ] "Directive" []) ]
                )
        }


{-| directive: Parser AST.Directive -}
directive : Elm.Expression
directive =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "directive"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Directive" [] ]
                )
        }


{-| argumentsOpt: Parser (List AST.Argument) -}
argumentsOpt : Elm.Expression
argumentsOpt =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "argumentsOpt"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.list (Type.namedWith [ "AST" ] "Argument" []) ]
                )
        }


{-| arguments: Parser (List AST.Argument) -}
arguments : Elm.Expression
arguments =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "arguments"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.list (Type.namedWith [ "AST" ] "Argument" []) ]
                )
        }


{-| argument: Parser AST.Argument -}
argument : Elm.Expression
argument =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "argument"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Argument" [] ]
                )
        }


{-| aliasedName: Parser ( Maybe AST.Name, AST.Name ) -}
aliasedName : Elm.Expression
aliasedName =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "aliasedName"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.tuple
                        (Type.namedWith
                            []
                            "Maybe"
                            [ Type.namedWith [ "AST" ] "Name" [] ]
                        )
                        (Type.namedWith [ "AST" ] "Name" [])
                    ]
                )
        }


{-| field_: Parser AST.FieldDetails -}
field_ : Elm.Expression
field_ =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "field_"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "FieldDetails" [] ]
                )
        }


{-| inlineOrSpread_: Parser AST.Selection -}
inlineOrSpread_ : Elm.Expression
inlineOrSpread_ =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "inlineOrSpread_"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Selection" [] ]
                )
        }


{-| comment: Parser () -}
comment : Elm.Expression
comment =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "comment"
        , annotation = Just (Type.namedWith [] "Parser" [ Type.unit ])
        }


{-| selectionSet: Parser (List AST.Selection) -}
selectionSet : Elm.Expression
selectionSet =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "selectionSet"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.list (Type.namedWith [ "AST" ] "Selection" []) ]
                )
        }


{-| kvp: Parser ( AST.Name, AST.Value ) -}
kvp : Elm.Expression
kvp =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "kvp"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.tuple
                        (Type.namedWith [ "AST" ] "Name" [])
                        (Type.namedWith [ "AST" ] "Value" [])
                    ]
                )
        }


{-| value: Parser AST.Value -}
value : Elm.Expression
value =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "value"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Value" [] ]
                )
        }


{-| nullValue: Parser AST.Value -}
nullValue : Elm.Expression
nullValue =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "nullValue"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Value" [] ]
                )
        }


{-| objectValue: (() -> Parser AST.Value) -> Parser AST.Value -}
objectValue : (Elm.Expression -> Elm.Expression) -> Elm.Expression
objectValue objectValueArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "objectValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.unit ]
                            (Type.namedWith
                                []
                                "Parser"
                                [ Type.namedWith [ "AST" ] "Value" [] ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.namedWith [ "AST" ] "Value" [] ]
                        )
                    )
            }
        )
        [ Elm.functionReduced "objectValueUnpack" objectValueArg ]


{-| kvp_: (() -> Parser AST.Value) -> Parser ( AST.Name, AST.Value ) -}
kvp_ : (Elm.Expression -> Elm.Expression) -> Elm.Expression
kvp_ kvp_Arg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "kvp_"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.unit ]
                            (Type.namedWith
                                []
                                "Parser"
                                [ Type.namedWith [ "AST" ] "Value" [] ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.tuple
                                (Type.namedWith [ "AST" ] "Name" [])
                                (Type.namedWith [ "AST" ] "Value" [])
                            ]
                        )
                    )
            }
        )
        [ Elm.functionReduced "kvp_Unpack" kvp_Arg ]


{-| listValue: (() -> Parser AST.Value) -> Parser AST.Value -}
listValue : (Elm.Expression -> Elm.Expression) -> Elm.Expression
listValue listValueArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "listValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.unit ]
                            (Type.namedWith
                                []
                                "Parser"
                                [ Type.namedWith [ "AST" ] "Value" [] ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.namedWith [ "AST" ] "Value" [] ]
                        )
                    )
            }
        )
        [ Elm.functionReduced "listValueUnpack" listValueArg ]


{-| enumValue: Parser AST.Value -}
enumValue : Elm.Expression
enumValue =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "enumValue"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Value" [] ]
                )
        }


{-| stringValue: Parser AST.Value -}
stringValue : Elm.Expression
stringValue =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "stringValue"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Value" [] ]
                )
        }


{-| {-|

    Of note!

    The Elm Parser.int and Parser.float parsers are broken as they can accept values that start with 'e'

    : https://github.com/elm/parser/issues/25

-}

intOrFloat: Parser AST.Value
-}
intOrFloat : Elm.Expression
intOrFloat =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "intOrFloat"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Value" [] ]
                )
        }


{-| boolValue: Parser AST.Value -}
boolValue : Elm.Expression
boolValue =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "boolValue"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Value" [] ]
                )
        }


{-| variable: Parser AST.Variable -}
variable : Elm.Expression
variable =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "variable"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Variable" [] ]
                )
        }


{-| name: Parser AST.Name -}
name : Elm.Expression
name =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "name"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Parser"
                    [ Type.namedWith [ "AST" ] "Name" [] ]
                )
        }


{-| ws: Parser () -}
ws : Elm.Expression
ws =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "ws"
        , annotation = Just (Type.namedWith [] "Parser" [ Type.unit ])
        }


{-| chars: { cr : Char.Char } -}
chars : Elm.Expression
chars =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "chars"
        , annotation = Just (Type.record [ ( "cr", Type.char ) ])
        }


{-| ignoreChars: Set Char.Char -}
ignoreChars : Elm.Expression
ignoreChars =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "ignoreChars"
        , annotation = Just (Type.namedWith [] "Set" [ Type.char ])
        }


{-| keywords: Set String -}
keywords : Elm.Expression
keywords =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "keywords"
        , annotation = Just (Type.namedWith [] "Set" [ Type.string ])
        }


{-| escapables: Set Char.Char -}
escapables : Elm.Expression
escapables =
    Elm.value
        { importFrom = [ "GraphQL", "Operations", "Parse" ]
        , name = "escapables"
        , annotation = Just (Type.namedWith [] "Set" [ Type.char ])
        }


{-| multiOr: List (a -> Bool) -> a -> Bool -}
multiOr : List Elm.Expression -> Elm.Expression -> Elm.Expression
multiOr multiOrArg multiOrArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "multiOr"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.function [ Type.var "a" ] Type.bool)
                        , Type.var "a"
                        ]
                        Type.bool
                    )
            }
        )
        [ Elm.list multiOrArg, multiOrArg0 ]


call_ :
    { peek : Elm.Expression -> Elm.Expression -> Elm.Expression
    , problemToString : Elm.Expression -> Elm.Expression
    , deadEndToString : Elm.Expression -> Elm.Expression
    , errorToString : Elm.Expression -> Elm.Expression
    , ifProgress : Elm.Expression -> Elm.Expression -> Elm.Expression
    , parse : Elm.Expression -> Elm.Expression
    , listType : Elm.Expression -> Elm.Expression
    , directivesHelper : Elm.Expression -> Elm.Expression
    , objectValue : Elm.Expression -> Elm.Expression
    , kvp_ : Elm.Expression -> Elm.Expression
    , listValue : Elm.Expression -> Elm.Expression
    , multiOr : Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { peek =
        \peekArg peekArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "peek"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function [ Type.string ] Type.string
                                , Type.namedWith
                                    []
                                    "Parser"
                                    [ Type.var "thing" ]
                                ]
                                (Type.namedWith [] "Parser" [ Type.var "thing" ]
                                )
                            )
                    }
                )
                [ peekArg, peekArg0 ]
    , problemToString =
        \problemToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "problemToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Parser" ] "Problem" [] ]
                                Type.string
                            )
                    }
                )
                [ problemToStringArg ]
    , deadEndToString =
        \deadEndToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "deadEndToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Parser" ] "DeadEnd" [] ]
                                Type.string
                            )
                    }
                )
                [ deadEndToStringArg ]
    , errorToString =
        \errorToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "errorToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.namedWith [ "Parser" ] "DeadEnd" [])
                                ]
                                Type.string
                            )
                    }
                )
                [ errorToStringArg ]
    , ifProgress =
        \ifProgressArg ifProgressArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "ifProgress"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "step" ]
                                    (Type.var "done")
                                , Type.namedWith [] "Parser" [ Type.var "step" ]
                                ]
                                (Type.namedWith
                                    []
                                    "Parser"
                                    [ Type.namedWith
                                        []
                                        "Step"
                                        [ Type.var "step", Type.var "done" ]
                                    ]
                                )
                            )
                    }
                )
                [ ifProgressArg, ifProgressArg0 ]
    , parse =
        \parseArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "parse"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string ]
                                (Type.namedWith
                                    []
                                    "Result"
                                    [ Type.list
                                        (Type.namedWith
                                            [ "Parser" ]
                                            "DeadEnd"
                                            []
                                        )
                                    , Type.namedWith [ "AST" ] "Document" []
                                    ]
                                )
                            )
                    }
                )
                [ parseArg ]
    , listType =
        \listTypeArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "listType"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.unit ]
                                    (Type.namedWith
                                        []
                                        "Parser"
                                        [ Type.namedWith [ "AST" ] "Type" [] ]
                                    )
                                ]
                                (Type.namedWith
                                    []
                                    "Parser"
                                    [ Type.namedWith [ "AST" ] "Type" [] ]
                                )
                            )
                    }
                )
                [ listTypeArg ]
    , directivesHelper =
        \directivesHelperArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "directivesHelper"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.namedWith [ "AST" ] "Directive" [])
                                ]
                                (Type.namedWith
                                    []
                                    "Parser"
                                    [ Type.namedWith
                                        [ "Parser" ]
                                        "Step"
                                        [ Type.list
                                            (Type.namedWith
                                                [ "AST" ]
                                                "Directive"
                                                []
                                            )
                                        , Type.list
                                            (Type.namedWith
                                                [ "AST" ]
                                                "Directive"
                                                []
                                            )
                                        ]
                                    ]
                                )
                            )
                    }
                )
                [ directivesHelperArg ]
    , objectValue =
        \objectValueArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "objectValue"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.unit ]
                                    (Type.namedWith
                                        []
                                        "Parser"
                                        [ Type.namedWith [ "AST" ] "Value" [] ]
                                    )
                                ]
                                (Type.namedWith
                                    []
                                    "Parser"
                                    [ Type.namedWith [ "AST" ] "Value" [] ]
                                )
                            )
                    }
                )
                [ objectValueArg ]
    , kvp_ =
        \kvp_Arg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "kvp_"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.unit ]
                                    (Type.namedWith
                                        []
                                        "Parser"
                                        [ Type.namedWith [ "AST" ] "Value" [] ]
                                    )
                                ]
                                (Type.namedWith
                                    []
                                    "Parser"
                                    [ Type.tuple
                                        (Type.namedWith [ "AST" ] "Name" [])
                                        (Type.namedWith [ "AST" ] "Value" [])
                                    ]
                                )
                            )
                    }
                )
                [ kvp_Arg ]
    , listValue =
        \listValueArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "listValue"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.unit ]
                                    (Type.namedWith
                                        []
                                        "Parser"
                                        [ Type.namedWith [ "AST" ] "Value" [] ]
                                    )
                                ]
                                (Type.namedWith
                                    []
                                    "Parser"
                                    [ Type.namedWith [ "AST" ] "Value" [] ]
                                )
                            )
                    }
                )
                [ listValueArg ]
    , multiOr =
        \multiOrArg multiOrArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Parse" ]
                    , name = "multiOr"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.function [ Type.var "a" ] Type.bool)
                                , Type.var "a"
                                ]
                                Type.bool
                            )
                    }
                )
                [ multiOrArg, multiOrArg0 ]
    }


values_ :
    { peek : Elm.Expression
    , problemToString : Elm.Expression
    , deadEndToString : Elm.Expression
    , errorToString : Elm.Expression
    , ifProgress : Elm.Expression
    , parse : Elm.Expression
    , document : Elm.Expression
    , definition : Elm.Expression
    , operation : Elm.Expression
    , variableDefinitions : Elm.Expression
    , variableDefinition : Elm.Expression
    , type_ : Elm.Expression
    , listType : Elm.Expression
    , defaultValue : Elm.Expression
    , operationType : Elm.Expression
    , nameOpt : Elm.Expression
    , fragment : Elm.Expression
    , directivesHelper : Elm.Expression
    , directives : Elm.Expression
    , directive : Elm.Expression
    , argumentsOpt : Elm.Expression
    , arguments : Elm.Expression
    , argument : Elm.Expression
    , aliasedName : Elm.Expression
    , field_ : Elm.Expression
    , inlineOrSpread_ : Elm.Expression
    , comment : Elm.Expression
    , selectionSet : Elm.Expression
    , kvp : Elm.Expression
    , value : Elm.Expression
    , nullValue : Elm.Expression
    , objectValue : Elm.Expression
    , kvp_ : Elm.Expression
    , listValue : Elm.Expression
    , enumValue : Elm.Expression
    , stringValue : Elm.Expression
    , intOrFloat : Elm.Expression
    , boolValue : Elm.Expression
    , variable : Elm.Expression
    , name : Elm.Expression
    , ws : Elm.Expression
    , chars : Elm.Expression
    , ignoreChars : Elm.Expression
    , keywords : Elm.Expression
    , escapables : Elm.Expression
    , multiOr : Elm.Expression
    }
values_ =
    { peek =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "peek"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.string ] Type.string
                        , Type.namedWith [] "Parser" [ Type.var "thing" ]
                        ]
                        (Type.namedWith [] "Parser" [ Type.var "thing" ])
                    )
            }
    , problemToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "problemToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Parser" ] "Problem" [] ]
                        Type.string
                    )
            }
    , deadEndToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "deadEndToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Parser" ] "DeadEnd" [] ]
                        Type.string
                    )
            }
    , errorToString =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "errorToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [ "Parser" ] "DeadEnd" []) ]
                        Type.string
                    )
            }
    , ifProgress =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "ifProgress"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "step" ] (Type.var "done")
                        , Type.namedWith [] "Parser" [ Type.var "step" ]
                        ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.namedWith
                                []
                                "Step"
                                [ Type.var "step", Type.var "done" ]
                            ]
                        )
                    )
            }
    , parse =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "parse"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list
                                (Type.namedWith [ "Parser" ] "DeadEnd" [])
                            , Type.namedWith [ "AST" ] "Document" []
                            ]
                        )
                    )
            }
    , document =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "document"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Document" [] ]
                    )
            }
    , definition =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "definition"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Definition" [] ]
                    )
            }
    , operation =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "operation"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "OperationDetails" [] ]
                    )
            }
    , variableDefinitions =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "variableDefinitions"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.list
                            (Type.namedWith [ "AST" ] "VariableDefinition" [])
                        ]
                    )
            }
    , variableDefinition =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "variableDefinition"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "VariableDefinition" [] ]
                    )
            }
    , type_ =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "type_"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Type" [] ]
                    )
            }
    , listType =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "listType"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.unit ]
                            (Type.namedWith
                                []
                                "Parser"
                                [ Type.namedWith [ "AST" ] "Type" [] ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.namedWith [ "AST" ] "Type" [] ]
                        )
                    )
            }
    , defaultValue =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "defaultValue"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith
                            []
                            "Maybe"
                            [ Type.namedWith [ "AST" ] "Value" [] ]
                        ]
                    )
            }
    , operationType =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "operationType"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "OperationType" [] ]
                    )
            }
    , nameOpt =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "nameOpt"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith
                            []
                            "Maybe"
                            [ Type.namedWith [ "AST" ] "Name" [] ]
                        ]
                    )
            }
    , fragment =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "fragment"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "FragmentDetails" [] ]
                    )
            }
    , directivesHelper =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "directivesHelper"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.namedWith [ "AST" ] "Directive" []) ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.namedWith
                                [ "Parser" ]
                                "Step"
                                [ Type.list
                                    (Type.namedWith [ "AST" ] "Directive" [])
                                , Type.list
                                    (Type.namedWith [ "AST" ] "Directive" [])
                                ]
                            ]
                        )
                    )
            }
    , directives =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "directives"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.list (Type.namedWith [ "AST" ] "Directive" []) ]
                    )
            }
    , directive =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "directive"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Directive" [] ]
                    )
            }
    , argumentsOpt =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "argumentsOpt"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.list (Type.namedWith [ "AST" ] "Argument" []) ]
                    )
            }
    , arguments =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "arguments"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.list (Type.namedWith [ "AST" ] "Argument" []) ]
                    )
            }
    , argument =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "argument"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Argument" [] ]
                    )
            }
    , aliasedName =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "aliasedName"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.tuple
                            (Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [ "AST" ] "Name" [] ]
                            )
                            (Type.namedWith [ "AST" ] "Name" [])
                        ]
                    )
            }
    , field_ =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "field_"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "FieldDetails" [] ]
                    )
            }
    , inlineOrSpread_ =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "inlineOrSpread_"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Selection" [] ]
                    )
            }
    , comment =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "comment"
            , annotation = Just (Type.namedWith [] "Parser" [ Type.unit ])
            }
    , selectionSet =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "selectionSet"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.list (Type.namedWith [ "AST" ] "Selection" []) ]
                    )
            }
    , kvp =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "kvp"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.tuple
                            (Type.namedWith [ "AST" ] "Name" [])
                            (Type.namedWith [ "AST" ] "Value" [])
                        ]
                    )
            }
    , value =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "value"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Value" [] ]
                    )
            }
    , nullValue =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "nullValue"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Value" [] ]
                    )
            }
    , objectValue =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "objectValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.unit ]
                            (Type.namedWith
                                []
                                "Parser"
                                [ Type.namedWith [ "AST" ] "Value" [] ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.namedWith [ "AST" ] "Value" [] ]
                        )
                    )
            }
    , kvp_ =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "kvp_"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.unit ]
                            (Type.namedWith
                                []
                                "Parser"
                                [ Type.namedWith [ "AST" ] "Value" [] ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.tuple
                                (Type.namedWith [ "AST" ] "Name" [])
                                (Type.namedWith [ "AST" ] "Value" [])
                            ]
                        )
                    )
            }
    , listValue =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "listValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.unit ]
                            (Type.namedWith
                                []
                                "Parser"
                                [ Type.namedWith [ "AST" ] "Value" [] ]
                            )
                        ]
                        (Type.namedWith
                            []
                            "Parser"
                            [ Type.namedWith [ "AST" ] "Value" [] ]
                        )
                    )
            }
    , enumValue =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "enumValue"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Value" [] ]
                    )
            }
    , stringValue =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "stringValue"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Value" [] ]
                    )
            }
    , intOrFloat =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "intOrFloat"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Value" [] ]
                    )
            }
    , boolValue =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "boolValue"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Value" [] ]
                    )
            }
    , variable =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "variable"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Variable" [] ]
                    )
            }
    , name =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "name"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Parser"
                        [ Type.namedWith [ "AST" ] "Name" [] ]
                    )
            }
    , ws =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "ws"
            , annotation = Just (Type.namedWith [] "Parser" [ Type.unit ])
            }
    , chars =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "chars"
            , annotation = Just (Type.record [ ( "cr", Type.char ) ])
            }
    , ignoreChars =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "ignoreChars"
            , annotation = Just (Type.namedWith [] "Set" [ Type.char ])
            }
    , keywords =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "keywords"
            , annotation = Just (Type.namedWith [] "Set" [ Type.string ])
            }
    , escapables =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "escapables"
            , annotation = Just (Type.namedWith [] "Set" [ Type.char ])
            }
    , multiOr =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Parse" ]
            , name = "multiOr"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.function [ Type.var "a" ] Type.bool)
                        , Type.var "a"
                        ]
                        Type.bool
                    )
            }
    }



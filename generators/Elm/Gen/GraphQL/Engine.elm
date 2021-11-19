module Elm.Gen.GraphQL.Engine exposing (arg, argList, batch, decode, decodeNullable, encodeArgument, encodeInputObject, encodeOptionals, enum, field, fieldWith, getGql, id_, list, make_, map, map2, mapPremade, maybeEnum, maybeScalarEncode, moduleName_, mutation, nullable, object, objectWith, optional, prebakedQuery, premadeOperation, query, queryString, recover, requestDetails, select, selectTypeNameButSkip, types_, union, unsafe, with)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Engine" ]


types_ :
    { argument : Type.Annotation -> Type.Annotation
    , premade : Type.Annotation -> Type.Annotation
    , error : Type.Annotation
    , mutation : Type.Annotation
    , query : Type.Annotation
    , optional : Type.Annotation -> Type.Annotation
    , selection : Type.Annotation -> Type.Annotation -> Type.Annotation
    }
types_ =
    { argument = \arg0 -> Type.namedWith moduleName_ "Argument" [ arg0 ]
    , premade = \arg0 -> Type.namedWith moduleName_ "Premade" [ arg0 ]
    , error = Type.named moduleName_ "Error"
    , mutation = Type.named moduleName_ "Mutation"
    , query = Type.named moduleName_ "Query"
    , optional = \arg0 -> Type.namedWith moduleName_ "Optional" [ arg0 ]
    , selection =
        \arg0 arg1 -> Type.namedWith moduleName_ "Selection" [ arg0, arg1 ]
    }


make_ :
    { argument :
        { argValue : Elm.Expression -> Elm.Expression -> Elm.Expression
        , var : Elm.Expression -> Elm.Expression
        }
    , error :
        { badUrl : Elm.Expression -> Elm.Expression
        , timeout : Elm.Expression
        , networkError : Elm.Expression
        , badStatus : Elm.Expression -> Elm.Expression
        , badBody : Elm.Expression -> Elm.Expression
        }
    }
make_ =
    { argument =
        { argValue =
            \ar0 ar1 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "ArgValue"
                        (Type.namedWith [] "Argument" [ Type.var "obj" ])
                    )
                    [ ar0, ar1 ]
        , var =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "Var"
                        (Type.namedWith [] "Argument" [ Type.var "obj" ])
                    )
                    [ ar0 ]
        }
    , error =
        { badUrl =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "BadUrl"
                        (Type.namedWith [] "Error" [])
                    )
                    [ ar0 ]
        , timeout =
            Elm.valueWith moduleName_ "Timeout" (Type.namedWith [] "Error" [])
        , networkError =
            Elm.valueWith
                moduleName_
                "NetworkError"
                (Type.namedWith [] "Error" [])
        , badStatus =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "BadStatus"
                        (Type.namedWith [] "Error" [])
                    )
                    [ ar0 ]
        , badBody =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "BadBody"
                        (Type.namedWith [] "Error" [])
                    )
                    [ ar0 ]
        }
    }


{-| Batch a number of selection sets together!
-}
batch : Elm.Expression -> Elm.Expression
batch arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "batch"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "GraphQL", "Engine" ]
                        "Selection"
                        [ Type.var "source", Type.var "data" ]
                    )
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.list (Type.var "data") ]
                )
            )
        )
        [ arg1 ]


{-| Used in generated code to handle maybes
-}
nullable : Elm.Expression -> Elm.Expression
nullable arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "nullable"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.maybe (Type.var "data") ]
                )
            )
        )
        [ arg1 ]


{-| Used in generated code to handle maybes
-}
list : Elm.Expression -> Elm.Expression
list arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "list"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.list (Type.var "data") ]
                )
            )
        )
        [ arg1 ]


{-| -}
field : Elm.Expression -> Elm.Expression -> Elm.Expression
field arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "field"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| -}
fieldWith : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
fieldWith arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fieldWith"
            (Type.function
                [ Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith
                            [ "GraphQL", "Engine" ]
                            "Argument"
                            [ Type.var "arg" ]
                        )
                    )
                , Type.string
                , Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                )
            )
        )
        [ arg1, arg2, arg3 ]


{-| -}
object : Elm.Expression -> Elm.Expression -> Elm.Expression
object arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "object"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "otherSource", Type.var "data" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| -}
objectWith :
    Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
objectWith arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "objectWith"
            (Type.function
                [ Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith
                            [ "GraphQL", "Engine" ]
                            "Argument"
                            [ Type.var "arg" ]
                        )
                    )
                , Type.string
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "otherSource", Type.var "data" ]
                )
            )
        )
        [ arg1, arg2, arg3 ]


{-| This adds a bare decoder for data that has already been pulled down.

Note, this is rarely needed! So far, only when a query or mutation returns a scalar directly without selecting any fields.

-}
decode : Elm.Expression -> Elm.Expression
decode arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "decode"
            (Type.function
                [ Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                )
            )
        )
        [ arg1 ]


{-| -}
enum : Elm.Expression -> Elm.Expression
enum arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "enum"
            (Type.function
                [ Type.list (Type.tuple Type.string (Type.var "item")) ]
                (Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "item" ]
                )
            )
        )
        [ arg1 ]


{-| -}
maybeEnum : Elm.Expression -> Elm.Expression
maybeEnum arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "maybeEnum"
            (Type.function
                [ Type.list (Type.tuple Type.string (Type.var "item")) ]
                (Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.maybe (Type.var "item") ]
                )
            )
        )
        [ arg1 ]


{-| -}
union : Elm.Expression -> Elm.Expression
union arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "union"
            (Type.function
                [ Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith
                            [ "GraphQL", "Engine" ]
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                )
            )
        )
        [ arg1 ]


{-| -}
select : Elm.Expression -> Elm.Expression
select arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "select"
            (Type.function
                [ Type.var "data" ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                )
            )
        )
        [ arg1 ]


{-| -}
with : Elm.Expression -> Elm.Expression -> Elm.Expression
with arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "with"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "a" ]
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source"
                    , Type.function [ Type.var "a" ] (Type.var "b")
                    ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "b" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| -}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "a" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "b" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| -}
map2 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map2 arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "c")
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "a" ]
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "b" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "c" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-| -}
recover :
    Elm.Expression
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
recover arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "recover"
            (Type.function
                [ Type.var "recovered"
                , Type.function [ Type.var "data" ] (Type.var "recovered")
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "recovered" ]
                )
            )
        )
        [ arg1, arg2 Elm.pass, arg3 ]


{-| The encoded value and the name of the expected type for this argument
-}
arg : Elm.Expression -> Elm.Expression -> Elm.Expression
arg arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "arg"
            (Type.function
                [ Type.namedWith [ "Json", "Encode" ] "Value" [], Type.string ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Argument"
                    [ Type.var "obj" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| -}
argList : Elm.Expression -> Elm.Expression -> Elm.Expression
argList arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "argList"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "GraphQL", "Engine" ]
                        "Argument"
                        [ Type.var "obj" ]
                    )
                , Type.string
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Argument"
                    [ Type.var "input" ]
                )
            )
        )
        [ arg1, arg2 ]


{-|

    Encode the nullability in the argument itself.

-}
optional : Elm.Expression -> Elm.Expression -> Elm.Expression
optional arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "optional"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Argument"
                    [ Type.var "arg" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Optional"
                    [ Type.var "arg" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| -}
query : Elm.Expression -> Elm.Expression -> Elm.Expression
query arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "query"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.namedWith [ "GraphQL", "Engine" ] "Query" []
                    , Type.var "value"
                    ]
                , Type.record
                    [ ( "name", Type.maybe Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.namedWith
                    [ "Platform", "Cmd" ]
                    "Cmd"
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "GraphQL", "Engine" ] "Error" []
                        , Type.var "value"
                        ]
                    ]
                )
            )
        )
        [ arg1, arg2 ]


{-| -}
mutation : Elm.Expression -> Elm.Expression -> Elm.Expression
mutation arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "mutation"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.namedWith [ "GraphQL", "Engine" ] "Mutation" []
                    , Type.var "msg"
                    ]
                , Type.record
                    [ ( "name", Type.maybe Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.namedWith
                    [ "Platform", "Cmd" ]
                    "Cmd"
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "GraphQL", "Engine" ] "Error" []
                        , Type.var "msg"
                        ]
                    ]
                )
            )
        )
        [ arg1, arg2 ]


{-| -}
prebakedQuery :
    Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
prebakedQuery arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "prebakedQuery"
            (Type.function
                [ Type.string
                , Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
                , Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "data" ]
                )
            )
        )
        [ arg1, arg2, arg3 ]


{-| -}
premadeOperation : Elm.Expression -> Elm.Expression -> Elm.Expression
premadeOperation arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "premadeOperation"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "value" ]
                , Type.record
                    [ ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.namedWith
                    [ "Platform", "Cmd" ]
                    "Cmd"
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "GraphQL", "Engine" ] "Error" []
                        , Type.var "value"
                        ]
                    ]
                )
            )
        )
        [ arg1, arg2 ]


{-| 
Return details that can be directly given to `Http.request`.

This is so that wiring up [Elm Program Test](https://package.elm-lang.org/packages/avh4/elm-program-test/latest/ProgramTest) is relatively easy.


-}
requestDetails : Elm.Expression -> Elm.Expression -> Elm.Expression
requestDetails arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "requestDetails"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "value" ]
                , Type.record
                    [ ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.record
                    [ ( "method", Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "expect"
                      , Type.namedWith
                            [ "Http" ]
                            "Expect"
                            [ Type.namedWith
                                [ "Result" ]
                                "Result"
                                [ Type.namedWith
                                    [ "GraphQL", "Engine" ]
                                    "Error"
                                    []
                                , Type.var "value"
                                ]
                            ]
                      )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                )
            )
        )
        [ arg1, arg2 ]


{-| -}
queryString :
    Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
queryString arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "queryString"
            (Type.function
                [ Type.string
                , Type.maybe Type.string
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                Type.string
            )
        )
        [ arg1, arg2, arg3 ]


{-| -}
maybeScalarEncode :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
maybeScalarEncode arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "maybeScalarEncode"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith [ "Json", "Encode" ] "Value" [])
                , Type.maybe (Type.var "a")
                ]
                (Type.namedWith [ "Json", "Encode" ] "Value" [])
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| -}
encodeOptionals : Elm.Expression -> Elm.Expression
encodeOptionals arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "encodeOptionals"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "GraphQL", "Engine" ]
                        "Optional"
                        [ Type.var "arg" ]
                    )
                ]
                (Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith
                            [ "GraphQL", "Engine" ]
                            "Argument"
                            [ Type.var "arg" ]
                        )
                    )
                )
            )
        )
        [ arg1 ]


{-| -}
encodeInputObject : Elm.Expression -> Elm.Expression -> Elm.Expression
encodeInputObject arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "encodeInputObject"
            (Type.function
                [ Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith
                            [ "GraphQL", "Engine" ]
                            "Argument"
                            [ Type.var "obj" ]
                        )
                    )
                , Type.string
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Argument"
                    [ Type.var "input" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| -}
encodeArgument : Elm.Expression -> Elm.Expression
encodeArgument arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "encodeArgument"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Argument"
                    [ Type.var "obj" ]
                ]
                (Type.namedWith [ "Json", "Encode" ] "Value" [])
            )
        )
        [ arg1 ]


{-| -}
decodeNullable : Elm.Expression -> Elm.Expression
decodeNullable arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "decodeNullable"
            (Type.function
                [ Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "data" ]
                ]
                (Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.maybe (Type.var "data") ]
                )
            )
        )
        [ arg1 ]


{-| -}
getGql : Elm.Expression -> Elm.Expression
getGql arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "getGql"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "data" ]
                ]
                Type.string
            )
        )
        [ arg1 ]


{-| -}
mapPremade :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
mapPremade arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "mapPremade"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "b" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| -}
unsafe : Elm.Expression -> Elm.Expression
unsafe arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "unsafe"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "selected" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "unsafe", Type.var "selected" ]
                )
            )
        )
        [ arg1 ]


{-| -}
selectTypeNameButSkip : Elm.Expression
selectTypeNameButSkip =
    Elm.valueWith
        moduleName_
        "selectTypeNameButSkip"
        (Type.namedWith
            [ "GraphQL", "Engine" ]
            "Selection"
            [ Type.var "source", Type.unit ]
        )


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { batch : Elm.Expression
    , nullable : Elm.Expression
    , list : Elm.Expression
    , field : Elm.Expression
    , fieldWith : Elm.Expression
    , object : Elm.Expression
    , objectWith : Elm.Expression
    , decode : Elm.Expression
    , enum : Elm.Expression
    , maybeEnum : Elm.Expression
    , union : Elm.Expression
    , select : Elm.Expression
    , with : Elm.Expression
    , map : Elm.Expression
    , map2 : Elm.Expression
    , recover : Elm.Expression
    , arg : Elm.Expression
    , argList : Elm.Expression
    , optional : Elm.Expression
    , query : Elm.Expression
    , mutation : Elm.Expression
    , prebakedQuery : Elm.Expression
    , premadeOperation : Elm.Expression
    , requestDetails : Elm.Expression
    , queryString : Elm.Expression
    , maybeScalarEncode : Elm.Expression
    , encodeOptionals : Elm.Expression
    , encodeInputObject : Elm.Expression
    , encodeArgument : Elm.Expression
    , decodeNullable : Elm.Expression
    , getGql : Elm.Expression
    , mapPremade : Elm.Expression
    , unsafe : Elm.Expression
    , selectTypeNameButSkip : Elm.Expression
    }
id_ =
    { batch =
        Elm.valueWith
            moduleName_
            "batch"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "GraphQL", "Engine" ]
                        "Selection"
                        [ Type.var "source", Type.var "data" ]
                    )
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.list (Type.var "data") ]
                )
            )
    , nullable =
        Elm.valueWith
            moduleName_
            "nullable"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.maybe (Type.var "data") ]
                )
            )
    , list =
        Elm.valueWith
            moduleName_
            "list"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.list (Type.var "data") ]
                )
            )
    , field =
        Elm.valueWith
            moduleName_
            "field"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                )
            )
    , fieldWith =
        Elm.valueWith
            moduleName_
            "fieldWith"
            (Type.function
                [ Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith
                            [ "GraphQL", "Engine" ]
                            "Argument"
                            [ Type.var "arg" ]
                        )
                    )
                , Type.string
                , Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                )
            )
    , object =
        Elm.valueWith
            moduleName_
            "object"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "otherSource", Type.var "data" ]
                )
            )
    , objectWith =
        Elm.valueWith
            moduleName_
            "objectWith"
            (Type.function
                [ Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith
                            [ "GraphQL", "Engine" ]
                            "Argument"
                            [ Type.var "arg" ]
                        )
                    )
                , Type.string
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "otherSource", Type.var "data" ]
                )
            )
    , decode =
        Elm.valueWith
            moduleName_
            "decode"
            (Type.function
                [ Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                )
            )
    , enum =
        Elm.valueWith
            moduleName_
            "enum"
            (Type.function
                [ Type.list (Type.tuple Type.string (Type.var "item")) ]
                (Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "item" ]
                )
            )
    , maybeEnum =
        Elm.valueWith
            moduleName_
            "maybeEnum"
            (Type.function
                [ Type.list (Type.tuple Type.string (Type.var "item")) ]
                (Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.maybe (Type.var "item") ]
                )
            )
    , union =
        Elm.valueWith
            moduleName_
            "union"
            (Type.function
                [ Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith
                            [ "GraphQL", "Engine" ]
                            "Selection"
                            [ Type.var "source", Type.var "data" ]
                        )
                    )
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                )
            )
    , select =
        Elm.valueWith
            moduleName_
            "select"
            (Type.function
                [ Type.var "data" ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                )
            )
    , with =
        Elm.valueWith
            moduleName_
            "with"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "a" ]
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source"
                    , Type.function [ Type.var "a" ] (Type.var "b")
                    ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "b" ]
                )
            )
    , map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "a" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "b" ]
                )
            )
    , map2 =
        Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "c")
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "a" ]
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "b" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "c" ]
                )
            )
    , recover =
        Elm.valueWith
            moduleName_
            "recover"
            (Type.function
                [ Type.var "recovered"
                , Type.function [ Type.var "data" ] (Type.var "recovered")
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "recovered" ]
                )
            )
    , arg =
        Elm.valueWith
            moduleName_
            "arg"
            (Type.function
                [ Type.namedWith [ "Json", "Encode" ] "Value" [], Type.string ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Argument"
                    [ Type.var "obj" ]
                )
            )
    , argList =
        Elm.valueWith
            moduleName_
            "argList"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "GraphQL", "Engine" ]
                        "Argument"
                        [ Type.var "obj" ]
                    )
                , Type.string
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Argument"
                    [ Type.var "input" ]
                )
            )
    , optional =
        Elm.valueWith
            moduleName_
            "optional"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Argument"
                    [ Type.var "arg" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Optional"
                    [ Type.var "arg" ]
                )
            )
    , query =
        Elm.valueWith
            moduleName_
            "query"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.namedWith [ "GraphQL", "Engine" ] "Query" []
                    , Type.var "value"
                    ]
                , Type.record
                    [ ( "name", Type.maybe Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.namedWith
                    [ "Platform", "Cmd" ]
                    "Cmd"
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "GraphQL", "Engine" ] "Error" []
                        , Type.var "value"
                        ]
                    ]
                )
            )
    , mutation =
        Elm.valueWith
            moduleName_
            "mutation"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.namedWith [ "GraphQL", "Engine" ] "Mutation" []
                    , Type.var "msg"
                    ]
                , Type.record
                    [ ( "name", Type.maybe Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.namedWith
                    [ "Platform", "Cmd" ]
                    "Cmd"
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "GraphQL", "Engine" ] "Error" []
                        , Type.var "msg"
                        ]
                    ]
                )
            )
    , prebakedQuery =
        Elm.valueWith
            moduleName_
            "prebakedQuery"
            (Type.function
                [ Type.string
                , Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
                , Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "data" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "data" ]
                )
            )
    , premadeOperation =
        Elm.valueWith
            moduleName_
            "premadeOperation"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "value" ]
                , Type.record
                    [ ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.namedWith
                    [ "Platform", "Cmd" ]
                    "Cmd"
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "GraphQL", "Engine" ] "Error" []
                        , Type.var "value"
                        ]
                    ]
                )
            )
    , requestDetails =
        Elm.valueWith
            moduleName_
            "requestDetails"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "value" ]
                , Type.record
                    [ ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.record
                    [ ( "method", Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "expect"
                      , Type.namedWith
                            [ "Http" ]
                            "Expect"
                            [ Type.namedWith
                                [ "Result" ]
                                "Result"
                                [ Type.namedWith
                                    [ "GraphQL", "Engine" ]
                                    "Error"
                                    []
                                , Type.var "value"
                                ]
                            ]
                      )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                )
            )
    , queryString =
        Elm.valueWith
            moduleName_
            "queryString"
            (Type.function
                [ Type.string
                , Type.maybe Type.string
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "data" ]
                ]
                Type.string
            )
    , maybeScalarEncode =
        Elm.valueWith
            moduleName_
            "maybeScalarEncode"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith [ "Json", "Encode" ] "Value" [])
                , Type.maybe (Type.var "a")
                ]
                (Type.namedWith [ "Json", "Encode" ] "Value" [])
            )
    , encodeOptionals =
        Elm.valueWith
            moduleName_
            "encodeOptionals"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "GraphQL", "Engine" ]
                        "Optional"
                        [ Type.var "arg" ]
                    )
                ]
                (Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith
                            [ "GraphQL", "Engine" ]
                            "Argument"
                            [ Type.var "arg" ]
                        )
                    )
                )
            )
    , encodeInputObject =
        Elm.valueWith
            moduleName_
            "encodeInputObject"
            (Type.function
                [ Type.list
                    (Type.tuple
                        Type.string
                        (Type.namedWith
                            [ "GraphQL", "Engine" ]
                            "Argument"
                            [ Type.var "obj" ]
                        )
                    )
                , Type.string
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Argument"
                    [ Type.var "input" ]
                )
            )
    , encodeArgument =
        Elm.valueWith
            moduleName_
            "encodeArgument"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Argument"
                    [ Type.var "obj" ]
                ]
                (Type.namedWith [ "Json", "Encode" ] "Value" [])
            )
    , decodeNullable =
        Elm.valueWith
            moduleName_
            "decodeNullable"
            (Type.function
                [ Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "data" ]
                ]
                (Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.maybe (Type.var "data") ]
                )
            )
    , getGql =
        Elm.valueWith
            moduleName_
            "getGql"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "data" ]
                ]
                Type.string
            )
    , mapPremade =
        Elm.valueWith
            moduleName_
            "mapPremade"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Premade"
                    [ Type.var "b" ]
                )
            )
    , unsafe =
        Elm.valueWith
            moduleName_
            "unsafe"
            (Type.function
                [ Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "source", Type.var "selected" ]
                ]
                (Type.namedWith
                    [ "GraphQL", "Engine" ]
                    "Selection"
                    [ Type.var "unsafe", Type.var "selected" ]
                )
            )
    , selectTypeNameButSkip =
        Elm.valueWith
            moduleName_
            "selectTypeNameButSkip"
            (Type.namedWith
                [ "GraphQL", "Engine" ]
                "Selection"
                [ Type.var "source", Type.unit ]
            )
    }



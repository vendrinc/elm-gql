module Elm.Gen.Json.Encode exposing (array, bool, dict, encode, float, id_, int, list, moduleName_, null, object, set, string, typeValue)

{-| 


-}

import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Json", "Encode" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { encode : Elm.Expression
    , string : Elm.Expression
    , int : Elm.Expression
    , float : Elm.Expression
    , bool : Elm.Expression
    , null : Elm.Expression
    , list : Elm.Expression
    , array : Elm.Expression
    , set : Elm.Expression
    , object : Elm.Expression
    , dict : Elm.Expression
    }
id_ =
    { encode =
        Elm.valueWith
            moduleName_
            "encode"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Int" []
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Encode" ])
                    "Value"
                    []
                ]
                (Type.namedWith (Elm.moduleName [ "String" ]) "String" [])
            )
    , string =
        Elm.valueWith
            moduleName_
            "string"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "String" ]) "String" [] ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
    , int =
        Elm.valueWith
            moduleName_
            "int"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Int" [] ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
    , float =
        Elm.valueWith
            moduleName_
            "float"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Float" [] ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
    , bool =
        Elm.valueWith
            moduleName_
            "bool"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Bool" [] ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
    , null =
        Elm.valueWith
            moduleName_
            "null"
            (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" [])
    , list =
        Elm.valueWith
            moduleName_
            "list"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Encode" ])
                        "Value"
                        []
                    )
                , Type.namedWith
                    (Elm.moduleName [ "List" ])
                    "List"
                    [ Type.var "a" ]
                ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
    , array =
        Elm.valueWith
            moduleName_
            "array"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Encode" ])
                        "Value"
                        []
                    )
                , Type.namedWith
                    (Elm.moduleName [ "Array" ])
                    "Array"
                    [ Type.var "a" ]
                ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
    , set =
        Elm.valueWith
            moduleName_
            "set"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Encode" ])
                        "Value"
                        []
                    )
                , Type.namedWith
                    (Elm.moduleName [ "Set" ])
                    "Set"
                    [ Type.var "a" ]
                ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
    , object =
        Elm.valueWith
            moduleName_
            "object"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "List" ])
                    "List"
                    [ Type.tuple
                        (Type.namedWith
                            (Elm.moduleName [ "String" ])
                            "String"
                            []
                        )
                        (Type.namedWith
                            (Elm.moduleName [ "Json", "Encode" ])
                            "Value"
                            []
                        )
                    ]
                ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
    , dict =
        Elm.valueWith
            moduleName_
            "dict"
            (Type.function
                [ Type.function
                    [ Type.var "k" ]
                    (Type.namedWith (Elm.moduleName [ "String" ]) "String" [])
                , Type.function
                    [ Type.var "v" ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Encode" ])
                        "Value"
                        []
                    )
                , Type.namedWith
                    (Elm.moduleName [ "Dict" ])
                    "Dict"
                    [ Type.var "k", Type.var "v" ]
                ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
    }


{-| Convert a `Value` into a prettified string. The first argument specifies
the amount of indentation in the resulting string.

    import Json.Encode as Encode

    tom : Encode.Value
    tom =
        Encode.object
            [ ( "name", Encode.string "Tom" )
            , ( "age", Encode.int 42 )
            ]

    compact = Encode.encode 0 tom
    -- {"name":"Tom","age":42}

    readable = Encode.encode 4 tom
    -- {
    --     "name": "Tom",
    --     "age": 42
    -- }
-}
encode : Elm.Expression -> Elm.Expression -> Elm.Expression
encode arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "encode"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Int" []
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Encode" ])
                    "Value"
                    []
                ]
                (Type.namedWith (Elm.moduleName [ "String" ]) "String" [])
            )
        )
        [ arg1, arg2 ]


{-| Represents a JavaScript value.
-}
typeValue : { annotation : Type.Annotation }
typeValue =
    { annotation = Type.named moduleName_ "Value" }


{-| Turn a `String` into a JSON string.

    import Json.Encode exposing (encode, string)

    -- encode 0 (string "")      == "\"\""
    -- encode 0 (string "abc")   == "\"abc\""
    -- encode 0 (string "hello") == "\"hello\""
-}
string : Elm.Expression -> Elm.Expression
string arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "string"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "String" ]) "String" [] ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
        )
        [ arg1 ]


{-| Turn an `Int` into a JSON number.

    import Json.Encode exposing (encode, int)

    -- encode 0 (int 42) == "42"
    -- encode 0 (int -7) == "-7"
    -- encode 0 (int 0)  == "0"
-}
int : Elm.Expression -> Elm.Expression
int arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "int"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Int" [] ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
        )
        [ arg1 ]


{-| Turn a `Float` into a JSON number.

    import Json.Encode exposing (encode, float)

    -- encode 0 (float 3.14)     == "3.14"
    -- encode 0 (float 1.618)    == "1.618"
    -- encode 0 (float -42)      == "-42"
    -- encode 0 (float NaN)      == "null"
    -- encode 0 (float Infinity) == "null"

**Note:** Floating point numbers are defined in the [IEEE 754 standard][ieee]
which is hardcoded into almost all CPUs. This standard allows `Infinity` and
`NaN`. [The JSON spec][json] does not include these values, so we encode them
both as `null`.

[ieee]: https://en.wikipedia.org/wiki/IEEE_754
[json]: https://www.json.org/
-}
float : Elm.Expression -> Elm.Expression
float arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "float"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Float" [] ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
        )
        [ arg1 ]


{-| Turn a `Bool` into a JSON boolean.

    import Json.Encode exposing (encode, bool)

    -- encode 0 (bool True)  == "true"
    -- encode 0 (bool False) == "false"
-}
bool : Elm.Expression -> Elm.Expression
bool arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "bool"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Bool" [] ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
        )
        [ arg1 ]


{-| Create a JSON `null` value.

    import Json.Encode exposing (encode, null)

    -- encode 0 null == "null"
-}
null : Elm.Expression
null =
    Elm.valueWith
        moduleName_
        "null"
        (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" [])


{-| Turn a `List` into a JSON array.

    import Json.Encode as Encode exposing (bool, encode, int, list, string)

    -- encode 0 (list int [1,3,4])       == "[1,3,4]"
    -- encode 0 (list bool [True,False]) == "[true,false]"
    -- encode 0 (list string ["a","b"])  == """["a","b"]"""

-}
list : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
list arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "list"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Encode" ])
                        "Value"
                        []
                    )
                , Type.namedWith
                    (Elm.moduleName [ "List" ])
                    "List"
                    [ Type.var "a" ]
                ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Turn an `Array` into a JSON array.
-}
array : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
array arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "array"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Encode" ])
                        "Value"
                        []
                    )
                , Type.namedWith
                    (Elm.moduleName [ "Array" ])
                    "Array"
                    [ Type.var "a" ]
                ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Turn an `Set` into a JSON array.
-}
set : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
set arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "set"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Encode" ])
                        "Value"
                        []
                    )
                , Type.namedWith
                    (Elm.moduleName [ "Set" ])
                    "Set"
                    [ Type.var "a" ]
                ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Create a JSON object.

    import Json.Encode as Encode

    tom : Encode.Value
    tom =
        Encode.object
            [ ( "name", Encode.string "Tom" )
            , ( "age", Encode.int 42 )
            ]

    -- Encode.encode 0 tom == """{"name":"Tom","age":42}"""
-}
object : Elm.Expression -> Elm.Expression
object arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "object"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "List" ])
                    "List"
                    [ Type.tuple
                        (Type.namedWith
                            (Elm.moduleName [ "String" ])
                            "String"
                            []
                        )
                        (Type.namedWith
                            (Elm.moduleName [ "Json", "Encode" ])
                            "Value"
                            []
                        )
                    ]
                ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
        )
        [ arg1 ]


{-| Turn a `Dict` into a JSON object.

    import Dict exposing (Dict)
    import Json.Encode as Encode

    people : Dict String Int
    people =
      Dict.fromList [ ("Tom",42), ("Sue", 38) ]

    -- Encode.encode 0 (Encode.dict identity Encode.int people)
    --   == """{"Tom":42,"Sue":38}"""
-}
dict :
    (Elm.Expression -> Elm.Expression)
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
dict arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "dict"
            (Type.function
                [ Type.function
                    [ Type.var "k" ]
                    (Type.namedWith (Elm.moduleName [ "String" ]) "String" [])
                , Type.function
                    [ Type.var "v" ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Encode" ])
                        "Value"
                        []
                    )
                , Type.namedWith
                    (Elm.moduleName [ "Dict" ])
                    "Dict"
                    [ Type.var "k", Type.var "v" ]
                ]
                (Type.namedWith (Elm.moduleName [ "Json", "Encode" ]) "Value" []
                )
            )
        )
        [ arg1 Elm.pass, arg2 Elm.pass, arg3 ]

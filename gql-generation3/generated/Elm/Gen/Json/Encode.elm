module Elm.Gen.Json.Encode exposing (array, bool, dict, encode, float, id_, int, list, moduleName_, null, object, set, string)

import Elm
import Elm.Annotation


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
    { encode = Elm.valueFrom moduleName_ "encode"
    , string = Elm.valueFrom moduleName_ "string"
    , int = Elm.valueFrom moduleName_ "int"
    , float = Elm.valueFrom moduleName_ "float"
    , bool = Elm.valueFrom moduleName_ "bool"
    , null = Elm.valueFrom moduleName_ "null"
    , list = Elm.valueFrom moduleName_ "list"
    , array = Elm.valueFrom moduleName_ "array"
    , set = Elm.valueFrom moduleName_ "set"
    , object = Elm.valueFrom moduleName_ "object"
    , dict = Elm.valueFrom moduleName_ "dict"
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
    Elm.apply (Elm.valueFrom moduleName_ "encode") [ arg1, arg2 ]


{-| Represents a JavaScript value.
-}
typeValue : { annotation : Elm.Annotation.Annotation }
typeValue =
    { annotation = Elm.Annotation.named moduleName_ "Value" }


{-| Turn a `String` into a JSON string.

    import Json.Encode exposing (encode, string)

    -- encode 0 (string "")      == "\"\""
    -- encode 0 (string "abc")   == "\"abc\""
    -- encode 0 (string "hello") == "\"hello\""
-}
string : Elm.Expression -> Elm.Expression
string arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "string") [ arg1 ]


{-| Turn an `Int` into a JSON number.

    import Json.Encode exposing (encode, int)

    -- encode 0 (int 42) == "42"
    -- encode 0 (int -7) == "-7"
    -- encode 0 (int 0)  == "0"
-}
int : Elm.Expression -> Elm.Expression
int arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "int") [ arg1 ]


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
    Elm.apply (Elm.valueFrom moduleName_ "float") [ arg1 ]


{-| Turn a `Bool` into a JSON boolean.

    import Json.Encode exposing (encode, bool)

    -- encode 0 (bool True)  == "true"
    -- encode 0 (bool False) == "false"
-}
bool : Elm.Expression -> Elm.Expression
bool arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "bool") [ arg1 ]


{-| Create a JSON `null` value.

    import Json.Encode exposing (encode, null)

    -- encode 0 null == "null"
-}
null : Elm.Expression
null =
    Elm.valueFrom moduleName_ "null"


{-| Turn a `List` into a JSON array.

    import Json.Encode as Encode exposing (bool, encode, int, list, string)

    -- encode 0 (list int [1,3,4])       == "[1,3,4]"
    -- encode 0 (list bool [True,False]) == "[true,false]"
    -- encode 0 (list string ["a","b"])  == """["a","b"]"""

-}
list : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
list arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "list") [ arg1 Elm.pass, arg2 ]


{-| Turn an `Array` into a JSON array.
-}
array : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
array arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "array") [ arg1 Elm.pass, arg2 ]


{-| Turn an `Set` into a JSON array.
-}
set : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
set arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "set") [ arg1 Elm.pass, arg2 ]


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
    Elm.apply (Elm.valueFrom moduleName_ "object") [ arg1 ]


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
        (Elm.valueFrom moduleName_ "dict")
        [ arg1 Elm.pass, arg2 Elm.pass, arg3 ]

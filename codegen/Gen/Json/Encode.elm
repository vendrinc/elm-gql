module Gen.Json.Encode exposing (annotation_, array, bool, call_, dict, encode, float, int, list, moduleName_, null, object, set, string, values_)

{-| 
@docs values_, call_, annotation_, dict, object, set, array, list, null, bool, float, int, string, encode, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Json", "Encode" ]


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

encode: Int -> Json.Encode.Value -> String
-}
encode : Int -> Elm.Expression -> Elm.Expression
encode encodeArg encodeArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "encode"
            , annotation =
                Just
                    (Type.function
                        [ Type.int
                        , Type.namedWith [ "Json", "Encode" ] "Value" []
                        ]
                        Type.string
                    )
            }
        )
        [ Elm.int encodeArg, encodeArg0 ]


{-| Turn a `String` into a JSON string.

    import Json.Encode exposing (encode, string)

    -- encode 0 (string "")      == "\"\""
    -- encode 0 (string "abc")   == "\"abc\""
    -- encode 0 (string "hello") == "\"hello\""

string: String -> Json.Encode.Value
-}
string : String -> Elm.Expression
string stringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "string"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.string stringArg ]


{-| Turn an `Int` into a JSON number.

    import Json.Encode exposing (encode, int)

    -- encode 0 (int 42) == "42"
    -- encode 0 (int -7) == "-7"
    -- encode 0 (int 0)  == "0"

int: Int -> Json.Encode.Value
-}
int : Int -> Elm.Expression
int intArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "int"
            , annotation =
                Just
                    (Type.function
                        [ Type.int ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.int intArg ]


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

float: Float -> Json.Encode.Value
-}
float : Float -> Elm.Expression
float floatArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "float"
            , annotation =
                Just
                    (Type.function
                        [ Type.float ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.float floatArg ]


{-| Turn a `Bool` into a JSON boolean.

    import Json.Encode exposing (encode, bool)

    -- encode 0 (bool True)  == "true"
    -- encode 0 (bool False) == "false"

bool: Bool -> Json.Encode.Value
-}
bool : Bool -> Elm.Expression
bool boolArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "bool"
            , annotation =
                Just
                    (Type.function
                        [ Type.bool ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.bool boolArg ]


{-| Create a JSON `null` value.

    import Json.Encode exposing (encode, null)

    -- encode 0 null == "null"

null: Json.Encode.Value
-}
null : Elm.Expression
null =
    Elm.value
        { importFrom = [ "Json", "Encode" ]
        , name = "null"
        , annotation = Just (Type.namedWith [ "Json", "Encode" ] "Value" [])
        }


{-| Turn a `List` into a JSON array.

    import Json.Encode as Encode exposing (bool, encode, int, list, string)

    -- encode 0 (list int [1,3,4])       == "[1,3,4]"
    -- encode 0 (list bool [True,False]) == "[true,false]"
    -- encode 0 (list string ["a","b"])  == """["a","b"]"""

list: (a -> Json.Encode.Value) -> List a -> Json.Encode.Value
-}
list :
    (Elm.Expression -> Elm.Expression) -> List Elm.Expression -> Elm.Expression
list listArg listArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "list"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.list (Type.var "a")
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.functionReduced "listUnpack" listArg, Elm.list listArg0 ]


{-| Turn an `Array` into a JSON array.

array: (a -> Json.Encode.Value) -> Array.Array a -> Json.Encode.Value
-}
array : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
array arrayArg arrayArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "array"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [ "Array" ] "Array" [ Type.var "a" ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.functionReduced "arrayUnpack" arrayArg, arrayArg0 ]


{-| Turn an `Set` into a JSON array.

set: (a -> Json.Encode.Value) -> Set.Set a -> Json.Encode.Value
-}
set : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
set setArg setArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "set"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [ "Set" ] "Set" [ Type.var "a" ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.functionReduced "setUnpack" setArg, setArg0 ]


{-| Create a JSON object.

    import Json.Encode as Encode

    tom : Encode.Value
    tom =
        Encode.object
            [ ( "name", Encode.string "Tom" )
            , ( "age", Encode.int 42 )
            ]

    -- Encode.encode 0 tom == """{"name":"Tom","age":42}"""

object: List ( String, Json.Encode.Value ) -> Json.Encode.Value
-}
object : List Elm.Expression -> Elm.Expression
object objectArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "object"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.list objectArg ]


{-| Turn a `Dict` into a JSON object.

    import Dict exposing (Dict)
    import Json.Encode as Encode

    people : Dict String Int
    people =
      Dict.fromList [ ("Tom",42), ("Sue", 38) ]

    -- Encode.encode 0 (Encode.dict identity Encode.int people)
    --   == """{"Tom":42,"Sue":38}"""

dict: (k -> String) -> (v -> Json.Encode.Value) -> Dict.Dict k v -> Json.Encode.Value
-}
dict :
    (Elm.Expression -> Elm.Expression)
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
dict dictArg dictArg0 dictArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "dict"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "k" ] Type.string
                        , Type.function
                            [ Type.var "v" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith
                            [ "Dict" ]
                            "Dict"
                            [ Type.var "k", Type.var "v" ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.functionReduced "dictUnpack" dictArg
        , Elm.functionReduced "dictUnpack" dictArg0
        , dictArg1
        ]


annotation_ : { value : Type.Annotation }
annotation_ =
    { value = Type.namedWith [ "Json", "Encode" ] "Value" [] }


call_ :
    { encode : Elm.Expression -> Elm.Expression -> Elm.Expression
    , string : Elm.Expression -> Elm.Expression
    , int : Elm.Expression -> Elm.Expression
    , float : Elm.Expression -> Elm.Expression
    , bool : Elm.Expression -> Elm.Expression
    , list : Elm.Expression -> Elm.Expression -> Elm.Expression
    , array : Elm.Expression -> Elm.Expression -> Elm.Expression
    , set : Elm.Expression -> Elm.Expression -> Elm.Expression
    , object : Elm.Expression -> Elm.Expression
    , dict :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { encode =
        \encodeArg encodeArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Encode" ]
                    , name = "encode"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.int
                                , Type.namedWith [ "Json", "Encode" ] "Value" []
                                ]
                                Type.string
                            )
                    }
                )
                [ encodeArg, encodeArg0 ]
    , string =
        \stringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Encode" ]
                    , name = "string"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ stringArg ]
    , int =
        \intArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Encode" ]
                    , name = "int"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.int ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ intArg ]
    , float =
        \floatArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Encode" ]
                    , name = "float"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.float ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ floatArg ]
    , bool =
        \boolArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Encode" ]
                    , name = "bool"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.bool ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ boolArg ]
    , list =
        \listArg listArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Encode" ]
                    , name = "list"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a" ]
                                    (Type.namedWith
                                        [ "Json", "Encode" ]
                                        "Value"
                                        []
                                    )
                                , Type.list (Type.var "a")
                                ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ listArg, listArg0 ]
    , array =
        \arrayArg arrayArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Encode" ]
                    , name = "array"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a" ]
                                    (Type.namedWith
                                        [ "Json", "Encode" ]
                                        "Value"
                                        []
                                    )
                                , Type.namedWith
                                    [ "Array" ]
                                    "Array"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ arrayArg, arrayArg0 ]
    , set =
        \setArg setArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Encode" ]
                    , name = "set"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a" ]
                                    (Type.namedWith
                                        [ "Json", "Encode" ]
                                        "Value"
                                        []
                                    )
                                , Type.namedWith
                                    [ "Set" ]
                                    "Set"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ setArg, setArg0 ]
    , object =
        \objectArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Encode" ]
                    , name = "object"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith
                                            [ "Json", "Encode" ]
                                            "Value"
                                            []
                                        )
                                    )
                                ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ objectArg ]
    , dict =
        \dictArg dictArg0 dictArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Encode" ]
                    , name = "dict"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function [ Type.var "k" ] Type.string
                                , Type.function
                                    [ Type.var "v" ]
                                    (Type.namedWith
                                        [ "Json", "Encode" ]
                                        "Value"
                                        []
                                    )
                                , Type.namedWith
                                    [ "Dict" ]
                                    "Dict"
                                    [ Type.var "k", Type.var "v" ]
                                ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ dictArg, dictArg0, dictArg1 ]
    }


values_ :
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
values_ =
    { encode =
        Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "encode"
            , annotation =
                Just
                    (Type.function
                        [ Type.int
                        , Type.namedWith [ "Json", "Encode" ] "Value" []
                        ]
                        Type.string
                    )
            }
    , string =
        Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "string"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , int =
        Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "int"
            , annotation =
                Just
                    (Type.function
                        [ Type.int ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , float =
        Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "float"
            , annotation =
                Just
                    (Type.function
                        [ Type.float ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , bool =
        Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "bool"
            , annotation =
                Just
                    (Type.function
                        [ Type.bool ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , null =
        Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "null"
            , annotation = Just (Type.namedWith [ "Json", "Encode" ] "Value" [])
            }
    , list =
        Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "list"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.list (Type.var "a")
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , array =
        Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "array"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [ "Array" ] "Array" [ Type.var "a" ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , set =
        Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "set"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith [ "Set" ] "Set" [ Type.var "a" ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , object =
        Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "object"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , dict =
        Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "dict"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "k" ] Type.string
                        , Type.function
                            [ Type.var "v" ]
                            (Type.namedWith [ "Json", "Encode" ] "Value" [])
                        , Type.namedWith
                            [ "Dict" ]
                            "Dict"
                            [ Type.var "k", Type.var "v" ]
                        ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    }



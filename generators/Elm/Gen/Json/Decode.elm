module Elm.Gen.Json.Decode exposing (andThen, array, at, bool, decodeString, decodeValue, dict, errorToString, fail, field, float, id_, index, int, keyValuePairs, lazy, list, map, map2, map3, map4, map5, map6, map7, map8, maybe, moduleName_, null, nullable, oneOf, oneOrMore, string, succeed, value)

import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Json", "Decode" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { string : Elm.Expression
    , bool : Elm.Expression
    , int : Elm.Expression
    , float : Elm.Expression
    , nullable : Elm.Expression
    , list : Elm.Expression
    , array : Elm.Expression
    , dict : Elm.Expression
    , keyValuePairs : Elm.Expression
    , oneOrMore : Elm.Expression
    , field : Elm.Expression
    , at : Elm.Expression
    , index : Elm.Expression
    , maybe : Elm.Expression
    , oneOf : Elm.Expression
    , decodeString : Elm.Expression
    , decodeValue : Elm.Expression
    , errorToString : Elm.Expression
    , map : Elm.Expression
    , map2 : Elm.Expression
    , map3 : Elm.Expression
    , map4 : Elm.Expression
    , map5 : Elm.Expression
    , map6 : Elm.Expression
    , map7 : Elm.Expression
    , map8 : Elm.Expression
    , lazy : Elm.Expression
    , value : Elm.Expression
    , null : Elm.Expression
    , succeed : Elm.Expression
    , fail : Elm.Expression
    , andThen : Elm.Expression
    }
id_ =
    { string =
        Elm.valueWith
            moduleName_
            "string"
            (Type.namedWith
                (Elm.moduleName [ "Json", "Decode" ])
                "Decoder"
                [ Type.namedWith (Elm.moduleName [ "String" ]) "String" [] ]
            )
    , bool =
        Elm.valueWith
            moduleName_
            "bool"
            (Type.namedWith
                (Elm.moduleName [ "Json", "Decode" ])
                "Decoder"
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Bool" [] ]
            )
    , int =
        Elm.valueWith
            moduleName_
            "int"
            (Type.namedWith
                (Elm.moduleName [ "Json", "Decode" ])
                "Decoder"
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Int" [] ]
            )
    , float =
        Elm.valueWith
            moduleName_
            "float"
            (Type.namedWith
                (Elm.moduleName [ "Json", "Decode" ])
                "Decoder"
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Float" [] ]
            )
    , nullable =
        Elm.valueWith
            moduleName_
            "nullable"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "Maybe" ])
                        "Maybe"
                        [ Type.var "a" ]
                    ]
                )
            )
    , list =
        Elm.valueWith
            moduleName_
            "list"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "List" ])
                        "List"
                        [ Type.var "a" ]
                    ]
                )
            )
    , array =
        Elm.valueWith
            moduleName_
            "array"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "Array" ])
                        "Array"
                        [ Type.var "a" ]
                    ]
                )
            )
    , dict =
        Elm.valueWith
            moduleName_
            "dict"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "Dict" ])
                        "Dict"
                        [ Type.namedWith
                            (Elm.moduleName [ "String" ])
                            "String"
                            []
                        , Type.var "a"
                        ]
                    ]
                )
            )
    , keyValuePairs =
        Elm.valueWith
            moduleName_
            "keyValuePairs"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "List" ])
                        "List"
                        [ Type.tuple
                            (Type.namedWith
                                (Elm.moduleName [ "String" ])
                                "String"
                                []
                            )
                            (Type.var "a")
                        ]
                    ]
                )
            )
    , oneOrMore =
        Elm.valueWith
            moduleName_
            "oneOrMore"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.namedWith
                        (Elm.moduleName [ "List" ])
                        "List"
                        [ Type.var "a" ]
                    ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
    , field =
        Elm.valueWith
            moduleName_
            "field"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "String" ]) "String" []
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , at =
        Elm.valueWith
            moduleName_
            "at"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "List" ])
                    "List"
                    [ Type.namedWith (Elm.moduleName [ "String" ]) "String" [] ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , index =
        Elm.valueWith
            moduleName_
            "index"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Int" []
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , maybe =
        Elm.valueWith
            moduleName_
            "maybe"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "Maybe" ])
                        "Maybe"
                        [ Type.var "a" ]
                    ]
                )
            )
    , oneOf =
        Elm.valueWith
            moduleName_
            "oneOf"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "List" ])
                    "List"
                    [ Type.namedWith
                        (Elm.moduleName [ "Json", "Decode" ])
                        "Decoder"
                        [ Type.var "a" ]
                    ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , decodeString =
        Elm.valueWith
            moduleName_
            "decodeString"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith (Elm.moduleName [ "String" ]) "String" []
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Result" ])
                    "Result"
                    [ Type.namedWith
                        (Elm.moduleName [ "Json", "Decode" ])
                        "Error"
                        []
                    , Type.var "a"
                    ]
                )
            )
    , decodeValue =
        Elm.valueWith
            moduleName_
            "decodeValue"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Value"
                    []
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Result" ])
                    "Result"
                    [ Type.namedWith
                        (Elm.moduleName [ "Json", "Decode" ])
                        "Error"
                        []
                    , Type.var "a"
                    ]
                )
            )
    , errorToString =
        Elm.valueWith
            moduleName_
            "errorToString"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Error"
                    []
                ]
                (Type.namedWith (Elm.moduleName [ "String" ]) "String" [])
            )
    , map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
    , map2 =
        Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b" ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
    , map3 =
        Elm.valueWith
            moduleName_
            "map3"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c" ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
    , map4 =
        Elm.valueWith
            moduleName_
            "map4"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c", Type.var "d" ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "d" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
    , map5 =
        Elm.valueWith
            moduleName_
            "map5"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "e" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
    , map6 =
        Elm.valueWith
            moduleName_
            "map6"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "f" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
    , map7 =
        Elm.valueWith
            moduleName_
            "map7"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    , Type.var "g"
                    ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "f" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "g" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
    , map8 =
        Elm.valueWith
            moduleName_
            "map8"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    , Type.var "g"
                    , Type.var "h"
                    ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "f" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "g" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "h" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
    , lazy =
        Elm.valueWith
            moduleName_
            "lazy"
            (Type.function
                [ Type.function
                    [ Type.unit ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Decode" ])
                        "Decoder"
                        [ Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , value =
        Elm.valueWith
            moduleName_
            "value"
            (Type.namedWith
                (Elm.moduleName [ "Json", "Decode" ])
                "Decoder"
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Value"
                    []
                ]
            )
    , null =
        Elm.valueWith
            moduleName_
            "null"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , succeed =
        Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , fail =
        Elm.valueWith
            moduleName_
            "fail"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "String" ]) "String" [] ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , andThen =
        Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Decode" ])
                        "Decoder"
                        [ Type.var "b" ]
                    )
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                )
            )
    }


{-| A value that knows how to decode JSON values.

There is a whole section in `guide.elm-lang.org` about decoders, so [check it
out](https://guide.elm-lang.org/interop/json.html) for a more comprehensive
introduction!
-}
typeDecoder : { annotation : Type.Annotation }
typeDecoder =
    { annotation = Type.named moduleName_ "Decoder" }


{-| Decode a JSON string into an Elm `String`.

    decodeString string "true"              == Err ...
    decodeString string "42"                == Err ...
    decodeString string "3.14"              == Err ...
    decodeString string "\"hello\""         == Ok "hello"
    decodeString string "{ \"hello\": 42 }" == Err ...
-}
string : Elm.Expression
string =
    Elm.valueWith
        moduleName_
        "string"
        (Type.namedWith
            (Elm.moduleName [ "Json", "Decode" ])
            "Decoder"
            [ Type.namedWith (Elm.moduleName [ "String" ]) "String" [] ]
        )


{-| Decode a JSON boolean into an Elm `Bool`.

    decodeString bool "true"              == Ok True
    decodeString bool "42"                == Err ...
    decodeString bool "3.14"              == Err ...
    decodeString bool "\"hello\""         == Err ...
    decodeString bool "{ \"hello\": 42 }" == Err ...
-}
bool : Elm.Expression
bool =
    Elm.valueWith
        moduleName_
        "bool"
        (Type.namedWith
            (Elm.moduleName [ "Json", "Decode" ])
            "Decoder"
            [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Bool" [] ]
        )


{-| Decode a JSON number into an Elm `Int`.

    decodeString int "true"              == Err ...
    decodeString int "42"                == Ok 42
    decodeString int "3.14"              == Err ...
    decodeString int "\"hello\""         == Err ...
    decodeString int "{ \"hello\": 42 }" == Err ...
-}
int : Elm.Expression
int =
    Elm.valueWith
        moduleName_
        "int"
        (Type.namedWith
            (Elm.moduleName [ "Json", "Decode" ])
            "Decoder"
            [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Int" [] ]
        )


{-| Decode a JSON number into an Elm `Float`.

    decodeString float "true"              == Err ..
    decodeString float "42"                == Ok 42
    decodeString float "3.14"              == Ok 3.14
    decodeString float "\"hello\""         == Err ...
    decodeString float "{ \"hello\": 42 }" == Err ...
-}
float : Elm.Expression
float =
    Elm.valueWith
        moduleName_
        "float"
        (Type.namedWith
            (Elm.moduleName [ "Json", "Decode" ])
            "Decoder"
            [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Float" [] ]
        )


{-| Decode a nullable JSON value into an Elm value.

    decodeString (nullable int) "13"    == Ok (Just 13)
    decodeString (nullable int) "42"    == Ok (Just 42)
    decodeString (nullable int) "null"  == Ok Nothing
    decodeString (nullable int) "true"  == Err ..
-}
nullable : Elm.Expression -> Elm.Expression
nullable arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "nullable"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "Maybe" ])
                        "Maybe"
                        [ Type.var "a" ]
                    ]
                )
            )
        )
        [ arg1 ]


{-| Decode a JSON array into an Elm `List`.

    decodeString (list int) "[1,2,3]"       == Ok [1,2,3]
    decodeString (list bool) "[true,false]" == Ok [True,False]
-}
list : Elm.Expression -> Elm.Expression
list arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "list"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "List" ])
                        "List"
                        [ Type.var "a" ]
                    ]
                )
            )
        )
        [ arg1 ]


{-| Decode a JSON array into an Elm `Array`.

    decodeString (array int) "[1,2,3]"       == Ok (Array.fromList [1,2,3])
    decodeString (array bool) "[true,false]" == Ok (Array.fromList [True,False])
-}
array : Elm.Expression -> Elm.Expression
array arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "array"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "Array" ])
                        "Array"
                        [ Type.var "a" ]
                    ]
                )
            )
        )
        [ arg1 ]


{-| Decode a JSON object into an Elm `Dict`.

    decodeString (dict int) "{ \"alice\": 42, \"bob\": 99 }"
      == Ok (Dict.fromList [("alice", 42), ("bob", 99)])

If you need the keys (like `"alice"` and `"bob"`) available in the `Dict`
values as well, I recommend using a (private) intermediate data structure like
`Info` in this example:

    module User exposing (User, decoder)

    import Dict
    import Json.Decode exposing (..)

    type alias User =
      { name : String
      , height : Float
      , age : Int
      }

    decoder : Decoder (Dict.Dict String User)
    decoder =
      map (Dict.map infoToUser) (dict infoDecoder)

    type alias Info =
      { height : Float
      , age : Int
      }

    infoDecoder : Decoder Info
    infoDecoder =
      map2 Info
        (field "height" float)
        (field "age" int)

    infoToUser : String -> Info -> User
    infoToUser name { height, age } =
      User name height age

So now JSON like `{ "alice": { height: 1.6, age: 33 }}` are turned into
dictionary values like `Dict.singleton "alice" (User "alice" 1.6 33)` if
you need that.
-}
dict : Elm.Expression -> Elm.Expression
dict arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "dict"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "Dict" ])
                        "Dict"
                        [ Type.namedWith
                            (Elm.moduleName [ "String" ])
                            "String"
                            []
                        , Type.var "a"
                        ]
                    ]
                )
            )
        )
        [ arg1 ]


{-| Decode a JSON object into an Elm `List` of pairs.

    decodeString (keyValuePairs int) "{ \"alice\": 42, \"bob\": 99 }"
      == Ok [("alice", 42), ("bob", 99)]
-}
keyValuePairs : Elm.Expression -> Elm.Expression
keyValuePairs arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "keyValuePairs"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "List" ])
                        "List"
                        [ Type.tuple
                            (Type.namedWith
                                (Elm.moduleName [ "String" ])
                                "String"
                                []
                            )
                            (Type.var "a")
                        ]
                    ]
                )
            )
        )
        [ arg1 ]


{-| Decode a JSON array that has one or more elements. This comes up if you
want to enable drag-and-drop of files into your application. You would pair
this function with [`elm/file`]() to write a `dropDecoder` like this:

    import File exposing (File)
    import Json.Decoder as D

    type Msg
      = GotFiles File (List Files)

    inputDecoder : D.Decoder Msg
    inputDecoder =
      D.at ["dataTransfer","files"] (D.oneOrMore GotFiles File.decoder)

This captures the fact that you can never drag-and-drop zero files.
-}
oneOrMore :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
oneOrMore arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "oneOrMore"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.namedWith
                        (Elm.moduleName [ "List" ])
                        "List"
                        [ Type.var "a" ]
                    ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2 ]


{-| Decode a JSON object, requiring a particular field.

    decodeString (field "x" int) "{ \"x\": 3 }"            == Ok 3
    decodeString (field "x" int) "{ \"x\": 3, \"y\": 4 }"  == Ok 3
    decodeString (field "x" int) "{ \"x\": true }"         == Err ...
    decodeString (field "x" int) "{ \"y\": 4 }"            == Err ...

    decodeString (field "name" string) "{ \"name\": \"tom\" }" == Ok "tom"

The object *can* have other fields. Lots of them! The only thing this decoder
cares about is if `x` is present and that the value there is an `Int`.

Check out [`map2`](#map2) to see how to decode multiple fields!
-}
field : Elm.Expression -> Elm.Expression -> Elm.Expression
field arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "field"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "String" ]) "String" []
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Decode a nested JSON object, requiring certain fields.

    json = """{ "person": { "name": "tom", "age": 42 } }"""

    decodeString (at ["person", "name"] string) json  == Ok "tom"
    decodeString (at ["person", "age" ] int   ) json  == Ok "42

This is really just a shorthand for saying things like:

    field "person" (field "name" string) == at ["person","name"] string
-}
at : Elm.Expression -> Elm.Expression -> Elm.Expression
at arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "at"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "List" ])
                    "List"
                    [ Type.namedWith (Elm.moduleName [ "String" ]) "String" [] ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Decode a JSON array, requiring a particular index.

    json = """[ "alice", "bob", "chuck" ]"""

    decodeString (index 0 string) json  == Ok "alice"
    decodeString (index 1 string) json  == Ok "bob"
    decodeString (index 2 string) json  == Ok "chuck"
    decodeString (index 3 string) json  == Err ...
-}
index : Elm.Expression -> Elm.Expression -> Elm.Expression
index arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "index"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "Basics" ]) "Int" []
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Helpful for dealing with optional fields. Here are a few slightly different
examples:

    json = """{ "name": "tom", "age": 42 }"""

    decodeString (maybe (field "age"    int  )) json == Ok (Just 42)
    decodeString (maybe (field "name"   int  )) json == Ok Nothing
    decodeString (maybe (field "height" float)) json == Ok Nothing

    decodeString (field "age"    (maybe int  )) json == Ok (Just 42)
    decodeString (field "name"   (maybe int  )) json == Ok Nothing
    decodeString (field "height" (maybe float)) json == Err ...

Notice the last example! It is saying we *must* have a field named `height` and
the content *may* be a float. There is no `height` field, so the decoder fails.

Point is, `maybe` will make exactly what it contains conditional. For optional
fields, this means you probably want it *outside* a use of `field` or `at`.
-}
maybe : Elm.Expression -> Elm.Expression
maybe arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "maybe"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.namedWith
                        (Elm.moduleName [ "Maybe" ])
                        "Maybe"
                        [ Type.var "a" ]
                    ]
                )
            )
        )
        [ arg1 ]


{-| Try a bunch of different decoders. This can be useful if the JSON may come
in a couple different formats. For example, say you want to read an array of
numbers, but some of them are `null`.

    import String

    badInt : Decoder Int
    badInt =
      oneOf [ int, null 0 ]

    -- decodeString (list badInt) "[1,2,null,4]" == Ok [1,2,0,4]

Why would someone generate JSON like this? Questions like this are not good
for your health. The point is that you can use `oneOf` to handle situations
like this!

You could also use `oneOf` to help version your data. Try the latest format,
then a few older ones that you still support. You could use `andThen` to be
even more particular if you wanted.
-}
oneOf : Elm.Expression -> Elm.Expression
oneOf arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "oneOf"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "List" ])
                    "List"
                    [ Type.namedWith
                        (Elm.moduleName [ "Json", "Decode" ])
                        "Decoder"
                        [ Type.var "a" ]
                    ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1 ]


{-| Parse the given string into a JSON value and then run the `Decoder` on it.
This will fail if the string is not well-formed JSON or if the `Decoder`
fails for some reason.

    decodeString int "4"     == Ok 4
    decodeString int "1 + 2" == Err ...
-}
decodeString : Elm.Expression -> Elm.Expression -> Elm.Expression
decodeString arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "decodeString"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith (Elm.moduleName [ "String" ]) "String" []
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Result" ])
                    "Result"
                    [ Type.namedWith
                        (Elm.moduleName [ "Json", "Decode" ])
                        "Error"
                        []
                    , Type.var "a"
                    ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Run a `Decoder` on some JSON `Value`. You can send these JSON values
through ports, so that is probably the main time you would use this function.
-}
decodeValue : Elm.Expression -> Elm.Expression -> Elm.Expression
decodeValue arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "decodeValue"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Value"
                    []
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Result" ])
                    "Result"
                    [ Type.namedWith
                        (Elm.moduleName [ "Json", "Decode" ])
                        "Error"
                        []
                    , Type.var "a"
                    ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Represents a JavaScript value.
-}
aliasValue : { annotation : Type.Annotation }
aliasValue =
    { annotation = Type.named moduleName_ "Value" }


{-| A structured error describing exactly how the decoder failed. You can use
this to create more elaborate visualizations of a decoder problem. For example,
you could show the entire JSON object and show the part causing the failure in
red.
-}
typeError :
    { annotation : Type.Annotation
    , field : Elm.Expression
    , index : Elm.Expression
    , oneOf : Elm.Expression
    , failure : Elm.Expression
    }
typeError =
    { annotation = Type.named moduleName_ "Error"
    , field =
        Elm.valueWith
            moduleName_
            "Field"
            (Type.namedWith (Elm.moduleName []) "Error" [])
    , index =
        Elm.valueWith
            moduleName_
            "Index"
            (Type.namedWith (Elm.moduleName []) "Error" [])
    , oneOf =
        Elm.valueWith
            moduleName_
            "OneOf"
            (Type.namedWith (Elm.moduleName []) "Error" [])
    , failure =
        Elm.valueWith
            moduleName_
            "Failure"
            (Type.namedWith (Elm.moduleName []) "Error" [])
    }


{-| Convert a decoding error into a `String` that is nice for debugging.

It produces multiple lines of output, so you may want to peek at it with
something like this:

    import Html
    import Json.Decode as Decode

    errorToHtml : Decode.Error -> Html.Html msg
    errorToHtml error =
      Html.pre [] [ Html.text (Decode.errorToString error) ]

**Note:** It would be cool to do nicer coloring and fancier HTML, but I wanted
to avoid having an `elm/html` dependency for now. It is totally possible to
crawl the `Error` structure and create this separately though!
-}
errorToString : Elm.Expression -> Elm.Expression
errorToString arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "errorToString"
            (Type.function
                [ Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Error"
                    []
                ]
                (Type.namedWith (Elm.moduleName [ "String" ]) "String" [])
            )
        )
        [ arg1 ]


{-| Transform a decoder. Maybe you just want to know the length of a string:

    import String

    stringLength : Decoder Int
    stringLength =
      map String.length string

It is often helpful to use `map` with `oneOf`, like when defining `nullable`:

    nullable : Decoder a -> Decoder (Maybe a)
    nullable decoder =
      oneOf
        [ null Nothing
        , map Just decoder
        ]
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Try two decoders and then combine the result. We can use this to decode
objects with many fields:

    type alias Point = { x : Float, y : Float }

    point : Decoder Point
    point =
      map2 Point
        (field "x" float)
        (field "y" float)

    -- decodeString point """{ "x": 3, "y": 4 }""" == Ok { x = 3, y = 4 }

It tries each individual decoder and puts the result together with the `Point`
constructor.
-}
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
                [ Type.function
                    [ Type.var "a", Type.var "b" ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-| Try three decoders and then combine the result. We can use this to decode
objects with many fields:

    type alias Person = { name : String, age : Int, height : Float }

    person : Decoder Person
    person =
      map3 Person
        (at ["name"] string)
        (at ["info","age"] int)
        (at ["info","height"] float)

    -- json = """{ "name": "tom", "info": { "age": 42, "height": 1.8 } }"""
    -- decodeString person json == Ok { name = "tom", age = 42, height = 1.8 }

Like `map2` it tries each decoder in order and then give the results to the
`Person` constructor. That can be any function though!
-}
map3 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map3 arg1 arg2 arg3 arg4 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map3"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c" ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass, arg2, arg3, arg4 ]


{-|-}
map4 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map4 arg1 arg2 arg3 arg4 arg5 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map4"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c", Type.var "d" ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "d" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass, arg2, arg3, arg4, arg5 ]


{-|-}
map5 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map5 arg1 arg2 arg3 arg4 arg5 arg6 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map5"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "e" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        ]


{-|-}
map6 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map6 arg1 arg2 arg3 arg4 arg5 arg6 arg7 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map6"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "f" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        , arg7
        ]


{-|-}
map7 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map7 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map7"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    , Type.var "g"
                    ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "f" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "g" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        , arg7
        , arg8
        ]


{-|-}
map8 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map8 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map8"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    , Type.var "g"
                    , Type.var "h"
                    ]
                    (Type.var "value")
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "f" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "g" ]
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "h" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        , arg7
        , arg8
        , arg9
        ]


{-| Sometimes you have JSON with recursive structure, like nested comments.
You can use `lazy` to make sure your decoder unrolls lazily.

    type alias Comment =
      { message : String
      , responses : Responses
      }

    type Responses = Responses (List Comment)

    comment : Decoder Comment
    comment =
      map2 Comment
        (field "message" string)
        (field "responses" (map Responses (list (lazy (\_ -> comment)))))

If we had said `list comment` instead, we would start expanding the value
infinitely. What is a `comment`? It is a decoder for objects where the
`responses` field contains comments. What is a `comment` though? Etc.

By using `list (lazy (\_ -> comment))` we make sure the decoder only expands
to be as deep as the JSON we are given. You can read more about recursive data
structures [here][].

[here]: https://github.com/elm/compiler/blob/master/hints/recursive-alias.md
-}
lazy : (Elm.Expression -> Elm.Expression) -> Elm.Expression
lazy arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "lazy"
            (Type.function
                [ Type.function
                    [ Type.unit ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Decode" ])
                        "Decoder"
                        [ Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1 Elm.pass ]


{-| Do not do anything with a JSON value, just bring it into Elm as a `Value`.
This can be useful if you have particularly complex data that you would like to
deal with later. Or if you are going to send it out a port and do not care
about its structure.
-}
value : Elm.Expression
value =
    Elm.valueWith
        moduleName_
        "value"
        (Type.namedWith
            (Elm.moduleName [ "Json", "Decode" ])
            "Decoder"
            [ Type.namedWith (Elm.moduleName [ "Json", "Decode" ]) "Value" [] ]
        )


{-| Decode a `null` value into some Elm value.

    decodeString (null False) "null" == Ok False
    decodeString (null 42) "null"    == Ok 42
    decodeString (null 42) "42"      == Err ..
    decodeString (null 42) "false"   == Err ..

So if you ever see a `null`, this will return whatever value you specified.
-}
null : Elm.Expression -> Elm.Expression
null arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "null"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1 ]


{-| Ignore the JSON and produce a certain Elm value.

    decodeString (succeed 42) "true"    == Ok 42
    decodeString (succeed 42) "[1,2,3]" == Ok 42
    decodeString (succeed 42) "hello"   == Err ... -- this is not a valid JSON string

This is handy when used with `oneOf` or `andThen`.
-}
succeed : Elm.Expression -> Elm.Expression
succeed arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1 ]


{-| Ignore the JSON and make the decoder fail. This is handy when used with
`oneOf` or `andThen` where you want to give a custom error message in some
case.

See the [`andThen`](#andThen) docs for an example.
-}
fail : Elm.Expression -> Elm.Expression
fail arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fail"
            (Type.function
                [ Type.namedWith (Elm.moduleName [ "String" ]) "String" [] ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1 ]


{-| Create decoders that depend on previous results. If you are creating
versioned data, you might do something like this:

    info : Decoder Info
    info =
      field "version" int
        |> andThen infoHelp

    infoHelp : Int -> Decoder Info
    infoHelp version =
      case version of
        4 ->
          infoDecoder4

        3 ->
          infoDecoder3

        _ ->
          fail <|
            "Trying to decode info, but version "
            ++ toString version ++ " is not supported."

    -- infoDecoder4 : Decoder Info
    -- infoDecoder3 : Decoder Info
-}
andThen : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
andThen arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        (Elm.moduleName [ "Json", "Decode" ])
                        "Decoder"
                        [ Type.var "b" ]
                    )
                , Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    (Elm.moduleName [ "Json", "Decode" ])
                    "Decoder"
                    [ Type.var "b" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]

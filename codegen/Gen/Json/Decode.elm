module Gen.Json.Decode exposing (andThen, annotation_, array, at, bool, call_, caseOf_, decodeString, decodeValue, dict, errorToString, fail, field, float, index, int, keyValuePairs, lazy, list, make_, map, map2, map3, map4, map5, map6, map7, map8, maybe, moduleName_, null, nullable, oneOf, oneOrMore, string, succeed, value, values_)

{-| 
@docs values_, call_, caseOf_, make_, annotation_, andThen, fail, succeed, null, value, lazy, map8, map7, map6, map5, map4, map3, map2, map, errorToString, decodeValue, decodeString, oneOf, maybe, index, at, field, oneOrMore, keyValuePairs, dict, array, list, nullable, float, int, bool, string, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Json", "Decode" ]


{-| Decode a JSON string into an Elm `String`.

    decodeString string "true"              == Err ...
    decodeString string "42"                == Err ...
    decodeString string "3.14"              == Err ...
    decodeString string "\"hello\""         == Ok "hello"
    decodeString string "{ \"hello\": 42 }" == Err ...

string: Json.Decode.Decoder String
-}
string : Elm.Expression
string =
    Elm.value
        { importFrom = [ "Json", "Decode" ]
        , name = "string"
        , annotation =
            Just (Type.namedWith [ "Json", "Decode" ] "Decoder" [ Type.string ])
        }


{-| Decode a JSON boolean into an Elm `Bool`.

    decodeString bool "true"              == Ok True
    decodeString bool "42"                == Err ...
    decodeString bool "3.14"              == Err ...
    decodeString bool "\"hello\""         == Err ...
    decodeString bool "{ \"hello\": 42 }" == Err ...

bool: Json.Decode.Decoder Bool
-}
bool : Elm.Expression
bool =
    Elm.value
        { importFrom = [ "Json", "Decode" ]
        , name = "bool"
        , annotation =
            Just (Type.namedWith [ "Json", "Decode" ] "Decoder" [ Type.bool ])
        }


{-| Decode a JSON number into an Elm `Int`.

    decodeString int "true"              == Err ...
    decodeString int "42"                == Ok 42
    decodeString int "3.14"              == Err ...
    decodeString int "\"hello\""         == Err ...
    decodeString int "{ \"hello\": 42 }" == Err ...

int: Json.Decode.Decoder Int
-}
int : Elm.Expression
int =
    Elm.value
        { importFrom = [ "Json", "Decode" ]
        , name = "int"
        , annotation =
            Just (Type.namedWith [ "Json", "Decode" ] "Decoder" [ Type.int ])
        }


{-| Decode a JSON number into an Elm `Float`.

    decodeString float "true"              == Err ..
    decodeString float "42"                == Ok 42
    decodeString float "3.14"              == Ok 3.14
    decodeString float "\"hello\""         == Err ...
    decodeString float "{ \"hello\": 42 }" == Err ...

float: Json.Decode.Decoder Float
-}
float : Elm.Expression
float =
    Elm.value
        { importFrom = [ "Json", "Decode" ]
        , name = "float"
        , annotation =
            Just (Type.namedWith [ "Json", "Decode" ] "Decoder" [ Type.float ])
        }


{-| Decode a nullable JSON value into an Elm value.

    decodeString (nullable int) "13"    == Ok (Just 13)
    decodeString (nullable int) "42"    == Ok (Just 42)
    decodeString (nullable int) "null"  == Ok Nothing
    decodeString (nullable int) "true"  == Err ..

nullable: Json.Decode.Decoder a -> Json.Decode.Decoder (Maybe a)
-}
nullable : Elm.Expression -> Elm.Expression
nullable nullableArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "nullable"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.maybe (Type.var "a") ]
                        )
                    )
            }
        )
        [ nullableArg ]


{-| Decode a JSON array into an Elm `List`.

    decodeString (list int) "[1,2,3]"       == Ok [1,2,3]
    decodeString (list bool) "[true,false]" == Ok [True,False]

list: Json.Decode.Decoder a -> Json.Decode.Decoder (List a)
-}
list : Elm.Expression -> Elm.Expression
list listArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "list"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.list (Type.var "a") ]
                        )
                    )
            }
        )
        [ listArg ]


{-| Decode a JSON array into an Elm `Array`.

    decodeString (array int) "[1,2,3]"       == Ok (Array.fromList [1,2,3])
    decodeString (array bool) "[true,false]" == Ok (Array.fromList [True,False])

array: Json.Decode.Decoder a -> Json.Decode.Decoder (Array.Array a)
-}
array : Elm.Expression -> Elm.Expression
array arrayArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "array"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.namedWith
                                [ "Array" ]
                                "Array"
                                [ Type.var "a" ]
                            ]
                        )
                    )
            }
        )
        [ arrayArg ]


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

dict: Json.Decode.Decoder a -> Json.Decode.Decoder (Dict.Dict String a)
-}
dict : Elm.Expression -> Elm.Expression
dict dictArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "dict"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.namedWith
                                [ "Dict" ]
                                "Dict"
                                [ Type.string, Type.var "a" ]
                            ]
                        )
                    )
            }
        )
        [ dictArg ]


{-| Decode a JSON object into an Elm `List` of pairs.

    decodeString (keyValuePairs int) "{ \"alice\": 42, \"bob\": 99 }"
      == Ok [("alice", 42), ("bob", 99)]

keyValuePairs: Json.Decode.Decoder a -> Json.Decode.Decoder (List ( String, a ))
-}
keyValuePairs : Elm.Expression -> Elm.Expression
keyValuePairs keyValuePairsArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "keyValuePairs"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.list (Type.tuple Type.string (Type.var "a"))
                            ]
                        )
                    )
            }
        )
        [ keyValuePairsArg ]


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

oneOrMore: (a -> List a -> value) -> Json.Decode.Decoder a -> Json.Decode.Decoder value
-}
oneOrMore :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
oneOrMore oneOrMoreArg oneOrMoreArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "oneOrMore"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a", Type.list (Type.var "a") ]
                            (Type.var "value")
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced
            "oneOrMoreUnpack"
            (\functionReducedUnpack ->
                Elm.functionReduced
                    "unpack"
                    (oneOrMoreArg functionReducedUnpack)
            )
        , oneOrMoreArg0
        ]


{-| Decode a JSON object, requiring a particular field.

    decodeString (field "x" int) "{ \"x\": 3 }"            == Ok 3
    decodeString (field "x" int) "{ \"x\": 3, \"y\": 4 }"  == Ok 3
    decodeString (field "x" int) "{ \"x\": true }"         == Err ...
    decodeString (field "x" int) "{ \"y\": 4 }"            == Err ...

    decodeString (field "name" string) "{ \"name\": \"tom\" }" == Ok "tom"

The object *can* have other fields. Lots of them! The only thing this decoder
cares about is if `x` is present and that the value there is an `Int`.

Check out [`map2`](#map2) to see how to decode multiple fields!

field: String -> Json.Decode.Decoder a -> Json.Decode.Decoder a
-}
field : String -> Elm.Expression -> Elm.Expression
field fieldArg fieldArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
        )
        [ Elm.string fieldArg, fieldArg0 ]


{-| Decode a nested JSON object, requiring certain fields.

    json = """{ "person": { "name": "tom", "age": 42 } }"""

    decodeString (at ["person", "name"] string) json  == Ok "tom"
    decodeString (at ["person", "age" ] int   ) json  == Ok "42

This is really just a shorthand for saying things like:

    field "person" (field "name" string) == at ["person","name"] string

at: List String -> Json.Decode.Decoder a -> Json.Decode.Decoder a
-}
at : List String -> Elm.Expression -> Elm.Expression
at atArg atArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "at"
            , annotation =
                Just
                    (Type.function
                        [ Type.list Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
        )
        [ Elm.list (List.map Elm.string atArg), atArg0 ]


{-| Decode a JSON array, requiring a particular index.

    json = """[ "alice", "bob", "chuck" ]"""

    decodeString (index 0 string) json  == Ok "alice"
    decodeString (index 1 string) json  == Ok "bob"
    decodeString (index 2 string) json  == Ok "chuck"
    decodeString (index 3 string) json  == Err ...

index: Int -> Json.Decode.Decoder a -> Json.Decode.Decoder a
-}
index : Int -> Elm.Expression -> Elm.Expression
index indexArg indexArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "index"
            , annotation =
                Just
                    (Type.function
                        [ Type.int
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
        )
        [ Elm.int indexArg, indexArg0 ]


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

maybe: Json.Decode.Decoder a -> Json.Decode.Decoder (Maybe a)
-}
maybe : Elm.Expression -> Elm.Expression
maybe maybeArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "maybe"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.maybe (Type.var "a") ]
                        )
                    )
            }
        )
        [ maybeArg ]


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

oneOf: List (Json.Decode.Decoder a) -> Json.Decode.Decoder a
-}
oneOf : List Elm.Expression -> Elm.Expression
oneOf oneOfArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "oneOf"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith
                                [ "Json", "Decode" ]
                                "Decoder"
                                [ Type.var "a" ]
                            )
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
        )
        [ Elm.list oneOfArg ]


{-| Parse the given string into a JSON value and then run the `Decoder` on it.
This will fail if the string is not well-formed JSON or if the `Decoder`
fails for some reason.

    decodeString int "4"     == Ok 4
    decodeString int "1 + 2" == Err ...

decodeString: Json.Decode.Decoder a -> String -> Result.Result Json.Decode.Error a
-}
decodeString : Elm.Expression -> String -> Elm.Expression
decodeString decodeStringArg decodeStringArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "decodeString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.string
                        ]
                        (Type.namedWith
                            [ "Result" ]
                            "Result"
                            [ Type.namedWith [ "Json", "Decode" ] "Error" []
                            , Type.var "a"
                            ]
                        )
                    )
            }
        )
        [ decodeStringArg, Elm.string decodeStringArg0 ]


{-| Run a `Decoder` on some JSON `Value`. You can send these JSON values
through ports, so that is probably the main time you would use this function.

decodeValue: Json.Decode.Decoder a -> Json.Decode.Value -> Result.Result Json.Decode.Error a
-}
decodeValue : Elm.Expression -> Elm.Expression -> Elm.Expression
decodeValue decodeValueArg decodeValueArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "decodeValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith [ "Json", "Decode" ] "Value" []
                        ]
                        (Type.namedWith
                            [ "Result" ]
                            "Result"
                            [ Type.namedWith [ "Json", "Decode" ] "Error" []
                            , Type.var "a"
                            ]
                        )
                    )
            }
        )
        [ decodeValueArg, decodeValueArg0 ]


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

errorToString: Json.Decode.Error -> String
-}
errorToString : Elm.Expression -> Elm.Expression
errorToString errorToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "errorToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Json", "Decode" ] "Error" [] ]
                        Type.string
                    )
            }
        )
        [ errorToStringArg ]


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

map: (a -> value) -> Json.Decode.Decoder a -> Json.Decode.Decoder value
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map mapArg mapArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "a" ] (Type.var "value")
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced "mapUnpack" mapArg, mapArg0 ]


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

map2: 
    (a -> b -> value)
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder b
    -> Json.Decode.Decoder value
-}
map2 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map2 map2Arg map2Arg0 map2Arg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map2"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a", Type.var "b" ]
                            (Type.var "value")
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced
            "map2Unpack"
            (\functionReducedUnpack ->
                Elm.functionReduced "unpack" (map2Arg functionReducedUnpack)
            )
        , map2Arg0
        , map2Arg1
        ]


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

map3: 
    (a -> b -> c -> value)
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder b
    -> Json.Decode.Decoder c
    -> Json.Decode.Decoder value
-}
map3 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map3 map3Arg map3Arg0 map3Arg1 map3Arg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map3"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a", Type.var "b", Type.var "c" ]
                            (Type.var "value")
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced
            "map3Unpack"
            (\functionReducedUnpack ->
                Elm.functionReduced
                    "unpack"
                    (\functionReducedUnpack0 ->
                        Elm.functionReduced
                            "unpack"
                            (map3Arg functionReducedUnpack
                                functionReducedUnpack0
                            )
                    )
            )
        , map3Arg0
        , map3Arg1
        , map3Arg2
        ]


{-| map4: 
    (a -> b -> c -> d -> value)
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder b
    -> Json.Decode.Decoder c
    -> Json.Decode.Decoder d
    -> Json.Decode.Decoder value
-}
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
map4 map4Arg map4Arg0 map4Arg1 map4Arg2 map4Arg3 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map4"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a"
                            , Type.var "b"
                            , Type.var "c"
                            , Type.var "d"
                            ]
                            (Type.var "value")
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "d" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced
            "map4Unpack"
            (\functionReducedUnpack ->
                Elm.functionReduced
                    "unpack"
                    (\functionReducedUnpack0 ->
                        Elm.functionReduced
                            "unpack"
                            (\functionReducedUnpack_2_1_2_0_2_0_2_0_0 ->
                                Elm.functionReduced
                                    "unpack"
                                    (map4Arg functionReducedUnpack
                                         functionReducedUnpack0
                                        functionReducedUnpack_2_1_2_0_2_0_2_0_0
                                    )
                            )
                    )
            )
        , map4Arg0
        , map4Arg1
        , map4Arg2
        , map4Arg3
        ]


{-| map5: 
    (a -> b -> c -> d -> e -> value)
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder b
    -> Json.Decode.Decoder c
    -> Json.Decode.Decoder d
    -> Json.Decode.Decoder e
    -> Json.Decode.Decoder value
-}
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
map5 map5Arg map5Arg0 map5Arg1 map5Arg2 map5Arg3 map5Arg4 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map5"
            , annotation =
                Just
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
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "d" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "e" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced
            "map5Unpack"
            (\functionReducedUnpack ->
                Elm.functionReduced
                    "unpack"
                    (\functionReducedUnpack0 ->
                        Elm.functionReduced
                            "unpack"
                            (\functionReducedUnpack_2_1_2_0_2_0_2_0_0 ->
                                Elm.functionReduced
                                    "unpack"
                                    (\functionReducedUnpack_2_1_2_1_2_0_2_0_2_0_0 ->
                                        Elm.functionReduced
                                            "unpack"
                                            (map5Arg functionReducedUnpack
                                                 functionReducedUnpack0
                                                 functionReducedUnpack_2_1_2_0_2_0_2_0_0
                                                functionReducedUnpack_2_1_2_1_2_0_2_0_2_0_0
                                            )
                                    )
                            )
                    )
            )
        , map5Arg0
        , map5Arg1
        , map5Arg2
        , map5Arg3
        , map5Arg4
        ]


{-| map6: 
    (a -> b -> c -> d -> e -> f -> value)
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder b
    -> Json.Decode.Decoder c
    -> Json.Decode.Decoder d
    -> Json.Decode.Decoder e
    -> Json.Decode.Decoder f
    -> Json.Decode.Decoder value
-}
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
map6 map6Arg map6Arg0 map6Arg1 map6Arg2 map6Arg3 map6Arg4 map6Arg5 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map6"
            , annotation =
                Just
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
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "d" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "e" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "f" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced
            "map6Unpack"
            (\functionReducedUnpack ->
                Elm.functionReduced
                    "unpack"
                    (\functionReducedUnpack0 ->
                        Elm.functionReduced
                            "unpack"
                            (\functionReducedUnpack_2_1_2_0_2_0_2_0_0 ->
                                Elm.functionReduced
                                    "unpack"
                                    (\functionReducedUnpack_2_1_2_1_2_0_2_0_2_0_0 ->
                                        Elm.functionReduced
                                            "unpack"
                                            (\functionReducedUnpack_2_1_2_1_2_1_2_0_2_0_2_0_0 ->
                                                Elm.functionReduced
                                                    "unpack"
                                                    (map6Arg
                                                         functionReducedUnpack
                                                         functionReducedUnpack0
                                                         functionReducedUnpack_2_1_2_0_2_0_2_0_0
                                                         functionReducedUnpack_2_1_2_1_2_0_2_0_2_0_0
                                                        functionReducedUnpack_2_1_2_1_2_1_2_0_2_0_2_0_0
                                                    )
                                            )
                                    )
                            )
                    )
            )
        , map6Arg0
        , map6Arg1
        , map6Arg2
        , map6Arg3
        , map6Arg4
        , map6Arg5
        ]


{-| map7: 
    (a -> b -> c -> d -> e -> f -> g -> value)
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder b
    -> Json.Decode.Decoder c
    -> Json.Decode.Decoder d
    -> Json.Decode.Decoder e
    -> Json.Decode.Decoder f
    -> Json.Decode.Decoder g
    -> Json.Decode.Decoder value
-}
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
map7 map7Arg map7Arg0 map7Arg1 map7Arg2 map7Arg3 map7Arg4 map7Arg5 map7Arg6 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map7"
            , annotation =
                Just
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
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "d" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "e" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "f" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "g" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced
            "map7Unpack"
            (\functionReducedUnpack ->
                Elm.functionReduced
                    "unpack"
                    (\functionReducedUnpack0 ->
                        Elm.functionReduced
                            "unpack"
                            (\functionReducedUnpack_2_1_2_0_2_0_2_0_0 ->
                                Elm.functionReduced
                                    "unpack"
                                    (\functionReducedUnpack_2_1_2_1_2_0_2_0_2_0_0 ->
                                        Elm.functionReduced
                                            "unpack"
                                            (\functionReducedUnpack_2_1_2_1_2_1_2_0_2_0_2_0_0 ->
                                                Elm.functionReduced
                                                    "unpack"
                                                    (\functionReducedUnpack_2_1_2_1_2_1_2_1_2_0_2_0_2_0_0 ->
                                                        Elm.functionReduced
                                                            "unpack"
                                                            (map7Arg
                                                                 functionReducedUnpack
                                                                 functionReducedUnpack0
                                                                 functionReducedUnpack_2_1_2_0_2_0_2_0_0
                                                                 functionReducedUnpack_2_1_2_1_2_0_2_0_2_0_0
                                                                 functionReducedUnpack_2_1_2_1_2_1_2_0_2_0_2_0_0
                                                                functionReducedUnpack_2_1_2_1_2_1_2_1_2_0_2_0_2_0_0
                                                            )
                                                    )
                                            )
                                    )
                            )
                    )
            )
        , map7Arg0
        , map7Arg1
        , map7Arg2
        , map7Arg3
        , map7Arg4
        , map7Arg5
        , map7Arg6
        ]


{-| map8: 
    (a -> b -> c -> d -> e -> f -> g -> h -> value)
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder b
    -> Json.Decode.Decoder c
    -> Json.Decode.Decoder d
    -> Json.Decode.Decoder e
    -> Json.Decode.Decoder f
    -> Json.Decode.Decoder g
    -> Json.Decode.Decoder h
    -> Json.Decode.Decoder value
-}
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
map8 map8Arg map8Arg0 map8Arg1 map8Arg2 map8Arg3 map8Arg4 map8Arg5 map8Arg6 map8Arg7 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map8"
            , annotation =
                Just
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
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "d" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "e" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "f" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "g" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "h" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced
            "map8Unpack"
            (\functionReducedUnpack ->
                Elm.functionReduced
                    "unpack"
                    (\functionReducedUnpack0 ->
                        Elm.functionReduced
                            "unpack"
                            (\functionReducedUnpack_2_1_2_0_2_0_2_0_0 ->
                                Elm.functionReduced
                                    "unpack"
                                    (\functionReducedUnpack_2_1_2_1_2_0_2_0_2_0_0 ->
                                        Elm.functionReduced
                                            "unpack"
                                            (\functionReducedUnpack_2_1_2_1_2_1_2_0_2_0_2_0_0 ->
                                                Elm.functionReduced
                                                    "unpack"
                                                    (\functionReducedUnpack_2_1_2_1_2_1_2_1_2_0_2_0_2_0_0 ->
                                                        Elm.functionReduced
                                                            "unpack"
                                                            (\functionReducedUnpack_2_1_2_1_2_1_2_1_2_1_2_0_2_0_2_0_0 ->
                                                                Elm.functionReduced
                                                                    "unpack"
                                                                    (map8Arg
                                                                         functionReducedUnpack
                                                                         functionReducedUnpack0
                                                                         functionReducedUnpack_2_1_2_0_2_0_2_0_0
                                                                         functionReducedUnpack_2_1_2_1_2_0_2_0_2_0_0
                                                                         functionReducedUnpack_2_1_2_1_2_1_2_0_2_0_2_0_0
                                                                         functionReducedUnpack_2_1_2_1_2_1_2_1_2_0_2_0_2_0_0
                                                                        functionReducedUnpack_2_1_2_1_2_1_2_1_2_1_2_0_2_0_2_0_0
                                                                    )
                                                            )
                                                    )
                                            )
                                    )
                            )
                    )
            )
        , map8Arg0
        , map8Arg1
        , map8Arg2
        , map8Arg3
        , map8Arg4
        , map8Arg5
        , map8Arg6
        , map8Arg7
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

lazy: (() -> Json.Decode.Decoder a) -> Json.Decode.Decoder a
-}
lazy : (Elm.Expression -> Elm.Expression) -> Elm.Expression
lazy lazyArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "lazy"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.unit ]
                            (Type.namedWith
                                [ "Json", "Decode" ]
                                "Decoder"
                                [ Type.var "a" ]
                            )
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced "lazyUnpack" lazyArg ]


{-| Do not do anything with a JSON value, just bring it into Elm as a `Value`.
This can be useful if you have particularly complex data that you would like to
deal with later. Or if you are going to send it out a port and do not care
about its structure.

value: Json.Decode.Decoder Json.Decode.Value
-}
value : Elm.Expression
value =
    Elm.value
        { importFrom = [ "Json", "Decode" ]
        , name = "value"
        , annotation =
            Just
                (Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.namedWith [ "Json", "Decode" ] "Value" [] ]
                )
        }


{-| Decode a `null` value into some Elm value.

    decodeString (null False) "null" == Ok False
    decodeString (null 42) "null"    == Ok 42
    decodeString (null 42) "42"      == Err ..
    decodeString (null 42) "false"   == Err ..

So if you ever see a `null`, this will return whatever value you specified.

null: a -> Json.Decode.Decoder a
-}
null : Elm.Expression -> Elm.Expression
null nullArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "null"
            , annotation =
                Just
                    (Type.function
                        [ Type.var "a" ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
        )
        [ nullArg ]


{-| Ignore the JSON and produce a certain Elm value.

    decodeString (succeed 42) "true"    == Ok 42
    decodeString (succeed 42) "[1,2,3]" == Ok 42
    decodeString (succeed 42) "hello"   == Err ... -- this is not a valid JSON string

This is handy when used with `oneOf` or `andThen`.

succeed: a -> Json.Decode.Decoder a
-}
succeed : Elm.Expression -> Elm.Expression
succeed succeedArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "succeed"
            , annotation =
                Just
                    (Type.function
                        [ Type.var "a" ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
        )
        [ succeedArg ]


{-| Ignore the JSON and make the decoder fail. This is handy when used with
`oneOf` or `andThen` where you want to give a custom error message in some
case.

See the [`andThen`](#andThen) docs for an example.

fail: String -> Json.Decode.Decoder a
-}
fail : String -> Elm.Expression
fail failArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "fail"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
        )
        [ Elm.string failArg ]


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

andThen: (a -> Json.Decode.Decoder b) -> Json.Decode.Decoder a -> Json.Decode.Decoder b
-}
andThen : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
andThen andThenArg andThenArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "andThen"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith
                                [ "Json", "Decode" ]
                                "Decoder"
                                [ Type.var "b" ]
                            )
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
        )
        [ Elm.functionReduced "andThenUnpack" andThenArg, andThenArg0 ]


annotation_ :
    { decoder : Type.Annotation -> Type.Annotation
    , value : Type.Annotation
    , error : Type.Annotation
    }
annotation_ =
    { decoder =
        \decoderArg0 ->
            Type.namedWith [ "Json", "Decode" ] "Decoder" [ decoderArg0 ]
    , value =
        Type.alias
            moduleName_
            "Value"
            []
            (Type.namedWith [ "Json", "Encode" ] "Value" [])
    , error = Type.namedWith [ "Json", "Decode" ] "Error" []
    }


make_ :
    { field : Elm.Expression -> Elm.Expression -> Elm.Expression
    , index : Elm.Expression -> Elm.Expression -> Elm.Expression
    , oneOf : Elm.Expression -> Elm.Expression
    , failure : Elm.Expression -> Elm.Expression -> Elm.Expression
    }
make_ =
    { field =
        \ar0 ar1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "Field"
                    , annotation = Just (Type.namedWith [] "Error" [])
                    }
                )
                [ ar0, ar1 ]
    , index =
        \ar0 ar1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "Index"
                    , annotation = Just (Type.namedWith [] "Error" [])
                    }
                )
                [ ar0, ar1 ]
    , oneOf =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "OneOf"
                    , annotation = Just (Type.namedWith [] "Error" [])
                    }
                )
                [ ar0 ]
    , failure =
        \ar0 ar1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "Failure"
                    , annotation = Just (Type.namedWith [] "Error" [])
                    }
                )
                [ ar0, ar1 ]
    }


caseOf_ :
    { error :
        Elm.Expression
        -> { errorTags_0_0
            | field : Elm.Expression -> Elm.Expression -> Elm.Expression
            , index : Elm.Expression -> Elm.Expression -> Elm.Expression
            , oneOf : Elm.Expression -> Elm.Expression
            , failure : Elm.Expression -> Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    }
caseOf_ =
    { error =
        \errorExpression errorTags ->
            Elm.Case.custom
                errorExpression
                (Type.namedWith [ "Json", "Decode" ] "Error" [])
                [ Elm.Case.branch2
                    "Field"
                    ( "string.String", Type.string )
                    ( "json.Decode.Error"
                    , Type.namedWith [ "Json", "Decode" ] "Error" []
                    )
                    errorTags.field
                , Elm.Case.branch2
                    "Index"
                    ( "basics.Int", Type.int )
                    ( "json.Decode.Error"
                    , Type.namedWith [ "Json", "Decode" ] "Error" []
                    )
                    errorTags.index
                , Elm.Case.branch1
                    "OneOf"
                    ( "list.List"
                    , Type.list (Type.namedWith [ "Json", "Decode" ] "Error" [])
                    )
                    errorTags.oneOf
                , Elm.Case.branch2
                    "Failure"
                    ( "string.String", Type.string )
                    ( "json.Decode.Value"
                    , Type.namedWith [ "Json", "Decode" ] "Value" []
                    )
                    errorTags.failure
                ]
    }


call_ :
    { nullable : Elm.Expression -> Elm.Expression
    , list : Elm.Expression -> Elm.Expression
    , array : Elm.Expression -> Elm.Expression
    , dict : Elm.Expression -> Elm.Expression
    , keyValuePairs : Elm.Expression -> Elm.Expression
    , oneOrMore : Elm.Expression -> Elm.Expression -> Elm.Expression
    , field : Elm.Expression -> Elm.Expression -> Elm.Expression
    , at : Elm.Expression -> Elm.Expression -> Elm.Expression
    , index : Elm.Expression -> Elm.Expression -> Elm.Expression
    , maybe : Elm.Expression -> Elm.Expression
    , oneOf : Elm.Expression -> Elm.Expression
    , decodeString : Elm.Expression -> Elm.Expression -> Elm.Expression
    , decodeValue : Elm.Expression -> Elm.Expression -> Elm.Expression
    , errorToString : Elm.Expression -> Elm.Expression
    , map : Elm.Expression -> Elm.Expression -> Elm.Expression
    , map2 :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , map3 :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , map4 :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , map5 :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , map6 :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , map7 :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , map8 :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , lazy : Elm.Expression -> Elm.Expression
    , null : Elm.Expression -> Elm.Expression
    , succeed : Elm.Expression -> Elm.Expression
    , fail : Elm.Expression -> Elm.Expression
    , andThen : Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { nullable =
        \nullableArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "nullable"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.maybe (Type.var "a") ]
                                )
                            )
                    }
                )
                [ nullableArg ]
    , list =
        \listArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "list"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.list (Type.var "a") ]
                                )
                            )
                    }
                )
                [ listArg ]
    , array =
        \arrayArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "array"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.namedWith
                                        [ "Array" ]
                                        "Array"
                                        [ Type.var "a" ]
                                    ]
                                )
                            )
                    }
                )
                [ arrayArg ]
    , dict =
        \dictArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "dict"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.namedWith
                                        [ "Dict" ]
                                        "Dict"
                                        [ Type.string, Type.var "a" ]
                                    ]
                                )
                            )
                    }
                )
                [ dictArg ]
    , keyValuePairs =
        \keyValuePairsArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "keyValuePairs"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.list
                                        (Type.tuple Type.string (Type.var "a"))
                                    ]
                                )
                            )
                    }
                )
                [ keyValuePairsArg ]
    , oneOrMore =
        \oneOrMoreArg oneOrMoreArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "oneOrMore"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a", Type.list (Type.var "a") ]
                                    (Type.var "value")
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ oneOrMoreArg, oneOrMoreArg0 ]
    , field =
        \fieldArg fieldArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "field"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                )
                            )
                    }
                )
                [ fieldArg, fieldArg0 ]
    , at =
        \atArg atArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "at"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list Type.string
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                )
                            )
                    }
                )
                [ atArg, atArg0 ]
    , index =
        \indexArg indexArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "index"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.int
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                )
                            )
                    }
                )
                [ indexArg, indexArg0 ]
    , maybe =
        \maybeArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "maybe"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.maybe (Type.var "a") ]
                                )
                            )
                    }
                )
                [ maybeArg ]
    , oneOf =
        \oneOfArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "oneOf"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.namedWith
                                        [ "Json", "Decode" ]
                                        "Decoder"
                                        [ Type.var "a" ]
                                    )
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                )
                            )
                    }
                )
                [ oneOfArg ]
    , decodeString =
        \decodeStringArg decodeStringArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "decodeString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.string
                                ]
                                (Type.namedWith
                                    [ "Result" ]
                                    "Result"
                                    [ Type.namedWith
                                        [ "Json", "Decode" ]
                                        "Error"
                                        []
                                    , Type.var "a"
                                    ]
                                )
                            )
                    }
                )
                [ decodeStringArg, decodeStringArg0 ]
    , decodeValue =
        \decodeValueArg decodeValueArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "decodeValue"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith [ "Json", "Decode" ] "Value" []
                                ]
                                (Type.namedWith
                                    [ "Result" ]
                                    "Result"
                                    [ Type.namedWith
                                        [ "Json", "Decode" ]
                                        "Error"
                                        []
                                    , Type.var "a"
                                    ]
                                )
                            )
                    }
                )
                [ decodeValueArg, decodeValueArg0 ]
    , errorToString =
        \errorToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "errorToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "Json", "Decode" ] "Error" []
                                ]
                                Type.string
                            )
                    }
                )
                [ errorToStringArg ]
    , map =
        \mapArg mapArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "map"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a" ]
                                    (Type.var "value")
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ mapArg, mapArg0 ]
    , map2 =
        \map2Arg map2Arg0 map2Arg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "map2"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a", Type.var "b" ]
                                    (Type.var "value")
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ map2Arg, map2Arg0, map2Arg1 ]
    , map3 =
        \map3Arg map3Arg0 map3Arg1 map3Arg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "map3"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a", Type.var "b", Type.var "c" ]
                                    (Type.var "value")
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "c" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ map3Arg, map3Arg0, map3Arg1, map3Arg2 ]
    , map4 =
        \map4Arg map4Arg0 map4Arg1 map4Arg2 map4Arg3 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "map4"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a"
                                    , Type.var "b"
                                    , Type.var "c"
                                    , Type.var "d"
                                    ]
                                    (Type.var "value")
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "c" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "d" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ map4Arg, map4Arg0, map4Arg1, map4Arg2, map4Arg3 ]
    , map5 =
        \map5Arg map5Arg0 map5Arg1 map5Arg2 map5Arg3 map5Arg4 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "map5"
                    , annotation =
                        Just
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
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "c" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "d" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "e" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ map5Arg, map5Arg0, map5Arg1, map5Arg2, map5Arg3, map5Arg4 ]
    , map6 =
        \map6Arg map6Arg0 map6Arg1 map6Arg2 map6Arg3 map6Arg4 map6Arg5 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "map6"
                    , annotation =
                        Just
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
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "c" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "d" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "e" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "f" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ map6Arg
                , map6Arg0
                , map6Arg1
                , map6Arg2
                , map6Arg3
                , map6Arg4
                , map6Arg5
                ]
    , map7 =
        \map7Arg map7Arg0 map7Arg1 map7Arg2 map7Arg3 map7Arg4 map7Arg5 map7Arg6 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "map7"
                    , annotation =
                        Just
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
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "c" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "d" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "e" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "f" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "g" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ map7Arg
                , map7Arg0
                , map7Arg1
                , map7Arg2
                , map7Arg3
                , map7Arg4
                , map7Arg5
                , map7Arg6
                ]
    , map8 =
        \map8Arg map8Arg0 map8Arg1 map8Arg2 map8Arg3 map8Arg4 map8Arg5 map8Arg6 map8Arg7 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "map8"
                    , annotation =
                        Just
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
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "c" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "d" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "e" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "f" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "g" ]
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "h" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "value" ]
                                )
                            )
                    }
                )
                [ map8Arg
                , map8Arg0
                , map8Arg1
                , map8Arg2
                , map8Arg3
                , map8Arg4
                , map8Arg5
                , map8Arg6
                , map8Arg7
                ]
    , lazy =
        \lazyArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "lazy"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.unit ]
                                    (Type.namedWith
                                        [ "Json", "Decode" ]
                                        "Decoder"
                                        [ Type.var "a" ]
                                    )
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                )
                            )
                    }
                )
                [ lazyArg ]
    , null =
        \nullArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "null"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.var "a" ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                )
                            )
                    }
                )
                [ nullArg ]
    , succeed =
        \succeedArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "succeed"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.var "a" ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                )
                            )
                    }
                )
                [ succeedArg ]
    , fail =
        \failArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "fail"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                )
                            )
                    }
                )
                [ failArg ]
    , andThen =
        \andThenArg andThenArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Json", "Decode" ]
                    , name = "andThen"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.function
                                    [ Type.var "a" ]
                                    (Type.namedWith
                                        [ "Json", "Decode" ]
                                        "Decoder"
                                        [ Type.var "b" ]
                                    )
                                , Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "a" ]
                                ]
                                (Type.namedWith
                                    [ "Json", "Decode" ]
                                    "Decoder"
                                    [ Type.var "b" ]
                                )
                            )
                    }
                )
                [ andThenArg, andThenArg0 ]
    }


values_ :
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
values_ =
    { string =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "string"
            , annotation =
                Just
                    (Type.namedWith
                        [ "Json", "Decode" ]
                        "Decoder"
                        [ Type.string ]
                    )
            }
    , bool =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "bool"
            , annotation =
                Just
                    (Type.namedWith [ "Json", "Decode" ] "Decoder" [ Type.bool ]
                    )
            }
    , int =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "int"
            , annotation =
                Just
                    (Type.namedWith [ "Json", "Decode" ] "Decoder" [ Type.int ])
            }
    , float =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "float"
            , annotation =
                Just
                    (Type.namedWith
                        [ "Json", "Decode" ]
                        "Decoder"
                        [ Type.float ]
                    )
            }
    , nullable =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "nullable"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.maybe (Type.var "a") ]
                        )
                    )
            }
    , list =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "list"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.list (Type.var "a") ]
                        )
                    )
            }
    , array =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "array"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.namedWith
                                [ "Array" ]
                                "Array"
                                [ Type.var "a" ]
                            ]
                        )
                    )
            }
    , dict =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "dict"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.namedWith
                                [ "Dict" ]
                                "Dict"
                                [ Type.string, Type.var "a" ]
                            ]
                        )
                    )
            }
    , keyValuePairs =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "keyValuePairs"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.list (Type.tuple Type.string (Type.var "a"))
                            ]
                        )
                    )
            }
    , oneOrMore =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "oneOrMore"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a", Type.list (Type.var "a") ]
                            (Type.var "value")
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
    , field =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
    , at =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "at"
            , annotation =
                Just
                    (Type.function
                        [ Type.list Type.string
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
    , index =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "index"
            , annotation =
                Just
                    (Type.function
                        [ Type.int
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
    , maybe =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "maybe"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.maybe (Type.var "a") ]
                        )
                    )
            }
    , oneOf =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "oneOf"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith
                                [ "Json", "Decode" ]
                                "Decoder"
                                [ Type.var "a" ]
                            )
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
    , decodeString =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "decodeString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.string
                        ]
                        (Type.namedWith
                            [ "Result" ]
                            "Result"
                            [ Type.namedWith [ "Json", "Decode" ] "Error" []
                            , Type.var "a"
                            ]
                        )
                    )
            }
    , decodeValue =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "decodeValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith [ "Json", "Decode" ] "Value" []
                        ]
                        (Type.namedWith
                            [ "Result" ]
                            "Result"
                            [ Type.namedWith [ "Json", "Decode" ] "Error" []
                            , Type.var "a"
                            ]
                        )
                    )
            }
    , errorToString =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "errorToString"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "Json", "Decode" ] "Error" [] ]
                        Type.string
                    )
            }
    , map =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map"
            , annotation =
                Just
                    (Type.function
                        [ Type.function [ Type.var "a" ] (Type.var "value")
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
    , map2 =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map2"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a", Type.var "b" ]
                            (Type.var "value")
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
    , map3 =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map3"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a", Type.var "b", Type.var "c" ]
                            (Type.var "value")
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
    , map4 =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map4"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a"
                            , Type.var "b"
                            , Type.var "c"
                            , Type.var "d"
                            ]
                            (Type.var "value")
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "d" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
    , map5 =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map5"
            , annotation =
                Just
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
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "d" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "e" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
    , map6 =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map6"
            , annotation =
                Just
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
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "d" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "e" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "f" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
    , map7 =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map7"
            , annotation =
                Just
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
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "d" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "e" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "f" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "g" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
    , map8 =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "map8"
            , annotation =
                Just
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
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "c" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "d" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "e" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "f" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "g" ]
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "h" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "value" ]
                        )
                    )
            }
    , lazy =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "lazy"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.unit ]
                            (Type.namedWith
                                [ "Json", "Decode" ]
                                "Decoder"
                                [ Type.var "a" ]
                            )
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
    , value =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "value"
            , annotation =
                Just
                    (Type.namedWith
                        [ "Json", "Decode" ]
                        "Decoder"
                        [ Type.namedWith [ "Json", "Decode" ] "Value" [] ]
                    )
            }
    , null =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "null"
            , annotation =
                Just
                    (Type.function
                        [ Type.var "a" ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
    , succeed =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "succeed"
            , annotation =
                Just
                    (Type.function
                        [ Type.var "a" ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
    , fail =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "fail"
            , annotation =
                Just
                    (Type.function
                        [ Type.string ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        )
                    )
            }
    , andThen =
        Elm.value
            { importFrom = [ "Json", "Decode" ]
            , name = "andThen"
            , annotation =
                Just
                    (Type.function
                        [ Type.function
                            [ Type.var "a" ]
                            (Type.namedWith
                                [ "Json", "Decode" ]
                                "Decoder"
                                [ Type.var "b" ]
                            )
                        , Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "a" ]
                        ]
                        (Type.namedWith
                            [ "Json", "Decode" ]
                            "Decoder"
                            [ Type.var "b" ]
                        )
                    )
            }
    }



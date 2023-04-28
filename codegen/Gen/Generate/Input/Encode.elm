module Gen.Generate.Input.Encode exposing (annotation_, call_, fullRecordToInputObject, make_, moduleName_, scalarType, toInputObject, toInputRecordAlias, toNulls, toOneOfHelper, toOneOfNulls, toOptionHelpers, toRecordInput, toRecordNulls, toRecordOptionals, values_)

{-| 
@docs values_, call_, make_, annotation_, fullRecordToInputObject, toRecordInput, toRecordOptionals, toRecordNulls, toInputRecordAlias, toInputObject, toOptionHelpers, toOneOfHelper, toOneOfNulls, toNulls, scalarType, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Generate", "Input", "Encode" ]


{-| scalarType: Namespace -> GraphQL.Schema.Wrapped -> String -> Type.Annotation -}
scalarType : Elm.Expression -> Elm.Expression -> String -> Elm.Expression
scalarType scalarTypeArg scalarTypeArg0 scalarTypeArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "scalarType"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.string
                        ]
                        (Type.namedWith [ "Type" ] "Annotation" [])
                    )
            }
        )
        [ scalarTypeArg, scalarTypeArg0, Elm.string scalarTypeArg1 ]


{-| toNulls: String -> List GraphQL.Schema.Field -> List Elm.Declaration -}
toNulls : String -> List Elm.Expression -> Elm.Expression
toNulls toNullsArg toNullsArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toNulls"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.list
                            (Type.namedWith [ "GraphQL", "Schema" ] "Field" [])
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ Elm.string toNullsArg, Elm.list toNullsArg0 ]


{-| toOneOfNulls: String -> List GraphQL.Schema.Field -> List Elm.Declaration -}
toOneOfNulls : String -> List Elm.Expression -> Elm.Expression
toOneOfNulls toOneOfNullsArg toOneOfNullsArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toOneOfNulls"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.list
                            (Type.namedWith [ "GraphQL", "Schema" ] "Field" [])
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ Elm.string toOneOfNullsArg, Elm.list toOneOfNullsArg0 ]


{-| toOneOfHelper: 
    Namespace
    -> GraphQL.Schema.Schema
    -> { a
        | fields : List { b | name : String, type_ : GraphQL.Schema.Type }
        , name : String
    }
    -> List Elm.Declaration
-}
toOneOfHelper :
    Elm.Expression
    -> Elm.Expression
    -> { a
        | fields : List { b | name : String, type_ : Elm.Expression }
        , name : String
    }
    -> Elm.Expression
toOneOfHelper toOneOfHelperArg toOneOfHelperArg0 toOneOfHelperArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toOneOfHelper"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.extensible
                            "a"
                            [ ( "fields"
                              , Type.list
                                    (Type.extensible
                                        "b"
                                        [ ( "name", Type.string )
                                        , ( "type_"
                                          , Type.namedWith
                                                [ "GraphQL", "Schema" ]
                                                "Type"
                                                []
                                          )
                                        ]
                                    )
                              )
                            , ( "name", Type.string )
                            ]
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ toOneOfHelperArg
        , toOneOfHelperArg0
        , Elm.record
            [ Tuple.pair
                "fields"
                (Elm.list
                    (List.map
                        (\unpack ->
                            Elm.record
                                [ Tuple.pair "name" (Elm.string unpack.name)
                                , Tuple.pair "type_" unpack.type_
                                ]
                        )
                        toOneOfHelperArg1.fields
                    )
                )
            , Tuple.pair "name" (Elm.string toOneOfHelperArg1.name)
            ]
        ]


{-| toOptionHelpers: 
    Namespace
    -> GraphQL.Schema.Schema
    -> { a
        | fields : List { b | name : String, type_ : GraphQL.Schema.Type }
        , name : String
    }
    -> List Elm.Declaration
-}
toOptionHelpers :
    Elm.Expression
    -> Elm.Expression
    -> { a
        | fields : List { b | name : String, type_ : Elm.Expression }
        , name : String
    }
    -> Elm.Expression
toOptionHelpers toOptionHelpersArg toOptionHelpersArg0 toOptionHelpersArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toOptionHelpers"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.extensible
                            "a"
                            [ ( "fields"
                              , Type.list
                                    (Type.extensible
                                        "b"
                                        [ ( "name", Type.string )
                                        , ( "type_"
                                          , Type.namedWith
                                                [ "GraphQL", "Schema" ]
                                                "Type"
                                                []
                                          )
                                        ]
                                    )
                              )
                            , ( "name", Type.string )
                            ]
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ toOptionHelpersArg
        , toOptionHelpersArg0
        , Elm.record
            [ Tuple.pair
                "fields"
                (Elm.list
                    (List.map
                        (\unpack ->
                            Elm.record
                                [ Tuple.pair "name" (Elm.string unpack.name)
                                , Tuple.pair "type_" unpack.type_
                                ]
                        )
                        toOptionHelpersArg1.fields
                    )
                )
            , Tuple.pair "name" (Elm.string toOptionHelpersArg1.name)
            ]
        ]


{-| {-| Create the initial `input` helper, which takes the required arguments and gives you the encoded type

    input :
        { url : String
        , overrideOneProductPerDomainAssumption : Bool
        }
        -> CreateServiceEntityInput

-}

toInputObject: 
    Namespace
    -> GraphQL.Schema.Schema
    -> { a
        | fields : List { b | name : String, type_ : GraphQL.Schema.Type }
        , name : String
    }
    -> Elm.Declaration
-}
toInputObject :
    Elm.Expression
    -> Elm.Expression
    -> { a
        | fields : List { b | name : String, type_ : Elm.Expression }
        , name : String
    }
    -> Elm.Expression
toInputObject toInputObjectArg toInputObjectArg0 toInputObjectArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toInputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.extensible
                            "a"
                            [ ( "fields"
                              , Type.list
                                    (Type.extensible
                                        "b"
                                        [ ( "name", Type.string )
                                        , ( "type_"
                                          , Type.namedWith
                                                [ "GraphQL", "Schema" ]
                                                "Type"
                                                []
                                          )
                                        ]
                                    )
                              )
                            , ( "name", Type.string )
                            ]
                        ]
                        (Type.namedWith [ "Elm" ] "Declaration" [])
                    )
            }
        )
        [ toInputObjectArg
        , toInputObjectArg0
        , Elm.record
            [ Tuple.pair
                "fields"
                (Elm.list
                    (List.map
                        (\unpack ->
                            Elm.record
                                [ Tuple.pair "name" (Elm.string unpack.name)
                                , Tuple.pair "type_" unpack.type_
                                ]
                        )
                        toInputObjectArg1.fields
                    )
                )
            , Tuple.pair "name" (Elm.string toInputObjectArg1.name)
            ]
        ]


{-| toInputRecordAlias: 
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    -> List GraphQL.Schema.Argument
    -> Elm.Declaration
-}
toInputRecordAlias :
    Elm.Expression
    -> Elm.Expression
    -> String
    -> List Elm.Expression
    -> Elm.Expression
toInputRecordAlias toInputRecordAliasArg toInputRecordAliasArg0 toInputRecordAliasArg1 toInputRecordAliasArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toInputRecordAlias"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.string
                        , Type.list
                            (Type.namedWith
                                [ "GraphQL", "Schema" ]
                                "Argument"
                                []
                            )
                        ]
                        (Type.namedWith [ "Elm" ] "Declaration" [])
                    )
            }
        )
        [ toInputRecordAliasArg
        , toInputRecordAliasArg0
        , Elm.string toInputRecordAliasArg1
        , Elm.list toInputRecordAliasArg2
        ]


{-| toRecordNulls: List GraphQL.Schema.Argument -> List Elm.Declaration -}
toRecordNulls : List Elm.Expression -> Elm.Expression
toRecordNulls toRecordNullsArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toRecordNulls"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith
                                [ "GraphQL", "Schema" ]
                                "Argument"
                                []
                            )
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ Elm.list toRecordNullsArg ]


{-| toRecordOptionals: 
    Namespace
    -> GraphQL.Schema.Schema
    -> List GraphQL.Schema.Argument
    -> List Elm.Declaration
-}
toRecordOptionals :
    Elm.Expression -> Elm.Expression -> List Elm.Expression -> Elm.Expression
toRecordOptionals toRecordOptionalsArg toRecordOptionalsArg0 toRecordOptionalsArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toRecordOptionals"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.list
                            (Type.namedWith
                                [ "GraphQL", "Schema" ]
                                "Argument"
                                []
                            )
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
        )
        [ toRecordOptionalsArg
        , toRecordOptionalsArg0
        , Elm.list toRecordOptionalsArg1
        ]


{-| {-|

    Subtly different than `inputToInputObject`

    inputToInputObject will create a record instead of an opaque type.

    This is used for top level inputs such as the direct arguments
    to queries or the arguments to a query from a gql document.


    input :
        { url : String
        , overrideOneProductPerDomainAssumption : Bool
        }
        -> CreateServiceEntityInput

-}

toRecordInput: 
    Namespace
    -> GraphQL.Schema.Schema
    -> List GraphQL.Schema.Argument
    -> Elm.Declaration
-}
toRecordInput :
    Elm.Expression -> Elm.Expression -> List Elm.Expression -> Elm.Expression
toRecordInput toRecordInputArg toRecordInputArg0 toRecordInputArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toRecordInput"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.list
                            (Type.namedWith
                                [ "GraphQL", "Schema" ]
                                "Argument"
                                []
                            )
                        ]
                        (Type.namedWith [ "Elm" ] "Declaration" [])
                    )
            }
        )
        [ toRecordInputArg, toRecordInputArg0, Elm.list toRecordInputArg1 ]


{-| {-|

    This is for queries/mutations which take a fully realized optional record:


        { requiredField : Int
        , optionalField : Engine.Option Int
        }

    And render it into a field list:

        [("requiredField", Encode.int), ("optionalField", Encode.null)]

-}

fullRecordToInputObject: 
    Namespace
    -> GraphQL.Schema.Schema
    -> List GraphQL.Schema.Argument
    -> Elm.Expression
    -> Elm.Expression
-}
fullRecordToInputObject :
    Elm.Expression
    -> Elm.Expression
    -> List Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
fullRecordToInputObject fullRecordToInputObjectArg fullRecordToInputObjectArg0 fullRecordToInputObjectArg1 fullRecordToInputObjectArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "fullRecordToInputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.list
                            (Type.namedWith
                                [ "GraphQL", "Schema" ]
                                "Argument"
                                []
                            )
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
        )
        [ fullRecordToInputObjectArg
        , fullRecordToInputObjectArg0
        , Elm.list fullRecordToInputObjectArg1
        , fullRecordToInputObjectArg2
        ]


annotation_ : { namespace : Type.Annotation }
annotation_ =
    { namespace =
        Type.alias
            moduleName_
            "Namespace"
            []
            (Type.record
                [ ( "namespace", Type.string ), ( "enums", Type.string ) ]
            )
    }


make_ :
    { namespace :
        { namespace : Elm.Expression, enums : Elm.Expression } -> Elm.Expression
    }
make_ =
    { namespace =
        \namespace_args ->
            Elm.withType
                (Type.alias
                    [ "Generate", "Input", "Encode" ]
                    "Namespace"
                    []
                    (Type.record
                        [ ( "namespace", Type.string )
                        , ( "enums", Type.string )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "namespace" namespace_args.namespace
                    , Tuple.pair "enums" namespace_args.enums
                    ]
                )
    }


call_ :
    { scalarType :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , toNulls : Elm.Expression -> Elm.Expression -> Elm.Expression
    , toOneOfNulls : Elm.Expression -> Elm.Expression -> Elm.Expression
    , toOneOfHelper :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , toOptionHelpers :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , toInputObject :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , toInputRecordAlias :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , toRecordNulls : Elm.Expression -> Elm.Expression
    , toRecordOptionals :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , toRecordInput :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , fullRecordToInputObject :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    }
call_ =
    { scalarType =
        \scalarTypeArg scalarTypeArg0 scalarTypeArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input", "Encode" ]
                    , name = "scalarType"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Wrapped"
                                    []
                                , Type.string
                                ]
                                (Type.namedWith [ "Type" ] "Annotation" [])
                            )
                    }
                )
                [ scalarTypeArg, scalarTypeArg0, scalarTypeArg1 ]
    , toNulls =
        \toNullsArg toNullsArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input", "Encode" ]
                    , name = "toNulls"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.list
                                    (Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Field"
                                        []
                                    )
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ toNullsArg, toNullsArg0 ]
    , toOneOfNulls =
        \toOneOfNullsArg toOneOfNullsArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input", "Encode" ]
                    , name = "toOneOfNulls"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.list
                                    (Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Field"
                                        []
                                    )
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ toOneOfNullsArg, toOneOfNullsArg0 ]
    , toOneOfHelper =
        \toOneOfHelperArg toOneOfHelperArg0 toOneOfHelperArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input", "Encode" ]
                    , name = "toOneOfHelper"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.extensible
                                    "a"
                                    [ ( "fields"
                                      , Type.list
                                            (Type.extensible
                                                "b"
                                                [ ( "name", Type.string )
                                                , ( "type_"
                                                  , Type.namedWith
                                                        [ "GraphQL", "Schema" ]
                                                        "Type"
                                                        []
                                                  )
                                                ]
                                            )
                                      )
                                    , ( "name", Type.string )
                                    ]
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ toOneOfHelperArg, toOneOfHelperArg0, toOneOfHelperArg1 ]
    , toOptionHelpers =
        \toOptionHelpersArg toOptionHelpersArg0 toOptionHelpersArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input", "Encode" ]
                    , name = "toOptionHelpers"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.extensible
                                    "a"
                                    [ ( "fields"
                                      , Type.list
                                            (Type.extensible
                                                "b"
                                                [ ( "name", Type.string )
                                                , ( "type_"
                                                  , Type.namedWith
                                                        [ "GraphQL", "Schema" ]
                                                        "Type"
                                                        []
                                                  )
                                                ]
                                            )
                                      )
                                    , ( "name", Type.string )
                                    ]
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ toOptionHelpersArg, toOptionHelpersArg0, toOptionHelpersArg1 ]
    , toInputObject =
        \toInputObjectArg toInputObjectArg0 toInputObjectArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input", "Encode" ]
                    , name = "toInputObject"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.extensible
                                    "a"
                                    [ ( "fields"
                                      , Type.list
                                            (Type.extensible
                                                "b"
                                                [ ( "name", Type.string )
                                                , ( "type_"
                                                  , Type.namedWith
                                                        [ "GraphQL", "Schema" ]
                                                        "Type"
                                                        []
                                                  )
                                                ]
                                            )
                                      )
                                    , ( "name", Type.string )
                                    ]
                                ]
                                (Type.namedWith [ "Elm" ] "Declaration" [])
                            )
                    }
                )
                [ toInputObjectArg, toInputObjectArg0, toInputObjectArg1 ]
    , toInputRecordAlias =
        \toInputRecordAliasArg toInputRecordAliasArg0 toInputRecordAliasArg1 toInputRecordAliasArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input", "Encode" ]
                    , name = "toInputRecordAlias"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.string
                                , Type.list
                                    (Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Argument"
                                        []
                                    )
                                ]
                                (Type.namedWith [ "Elm" ] "Declaration" [])
                            )
                    }
                )
                [ toInputRecordAliasArg
                , toInputRecordAliasArg0
                , toInputRecordAliasArg1
                , toInputRecordAliasArg2
                ]
    , toRecordNulls =
        \toRecordNullsArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input", "Encode" ]
                    , name = "toRecordNulls"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Argument"
                                        []
                                    )
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ toRecordNullsArg ]
    , toRecordOptionals =
        \toRecordOptionalsArg toRecordOptionalsArg0 toRecordOptionalsArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input", "Encode" ]
                    , name = "toRecordOptionals"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.list
                                    (Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Argument"
                                        []
                                    )
                                ]
                                (Type.list
                                    (Type.namedWith [ "Elm" ] "Declaration" [])
                                )
                            )
                    }
                )
                [ toRecordOptionalsArg
                , toRecordOptionalsArg0
                , toRecordOptionalsArg1
                ]
    , toRecordInput =
        \toRecordInputArg toRecordInputArg0 toRecordInputArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input", "Encode" ]
                    , name = "toRecordInput"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.list
                                    (Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Argument"
                                        []
                                    )
                                ]
                                (Type.namedWith [ "Elm" ] "Declaration" [])
                            )
                    }
                )
                [ toRecordInputArg, toRecordInputArg0, toRecordInputArg1 ]
    , fullRecordToInputObject =
        \fullRecordToInputObjectArg fullRecordToInputObjectArg0 fullRecordToInputObjectArg1 fullRecordToInputObjectArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "Generate", "Input", "Encode" ]
                    , name = "fullRecordToInputObject"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Namespace" []
                                , Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.list
                                    (Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Argument"
                                        []
                                    )
                                , Type.namedWith [ "Elm" ] "Expression" []
                                ]
                                (Type.namedWith [ "Elm" ] "Expression" [])
                            )
                    }
                )
                [ fullRecordToInputObjectArg
                , fullRecordToInputObjectArg0
                , fullRecordToInputObjectArg1
                , fullRecordToInputObjectArg2
                ]
    }


values_ :
    { scalarType : Elm.Expression
    , toNulls : Elm.Expression
    , toOneOfNulls : Elm.Expression
    , toOneOfHelper : Elm.Expression
    , toOptionHelpers : Elm.Expression
    , toInputObject : Elm.Expression
    , toInputRecordAlias : Elm.Expression
    , toRecordNulls : Elm.Expression
    , toRecordOptionals : Elm.Expression
    , toRecordInput : Elm.Expression
    , fullRecordToInputObject : Elm.Expression
    }
values_ =
    { scalarType =
        Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "scalarType"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
                        , Type.string
                        ]
                        (Type.namedWith [ "Type" ] "Annotation" [])
                    )
            }
    , toNulls =
        Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toNulls"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.list
                            (Type.namedWith [ "GraphQL", "Schema" ] "Field" [])
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    , toOneOfNulls =
        Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toOneOfNulls"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.list
                            (Type.namedWith [ "GraphQL", "Schema" ] "Field" [])
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    , toOneOfHelper =
        Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toOneOfHelper"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.extensible
                            "a"
                            [ ( "fields"
                              , Type.list
                                    (Type.extensible
                                        "b"
                                        [ ( "name", Type.string )
                                        , ( "type_"
                                          , Type.namedWith
                                                [ "GraphQL", "Schema" ]
                                                "Type"
                                                []
                                          )
                                        ]
                                    )
                              )
                            , ( "name", Type.string )
                            ]
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    , toOptionHelpers =
        Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toOptionHelpers"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.extensible
                            "a"
                            [ ( "fields"
                              , Type.list
                                    (Type.extensible
                                        "b"
                                        [ ( "name", Type.string )
                                        , ( "type_"
                                          , Type.namedWith
                                                [ "GraphQL", "Schema" ]
                                                "Type"
                                                []
                                          )
                                        ]
                                    )
                              )
                            , ( "name", Type.string )
                            ]
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    , toInputObject =
        Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toInputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.extensible
                            "a"
                            [ ( "fields"
                              , Type.list
                                    (Type.extensible
                                        "b"
                                        [ ( "name", Type.string )
                                        , ( "type_"
                                          , Type.namedWith
                                                [ "GraphQL", "Schema" ]
                                                "Type"
                                                []
                                          )
                                        ]
                                    )
                              )
                            , ( "name", Type.string )
                            ]
                        ]
                        (Type.namedWith [ "Elm" ] "Declaration" [])
                    )
            }
    , toInputRecordAlias =
        Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toInputRecordAlias"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.string
                        , Type.list
                            (Type.namedWith
                                [ "GraphQL", "Schema" ]
                                "Argument"
                                []
                            )
                        ]
                        (Type.namedWith [ "Elm" ] "Declaration" [])
                    )
            }
    , toRecordNulls =
        Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toRecordNulls"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.namedWith
                                [ "GraphQL", "Schema" ]
                                "Argument"
                                []
                            )
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    , toRecordOptionals =
        Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toRecordOptionals"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.list
                            (Type.namedWith
                                [ "GraphQL", "Schema" ]
                                "Argument"
                                []
                            )
                        ]
                        (Type.list (Type.namedWith [ "Elm" ] "Declaration" []))
                    )
            }
    , toRecordInput =
        Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "toRecordInput"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.list
                            (Type.namedWith
                                [ "GraphQL", "Schema" ]
                                "Argument"
                                []
                            )
                        ]
                        (Type.namedWith [ "Elm" ] "Declaration" [])
                    )
            }
    , fullRecordToInputObject =
        Elm.value
            { importFrom = [ "Generate", "Input", "Encode" ]
            , name = "fullRecordToInputObject"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Namespace" []
                        , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.list
                            (Type.namedWith
                                [ "GraphQL", "Schema" ]
                                "Argument"
                                []
                            )
                        , Type.namedWith [ "Elm" ] "Expression" []
                        ]
                        (Type.namedWith [ "Elm" ] "Expression" [])
                    )
            }
    }



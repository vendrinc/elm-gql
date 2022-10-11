module Gen.GraphQL.Schema exposing (annotation_, call_, caseOf_, decoder, empty, getInner, getJsonValue, getWrap, kindToString, make_, mockScalar, moduleName_, typeToElmString, typeToString, values_)

{-| 
@docs values_, call_, caseOf_, make_, annotation_, getWrap, getInner, mockScalar, typeToElmString, typeToString, decoder, empty, getJsonValue, kindToString, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Schema" ]


{-| kindToString: Kind -> String -}
kindToString : Elm.Expression -> Elm.Expression
kindToString kindToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "kindToString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Kind" [] ] Type.string)
            }
        )
        [ kindToStringArg ]


{-| getJsonValue: 
    List ( String, String )
    -> String
    -> (Result Http.Error Json.Value -> msg)
    -> Cmd msg
-}
getJsonValue :
    List Elm.Expression
    -> String
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
getJsonValue getJsonValueArg getJsonValueArg0 getJsonValueArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "getJsonValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.tuple Type.string Type.string)
                        , Type.string
                        , Type.function
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [ "Http" ] "Error" []
                                , Type.namedWith [ "Json" ] "Value" []
                                ]
                            ]
                            (Type.var "msg")
                        ]
                        (Type.namedWith [] "Cmd" [ Type.var "msg" ])
                    )
            }
        )
        [ Elm.list getJsonValueArg
        , Elm.string getJsonValueArg0
        , Elm.functionReduced "getJsonValueUnpack" getJsonValueArg1
        ]


{-| empty: Schema -}
empty : Elm.Expression
empty =
    Elm.value
        { importFrom = [ "GraphQL", "Schema" ]
        , name = "empty"
        , annotation = Just (Type.namedWith [] "Schema" [])
        }


{-| decoder: Json.Decoder Schema -}
decoder : Elm.Expression
decoder =
    Elm.value
        { importFrom = [ "GraphQL", "Schema" ]
        , name = "decoder"
        , annotation =
            Just
                (Type.namedWith
                    [ "Json" ]
                    "Decoder"
                    [ Type.namedWith [] "Schema" [] ]
                )
        }


{-| typeToString: Type -> String -}
typeToString : Elm.Expression -> Elm.Expression
typeToString typeToStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "typeToString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Type" [] ] Type.string)
            }
        )
        [ typeToStringArg ]


{-| typeToElmString: Type -> String -}
typeToElmString : Elm.Expression -> Elm.Expression
typeToElmString typeToElmStringArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "typeToElmString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Type" [] ] Type.string)
            }
        )
        [ typeToElmStringArg ]


{-| mockScalar: Type -> Json.Encode.Value -}
mockScalar : Elm.Expression -> Elm.Expression
mockScalar mockScalarArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "mockScalar"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Type" [] ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ mockScalarArg ]


{-| getInner: Type -> Type -}
getInner : Elm.Expression -> Elm.Expression
getInner getInnerArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "getInner"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Type" [] ]
                        (Type.namedWith [] "Type" [])
                    )
            }
        )
        [ getInnerArg ]


{-| getWrap: Type -> Wrapped -}
getWrap : Elm.Expression -> Elm.Expression
getWrap getWrapArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "getWrap"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Type" [] ]
                        (Type.namedWith [] "Wrapped" [])
                    )
            }
        )
        [ getWrapArg ]


annotation_ :
    { mutation : Type.Annotation
    , query : Type.Annotation
    , inputObjectDetails : Type.Annotation
    , interfaceDetails : Type.Annotation
    , field : Type.Annotation
    , argument : Type.Annotation
    , objectDetails : Type.Annotation
    , variant : Type.Annotation
    , unionDetails : Type.Annotation
    , scalarDetails : Type.Annotation
    , schema : Type.Annotation
    , namespace : Type.Annotation
    , wrapped : Type.Annotation
    , type_ : Type.Annotation
    , kind : Type.Annotation
    }
annotation_ =
    { mutation =
        Type.alias moduleName_ "Mutation" [] (Type.namedWith [] "Field" [])
    , query = Type.alias moduleName_ "Query" [] (Type.namedWith [] "Field" [])
    , inputObjectDetails =
        Type.alias
            moduleName_
            "InputObjectDetails"
            []
            (Type.record
                [ ( "name", Type.string )
                , ( "description", Type.namedWith [] "Maybe" [ Type.string ] )
                , ( "fields", Type.list (Type.namedWith [] "Field" []) )
                , ( "isOneOf", Type.bool )
                ]
            )
    , interfaceDetails =
        Type.alias
            moduleName_
            "InterfaceDetails"
            []
            (Type.record
                [ ( "name", Type.string )
                , ( "description", Type.namedWith [] "Maybe" [ Type.string ] )
                , ( "fields", Type.list (Type.namedWith [] "Field" []) )
                , ( "implementedBy", Type.list (Type.namedWith [] "Kind" []) )
                ]
            )
    , field =
        Type.alias
            moduleName_
            "Field"
            []
            (Type.record
                [ ( "name", Type.string )
                , ( "deprecation", Type.namedWith [] "Deprecation" [] )
                , ( "description", Type.namedWith [] "Maybe" [ Type.string ] )
                , ( "arguments", Type.list (Type.namedWith [] "Argument" []) )
                , ( "type_", Type.namedWith [] "Type" [] )
                , ( "permissions"
                  , Type.list (Type.namedWith [] "Permission" [])
                  )
                ]
            )
    , argument =
        Type.alias
            moduleName_
            "Argument"
            []
            (Type.record
                [ ( "name", Type.string )
                , ( "description", Type.namedWith [] "Maybe" [ Type.string ] )
                , ( "type_", Type.namedWith [] "Type" [] )
                ]
            )
    , objectDetails =
        Type.alias
            moduleName_
            "ObjectDetails"
            []
            (Type.record
                [ ( "name", Type.string )
                , ( "description", Type.namedWith [] "Maybe" [ Type.string ] )
                , ( "fields", Type.list (Type.namedWith [] "Field" []) )
                , ( "interfaces", Type.list (Type.namedWith [] "Kind" []) )
                ]
            )
    , variant =
        Type.alias
            moduleName_
            "Variant"
            []
            (Type.record [ ( "kind", Type.namedWith [] "Kind" [] ) ])
    , unionDetails =
        Type.alias
            moduleName_
            "UnionDetails"
            []
            (Type.record
                [ ( "name", Type.string )
                , ( "description", Type.namedWith [] "Maybe" [ Type.string ] )
                , ( "variants", Type.list (Type.namedWith [] "Variant" []) )
                ]
            )
    , scalarDetails =
        Type.alias
            moduleName_
            "ScalarDetails"
            []
            (Type.record
                [ ( "name", Type.string )
                , ( "description", Type.namedWith [] "Maybe" [ Type.string ] )
                ]
            )
    , schema =
        Type.alias
            moduleName_
            "Schema"
            []
            (Type.record
                [ ( "queries"
                  , Type.namedWith
                        []
                        "Dict"
                        [ Type.namedWith [] "Ref" []
                        , Type.namedWith [] "Query" []
                        ]
                  )
                , ( "mutations"
                  , Type.namedWith
                        []
                        "Dict"
                        [ Type.namedWith [] "Ref" []
                        , Type.namedWith [] "Mutation" []
                        ]
                  )
                , ( "objects"
                  , Type.namedWith
                        []
                        "Dict"
                        [ Type.namedWith [] "Ref" []
                        , Type.namedWith [] "ObjectDetails" []
                        ]
                  )
                , ( "scalars"
                  , Type.namedWith
                        []
                        "Dict"
                        [ Type.namedWith [] "Ref" []
                        , Type.namedWith [] "ScalarDetails" []
                        ]
                  )
                , ( "inputObjects"
                  , Type.namedWith
                        []
                        "Dict"
                        [ Type.namedWith [] "Ref" []
                        , Type.namedWith [] "InputObjectDetails" []
                        ]
                  )
                , ( "enums"
                  , Type.namedWith
                        []
                        "Dict"
                        [ Type.namedWith [] "Ref" []
                        , Type.namedWith [] "EnumDetails" []
                        ]
                  )
                , ( "unions"
                  , Type.namedWith
                        []
                        "Dict"
                        [ Type.namedWith [] "Ref" []
                        , Type.namedWith [] "UnionDetails" []
                        ]
                  )
                , ( "interfaces"
                  , Type.namedWith
                        []
                        "Dict"
                        [ Type.namedWith [] "Ref" []
                        , Type.namedWith [] "InterfaceDetails" []
                        ]
                  )
                ]
            )
    , namespace =
        Type.alias
            moduleName_
            "Namespace"
            []
            (Type.record
                [ ( "namespace", Type.string ), ( "enums", Type.string ) ]
            )
    , wrapped = Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" []
    , type_ = Type.namedWith [ "GraphQL", "Schema" ] "Type" []
    , kind = Type.namedWith [ "GraphQL", "Schema" ] "Kind" []
    }


make_ :
    { inputObjectDetails :
        { name : Elm.Expression
        , description : Elm.Expression
        , fields : Elm.Expression
        , isOneOf : Elm.Expression
        }
        -> Elm.Expression
    , interfaceDetails :
        { name : Elm.Expression
        , description : Elm.Expression
        , fields : Elm.Expression
        , implementedBy : Elm.Expression
        }
        -> Elm.Expression
    , field :
        { name : Elm.Expression
        , deprecation : Elm.Expression
        , description : Elm.Expression
        , arguments : Elm.Expression
        , type_ : Elm.Expression
        , permissions : Elm.Expression
        }
        -> Elm.Expression
    , argument :
        { name : Elm.Expression
        , description : Elm.Expression
        , type_ : Elm.Expression
        }
        -> Elm.Expression
    , objectDetails :
        { name : Elm.Expression
        , description : Elm.Expression
        , fields : Elm.Expression
        , interfaces : Elm.Expression
        }
        -> Elm.Expression
    , variant : { kind : Elm.Expression } -> Elm.Expression
    , unionDetails :
        { name : Elm.Expression
        , description : Elm.Expression
        , variants : Elm.Expression
        }
        -> Elm.Expression
    , scalarDetails :
        { name : Elm.Expression, description : Elm.Expression }
        -> Elm.Expression
    , schema :
        { queries : Elm.Expression
        , mutations : Elm.Expression
        , objects : Elm.Expression
        , scalars : Elm.Expression
        , inputObjects : Elm.Expression
        , enums : Elm.Expression
        , unions : Elm.Expression
        , interfaces : Elm.Expression
        }
        -> Elm.Expression
    , namespace :
        { namespace : Elm.Expression, enums : Elm.Expression } -> Elm.Expression
    , unwrappedValue : Elm.Expression
    , inList : Elm.Expression -> Elm.Expression
    , inMaybe : Elm.Expression -> Elm.Expression
    , scalar : Elm.Expression -> Elm.Expression
    , inputObject : Elm.Expression -> Elm.Expression
    , object : Elm.Expression -> Elm.Expression
    , enum : Elm.Expression -> Elm.Expression
    , union : Elm.Expression -> Elm.Expression
    , interface : Elm.Expression -> Elm.Expression
    , list_ : Elm.Expression -> Elm.Expression
    , nullable : Elm.Expression -> Elm.Expression
    , objectKind : Elm.Expression -> Elm.Expression
    , scalarKind : Elm.Expression -> Elm.Expression
    , inputObjectKind : Elm.Expression -> Elm.Expression
    , enumKind : Elm.Expression -> Elm.Expression
    , unionKind : Elm.Expression -> Elm.Expression
    , interfaceKind : Elm.Expression -> Elm.Expression
    }
make_ =
    { inputObjectDetails =
        \inputObjectDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Schema" ]
                    "InputObjectDetails"
                    []
                    (Type.record
                        [ ( "name", Type.string )
                        , ( "description"
                          , Type.namedWith [] "Maybe" [ Type.string ]
                          )
                        , ( "fields", Type.list (Type.namedWith [] "Field" []) )
                        , ( "isOneOf", Type.bool )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" inputObjectDetails_args.name
                    , Tuple.pair
                        "description"
                        inputObjectDetails_args.description
                    , Tuple.pair "fields" inputObjectDetails_args.fields
                    , Tuple.pair "isOneOf" inputObjectDetails_args.isOneOf
                    ]
                )
    , interfaceDetails =
        \interfaceDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Schema" ]
                    "InterfaceDetails"
                    []
                    (Type.record
                        [ ( "name", Type.string )
                        , ( "description"
                          , Type.namedWith [] "Maybe" [ Type.string ]
                          )
                        , ( "fields", Type.list (Type.namedWith [] "Field" []) )
                        , ( "implementedBy"
                          , Type.list (Type.namedWith [] "Kind" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" interfaceDetails_args.name
                    , Tuple.pair "description" interfaceDetails_args.description
                    , Tuple.pair "fields" interfaceDetails_args.fields
                    , Tuple.pair
                        "implementedBy"
                        interfaceDetails_args.implementedBy
                    ]
                )
    , field =
        \field_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Schema" ]
                    "Field"
                    []
                    (Type.record
                        [ ( "name", Type.string )
                        , ( "deprecation", Type.namedWith [] "Deprecation" [] )
                        , ( "description"
                          , Type.namedWith [] "Maybe" [ Type.string ]
                          )
                        , ( "arguments"
                          , Type.list (Type.namedWith [] "Argument" [])
                          )
                        , ( "type_", Type.namedWith [] "Type" [] )
                        , ( "permissions"
                          , Type.list (Type.namedWith [] "Permission" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" field_args.name
                    , Tuple.pair "deprecation" field_args.deprecation
                    , Tuple.pair "description" field_args.description
                    , Tuple.pair "arguments" field_args.arguments
                    , Tuple.pair "type_" field_args.type_
                    , Tuple.pair "permissions" field_args.permissions
                    ]
                )
    , argument =
        \argument_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Schema" ]
                    "Argument"
                    []
                    (Type.record
                        [ ( "name", Type.string )
                        , ( "description"
                          , Type.namedWith [] "Maybe" [ Type.string ]
                          )
                        , ( "type_", Type.namedWith [] "Type" [] )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" argument_args.name
                    , Tuple.pair "description" argument_args.description
                    , Tuple.pair "type_" argument_args.type_
                    ]
                )
    , objectDetails =
        \objectDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Schema" ]
                    "ObjectDetails"
                    []
                    (Type.record
                        [ ( "name", Type.string )
                        , ( "description"
                          , Type.namedWith [] "Maybe" [ Type.string ]
                          )
                        , ( "fields", Type.list (Type.namedWith [] "Field" []) )
                        , ( "interfaces"
                          , Type.list (Type.namedWith [] "Kind" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" objectDetails_args.name
                    , Tuple.pair "description" objectDetails_args.description
                    , Tuple.pair "fields" objectDetails_args.fields
                    , Tuple.pair "interfaces" objectDetails_args.interfaces
                    ]
                )
    , variant =
        \variant_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Schema" ]
                    "Variant"
                    []
                    (Type.record [ ( "kind", Type.namedWith [] "Kind" [] ) ])
                )
                (Elm.record [ Tuple.pair "kind" variant_args.kind ])
    , unionDetails =
        \unionDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Schema" ]
                    "UnionDetails"
                    []
                    (Type.record
                        [ ( "name", Type.string )
                        , ( "description"
                          , Type.namedWith [] "Maybe" [ Type.string ]
                          )
                        , ( "variants"
                          , Type.list (Type.namedWith [] "Variant" [])
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" unionDetails_args.name
                    , Tuple.pair "description" unionDetails_args.description
                    , Tuple.pair "variants" unionDetails_args.variants
                    ]
                )
    , scalarDetails =
        \scalarDetails_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Schema" ]
                    "ScalarDetails"
                    []
                    (Type.record
                        [ ( "name", Type.string )
                        , ( "description"
                          , Type.namedWith [] "Maybe" [ Type.string ]
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" scalarDetails_args.name
                    , Tuple.pair "description" scalarDetails_args.description
                    ]
                )
    , schema =
        \schema_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Schema" ]
                    "Schema"
                    []
                    (Type.record
                        [ ( "queries"
                          , Type.namedWith
                                []
                                "Dict"
                                [ Type.namedWith [] "Ref" []
                                , Type.namedWith [] "Query" []
                                ]
                          )
                        , ( "mutations"
                          , Type.namedWith
                                []
                                "Dict"
                                [ Type.namedWith [] "Ref" []
                                , Type.namedWith [] "Mutation" []
                                ]
                          )
                        , ( "objects"
                          , Type.namedWith
                                []
                                "Dict"
                                [ Type.namedWith [] "Ref" []
                                , Type.namedWith [] "ObjectDetails" []
                                ]
                          )
                        , ( "scalars"
                          , Type.namedWith
                                []
                                "Dict"
                                [ Type.namedWith [] "Ref" []
                                , Type.namedWith [] "ScalarDetails" []
                                ]
                          )
                        , ( "inputObjects"
                          , Type.namedWith
                                []
                                "Dict"
                                [ Type.namedWith [] "Ref" []
                                , Type.namedWith [] "InputObjectDetails" []
                                ]
                          )
                        , ( "enums"
                          , Type.namedWith
                                []
                                "Dict"
                                [ Type.namedWith [] "Ref" []
                                , Type.namedWith [] "EnumDetails" []
                                ]
                          )
                        , ( "unions"
                          , Type.namedWith
                                []
                                "Dict"
                                [ Type.namedWith [] "Ref" []
                                , Type.namedWith [] "UnionDetails" []
                                ]
                          )
                        , ( "interfaces"
                          , Type.namedWith
                                []
                                "Dict"
                                [ Type.namedWith [] "Ref" []
                                , Type.namedWith [] "InterfaceDetails" []
                                ]
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "queries" schema_args.queries
                    , Tuple.pair "mutations" schema_args.mutations
                    , Tuple.pair "objects" schema_args.objects
                    , Tuple.pair "scalars" schema_args.scalars
                    , Tuple.pair "inputObjects" schema_args.inputObjects
                    , Tuple.pair "enums" schema_args.enums
                    , Tuple.pair "unions" schema_args.unions
                    , Tuple.pair "interfaces" schema_args.interfaces
                    ]
                )
    , namespace =
        \namespace_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Schema" ]
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
    , unwrappedValue =
        Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "UnwrappedValue"
            , annotation = Just (Type.namedWith [] "Wrapped" [])
            }
    , inList =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "InList"
                    , annotation = Just (Type.namedWith [] "Wrapped" [])
                    }
                )
                [ ar0 ]
    , inMaybe =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "InMaybe"
                    , annotation = Just (Type.namedWith [] "Wrapped" [])
                    }
                )
                [ ar0 ]
    , scalar =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "Scalar"
                    , annotation = Just (Type.namedWith [] "Type" [])
                    }
                )
                [ ar0 ]
    , inputObject =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "InputObject"
                    , annotation = Just (Type.namedWith [] "Type" [])
                    }
                )
                [ ar0 ]
    , object =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "Object"
                    , annotation = Just (Type.namedWith [] "Type" [])
                    }
                )
                [ ar0 ]
    , enum =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "Enum"
                    , annotation = Just (Type.namedWith [] "Type" [])
                    }
                )
                [ ar0 ]
    , union =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "Union"
                    , annotation = Just (Type.namedWith [] "Type" [])
                    }
                )
                [ ar0 ]
    , interface =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "Interface"
                    , annotation = Just (Type.namedWith [] "Type" [])
                    }
                )
                [ ar0 ]
    , list_ =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "List_"
                    , annotation = Just (Type.namedWith [] "Type" [])
                    }
                )
                [ ar0 ]
    , nullable =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "Nullable"
                    , annotation = Just (Type.namedWith [] "Type" [])
                    }
                )
                [ ar0 ]
    , objectKind =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "ObjectKind"
                    , annotation = Just (Type.namedWith [] "Kind" [])
                    }
                )
                [ ar0 ]
    , scalarKind =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "ScalarKind"
                    , annotation = Just (Type.namedWith [] "Kind" [])
                    }
                )
                [ ar0 ]
    , inputObjectKind =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "InputObjectKind"
                    , annotation = Just (Type.namedWith [] "Kind" [])
                    }
                )
                [ ar0 ]
    , enumKind =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "EnumKind"
                    , annotation = Just (Type.namedWith [] "Kind" [])
                    }
                )
                [ ar0 ]
    , unionKind =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "UnionKind"
                    , annotation = Just (Type.namedWith [] "Kind" [])
                    }
                )
                [ ar0 ]
    , interfaceKind =
        \ar0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "InterfaceKind"
                    , annotation = Just (Type.namedWith [] "Kind" [])
                    }
                )
                [ ar0 ]
    }


caseOf_ :
    { wrapped :
        Elm.Expression
        -> { wrappedTags_0_0
            | unwrappedValue : Elm.Expression
            , inList : Elm.Expression -> Elm.Expression
            , inMaybe : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , type_ :
        Elm.Expression
        -> { typeTags_1_0
            | scalar : Elm.Expression -> Elm.Expression
            , inputObject : Elm.Expression -> Elm.Expression
            , object : Elm.Expression -> Elm.Expression
            , enum : Elm.Expression -> Elm.Expression
            , union : Elm.Expression -> Elm.Expression
            , interface : Elm.Expression -> Elm.Expression
            , list_ : Elm.Expression -> Elm.Expression
            , nullable : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    , kind :
        Elm.Expression
        -> { kindTags_2_0
            | objectKind : Elm.Expression -> Elm.Expression
            , scalarKind : Elm.Expression -> Elm.Expression
            , inputObjectKind : Elm.Expression -> Elm.Expression
            , enumKind : Elm.Expression -> Elm.Expression
            , unionKind : Elm.Expression -> Elm.Expression
            , interfaceKind : Elm.Expression -> Elm.Expression
        }
        -> Elm.Expression
    }
caseOf_ =
    { wrapped =
        \wrappedExpression wrappedTags ->
            Elm.Case.custom
                wrappedExpression
                (Type.namedWith [ "GraphQL", "Schema" ] "Wrapped" [])
                [ Elm.Case.branch0 "UnwrappedValue" wrappedTags.unwrappedValue
                , Elm.Case.branch1
                    "InList"
                    ( "wrapped", Type.namedWith [] "Wrapped" [] )
                    wrappedTags.inList
                , Elm.Case.branch1
                    "InMaybe"
                    ( "wrapped", Type.namedWith [] "Wrapped" [] )
                    wrappedTags.inMaybe
                ]
    , type_ =
        \typeExpression typeTags ->
            Elm.Case.custom
                typeExpression
                (Type.namedWith [ "GraphQL", "Schema" ] "Type" [])
                [ Elm.Case.branch1
                    "Scalar"
                    ( "string.String", Type.string )
                    typeTags.scalar
                , Elm.Case.branch1
                    "InputObject"
                    ( "string.String", Type.string )
                    typeTags.inputObject
                , Elm.Case.branch1
                    "Object"
                    ( "string.String", Type.string )
                    typeTags.object
                , Elm.Case.branch1
                    "Enum"
                    ( "string.String", Type.string )
                    typeTags.enum
                , Elm.Case.branch1
                    "Union"
                    ( "string.String", Type.string )
                    typeTags.union
                , Elm.Case.branch1
                    "Interface"
                    ( "string.String", Type.string )
                    typeTags.interface
                , Elm.Case.branch1
                    "List_"
                    ( "type_", Type.namedWith [] "Type" [] )
                    typeTags.list_
                , Elm.Case.branch1
                    "Nullable"
                    ( "type_", Type.namedWith [] "Type" [] )
                    typeTags.nullable
                ]
    , kind =
        \kindExpression kindTags ->
            Elm.Case.custom
                kindExpression
                (Type.namedWith [ "GraphQL", "Schema" ] "Kind" [])
                [ Elm.Case.branch1
                    "ObjectKind"
                    ( "string.String", Type.string )
                    kindTags.objectKind
                , Elm.Case.branch1
                    "ScalarKind"
                    ( "string.String", Type.string )
                    kindTags.scalarKind
                , Elm.Case.branch1
                    "InputObjectKind"
                    ( "string.String", Type.string )
                    kindTags.inputObjectKind
                , Elm.Case.branch1
                    "EnumKind"
                    ( "string.String", Type.string )
                    kindTags.enumKind
                , Elm.Case.branch1
                    "UnionKind"
                    ( "string.String", Type.string )
                    kindTags.unionKind
                , Elm.Case.branch1
                    "InterfaceKind"
                    ( "string.String", Type.string )
                    kindTags.interfaceKind
                ]
    }


call_ :
    { kindToString : Elm.Expression -> Elm.Expression
    , getJsonValue :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , typeToString : Elm.Expression -> Elm.Expression
    , typeToElmString : Elm.Expression -> Elm.Expression
    , mockScalar : Elm.Expression -> Elm.Expression
    , getInner : Elm.Expression -> Elm.Expression
    , getWrap : Elm.Expression -> Elm.Expression
    }
call_ =
    { kindToString =
        \kindToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "kindToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Kind" [] ]
                                Type.string
                            )
                    }
                )
                [ kindToStringArg ]
    , getJsonValue =
        \getJsonValueArg getJsonValueArg0 getJsonValueArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "getJsonValue"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list (Type.tuple Type.string Type.string)
                                , Type.string
                                , Type.function
                                    [ Type.namedWith
                                        []
                                        "Result"
                                        [ Type.namedWith [ "Http" ] "Error" []
                                        , Type.namedWith [ "Json" ] "Value" []
                                        ]
                                    ]
                                    (Type.var "msg")
                                ]
                                (Type.namedWith [] "Cmd" [ Type.var "msg" ])
                            )
                    }
                )
                [ getJsonValueArg, getJsonValueArg0, getJsonValueArg1 ]
    , typeToString =
        \typeToStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "typeToString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Type" [] ]
                                Type.string
                            )
                    }
                )
                [ typeToStringArg ]
    , typeToElmString =
        \typeToElmStringArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "typeToElmString"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Type" [] ]
                                Type.string
                            )
                    }
                )
                [ typeToElmStringArg ]
    , mockScalar =
        \mockScalarArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "mockScalar"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Type" [] ]
                                (Type.namedWith [ "Json", "Encode" ] "Value" [])
                            )
                    }
                )
                [ mockScalarArg ]
    , getInner =
        \getInnerArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "getInner"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Type" [] ]
                                (Type.namedWith [] "Type" [])
                            )
                    }
                )
                [ getInnerArg ]
    , getWrap =
        \getWrapArg ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Schema" ]
                    , name = "getWrap"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Type" [] ]
                                (Type.namedWith [] "Wrapped" [])
                            )
                    }
                )
                [ getWrapArg ]
    }


values_ :
    { kindToString : Elm.Expression
    , getJsonValue : Elm.Expression
    , empty : Elm.Expression
    , decoder : Elm.Expression
    , typeToString : Elm.Expression
    , typeToElmString : Elm.Expression
    , mockScalar : Elm.Expression
    , getInner : Elm.Expression
    , getWrap : Elm.Expression
    }
values_ =
    { kindToString =
        Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "kindToString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Kind" [] ] Type.string)
            }
    , getJsonValue =
        Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "getJsonValue"
            , annotation =
                Just
                    (Type.function
                        [ Type.list (Type.tuple Type.string Type.string)
                        , Type.string
                        , Type.function
                            [ Type.namedWith
                                []
                                "Result"
                                [ Type.namedWith [ "Http" ] "Error" []
                                , Type.namedWith [ "Json" ] "Value" []
                                ]
                            ]
                            (Type.var "msg")
                        ]
                        (Type.namedWith [] "Cmd" [ Type.var "msg" ])
                    )
            }
    , empty =
        Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "empty"
            , annotation = Just (Type.namedWith [] "Schema" [])
            }
    , decoder =
        Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "decoder"
            , annotation =
                Just
                    (Type.namedWith
                        [ "Json" ]
                        "Decoder"
                        [ Type.namedWith [] "Schema" [] ]
                    )
            }
    , typeToString =
        Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "typeToString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Type" [] ] Type.string)
            }
    , typeToElmString =
        Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "typeToElmString"
            , annotation =
                Just (Type.function [ Type.namedWith [] "Type" [] ] Type.string)
            }
    , mockScalar =
        Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "mockScalar"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Type" [] ]
                        (Type.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
    , getInner =
        Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "getInner"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Type" [] ]
                        (Type.namedWith [] "Type" [])
                    )
            }
    , getWrap =
        Elm.value
            { importFrom = [ "GraphQL", "Schema" ]
            , name = "getWrap"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Type" [] ]
                        (Type.namedWith [] "Wrapped" [])
                    )
            }
    }



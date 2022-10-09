module Generate.Input.Encode exposing
    ( toInputRecordAlias, toRecordInput, toRecordOptionals, toRecordNulls
    , toInputObject, toOptionHelpers, toNulls
    , toOneOfHelper, toOneOfNulls
    , fullRecordToInputObject
    , encodeEnum
    , docGroups
    , encode, scalarType, toElmType
    )

{-|

@docs toInputRecordAlias, toRecordInput, toRecordOptionals, toRecordNulls

@docs toInputObject, toOptionHelpers, toNulls

@docs toOneOfHelper, toOneOfNulls

@docs fullRecordToInputObject

@docs encodeEnum

@docs docGroups

-}

import Elm
import Elm.Annotation as Type
import Elm.Op
import Gen.GraphQL.Engine as Engine
import Gen.Json.Encode as Encode
import Generate.Common
import Generate.Scalar
import GraphQL.Schema
import Set exposing (Set)
import Utils.String


reservedWords : Set String
reservedWords =
    Set.fromList
        [ "input"
        , "null"
        ]


type alias Namespace =
    { namespace : String
    , enums : String
    }


valueFrom mod name =
    Elm.value
        { importFrom = mod
        , name = name
        , annotation = Nothing
        }


docGroups =
    { optionalFields = "Optional fields"
    , nullFields = "Null values"
    , inputStarter = "Creating an input"
    }


{-|

    list : (a -> Json.Encode.Value) -> List a -> Json.Encode.Value

-}
encodeList : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
encodeList fn listExpr =
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
        [ Elm.functionReduced "listUnpack" fn, listExpr ]


{-|

    This is for queries/mutations which take a fully realized optional record:


        { requiredField : Int
        , optionalField : Engine.Option Int
        }

    And render it into a field list:

        [("requiredField", Encode.int), ("optionalField", Encode.null)]

-}
fullRecordToInputObject :
    Namespace
    -> GraphQL.Schema.Schema
    -> List GraphQL.Schema.Argument
    -> Elm.Expression
    -> Elm.Expression
fullRecordToInputObject namespace schema args argRecord =
    List.foldl
        (addEncodedVariablesHelper namespace schema argRecord)
        (Engine.inputObject "Input")
        args


addEncodedVariablesHelper :
    Namespace
    -> GraphQL.Schema.Schema
    -> Elm.Expression
    -> GraphQL.Schema.Argument
    -> Elm.Expression
    -> Elm.Expression
addEncodedVariablesHelper namespace schema argRecord var inputObj =
    let
        name =
            var.name
    in
    case var.type_ of
        GraphQL.Schema.Nullable type_ ->
            inputObj
                |> Elm.Op.pipe
                    (Elm.apply Engine.values_.addOptionalField
                        [ Elm.string name
                        , Elm.string (GraphQL.Schema.typeToString var.type_)
                        , Elm.get name argRecord
                        , Elm.fn
                            ( "encode", Nothing )
                            (\x ->
                                encode
                                    namespace
                                    schema
                                    type_
                                    x
                            )
                        ]
                    )

        _ ->
            inputObj
                |> Elm.Op.pipe
                    (Elm.apply Engine.values_.addField
                        [ Elm.string name
                        , Elm.string (GraphQL.Schema.typeToString var.type_)
                        , Elm.get name argRecord
                            |> encode
                                namespace
                                schema
                                var.type_
                        ]
                    )



{- INPUT RECORDS -}


{-|

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
toRecordInput :
    Namespace
    -> GraphQL.Schema.Schema
    -> List GraphQL.Schema.Argument
    -> Elm.Declaration
toRecordInput namespace schema fields =
    let
        ( required, optional ) =
            List.partition
                (\arg ->
                    case arg.type_ of
                        GraphQL.Schema.Nullable innerType ->
                            False

                        _ ->
                            True
                )
                fields
    in
    case required of
        [] ->
            Elm.declaration "input"
                (Elm.record
                    (List.map
                        (\var ->
                            ( var.name
                            , Engine.make_.absent
                            )
                        )
                        fields
                    )
                    |> Elm.withType
                        (Type.named [] "Input")
                )
                |> Elm.exposeWith
                    { exposeConstructor = False
                    , group = Just docGroups.inputStarter
                    }

        _ ->
            Elm.fn
                ( "args"
                , Just <|
                    Type.record
                        (List.map
                            (\req ->
                                ( req.name
                                , toElmType namespace schema req.type_ (GraphQL.Schema.getWrap req.type_)
                                )
                            )
                            required
                        )
                )
                (\reqd ->
                    Elm.record
                        (List.map
                            (\var ->
                                Tuple.pair var.name
                                    (case var.type_ of
                                        GraphQL.Schema.Nullable _ ->
                                            Engine.make_.absent

                                        _ ->
                                            reqd |> Elm.get var.name
                                    )
                            )
                            fields
                        )
                        |> Elm.withType
                            (Type.named [] "Input")
                )
                |> Elm.declaration "input"
                |> Elm.exposeWith
                    { exposeConstructor = False
                    , group = Just docGroups.inputStarter
                    }


toRecordOptionals :
    Namespace
    -> GraphQL.Schema.Schema
    -> List GraphQL.Schema.Argument
    -> List Elm.Declaration
toRecordOptionals namespace schema varDefs =
    List.filterMap (inputToRecordOptionalHelper namespace schema) varDefs


inputToRecordOptionalHelper :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.Argument
    -> Maybe Elm.Declaration
inputToRecordOptionalHelper namespace schema var =
    case var.type_ of
        GraphQL.Schema.Nullable inner ->
            let
                varName =
                    if Set.member var.name reservedWords then
                        var.name ++ "_"

                    else
                        var.name

                innerType =
                    toElmType namespace schema inner (GraphQL.Schema.getWrap inner)
            in
            Just
                (Elm.fn2
                    ( "var"
                    , Just innerType
                    )
                    ( "record"
                    , Just (Type.named [] "Input")
                    )
                    (\val record ->
                        record
                            |> Elm.updateRecord
                                [ ( var.name, Engine.make_.present val )
                                ]
                            |> Elm.withType (Type.named [] "Input")
                    )
                    |> Elm.declaration varName
                    |> Elm.exposeWith { exposeConstructor = False, group = Just "inputBuilders" }
                    |> Elm.withDocumentation ""
                )

        _ ->
            Nothing


toRecordNulls : List GraphQL.Schema.Argument -> List Elm.Declaration
toRecordNulls varDefs =
    let
        toOptionalInput var =
            case var.type_ of
                GraphQL.Schema.Nullable _ ->
                    let
                        fieldName =
                            var.name
                    in
                    Just
                        (Tuple.pair fieldName
                            (Elm.fn
                                ( "record"
                                , Just (Type.named [] "Input")
                                )
                                (Elm.updateRecord
                                    [ ( fieldName, Engine.make_.null )
                                    ]
                                )
                            )
                        )

                _ ->
                    Nothing
    in
    case List.filterMap toOptionalInput varDefs of
        [] ->
            []

        options ->
            [ Elm.declaration "null"
                (Elm.record
                    options
                )
                |> Elm.exposeWith { exposeConstructor = False, group = Just "Null values" }
            ]


toInputRecordAlias :
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    -> List GraphQL.Schema.Argument
    -> Elm.Declaration
toInputRecordAlias namespace schema name varDefs =
    Elm.alias name
        (Type.record
            (List.map
                (\var ->
                    let
                        fieldName =
                            var.name
                    in
                    case var.type_ of
                        GraphQL.Schema.Nullable inner ->
                            ( fieldName
                            , Engine.annotation_.option
                                (toElmType namespace
                                    schema
                                    inner
                                    (GraphQL.Schema.getWrap inner)
                                )
                            )

                        _ ->
                            ( fieldName
                            , toElmType namespace
                                schema
                                var.type_
                                (GraphQL.Schema.getWrap var.type_)
                            )
                )
                varDefs
            )
        )
        |> Elm.exposeWith { exposeConstructor = False, group = Just "Input" }



{- INPUT OBJECTS -}


{-| Create the initial `input` helper, which takes the required arguments and gives you the encoded type

    input :
        { url : String
        , overrideOneProductPerDomainAssumption : Bool
        }
        -> CreateServiceEntityInput

-}
toInputObject :
    Namespace
    -> GraphQL.Schema.Schema
    ->
        { a
            | fields : List { b | name : String, type_ : GraphQL.Schema.Type }
            , name : String
        }
    -> Elm.Declaration
toInputObject namespace schema input =
    let
        ( required, optional ) =
            List.partition
                (\arg ->
                    case arg.type_ of
                        GraphQL.Schema.Nullable innerType ->
                            False

                        _ ->
                            True
                )
                input.fields
    in
    case required of
        [] ->
            Elm.declaration "input"
                (Engine.inputObject input.name
                    |> Elm.withType (Type.named [] input.name)
                )
                |> Elm.exposeWith
                    { exposeConstructor = False
                    , group = Just docGroups.inputStarter
                    }

        _ ->
            Elm.fn
                ( "requiredArgs"
                , Type.record
                    (List.map
                        (\reqField ->
                            ( reqField.name
                            , toElmType namespace schema reqField.type_ (GraphQL.Schema.getWrap reqField.type_)
                            )
                        )
                        required
                    )
                    |> Just
                )
                (\val ->
                    List.foldl
                        (\field inputObj ->
                            Engine.addField
                                field.name
                                (GraphQL.Schema.typeToString field.type_)
                                (encode
                                    namespace
                                    schema
                                    field.type_
                                    (Elm.get field.name val)
                                )
                                inputObj
                        )
                        (Engine.inputObject input.name)
                        required
                        |> Elm.withType (Type.named [] input.name)
                )
                |> Elm.declaration "input"
                |> Elm.exposeWith
                    { exposeConstructor = False
                    , group = Just docGroups.inputStarter
                    }


toOptionHelpers :
    Namespace
    -> GraphQL.Schema.Schema
    ->
        { a
            | fields : List { b | name : String, type_ : GraphQL.Schema.Type }
            , name : String
        }
    -> List Elm.Declaration
toOptionHelpers namespace schema input =
    List.filterMap
        (\field ->
            case field.type_ of
                GraphQL.Schema.Nullable type_ ->
                    Elm.fn2
                        ( "newArg"
                        , toElmType namespace schema type_ (GraphQL.Schema.getWrap type_)
                            |> Just
                        )
                        ( "inputObj", Just <| Type.named [] input.name )
                        (\new inputObj ->
                            inputObj
                                |> Engine.addField
                                    field.name
                                    (GraphQL.Schema.typeToString field.type_)
                                    (encode
                                        namespace
                                        schema
                                        type_
                                        new
                                    )
                                |> Elm.withType (Type.named [] input.name)
                        )
                        |> Elm.declaration field.name
                        |> Elm.exposeWith
                            { exposeConstructor = False
                            , group = Just docGroups.optionalFields
                            }
                        |> Just

                _ ->
                    Nothing
        )
        input.fields


toOneOfHelper :
    Namespace
    -> GraphQL.Schema.Schema
    ->
        { a
            | fields : List { b | name : String, type_ : GraphQL.Schema.Type }
            , name : String
        }
    -> List Elm.Declaration
toOneOfHelper namespace schema input =
    List.filterMap
        (\field ->
            case field.type_ of
                GraphQL.Schema.Nullable type_ ->
                    Elm.fn
                        ( "newArg"
                        , toElmType namespace schema type_ (GraphQL.Schema.getWrap type_)
                            |> Just
                        )
                        (\new ->
                            Engine.inputObject input.name
                                |> Elm.withType (Type.named [] input.name)
                                |> Engine.addField
                                    field.name
                                    (GraphQL.Schema.typeToString field.type_)
                                    (encode
                                        namespace
                                        schema
                                        type_
                                        new
                                    )
                                |> Elm.withType (Type.named [] input.name)
                        )
                        |> Elm.declaration field.name
                        |> Elm.exposeWith
                            { exposeConstructor = False
                            , group = Just docGroups.optionalFields
                            }
                        |> Just

                _ ->
                    Nothing
        )
        input.fields


toOneOfNulls : String -> List GraphQL.Schema.Field -> List Elm.Declaration
toOneOfNulls inputName fields =
    let
        toOptionalInput field =
            case field.type_ of
                GraphQL.Schema.Nullable _ ->
                    Just
                        (Tuple.pair
                            field.name
                            (Engine.inputObject field.name
                                |> Elm.withType (Type.named [] field.name)
                                |> Engine.addField
                                    field.name
                                    (GraphQL.Schema.typeToString field.type_)
                                    Encode.null
                                |> Elm.withType (Type.named [] inputName)
                            )
                        )

                _ ->
                    Nothing
    in
    case List.filterMap toOptionalInput fields of
        [] ->
            []

        options ->
            [ Elm.declaration "null"
                (Elm.record
                    options
                )
                |> Elm.exposeWith { exposeConstructor = False, group = Just docGroups.nullFields }
            ]


toNulls : String -> List GraphQL.Schema.Field -> List Elm.Declaration
toNulls inputName fields =
    let
        toOptionalInput field =
            case field.type_ of
                GraphQL.Schema.Nullable _ ->
                    Just
                        (Tuple.pair
                            field.name
                            (Elm.fn
                                ( "inputObj"
                                , Just (Type.named [] inputName)
                                )
                                (\inputObj ->
                                    inputObj
                                        |> Engine.addField
                                            field.name
                                            (GraphQL.Schema.typeToString field.type_)
                                            Encode.null
                                        |> Elm.withType (Type.named [] inputName)
                                )
                            )
                        )

                _ ->
                    Nothing
    in
    case List.filterMap toOptionalInput fields of
        [] ->
            []

        options ->
            [ Elm.declaration "null"
                (Elm.record
                    options
                )
                |> Elm.exposeWith { exposeConstructor = True, group = Just docGroups.nullFields }
            ]


{-| -}
toElmType :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.Type
    -> GraphQL.Schema.Wrapped
    -> Type.Annotation
toElmType namespace schema type_ wrapped =
    case type_ of
        GraphQL.Schema.Nullable newType ->
            toElmType namespace schema newType wrapped

        GraphQL.Schema.List_ newType ->
            toElmType namespace schema newType wrapped

        GraphQL.Schema.Scalar scalarName ->
            scalarType namespace wrapped scalarName

        GraphQL.Schema.Enum enumName ->
            Type.named
                (Generate.Common.modules.enum namespace enumName)
                enumName
                |> unwrapWith wrapped

        GraphQL.Schema.InputObject inputName ->
            Type.named [ namespace.namespace, "Input" ] inputName
                |> unwrapWith wrapped

        GraphQL.Schema.Object nestedObjectName ->
            -- not used as input
            Type.unit

        GraphQL.Schema.Union unionName ->
            -- not used as input
            Type.unit

        GraphQL.Schema.Interface interfaceName ->
            -- not used as input
            Type.unit


{-| -}
encode :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.Type
    -> Elm.Expression
    -> Elm.Expression
encode namespace schema type_ val =
    encodeHelper namespace schema type_ val


encodeHelper :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.Type
    -> Elm.Expression
    -> Elm.Expression
encodeHelper namespace schema type_ val =
    case type_ of
        GraphQL.Schema.Nullable newType ->
            Engine.maybeScalarEncode
                (encodeHelper namespace schema newType)
                val

        GraphQL.Schema.List_ newType ->
            encodeList
                (encodeHelper namespace schema newType)
                val

        GraphQL.Schema.Scalar scalarName ->
            Generate.Scalar.encode namespace
                scalarName
                GraphQL.Schema.UnwrappedValue
                val

        GraphQL.Schema.Enum enumName ->
            if namespace.namespace /= namespace.enums then
                -- we're encoding using code generated via dillonkearns/elm-graphql
                Elm.apply
                    (Elm.fn
                        ( "enumValue"
                        , Just (Type.named [ namespace.enums, "Enum", enumName ] enumName)
                        )
                        (\i ->
                            Encode.call_.string
                                (Elm.apply
                                    (valueFrom [ namespace.enums, "Enum", enumName ] "toString")
                                    [ i
                                    ]
                                )
                        )
                    )
                    [ val
                    ]

            else
                Elm.apply
                    (valueFrom [ namespace.enums, "Enum", enumName ] "encode")
                    [ val
                    ]

        GraphQL.Schema.InputObject inputName ->
            Engine.encodeInputObjectAsJson val

        GraphQL.Schema.Object nestedObjectName ->
            -- not used as input
            Elm.unit

        GraphQL.Schema.Union unionName ->
            -- not used as input
            Elm.unit

        GraphQL.Schema.Interface interfaceName ->
            -- not used as input
            Elm.unit


wrappedToStringIndex : GraphQL.Schema.Wrapped -> String
wrappedToStringIndex wrapped =
    case wrapped of
        GraphQL.Schema.UnwrappedValue ->
            ""

        GraphQL.Schema.InMaybe inner ->
            "m" ++ wrappedToStringIndex inner

        GraphQL.Schema.InList inner ->
            "l" ++ wrappedToStringIndex inner


scalarType : Namespace -> GraphQL.Schema.Wrapped -> String -> Type.Annotation
scalarType namespace wrapped scalarName =
    case wrapped of
        GraphQL.Schema.InList inner ->
            Type.list
                (scalarType namespace inner scalarName)

        GraphQL.Schema.InMaybe inner ->
            Type.maybe
                (scalarType namespace inner scalarName)

        GraphQL.Schema.UnwrappedValue ->
            Generate.Scalar.type_ namespace scalarName


unwrapWith :
    GraphQL.Schema.Wrapped
    -> Type.Annotation
    -> Type.Annotation
unwrapWith wrapped expression =
    case wrapped of
        GraphQL.Schema.InList inner ->
            Type.list
                (unwrapWith inner expression)

        GraphQL.Schema.InMaybe inner ->
            Type.maybe
                (unwrapWith inner expression)

        GraphQL.Schema.UnwrappedValue ->
            expression


encodeWrapped :
    GraphQL.Schema.Wrapped
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
encodeWrapped wrapper encoder val =
    case wrapper of
        GraphQL.Schema.UnwrappedValue ->
            encoder val

        GraphQL.Schema.InMaybe inner ->
            encodeWrapped inner (Engine.maybeScalarEncode encoder) val

        GraphQL.Schema.InList inner ->
            encodeWrapped inner (encodeList encoder) val


encodeEnum : Namespace -> GraphQL.Schema.Wrapped -> Elm.Expression -> String -> Elm.Expression
encodeEnum namespace wrapped val enumName =
    encodeWrappedInverted wrapped
        (\v ->
            if namespace.namespace /= namespace.enums then
                -- we're encoding using code generated via dillonkearns/elm-graphql
                Elm.apply
                    (Elm.fn
                        ( "enumValue"
                        , Just (Type.named [ namespace.enums, "Enum", enumName ] enumName)
                        )
                        (\i ->
                            Encode.call_.string
                                (Elm.apply
                                    (valueFrom [ namespace.enums, "Enum", enumName ] "toString")
                                    [ i
                                    ]
                                )
                        )
                    )
                    [ v
                    ]

            else
                Elm.apply
                    (valueFrom [ namespace.enums, "Enum", enumName ] "encode")
                    [ v
                    ]
        )
        val


encodeWrappedInverted :
    GraphQL.Schema.Wrapped
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
encodeWrappedInverted wrapper encoder val =
    case wrapper of
        GraphQL.Schema.UnwrappedValue ->
            encoder val

        GraphQL.Schema.InMaybe inner ->
            Engine.maybeScalarEncode (encodeWrappedInverted inner encoder) val

        GraphQL.Schema.InList inner ->
            encodeList (encodeWrappedInverted inner encoder) val

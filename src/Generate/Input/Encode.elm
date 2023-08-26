module Generate.Input.Encode exposing
    ( toInputRecordAlias
    , toInputObject, toOptionHelpers, toNulls
    , toOneOfHelper, toOneOfNulls
    , fullRecordToInputObject
    , docGroups
    , Namespace
    )

{-|

@docs toInputRecordAlias

@docs toInputObject, toOptionHelpers, toNulls

@docs toOneOfHelper, toOneOfNulls

@docs fullRecordToInputObject

@docs docGroups

-}

import Elm
import Elm.Annotation as Type
import Elm.Op
import Gen.GraphQL.Engine as Engine
import Gen.GraphQL.InputObject
import Gen.Json.Encode as Encode
import Generate.Common
import Generate.Scalar
import GraphQL.Schema
import Utils.String


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
        (Gen.GraphQL.InputObject.inputObject "Input")
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
                    (Elm.apply Gen.GraphQL.InputObject.values_.addOptionalField
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
                    (Elm.apply Gen.GraphQL.InputObject.values_.addField
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


toInputRecordAlias :
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    -> List GraphQL.Schema.Argument
    -> Elm.Declaration
toInputRecordAlias namespace schema name varDefs =
    let
        isOptionalVar var =
            case var.type_ of
                GraphQL.Schema.Nullable _ ->
                    True

                _ ->
                    False

        docs =
            if List.any isOptionalVar varDefs then
                """ This input has optional args, which are wrapped in `""" ++ namespace.namespace ++ """.Option`.

First up, if it makes sense, you can make this argument required in your graphql query 
by adding ! to that variable definition at the top of the query.  This will make it easier to handle in Elm.

If the field is truly optional, here's how to wrap it.

    - """ ++ namespace.namespace ++ ".present myValue" ++ """ -- this field should be myValue
    - """ ++ namespace.namespace ++ ".absent" ++ """ -- do not include this field at all in the GraphQL
    - """ ++ namespace.namespace ++ ".null" ++ """ -- include this field as a null value.  Not as common as .absent.
"""

            else
                """"""
    in
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
                            , --Engine.annotation_.option
                              Type.namedWith
                                [ namespace.namespace ]
                                "Option"
                                [ toElmType namespace
                                    schema
                                    inner
                                    (GraphQL.Schema.getWrap inner)
                                ]
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
                -- vars are reversed as provided
                |> List.reverse
            )
        )
        |> Elm.withDocumentation docs
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
        ( required, _ ) =
            List.partition
                (\arg ->
                    case arg.type_ of
                        GraphQL.Schema.Nullable _ ->
                            False

                        _ ->
                            True
                )
                input.fields
    in
    case required of
        [] ->
            Elm.declaration "input"
                (Gen.GraphQL.InputObject.inputObject input.name
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
                            Gen.GraphQL.InputObject.addField
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
                        (Gen.GraphQL.InputObject.inputObject input.name)
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
                        ( "newArg_"
                        , toElmType namespace schema type_ (GraphQL.Schema.getWrap type_)
                            |> Just
                        )
                        ( "inputObj_", Just <| Type.named [] input.name )
                        (\new inputObj ->
                            inputObj
                                |> Gen.GraphQL.InputObject.addField
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
                        |> Elm.declaration
                            (Utils.String.formatValue
                                (case field.name of
                                    "null" ->
                                        "null_"

                                    _ ->
                                        field.name
                                )
                            )
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
                            Gen.GraphQL.InputObject.inputObject input.name
                                |> Elm.withType (Type.named [] input.name)
                                |> Gen.GraphQL.InputObject.addField
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
                            (Gen.GraphQL.InputObject.inputObject field.name
                                |> Elm.withType (Type.named [] field.name)
                                |> Gen.GraphQL.InputObject.addField
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
                            (Utils.String.formatValue field.name)
                            (Elm.fn
                                ( "inputObj"
                                , Just (Type.named [] inputName)
                                )
                                (\inputObj ->
                                    inputObj
                                        |> Gen.GraphQL.InputObject.addField
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

        GraphQL.Schema.Object _ ->
            -- not used as input
            Type.unit

        GraphQL.Schema.Union _ ->
            -- not used as input
            Type.unit

        GraphQL.Schema.Interface _ ->
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
            Gen.GraphQL.InputObject.maybe
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
                        ( "enumValue_"
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

        GraphQL.Schema.InputObject _ ->
            Gen.GraphQL.InputObject.encode val

        GraphQL.Schema.Object _ ->
            -- not used as input
            Elm.unit

        GraphQL.Schema.Union _ ->
            -- not used as input
            Elm.unit

        GraphQL.Schema.Interface _ ->
            -- not used as input
            Elm.unit


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

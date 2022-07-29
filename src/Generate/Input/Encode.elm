module Generate.Input.Encode exposing
    ( toInputRecordAlias, toRecordInput, toRecordOptionals, toRecordNulls
    , toInputObject, toOptionHelpers, toNulls
    , fullRecordToInputObject
    , encodeScalar, encodeEnum
    , encode, scalarType, toElmType
    )

{-|

@docs toInputRecordAlias, toRecordInput, toRecordOptionals, toRecordNulls

@docs toInputObject, toOptionHelpers, toNulls

@docs fullRecordToInputObject

@docs encodeScalar, encodeEnum

-}

import Elm
import Elm.Annotation as Type
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Encode as Encode
import Generate.Common
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
    Engine.inputObject
        -- NOTE, this is probably wrong.
        -- But the top leve arguments dont really have a specific set of inputs
        (Elm.string "Input")
        |> addEncodedVariables namespace schema argRecord args


{--}
addEncodedVariables :
    Namespace
    -> GraphQL.Schema.Schema
    -> Elm.Expression
    -> List GraphQL.Schema.Argument
    -> Elm.Expression
    -> Elm.Expression
addEncodedVariables namespace schema argRecord args inputObj =
    addEncodedVariablesHelper namespace schema argRecord args inputObj


addEncodedVariablesHelper :
    Namespace
    -> GraphQL.Schema.Schema
    -> Elm.Expression
    -> List GraphQL.Schema.Argument
    -> Elm.Expression
    -> Elm.Expression
addEncodedVariablesHelper namespace schema argRecord variables inputObj =
    case variables of
        [] ->
            inputObj

        var :: remain ->
            let
                name =
                    var.name
            in
            case var.type_ of
                GraphQL.Schema.Nullable type_ ->
                    let
                        newInput =
                            inputObj
                                |> Engine.addOptionalField
                                    (Elm.string name)
                                    (Elm.string (GraphQL.Schema.typeToString var.type_))
                                    (Elm.get name argRecord)
                                    (\x ->
                                        encode
                                            namespace
                                            schema
                                            type_
                                            x
                                    )
                    in
                    addEncodedVariablesHelper namespace schema argRecord remain newInput

                _ ->
                    let
                        newInput =
                            inputObj
                                |> Engine.addField
                                    (Elm.string name)
                                    (Elm.string (GraphQL.Schema.typeToString var.type_))
                                    (Elm.get name argRecord
                                        |> encode
                                            namespace
                                            schema
                                            var.type_
                                    )
                    in
                    addEncodedVariablesHelper namespace schema argRecord remain newInput



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
                            Elm.field var.name
                                Engine.make_.option.absent
                        )
                        fields
                    )
                    |> Elm.withType
                        (Type.named [] "Input")
                )
                |> Elm.exposeAndGroup "input"

        _ ->
            Elm.fn "input"
                ( "args"
                , Type.record
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
                                Elm.field var.name
                                    (case var.type_ of
                                        GraphQL.Schema.Nullable _ ->
                                            Engine.make_.option.absent

                                        _ ->
                                            reqd |> Elm.get var.name
                                    )
                            )
                            fields
                        )
                        |> Elm.withType
                            (Type.named [] "Input")
                )
                |> Elm.exposeAndGroup "input"


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
                (Elm.fn2 varName
                    ( "var"
                    , innerType
                    )
                    ( "record"
                    , Type.named [] "Input"
                    )
                    (\val record ->
                        Elm.updateRecord "record"
                            [ ( varName, Engine.make_.option.present val )
                            ]
                            |> Elm.withType (Type.named [] "Input")
                    )
                    |> Elm.exposeAndGroup "inputBuilders"
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
                        (Elm.field fieldName
                            (Elm.lambda "record"
                                (Type.named [] "Input")
                                (\val ->
                                    Elm.updateRecord "record"
                                        [ ( fieldName, Engine.make_.option.null )
                                        ]
                                        |> Elm.withType (Type.named [] "Input")
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
                |> Elm.exposeAndGroup "nulls"
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
                            , Engine.types_.option
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
        |> Elm.exposeAndGroup "input"



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
                (Engine.inputObject (Elm.string input.name)
                    |> Elm.withType (Type.named [] input.name)
                )
                |> Elm.exposeAndGroup "input"

        _ ->
            Elm.fn "input"
                ( "required"
                , Type.record
                    (List.map
                        (\reqField ->
                            ( reqField.name
                            , toElmType namespace schema reqField.type_ (GraphQL.Schema.getWrap reqField.type_)
                            )
                        )
                        required
                    )
                )
                (\val ->
                    List.foldl
                        (\field inputObj ->
                            Engine.addField
                                (Elm.string field.name)
                                (Elm.string (GraphQL.Schema.typeToString field.type_))
                                (encode
                                    namespace
                                    schema
                                    field.type_
                                    (Elm.get field.name val)
                                )
                                inputObj
                        )
                        (Engine.inputObject (Elm.string input.name))
                        required
                        |> Elm.withType (Type.named [] input.name)
                )
                |> Elm.exposeAndGroup "input"


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
                    Elm.fn2 field.name
                        ( "newArg"
                        , toElmType namespace schema type_ (GraphQL.Schema.getWrap type_)
                        )
                        ( "inputObj", Type.named [] input.name )
                        (\new inputObj ->
                            inputObj
                                |> Engine.addField
                                    (Elm.string field.name)
                                    (Elm.string (GraphQL.Schema.typeToString field.type_))
                                    (encode
                                        namespace
                                        schema
                                        type_
                                        new
                                    )
                                |> Elm.withType (Type.named [] input.name)
                        )
                        |> Elm.exposeAndGroup "inputs"
                        |> Just

                _ ->
                    Nothing
        )
        input.fields


toNulls : String -> List GraphQL.Schema.Field -> List Elm.Declaration
toNulls inputName fields =
    let
        toOptionalInput field =
            case field.type_ of
                GraphQL.Schema.Nullable _ ->
                    Just
                        (Elm.field
                            field.name
                            (Elm.lambda "inputObj"
                                (Type.named [] inputName)
                                (\inputObj ->
                                    inputObj
                                        |> Engine.addField
                                            (Elm.string field.name)
                                            (Elm.string (GraphQL.Schema.typeToString field.type_))
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
                |> Elm.exposeAndGroup "null"
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
            scalarType wrapped scalarName

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


encode :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.Type
    -> Elm.Expression
    -> Elm.Expression
encode namespace schema type_ val =
    encodeHelper namespace schema type_ (GraphQL.Schema.getWrap type_) val


encodeHelper :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.Type
    -> GraphQL.Schema.Wrapped
    -> Elm.Expression
    -> Elm.Expression
encodeHelper namespace schema type_ wrapped val =
    case type_ of
        GraphQL.Schema.Nullable newType ->
            encodeHelper namespace schema newType wrapped val

        GraphQL.Schema.List_ newType ->
            encodeHelper namespace schema newType wrapped val

        GraphQL.Schema.Scalar scalarName ->
            encodeScalar scalarName wrapped val

        GraphQL.Schema.Enum enumName ->
            encodeEnum namespace wrapped val enumName

        GraphQL.Schema.InputObject inputName ->
            encodeWrapped wrapped
                (\x ->
                    -- Elm.lambda ("inlist" ++ wrappedToStringIndex wrapped)
                    -- Type.unit
                    Engine.encodeInputObjectAsJson x
                )
                val

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


scalarType : GraphQL.Schema.Wrapped -> String -> Type.Annotation
scalarType wrapped scalarName =
    case wrapped of
        GraphQL.Schema.InList inner ->
            Type.list
                (scalarType inner scalarName)

        GraphQL.Schema.InMaybe inner ->
            Type.maybe
                (scalarType inner scalarName)

        GraphQL.Schema.UnwrappedValue ->
            let
                lowered =
                    String.toLower scalarName
            in
            case lowered of
                "int" ->
                    Type.int

                "float" ->
                    Type.float

                "string" ->
                    Type.string

                "boolean" ->
                    Type.bool

                _ ->
                    Type.named
                        [ "Scalar" ]
                        (Utils.String.formatScalar scalarName)


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
            encodeWrapped inner (Encode.list encoder) val


encodeScalar : String -> GraphQL.Schema.Wrapped -> (Elm.Expression -> Elm.Expression)
encodeScalar scalarName wrapped =
    case wrapped of
        GraphQL.Schema.InList inner ->
            Encode.list
                (encodeScalar scalarName inner)

        GraphQL.Schema.InMaybe inner ->
            Engine.maybeScalarEncode
                (encodeScalar scalarName
                    inner
                )

        GraphQL.Schema.UnwrappedValue ->
            let
                lowered =
                    String.toLower scalarName
            in
            case lowered of
                "int" ->
                    Encode.int

                "float" ->
                    Encode.float

                "string" ->
                    Encode.string

                "boolean" ->
                    Encode.bool

                _ ->
                    \val ->
                        Elm.apply
                            (Elm.valueFrom [ "Scalar" ]
                                (Utils.String.formatValue scalarName)
                                |> Elm.get "encode"
                            )
                            [ val ]


encodeEnum : Namespace -> GraphQL.Schema.Wrapped -> Elm.Expression -> String -> Elm.Expression
encodeEnum namespace wrapped val enumName =
    encodeWrappedInverted wrapped
        (\v ->
            if namespace.namespace /= namespace.enums then
                -- we're encoding using code generated via dillonkearns/elm-graphql
                Elm.apply
                    (Elm.lambda "enumValue"
                        (Type.named [ namespace.enums, "Enum", enumName ] enumName)
                        (\i ->
                            Encode.string
                                (Elm.apply
                                    (Elm.valueFrom [ namespace.enums, "Enum", enumName ] "toString")
                                    [ i
                                    ]
                                )
                        )
                    )
                    [ v
                    ]

            else
                Elm.apply
                    (Elm.valueFrom [ namespace.enums, "Enum", enumName ] "encode")
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
            Encode.list (encodeWrappedInverted inner encoder) val

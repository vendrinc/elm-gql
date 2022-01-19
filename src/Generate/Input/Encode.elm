module Generate.Input.Encode exposing
    ( toInputRecordAlias, toRecordInput, toRecordOptionals, toRecordNulls
    , toInputObject, toOptionHelpers, toNulls
    , encode, fullRecordToFieldList, toElmType
    )

{-|

@docs toInputRecordAlias, toRecordInput, toRecordOptionals, toRecordNulls

@docs toInputObject, toOptionHelpers, toNulls

-}

import Elm
import Elm.Annotation as Type
import Elm.Gen.GraphQL.Engine as Engine
import Generate.Args
import Generate.Common
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Schema


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
fullRecordToFieldList :
    Namespace
    -> GraphQL.Schema.Schema
    -> Can.Definition
    -> Elm.Expression
    -> Elm.Expression
fullRecordToFieldList namespace schema definition argRecord =
    Engine.inputObject
        |> addEncodedVariables namespace schema argRecord definition
        |> Engine.inputObjectToFieldList


{--}
addEncodedVariables :
    Namespace
    -> GraphQL.Schema.Schema
    -> Elm.Expression
    -> Can.Definition
    -> Elm.Expression
    -> Elm.Expression
addEncodedVariables namespace schema argRecord def inputObj =
    case def of
        Can.Operation op ->
            addEncodedVariablesHelper namespace schema argRecord op.variableDefinitions inputObj


addEncodedVariablesHelper :
    Namespace
    -> GraphQL.Schema.Schema
    -> Elm.Expression
    -> List Can.VariableDefinition
    -> Elm.Expression
    -> Elm.Expression
addEncodedVariablesHelper namespace schema argRecord variables inputObj =
    case variables of
        [] ->
            inputObj

        var :: remain ->
            let
                name =
                    Can.nameToString var.variable.name
            in
            case var.schemaType of
                GraphQL.Schema.Nullable type_ ->
                    let
                        newInput =
                            inputObj
                                |> Engine.addOptionalField (Elm.string name)
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
                                |> Engine.addField (Elm.string name)
                                    (Elm.get name argRecord
                                        |> encode
                                            namespace
                                            schema
                                            var.schemaType
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
    ->
        List
            { name : String
            , schemaType : GraphQL.Schema.Type
            }
    -> Elm.Declaration
toRecordInput namespace schema fields =
    let
        ( required, optional ) =
            List.partition
                (\arg ->
                    case arg.schemaType of
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

        _ ->
            Elm.fn "input"
                ( "args"
                , Type.record
                    (List.map
                        (\req ->
                            ( req.name
                            , toElmType namespace schema req.schemaType (GraphQL.Schema.getWrap req.schemaType)
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
                                    (case var.schemaType of
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


toRecordOptionals :
    Namespace
    -> GraphQL.Schema.Schema
    -> List Can.VariableDefinition
    -> List Elm.Declaration
toRecordOptionals namespace schema varDefs =
    List.filterMap (inputToRecordOptionalHelper namespace schema) varDefs


inputToRecordOptionalHelper :
    Namespace
    -> GraphQL.Schema.Schema
    -> Can.VariableDefinition
    -> Maybe Elm.Declaration
inputToRecordOptionalHelper namespace schema var =
    case var.schemaType of
        GraphQL.Schema.Nullable inner ->
            let
                varName =
                    Can.nameToString var.variable.name

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


toRecordNulls : List Can.VariableDefinition -> List Elm.Declaration
toRecordNulls varDefs =
    let
        toOptionalInput var =
            case var.schemaType of
                GraphQL.Schema.Nullable _ ->
                    let
                        fieldName =
                            Can.nameToString var.variable.name
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
            ]


toInputRecordAlias :
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    -> List Can.VariableDefinition
    -> Elm.Declaration
toInputRecordAlias namespace schema name varDefs =
    Elm.alias name
        (Type.record
            (List.map
                (\var ->
                    let
                        fieldName =
                            Can.nameToString var.variable.name
                    in
                    case var.schemaType of
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
                                var.schemaType
                                (GraphQL.Schema.getWrap var.schemaType)
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
                (Engine.inputObject
                    |> Elm.withType (Type.named [] input.name)
                )
                |> Elm.expose

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
                            Engine.addField (Elm.string field.name)
                                (encode
                                    namespace
                                    schema
                                    field.type_
                                    (Elm.get field.name val)
                                )
                                inputObj
                        )
                        Engine.inputObject
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
                                |> Engine.addField (Elm.string field.name)
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
                    let
                        fieldName =
                            field.name
                    in
                    Just
                        (Elm.field
                            fieldName
                            (Elm.lambda "inputObj"
                                (Type.named [] inputName)
                                (\inputObj ->
                                    inputObj
                                        |> Engine.addField (Elm.string fieldName) Engine.make_.option.null
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
            Generate.Args.scalarType wrapped scalarName

        GraphQL.Schema.Enum enumName ->
            Type.named
                (Generate.Common.modules.enum namespace enumName)
                enumName
                |> Generate.Args.unwrapWith wrapped

        GraphQL.Schema.InputObject inputName ->
            Type.named [ namespace.namespace, "Input" ] inputName
                |> Generate.Args.unwrapWith wrapped

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
            Generate.Args.encodeScalar scalarName wrapped val

        GraphQL.Schema.Enum enumName ->
            Generate.Args.encodeEnum namespace wrapped val enumName

        GraphQL.Schema.InputObject inputName ->
            Generate.Args.encodeWrapped wrapped
                (\_ ->
                    Elm.lambda ("inlist" ++ wrappedToStringIndex wrapped)
                        Type.unit
                        Engine.encodeInputObjectAsJson
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

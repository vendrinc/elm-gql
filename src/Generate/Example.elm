module Generate.Example exposing (example, operation)

import Dict
import Elm
import Elm.Gen.GraphQL.Engine as Engine
import Generate.Common
import Generate.Input
import GraphQL.Schema exposing (Namespace)
import Set exposing (Set)
import String
import Utils.String


{-| -}
operation :
    Namespace
    -> GraphQL.Schema.Schema
    -> ( Generate.Input.Operation, GraphQL.Schema.Operation )
    -> Elm.Expression
operation namespace schema ( opType, op ) =
    create namespace
        schema
        Set.empty
        op.name
        opType
        (Elm.valueFrom
            (case opType of
                Generate.Input.Mutation ->
                    Generate.Common.modules.mutation namespace.namespace op.name

                Generate.Input.Query ->
                    Generate.Common.modules.query namespace.namespace op.name
            )
            (Utils.String.formatValue op.name)
        )
        op.arguments
        -- (Elm.value ("select" ++ GraphQL.Schema.Type.toString returnType))
        -- (Engine.select Elm.unit)
        (Engine.selectTypeNameButSkip
         -- (Elm.string "__typename")
         -- (Decode.succeed (Elm.string "Payload"))
        )


{-|

    Generates an example that demonstrates Inputs, but the selection set is only `select{Object}`

-}
example :
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    ->
        List
            { fieldOrArg
                | name : String.String
                , description : Maybe String.String
                , type_ : GraphQL.Schema.Type
            }
    -> GraphQL.Schema.Type
    -> Generate.Input.Operation
    -> Elm.Expression
example namespace schema name arguments returnType op =
    create namespace
        schema
        Set.empty
        name
        op
        (Elm.valueFrom
            (case op of
                Generate.Input.Mutation ->
                    Generate.Common.modules.mutation namespace.namespace name

                Generate.Input.Query ->
                    Generate.Common.modules.query namespace.namespace name
            )
            (Utils.String.formatValue name)
        )
        arguments
        (Elm.value ("select" ++ GraphQL.Schema.typeToElmString (GraphQL.Schema.getInner returnType)))


create :
    Namespace
    -> GraphQL.Schema.Schema
    -> Set String
    -> String
    -> Generate.Input.Operation
    -> Elm.Expression
    ->
        List
            { fieldOrArg
                | description : Maybe String.String
                , name : String.String
                , type_ : GraphQL.Schema.Type
            }
    -> Elm.Expression
    -> Elm.Expression
create namespace schema called name operationType base fields return =
    let
        ( required, optional ) =
            Generate.Input.splitRequired
                fields

        hasRequiredArgs =
            case required of
                [] ->
                    False

                _ ->
                    True

        hasOptionalArgs =
            case optional of
                [] ->
                    False

                _ ->
                    True

        requiredArgs =
            if hasRequiredArgs then
                Just
                    (requiredArgsExample namespace schema name called required)

            else
                Nothing

        optionalArgs =
            if hasOptionalArgs then
                Just
                    (optionalArgsExample
                        namespace
                        schema
                        called
                        name
                        -- only give a maximum of 5 examples
                        (List.take 5 optional)
                        (Just operationType)
                        Set.empty
                        []
                    )

            else
                Nothing
    in
    Elm.apply
        base
        (List.filterMap identity
            [ requiredArgs
            , optionalArgs
            , Just return
            ]
        )


createEmbedded :
    Namespace
    -> GraphQL.Schema.Schema
    -> Set String
    -> String
    ->
        List
            { fieldOrArg
                | description : Maybe String.String
                , name : String.String
                , type_ : GraphQL.Schema.Type
            }
    -> Elm.Expression
createEmbedded namespace schema called name fields =
    let
        ( required, optional ) =
            Generate.Input.splitRequired
                fields

        hasRequiredArgs =
            case required of
                [] ->
                    False

                _ ->
                    True

        hasOptionalArgs =
            case optional of
                [] ->
                    False

                _ ->
                    True
    in
    if hasRequiredArgs then
        requiredArgsExample namespace schema name called fields

    else if hasOptionalArgs then
        optionalArgsExample
            namespace
            schema
            called
            name
            -- only give a maximum of 5 examples
            (List.take 5 optional)
            Nothing
            Set.empty
            []

    else
        Elm.list []


denullable : GraphQL.Schema.Type -> GraphQL.Schema.Type
denullable type_ =
    case type_ of
        GraphQL.Schema.Nullable inner ->
            inner

        _ ->
            type_


optionalArgsExample :
    Namespace
    -> GraphQL.Schema.Schema
    -> Set String
    -> String.String
    -> List { a | type_ : GraphQL.Schema.Type, name : String.String }
    -> Maybe Generate.Input.Operation
    -> Set String
    -> List Elm.Expression
    -> Elm.Expression
optionalArgsExample namespace schema called parentName fields isTopLevel calledType prepared =
    case fields of
        [] ->
            Elm.list (List.reverse prepared)

        field :: remaining ->
            let
                typeString =
                    GraphQL.Schema.typeToString field.type_
            in
            -- if we don't limit examples by type, then the code generation seems to hang or takea huge amount of time
            if Set.member typeString calledType then
                optionalArgsExample namespace
                    schema
                    called
                    parentName
                    remaining
                    isTopLevel
                    calledType
                    prepared

            else
                let
                    optionalModule =
                        case isTopLevel of
                            Nothing ->
                                [ namespace.namespace
                                , Utils.String.formatTypename parentName
                                ]

                            Just Generate.Input.Mutation ->
                                Generate.Common.modules.mutation namespace.namespace parentName

                            Just Generate.Input.Query ->
                                Generate.Common.modules.query namespace.namespace parentName

                    unnullifiedType =
                        denullable field.type_

                    maybePrep =
                        let
                            innerRequired =
                                requiredArgsExampleHelper
                                    namespace
                                    schema
                                    called
                                    unnullifiedType
                                    GraphQL.Schema.UnwrappedValue
                        in
                        case innerRequired of
                            Nothing ->
                                Nothing

                            Just inner ->
                                Elm.apply
                                    (Elm.valueFrom
                                        optionalModule
                                        (Utils.String.formatValue field.name)
                                    )
                                    [ inner
                                    ]
                                    |> Just
                in
                optionalArgsExample namespace
                    schema
                    called
                    parentName
                    remaining
                    isTopLevel
                    (Set.insert typeString calledType)
                    (case maybePrep of
                        Nothing ->
                            prepared

                        Just prep ->
                            prep :: prepared
                    )


{-| -}
requiredArgsExample :
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    -> Set String
    ->
        List
            { fieldOrArg
                | name : String.String
                , description : Maybe String.String
                , type_ : GraphQL.Schema.Type
            }
    -> Elm.Expression
requiredArgsExample namespace schema name called fields =
    let
        ( required, optional ) =
            Generate.Input.splitRequired
                fields
    in
    Elm.record
        (List.filterMap
            (\field ->
                let
                    innerContent =
                        requiredArgsExampleHelper
                            namespace
                            schema
                            called
                            field.type_
                            GraphQL.Schema.UnwrappedValue
                in
                case innerContent of
                    Nothing ->
                        Nothing

                    Just inner ->
                        Just
                            (Elm.field field.name inner)
            )
            required
            ++ (case optional of
                    [] ->
                        []

                    _ ->
                        [ Elm.field "optional_"
                            (optionalArgsExample
                                namespace
                                schema
                                called
                                name
                                -- only give a maximum of 5 examples
                                (List.take 5 optional)
                                Nothing
                                Set.empty
                                []
                            )
                        ]
               )
        )


requiredArgsExampleHelper :
    Namespace
    -> GraphQL.Schema.Schema
    -> Set String
    -> GraphQL.Schema.Type
    -> GraphQL.Schema.Wrapped
    -> Maybe Elm.Expression
requiredArgsExampleHelper namespace schema called type_ wrapped =
    case type_ of
        GraphQL.Schema.Nullable newType ->
            requiredArgsExampleHelper namespace schema called newType (GraphQL.Schema.InMaybe wrapped)

        GraphQL.Schema.List_ newType ->
            requiredArgsExampleHelper namespace schema called newType (GraphQL.Schema.InList wrapped)

        GraphQL.Schema.Scalar scalarName ->
            scalarExample scalarName
                |> Generate.Input.wrapExpression wrapped
                |> Just

        GraphQL.Schema.Enum enumName ->
            enumExample namespace schema enumName
                |> Generate.Input.wrapExpression wrapped
                |> Just

        GraphQL.Schema.Object nestedObjectName ->
            Nothing

        GraphQL.Schema.InputObject inputName ->
            if Set.member inputName called then
                Nothing

            else
                case Dict.get inputName schema.inputObjects of
                    Nothing ->
                        Nothing

                    Just input ->
                        let
                            newCalled =
                                Set.insert inputName called
                        in
                        case Generate.Input.splitRequired input.fields of
                            ( required, [] ) ->
                                Elm.record
                                    (List.filterMap
                                        (\field ->
                                            let
                                                innerContent =
                                                    requiredArgsExampleHelper namespace
                                                        schema
                                                        newCalled
                                                        field.type_
                                                        GraphQL.Schema.UnwrappedValue
                                            in
                                            case innerContent of
                                                Nothing ->
                                                    Nothing

                                                Just inner ->
                                                    Just
                                                        (Elm.field field.name inner)
                                        )
                                        required
                                    )
                                    |> Generate.Input.wrapExpression wrapped
                                    |> Just

                            otherwise ->
                                createEmbedded namespace
                                    schema
                                    newCalled
                                    inputName
                                    input.fields
                                    |> Generate.Input.wrapExpression wrapped
                                    |> Just

        GraphQL.Schema.Union unionName ->
            Nothing

        GraphQL.Schema.Interface interfaceName ->
            Nothing


enumExample : Namespace -> GraphQL.Schema.Schema -> String -> Elm.Expression
enumExample namespace schema enumName =
    case Dict.get enumName schema.enums of
        Nothing ->
            Elm.value enumName

        Just enum ->
            case enum.values of
                [] ->
                    Elm.value enumName

                top :: _ ->
                    Elm.valueFrom
                        (Generate.Common.modules.enum namespace enumName)
                        (Utils.String.formatTypename top.name)


scalarExample : String -> Elm.Expression
scalarExample scalarName =
    case String.toLower scalarName of
        "int" ->
            Elm.int 10

        "float" ->
            Elm.float 10

        "string" ->
            Elm.string "Example..."

        "boolean" ->
            Elm.bool True

        "datetime" ->
            Elm.apply
                (Elm.valueFrom
                    [ "Time" ]
                    "millisToPosix"
                )
                [ Elm.int 0
                ]

        "presence" ->
            Elm.valueFrom
                [ "Scalar" ]
                "Present"

        "url" ->
            Elm.valueFrom
                [ "Scalar" ]
                "fakeUrl"

        _ ->
            -- Elm.value (Utils.String.formatValue scalarName)
            Elm.apply
                (Elm.valueFrom
                    [ "Scalar" ]
                    (Utils.String.formatScalar scalarName)
                )
                [ Elm.string "placeholder"
                ]

module GraphQL.Operations.Generate.Mock.ServerResponse exposing (toJsonEncoder)

{-| Given an Elm Value of a decoded query or mutation, generate a JSON value.
-}

import Elm
import Elm.Annotation as Type
import Gen.Json.Encode
import Generate.Path
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Generate.Decode exposing (Namespace)
import GraphQL.Operations.Generate.Types as GeneratedTypes
import GraphQL.Schema
import Utils.String


{-| A standard query generates some Elm code that returns

    Api.Query DataReturned

Where we generate types for DataReturned.

This generates a function that takes a {DataReturned} and returns a JSON value.

This will ultimately be used in testing as follows

        Spec.app.sends
            { gql =
                AppsPaginated.query
                    (AppsPaginated.input
                        |> AppsPaginated.first 50
                    )

            , encoder = Mock.encoder
            , serverReturns  =
                Mock.AppsPaginated.query
            }


        Spec.app.sends
            { gql =
                -- Api.Query data
                AppsPaginated.query
                    (AppsPaginated.input
                        |> AppsPaginated.first 50
                    )
            -- data -> Json.Encode.Value
            , encoder = Mock.encoder
            -- data
            , serverReturns  =
                Mock.AppsPaginated.query
            }


        Api.Mock.appsPaginated
            { input =
                AppsPaginated.input
                    |> AppsPaginated.first 50
            , returns =
                Mock.AppsPaginated.query
            }

-}
toJsonEncoder : Type.Annotation -> Namespace -> Can.Definition -> List Elm.Declaration
toJsonEncoder responseType namespace ((Can.Operation def) as op) =
    [ Elm.declaration "encode"
        (Elm.fn
            ( "value"
            , Just responseType
            )
            (\value ->
                let
                    data =
                        encodeFields namespace def.fields value
                in
                Gen.Json.Encode.object
                    [ Elm.tuple (Elm.string "data") data
                    ]
                    |> Elm.withType Gen.Json.Encode.annotation_.value
            )
        )
    ]


encodeFields : Namespace -> List Can.Field -> Elm.Expression -> Elm.Expression
encodeFields namespace fields runtimeValue =
    toObject <|
        List.concatMap
            (encodeField namespace runtimeValue)
            fields


toObject : List ( String, Elm.Expression ) -> Elm.Expression
toObject fields =
    Gen.Json.Encode.object
        (List.map
            (\( fieldString, field ) ->
                Elm.tuple (Elm.string fieldString) field
            )
            fields
        )


encodeField : Namespace -> Elm.Expression -> Can.Field -> List ( String, Elm.Expression )
encodeField namespace parentObjectRuntimeValue field =
    case field of
        Can.Frag fragment ->
            -- encodeFragment namespace fragment
            case fragment.fragment.selection of
                Can.FragmentObject fields ->
                    List.concatMap
                        (encodeField namespace parentObjectRuntimeValue)
                        fields.selection

                Can.FragmentUnion union ->
                    List.concatMap
                        (encodeField namespace parentObjectRuntimeValue)
                        union.selection

                Can.FragmentInterface interface ->
                    List.concatMap
                        (encodeField namespace parentObjectRuntimeValue)
                        interface.selection

        Can.Field fieldDetails ->
            let
                name =
                    Can.getFieldName field
                        |> Utils.String.formatValue

                runtimeValue =
                    parentObjectRuntimeValue
                        |> Elm.get name
            in
            case fieldDetails.selection of
                Can.FieldScalar scalarType ->
                    [ ( name, encodeScalar namespace scalarType runtimeValue ) ]

                Can.FieldEnum enum ->
                    [ ( name, encodeEnum namespace enum runtimeValue ) ]

                Can.FieldObject fields ->
                    [ ( name, encodeFields namespace fields runtimeValue )
                    ]

                Can.FieldUnion union ->
                    [ ( name, encodeFields namespace union.selection runtimeValue ) ]

                Can.FieldInterface interface ->
                    [ ( name, encodeFields namespace interface.selection runtimeValue ) ]


encodeEnum : Namespace -> Can.FieldEnumDetails -> Elm.Expression -> Elm.Expression
encodeEnum namespace enum value =
    Elm.apply
        (Elm.value
            { importFrom =
                [ namespace.enums
                , "Enum"
                , Utils.String.formatTypename enum.enumName
                ]
            , name = "encode"
            , annotation =
                Nothing
            }
        )
        [ value ]


encodeScalar : Namespace -> GraphQL.Schema.Type -> Elm.Expression -> Elm.Expression
encodeScalar namespace scalarType value =
    case scalarType of
        GraphQL.Schema.Scalar name ->
            case String.toLower name of
                "string" ->
                    Gen.Json.Encode.call_.string value

                "int" ->
                    Gen.Json.Encode.call_.int value

                "float" ->
                    Gen.Json.Encode.call_.float value

                "boolean" ->
                    Gen.Json.Encode.call_.bool value

                _ ->
                    Elm.apply
                        (Elm.value
                            { importFrom = [ namespace.namespace ]
                            , name = Utils.String.formatValue name
                            , annotation = Nothing
                            }
                            |> Elm.get "encode"
                        )
                        [ value ]

        _ ->
            Gen.Json.Encode.null

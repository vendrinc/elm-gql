module GraphQL.Operations.Generate.Mock.ServerResponse exposing (toJsonEncoder)

{-| Given an Elm Value of a decoded query or mutation, generate a JSON value.
-}

import Elm
import Elm.Annotation as Type
import Elm.Case
import Elm.Case.Branch
import Gen.GraphQL.InputObject
import Gen.Json.Encode
import Gen.List
import Generate.Path
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Generate.Decode exposing (Namespace)
import GraphQL.Operations.Generate.Types as GeneratedTypes
import GraphQL.Schema
import Set
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
    let
        builders =
            createBuilders namespace Nothing def.fields

        topEncoder =
            createFieldsEncoder "encode" (Just responseType) namespace def.fields
                |> Elm.expose
    in
    topEncoder :: deduplicate builders


deduplicate : List ( String, Elm.Declaration ) -> List Elm.Declaration
deduplicate builders =
    List.foldl
        (\( key, builder ) ( seen, acc ) ->
            if Set.member key seen then
                ( seen, acc )

            else
                ( Set.insert key seen, builder :: acc )
        )
        ( Set.empty, [] )
        builders
        |> Tuple.second
        |> List.reverse


createFieldsEncoder name annotation namespace fields =
    Elm.declaration name
        (Elm.fn
            ( "value"
            , annotation
            )
            (\value ->
                let
                    data =
                        encodeFields namespace fields value
                in
                data
                    |> Elm.withType Gen.Json.Encode.annotation_.value
            )
        )


createBuilders : Namespace -> Maybe Can.FragmentDetails -> List Can.Field -> List ( String, Elm.Declaration )
createBuilders namespace maybeFragmentName fields =
    List.concatMap
        (createBuilder namespace maybeFragmentName)
        fields


toEncoderName :
    Maybe
        { importFrom : List String
        , importMockFrom : List String
        , name : String
        }
    -> Maybe Can.FragmentDetails
    -> String
    -> String
toEncoderName maybeSingleSelection maybeFragment name =
    let
        fragName =
            case maybeSingleSelection of
                Nothing ->
                    case maybeFragment of
                        Just frag ->
                            Can.nameToString frag.fragment.name
                                |> Utils.String.formatTypename
                                |> Utils.String.capitalize

                        Nothing ->
                            ""

                Just frag ->
                    frag.name
                        |> Utils.String.formatTypename
                        |> Utils.String.capitalize
    in
    "encode" ++ fragName ++ Utils.String.capitalize name


createBuilder : Namespace -> Maybe Can.FragmentDetails -> Can.Field -> List ( String, Elm.Declaration )
createBuilder namespace maybeFragmentName field =
    let
        name =
            Can.getFieldName field
                |> Utils.String.formatValue
    in
    case field of
        Can.Frag fragment ->
            case fragment.fragment.selection of
                Can.FragmentObject { selection } ->
                    createBuilders namespace (Just fragment) selection

                Can.FragmentUnion union ->
                    createBuilders namespace (Just fragment) union.selection

                Can.FragmentInterface interface ->
                    createBuilders namespace (Just fragment) interface.selection

        Can.Field fieldDetails ->
            let
                globalAlias =
                    Can.nameToString fieldDetails.globalAlias
                        |> Utils.String.formatTypename
            in
            case fieldDetails.selection of
                Can.FieldScalar scalarType ->
                    []

                Can.FieldEnum enum ->
                    []

                Can.FieldObject fields ->
                    let
                        annotation =
                            case fieldDetails.selectsOnlyFragment of
                                Nothing ->
                                    case maybeFragmentName of
                                        Just frag ->
                                            Type.named frag.fragment.importFrom
                                                -- (Can.nameToString frag.fragment.name)
                                                name
                                                |> Just

                                        Nothing ->
                                            Type.named [] globalAlias
                                                |> Just

                                Just frag ->
                                    Type.named frag.importFrom frag.name
                                        |> Just

                        encoderName =
                            toEncoderName fieldDetails.selectsOnlyFragment maybeFragmentName name

                        builder =
                            createFieldsEncoder encoderName
                                annotation
                                namespace
                                fields

                        innerBuilders =
                            createBuilders namespace maybeFragmentName fields
                    in
                    ( encoderName, builder ) :: innerBuilders

                Can.FieldUnion union ->
                    let
                        encoderName =
                            toEncoderName fieldDetails.selectsOnlyFragment maybeFragmentName name

                        builder =
                            createFieldsEncoder encoderName
                                Nothing
                                namespace
                                union.selection

                        innerBuilders =
                            createBuilders namespace maybeFragmentName union.selection
                    in
                    ( encoderName, builder ) :: innerBuilders

                Can.FieldInterface interface ->
                    let
                        encoderName =
                            toEncoderName fieldDetails.selectsOnlyFragment maybeFragmentName name

                        builder =
                            createFieldsEncoder encoderName Nothing namespace interface.selection

                        innerBuilders =
                            createBuilders namespace maybeFragmentName interface.selection
                    in
                    ( encoderName, builder ) :: innerBuilders


encodeFields : Namespace -> List Can.Field -> Elm.Expression -> Elm.Expression
encodeFields namespace fields runtimeValue =
    let
        encodedFields =
            List.concatMap
                (encodeFragmentFields namespace Nothing runtimeValue)
                fields
    in
    Gen.Json.Encode.call_.object
        (encodedFields
            |> List.reverse
            |> Elm.list
        )


fieldToJson : String -> Elm.Expression -> Elm.Expression
fieldToJson name value =
    Elm.tuple (Elm.string name) value


encodeFragmentFields : Namespace -> Maybe Can.FragmentDetails -> Elm.Expression -> Can.Field -> List Elm.Expression
encodeFragmentFields namespace maybeFragmentName parentObjectRuntimeValue field =
    let
        name =
            Can.getFieldName field
                |> Utils.String.formatValue

        runtimeValue =
            parentObjectRuntimeValue
                |> Elm.get name
    in
    case field of
        Can.Frag fragment ->
            case fragment.fragment.selection of
                Can.FragmentObject fields ->
                    List.concatMap
                        (encodeFragmentFields namespace (Just fragment) parentObjectRuntimeValue)
                        fields.selection

                Can.FragmentUnion union ->
                    List.concatMap
                        (encodeFragmentFields namespace (Just fragment) parentObjectRuntimeValue)
                        union.selection

                Can.FragmentInterface interface ->
                    List.concatMap
                        (encodeFragmentFields namespace (Just fragment) parentObjectRuntimeValue)
                        interface.selection

        Can.Field fieldDetails ->
            case fieldDetails.selection of
                Can.FieldScalar scalarType ->
                    [ fieldToJson name
                        (encodeScalar namespace
                            fieldDetails.wrapper
                            scalarType
                            runtimeValue
                        )
                    ]

                Can.FieldEnum enum ->
                    [ fieldToJson name
                        (encodeEnum namespace
                            fieldDetails.wrapper
                            enum
                            runtimeValue
                        )
                    ]

                Can.FieldObject fields ->
                    [ Elm.tuple (Elm.string name)
                        (wrapEncoder fieldDetails.wrapper
                            (Elm.val
                                (toEncoderName fieldDetails.selectsOnlyFragment maybeFragmentName name)
                            )
                            runtimeValue
                        )
                    ]

                Can.FieldUnion union ->
                    [ fieldToJson name
                        (encodeFields namespace
                            union.selection
                            runtimeValue
                        )
                    ]

                Can.FieldInterface interface ->
                    [ fieldToJson name
                        (encodeFields namespace
                            interface.selection
                            runtimeValue
                        )
                    ]


encodeEnum : Namespace -> GraphQL.Schema.Wrapped -> Can.FieldEnumDetails -> Elm.Expression -> Elm.Expression
encodeEnum namespace wrapper enum value =
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


encodeScalar : Namespace -> GraphQL.Schema.Wrapped -> GraphQL.Schema.Type -> Elm.Expression -> Elm.Expression
encodeScalar namespace wrapper scalarType value =
    case scalarType of
        GraphQL.Schema.Scalar name ->
            let
                encoder =
                    case String.toLower name of
                        "string" ->
                            Gen.Json.Encode.values_.string

                        "int" ->
                            Gen.Json.Encode.values_.int

                        "float" ->
                            Gen.Json.Encode.values_.float

                        "boolean" ->
                            Gen.Json.Encode.values_.bool

                        _ ->
                            Elm.value
                                { importFrom = [ namespace.namespace ]
                                , name = Utils.String.formatValue name
                                , annotation = Nothing
                                }
                                |> Elm.get "encode"
            in
            wrapEncoder wrapper encoder value

        _ ->
            Gen.Json.Encode.null


wrapEncoder : GraphQL.Schema.Wrapped -> Elm.Expression -> Elm.Expression -> Elm.Expression
wrapEncoder wrapper encoder value =
    case wrapper of
        GraphQL.Schema.InMaybe inner ->
            wrapEncoder inner (Elm.apply Gen.GraphQL.InputObject.values_.maybe [ encoder ]) value

        GraphQL.Schema.InList inner ->
            wrapEncoder inner (Elm.apply Gen.Json.Encode.values_.list [ encoder ]) value

        GraphQL.Schema.UnwrappedValue ->
            Elm.apply encoder [ value ]

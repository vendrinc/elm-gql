module GraphQL.Operations.Generate.Mock.ServerResponse exposing (fragmentToJsonEncoder, toJsonEncoder)

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


type alias TargetModule =
    { importFrom : List String
    }


fragmentToJsonEncoder : TargetModule -> Namespace -> Can.Fragment -> List Elm.Declaration
fragmentToJsonEncoder targetModule namespace frag =
    let
        name =
            Can.nameToString frag.name
                |> Utils.String.formatTypename
    in
    Elm.comment "Encoders"
        :: (case frag.selection of
                Can.FragmentObject def ->
                    let
                        record =
                            GeneratedTypes.toFields namespace [] def.selection
                                |> Type.record

                        responseType =
                            Type.alias targetModule.importFrom
                                (frag.name
                                    |> Can.nameToString
                                    |> Utils.String.formatTypename
                                )
                                []
                                record

                        builders =
                            createBuilders targetModule namespace Nothing def.selection

                        topEncoder =
                            createFieldsEncoder "encode" (Just responseType) namespace def.selection
                    in
                    List.map Elm.expose (topEncoder :: deduplicate builders)

                Can.FragmentUnion union ->
                    let
                        encoderName =
                            "encode"

                        builder =
                            createUnionEncoder targetModule namespace name encoderName union
                                |> Elm.expose

                        allSelections =
                            List.concatMap .selection union.variants

                        innerBuilders =
                            createBuilders targetModule
                                namespace
                                Nothing
                                (union.selection ++ allSelections)
                    in
                    List.map Elm.expose (builder :: deduplicate innerBuilders)

                Can.FragmentInterface union ->
                    [ Elm.declaration "encode"
                        (Elm.string "interface")
                    ]
           )


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
toJsonEncoder : TargetModule -> Type.Annotation -> Namespace -> Can.Definition -> List Elm.Declaration
toJsonEncoder targetModule responseType namespace ((Can.Operation def) as op) =
    let
        builders =
            createBuilders targetModule namespace Nothing def.fields

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
            ( "valueToEncode"
            , annotation
            )
            (\value ->
                let
                    data =
                        encodeFields namespace fields value
                            |> toObject
                in
                data
                    |> Elm.withType Gen.Json.Encode.annotation_.value
            )
        )


createUnionEncoder : TargetModule -> Namespace -> String -> String -> Can.FieldVariantDetails -> Elm.Declaration
createUnionEncoder target namespace unionName encoderName union =
    let
        branches =
            List.map
                (createUnionEncoderBranch target namespace)
                union.variants

        remainingBranches =
            List.map
                (createUnionEncoderBranchEmpty target namespace)
                union.remainingTags

        unionType =
            Type.named target.importFrom
                (Utils.String.formatTypename unionName)
    in
    Elm.declaration encoderName
        (Elm.fn
            ( "valueToEncode"
            , Just unionType
            )
            (\value ->
                Elm.Case.custom value
                    unionType
                    (List.reverse (remainingBranches ++ branches))
                    |> Elm.withType Gen.Json.Encode.annotation_.value
            )
        )


typeNameField : String -> Elm.Expression
typeNameField name =
    Elm.tuple (Elm.string "__typename") (Gen.Json.Encode.string name)


createUnionEncoderBranchEmpty : TargetModule -> Namespace -> { tag : Can.Name, globalAlias : Can.Name } -> Elm.Case.Branch
createUnionEncoderBranchEmpty target namespace variant =
    let
        typename =
            typeNameField (Can.nameToString variant.tag)
    in
    Elm.Case.branch0
        (Can.nameToString variant.globalAlias |> Utils.String.formatValue)
        ([ typename ]
            |> toObject
            |> Elm.withType Gen.Json.Encode.annotation_.value
        )


createUnionEncoderBranch : TargetModule -> Namespace -> Can.VariantCase -> Elm.Case.Branch
createUnionEncoderBranch target namespace variant =
    let
        selection =
            List.filter (not << Can.isTypeNameSelection) variant.selection

        typename =
            typeNameField (Can.nameToString variant.tag)
    in
    if List.isEmpty selection then
        Elm.Case.branch0
            (Can.nameToString variant.globalTagName |> Utils.String.formatValue)
            ([ typename ]
                |> toObject
                |> Elm.withType Gen.Json.Encode.annotation_.value
            )

    else
        let
            tagName =
                variant.globalTagName |> Can.nameToString
        in
        Elm.Case.branch1 (tagName |> Utils.String.formatValue)
            ( tagName ++ "__details", Type.named target.importFrom (tagName |> Utils.String.formatTypename) )
            (\details ->
                typename
                    :: encodeFields namespace selection details
                    |> toObject
                    |> Elm.withType Gen.Json.Encode.annotation_.value
            )


createBuilders : TargetModule -> Namespace -> Maybe Can.FragmentDetails -> List Can.Field -> List ( String, Elm.Declaration )
createBuilders targetModule namespace maybeFragmentName fields =
    List.concatMap
        (createBuilder targetModule namespace maybeFragmentName)
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


createBuilder : TargetModule -> Namespace -> Maybe Can.FragmentDetails -> Can.Field -> List ( String, Elm.Declaration )
createBuilder targetModule namespace maybeFragmentName field =
    let
        name =
            Can.getFieldName field
                |> Utils.String.formatValue
    in
    case field of
        Can.Frag fragment ->
            -- case fragment.fragment.selection of
            --     Can.FragmentObject { selection } ->
            --         createBuilders targetModule namespace (Just fragment) selection
            --     Can.FragmentUnion union ->
            --         let
            --             encoderName =
            --                 toEncoderName Nothing maybeFragmentName name
            --             builder =
            --                 createUnionEncoder targetModule namespace name encoderName union
            --             allSelections =
            --                 List.concatMap .selection union.variants
            --             innerBuilders =
            --                 createBuilders targetModule
            --                     namespace
            --                     maybeFragmentName
            --                     (union.selection ++ allSelections)
            --         in
            --         ( encoderName, builder )
            --             :: innerBuilders
            --     Can.FragmentInterface interface ->
            --         createBuilders targetModule namespace (Just fragment) interface.selection
            []

        Can.Field fieldDetails ->
            case fieldDetails.selectsOnlyFragment of
                Just onlyFragment ->
                    []

                Nothing ->
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
                                                        (Utils.String.formatTypename name)
                                                        |> Just

                                                Nothing ->
                                                    Type.named targetModule.importFrom globalAlias
                                                        |> Just

                                        Just frag ->
                                            Type.named frag.importFrom (Utils.String.formatTypename frag.name)
                                                |> Just

                                encoderName =
                                    toEncoderName fieldDetails.selectsOnlyFragment maybeFragmentName name

                                builder =
                                    createFieldsEncoder encoderName
                                        annotation
                                        namespace
                                        fields

                                innerBuilders =
                                    createBuilders targetModule namespace maybeFragmentName fields
                            in
                            ( encoderName, builder ) :: innerBuilders

                        Can.FieldUnion union ->
                            let
                                encoderName =
                                    toEncoderName fieldDetails.selectsOnlyFragment maybeFragmentName name

                                builder =
                                    createUnionEncoder targetModule namespace globalAlias encoderName union

                                allSelections =
                                    List.concatMap .selection union.variants

                                innerBuilders =
                                    createBuilders targetModule
                                        namespace
                                        maybeFragmentName
                                        (union.selection ++ allSelections)
                            in
                            ( encoderName, builder ) :: innerBuilders

                        Can.FieldInterface interface ->
                            let
                                encoderName =
                                    toEncoderName fieldDetails.selectsOnlyFragment maybeFragmentName name

                                builder =
                                    createFieldsEncoder encoderName Nothing namespace interface.selection

                                innerBuilders =
                                    createBuilders targetModule namespace maybeFragmentName interface.selection
                            in
                            ( encoderName, builder ) :: innerBuilders


toObject fields =
    Gen.Json.Encode.call_.object
        (fields
            |> Elm.list
        )


encodeFields : Namespace -> List Can.Field -> Elm.Expression -> List Elm.Expression
encodeFields namespace fields runtimeValue =
    let
        encodedFields =
            List.concatMap
                (encodeFragmentFields namespace Nothing runtimeValue)
                fields
    in
    List.reverse encodedFields


fieldToJson : String -> Elm.Expression -> Elm.Expression
fieldToJson name value =
    Elm.tuple (Elm.string name) value


encodeFragmentFields : Namespace -> Maybe Can.FragmentDetails -> Elm.Expression -> Can.Field -> List Elm.Expression
encodeFragmentFields namespace maybeParentFragment parentObjectRuntimeValue field =
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
            case fieldDetails.selectsOnlyFragment of
                Just onlyFragment ->
                    [ Elm.tuple
                        (Elm.string name)
                        (wrapEncoder fieldDetails.wrapper
                            (Elm.value
                                { importFrom = onlyFragment.importMockFrom
                                , name = "encode"
                                , annotation = Nothing
                                }
                            )
                            runtimeValue
                        )
                    ]

                Nothing ->
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
                            case maybeParentFragment of
                                Just parent ->
                                    [ Elm.tuple
                                        (Elm.string name)
                                        (wrapEncoder fieldDetails.wrapper
                                            (Elm.value
                                                { importFrom = parent.fragment.importMockFrom
                                                , name = "encode" ++ Utils.String.capitalize name
                                                , annotation = Nothing
                                                }
                                            )
                                            runtimeValue
                                        )
                                    ]

                                Nothing ->
                                    [ Elm.tuple (Elm.string name)
                                        (wrapEncoder fieldDetails.wrapper
                                            (Elm.val
                                                (toEncoderName fieldDetails.selectsOnlyFragment maybeParentFragment name)
                                            )
                                            runtimeValue
                                        )
                                    ]

                        Can.FieldUnion union ->
                            case maybeParentFragment of
                                Just parent ->
                                    [ Elm.tuple
                                        (Elm.string name)
                                        (wrapEncoder fieldDetails.wrapper
                                            (Elm.value
                                                { importFrom = parent.fragment.importMockFrom
                                                , name = "encode" ++ Utils.String.capitalize name
                                                , annotation = Nothing
                                                }
                                            )
                                            runtimeValue
                                        )
                                    ]

                                Nothing ->
                                    [ fieldToJson name
                                        (wrapEncoder fieldDetails.wrapper
                                            (Elm.val
                                                (toEncoderName fieldDetails.selectsOnlyFragment maybeParentFragment name)
                                            )
                                            runtimeValue
                                        )
                                    ]

                        Can.FieldInterface interface ->
                            case maybeParentFragment of
                                Just parent ->
                                    [ Elm.tuple
                                        (Elm.string name)
                                        (wrapEncoder fieldDetails.wrapper
                                            (Elm.value
                                                { importFrom = parent.fragment.importMockFrom
                                                , name = "encode" ++ Utils.String.capitalize name
                                                , annotation = Nothing
                                                }
                                            )
                                            runtimeValue
                                        )
                                    ]

                                Nothing ->
                                    [ fieldToJson name
                                        (encodeFields namespace
                                            interface.selection
                                            runtimeValue
                                            |> toObject
                                        )
                                    ]


encodeEnum : Namespace -> GraphQL.Schema.Wrapped -> Can.FieldEnumDetails -> Elm.Expression -> Elm.Expression
encodeEnum namespace wrapper enum value =
    wrapEncoder wrapper
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
        value


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
            Elm.Case.maybe value
                { nothing = Gen.Json.Encode.null
                , just =
                    ( "innerMaybeJust"
                    , \val ->
                        wrapEncoder inner encoder val
                    )
                }

        GraphQL.Schema.InList inner ->
            Gen.Json.Encode.call_.list
                (Elm.fn
                    ( "innerItemToEncode", Nothing )
                    (\innerValue ->
                        wrapEncoder inner encoder innerValue
                    )
                )
                value

        GraphQL.Schema.UnwrappedValue ->
            Elm.apply encoder [ value ]

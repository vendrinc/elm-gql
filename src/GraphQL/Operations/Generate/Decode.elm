module GraphQL.Operations.Generate.Decode exposing
    ( Index
    , Namespace
    , decodeFields
    , decodeInterface
    , decodeUnion
    , initIndex
    , removeTypename
    , unionVariantName
    )

import Elm
import Elm.Annotation as Type
import Elm.Case
import Elm.Op
import Gen.GraphQL.Decode
import Gen.GraphQL.Engine as Engine
import Gen.Json.Decode as Decode
import Generate.Input as Input
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Schema
import Utils.String


type alias Namespace =
    { namespace : String
    , enums : String
    }


type Index
    = Index Int (List Int)


isTopLevel : Index -> Bool
isTopLevel (Index i tail) =
    List.isEmpty tail


initIndex : Index
initIndex =
    Index 0 []


next : Index -> Index
next (Index top total) =
    Index (top + 1) total


child : Index -> Index
child (Index top total) =
    Index 0 (top :: total)


decodeScalarType : Namespace -> GraphQL.Schema.Type -> Elm.Expression
decodeScalarType namespace type_ =
    case type_ of
        GraphQL.Schema.Scalar scalarName ->
            case String.toLower scalarName of
                "int" ->
                    Decode.int

                "float" ->
                    Decode.float

                "string" ->
                    Decode.string

                "boolean" ->
                    Decode.bool

                _ ->
                    Elm.value
                        { importFrom =
                            [ namespace.namespace ]
                        , name = Utils.String.formatValue scalarName
                        , annotation =
                            Nothing
                        }
                        |> Elm.get "decoder"

        GraphQL.Schema.Nullable inner ->
            Decode.nullable (decodeScalarType namespace inner)

        GraphQL.Schema.List_ inner ->
            Decode.list (decodeScalarType namespace inner)

        _ ->
            Decode.succeed (Elm.string "DECODE UNKNOWN")


decodeFields : Namespace -> Elm.Expression -> Index -> List Can.Field -> Elm.Expression -> Elm.Expression
decodeFields namespace version index fields exp =
    fields
        |> List.reverse
        |> List.foldl
            (decodeFieldHelper namespace version)
            ( index, exp )
        |> Tuple.second


decodeFieldHelper : Namespace -> Elm.Expression -> Can.Field -> ( Index, Elm.Expression ) -> ( Index, Elm.Expression )
decodeFieldHelper namespace version field ( index, exp ) =
    case field of
        Can.Field details ->
            ( next index
            , exp
                |> decodeSingleField version
                    index
                    (Can.getAliasedName details)
                    (decodeSelection
                        namespace
                        version
                        details
                        (child index)
                        |> Input.decodeWrapper details.wrapper
                    )
            )

        Can.Frag fragment ->
            ( index
            , exp
                |> Elm.Op.pipe
                    (Elm.value
                        { importFrom =
                            fragment.fragment.importFrom
                        , name = "decoder"
                        , annotation = Nothing
                        }
                    )
            )


decodeSelection : Namespace -> Elm.Expression -> Can.FieldDetails -> Index -> Elm.Expression
decodeSelection namespace version field index =
    let
        start =
            case field.selectsOnlyFragment of
                Just fragment ->
                    Decode.succeed
                        (Elm.value
                            { importFrom =
                                fragment.importFrom
                            , name = fragment.name
                            , annotation =
                                Just (Type.named fragment.importFrom fragment.name)
                            }
                        )

                Nothing ->
                    Decode.succeed (Elm.val (Can.nameToString field.globalAlias))
    in
    -- NOTE: this withType thing is a workaround at the moment.  It's not even necessarily correct?
    -- If we don't have it, then the `Apps2` query with a union fragment will go into an infinite loop when generating
    -- The main issue seems to be with decodeUnion, but is also tricky
    -- This means elm-codegen still has an issue with type inference.
    -- We're not relying on type inference here, so it's not that big of a deal
    Elm.withType (Decode.annotation_.decoder (Type.named [] (Can.nameToString field.globalAlias))) <|
        case field.selection of
            Can.FieldObject objSelection ->
                start
                    |> decodeFields namespace
                        version
                        (child index)
                        objSelection

            Can.FieldScalar type_ ->
                decodeScalarType namespace type_

            Can.FieldEnum enum ->
                Elm.value
                    { importFrom =
                        [ namespace.enums
                        , "Enum"
                        , Utils.String.formatTypename enum.enumName
                        ]
                    , name = "decoder"
                    , annotation =
                        Nothing
                    }

            Can.FieldUnion union ->
                case field.selectsOnlyFragment of
                    Just fragment ->
                        Elm.value
                            { importFrom =
                                fragment.importFrom
                            , name = "decoder"
                            , annotation =
                                Nothing
                            }

                    Nothing ->
                        decodeUnion namespace
                            version
                            (child index)
                            union

            -- Elm.unit
            Can.FieldInterface interface ->
                start
                    |> decodeInterface namespace
                        version
                        (child index)
                        interface


decodeSingleField version index name decoder exp =
    exp
        |> Elm.Op.pipe
            (if isTopLevel index then
                Elm.apply
                    Gen.GraphQL.Decode.values_.versionedField
                    -- we only care about adjusting the aliases of the top-level things that could collide
                    [ version
                    , Elm.string name
                    , decoder
                    ]

             else
                Elm.apply
                    Gen.GraphQL.Decode.values_.field
                    -- we only care about adjusting the aliases of the top-level things that could collide
                    [ Elm.string name
                    , decoder
                    ]
            )


decodeInterface :
    Namespace
    -> Elm.Expression
    -> Index
    -> Can.FieldVariantDetails
    -> Elm.Expression
    -> Elm.Expression
decodeInterface namespace version index interface start =
    let
        selection =
            List.filter (not << Can.isTypeNameSelection) interface.selection
    in
    case interface.variants of
        [] ->
            start
                |> decodeFields namespace version (child index) selection

        _ ->
            start
                |> decodeFields namespace version (child index) selection
                |> andMap (decodeInterfaceSpecifics namespace version index interface)



-- interfacePattern : Namespace -> Elm.Expression -> Index ->


interfacePattern namespace version index commonFields var =
    let
        tag =
            Utils.String.formatTypename (Can.nameToString var.tag)

        tagTypeName =
            Can.nameToString var.globalTagName

        allFields =
            var.selection
    in
    ( tag
    , case List.filter removeTypename allFields of
        [] ->
            Decode.succeed
                (Elm.value
                    { importFrom = []
                    , name = tagTypeName
                    , annotation = Nothing
                    }
                )

        fields ->
            Decode.call_.map
                (Elm.val tagTypeName)
                (Decode.succeed
                    (Elm.val (Can.nameToString var.globalDetailsAlias))
                    |> decodeFields namespace version (child index) fields
                )
    )


decodeInterfaceSpecifics : Namespace -> Elm.Expression -> Index -> Can.FieldVariantDetails -> Elm.Expression
decodeInterfaceSpecifics namespace version index interface =
    Decode.field "__typename" Decode.string
        |> Decode.andThen
            (\val ->
                Elm.Case.string val
                    { cases =
                        List.map
                            (interfacePattern namespace
                                version
                                (child index)
                                interface.selection
                            )
                            interface.variants
                            ++ List.map
                                (\tag ->
                                    ( Can.nameToString tag.tag
                                    , Decode.succeed
                                        (Elm.value
                                            { importFrom = []
                                            , name = unionVariantName tag
                                            , annotation = Nothing
                                            }
                                        )
                                    )
                                )
                                interface.remainingTags
                    , otherwise =
                        Decode.fail "Unknown interface type"
                    }
            )



{- UNIONS -}


decodeUnion :
    Namespace
    -> Elm.Expression
    -> Index
    -> Can.FieldVariantDetails
    -> Elm.Expression
decodeUnion namespace version index union =
    Decode.field "__typename" Decode.string
        |> Decode.andThen
            (\typename ->
                Elm.Case.string typename
                    { cases =
                        List.map
                            (unionPattern namespace
                                version
                                (child index)
                            )
                            union.variants
                            ++ List.map
                                (\tag ->
                                    ( Can.nameToString tag.tag
                                    , Decode.succeed
                                        (Elm.value
                                            { importFrom = []
                                            , name = unionVariantName tag
                                            , annotation = Nothing
                                            }
                                        )
                                    )
                                )
                                union.remainingTags
                    , otherwise =
                        Decode.fail
                            "Unknown union found"
                    }
            )


unionPattern namespace version index var =
    let
        tag =
            Utils.String.formatTypename (Can.nameToString var.tag)

        tagTypeName =
            Can.nameToString var.globalTagName
    in
    ( tag
    , case List.filter removeTypename var.selection of
        [] ->
            Decode.succeed
                (Elm.value
                    { importFrom = []
                    , name = tagTypeName
                    , annotation = Nothing
                    }
                )

        fields ->
            let
                tagDetailsName =
                    Can.nameToString var.globalDetailsAlias
            in
            Decode.call_.map
                (Elm.value
                    { importFrom = []
                    , name = tagTypeName
                    , annotation = Nothing
                    }
                )
                (Decode.succeed
                    (Elm.value
                        { importFrom = []
                        , name = tagDetailsName
                        , annotation = Nothing
                        }
                    )
                    |> decodeFields namespace version (child index) fields
                )
    )



{- HELPERS -}


andMap : Elm.Expression -> Elm.Expression -> Elm.Expression
andMap decoder builder =
    builder
        |> Elm.Op.pipe
            (Elm.apply
                Gen.GraphQL.Decode.values_.andMap
                [ decoder
                ]
            )


removeTypename : Can.Field -> Bool
removeTypename field =
    case field of
        Can.Field details ->
            Can.nameToString details.name /= "__typename"

        _ ->
            True


unionVariantName tag =
    Can.nameToString tag.globalAlias

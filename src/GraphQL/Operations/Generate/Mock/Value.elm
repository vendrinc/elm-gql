module GraphQL.Operations.Generate.Mock.Value exposing (builders, expandedFields, field, variantBuilders)

import Elm
import Elm.Annotation as Type
import Generate.Path
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Generate.Decode exposing (Namespace)
import GraphQL.Operations.Generate.Types as GeneratedTypes
import GraphQL.Schema
import Utils.String


expandedFields :
    Namespace
    -> Can.Field
    -> List ( String, Elm.Expression )
expandedFields namespace fullField =
    expandedFieldsWith namespace Nothing fullField


expandedFieldsWith : Namespace -> Maybe Can.FragmentDetails -> Can.Field -> List ( String, Elm.Expression )
expandedFieldsWith namespace maybeParentFragment fullField =
    case fullField of
        Can.Frag fragment ->
            case fragment.fragment.selection of
                Can.FragmentObject { selection } ->
                    getExpandedRecordFields namespace (Just fragment) selection

                Can.FragmentUnion { selection, variants, remainingTags } ->
                    getExpandedRecordFields namespace (Just fragment) selection

                Can.FragmentInterface { selection, variants, remainingTags } ->
                    getExpandedRecordFields namespace (Just fragment) selection

        Can.Field fieldDetails ->
            case maybeParentFragment of
                Nothing ->
                    [ ( Can.getFieldName fullField
                            |> Utils.String.formatJsonFieldName
                      , field namespace fullField
                      )
                    ]

                Just parent ->
                    let
                        fieldName =
                            Can.getFieldName fullField
                    in
                    [ ( fieldName
                            |> Utils.String.formatJsonFieldName
                      , fragmentValue parent
                            |> Elm.get
                                (fieldName
                                    |> Utils.String.formatValue
                                )
                      )
                    ]


getExpandedRecordFields :
    Namespace
    -> Maybe Can.FragmentDetails
    -> List Can.Field
    -> List ( String, Elm.Expression )
getExpandedRecordFields namespace maybeParentFragment fields =
    List.concatMap
        (\fieldDetails ->
            if Can.isTypeNameSelection fieldDetails then
                []

            else
                expandedFieldsWith namespace maybeParentFragment fieldDetails
        )
        fields


fragmentValue : Can.FragmentDetails -> Elm.Expression
fragmentValue frag =
    Elm.value
        { importFrom = frag.fragment.importMockFrom
        , name = Utils.String.formatValue (Can.nameToString frag.fragment.name)
        , annotation = Nothing
        }


field :
    Namespace
    -> Can.Field
    -> Elm.Expression
field namespace fullField =
    case fullField of
        Can.Frag fragment ->
            fragmentValue fragment

        Can.Field fieldDetails ->
            case fieldDetails.selectsOnlyFragment of
                Just fragment ->
                    wrapScalar fieldDetails.wrapper <|
                        Elm.value
                            { importFrom = fragment.importMockFrom
                            , name = Utils.String.formatValue fragment.name
                            , annotation = Nothing
                            }

                Nothing ->
                    wrapScalar fieldDetails.wrapper <|
                        case fieldDetails.selection of
                            Can.FieldObject _ ->
                                Can.nameToString fieldDetails.globalAlias
                                    |> Utils.String.formatValue
                                    |> Elm.val

                            Can.FieldScalar type_ ->
                                mockScalar namespace fieldDetails type_

                            Can.FieldEnum enum ->
                                case enum.values of
                                    [] ->
                                        Elm.string "Enum with no values"

                                    top :: _ ->
                                        Elm.value
                                            { name = top.name
                                            , importFrom =
                                                [ namespace.enums
                                                , "Enum"
                                                , Utils.String.formatTypename enum.enumName
                                                ]
                                            , annotation =
                                                Just
                                                    (GeneratedTypes.enumType namespace enum.enumName)
                                            }

                            Can.FieldUnion _ ->
                                Can.nameToString fieldDetails.globalAlias
                                    |> Utils.String.formatValue
                                    |> Elm.val

                            Can.FieldInterface _ ->
                                Can.nameToString fieldDetails.globalAlias
                                    |> Utils.String.formatValue
                                    |> Elm.val


mockScalar : Namespace -> Can.FieldDetails -> GraphQL.Schema.Type -> Elm.Expression
mockScalar namespace fieldDetails scalar =
    case scalar of
        GraphQL.Schema.Scalar name ->
            case String.toLower name of
                "int" ->
                    Elm.int 5

                "float" ->
                    Elm.float 5

                "boolean" ->
                    Elm.bool True

                "string" ->
                    fieldDetails.alias_
                        |> Maybe.withDefault fieldDetails.name
                        |> Can.nameToString
                        |> Elm.string

                _ ->
                    Elm.value
                        { importFrom =
                            [ namespace.namespace
                            ]
                        , name = Utils.String.formatValue name
                        , annotation = Nothing
                        }
                        |> Elm.get "defaultTestingValue"

        GraphQL.Schema.InputObject _ ->
            Elm.unit

        GraphQL.Schema.Object _ ->
            Elm.unit

        GraphQL.Schema.Enum _ ->
            Elm.unit

        GraphQL.Schema.Union _ ->
            Elm.unit

        GraphQL.Schema.Interface _ ->
            Elm.unit

        GraphQL.Schema.List_ inner ->
            Elm.list [ mockScalar namespace fieldDetails inner ]

        GraphQL.Schema.Nullable inner ->
            Elm.just (mockScalar namespace fieldDetails inner)


wrapScalar : GraphQL.Schema.Wrapped -> Elm.Expression -> Elm.Expression
wrapScalar wrapper value =
    case wrapper of
        GraphQL.Schema.UnwrappedValue ->
            value

        GraphQL.Schema.InList inner ->
            Elm.list [ wrapScalar inner value ]

        GraphQL.Schema.InMaybe inner ->
            Elm.just (wrapScalar inner value)



{- BUILDERS -}


builders : Generate.Path.Paths -> Namespace -> Can.Field -> List Elm.Declaration
builders paths namespace fullField =
    case fullField of
        Can.Frag _ ->
            []

        Can.Field fieldDetails ->
            if fieldDetails.selectsOnlyFragment /= Nothing then
                []

            else
                case fieldDetails.selection of
                    Can.FieldScalar _ ->
                        -- Don't need builders for scalars
                        []

                    Can.FieldEnum _ ->
                        -- Don't need builders for enums
                        []

                    Can.FieldObject fields ->
                        let
                            objExpandedFields =
                                List.concatMap
                                    (expandedFields namespace)
                                    fields

                            objectType =
                                GeneratedTypes.toFields namespace [] fields
                                    |> Type.record

                            builderForThisObject =
                                Elm.declaration
                                    (fieldDetails.globalAlias
                                        |> Can.nameToString
                                        |> Utils.String.formatValue
                                    )
                                    (Elm.record objExpandedFields
                                        |> Elm.withType
                                            (Type.alias paths.modulePath
                                                (Can.nameToString fieldDetails.globalAlias)
                                                []
                                                objectType
                                            )
                                    )
                                    |> Elm.exposeWith
                                        { exposeConstructor = True
                                        , group = Just "builders"
                                        }

                            -- What is this, a builder for ANTS?!
                            buildersForChildren =
                                List.concatMap
                                    (builders paths namespace)
                                    fields
                        in
                        builderForThisObject :: buildersForChildren

                    Can.FieldUnion union ->
                        variantBuilders paths namespace fieldDetails union

                    Can.FieldInterface interface ->
                        -- We also need builders for the "specifics" of the interface
                        case interface.variants of
                            [] ->
                                let
                                    fields =
                                        interface.selection

                                    objectType =
                                        GeneratedTypes.toFields namespace [] fields
                                            |> Type.record

                                    builderForThisObject =
                                        Elm.declaration
                                            (fieldDetails.globalAlias
                                                |> Can.nameToString
                                                |> Utils.String.formatValue
                                            )
                                            (Elm.record
                                                (fields
                                                    |> List.reverse
                                                    |> List.concatMap
                                                        (\innerField ->
                                                            if Can.isTypeNameSelection innerField then
                                                                []

                                                            else
                                                                [ ( Can.getFieldName innerField
                                                                        |> Utils.String.formatJsonFieldName
                                                                  , field namespace innerField
                                                                  )
                                                                ]
                                                        )
                                                )
                                                |> Elm.withType
                                                    (Type.alias paths.modulePath
                                                        (Can.nameToString fieldDetails.globalAlias)
                                                        []
                                                        objectType
                                                    )
                                            )
                                            |> Elm.exposeWith
                                                { exposeConstructor = True
                                                , group = Just "builders"
                                                }

                                    -- What is this, a builder for ANTS?!
                                    buildersForChildren =
                                        List.concatMap
                                            (builders paths namespace)
                                            fields
                                in
                                builderForThisObject :: buildersForChildren

                            _ ->
                                let
                                    fields =
                                        interface.selection

                                    objectType =
                                        GeneratedTypes.toFields namespace [] fields
                                            |> Type.record

                                    recordFields =
                                        fields
                                            |> List.reverse
                                            |> List.concatMap
                                                (\innerField ->
                                                    if Can.isTypeNameSelection innerField then
                                                        []

                                                    else
                                                        [ ( Can.getFieldName innerField
                                                                |> Utils.String.formatJsonFieldName
                                                          , field namespace innerField
                                                          )
                                                        ]
                                                )

                                    specificsField =
                                        ( "specifics_"
                                            |> Utils.String.formatJsonFieldName
                                        , Elm.value
                                            { name =
                                                (Can.nameToString fieldDetails.globalAlias ++ "_specifics")
                                                    |> Utils.String.formatJsonFieldName
                                            , importFrom = []
                                            , annotation =
                                                Just (Type.namedWith paths.modulePath (Can.nameToString fieldDetails.globalAlias ++ "_Specifics") [])
                                            }
                                        )

                                    builderForThisObject =
                                        Elm.declaration
                                            (fieldDetails.globalAlias
                                                |> Can.nameToString
                                                |> Utils.String.formatValue
                                            )
                                            (Elm.record
                                                (recordFields ++ [ specificsField ])
                                                |> Elm.withType
                                                    (Type.alias paths.modulePath
                                                        (Can.nameToString fieldDetails.globalAlias)
                                                        []
                                                        objectType
                                                    )
                                            )
                                            |> Elm.exposeWith
                                                { exposeConstructor = True
                                                , group = Just "builders"
                                                }

                                    -- What is this, a builder for ANTS?!
                                    buildersForChildren =
                                        List.concatMap
                                            (builders paths namespace)
                                            fields

                                    buildersForVariants =
                                        variantBuildersForInterface paths namespace fieldDetails interface
                                in
                                builderForThisObject :: buildersForVariants ++ buildersForChildren


{-|

    There are some subtle differences between this code and the `variantBuilders` function.

-}
variantBuildersForInterface :
    Generate.Path.Paths
    -> Namespace
    ->
        { parentField
            | globalAlias : Can.Name
            , selectsOnlyFragment :
                Maybe
                    { importFrom : List String
                    , importMockFrom : List String
                    , name : String
                    }
        }
    -> Can.FieldVariantDetails
    -> List Elm.Declaration
variantBuildersForInterface paths namespace parentField variantDetails =
    if parentField.selectsOnlyFragment /= Nothing then
        []

    else
        let
            variantBuildersPrimary =
                List.concatMap
                    (generateVariantBuilder paths
                        namespace
                        variantTypeName
                        parentField
                        variantDetails
                    )
                    variantDetails.variants

            variantTypeName =
                Type.namedWith paths.modulePath (Can.nameToString parentField.globalAlias ++ "_Specifics") []

            variantBuildersForRemainigTags =
                List.map
                    (\tag ->
                        Elm.declaration (Utils.String.formatValue (Can.nameToString tag.globalAlias))
                            (Elm.value
                                { name = Can.nameToString tag.globalAlias
                                , importFrom = paths.modulePath
                                , annotation =
                                    Just variantTypeName
                                }
                            )
                            |> Elm.expose
                    )
                    variantDetails.remainingTags

            builtBuilders =
                Elm.comment (Can.nameToString parentField.globalAlias)
                    :: variantBuildersPrimary
                    ++ variantBuildersForRemainigTags

            defaultBuilderDeclarationName =
                Utils.String.formatValue (Can.nameToString parentField.globalAlias) ++ "_specifics"

            defaultBuilder name =
                Elm.declaration defaultBuilderDeclarationName
                    (Elm.value
                        { name = Utils.String.formatValue (Can.nameToString name)
                        , importFrom = []
                        , annotation =
                            Just variantTypeName
                        }
                    )
                    |> Elm.expose
        in
        case variantDetails.variants of
            [] ->
                case variantDetails.remainingTags of
                    [] ->
                        builtBuilders

                    topTag :: _ ->
                        defaultBuilder topTag.globalAlias :: builtBuilders

            topTag :: _ ->
                defaultBuilder topTag.globalTagName :: builtBuilders


variantBuilders :
    Generate.Path.Paths
    -> Namespace
    ->
        { parentField
            | globalAlias : Can.Name
            , selectsOnlyFragment :
                Maybe
                    { importFrom : List String
                    , importMockFrom : List String
                    , name : String
                    }
        }
    -> Can.FieldVariantDetails
    -> List Elm.Declaration
variantBuilders paths namespace parentField variantDetails =
    if parentField.selectsOnlyFragment /= Nothing then
        []

    else
        let
            variantBuildersPrimary =
                List.concatMap
                    (generateVariantBuilder paths
                        namespace
                        (Type.namedWith paths.modulePath
                            (Can.nameToString parentField.globalAlias)
                            []
                        )
                        parentField
                        variantDetails
                    )
                    variantDetails.variants

            variantBuildersForRemainigTags =
                List.map
                    (\tag ->
                        Elm.declaration (Utils.String.formatValue (Can.nameToString tag.globalAlias))
                            (Elm.value
                                { name = Can.nameToString tag.globalAlias
                                , importFrom = paths.modulePath
                                , annotation =
                                    Just (Type.namedWith paths.modulePath (Can.nameToString parentField.globalAlias) [])
                                }
                            )
                            |> Elm.expose
                    )
                    variantDetails.remainingTags

            builtBuilders =
                Elm.comment (Can.nameToString parentField.globalAlias)
                    :: variantBuildersPrimary
                    ++ variantBuildersForRemainigTags

            defaultBuilder name =
                Elm.declaration (Utils.String.formatValue (Can.nameToString parentField.globalAlias))
                    (Elm.value
                        { name = Utils.String.formatValue (Can.nameToString name)
                        , importFrom = []
                        , annotation =
                            Just (Type.namedWith paths.modulePath (Can.nameToString parentField.globalAlias) [])
                        }
                    )
                    |> Elm.expose
        in
        case variantDetails.variants of
            [] ->
                case variantDetails.remainingTags of
                    [] ->
                        builtBuilders

                    topTag :: _ ->
                        defaultBuilder topTag.globalAlias :: builtBuilders

            topTag :: _ ->
                defaultBuilder topTag.globalTagName :: builtBuilders


generateVariantBuilder :
    Generate.Path.Paths
    -> Namespace
    -> Type.Annotation
    ->
        { parentField
            | globalAlias : Can.Name
        }
    -> Can.FieldVariantDetails
    -> Can.VariantCase
    -> List Elm.Declaration
generateVariantBuilder paths namespace returnType parentDetails parent variant =
    let
        variantName =
            Can.nameToString variant.globalTagName

        fields =
            variant.selection

        detailsRecordFields =
            variant.selection
                |> List.reverse
                |> List.concatMap
                    (\fieldItem ->
                        if Can.isTypeNameSelection fieldItem then
                            []

                        else
                            [ ( Can.getFieldName fieldItem
                                    |> Utils.String.formatJsonFieldName
                              , field namespace fieldItem
                              )
                            ]
                    )

        builder =
            Elm.declaration
                (variantName
                    |> Utils.String.formatValue
                )
                (case detailsRecordFields of
                    [] ->
                        Elm.value
                            { name = variantName
                            , importFrom = paths.modulePath
                            , annotation = Nothing
                            }
                            |> Elm.withType
                                returnType

                    _ ->
                        Elm.record
                            detailsRecordFields
                            |> List.singleton
                            |> Elm.apply
                                (Elm.value
                                    { name = variantName
                                    , importFrom = paths.modulePath
                                    , annotation = Nothing
                                    }
                                )
                            |> Elm.withType
                                returnType
                )
                |> Elm.exposeWith
                    { exposeConstructor = True
                    , group = Just "builders"
                    }

        buildersForChildren =
            List.concatMap
                (builders paths namespace)
                fields
    in
    builder :: buildersForChildren

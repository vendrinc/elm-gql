module GraphQL.Operations.Generate.Types exposing
    ( generate
    , interfaceVariants
    , toAliasedFields
    , unionVars
    )

{-| -}

import Elm
import Elm.Annotation as Type
import Elm.Case
import Elm.Op
import Gen.GraphQL.Engine as Engine
import Gen.Json.Decode as Decode
import Generate.Input as Input
import Generate.Input.Encode
import Generate.Path
import Generate.Scalar
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Generate.Decode as GenDecode exposing (Namespace)
import GraphQL.Schema
import Utils.String


{-| -}
generate : Namespace -> List Can.Field -> List Elm.Declaration
generate namespace fields =
    generateTypesForFields (genAliasedTypes namespace)
        []
        fields


generateTypesForFields fn generated fields =
    case fields of
        [] ->
            generated

        top :: remaining ->
            let
                newStuff =
                    fn top
            in
            generateTypesForFields fn
                (generated ++ newStuff)
                remaining


genAliasedTypes : Namespace -> Can.Field -> List Elm.Declaration
genAliasedTypes namespace fieldOrFrag =
    case fieldOrFrag of
        Can.Frag _ ->
            []

        Can.Field field ->
            case field.selectsOnlyFragment of
                Just _ ->
                    []

                Nothing ->
                    let
                        name =
                            Can.nameToString field.globalAlias
                    in
                    case field.selection of
                        Can.FieldObject selection ->
                            let
                                newDecls =
                                    generateTypesForFields (genAliasedTypes namespace)
                                        []
                                        selection

                                fieldResult =
                                    toAliasedFields namespace [] selection
                            in
                            (Elm.alias name fieldResult
                                |> Elm.expose
                            )
                                :: newDecls

                        Can.FieldUnion union ->
                            let
                                newDecls =
                                    generateTypesForFields (genAliasedTypes namespace)
                                        []
                                        union.selection

                                final =
                                    List.foldl
                                        (unionVars namespace)
                                        { variants = []
                                        , declarations = []
                                        }
                                        union.variants

                                ghostVariants =
                                    List.map (Elm.variant << GenDecode.unionVariantName) union.remainingTags

                                -- Any records within variants
                            in
                            (Elm.customType
                                name
                                (final.variants ++ ghostVariants)
                                |> Elm.exposeWith
                                    { exposeConstructor = True
                                    , group = Just "unions"
                                    }
                            )
                                :: final.declarations
                                ++ newDecls

                        Can.FieldInterface interface ->
                            let
                                newDecls =
                                    generateTypesForFields (genAliasedTypes namespace)
                                        []
                                        interface.selection

                                selectingForVariants =
                                    case interface.variants of
                                        [] ->
                                            False

                                        _ ->
                                            True

                                -- Generate the record
                                interfaceRecord =
                                    toAliasedFields namespace
                                        (if selectingForVariants then
                                            [ ( "specifics_"
                                              , Type.named [] (name ++ "_Specifics")
                                              )
                                            ]

                                         else
                                            []
                                        )
                                        interface.selection

                                final =
                                    List.foldl
                                        (interfaceVariants namespace)
                                        { variants = []
                                        , declarations = []
                                        }
                                        interface.variants

                                ghostVariants =
                                    List.map (Elm.variant << GenDecode.unionVariantName) interface.remainingTags

                                withSpecificType existingList =
                                    if selectingForVariants then
                                        (Elm.customType
                                            (name ++ "_Specifics")
                                            (final.variants ++ ghostVariants)
                                            |> Elm.exposeWith
                                                { exposeConstructor = True
                                                , group = Just "unions"
                                                }
                                        )
                                            :: existingList

                                    else
                                        existingList
                            in
                            (Elm.alias name interfaceRecord
                                |> Elm.exposeWith { exposeConstructor = True, group = Just "necessary" }
                            )
                                :: withSpecificType
                                    (final.declarations
                                        ++ newDecls
                                    )

                        _ ->
                            []


{-| -}
unionVars :
    Namespace
    -> Can.VariantCase
    ->
        { variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
    ->
        { variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
unionVars namespace unionCase gathered =
    case List.filter GenDecode.removeTypename unionCase.selection of
        [] ->
            { declarations = gathered.declarations
            , variants =
                Elm.variant
                    (Can.nameToString unionCase.globalTagName)
                    :: gathered.variants
            }

        fields ->
            let
                record =
                    toAliasedFields namespace [] fields

                variantName =
                    Can.nameToString unionCase.globalTagName

                detailsName =
                    Can.nameToString unionCase.globalDetailsAlias

                recordAlias =
                    Elm.alias detailsName record
                        |> Elm.exposeWith
                            { exposeConstructor = True
                            , group = Just "necessary"
                            }

                -- aliases for subselections
                subfieldAliases =
                    generateTypesForFields (genAliasedTypes namespace)
                        []
                        fields
            in
            { variants =
                Elm.variantWith
                    variantName
                    [ Type.named [] detailsName
                    ]
                    :: gathered.variants
            , declarations =
                Elm.comment (Can.nameToString unionCase.tag)
                    :: recordAlias
                    :: subfieldAliases
                    ++ gathered.declarations
            }


{-| -}
interfaceVariants :
    Namespace
    -> Can.VariantCase
    ->
        { variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
    ->
        { variants : List Elm.Variant
        , declarations : List Elm.Declaration
        }
interfaceVariants namespace unionCase gathered =
    case List.filter GenDecode.removeTypename unionCase.selection of
        [] ->
            { variants =
                Elm.variant
                    (Can.nameToString unionCase.globalTagName)
                    :: gathered.variants
            , declarations = gathered.declarations
            }

        fields ->
            let
                record =
                    toAliasedFields namespace [] fields

                detailsName =
                    Can.nameToString unionCase.globalDetailsAlias

                recordAlias =
                    Elm.alias detailsName record
                        |> Elm.exposeWith
                            { exposeConstructor = True
                            , group = Just "necessary"
                            }

                -- aliases for subselections
                subfieldAliases =
                    generateTypesForFields (genAliasedTypes namespace)
                        []
                        fields
            in
            { variants =
                Elm.variantWith
                    (Can.nameToString unionCase.globalTagName)
                    [ Type.named [] detailsName
                    ]
                    :: gathered.variants
            , declarations =
                Elm.comment (Can.nameToString unionCase.tag)
                    :: recordAlias
                    :: subfieldAliases
                    ++ gathered.declarations
            }


toAliasedFields :
    Namespace
    -> List ( String, Type.Annotation )
    -> List Can.Field
    -> Type.Annotation
toAliasedFields namespace additionalFields selection =
    List.foldl (aliasedFieldRecord namespace)
        additionalFields
        selection
        |> Type.record


aliasedFieldRecord :
    Namespace
    -> Can.Field
    -> List ( String, Type.Annotation )
    -> List ( String, Type.Annotation )
aliasedFieldRecord namespace sel fields =
    if Can.isTypeNameSelection sel then
        -- skip it!
        fields

    else
        fieldAliasedAnnotation namespace sel ++ fields


fieldAliasedAnnotation :
    Namespace
    -> Can.Field
    -> List ( String, Type.Annotation )
fieldAliasedAnnotation namespace field =
    if Can.isTypeNameSelection field then
        []

    else
        case field of
            Can.Field details ->
                [ ( Utils.String.formatValue (Can.getAliasedName details)
                  , selectionAliasedAnnotation namespace details
                        |> Input.wrapElmType details.wrapper
                  )
                ]

            Can.Frag frag ->
                case frag.fragment.selection of
                    Can.FragmentObject { selection } ->
                        List.concatMap
                            (fieldAliasedAnnotation namespace)
                            selection

                    Can.FragmentUnion union ->
                        List.concatMap
                            (fieldAliasedAnnotation namespace)
                            union.selection

                    Can.FragmentInterface interface ->
                        if not (List.isEmpty interface.variants) || not (List.isEmpty interface.remainingTags) then
                            let
                                name =
                                    Can.nameToString frag.fragment.name
                            in
                            List.concatMap
                                (fieldAliasedAnnotation namespace)
                                interface.selection
                                ++ [ ( name, Type.named [] (name ++ "_Specifics") )
                                   ]

                        else
                            List.concatMap
                                (fieldAliasedAnnotation namespace)
                                interface.selection


selectionAliasedAnnotation :
    Namespace
    -> Can.FieldDetails
    -> Type.Annotation
selectionAliasedAnnotation namespace field =
    case field.selectsOnlyFragment of
        Just fragment ->
            Type.named
                fragment.importFrom
                fragment.name

        Nothing ->
            case field.selection of
                Can.FieldObject _ ->
                    Type.named
                        []
                        (Can.nameToString field.globalAlias)

                Can.FieldScalar type_ ->
                    schemaTypeToPrefab namespace type_

                Can.FieldEnum enum ->
                    enumType namespace enum.enumName

                Can.FieldUnion _ ->
                    Type.named
                        []
                        (Can.nameToString field.globalAlias)

                Can.FieldInterface _ ->
                    Type.named
                        []
                        (Can.nameToString field.globalAlias)


enumType : Namespace -> String -> Type.Annotation
enumType namespace enumName =
    Type.named
        [ namespace.enums
        , "Enum"
        , Utils.String.formatTypename enumName
        ]
        enumName


schemaTypeToPrefab : Namespace -> GraphQL.Schema.Type -> Type.Annotation
schemaTypeToPrefab namespace schemaType =
    case schemaType of
        GraphQL.Schema.Scalar scalarName ->
            Generate.Scalar.type_ namespace scalarName

        GraphQL.Schema.InputObject _ ->
            Type.unit

        GraphQL.Schema.Object _ ->
            Type.unit

        GraphQL.Schema.Enum _ ->
            Type.unit

        GraphQL.Schema.Union _ ->
            Type.unit

        GraphQL.Schema.Interface _ ->
            Type.unit

        GraphQL.Schema.List_ inner ->
            Type.list (schemaTypeToPrefab namespace inner)

        GraphQL.Schema.Nullable inner ->
            Type.maybe (schemaTypeToPrefab namespace inner)

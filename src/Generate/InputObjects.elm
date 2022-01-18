module Generate.InputObjects exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation as Type
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Encode as Encode
import Generate.Args
import Generate.Common
import GraphQL.Schema exposing (Namespace, getWrap)
import Utils.String


inputObjectToOptionalBuilders : Namespace -> GraphQL.Schema.Schema -> GraphQL.Schema.InputObjectDetails -> List Elm.File
inputObjectToOptionalBuilders namespace schema input =
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

        hasOptionalArgs =
            case optional of
                [] ->
                    False

                _ ->
                    True

        optionalTypeAlias =
            Elm.alias "Optional"
                (Engine.types_.optional
                    (Type.named [ namespace.namespace ]
                        input.name
                    )
                )
                |> Elm.expose
    in
    if hasOptionalArgs then
        [ Elm.file [ namespace.namespace, Utils.String.formatTypename input.name ]
            (optionalTypeAlias
                :: Generate.Args.optionsRecursive namespace
                    schema
                    input.name
                    optional
                ++ [ Generate.Args.nullsRecord namespace input.name optional
                        |> Elm.declaration "null"
                        |> Elm.expose
                   ]
            )
        ]

    else
        []


generateFiles : Namespace -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace schema =
    let
        objects =
            schema.inputObjects
                |> Dict.toList
                |> List.map Tuple.second

        -- optionalFiles =
        --     objects
        --         |> List.concatMap (inputObjectToOptionalBuilders namespace schema)
        newOptionalFiles =
            objects
                |> List.filterMap (renderNewOptionalFiles namespace schema)
    in
    newOptional namespace schema objects :: newOptionalFiles



{- NEW OPTIONAL HANDLING!! -}


renderNewOptionalFiles :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.InputObjectDetails
    -> Maybe Elm.File
renderNewOptionalFiles namespace schema input =
    Just
        (Elm.file
            [ namespace.namespace
            , "Input"
            , Utils.String.formatTypename input.name
            ]
            (renderNewOptionalSingleFile namespace schema input)
        )


{-| -}
newOptional :
    Namespace
    -> GraphQL.Schema.Schema
    -> List GraphQL.Schema.InputObjectDetails
    -> Elm.File
newOptional namespace schema inputObjects =
    Elm.file [ namespace.namespace, "Input" ]
        (List.concatMap
            (renderNewOptional namespace schema)
            inputObjects
        )


renderNewOptional :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.InputObjectDetails
    -> List Elm.Declaration
renderNewOptional namespace schema input =
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
    [ Elm.alias input.name
        (Engine.types_.inputObject
            (Type.named [ namespace.namespace ]
                input.name
            )
        )
        |> Elm.expose
        |> Elm.withDocumentation """

"""
    , Elm.declaration input.name
        (Elm.record
            (List.concat
                [ [ case required of
                        [] ->
                            Elm.field "input"
                                (Engine.inputObject
                                    -- Elm.record
                                    -- (List.map
                                    --     (\field ->
                                    --         Elm.field field.name Engine.make_.option.absent
                                    --     )
                                    --     input.fields
                                    -- )
                                    |> Elm.withType (Type.named [] input.name)
                                )

                        _ ->
                            Elm.field "input"
                                (Elm.lambda "required"
                                    (Type.record
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
                                        Elm.record
                                            (List.map
                                                (\field ->
                                                    case field.type_ of
                                                        GraphQL.Schema.Nullable innerType ->
                                                            Elm.field field.name Engine.make_.option.absent

                                                        _ ->
                                                            Elm.field field.name
                                                                (val
                                                                    |> Elm.get field.name
                                                                )
                                                )
                                                input.fields
                                            )
                                            |> Elm.withType (Type.named [] input.name)
                                    )
                                )
                  ]
                , List.map
                    (\field ->
                        Elm.field field.name
                            (Elm.lambda2 "recordUpdate"
                                (case field.type_ of
                                    GraphQL.Schema.Nullable type_ ->
                                        toElmType namespace schema type_ (GraphQL.Schema.getWrap type_)

                                    _ ->
                                        Type.unit
                                )
                                (Type.named [] input.name)
                                (\new val ->
                                    Elm.updateRecord "recordUpdate2"
                                        [ ( field.name, Engine.make_.option.present new )
                                        ]
                                        |> Elm.withType (Type.named [] input.name)
                                )
                            )
                    )
                    optional
                , case optional of
                    [] ->
                        []

                    _ ->
                        [ nullsRecord namespace input.name optional
                            |> Elm.field "null"
                        ]
                ]
            )
        )
        |> Elm.expose
    ]


renderNewOptionalSingleFile :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.InputObjectDetails
    -> List Elm.Declaration
renderNewOptionalSingleFile namespace schema input =
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
    List.concat
        [ [ Elm.alias input.name
                (Engine.types_.inputObject
                    (Type.named [ namespace.namespace ]
                        input.name
                    )
                )
                |> Elm.expose
                |> Elm.withDocumentation """

"""
          ]
        , List.concat
            [ [ case required of
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
                                -- Elm.record
                                --     (List.map
                                --         (\field ->
                                --             case field.type_ of
                                --                 GraphQL.Schema.Nullable innerType ->
                                --                     Elm.field field.name Engine.make_.option.absent
                                --                 _ ->
                                --                     Elm.field field.name
                                -- (val
                                --     |> Elm.get field.name
                                -- )
                                --         )
                                --         input.fields
                                --     )
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
              ]
            , List.filterMap
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
                optional
            , case optional of
                [] ->
                    []

                _ ->
                    [ nullsRecord namespace input.name optional
                        |> Elm.declaration "null"
                        |> Elm.exposeAndGroup "null"
                    ]
            ]
        ]


nullsRecord :
    Namespace
    -> String
    ->
        List
            { fieldOrArg
                | name : String
                , type_ : GraphQL.Schema.Type
                , description : Maybe String
            }
    -> Elm.Expression
nullsRecord namespace name fields =
    Elm.record
        (List.map
            (\field ->
                Elm.field
                    (Utils.String.formatValue field.name)
                    (Elm.lambda "inputObj"
                        (Type.named [] name)
                        (\inputObj ->
                            inputObj
                                |> Engine.addField (Elm.string field.name) Encode.null
                                |> Elm.withType (Type.named [] name)
                        )
                    )
            )
            fields
        )



{- Preparing arguments -}


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
            Type.named [] inputName
                |> Generate.Args.unwrapWith wrapped

        GraphQL.Schema.Object nestedObjectName ->
            -- not used as input
            Generate.Common.selection namespace.namespace
                nestedObjectName
                (Type.var "data")

        GraphQL.Schema.Union unionName ->
            -- not used as input
            -- Note, we need a discriminator instead of just `data`
            Generate.Common.selection namespace.namespace
                unionName
                (Type.var "data")
                |> Generate.Args.unwrapWith wrapped

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
                        (\v ->
                            Engine.encodeInputObject v (Elm.string inputName)
                        )
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

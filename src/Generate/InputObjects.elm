module Generate.InputObjects exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation as Type
import Elm.Gen.GraphQL.Engine as Engine
import Generate.Input.Encode
import GraphQL.Schema exposing (Namespace)
import Utils.String


generateFiles : Namespace -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace schema =
    let
        objects =
            schema.inputObjects
                |> Dict.toList
                |> List.map Tuple.second

        newOptionalFiles =
            objects
                |> List.filterMap (renderNewOptionalFiles namespace schema)
    in
    inputMainFile namespace schema objects
        :: newOptionalFiles



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



{- THE MAIN INPUT.elm file -}


{-| -}
inputMainFile :
    Namespace
    -> GraphQL.Schema.Schema
    -> List GraphQL.Schema.InputObjectDetails
    -> Elm.File
inputMainFile namespace schema inputObjects =
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
        lockName =
            input.name ++ "_"
    in
    [ Elm.alias input.name
        (Engine.types_.inputObject
            (Type.named []
                lockName
            )
        )
        |> Elm.expose
    , Elm.customType lockName
        [ Elm.variant lockName
        ]
        |> Elm.expose
    ]



{- INDIVIDUAL INPUT FILES -}


renderNewOptionalSingleFile :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.InputObjectDetails
    -> List Elm.Declaration
renderNewOptionalSingleFile namespace schema input =
    if List.all areOptional input.fields && input.isOneOf then
        oneOf namespace schema input

    else
        List.concat
            [ [ Elm.alias input.name
                    (Type.named [ namespace.namespace, "Input" ]
                        input.name
                    )
                    |> Elm.expose
                    |> Elm.withDocumentation """

"""
              ]
            , List.concat
                [ [ Generate.Input.Encode.toInputObject namespace
                        schema
                        input
                  ]
                , Generate.Input.Encode.toOptionHelpers namespace
                    schema
                    input
                , Generate.Input.Encode.toNulls input.name input.fields
                ]
            ]


areOptional field =
    case field.type_ of
        GraphQL.Schema.Nullable _ ->
            True

        _ ->
            False


{-| This can be implemented if we know that a definition
-}
hasOneOfDirective : GraphQL.Schema.InputObjectDetails -> Bool
hasOneOfDirective input =
    False


oneOf :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.InputObjectDetails
    -> List Elm.Declaration
oneOf namespace schema input =
    List.concat
        [ Generate.Input.Encode.toOneOfHelper namespace
            schema
            input
        , Generate.Input.Encode.toOneOfNulls input.name input.fields
        ]

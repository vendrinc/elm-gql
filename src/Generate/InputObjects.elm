module Generate.InputObjects exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Generate.Args
import GraphQL.Schema
import GraphQL.Schema.InputObject
import GraphQL.Schema.Type exposing (Type(..))


inputObjectToOptionalBuilders : String -> GraphQL.Schema.Schema -> GraphQL.Schema.InputObject.InputObject -> List Elm.File
inputObjectToOptionalBuilders namespace schema input =
    let
        ( required, optional ) =
            List.partition
                (\arg ->
                    case arg.type_ of
                        GraphQL.Schema.Type.Nullable innerType ->
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
            Elm.aliasWith "Optional"
                []
                (Engine.typeOptional.annotation
                    (Elm.Annotation.named (Elm.moduleName [ namespace ])
                        input.name
                    )
                )
                |> Elm.expose
    in
    if hasOptionalArgs then
        [ Elm.file [ namespace, input.name ]
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


generateFiles : String -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace schema =
    let
        objects =
            schema.inputObjects
                |> Dict.toList
                |> List.map Tuple.second

        optionalFiles =
            objects
                |> List.concatMap (inputObjectToOptionalBuilders namespace schema)
    in
    optionalFiles

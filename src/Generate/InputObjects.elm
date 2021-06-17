module Generate.InputObjects exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.List
import Generate.Args
import GraphQL.Schema
import GraphQL.Schema.InputObject
import GraphQL.Schema.Type exposing (Type(..))


inputObjectToDeclarations : String -> GraphQL.Schema.Schema -> GraphQL.Schema.InputObject.InputObject -> List Elm.Declaration
inputObjectToDeclarations namespace schema input =
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

        optionalConstructor =
            if hasOptionalArgs then
                Just
                    (Generate.Args.optionalMaker namespace
                        input.name
                        optional
                        |> Elm.expose
                    )

            else
                Nothing

        inputDecl =
            Generate.Args.createBuilder namespace
                schema
                input.name
                input.fields
                (Object input.name)
    in
    List.filterMap identity
        [ inputDecl
            |> Elm.expose
            |> Just
        , optionalConstructor
        ]


generateFiles : String -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace schema =
    let
        objects =
            schema.inputObjects
                |> Dict.toList
                |> List.map Tuple.second

        --|> List.filter (\object -> String.toLower object.name == "setassignedappid")
        declarations =
            objects
                |> List.concatMap (inputObjectToDeclarations namespace schema)
    in
    [ Elm.file (Elm.moduleName [ namespace, "Input" ])
        ""
        declarations
    ]

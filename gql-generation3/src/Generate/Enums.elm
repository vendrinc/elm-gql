module Generate.Enums exposing (generateFiles)

import Dict
import Elm
import Elm.Gen.Json.Decode
import Elm.Pattern
import Elm.Type
import GraphQL.Schema
import String.Extra as String


enumNameToConstructorName =
    String.toSentenceCase


generateFiles : GraphQL.Schema.Schema -> List Elm.File
generateFiles graphQLSchema =
    graphQLSchema.enums
        |> Dict.toList
        |> List.map
            (\( _, enumDefinition ) ->
                let
                    constructors =
                        enumDefinition.values
                            |> List.map .name
                            |> List.map (\name -> ( enumNameToConstructorName name, [] ))

                    enumTypeDeclaration =
                        Elm.Type.custom enumDefinition.name
                            constructors

                    listOfValues =
                        constructors
                            |> List.map (Tuple.first >> Elm.value)
                            |> Elm.list
                            |> Elm.declaration "list"

                    enumDecoder =
                        Elm.declaration "decoder"
                            (Elm.Gen.Json.Decode.string
                                |> Elm.pipe
                                    (Elm.apply
                                        Elm.Gen.Json.Decode.andThen
                                        [ Elm.lambda [ Elm.Pattern.var "string" ]
                                            (Elm.caseOf (Elm.value "string")
                                                ((constructors
                                                    |> List.map
                                                        (\( name, _ ) ->
                                                            ( Elm.Pattern.string name, Elm.apply Elm.Gen.Json.Decode.succeed [ Elm.value name ] )
                                                        )
                                                 )
                                                    ++ [ ( Elm.Pattern.skip, Elm.apply Elm.Gen.Json.Decode.fail [ Elm.string "Invalid type" ] ) ]
                                                )
                                            )
                                        ]
                                    )
                            )
                in
                Elm.file (Elm.moduleName [ "TnGql", "Enum", enumDefinition.name ])
                    [ enumTypeDeclaration
                        |> Elm.expose
                    , listOfValues
                        |> Elm.expose
                    , enumDecoder
                    ]
            )

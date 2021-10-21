module Generate.Enums exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.Json.Decode as Decode
import Elm.Gen.Json.Encode as Encode
import Elm.Pattern
import Generate.Common
import GraphQL.Schema
import Utils.String


enumNameToConstructorName : String -> String
enumNameToConstructorName =
    Utils.String.formatTypename


generateFiles : String -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace graphQLSchema =
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
                        Elm.customType enumDefinition.name
                            (List.map (\(name,vals) -> Elm.variantWith name vals) constructors)

                    listOfValues =
                        constructors
                            |> List.map
                                (\( enumName, _ ) ->
                                    Elm.valueWith
                                        ( [])
                                        enumName
                                        (Elm.Annotation.named [] enumDefinition.name)
                                )
                            |> Elm.list
                            |> Elm.declaration "list"

                    enumDecoder =
                        Elm.declaration "decoder"
                            (Decode.string
                                |> Decode.andThen
                                    (\_ ->
                                        Elm.lambda "string"
                                            Elm.Annotation.string
                                            (\str ->
                                                Elm.caseOf str
                                                    ((constructors
                                                        |> List.map
                                                            (\( name, _ ) ->
                                                                ( Elm.Pattern.string name
                                                                , Decode.succeed
                                                                    (Elm.valueWith []
                                                                        name
                                                                        (Elm.Annotation.named [] enumDefinition.name)
                                                                    )
                                                                )
                                                            )
                                                     )
                                                        ++ [ ( Elm.Pattern.wildcard, Decode.fail (Elm.string "Invalid type") ) ]
                                                    )
                                            )
                                    )
                                |> Elm.withType
                                    (Decode.types_.decoder
                                        (Elm.Annotation.named [] enumDefinition.name)
                                    )
                            )

                    enumEncoder =
                        Elm.fn "encode"
                            ( "val", Elm.Annotation.named [] enumDefinition.name )
                            (\val ->
                                Elm.caseOf val
                                    (enumDefinition.values
                                        |> List.map
                                            (\variant ->
                                                ( Elm.Pattern.named (enumNameToConstructorName variant.name) []
                                                , Encode.string (Elm.string variant.name)
                                                )
                                            )
                                    )
                            )
                in
                Elm.file
                    (Generate.Common.modules.enum namespace enumDefinition.name)
                    [ enumTypeDeclaration
                        |> Elm.exposeConstructor
                    , listOfValues
                        |> Elm.expose
                    , enumDecoder
                        |> Elm.expose
                    , enumEncoder
                        |> Elm.expose
                    ]
            )

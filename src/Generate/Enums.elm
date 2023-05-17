module Generate.Enums exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Case
import Gen.Json.Decode as Decode
import Gen.Json.Encode as Encode
import Generate.Common
import GraphQL.Schema exposing (Namespace)
import Utils.String


enumNameToConstructorName : String -> String
enumNameToConstructorName =
    Utils.String.formatTypename


generateFiles : Namespace -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace graphQLSchema =
    graphQLSchema.enums
        |> Dict.toList
        |> List.filterMap
            (\( _, enumDefinition ) ->
                if String.startsWith "_" enumDefinition.name then
                    Nothing

                else
                    let
                        constructors =
                            enumDefinition.values
                                |> List.map .name
                                |> List.map (\name -> ( enumNameToConstructorName name, [] ))

                        enumTypeDeclaration =
                            Elm.customType enumDefinition.name
                                (List.map (\( name, vals ) -> Elm.variantWith name vals) constructors)

                        listOfValues =
                            constructors
                                |> List.map
                                    (\( enumName, _ ) ->
                                        Elm.value
                                            { importFrom = []
                                            , name = enumName
                                            , annotation = Just (Elm.Annotation.named [] enumDefinition.name)
                                            }
                                    )
                                |> Elm.list
                                |> Elm.declaration "all"

                        enumDecoder =
                            Elm.declaration "decoder"
                                (Decode.string
                                    |> Decode.andThen
                                        (\str ->
                                            Elm.Case.string str
                                                { cases =
                                                    constructors
                                                        |> List.map
                                                            (\( name, _ ) ->
                                                                ( name
                                                                , Decode.succeed
                                                                    (Elm.value
                                                                        { importFrom = []
                                                                        , name = name
                                                                        , annotation = Just (Elm.Annotation.named [] enumDefinition.name)
                                                                        }
                                                                    )
                                                                )
                                                            )
                                                , otherwise = Decode.fail "Invalid type"
                                                }
                                        )
                                    |> Elm.withType
                                        (Decode.annotation_.decoder
                                            (Elm.Annotation.named [] enumDefinition.name)
                                        )
                                )

                        enumEncoder =
                            Elm.declaration "encode" <|
                                Elm.fn
                                    ( "val", Just (Elm.Annotation.named [] enumDefinition.name) )
                                    (\val ->
                                        Elm.Case.custom val
                                            (Elm.Annotation.named [] enumDefinition.name)
                                            (enumDefinition.values
                                                |> List.map
                                                    (\variant ->
                                                        Elm.Case.branch0 (enumNameToConstructorName variant.name)
                                                            (Encode.string variant.name)
                                                    )
                                            )
                                    )
                    in
                    Just <|
                        Elm.fileWith (Generate.Common.modules.enumSourceModule namespace enumDefinition.name)
                            { aliases = []
                            , docs =
                                \docs ->
                                    [ "\nThis file wass generated using `elm-gql`" ++ """

Please avoid modifying directly.
""" ++ Help.renderStandardComment docs
                                    ]
                            }
                            [ enumTypeDeclaration
                                |> Elm.exposeWith { exposeConstructor = True, group = Nothing }
                            , listOfValues
                                |> Elm.expose
                            , enumDecoder
                                |> Elm.expose
                            , enumEncoder
                                |> Elm.expose
                            ]
            )

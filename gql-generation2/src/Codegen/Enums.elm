module Codegen.Enums exposing (generateFiles)

import Codegen.Common
import Dict
import Elm.CodeGen as Elm
import GraphQL.Schema
import Json.Decode as Json
import String.Extra as String


enumNameToConstructorName =
    String.toSentenceCase


moduleFqJsonDecode =
    [ "Json", "Decode" ]


moduleJsonDecode =
    [ "Decode" ]


importJson =
    Elm.importStmt moduleFqJsonDecode (Just moduleJsonDecode) (Just ([ Elm.funExpose "Decoder" ] |> Elm.exposeExplicit))


generateFiles : GraphQL.Schema.Schema -> List Codegen.Common.File
generateFiles graphQLSchema =
    graphQLSchema.enums
        |> Dict.toList
        |> List.map
            (\( _, enumDefinition ) ->
                let
                    moduleName =
                        [ "TnGql", "Enum", enumDefinition.name ]

                    module_ =
                        Elm.normalModule moduleName []

                    docs =
                        Nothing

                    constructors =
                        enumDefinition.values
                            |> List.map .name
                            |> List.map (\name -> ( enumNameToConstructorName name, [] ))

                    enumType =
                        Elm.customTypeDecl docs enumDefinition.name [] constructors

                    listOfValues =
                        Elm.valDecl Nothing
                            (Just
                                (Elm.listAnn (Elm.typed enumDefinition.name []))
                            )
                            "list"
                            (Elm.list
                                (constructors |> List.map Tuple.first |> List.map (Elm.fqVal []))
                            )

                    enumDecoder =
                        Elm.valDecl Nothing
                            (Just (Elm.typed "Decoder" [ Elm.typed enumDefinition.name [] ]))
                            "decoder"
                            (Elm.pipe (Elm.fqFun moduleJsonDecode "string")
                                [ Elm.apply
                                    [ Elm.fqFun moduleJsonDecode "andThen"
                                    , Elm.lambda [ Elm.varPattern "string" ]
                                        (Elm.caseExpr (Elm.val "string")
                                            ((enumDefinition.values
                                                |> List.map
                                                    (\value ->
                                                        ( Elm.stringPattern value.name
                                                        , Elm.apply
                                                            [ Elm.fqFun moduleJsonDecode "succeed"
                                                            , Elm.fqVal [] (enumNameToConstructorName value.name)
                                                            ]
                                                        )
                                                    )
                                             )
                                                ++ [ ( Elm.allPattern
                                                     , Elm.apply
                                                        [ Elm.fqFun moduleJsonDecode "fail"
                                                        , Elm.string
                                                            ("Invalid "
                                                                ++ enumDefinition.name
                                                                ++ " type"
                                                            )
                                                        ]
                                                     )
                                                   ]
                                            )
                                        )
                                    ]
                                ]
                            )
                in
                { name = moduleName
                , file =
                    Elm.file module_
                        [ importJson
                        ]
                        [ enumType, listOfValues, enumDecoder ]
                        Nothing
                }
            )

module Codegen.Enums exposing (generateFiles)


import Codegen.Common as Common
import Dict
import Elm.CodeGen as Elm
import GraphQL.Schema
import String.Extra as String


enumNameToConstructorName =
    String.toSentenceCase


generateFiles : GraphQL.Schema.Schema -> List Common.File
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
                            (Elm.pipe (Elm.fqFun Common.modules.decode.name "string")
                                [ Elm.apply
                                    [ Elm.fqFun Common.modules.decode.name "andThen"
                                    , Elm.lambda [ Elm.varPattern "string" ]
                                        (Elm.caseExpr (Elm.val "string")
                                            ((enumDefinition.values
                                                |> List.map
                                                    (\value ->
                                                        ( Elm.stringPattern value.name
                                                        , Elm.apply
                                                            [ Elm.fqFun Common.modules.decode.name "succeed"
                                                            , Elm.fqVal [] (enumNameToConstructorName value.name)
                                                            ]
                                                        )
                                                    )
                                             )
                                                ++ [ ( Elm.allPattern
                                                     , Elm.apply
                                                        [ Elm.fqFun Common.modules.decode.name "fail"
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
                        [ Common.modules.decode.import_
                        ]
                        [ enumType, listOfValues, enumDecoder ]
                        Nothing
                }
            )

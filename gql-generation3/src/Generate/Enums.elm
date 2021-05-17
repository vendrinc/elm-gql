module Generate.Enums exposing (generateFiles)

import Dict
import Elm
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
                    moduleName =
                        [ "TnGql", "Enum", enumDefinition.name ]

                    -- module_ =
                    --     Elm.normalModule moduleName []
                    constructors =
                        enumDefinition.values
                            |> List.map .name
                            |> List.map (\name -> ( enumNameToConstructorName name, [] ))

                    -- enumType =
                    --     Elm.valueFrom
                    --     Elm.customTypeDecl docs enumDefinition.name [] constructors
                    listOfValues =
                        constructors
                            |> List.map (Tuple.first >> Elm.value)
                            |> Elm.list
                            |> Elm.declaration "list"

                    -- enumDecoder =
                    --     Elm.valDecl Nothing
                    --         (Just (Elm.typed "Decoder" [ Elm.typed enumDefinition.name [] ]))
                    --         "decoder"
                    --         (Elm.pipe (Elm.fqFun Common.modules.decode.name "string")
                    --             [ Elm.apply
                    --                 [ Elm.fqFun Common.modules.decode.name "andThen"
                    --                 , Elm.lambda [ Elm.varPattern "string" ]
                    --                     (Elm.caseExpr (Elm.val "string")
                    --                         ((enumDefinition.values
                    --                             |> List.map
                    --                                 (\value ->
                    --                                     ( Elm.stringPattern value.name
                    --                                     , Elm.apply
                    --                                         [ Elm.fqFun Common.modules.decode.name "succeed"
                    --                                         , Elm.fqVal [] (enumNameToConstructorName value.name)
                    --                                         ]
                    --                                     )
                    --                                 )
                    --                          )
                    --                             ++ [ ( Elm.allPattern
                    --                                  , Elm.apply
                    --                                     [ Elm.fqFun Common.modules.decode.name "fail"
                    --                                     , Elm.string
                    --                                         ("Invalid "
                    --                                             ++ enumDefinition.name
                    --                                             ++ " type"
                    --                                         )
                    --                                     ]
                    --                                  )
                    --                                ]
                    --                         )
                    --                     )
                    --                 ]
                    --             ]
                    --         )
                in
                Elm.file (Elm.moduleName [ "Enum", enumDefinition.name ])
                    [ -- enumType
                      listOfValues |> Elm.expose

                    -- , enumDecoder
                    ]
            )

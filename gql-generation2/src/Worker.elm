port module Worker exposing (main)

import Debug
import Dict
import Elm.CodeGen as Elm
import Elm.Pretty as Elm
import GraphQL.Schema
import Json.Decode as Json
import String.Extra as String


port writeElmFile : { moduleName : String, contents : String } -> Cmd msg


main : Program Flags () Never
main =
    Platform.worker
        { init = \flags -> ( (), run flags )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }



-- ACTUAL APP


type alias Flags =
    { schemaJson : Json.Value
    }


run : Flags -> Cmd msg
run flags =
    let
        schema =
            (case Json.decodeValue GraphQL.Schema.decoder flags.schemaJson of
                Ok schema_ ->
                    Just schema_

                Err error ->
                    Nothing
            )
                |> Maybe.withDefault GraphQL.Schema.empty

        enumFiles =
            Debug.log "enumFiles"
                (schema.enums
                    |> Dict.toList
                    |> List.map
                        (\( enumRef, enumDefinition ) ->
                            let
                                moduleName_ =
                                    [ "TnGql", "Enum", enumDefinition.name ]

                                module_ =
                                    Elm.normalModule moduleName_ []

                                docs =
                                    Nothing

                                enumNameToConstructorName =
                                    String.toSentenceCase

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
                                        (Elm.pipe (Elm.fun "Decode.string")
                                            [ Elm.apply
                                                [ Elm.fun "Decode.andThen"
                                                , Elm.lambda [ Elm.varPattern "string" ]
                                                    (Elm.caseExpr (Elm.val "string")
                                                        ((enumDefinition.values
                                                            |> List.map
                                                                (\value ->
                                                                    ( Elm.stringPattern value.name
                                                                    , -- Decode.succeed
                                                                      Elm.apply
                                                                        [ Elm.fun "Decode.succeed"
                                                                        , Elm.fqVal [] (enumNameToConstructorName value.name)
                                                                        ]
                                                                    )
                                                                )
                                                         )
                                                            ++ [ ( Elm.allPattern
                                                                 , -- Decode.fail ("Invalid InsightType type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
                                                                   Elm.apply
                                                                    [ Elm.fun "Decode.fail"
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

                                -- decoder : Decoder InsightType
                                -- decoder =
                                --     Decode.string
                                --         |> Decode.andThen
                                --             (\string ->
                                --                 case string of
                                --                     "orphan" ->
                                --                         Decode.succeed Orphan
                                --                     _ ->
                                --                         Decode.fail ("Invalid InsightType type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
                                --             )
                            in
                            { moduleName = moduleName_ |> String.join "."
                            , contents =
                                Elm.file module_
                                    [ Elm.importStmt [ "Json", "Decode" ] (Just [ "Decode" ]) (Just ([ Elm.funExpose "Decoder" ] |> Elm.exposeExplicit))

                                    -- import Json.Decode as Decode exposing (Decoder)
                                    ]
                                    [ enumType, listOfValues, enumDecoder ]
                                    Nothing
                                    |> Elm.pretty 120
                            }
                        )
                )
    in
    Cmd.batch (enumFiles |> List.map writeElmFile)

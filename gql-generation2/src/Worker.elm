port module Worker exposing (main)

import Debug
import Dict
import Elm.CodeGen as Elm
import Elm.Pretty as Elm
import GraphQL.Schema
import Json.Decode as Json


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

                                constructors =
                                    enumDefinition.values
                                        |> List.map
                                            (\value ->
                                                ( value.name, [] )
                                            )

                                enumType =
                                    Elm.customTypeDecl docs enumDefinition.name [] constructors

                                listOfValues =
                                    Elm.valDecl Nothing
                                        (Just
                                            (Elm.listAnn (Elm.typed enumDefinition.name []))
                                        )
                                        "list"
                                        (Elm.list
                                            (constructors |> List.map (\( name, _ ) -> Elm.fqVal [] name))
                                        )
                            in
                            { moduleName = moduleName_ |> String.join "."
                            , contents =
                                Elm.file module_ [] [ enumType, listOfValues ] Nothing
                                    |> Elm.pretty 120
                            }
                        )
                )
    in
    Cmd.batch (enumFiles |> List.map writeElmFile)

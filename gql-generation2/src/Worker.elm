port module Worker exposing (main)

import Codegen.Enums
import Codegen.Objects
import Codegen.Queries
import Codegen.Union
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
            Codegen.Enums.generateFiles schema

        queryFiles =
            Codegen.Queries.generateFiles schema

        objectFiles =
            Codegen.Objects.generateFiles schema

        unionFiles =
            Codegen.Union.generateFiles schema

        allFiles =
            enumFiles ++ queryFiles ++ objectFiles ++ unionFiles
    in
    Cmd.batch
        (allFiles
            |> List.map
                (\file ->
                    { moduleName = String.join "." file.name
                    , contents = Elm.pretty 120 file.file
                    }
                )
            |> List.map writeElmFile
        )

module Generate.Operations exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Generate.Args
import GraphQL.Schema
import GraphQL.Schema.Operation
import String.Extra as String



{-



   myProtectedField @PermisionReqed Int



   onDirective
        (\directivename ->
            if directivename == Permissions then
                jfkldasjflkda

           else
            Nothing

        )
    --Elm.Expression


    onGeneration
        (\
              -> OneOf
        )



   updateLicesne
       { input =
           { id = myId
           , actions =
               [ updateLicenseAction
                   [ updateLicenseActionOptions.setNotes
                       (Just
                           ( setLicenseNote
                               [ setLicenseNotesOptions.notes (Just "My notes")
                               ]
                           )
                       )
                   ]
               ]
           }
       }







-}


queryToModule : String -> Generate.Args.Operation -> GraphQL.Schema.Schema -> GraphQL.Schema.Operation.Operation -> Elm.File
queryToModule namespace op schema operation =
    let
        dir =
            directory op

        allOptionalMakers =
            Generate.Args.recursiveOptionalMaker namespace
                schema
                operation.name
                operation.arguments

        queryFunction =
            Generate.Args.createBuilder namespace
                schema
                operation.name
                operation.arguments
                operation.type_
                op

        example =
            Generate.Args.createBuilderExample namespace
                schema
                operation.name
                operation.arguments
                operation.type_
                op

        optionalHelpers =
            if List.any Generate.Args.isOptional operation.arguments then
                let
                    topLevelAlias =
                        Elm.aliasWith "Optional"
                            []
                            (Engine.typeOptional.annotation
                                (Elm.Annotation.named (Elm.moduleName [ namespace ])
                                    (operation.name ++ "_")
                                )
                            )
                            |> Elm.expose
                in
                topLevelAlias
                    :: Generate.Args.optionalMakerTopLevel namespace
                        operation.name
                        (List.filter Generate.Args.isOptional operation.arguments)

            else
                []
    in
    Elm.file
        (Elm.moduleName
            [ namespace
            , dir
            , String.toSentenceCase operation.name
            ]
        )
        ("\n\nExample usage:\n\n"
            ++ Elm.expressionImportsToString example
            ++ "\n\n\n"
            ++ Elm.expressionToString example
        )
        (queryFunction :: optionalHelpers)


directory : Generate.Args.Operation -> String
directory op =
    case op of
        Generate.Args.Query ->
            "Queries"

        Generate.Args.Mutation ->
            "Mutations"


generateFiles : String -> Generate.Args.Operation -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace op schema =
    --List.filterMap
    --    (\oper ->
    --        if String.toLower oper.name == "app" then
    --            Just (queryToModule op oper)
    --
    --        else
    --            Nothing
    --    )
    --    ops
    case op of
        Generate.Args.Mutation ->
            schema.mutations
                |> Dict.toList
                |> List.map
                    (\( _, oper ) ->
                        --if oper.name == "updateLicense" then
                        --    let
                        --        _ =
                        --            Debug.log "OPERATION" oper
                        --    in
                        --    Just
                        queryToModule namespace op schema oper
                     --else
                     --    Nothing
                    )

        --[]
        Generate.Args.Query ->
            schema.queries
                |> Dict.toList
                |> List.map
                    (\( _, oper ) ->
                        --if String.toLower oper.name == "app" then
                        queryToModule namespace op schema oper
                     --else
                     --    Nothing
                    )



--[]

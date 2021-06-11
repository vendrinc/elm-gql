module Generate.Operations exposing (Operation(..), generateFiles)

import Elm
import Elm.Annotation
import Elm.Debug
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Encode as Encode
import Elm.Pattern
import Generate.Args
import Generate.Common as Common
import GraphQL.Schema
import GraphQL.Schema.Argument
import GraphQL.Schema.Operation
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String


queryToModule : String -> Operation -> GraphQL.Schema.Operation.Operation -> Elm.File
queryToModule namespace op queryOperation =
    let
        dir =
            directory op

        ( required, optional ) =
            List.partition
                (\arg ->
                    case arg.type_ of
                        GraphQL.Schema.Type.Nullable innerType ->
                            False

                        _ ->
                            True
                )
                queryOperation.arguments

        hasRequiredArgs =
            case required of
                [] ->
                    False

                _ ->
                    True

        hasOptionalArgs =
            case optional of
                [] ->
                    False

                _ ->
                    True

        anchor =
            Elm.Annotation.named (Elm.moduleName [ namespace, "Object" ])
                (String.toSentenceCase queryOperation.name)

        optionalMaker =
            Generate.Args.optionalMaker queryOperation.name optional
                |> Elm.expose

        expression =
            Engine.objectWith
                (if hasOptionalArgs && hasRequiredArgs then
                    Elm.append
                        (Elm.list
                            (required
                                |> List.map Generate.Args.prepareRequired
                            )
                        )
                        (Engine.encodeOptionals
                            (Elm.valueWith
                                (Elm.moduleName [])
                                "optional"
                                (Elm.Annotation.list
                                    (Engine.typeOptional.annotation anchor)
                                )
                            )
                        )

                 else if hasOptionalArgs then
                    Engine.encodeOptionals
                        (Elm.valueWith
                            (Elm.moduleName [])
                            "optional"
                            (Elm.Annotation.list
                                (Engine.typeOptional.annotation anchor)
                            )
                        )

                 else if hasRequiredArgs then
                    Elm.list
                        (required
                            |> List.map Generate.Args.prepareRequired
                        )

                 else
                    Elm.list []
                )
                (Elm.string queryOperation.name)
                (Elm.valueWith (Elm.moduleName [])
                    "selection"
                    (Engine.typeSelection.annotation anchor (Elm.Annotation.var "data"))
                )
                |> Elm.withAnnotation
                    (Engine.typeSelection.annotation Engine.typeQuery.annotation (Elm.Annotation.var "data"))

        queryFunction =
            Elm.functionWith queryOperation.name
                (List.filterMap identity
                    [ justIf hasRequiredArgs
                        ( Generate.Args.requiredAnnotation required
                        , Elm.Pattern.var "required"
                        )
                    , justIf hasOptionalArgs
                        ( Elm.Annotation.list
                            (Engine.typeOptional.annotation anchor)
                        , Elm.Pattern.var "optional"
                        )
                    , Just
                        ( Engine.typeSelection.annotation anchor (Elm.Annotation.var "data")
                        , Elm.Pattern.var "selection"
                        )
                    ]
                )
                expression
                |> Elm.expose

        moduleName =
            [ namespace, dir, String.toSentenceCase queryOperation.name ]
    in
    Elm.file (Elm.moduleName moduleName)
        ""
        (List.filterMap identity
            [ justIf hasOptionalArgs optionalMaker
            , Just queryFunction
            ]
        )


applyIf : Bool -> (c -> c) -> c -> c
applyIf condition fn val =
    if condition then
        fn val

    else
        val


justIf : Bool -> a -> Maybe a
justIf condition val =
    if condition then
        Just val

    else
        Nothing


type Operation
    = Query
    | Mutation


directory : Operation -> String
directory op =
    case op of
        Query ->
            "Queries"

        Mutation ->
            "Mutations"


typename : Operation -> String
typename op =
    case op of
        Query ->
            "GraphQL.Engine.Query"

        Mutation ->
            "GraphQL.Engine.Mutation"


generateFiles : String -> Operation -> List GraphQL.Schema.Operation.Operation -> List Elm.File
generateFiles namespace op ops =
    --List.filterMap
    --    (\oper ->
    --        if String.toLower oper.name == "app" then
    --            Just (queryToModule op oper)
    --
    --        else
    --            Nothing
    --    )
    --    ops
    List.map (queryToModule namespace op) ops

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



-- target
-- app : { slug : Maybe String, id : Maybe String } -> GraphQL.Engine.Selection TnGql.Object.App value -> GraphQL.Engine.Selection GraphQL.Engine.Query value
-- app =
--     \required selection ->
--     GraphQL.Engine.objectWith
--         [ ("slug", GraphQL.Engine.ArgValue (Maybe.map Json.Encode.string required.slug |> Maybe.withDefault Json.Encode.null) "string")
--         , ("id", GraphQL.Engine.ArgValue (Maybe.map Json.Encode.string required.id |> Maybe.withDefault Json.Encode.null) "string")
--         ]
--         "app"
--         selection


queryToModule : Operation -> GraphQL.Schema.Operation.Operation -> Elm.File
queryToModule op queryOperation =
    let
        dir =
            directory op

        returnType =
            Elm.Annotation.namedWith (Elm.moduleName [ "GraphQL", "Engine" ]) "Selection" [ Elm.Annotation.var (typename op), Elm.Annotation.var "value" ]

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

        optionalInputType =
            Elm.Annotation.list
                (Elm.Annotation.namedWith
                    (Elm.moduleName [ "GraphQL", "Engine" ])
                    "Optional"
                    [ Elm.Annotation.named (Elm.moduleName [ "TnGql", "Object" ])
                        (String.toSentenceCase queryOperation.name)
                    ]
                )

        optionalMaker =
            Generate.Args.optionalMaker queryOperation.name optional
                |> Elm.expose

        requiredInputType =
            required
                |> List.foldl
                    (\argument argumentTypeAcc ->
                        let
                            argumentTypeAnnotation =
                                Common.gqlTypeToElmTypeAnnotation argument.type_ Nothing
                        in
                        ( argument.name, argumentTypeAnnotation ) :: argumentTypeAcc
                    )
                    []
                |> Elm.Annotation.record

        -- ( type_ ) =
        --     let
        --         ( innerOperationType ) =
        --             Common.gqlTypeToElmTypeAnnotation queryOperation.type_ Nothing
        --         operationType =
        --             Elm.Annotation.namedWith (Elm.moduleName ["GraphQL", "Engine"]) "Selection" [ innerOperationType, Elm.Annotation.var "value" ]
        --     in
        --     ( Elm.funAnn
        --         operationType
        --         returnType
        --         |> applyIf hasOptionalArgs (Elm.funAnn optionalInputType)
        --         |> applyIf hasRequiredArgs (Elm.funAnn requiredInputType)
        --     )
        expression =
            Engine.objectWith
                (if hasOptionalArgs && hasRequiredArgs then
                    Elm.append
                        (Elm.list
                            (required
                                |> List.map Generate.Args.prepareRequired
                            )
                        )
                        (Engine.encodeOptionals (Elm.value "optional"))

                 else if hasOptionalArgs then
                    Engine.encodeOptionals (Elm.value "optional")

                 else if hasRequiredArgs then
                    Elm.list
                        (required
                            |> List.map Generate.Args.prepareRequired
                        )

                 else
                    Elm.list []
                )
                (Elm.string queryOperation.name)
                (Elm.value "selection")

        queryFunction =
            Elm.functionWith queryOperation.name
                (List.filterMap identity
                    [ justIf hasRequiredArgs ( Elm.Annotation.string, Elm.Pattern.var "required" )
                    , justIf hasOptionalArgs ( Elm.Annotation.string, Elm.Pattern.var "optional" )
                    , Just ( Elm.Annotation.string, Elm.Pattern.var "selection" )
                    ]
                )
                expression
                |> Elm.expose

        moduleName =
            [ "TnGql", dir, String.toSentenceCase queryOperation.name ]
    in
    Elm.file (Elm.moduleName moduleName)
        (List.filterMap identity
            [ justIf hasOptionalArgs optionalMaker
            , Just queryFunction
            ]
        )



-- fieldSignature :
--     String
--     -> Type
--     ->
--         { annotation : Elm.Annotation.Annotation
--         }
-- fieldSignature objectName fieldType =
--     let
--         ( dataType ) =
--             Common.gqlTypeToElmTypeAnnotation fieldType Nothing
--         typeAnnotation =
--             Common.modules.engine.fns.selection objectName dataType
--     in
--     { annotation = typeAnnotation
--     }
--


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


generateFiles : Operation -> List GraphQL.Schema.Operation.Operation -> List Elm.File
generateFiles op ops =
    List.filterMap
        (\oper ->
            if String.toLower oper.name == "app" then
                Just (queryToModule op oper)

            else
                Nothing
        )
        ops



--List.map (queryToModule op) ops

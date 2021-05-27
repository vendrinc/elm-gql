module Generate.Operations exposing (Operation(..), generateFiles)

-- import Codegen.Common as Common
-- import Codegen.ElmCodegenUtil as Elm

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Encode as Encode
import Elm.Pattern
import Generate.Common as Common
import GraphQL.Schema
import GraphQL.Schema.Argument
import GraphQL.Schema.Operation
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String
import Utils.String



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
            createOptionalCreator queryOperation.name optional
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
                                |> List.map prepareRequiredArgument
                            )
                        )
                        (Elm.value "optional")

                 else if hasOptionalArgs then
                    Elm.value "optional"

                 else if hasRequiredArgs then
                    Elm.list
                        (required
                            |> List.map prepareRequiredArgument
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


createOptionalCreator name options =
    createOptionalCreatorHelper name options []


createOptionalCreatorHelper :
    String
    -> List GraphQL.Schema.Argument.Argument
    -> List ( String, Elm.Expression )
    -- -> List ( String, Elm.Annotation.Annotation )
    -> Elm.Declaration
createOptionalCreatorHelper name options fields =
    case options of
        [] ->
            Elm.declaration (String.decapitalize (name ++ "Options"))
                (Elm.record fields)

        arg :: remain ->
            let
                -- ( annotation, argumentTypeLinkage_ ) =
                --     Common.gqlTypeToElmTypeAnnotation arg.type_ Nothing
                implemented =
                    implementArgEncoder name arg.name arg.type_ UnwrappedValue
            in
            createOptionalCreatorHelper name
                remain
                (( arg.name
                 , Elm.lambda [ Elm.Pattern.var "val" ]
                    (implemented.expression
                     -- , Elm.string fieldName
                     -- , wrapExpression wrapped (Elm.val "val")
                    )
                 )
                    :: fields
                )



-- (( arg.name
--  , implemented.annotation
--  )
--     :: fieldAnnotations
-- )


type Wrapped
    = UnwrappedValue
    | InList Wrapped
    | InMaybe Wrapped


implementArgEncoder :
    String
    -> String
    -> Type
    -> Wrapped
    ->
        { expression : Elm.Expression

        -- , annotation : Elm.TypeAnnotation
        }
implementArgEncoder objectName fieldName fieldType wrapped =
    case fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            implementArgEncoder objectName fieldName newType (InMaybe wrapped)

        GraphQL.Schema.Type.List_ newType ->
            implementArgEncoder objectName fieldName newType (InList wrapped)

        GraphQL.Schema.Type.Scalar scalarName ->
            -- let
            --     signature =
            --         fieldSignature objectName fieldType
            -- in
            { expression =
                Elm.apply (Elm.valueFrom (Elm.moduleName [ "GraphQL", "Engine" ]) "optional")
                    [ Elm.string fieldName
                    , Engine.arg
                        (encodeScalar scalarName
                            wrapped
                            (Elm.value "val")
                        )
                        (Elm.string "TODO")
                    ]

            -- , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Enum enumName ->
            -- let
            --     signature =
            --         fieldSignature objectName fieldType
            -- in
            { expression =
                Engine.field
                    (Elm.string fieldName)
                    (Elm.valueFrom (Elm.moduleName [ "TnGql", "Enum", enumName ]) "decoder")

            -- , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Object nestedObjectName ->
            { expression =
                Elm.lambda [ Elm.Pattern.var "selection_" ]
                    (Engine.object
                        (Elm.string fieldName)
                        (Elm.value "selection_")
                     -- , wrapExpression wrapped (Elm.val "selection_")
                    )

            -- , annotation =
            --     Elm.funAnn
            --         (Common.modules.engine.fns.selection nestedObjectName (Elm.typeVar "data"))
            --         (Common.modules.engine.fns.selection objectName (Elm.typeVar "data")
            --          -- (wrapAnnotation wrapped (Elm.typeVar "data"))
            --         )
            }

        GraphQL.Schema.Type.Interface interfaceName ->
            -- let
            --     signature =
            --         fieldSignature objectName fieldType
            -- in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)

            -- , annotation = signature.annotation
            }

        GraphQL.Schema.Type.InputObject inputName ->
            -- let
            --     signature =
            --         fieldSignature objectName fieldType
            -- in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)

            -- , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Union unionName ->
            { expression =
                Elm.lambda [ Elm.Pattern.var "union_" ]
                    (Engine.object
                        (Elm.string fieldName)
                        (Elm.value "union_")
                     -- , wrapExpression wrapped (Elm.val "union_")
                    )

            -- , annotation =
            --     Elm.funAnn
            --         (Common.modules.engine.fns.selectUnion unionName (Elm.typeVar "data"))
            --         (Common.modules.engine.fns.selection objectName (Elm.typeVar "data")
            --          -- (wrapAnnotation wrapped (Elm.typeVar "data"))
            --         )
            }



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


{-|

    val -> our variable containing the value we want to encode

    We then want to

-}
encodeScalar : String -> Wrapped -> (Elm.Expression -> Elm.Expression)
encodeScalar scalarName wrapped =
    case wrapped of
        InList inner ->
            Encode.list
                (encodeScalar scalarName inner)

        InMaybe inner ->
            Engine.maybeScalarEncode
                (encodeScalar scalarName
                    inner
                )

        UnwrappedValue ->
            let
                lowered =
                    String.toLower scalarName
            in
            case lowered of
                "int" ->
                    Encode.int

                "float" ->
                    Encode.float

                "string" ->
                    Encode.string

                "boolean" ->
                    Encode.bool

                "id" ->
                    Engine.encodeId

                _ ->
                    \val ->
                        Elm.apply
                            (Elm.valueFrom (Elm.moduleName [ "Scalar" ])
                                (Utils.String.formatValue scalarName)
                                |> Elm.get "encode"
                            )
                            [ val ]


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


prepareRequiredArgument :
    { a | name : String, type_ : Type }
    -> Elm.Expression
prepareRequiredArgument argument =
    Elm.tuple
        (Elm.string argument.name)
        (let
            convert type__ =
                case type__ of
                    GraphQL.Schema.Type.Scalar scalarName ->
                        Engine.arg
                            (encodeScalar argument.name
                                UnwrappedValue
                                (Elm.get argument.name (Elm.value "required"))
                            )
                            (Elm.string scalarName)

                    GraphQL.Schema.Type.Enum enumName ->
                        --Elm.apply (Elm.valueFrom (Elm.moduleName [ "GraphQL", "Engine", "args" ]) "scalar")
                        --    [ GenEngine.enum
                        --    , Elm.valueFrom (Elm.moduleName [ "TnGql", "Enum", enumName ]) "decoder"
                        --    , Elm.get argument.name (Elm.value "required")
                        --    ]
                        Elm.string "unimplemented"

                    GraphQL.Schema.Type.InputObject inputObject ->
                        Elm.apply (Elm.valueFrom (Elm.moduleName [ "GraphQL", "Engine", "args" ]) "scalar")
                            [ Elm.valueFrom (Elm.moduleName [ "TnGql", "InputObject", inputObject ]) "decoder"
                            , Elm.get argument.name (Elm.value "required")
                            ]

                    GraphQL.Schema.Type.Nullable innerType ->
                        -- bugbug pretty sure the inner decoder
                        -- needs to be instructed to handle null
                        -- but I'm just glossing over that for now
                        convert innerType

                    GraphQL.Schema.Type.Object name ->
                        Elm.string "unimplemented"

                    GraphQL.Schema.Type.Union name ->
                        Elm.string "unimplemented"

                    GraphQL.Schema.Type.Interface name ->
                        Elm.string "unimplemented"

                    GraphQL.Schema.Type.List_ innerType ->
                        Elm.string "unimplemented"
         in
         convert argument.type_
        )


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
    --List.filterMap
    --    (\oper ->
    --        if String.toLower oper.name == "App" then
    --            Just (queryToModule op oper)
    --
    --        else
    --            Nothing
    --    )
    List.map (queryToModule op) ops

module Codegen.Operations exposing (Operation(..), generateFiles)

import Codegen.Common as Common
import Codegen.ElmCodegenUtil as Elm
import Dict
import Elm.CodeGen as Elm
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


queryToModule : Operation -> GraphQL.Schema.Operation.Operation -> Common.File
queryToModule op queryOperation =
    let
        dir =
            directory op

        linkage =
            Elm.emptyLinkage
                |> Elm.addImport (Elm.importStmt [ "GraphQL", "Engine" ] Nothing Nothing)

        returnType =
            Elm.typed "GraphQL.Engine.Selection" [ Elm.typed (typename op) [], Elm.typed "value" [] ]

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
            Elm.listAnn
                (Elm.fqTyped
                    [ "GraphQL", "Engine" ]
                    "Optional"
                    [ Elm.fqTyped [ "TnGql", "Object" ]
                        (String.toSentenceCase queryOperation.name)
                        []
                    ]
                )

        optionalArgumentsLinkage =
            optional
                |> List.foldl
                    (\argument linkageAcc ->
                        -- let
                        --     ( argumentTypeAnnotation, argumentTypeLinkage ) =
                        --         Common.gqlTypeToElmTypeAnnotation argument.type_ Nothing
                        -- in
                        linkageAcc
                    )
                    []
                |> Elm.combineLinkage

        optionalMaker =
            createOptionalCreator queryOperation.name optional

        ( requiredInputType, requiredArgumentsLinkage ) =
            required
                |> List.foldl
                    (\argument ( argumentTypeAcc, linkageAcc ) ->
                        let
                            ( argumentTypeAnnotation, argumentTypeLinkage ) =
                                Common.gqlTypeToElmTypeAnnotation argument.type_ Nothing
                        in
                        ( ( argument.name, argumentTypeAnnotation ) :: argumentTypeAcc, argumentTypeLinkage :: linkageAcc )
                    )
                    ( [], [] )
                |> Tuple.mapFirst Elm.recordAnn
                |> Tuple.mapSecond Elm.combineLinkage

        ( type_, functionAnnotationLinkage ) =
            let
                ( innerOperationType, linkage____ ) =
                    Common.gqlTypeToElmTypeAnnotation queryOperation.type_ Nothing

                operationType =
                    Elm.typed "GraphQL.Engine.Selection" [ innerOperationType, Elm.typeVar "value" ]
            in
            ( Elm.funAnn
                operationType
                returnType
                |> applyIf hasOptionalArgs (Elm.funAnn optionalInputType)
                |> applyIf hasRequiredArgs (Elm.funAnn requiredInputType)
            , linkage____
            )

        expression =
            Elm.apply
                [ Elm.fqVal [ "GraphQL", "Engine" ] "objectWith"
                , Elm.parens
                    (Elm.applyBinOp
                        (Elm.list
                            (required
                                |> List.map prepareRequiredArgument
                            )
                        )
                        Elm.append
                        (Elm.list [])
                    )
                , Elm.string queryOperation.name
                , Elm.val "selection"
                ]

        queryFunction =
            Elm.funDecl Nothing
                (Just type_)
                queryOperation.name
                (List.filterMap identity
                    [ justIf hasRequiredArgs (Elm.varPattern "required")
                    , justIf hasOptionalArgs (Elm.varPattern "optional")
                    , Just (Elm.varPattern "selection")
                    ]
                )
                expression

        moduleName =
            [ "TnGql", dir, String.toSentenceCase queryOperation.name ]

        ( imports_, exposing_ ) =
            linkage
                |> Elm.addImport Common.modules.decode.import_
                |> Elm.addImport Common.modules.encode.import_
                |> Elm.mergeLinkage requiredArgumentsLinkage
                |> Elm.mergeLinkage optionalArgumentsLinkage
                |> Elm.mergeLinkage functionAnnotationLinkage
    in
    { name = moduleName
    , file =
        Elm.file (Elm.normalModule moduleName [])
            imports_
            (List.filterMap identity
                [ justIf hasOptionalArgs optionalMaker
                , Just queryFunction
                ]
            )
            Nothing
    }


createOptionalCreator name options =
    createOptionalCreatorHelper name options [] []


createOptionalCreatorHelper :
    String
    -> List GraphQL.Schema.Argument.Argument
    -> List ( String, Elm.Expression )
    -> List ( String, Elm.TypeAnnotation )
    -> Elm.Declaration
createOptionalCreatorHelper name options fields fieldAnnotations =
    case options of
        [] ->
            Elm.valDecl Nothing
                (Just (Elm.recordAnn fieldAnnotations))
                (String.decapitalize (name ++ "Options"))
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
                 , Elm.lambda [ Elm.varPattern "val" ]
                    (implemented.expression
                     -- , Elm.string fieldName
                     -- , wrapExpression wrapped (Elm.val "val")
                    )
                 )
                    :: fields
                )
                (( arg.name
                 , implemented.annotation
                 )
                    :: fieldAnnotations
                )


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
        , annotation : Elm.TypeAnnotation
        , linkage : Elm.Linkage
        }
implementArgEncoder objectName fieldName fieldType wrapped =
    case fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            implementArgEncoder objectName fieldName newType (InMaybe wrapped)

        GraphQL.Schema.Type.List_ newType ->
            implementArgEncoder objectName fieldName newType (InList wrapped)

        GraphQL.Schema.Type.Scalar scalarName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression =
                Elm.apply
                    [ Common.modules.engine.fns.optional
                    , Elm.string fieldName
                    , Elm.apply
                        [ Common.modules.engine.fns.arg
                        , Elm.parens
                            (Elm.apply
                                [ encodeScalar scalarName wrapped
                                , Elm.val "val"
                                ]
                            )
                        , Elm.string "TODO"
                        ]
                    ]
            , annotation = signature.annotation
            , linkage =
                signature.linkage
                    |> Elm.addImport Common.modules.scalar.import_
            }

        GraphQL.Schema.Type.Enum enumName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression =
                Elm.apply
                    [ Common.modules.engine.fns.field
                    , Elm.string fieldName
                    , Elm.fqFun [ "TnGql", "Enum", enumName ] "decoder"
                    ]
            , annotation = signature.annotation
            , linkage =
                signature.linkage
                    |> Elm.addImport (Common.modules.generated.enum enumName)
            }

        GraphQL.Schema.Type.Object nestedObjectName ->
            { expression =
                Elm.lambda [ Elm.varPattern "selection_" ]
                    (Elm.apply
                        [ Common.modules.engine.fns.object
                        , Elm.string fieldName

                        -- , wrapExpression wrapped (Elm.val "selection_")
                        ]
                    )
            , annotation =
                Elm.funAnn
                    (Common.modules.engine.fns.selection nestedObjectName (Elm.typeVar "data"))
                    (Common.modules.engine.fns.selection objectName (Elm.typeVar "data")
                     -- (wrapAnnotation wrapped (Elm.typeVar "data"))
                    )
            , linkage =
                Elm.emptyLinkage
            }

        GraphQL.Schema.Type.Interface interfaceName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
            , annotation = signature.annotation
            , linkage = signature.linkage
            }

        GraphQL.Schema.Type.InputObject inputName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
            , annotation = signature.annotation
            , linkage = signature.linkage
            }

        GraphQL.Schema.Type.Union unionName ->
            { expression =
                Elm.lambda [ Elm.varPattern "union_" ]
                    (Elm.apply
                        [ Common.modules.engine.fns.object
                        , Elm.string fieldName

                        -- , wrapExpression wrapped (Elm.val "union_")
                        ]
                    )
            , annotation =
                Elm.funAnn
                    (Common.modules.engine.fns.selectUnion unionName (Elm.typeVar "data"))
                    (Common.modules.engine.fns.selection objectName (Elm.typeVar "data")
                     -- (wrapAnnotation wrapped (Elm.typeVar "data"))
                    )
            , linkage =
                Elm.emptyLinkage
            }


fieldSignature :
    String
    -> Type
    ->
        { annotation : Elm.TypeAnnotation
        , linkage : Elm.Linkage
        }
fieldSignature objectName fieldType =
    let
        ( dataType, linkage ) =
            Common.gqlTypeToElmTypeAnnotation fieldType Nothing

        typeAnnotation =
            Common.modules.engine.fns.selection objectName dataType
    in
    { annotation = typeAnnotation
    , linkage = linkage
    }


encodeScalar : String -> Wrapped -> Elm.Expression
encodeScalar scalarName nullable =
    let
        lowered =
            String.toLower scalarName
    in
    if List.member lowered [ "string", "int", "float" ] then
        Elm.fqVal [ "Encode" ] (Utils.String.formatValue scalarName)

    else if lowered == "boolean" then
        Elm.fqVal [ "Encode" ] "bool"

    else if lowered == "id" then
        Elm.fqVal [ "GraphQL", "Engine" ] "encodeId"

    else
        Elm.access (Elm.fqVal [ "Scalar" ] (Utils.String.formatValue scalarName)) "encode"


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
        [ Elm.string argument.name
        , let
            convert type__ =
                case type__ of
                    GraphQL.Schema.Type.Scalar scalarName ->
                        Elm.apply
                            [ Elm.fqVal [ "GraphQL", "Engine" ] "ArgValue"
                            , Elm.parens
                                (Elm.apply
                                    [ Elm.fqVal [ "GraphQL", "Engine" ] "maybeScalarEncode"
                                    , Elm.fqVal [ "Json", "Encode" ] (String.decapitalize scalarName)
                                    , Elm.access (Elm.val "required") argument.name
                                    ]
                                )
                            , Elm.string scalarName
                            ]

                    GraphQL.Schema.Type.Enum enumName ->
                        Elm.apply
                            [ Common.modules.engine.args.fns.scalar
                            , Common.modules.engine.args.fns.enum
                            , Elm.fqFun [ "TnGql", "Enum", enumName ] "decoder"
                            , Elm.access (Elm.val "required") argument.name
                            ]

                    GraphQL.Schema.Type.InputObject inputObject ->
                        Elm.apply
                            [ Common.modules.engine.args.fns.scalar
                            , Elm.fqFun [ "TnGql", "InputObject", inputObject ] "decoder"
                            , Elm.access (Elm.val "required") argument.name
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
        ]


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


generateFiles : Operation -> List GraphQL.Schema.Operation.Operation -> List Common.File
generateFiles op ops =
    List.map (queryToModule op) ops

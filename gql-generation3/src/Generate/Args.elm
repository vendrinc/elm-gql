module Generate.Args exposing (Wrapped(..), encodeScalar, optionalMaker, prepareRequired)

import Elm
import Elm.Annotation
import Elm.Debug
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Encode as Encode
import Elm.Pattern
import GraphQL.Schema.Type exposing (Type(..))
import String
import Utils.String


type Wrapped
    = UnwrappedValue
    | InList Wrapped
    | InMaybe Wrapped


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


scalarType : Wrapped -> String -> Elm.Annotation.Annotation
scalarType wrapped scalarName =
    case wrapped of
        InList inner ->
            Elm.Annotation.list
                (scalarType inner scalarName)

        InMaybe inner ->
            Debug.log "scalar maybe" <|
                Elm.Annotation.maybe
                    (scalarType inner scalarName)

        UnwrappedValue ->
            Debug.log "scalar inner" <|
                let
                    lowered =
                        String.toLower scalarName
                in
                case lowered of
                    "int" ->
                        Elm.Annotation.int

                    "float" ->
                        Elm.Annotation.float

                    "string" ->
                        Elm.Annotation.string

                    "boolean" ->
                        Elm.Annotation.bool

                    "id" ->
                        --Engine.typeId.annotation
                        Elm.Annotation.named
                            Engine.moduleName_
                            (Utils.String.formatTypename "id")

                    _ ->
                        Elm.Annotation.named
                            (Elm.moduleName [ "Scalar" ])
                            (Utils.String.formatTypename scalarName)


prepareRequired :
    { a | name : String, type_ : Type }
    -> Elm.Expression
prepareRequired argument =
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


optionalMaker name options =
    createOptionalCreatorHelper name options []


createOptionalCreatorHelper :
    String
    ->
        List
            { field
                | name : String
                , description : Maybe String
                , type_ : Type
            }
    -> List ( String, Elm.Expression )
    -> Elm.Declaration
createOptionalCreatorHelper name options fields =
    case options of
        [] ->
            Elm.declaration (Utils.String.formatValue (name ++ "Options"))
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
                 , Elm.lambdaWith
                    [ ( Elm.Pattern.var "val"
                      , implemented.annotation
                      )
                    ]
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


implementArgEncoder :
    String
    -> String
    -> Type
    -> Wrapped
    ->
        { expression : Elm.Expression
        , annotation : Elm.Annotation.Annotation
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
                Engine.optional
                    (Elm.string fieldName)
                    (Engine.arg
                        (encodeScalar scalarName
                            wrapped
                            (Elm.valueWith (Elm.moduleName [])
                                "val"
                                (scalarType wrapped scalarName)
                                |> Elm.Debug.annotation Debug.log "Inner"
                            )
                            |> Elm.Debug.annotation Debug.log "Encoded"
                        )
                        (Elm.string "TODO")
                    )
            , annotation = scalarType wrapped scalarName
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
            , annotation = Elm.Annotation.unit
            }

        GraphQL.Schema.Type.Object nestedObjectName ->
            { expression =
                Elm.lambda [ Elm.Pattern.var "selection_" ]
                    (Engine.object
                        (Elm.string fieldName)
                        (Elm.value "selection_")
                     -- , wrapExpression wrapped (Elm.val "selection_")
                    )
            , annotation = Elm.Annotation.unit

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
            , annotation = Elm.Annotation.string
            }

        GraphQL.Schema.Type.InputObject inputName ->
            -- let
            --     signature =
            --         fieldSignature objectName fieldType
            -- in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
            , annotation = Elm.Annotation.string
            }

        GraphQL.Schema.Type.Union unionName ->
            { expression =
                Elm.lambda [ Elm.Pattern.var "union_" ]
                    (Engine.object
                        (Elm.string fieldName)
                        (Elm.value "union_")
                     -- , wrapExpression wrapped (Elm.val "union_")
                    )
            , annotation = Elm.Annotation.string

            --     Elm.funAnn
            --         (Common.modules.engine.fns.selectUnion unionName (Elm.typeVar "data"))
            --         (Common.modules.engine.fns.selection objectName (Elm.typeVar "data")
            --          -- (wrapAnnotation wrapped (Elm.typeVar "data"))
            --         )
            }

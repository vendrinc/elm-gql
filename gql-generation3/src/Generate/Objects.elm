module Generate.Objects exposing (generateFiles)

-- import Codegen.Common as Common
import Dict
import Elm
import Elm.Annotation
import Elm.Pattern
import GraphQL.Schema
import GraphQL.Schema.Object
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String
import Utils.String
import Elm.Gen.GraphQL.Engine as GenEngine



-- target:
-- module TnGql.Object.App exposing (..)
-- import Json.Decode as Decode exposing (Decoder)
-- import TnGql.Object
-- import GraphQL.Engine as Engine
-- app : { name : Engine.Selection Tng.Object.App String, slug : Engine.Selection Tng.Object.App String  }
-- app =
--     { name = Engine.field "name" Decode.string
--     , slug = Engine.field "slug" Decode.string
--     }


objectToModule : GraphQL.Schema.Object.Object -> Elm.File
objectToModule object =
    let
        ( fieldTypesAndImpls ) =
            object.fields
                |> List.filter
                    (\field ->
                        List.member field.name [ "name", "slug", "id", "viewUrl", "parent" ]
                    )
                |> List.foldl
                    (\field ( accDecls ) ->
                        let
                            implemented =
                                implementField object.name
                                    field.name
                                    field.type_
                                    UnwrappedValue
                        in
                        ( ( field.name, implemented.expression ) :: accDecls
                        )
                    )
                    ( [] )

        -- GQL.Query (Maybe value)
        -- objectTypeAnnotation =
        --     fieldTypesAndImpls
        --         |> List.map (\( name, _ ) -> ( name, typeAnnotation ))
        --         |> Elm.Annotation.record

        objectImplementation =
            fieldTypesAndImpls
                |> Elm.record

        objectDecl =
            Elm.declaration (String.decapitalize object.name) objectImplementation
    in
    Elm.file (Elm.moduleName [ "TnGql", "Object", object.name ])
        [ objectDecl |> Elm.expose
        ]
    
type Wrapped
    = UnwrappedValue
    | InList Wrapped
    | InMaybe Wrapped


implementField :
    String
    -> String
    -> Type
    -> Wrapped
    ->
        { expression : Elm.Expression
        -- , annotation : Elm.Annotation.Annotation
        }
implementField objectName fieldName fieldType wrapped =
    case fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            implementField objectName fieldName newType (InMaybe wrapped)

        GraphQL.Schema.Type.List_ newType ->
            implementField objectName fieldName newType (InList wrapped)

        GraphQL.Schema.Type.Scalar scalarName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression =
                Elm.apply GenEngine.field
                    [ Elm.string fieldName
                    , decodeScalar scalarName wrapped
                    ]
            -- , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Enum enumName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression =
                Elm.apply GenEngine.field
                    [ Elm.string fieldName
                    , Elm.valueFrom (Elm.moduleName [ "TnGql", "Enum", enumName]) "decoder"
                    ]
            -- , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Object nestedObjectName ->
            { expression =
                Elm.lambda [ Elm.Pattern.var "selection_" ]
                    (Elm.apply GenEngine.object
                        [ Elm.string fieldName
                        , wrapExpression wrapped (Elm.value "selection_")
                        ]
                    )
            -- , annotation =
            --     Elm.funAnn
            --         (Common.modules.engine.fns.selection nestedObjectName (Elm.typeVar "data"))
            --         (Common.modules.engine.fns.selection objectName
            --             (wrapAnnotation wrapped (Elm.typeVar "data"))
            --         )
            }

        GraphQL.Schema.Type.Interface interfaceName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
            -- , annotation = signature.annotation
            }

        GraphQL.Schema.Type.InputObject inputName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
            -- , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Union unionName ->
            { expression =
                Elm.lambda [ Elm.Pattern.var "union_" ]
                    (Elm.apply  GenEngine.object
                        [ Elm.string fieldName
                        , wrapExpression wrapped (Elm.value "union_")
                        ]
                    )
            -- , annotation =
            --     Elm.funAnn
            --         (Common.modules.engine.fns.selectUnion unionName (Elm.typeVar "data"))
            --         (Common.modules.engine.fns.selection objectName
            --             (wrapAnnotation wrapped (Elm.typeVar "data"))
            --         )
            }


wrapAnnotation : Wrapped -> Elm.Annotation.Annotation -> Elm.Annotation.Annotation
wrapAnnotation wrap signature =
    case wrap of
        UnwrappedValue ->
            signature

        InList inner ->
            Elm.Annotation.list (wrapAnnotation inner signature)

        InMaybe inner ->
            Elm.Annotation.maybe (wrapAnnotation inner signature)


wrapExpression : Wrapped -> Elm.Expression -> Elm.Expression
wrapExpression wrap exp =
    case wrap of
        UnwrappedValue ->
            exp

        InList inner ->
                (Elm.apply (Elm.valueFrom (Elm.moduleName ["Json", "Decode"]) "list")
                    [ wrapExpression inner exp
                    ]
                )

        InMaybe inner ->
                (Elm.apply GenEngine.nullable
                    [ wrapExpression inner exp
                    ]
                )


fieldSignature :
    String
    -> Type
    ->
        { annotation : Elm.Annotation.Annotation
        }
fieldSignature objectName fieldType =
    let
        ( dataType ) =
            gqlTypeToElmTypeAnnotation fieldType Nothing

        typeAnnotation =
            Elm.Annotation.namedWith (Elm.moduleName [ "TnGql", "Object" ]) objectName [ dataType ]
    in
    { annotation = typeAnnotation
    }


gqlTypeToElmTypeAnnotation : GraphQL.Schema.Type.Type -> Maybe (List Elm.Annotation.Annotation) -> Elm.Annotation.Annotation
gqlTypeToElmTypeAnnotation gqlType maybeAppliedToTypes =
    let
        appliedToTypes =
            Maybe.withDefault [] maybeAppliedToTypes
    in
    case gqlType of
        Scalar scalarName ->
            case String.toLower scalarName of
                "string" ->
                    Elm.Annotation.string

                "int" ->
                    Elm.Annotation.int

                "float" ->
                    Elm.Annotation.float

                "boolean" ->
                    Elm.Annotation.bool

                "id" ->
                    ( Elm.Annotation.namedWith (Elm.moduleName[ "GraphQL", "Engine" ]) "Id" appliedToTypes)

                _ ->
                    ( Elm.Annotation.namedWith (Elm.moduleName[ "Scalar" ])
                        (Utils.String.formatTypename scalarName)
                        appliedToTypes
                    )

        Enum enumName ->
            ( Elm.Annotation.namedWith (Elm.moduleName[ "TnGql", "Enum" ]) enumName appliedToTypes
            )

        List_ listElementType ->
            let
                ( innerType ) =
                    gqlTypeToElmTypeAnnotation listElementType maybeAppliedToTypes
            in
            ( Elm.Annotation.list innerType )

        Nullable nonNullType ->
            let
                ( innerType ) =
                    gqlTypeToElmTypeAnnotation nonNullType maybeAppliedToTypes
            in
            ( Elm.Annotation.maybe innerType )

        InputObject inputObjectName ->
            ( Elm.Annotation.namedWith (Elm.moduleName[ "TnGql", "InputObject" ]) inputObjectName appliedToTypes
            )

        Object objectName ->
            ( Elm.Annotation.namedWith (Elm.moduleName[ "TnGql", "Object" ]) objectName appliedToTypes
          
            )

        Union unionName ->
            ( Elm.Annotation.namedWith (Elm.moduleName[ "TnGql", "Union" ]) unionName appliedToTypes
            )

        Interface interfaceName ->
            ( Elm.Annotation.namedWith (Elm.moduleName[ "TnGql", "Interface" ]) interfaceName appliedToTypes
            )


decodeScalar : String -> Wrapped -> Elm.Expression
decodeScalar scalarName nullable =
    let
        lowered =
            String.toLower scalarName
    in
    if List.member lowered [ "string", "int", "float" ] then
        Elm.valueFrom (Elm.moduleName [ "Json", "Decode" ]) (Utils.String.formatValue scalarName)

    else if lowered == "boolean" then
        Elm.valueFrom (Elm.moduleName [ "Json", "Decode" ]) "bool"

    else if lowered == "id" then
        GenEngine.decodeId

    else
        Elm.valueFrom (Elm.moduleName [ "Scalar" ]) (Utils.String.formatValue scalarName)
            |> Elm.get "decoder"


generateFiles : GraphQL.Schema.Schema -> List Elm.File
generateFiles graphQLSchema =
    let
        objects =
            graphQLSchema.objects
                |> Dict.toList
                |> List.map Tuple.second
                |> List.filter (\object -> object.name == "App")

        objectFiles =
            objects
                |> List.map objectToModule

        phantomTypeDeclarations =
            objects
                |> List.map
                    (\object ->
                        Elm.customType object.name [ ( object.name, [] ) ]
                    )

        masterObjectFile =
            Elm.file (Elm.moduleName [ "TnGql", "Object" ])
                (phantomTypeDeclarations
                    |> List.map Elm.expose)
    in
    masterObjectFile :: objectFiles

module Generate.InputObjects exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Json
import Elm.Gen.Json.Encode as Encode
import Elm.Pattern
import Generate.Args exposing (optionalMaker)
import Generate.Common as Common
import GraphQL.Schema
import GraphQL.Schema.InputObject
import GraphQL.Schema.Object
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String
import Utils.String



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


inputObjectToDeclarations : GraphQL.Schema.InputObject.InputObject -> List Elm.Declaration
inputObjectToDeclarations input =
    let
        ( required, optional ) =
            List.partition
                (\arg ->
                    case arg.type_ of
                        GraphQL.Schema.Type.Nullable innerType ->
                            False

                        _ ->
                            True
                )
                input.fields

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

        fieldTypesAndImpls =
            input.fields
                |> List.foldl
                    (\field accDecls ->
                        let
                            implemented =
                                implementField input.name
                                    field.name
                                    field.type_
                                    UnwrappedValue
                        in
                        ( field.name, implemented.annotation, implemented.expression ) :: accDecls
                    )
                    []

        -- GQL.Query (Maybe value)
        inputTypeAnnotation =
            fieldTypesAndImpls
                |> List.map (\( name, typeAnnotation, _ ) -> ( name, typeAnnotation ))
                |> Elm.Annotation.record

        optionalTypeProof =
            if hasOptionalArgs then
                Just
                    (Elm.customType input.name
                        [ ( input.name, [] )
                        ]
                    )

            else
                Nothing

        optionalConstructor =
            if hasOptionalArgs then
                Just
                    (Generate.Args.optionalMaker input.name
                        (List.filter
                            (\field ->
                                case field.type_ of
                                    GraphQL.Schema.Type.Nullable innerType ->
                                        True

                                    _ ->
                                        False
                            )
                            input.fields
                        )
                    )

            else
                Nothing

        inputDecl =
            Elm.functionWith (Utils.String.formatValue input.name)
                (List.filterMap identity
                    [ justIf hasRequiredArgs ( Elm.Annotation.string, Elm.Pattern.var "required" )
                    , justIf hasOptionalArgs ( Elm.Annotation.string, Elm.Pattern.var "optional" )
                    ]
                )
                (Engine.arg
                    (Encode.object <|
                        if hasOptionalArgs && hasRequiredArgs then
                            Elm.append
                                (Elm.list
                                    (required
                                        |> List.map Generate.Args.prepareRequired
                                    )
                                )
                                (Elm.apply
                                    (Elm.valueFrom Engine.moduleName_ "encodeOptionals")
                                    [ Elm.value "optional" ]
                                )

                        else if hasOptionalArgs then
                            Elm.apply (Elm.valueFrom Engine.moduleName_ "encodeOptionals")
                                [ Elm.value "optional" ]

                        else if hasRequiredArgs then
                            Elm.list
                                (required
                                    |> List.map Generate.Args.prepareRequired
                                )

                        else
                            Elm.list []
                    )
                    (Elm.string input.name)
                )
    in
    List.filterMap identity
        [ optionalTypeProof
        , optionalConstructor
        , inputDecl
            |> Elm.expose
            |> Just
        ]


justIf : Bool -> a -> Maybe a
justIf condition val =
    if condition then
        Just val

    else
        Nothing


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
        , annotation : Elm.Annotation.Annotation
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
                Engine.field
                    (Elm.string fieldName)
                    (decodeScalar scalarName wrapped)
            , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Enum enumName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression =
                Engine.field
                    (Elm.string fieldName)
                    (Elm.valueFrom (Elm.moduleName [ "TnGql", "Enum", enumName ]) "decoder")
            , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Object nestedObjectName ->
            { expression =
                Elm.lambda "selection_"
                    (Elm.Annotation.namedWith (Elm.moduleName [ "GraphQL", "Engine" ])
                        "Selection"
                        [ Elm.Annotation.named (Elm.moduleName [ "TnGql", "Object" ]) nestedObjectName
                        , Elm.Annotation.var "data"
                        ]
                    )
                    (\sel ->
                        Engine.object
                            (Elm.string fieldName)
                            (wrapExpression wrapped sel)
                    )
            , annotation =
                Elm.Annotation.function
                    [ Elm.Annotation.namedWith (Elm.moduleName [ "GraphQL", "Engine" ])
                        "Selection"
                        [ Elm.Annotation.named (Elm.moduleName [ "TnGql", "Object" ]) nestedObjectName
                        , Elm.Annotation.var "data"
                        ]
                    ]
                    (Elm.Annotation.namedWith (Elm.moduleName [ "GraphQL", "Engine" ])
                        "Selection"
                        [ Elm.Annotation.named (Elm.moduleName [ "TnGql", "Object" ]) objectName
                        , wrapAnnotation wrapped (Elm.Annotation.var "data")
                        ]
                    )
            }

        GraphQL.Schema.Type.Interface interfaceName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
            , annotation = signature.annotation
            }

        GraphQL.Schema.Type.InputObject inputName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
            , annotation = signature.annotation
            }

        GraphQL.Schema.Type.Union unionName ->
            { expression =
                Elm.lambda "union_"
                    (Elm.Annotation.namedWith (Elm.moduleName [ "GraphQL", "Engine" ]) unionName [ Elm.Annotation.var "data" ])
                    (\un ->
                        Engine.object
                            (Elm.string fieldName)
                            (wrapExpression wrapped un)
                    )
            , annotation =
                Elm.Annotation.function
                    [ Elm.Annotation.namedWith (Elm.moduleName [ "GraphQL", "Engine" ]) unionName [ Elm.Annotation.var "data" ] ]
                    (Elm.Annotation.namedWith (Elm.moduleName [ "GraphQL", "Engine" ]) objectName [ wrapAnnotation wrapped (Elm.Annotation.var "data") ])
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
            Elm.apply (Elm.valueFrom (Elm.moduleName [ "Json", "Decode" ]) "list")
                [ wrapExpression inner exp
                ]

        InMaybe inner ->
            Engine.nullable
                (wrapExpression inner exp)


fieldSignature :
    String
    -> Type
    ->
        { annotation : Elm.Annotation.Annotation
        }
fieldSignature objectName fieldType =
    let
        dataType =
            Common.gqlTypeToElmTypeAnnotation fieldType Nothing

        typeAnnotation =
            Elm.Annotation.namedWith (Elm.moduleName [ "TnGql", "Object" ]) objectName [ dataType ]
    in
    { annotation = typeAnnotation
    }


decodeScalar : String -> Wrapped -> Elm.Expression
decodeScalar scalarName nullable =
    let
        lowered =
            String.toLower scalarName
    in
    case lowered of
        "string" ->
            Json.string

        "int" ->
            Json.int

        "float" ->
            Json.float

        "id" ->
            Engine.decodeId

        "boolean" ->
            Json.bool

        _ ->
            Elm.valueFrom (Elm.moduleName [ "Scalar" ]) (Utils.String.formatValue scalarName)
                |> Elm.get "decoder"


generateFiles : GraphQL.Schema.Schema -> List Elm.File
generateFiles graphQLSchema =
    let
        objects =
            graphQLSchema.inputObjects
                |> Dict.toList
                |> List.map Tuple.second

        --|> List.filter (\object -> object.name == "App")
        declarations =
            objects
                |> List.concatMap inputObjectToDeclarations

        phantomTypeDeclarations =
            objects
                |> List.map
                    (\object ->
                        Elm.customType object.name [ ( object.name, [] ) ]
                    )

        --masterObjectFile =
        --    Elm.file (Elm.moduleName [ "TnGql", "Object" ])
        --        (phantomTypeDeclarations
        --            |> List.map Elm.expose
        --        )
    in
    --masterObjectFile ::
    --objectFiles
    [ Elm.file (Elm.moduleName [ "TnGql", "Input" ])
        ""
        declarations
    ]

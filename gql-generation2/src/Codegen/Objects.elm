module Codegen.Objects exposing (generateFiles)

import Codegen.Common as Common
import Dict
import Elm.CodeGen as Elm
import GraphQL.Schema
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


objectToModule : GraphQL.Schema.Object.Object -> Common.File
objectToModule object =
    let
        ( fieldTypesAndImpls, linkage ) =
            object.fields
                |> List.filter
                    (\field ->
                        List.member field.name [ "name", "slug", "id", "viewUrl", "parent" ]
                    )
                |> List.foldl
                    (\field ( accDecls, linkageAcc ) ->
                        let
                            implemented =
                                implementField object.name field.name field.type_ False
                        in
                        ( ( field.name, implemented.annotation, implemented.expression ) :: accDecls
                        , implemented.linkage :: linkageAcc
                        )
                    )
                    ( [], [] )

        -- GQL.Query (Maybe value)
        objectTypeAnnotation =
            fieldTypesAndImpls
                |> List.map (\( name, typeAnnotation, _ ) -> ( name, typeAnnotation ))
                |> Elm.recordAnn

        objectImplementation =
            fieldTypesAndImpls
                |> List.map (\( name, _, implementation ) -> ( name, implementation ))
                |> Elm.record

        objectDecl =
            Elm.valDecl Nothing (Just objectTypeAnnotation) (String.decapitalize object.name) objectImplementation

        moduleName =
            [ "TnGql", "Object", object.name ]

        module_ =
            Elm.normalModule moduleName []

        ( imports_, exposing_ ) =
            Elm.combineLinkage linkage
                |> Elm.addImport Common.modules.decode.import_
                |> Elm.addImport Common.modules.scalar.import_
                |> Elm.addImport (Elm.importStmt [ "TnGql", "Object" ] Nothing Nothing)
                |> Elm.addImport (Elm.importStmt [ "GraphQL", "Engine" ] Nothing Nothing)
    in
    { name = moduleName
    , file =
        Elm.file module_
            imports_
            [ objectDecl ]
            Nothing
    }


implementField :
    String
    -> String
    -> Type
    -> Bool
    ->
        { expression : Elm.Expression
        , annotation : Elm.TypeAnnotation
        , linkage : Elm.Linkage
        }
implementField objectName fieldName fieldType nullable =
    case fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            implementField objectName fieldName newType True

        GraphQL.Schema.Type.Scalar scalarName ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression =
                Elm.apply
                    [ Common.modules.engine.fns.field
                    , Elm.string fieldName
                    , decodeScalar scalarName nullable
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
                    , Elm.fun "identity"
                    , Elm.string fieldName
                    , Elm.fqFun [ "TnGql", "Enum", enumName ] "decoder"
                    , Elm.list []
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
                        , if nullable then
                            Elm.parens
                                (Elm.apply
                                    [ Elm.fqFun Common.modules.engine.fqName "nullable"
                                    , Elm.val "selection_"
                                    ]
                                )

                          else
                            Elm.val "selection_"
                        ]
                    )
            , annotation =
                Elm.funAnn
                    (Common.modules.engine.fns.selection objectName (Elm.typeVar "data"))
                    (Common.modules.engine.fns.selection nestedObjectName
                        (if nullable then
                            Elm.maybeAnn (Elm.typeVar "data")

                         else
                            Elm.typeVar "data"
                        )
                    )
            , linkage =
                Elm.emptyLinkage
            }

        _ ->
            let
                signature =
                    fieldSignature objectName fieldType
            in
            { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
            , annotation = signature.annotation
            , linkage = signature.linkage
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


decodeScalar : String -> Bool -> Elm.Expression
decodeScalar scalarName nullable =
    let
        lowered =
            String.toLower scalarName
    in
    if List.member lowered [ "string", "int", "float" ] then
        Elm.fqVal [ "Decode" ] (Utils.String.formatValue scalarName)

    else if lowered == "boolean" then
        Elm.fqVal [ "Decode" ] "bool"

    else if lowered == "id" then
        Elm.fqVal [ "GraphQL", "Engine" ] "decodeId"

    else
        Elm.access (Elm.fqVal [ "Scalar" ] (Utils.String.formatValue scalarName)) "decoder"


generateFiles : GraphQL.Schema.Schema -> List Common.File
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

        moduleName =
            [ "TnGql", "Object" ]

        module_ =
            Elm.normalModule moduleName []

        phantomTypeDeclarations =
            objects
                |> List.map
                    (\object ->
                        Elm.customTypeDecl Nothing object.name [] [ ( object.name, [] ) ]
                    )

        -- ( imports_, exposing_ ) =
        --     Elm.combineLinkage linkage
        --         |> Elm.addImport Common.modules.decode.import_
        --         |> Elm.addImport Common.modules.scalar.import_
        --     in
        masterObjectFile =
            { name = moduleName
            , file =
                Elm.file module_
                    []
                    phantomTypeDeclarations
                    Nothing
            }
    in
    masterObjectFile :: objectFiles

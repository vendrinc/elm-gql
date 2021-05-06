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
                            -- ( underlyingTypeAnnotation, linkage__ ) =
                            --     Common.gqlTypeToElmTypeAnnotation field.type_ Nothing
                            ( typeAnnotation, typeLinkage ) =
                                createTypeSignature object field.type_ False

                            -- Elm.fqTyped [ "GraphQL", "Engine" ]
                            --     "Selection"
                            --     [ Elm.fqTyped [ "TnGql", "Object" ] object.name []
                            --     , underlyingTypeAnnotation
                            --     ]
                            ( implementation, import_ ) =
                                createImplementation field.name field.type_ False
                        in
                        ( ( field.name, typeAnnotation, implementation ) :: accDecls
                        , typeLinkage
                            :: (import_
                                    |> Maybe.map (\i -> Elm.emptyLinkage |> Elm.addImport (Elm.importStmt i Nothing Nothing))
                                    |> Maybe.withDefault Elm.emptyLinkage
                               )
                            :: linkageAcc
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


createTypeSignature object fieldType nullable =
    case fieldType of
        GraphQL.Schema.Type.Object selectedObjectName ->
            let
                
                typeAnnotation =
                    Elm.funAnn 
                        (Common.modules.engine.fns.selection object.name (Elm.typeVar "data")) 
                        
                        (Common.modules.engine.fns.selection selectedObjectName 
                            (if nullable then
                                (Elm.maybeAnn (Elm.typeVar "data"))
                            else
                                (Elm.typeVar "data")

                            )
                        ) 

            in
            ( typeAnnotation
            , Elm.emptyLinkage
            )
        
        GraphQL.Schema.Type.Nullable newType  ->
            createTypeSignature object newType True

        _ ->
            let
                ( dataType, linkage ) =
                    Common.gqlTypeToElmTypeAnnotation fieldType Nothing

                typeAnnotation =
                    Common.modules.engine.fns.selection object.name dataType
            in
            ( typeAnnotation, linkage )


createImplementation name type_ nullable =
    case type_ of
        GraphQL.Schema.Type.Scalar scalarName ->
            ( Elm.apply
                [ Common.modules.engine.fns.field
                , Elm.string name
                , decodeScalar scalarName nullable
                ]
            , Just [ "Scalar" ]
            )

        GraphQL.Schema.Type.Enum enumName ->
            ( Elm.apply
                [ Common.modules.engine.fns.field
                , Elm.fun "identity"
                , Elm.string name
                , Elm.fqFun [ "TnGql", "Enum", enumName ] "decoder"
                , Elm.list []
                ]
            , Just [ "TnGql", "Enum", enumName ]
            )

        GraphQL.Schema.Type.Object objectName ->
            ( Elm.lambda [ Elm.varPattern "selection_" ]
                (Elm.apply
                    [ Common.modules.engine.fns.object
                    , Elm.string name
                    , Elm.val "selection_"
                    ]
                )
            , Just [ "TnGql", "Object", objectName ]
            )

        GraphQL.Schema.Type.Nullable newType ->
            createImplementation name newType True

        _ ->
            ( Elm.string ("unimplemented: " ++ Debug.toString type_), Nothing )


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

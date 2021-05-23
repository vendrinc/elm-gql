module Generate.Objects exposing (generateFiles)

-- import Codegen.Common as Common
import Dict
import Elm
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


-- objectToModule : GraphQL.Schema.Object.Object -> Elm.File
-- objectToModule object =
--     let
--         ( fieldTypesAndImpls, linkage ) =
--             object.fields
--                 -- |> List.filter
--                 --     (\field ->
--                 --         List.member field.name [ "name", "slug", "id", "viewUrl", "parent" ]
--                 --     )
--                 |> List.foldl
--                     (\field ( accDecls, linkageAcc ) ->
--                         let
--                             implemented =
--                                 implementField object.name
--                                     field.name
--                                     field.type_
--                                     UnwrappedValue
--                         in
--                         ( ( field.name, implemented.annotation, implemented.expression ) :: accDecls
--                         , implemented.linkage :: linkageAcc
--                         )
--                     )
--                     ( [], [] )

--         -- GQL.Query (Maybe value)
--         objectTypeAnnotation =
--             fieldTypesAndImpls
--                 |> List.map (\( name, typeAnnotation, _ ) -> ( name, typeAnnotation ))
--                 |> Elm.recordAnn

--         objectImplementation =
--             fieldTypesAndImpls
--                 |> List.map (\( name, _, implementation ) -> ( name, implementation ))
--                 |> Elm.record

--         objectDecl =
--             Elm.valDecl Nothing (Just objectTypeAnnotation) (String.decapitalize object.name) objectImplementation

--         moduleName =
--             [ "TnGql", "Object", object.name ]

--         ( imports_, exposing_ ) =
--             Elm.combineLinkage linkage
--                 |> Elm.addImport Common.modules.decode.import_
--                 |> Elm.addImport Common.modules.scalar.import_
--                 |> Elm.addImport (Elm.importStmt [ "TnGql", "Object" ] Nothing Nothing)
--                 |> Elm.addImport (Elm.importStmt [ "GraphQL", "Engine" ] Nothing Nothing)
--     in
--     Elm.file (Elm.moduleName [ "TnGql", "Object", object.name ])
--         [ objectDecl |> Elm.expose
--         ]
    
-- type Wrapped
--     = UnwrappedValue
--     | InList Wrapped
--     | InMaybe Wrapped


-- implementField :
--     String
--     -> String
--     -> Type
--     -> Wrapped
--     ->
--         { expression : Elm.Expression
--         , annotation : Elm.TypeAnnotation
--         , linkage : Elm.Linkage
--         }
-- implementField objectName fieldName fieldType wrapped =
--     case fieldType of
--         GraphQL.Schema.Type.Nullable newType ->
--             implementField objectName fieldName newType (InMaybe wrapped)

--         GraphQL.Schema.Type.List_ newType ->
--             implementField objectName fieldName newType (InList wrapped)

--         GraphQL.Schema.Type.Scalar scalarName ->
--             let
--                 signature =
--                     fieldSignature objectName fieldType
--             in
--             { expression =
--                 Elm.apply
--                     [ Common.modules.engine.fns.field
--                     , Elm.string fieldName
--                     , decodeScalar scalarName wrapped
--                     ]
--             , annotation = signature.annotation
--             , linkage =
--                 signature.linkage
--                     |> Elm.addImport Common.modules.scalar.import_
--             }

--         GraphQL.Schema.Type.Enum enumName ->
--             let
--                 signature =
--                     fieldSignature objectName fieldType
--             in
--             { expression =
--                 Elm.apply
--                     [ Common.modules.engine.fns.field
--                     , Elm.string fieldName
--                     , Elm.fqFun [ "TnGql", "Enum", enumName ] "decoder"
--                     ]
--             , annotation = signature.annotation
--             , linkage =
--                 signature.linkage
--                     |> Elm.addImport (Common.modules.generated.enum enumName)
--             }

--         GraphQL.Schema.Type.Object nestedObjectName ->
--             { expression =
--                 Elm.lambda [ Elm.varPattern "selection_" ]
--                     (Elm.apply
--                         [ Common.modules.engine.fns.object
--                         , Elm.string fieldName
--                         , wrapExpression wrapped (Elm.val "selection_")
--                         ]
--                     )
--             , annotation =
--                 Elm.funAnn
--                     (Common.modules.engine.fns.selection nestedObjectName (Elm.typeVar "data"))
--                     (Common.modules.engine.fns.selection objectName
--                         (wrapAnnotation wrapped (Elm.typeVar "data"))
--                     )
--             , linkage =
--                 Elm.emptyLinkage
--             }

--         GraphQL.Schema.Type.Interface interfaceName ->
--             let
--                 signature =
--                     fieldSignature objectName fieldType
--             in
--             { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
--             , annotation = signature.annotation
--             , linkage = signature.linkage
--             }

--         GraphQL.Schema.Type.InputObject inputName ->
--             let
--                 signature =
--                     fieldSignature objectName fieldType
--             in
--             { expression = Elm.string ("unimplemented: " ++ Debug.toString fieldType)
--             , annotation = signature.annotation
--             , linkage = signature.linkage
--             }

--         GraphQL.Schema.Type.Union unionName ->
--             { expression =
--                 Elm.lambda [ Elm.varPattern "union_" ]
--                     (Elm.apply
--                         [ Common.modules.engine.fns.object
--                         , Elm.string fieldName
--                         , wrapExpression wrapped (Elm.val "union_")
--                         ]
--                     )
--             , annotation =
--                 Elm.funAnn
--                     (Common.modules.engine.fns.selectUnion unionName (Elm.typeVar "data"))
--                     (Common.modules.engine.fns.selection objectName
--                         (wrapAnnotation wrapped (Elm.typeVar "data"))
--                     )
--             , linkage =
--                 Elm.emptyLinkage
--             }


-- wrapAnnotation : Wrapped -> Elm.TypeAnnotation -> Elm.TypeAnnotation
-- wrapAnnotation wrap signature =
--     case wrap of
--         UnwrappedValue ->
--             signature

--         InList inner ->
--             Elm.listAnn (wrapAnnotation inner signature)

--         InMaybe inner ->
--             Elm.maybeAnn (wrapAnnotation inner signature)


-- wrapExpression : Wrapped -> Elm.Expression -> Elm.Expression
-- wrapExpression wrap exp =
--     case wrap of
--         UnwrappedValue ->
--             exp

--         InList inner ->
--             Elm.parens
--                 (Elm.apply
--                     [ Elm.fqFun [ "Decode" ] "list"
--                     , wrapExpression inner exp
--                     ]
--                 )

--         InMaybe inner ->
--             Elm.parens
--                 (Elm.apply
--                     [ Elm.fqFun Common.modules.engine.fqName "nullable"
--                     , wrapExpression inner exp
--                     ]
--                 )


-- fieldSignature :
--     String
--     -> Type
--     ->
--         { annotation : Elm.TypeAnnotation
--         , linkage : Elm.Linkage
--         }
-- fieldSignature objectName fieldType =
--     let
--         ( dataType, linkage ) =
--             Common.gqlTypeToElmTypeAnnotation fieldType Nothing

--         typeAnnotation =
--             Common.modules.engine.fns.selection objectName dataType
--     in
--     { annotation = typeAnnotation
--     , linkage = linkage
--     }


-- decodeScalar : String -> Wrapped -> Elm.Expression
-- decodeScalar scalarName nullable =
--     let
--         lowered =
--             String.toLower scalarName
--     in
--     if List.member lowered [ "string", "int", "float" ] then
--         Elm.fqVal [ "Decode" ] (Utils.String.formatValue scalarName)

--     else if lowered == "boolean" then
--         Elm.fqVal [ "Decode" ] "bool"

--     else if lowered == "id" then
--         Elm.fqVal [ "GraphQL", "Engine" ] "decodeId"

--     else
--         Elm.access (Elm.fqVal [ "Scalar" ] (Utils.String.formatValue scalarName)) "decoder"


generateFiles : GraphQL.Schema.Schema -> List Elm.File
generateFiles graphQLSchema =
    let
        objects =
            graphQLSchema.objects
                |> Dict.toList
                |> List.map Tuple.second
                |> List.filter (\object -> object.name == "App")

        objectFiles = []
            -- objects
            --     |> List.map objectToModule

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

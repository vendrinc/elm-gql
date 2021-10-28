module GraphQL.Operations.Generate exposing (generate)

{-| Generate elm code from an Operations.AST
-}

import Dict
import Elm
import Elm.Annotation as Type
import Generate.Args
import Generate.Example
import Generate.Input as Input
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Validate as Validate
import GraphQL.Schema
import GraphQL.Schema.Type as SchemaType
import Set
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Decode
import GraphQL.Schema.Scalar
import Utils.String
import Elm.Pattern as Pattern
import Elm.Gen.String
import GraphQL.Operations.AST as AST

generate : String -> GraphQL.Schema.Schema -> String -> Can.Document -> List String -> Result (List Validate.Error) (List Elm.File)
generate namespace schema queryStr document path =
    let
        typeName =
            case document.definitions of
                [] -> "Query"

                [ Can.Operation op  ] -> 
                    (Maybe.withDefault "Query" 
                        (Maybe.map 
                            Can.nameToString op.name
                        )
                    )
                
                _ -> 
                    "Query"


        query =
            Elm.fn "query"
                ( "input"
                , Type.record
                    (List.concatMap (getVariables namespace schema) document.definitions)
                )
                (\var ->
                    Engine.prebakedQuery
                        (Elm.string queryStr)
                        (Elm.list 
                            (List.concatMap 
                                (encodeVariable namespace schema) 
                                document.definitions
                            )
                        )
                        (generateDecoder schema document.definitions )
                        |> Elm.withType 
                            (Engine.types_.selection
                                (Engine.types_.query)
                                (Type.named [  ] typeName)
                            )

                )
                    |> Elm.expose

        helpers =
            List.concatMap (generateResultTypes schema) document.definitions
    
        primaryResult =
            List.concatMap (generatePrimaryResultType schema) document.definitions
    in
    Ok
        [ Elm.file path
            (primaryResult ++ helpers ++ [query ] ++ [decodeHelper])
        ]



encodeVariable : String ->GraphQL.Schema.Schema -> Can.Definition -> List Elm.Expression
encodeVariable namespace schema def =
    case def of
        Can.Fragment frag ->
            []

        Can.Operation op ->
            List.map (toVariableEncoder namespace schema) op.variableDefinitions
    

toVariableEncoder : String -> GraphQL.Schema.Schema -> Can.VariableDefinition -> Elm.Expression
toVariableEncoder namespace schema var =
    let
        name = Can.nameToString var.variable.name

    in
    Elm.get name (Elm.value "input")
        |> Generate.Args.toJsonValue 
            namespace
            schema 
            (toVariableSchemaType schema var.type_)
            (Input.getWrapFromAst var.type_)
        |> Elm.tuple (Elm.string name)


toVariableSchemaType : GraphQL.Schema.Schema -> AST.Type -> SchemaType.Type
toVariableSchemaType schema type_ =
    case type_ of
        AST.Type_ name ->
            if nameIsScalar (AST.nameToString name) then
                SchemaType.Scalar (AST.nameToString name)
            else
                SchemaType.InputObject (AST.nameToString name)

        AST.List_ inner ->
            SchemaType.List_ (toVariableSchemaType schema inner)

        AST.Nullable inner ->
            SchemaType.Nullable (toVariableSchemaType schema inner)


nameIsScalar : String -> Bool
nameIsScalar name =
    List.member (String.toLower name) 
        [ "int"
        , "float"
        , "boolean"
        ]



andField : Can.Name -> Elm.Expression -> Elm.Expression -> Elm.Expression
andField name decoder builder =
    Elm.pipe
        builder
        (Elm.apply 
            (Elm.value "field")
            [ (Elm.string (Can.nameToString name)) 
            , decoder
            ]
        )



{-|
field name fieldExpr builder



-}

decodeHelper : Elm.Declaration
decodeHelper =
    Elm.fn3 "field" 
        ("name", Type.string)
        ("new", Decode.types_.decoder (Type.var "a"))
        ("build", Decode.types_.decoder (Type.function [Type.var "a"] (Type.var "b")))
        (\name new build ->
            build
                |> (Decode.map2 
                        (\_ _ ->
                            Elm.lambda2 "inner" 
                                Type.unit
                                Type.unit
                                (\one two -> 
                                    Elm.apply two [ one ]
                                ) 
                        )
                        (Decode.field 
                            name
                            new
                        )
                    )
                |> Elm.withType (Decode.types_.decoder (Type.var "b"))
        )


getVariables : String -> GraphQL.Schema.Schema -> Can.Definition -> List ( String, Type.Annotation )
getVariables namespace schema def =
    case def of
        Can.Fragment frag ->
            []

        Can.Operation op ->
            List.map (toVariableAnnotation namespace schema) op.variableDefinitions



toVariableAnnotation : String -> GraphQL.Schema.Schema -> Can.VariableDefinition -> ( String, Type.Annotation )
toVariableAnnotation namespace schema var =
    ( Can.nameToString var.variable.name
    , toElmType namespace schema var.type_
    )


toElmType : String -> GraphQL.Schema.Schema -> AST.Type -> Type.Annotation
toElmType namespace schema astType =
    case astType of
        AST.Type_ name ->
            toElmTypeHelper namespace schema astType

        AST.List_ inner ->
            Type.list (toElmTypeHelper namespace schema inner)

        AST.Nullable inner ->
            Type.maybe (toElmTypeHelper namespace schema inner)


toElmTypeHelper : String -> GraphQL.Schema.Schema -> AST.Type -> Type.Annotation
toElmTypeHelper namespace schema astType =
    case astType of
        AST.Type_ name ->
            let
                typename =
                    AST.nameToString name
            in
            if isPrimitive schema typename then
                Type.named [] typename

            else
                case Dict.get typename schema.inputObjects of
                    Nothing ->
                        -- this should never happen because this is validated...
                        Type.named  [] typename

                    Just input ->
                        Generate.Args.annotation namespace schema input

        AST.List_ inner ->
            Type.list (toElmTypeHelper namespace schema inner)

        AST.Nullable inner ->
            Type.maybe (toElmTypeHelper namespace schema inner)


isPrimitive : GraphQL.Schema.Schema -> String -> Bool
isPrimitive schema name =
    if Dict.member name schema.scalars then
        True

    else
        Set.member name primitives


primitives : Set.Set String
primitives =
    Set.fromList
        [ "Int"
        , "String"
        , "Float"
        , "Boolean"
        , "ID"
        ]




{- RESULT DATA -}


generatePrimaryResultType : GraphQL.Schema.Schema -> Can.Definition -> List Elm.Declaration
generatePrimaryResultType schema def =
    case def of
        Can.Fragment frag ->
            []

        Can.Operation op ->
            [ Elm.alias 
                (Maybe.withDefault "Query" 
                    (Maybe.map 
                        Can.nameToString op.name
                    )
                )
                (Type.record 
                    (List.map 
                        (fieldAnnotation schema Nothing)
                        op.fields
                    )
                )
            ]
             



generateResultTypes :  GraphQL.Schema.Schema -> Can.Definition -> List Elm.Declaration
generateResultTypes schema def =
    case def of
        Can.Fragment frag ->
            []

        Can.Operation op ->
             List.concatMap (generateChildTypes schema) (op.fields)


generateChildTypes : GraphQL.Schema.Schema -> Can.Selection -> List Elm.Declaration
generateChildTypes schema sel =
    case sel of
        Can.FieldObject obj ->               
            List.concatMap (generateChildTypes schema) (obj.selection)


        Can.FieldUnion field ->
            Elm.customType 
                (Maybe.withDefault (Can.nameToString field.name)
                    (Maybe.map 
                        Can.nameToString field.alias_
                    )
                )
                (List.filterMap 
                    (unionVariant schema)
                    field.selection
                )
                 :: List.concatMap (generateChildTypes schema) (field.selection)
        _ ->
            []


unionVariant : GraphQL.Schema.Schema -> Can.Selection -> Maybe Elm.Variant
unionVariant schema selection =
    case selection of
        Can.FieldScalar field ->
            Nothing

        Can.UnionCase field ->
            case List.filter removeTypename field.selection of 
                [] ->
                    Just (Elm.variant (Can.nameToString field.tag))
                    
                fields ->
                    Just 
                        (Elm.variantWith 
                            (Can.nameToString field.tag)
                            [ Type.record 
                                (List.map 
                                    (fieldAnnotation schema Nothing)
                                    fields
                                )
                            ]
                        )

        _ ->
            let
                _ = Debug.log "NOT IMPLEMENTED" selection
            in
            Debug.todo "Union variant not implemented!" selection


removeTypename : Can.Selection -> Bool
removeTypename field =
    case field of 
        Can.FieldScalar scal ->
            case scal.type_ of
                SchemaType.Scalar "typename" ->
                    False
                _ ->
                    True

        _ ->
            True


fieldAnnotation : GraphQL.Schema.Schema -> Maybe String -> Can.Selection -> (String, Type.Annotation)
fieldAnnotation schema parent selection =
    case selection of
        Can.Field field ->
            ( case field.alias_ of
                Nothing ->
                    Can.nameToString field.name 
                Just alias ->
                    Can.nameToString alias
            , case field.selection of
                [] ->
                    -- This is a leaf, produce a leaf type
                   
                     case parent of
                        Nothing ->
                            -- Debug.todo "WAT"
                            Type.unit

                        Just par ->
                            getScalarType par (Can.nameToString field.name) schema
                                |> schemaTypeToPrefab

                sels ->
                    Type.record 
                        (List.map 
                            (fieldAnnotation schema (Just (Can.nameToString field.name)))
                            field.selection
                        )
                    
                
            )

        Can.FieldObject field ->
            ( case field.alias_ of
                Nothing ->
                    Can.nameToString field.name 
                Just alias ->
                    Can.nameToString alias
            , case field.selection of
                [] ->
                     case parent of
                        Nothing ->
                            -- Debug.todo "WAT"
                            Type.unit

                        Just par ->
                            getScalarType par (Can.nameToString field.name) schema
                                |> schemaTypeToPrefab

                sels ->
                    Input.wrapElmType field.wrapper
                        (Type.record 
                            (List.map 
                                (fieldAnnotation schema (Just (Can.nameToString field.name)))
                                field.selection
                            ))
                    
                
            )

        Can.FieldScalar field ->
            ( case field.alias_ of
                Nothing ->
                    Can.nameToString field.name 
                Just alias ->
                    Can.nameToString alias
            ,  schemaTypeToPrefab field.type_
            )

        Can.FieldEnum field ->
            ( case field.alias_ of
                Nothing ->
                    Can.nameToString field.name 
                Just alias ->
                    Can.nameToString alias
            , enumType field.enumName
            )

        Can.UnionCase field ->
            ( Can.nameToString field.tag 
            , Type.named 
                [] 
                (Can.nameToString field.tag)
            )

        Can.FieldUnion field ->
            ( case field.alias_ of
                Nothing ->
                    Can.nameToString field.name 
                Just alias ->
                    Can.nameToString alias
            , case field.selection of
                [] ->
                     case parent of
                        Nothing ->
                            Type.unit

                        Just par ->
                            getScalarType par (Can.nameToString field.name) schema
                                |> schemaTypeToPrefab

                sels ->
                    Type.named 
                        [] 
                        (Can.nameToString field.name)
            )

        _ ->
            let
                _ = Debug.log "NOT IMPLEMENTED" selection
            in
            Debug.todo "Field not implemented!" selection

        


enumValue : String -> String -> Elm.Expression
enumValue enumName val =
    Elm.valueFrom
        [ "TnG"
        , "Enum"
        , Utils.String.formatTypename enumName
        ] 
        val


enumType : String -> Type.Annotation
enumType enumName =
    Type.named 
        [ "TnG"
        , "Enum"
        , Utils.String.formatTypename enumName
        ] 
        enumName


schemaTypeToPrefab : SchemaType.Type -> Type.Annotation
schemaTypeToPrefab schemaType =
    case schemaType of
        SchemaType.Scalar scalarName ->
            case String.toLower scalarName of
                "string" ->
                    Type.string

                "int" ->
                    Type.int

                "float" ->
                    Type.float

                "boolean" ->
                    Type.bool

                _ ->
                    Type.namedWith [ "Scalar" ]
                        (Utils.String.formatScalar scalarName)
                        []

        SchemaType.InputObject input ->
            Type.unit

        SchemaType.Object obj ->
            Type.unit

        SchemaType.Enum name ->
            Type.unit

        SchemaType.Union name ->
            Type.unit

        SchemaType.Interface name ->
            Type.unit

        SchemaType.List_ inner ->
            Type.list (schemaTypeToPrefab inner)

        SchemaType.Nullable inner ->
            Type.maybe (schemaTypeToPrefab inner)


{- DECODER -}

generateDecoder : GraphQL.Schema.Schema -> List Can.Definition -> Elm.Expression
generateDecoder schema defs =
    case defs of
        [] ->
            Decode.succeed Elm.unit

        [ Can.Operation op ] ->
            let
                opName =
                    (Maybe.withDefault "Query" 
                        (Maybe.map 
                            Can.nameToString op.name
                        )
                    )
            in
            decodeFields op.fields
                (Decode.succeed
                    (Elm.value opName)
                )

        _ ->
            Decode.succeed Elm.unit
            
            

subobjectBuilderArgs : Can.Selection -> (Pattern.Pattern, Type.Annotation)
subobjectBuilderArgs sel =
    ( Pattern.var (Utils.String.formatValue (Can.getAliasedName sel))
    , Type.unit
    )
      


subobjectBuilderBody : List Can.Selection -> Elm.Expression
subobjectBuilderBody fields =
    Elm.record 
        (List.map 
            (\selection ->
                let
                    name = (Can.getAliasedName selection)
                in
                Elm.field name
                    ((Elm.value (Utils.String.formatValue name)))
            
            )
        
        fields)

decodeFields : List Can.Selection -> Elm.Expression -> Elm.Expression
decodeFields fields exp =
    case fields of
        [] ->
            exp

        (Can.Field field :: remain) ->
             exp
        
        (((Can.FieldObject obj) as field) :: remain) -> 
            decodeFields 
                remain
                (andField
                    (Can.Name (Can.getAliasedName field))
                    (Input.decodeWrapper obj.wrapper
                        (decodeFields obj.selection 
                            (Decode.succeed
                                (Elm.lambdaWith 
                                    (List.map subobjectBuilderArgs obj.selection)
                                    (subobjectBuilderBody obj.selection)

                                )
                            )
                        )
                    )
                    exp
                )
                
        
        (Can.FieldScalar scal :: remain) -> 
             let
                decoded =
                     andField
                        scal.name
                        (decodeScalarType scal.type_)
                        exp
                        
             in
             decodeFields 
                remain
                decoded
            
        (((Can.FieldEnum enum) as field) :: remain) -> 
             let
                decoded =
                    andField
                        (Can.Name (Can.getAliasedName field))
                        (Decode.string
                            |> (Decode.andThen
                                (\_ ->
                                    Elm.lambda  "enum"
                                        Type.string
                                        (\str ->
                                            Elm.caseOf (Elm.Gen.String.toLower str) 
                                                ((List.map 
                                                    (\value ->
                                                        ( Pattern.string (String.toLower value.name)
                                                        , Decode.succeed 
                                                            (enumValue enum.enumName
                                                                value.name
                                                            )
                                                        )
                                                    
                                                    )
                                                    enum.values
                                                ) ++ 
                                                    [ ( Pattern.wildcard
                                                     ,  (Decode.fail (Elm.string "I don't recognize this enum!"))
                                                     )
                                                    ]
                                                
                                                )
                                        )
                                )
                            )
                        )    
                        exp
             in
             decodeFields 
                remain
                decoded

        (((Can.FieldUnion union) as field) :: remain) ->
            decodeFields 
                remain
                (andField
                     (Can.Name (Can.getAliasedName field))
                    (decodeUnion union)
                     exp
                )

        _ ->
            exp



decodeUnion : { a | selection : List Can.Selection } -> Elm.Expression
decodeUnion union =
    Decode.field (Elm.string "__typename") Decode.string
        |> Decode.andThen 
            (\_ ->
                Elm.lambda "typename" 
                    Type.string
                    (\typename -> 
                        Elm.caseOf typename
                            ((List.filterMap 
                                toUnionVariantPattern
                                union.selection
                             )
                             ++ 
                             [ (Pattern.wildcard
                               , Decode.fail (Elm.string "Unknown union type")
                               )

                             ]
                            )
                    ) 
                        

            )

toUnionVariantPattern : Can.Selection -> Maybe (Pattern.Pattern, Elm.Expression)
toUnionVariantPattern selection =
    case selection of
        Can.UnionCase var ->
            let
                tag = (Utils.String.formatTypename (Can.nameToString var.tag))
            in
            Just 
                ( Pattern.string tag
                , case List.filter removeTypename var.selection of
                    [] ->
                        Decode.succeed (Elm.value tag)

                    fields ->
                        Decode.succeed 
                            (Elm.lambdaWith 
                                (List.map fieldParameters fields)
                                (Elm.apply (Elm.value tag)
                                    [ Elm.record 
                                        (List.map buildRecordFromVariantFields fields)
                                    ]
                                )
                                

                            )
                            |> decodeFields fields
                            

                )
        _ ->
            Nothing


fieldParameters : Can.Selection -> (Pattern.Pattern, Type.Annotation)
fieldParameters field =
    let
        name = Can.getAliasedName field
    in
    (Pattern.var name, Type.unit)


buildRecordFromVariantFields field =
    let
        name = Can.getAliasedName field
    in
    (Elm.field name (Elm.value name))


decodeScalarType : SchemaType.Type -> Elm.Expression
decodeScalarType type_ =
    case type_ of
        SchemaType.Scalar scalarName ->
            case String.toLower scalarName of
                "int" ->
                    Decode.int

                "float" ->
                    Decode.float

                "string" ->
                    Decode.string
                
                "boolean" ->
                    Decode.bool

                scal ->
                    Elm.valueFrom ["Scalar"]
                        (Utils.String.formatValue scalarName)
                        |> Elm.get "decoder"
                    -- Decode.succeed (Elm.string scal)


        SchemaType.Nullable inner ->
            Decode.nullable (decodeScalarType inner)

        
        SchemaType.List_ inner ->
            Decode.list (decodeScalarType inner)


        _ ->
            Decode.succeed (Elm.string "DECODE UNKNOWN")


getScalarType :  String -> String -> GraphQL.Schema.Schema -> SchemaType.Type
getScalarType queryName field schema =
    case Dict.get queryName schema.queries of
        Nothing ->
            case Dict.get queryName schema.objects of
                Nothing ->
                    let
                        _ = Debug.log "Not an object" (queryName, field)
                    in
                    SchemaType.Scalar (queryName ++ "." ++ field ++  "NOT AN OBJECT?!")

                Just object ->
                    let
                        found =
                            List.filter 
                                (\f ->
                                    f.name == field
                                )
                                object.fields
                                
                    in
                    case List.head found of
                        Nothing ->
                            SchemaType.Scalar "NOT FOUND?!"

                        Just foundField ->
                            foundField.type_
        

        Just q ->
            case q.type_ of
                SchemaType.Object objName ->
                    case Dict.get objName schema.objects of
                        Nothing ->
                            SchemaType.Scalar "WHAAT?!?!"
                        
                        Just object -> 
                             let
                                found =
                                    List.filter 
                                        (\f ->
                                            f.name == field
                                        )
                                        object.fields
                                        
                            in
                            case List.head found of
                                Nothing ->
                                    SchemaType.Scalar "NOT FOUND?!"

                                Just foundField ->
                                    foundField.type_


                _ ->
                    q.type_
            
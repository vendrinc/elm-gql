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


generate : GraphQL.Schema.Schema -> String -> Can.Document -> List String -> Result (List Validate.Error) (List Elm.File)
generate schema queryStr document path =
    let
        query =
            Elm.fn "query"
                    ( "input"
                    , Type.record
                        (List.concatMap (getVariables schema) document.definitions)
                    )
                    (\var ->
                        Engine.prebakedQuery
                            (Elm.string queryStr)
                            (generateDecoder schema document.definitions )

                    )
                    |> Elm.expose

        helpers =
            List.concatMap (generateResultTypes schema) document.definitions
    in
    Ok
        [ Elm.file path
            (query :: helpers)


            
        ]


getVariables : GraphQL.Schema.Schema -> Can.Definition -> List ( String, Type.Annotation )
getVariables schema def =
    case def of
        Can.Fragment frag ->
            []

        Can.Operation op ->
            List.map (toVariableAnnotation schema) op.variableDefinitions


toVariableAnnotation : GraphQL.Schema.Schema -> Can.VariableDefinition -> ( String, Type.Annotation )
toVariableAnnotation schema var =
    ( Can.nameToString var.variable.name
    , toElmType schema var.type_
    )


toElmType : GraphQL.Schema.Schema -> Can.Type -> Type.Annotation
toElmType schema astType =
    case astType of
        Can.Type_ name ->
            Type.string

        Can.List_ inner ->
            Type.list (toElmTypeHelper schema inner)

        Can.Nullable inner ->
            toElmTypeHelper schema inner


toElmTypeHelper : GraphQL.Schema.Schema -> Can.Type -> Type.Annotation
toElmTypeHelper schema astType =
    case astType of
        Can.Type_ name ->
            let
                typename =
                    Can.nameToString name
            in
            if isPrimitive schema typename then
                Type.named [] typename

            else
                case Dict.get typename schema.inputObjects of
                    Nothing ->
                        -- this should never happen because this is validated...
                        Type.named  [] typename

                    Just input ->
                        case Input.splitRequired input.fields of
                            ( req, [] ) ->
                                Type.record
                                    (List.map
                                        (\r ->
                                            ( r.name
                                            , Type.string
                                            )
                                        )
                                        req
                                    )

                            ( required, opts ) ->
                                Type.named [] typename

        Can.List_ inner ->
            Type.list (toElmTypeHelper schema inner)

        Can.Nullable inner ->
            Type.maybe (toElmTypeHelper schema inner)


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



generateResultTypes :  GraphQL.Schema.Schema -> Can.Definition -> List Elm.Declaration
generateResultTypes schema def =
    case def of
        Can.Fragment frag ->
            []

        Can.Operation op ->
             (Elm.alias 
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
                ))
             :: List.concatMap (generateChildTypes schema) (op.fields)


generateChildTypes : GraphQL.Schema.Schema -> Can.Selection -> List Elm.Declaration
generateChildTypes schema sel =
    case sel of
        Can.FieldObject obj ->
            Elm.alias 
                (Maybe.withDefault (Can.nameToString obj.name)
                    (Maybe.map 
                        Can.nameToString obj.alias_
                    )
                )
                (Type.record 
                    (List.map 
                        (fieldAnnotation schema Nothing)
                        obj.selection
                    )
                ) :: List.concatMap (generateChildTypes schema) (obj.selection)

        _ ->
            []


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
                    let
                        _ = Debug.log "LEAF" (parent, field.name)

                        
                           
                    in
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
                    -- This is a leaf, produce a leaf type
                    let
                        _ = Debug.log "LEAF" (parent, field.name)

                        
                           
                    in
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

        Can.FieldScalar field ->
            ( case field.alias_ of
                Nothing ->
                    Can.nameToString field.name 
                Just alias ->
                    Can.nameToString alias
            ,  schemaTypeToPrefab field.type_
            )

        _ ->
            Debug.todo "Field not implemented!" selection

        


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
            --     _ = Debug.log "OP" 
            --         ( op.variableDefinitions
                    
            --         )
            in
            decodeFields op.fields (Decode.succeed (Elm.value opName))

        _ ->
            Decode.succeed Elm.unit
            
            

decodeFields fields exp =
    case Debug.log "FIELDS" fields of
        [] ->
            exp

        (Can.Field field :: remain) ->
            -- Decode.field
            
             exp
        
        (Can.FieldObject obj :: remain) -> 
            decodeFields 
                remain
                (exp
                    |> Decode.map2 
                        (\newField builder ->
                            -- Elm.apply builder [ newField ]
                            -- Elm.tuple newField builder
                            Elm.lambda2 "build" 
                                Type.unit
                                Type.unit
                                (\one two -> 
                                    Elm.apply two [ one ]
                                ) 
                        )
                        (Decode.field 
                            (Elm.string (Can.nameToString obj.name)) 
                            (decodeFields obj.selection 
                                (Decode.succeed
                                    (Elm.value (Utils.String.formatTypename (Can.nameToString obj.name)))
                                )
                            )
                        )
                    )
                
        
        (Can.FieldScalar scal :: remain) -> 
             let
                decoded =
                    exp
                    |> Decode.map2 
                        (\newField builder ->
                            Elm.lambda2 "build" 
                                Type.unit
                                Type.unit
                                (\one two -> 
                                    Elm.apply two [ one ]
                                ) 
                        )
                        (Decode.field 
                            (Elm.string (Can.nameToString scal.name)) 
                            (decodeScalarType scal.type_)
                            
                        )
             in
             
             decodeFields 
                remain
                decoded
            


        (Can.FieldUnion union :: remain) ->
            exp

        _ ->
            exp


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
            
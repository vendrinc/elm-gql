module GraphQL.Operations.Canonicalize exposing (errorToString, canonicalize)


{-|-}

import GraphQL.Schema
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Schema.Operation as Operation
import GraphQL.Schema.Object as Object
import GraphQL.Schema.Enum as Enum
import GraphQL.Schema.Field as Field
import GraphQL.Schema.Interface as Interface
import GraphQL.Schema.Union as Union
import GraphQL.Schema.Scalar as Scalar
import GraphQL.Schema.InputObject as Input
import GraphQL.Schema.Type as Type
import Dict exposing (Dict)

type Error =
    Error 
        { coords : Coords 
        , error : ErrorDetails 
        }


todo : String -> Error
todo msg =
    Error 
        { coords =
            { start = zeroPosition
            , end = zeroPosition
            }

        , error = Todo msg
        }


error : ErrorDetails -> Error
error deets =
    Error 
        { coords = {start = zeroPosition, end = zeroPosition}
        , error = deets

        }

zeroPosition : Position
zeroPosition =
    { line = 0
    , char = 0

    }

type alias Coords = 
    { start : Position
    , end  : Position

    }

type alias Position =
    { line : Int
    , char : Int
    }

type ErrorDetails 
    = Todo String
    | QueryUnknown String
    | ObjectUnknown String
    | UnionUnknown String
    | FieldUnknown 
        { object : String
        , field : String
        }

errorToString : Error -> String
errorToString (Error details) =
    case details.error of
        Todo msg ->
            "Todo: " ++ msg
        QueryUnknown name ->
            "Unknown Query: " ++ name
        ObjectUnknown name ->
            "Unknown Object: " ++ name
        UnionUnknown name ->
            "Unknown Union: " ++ name
        FieldUnknown field ->
            "Unknown Field: " ++ field.object ++ "." ++ field.field
        


canonicalize : GraphQL.Schema.Schema -> AST.Document -> Result (List Error) Can.Document
canonicalize schema doc =
    case reduce (canonicalizeDefinition schema) doc.definitions (Ok []) of
        Ok result ->
            Ok { definitions = result }

        Err err ->
            Err err


reduce :
    (item -> Result (List Error) result) 
        -> List item 
        -> Result (List Error) (List result)
        -> Result (List Error) (List result)
reduce isValid items res =
    case items of
        [] ->
            res

        top :: remain ->
            case isValid top of
                Ok valid ->
                    case res of
                        Ok existing ->
                            reduce isValid remain 
                                (Ok (valid :: existing))


                        Err err ->
                            res

                Err err ->
                    let
                        newResult =
                            case res of
                                Ok _ ->
                                    Err err

                                Err existingErrors ->
                                    Err (err ++ existingErrors)
                    in
                    reduce isValid remain newResult




convertName : AST.Name -> Can.Name
convertName (AST.Name str) =
    Can.Name str

canonicalizeDefinition : GraphQL.Schema.Schema -> AST.Definition -> Result (List Error) (Can.Definition)
canonicalizeDefinition schema def =
    case def of
        AST.Fragment details ->
            Err [ todo "Top level fragments are not supported yet!" ]

        AST.Operation details ->
            case details.operationType of
                AST.Query ->
                    let
                        fieldResult = reduce (canonicalizeQuerySelection schema) details.fields (Ok [])
                    in
                    case fieldResult of
                        Ok fields ->
                            Ok <|
                                Can.Operation 
                                    { operationType = Can.Query
                                    , name = Maybe.map convertName details.name
                                    , variableDefinitions = []
                                    , directives = []
                                    , fields = fields
                                    }

                        Err err ->
                            Err err
                            

                AST.Mutation ->
                    -- reduce (validateMutation schema) details.fields (Ok ())
                    Debug.todo "MUTATSION!"


canonicalizeQuerySelection : GraphQL.Schema.Schema -> AST.Selection -> Result (List Error) (Can.Selection)
canonicalizeQuerySelection schema selection =
    case selection of
        AST.Field field ->
            case Dict.get (AST.nameToString field.name) schema.queries of
                Nothing ->
                    Err  [error (QueryUnknown (AST.nameToString field.name))]

                Just query ->
                    case query.type_ of
                        -- Union unionName ->
                        --     case Dict.get unionName schema.unions of
                        --         Nothing ->
                        --             Err [ UnknownField unionName ]

                        --         Just innerUnion ->
                        --             reduce (validateUnion schema innerUnion) field.selection (Ok [])

                        -- Object objName ->
                            -- case Dict.get objName schema.objects of
                            --     Nothing ->
                            --         Err [ UnknownField objName ]

                            --     Just obj ->
                            --         Ok ()
                            --             |> reduce (validateArg queryObj) field.arguments
                            --             |> reduce (validateField schema obj) field.selection

                        -- Leaf ->
                        --     Ok ()


                        
                        Type.Scalar name ->
                            Ok 
                                (Can.FieldScalar
                                    { alias_ = Maybe.map convertName field.alias_
                                    , name = convertName field.name
                                    , arguments = []
                                    , directives = []
                                    , type_ = query.type_
                                    }
                                )

                        Type.InputObject name ->
                            Err [ todo "Invalid schema!  Weird InputObject" ]

                        Type.Object name ->
                            case Dict.get name schema.objects of
                                Nothing ->
                                    Err [ error (ObjectUnknown name) ]

                                Just obj ->
                                    let
                                    --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                                        
                                        selectionResult = reduce (canonicalizeField schema obj) field.selection (Ok [])
                                    in
                                    case selectionResult of
                                        Ok canSelection ->
                                            Ok 
                                                (Can.FieldObject
                                                    { alias_ = Maybe.map convertName field.alias_
                                                    , name = convertName field.name
                                                    , arguments = []
                                                    , directives = []
                                                    , selection = canSelection
                                                    , object = obj
                                                    }
                                                )
                                            
                                        Err err ->
                                            Err err

                        Type.Enum name ->
                            Ok 
                                (Can.FieldScalar
                                    { alias_ = Maybe.map convertName field.alias_
                                    , name = convertName field.name
                                    , arguments = []
                                    , directives = []
                                    , type_ = query.type_
                                    }
                                )

                        Type.Union name ->
                             case Dict.get name schema.unions of
                                Nothing ->
                                    Err [ error (UnionUnknown name) ]

                                Just union ->
                                    let
                                    --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                                        
                                        selectionResult = reduce (canonicalizeUnionField schema union) field.selection (Ok [])
                                    in
                                    case selectionResult of
                                        Ok canSelection ->
                                            Ok 
                                                (Can.FieldUnion
                                                    { alias_ = Maybe.map convertName field.alias_
                                                    , name = convertName field.name
                                                    , arguments = []
                                                    , directives = []
                                                    , selection = canSelection
                                                    , union = union
                                                    }
                                                )
                                            
                                        Err err ->
                                            Err err

                        Type.Interface name ->
                            Err [ todo "Handle more object types!" ]

                        Type.List_ inner ->
                            Err [ todo "Handle more object types!" ]

                        Type.Nullable inner ->
                            Err [ todo "Handle more object types!" ]
                       

        AST.FragmentSpreadSelection frag ->
            Err [ todo "Fragments in unions aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            Err [ todo "Unions not supported yet" ]



canonicalizeField : GraphQL.Schema.Schema -> Object.Object -> AST.Selection -> Result (List Error) (Can.Selection)
canonicalizeField schema object selection =
    case selection of
        AST.Field field ->
            let
                fieldName =
                    AST.nameToString field.name

               
            in
            if fieldName == "__typename" then
                Ok 
                    (Can.FieldScalar
                        { alias_ = Maybe.map convertName field.alias_
                        , name = convertName field.name
                        , arguments = []
                        , directives = []
                        , type_ = Type.Scalar "typename"
                        }
                    )

            else
                let
                    matchedField =
                        object.fields
                            |> List.filter (\fld -> fld.name == fieldName)
                            |> List.head

                in
                -- canonicalizeFieldType
                case matchedField of
                    Just matched ->
                        canonicalizeFieldType schema object field matched.type_ selection matched.type_
                        -- case matched.type_ of
                        --     Type.Scalar name ->
                        --         -- Err [ todo "Handle more object types!" ]
                        --         Ok 
                        --             (Can.FieldScalar
                        --                 { alias_ = Maybe.map convertName field.alias_
                        --                 , name = convertName field.name
                        --                 , arguments = []
                        --                 , directives = []
                        --                 , type_ = matched.type_
                        --                 }
                        --             )

                        --     Type.InputObject name ->
                        --         Err [ todo "Invalid schema!  Weird InputObject" ]

                        --     Type.Object name ->
                        --         case Dict.get name schema.objects of
                        --             Nothing ->
                        --                 Err [ error (ObjectUnknown name) ]

                        --             Just obj ->
                        --                 let
                        --                 --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                                            
                        --                     fields = reduce (canonicalizeField schema obj) field.selection (Ok [])
                        --                 in
                        --                 Err [ todo "Field Object" ]

                        --     Type.Enum name ->
                        --         Err [ todo "Field enums!" ]

                        --     Type.Union name ->
                        --         Err [ todo "Field Unions" ]

                        --     Type.Interface name ->
                        --         Err [ todo "Field Interfaces!" ]

                        --     Type.List_ inner ->
                        --         Err [ todo "Field List" ]

                        --     Type.Nullable inner ->
                        --         let
                        --             _ = Debug.log "INNER NULLABLE" inner
                        --         in
                        --         Err [ todo "Field Nullable" ]
                                        

                    Nothing ->
                        Err [ error (FieldUnknown { object = object.name, field = fieldName} ) ]

        AST.FragmentSpreadSelection frag ->
            Err [ todo "Fragments in objects aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            Err [ todo "Inline fragments are not allowed" ]


canonicalizeFieldType : GraphQL.Schema.Schema -> Object.Object -> AST.FieldDetails -> Type.Type -> AST.Selection -> Type.Type ->  Result (List Error) (Can.Selection)
canonicalizeFieldType schema object field type_ selection originalType =
        case type_ of
            Type.Scalar name ->
                -- Err [ todo "Handle more object types!" ]
                Ok 
                    (Can.FieldScalar
                        { alias_ = Maybe.map convertName field.alias_
                        , name = convertName field.name
                        , arguments = []
                        , directives = []
                        , type_ = originalType
                        }
                    )

            Type.InputObject name ->
                Err [ todo "Invalid schema!  Weird InputObject" ]

            Type.Object name ->
                case Dict.get name schema.objects of
                    Nothing ->
                        Err [ error (ObjectUnknown name) ]

                    Just obj ->
                        let
                                --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                            
                            selectionResult = reduce (canonicalizeField schema obj) field.selection (Ok [])
                        in
                        case selectionResult of
                            Ok canSelection ->
                                Ok 
                                    (Can.FieldObject
                                        { alias_ = Maybe.map convertName field.alias_
                                        , name = convertName field.name
                                        , arguments = []
                                        , directives = []
                                        , selection = canSelection
                                        , object = obj
                                        }
                                    )
                                
                            Err err ->
                                Err err

            Type.Enum name ->
                Err [ todo "Field enums!" ]

            Type.Union name ->
                Err [ todo "Field Unions" ]

            Type.Interface name ->
                Err [ todo "Field Interfaces!" ]

            Type.List_ inner ->
                canonicalizeFieldType schema object field inner selection originalType

            Type.Nullable inner ->
                canonicalizeFieldType schema object field inner selection originalType
                                        
  




canonicalizeUnionField : GraphQL.Schema.Schema -> Union.Union -> AST.Selection -> Result (List Error) (Can.Selection)
canonicalizeUnionField schema union selection =
    case selection of
        AST.Field field ->
            -- let
            --     fieldName =
            --         AST.nameToString field.name

               
            -- in
            -- if fieldName == "__typename" then
            --     Ok 
            --         (Can.FieldScalar
            --             { alias_ = Maybe.map convertName field.alias_
            --             , name = convertName field.name
            --             , arguments = []
            --             , directives = []
            --             , type_ = Type.Scalar "typename"
            --             }
            --         )

            -- else
            --     let
            --         matchedField =
            --             unions.fields
            --                 |> List.filter (\fld -> fld.name == fieldName)
            --                 |> List.head

            --     in
            --     case matchedField of
            --         Just matched ->
            --             case matched.type_ of
            --                 Type.Scalar name ->
            --                     -- Err [ todo "Handle more object types!" ]
            --                     Ok 
            --                         (Can.FieldScalar
            --                             { alias_ = Maybe.map convertName field.alias_
            --                             , name = convertName field.name
            --                             , arguments = []
            --                             , directives = []
            --                             , type_ = matched.type_
            --                             }
            --                         )

            --                 Type.InputObject name ->
            --                     Err [ todo "Invalid schema!  Weird InputObject" ]

            --                 Type.Object name ->
            --                     case Dict.get name schema.objects of
            --                         Nothing ->
            --                             Err [ error (ObjectUnknown name) ]

            --                         Just obj ->
            --                             let
            --                             --     args = reduce (validateArg queryObj) field.arguments (Ok [])
                                            
            --                                 fields = reduce (canonicalizeField schema obj) field.selection (Ok [])
            --                             in
            --                             Err [ todo "Handle more object types!" ]

            --                 Type.Enum name ->
            --                     Err [ todo "Handle more object types!" ]

            --                 Type.Union name ->
            --                     Err [ todo "Handle more object types!" ]

            --                 Type.Interface name ->
            --                     Err [ todo "Handle more object types!" ]

            --                 Type.List_ inner ->
            --                     Err [ todo "Handle more object types!" ]

            --                 Type.Nullable inner ->
            --                     Err [ todo "Handle more object types!" ]
                                        

            --         Nothing ->
            --             Err [ error (FieldUnknown { object = object.name, field = fieldName} ) ]
            Err [ todo "Fragments in objects aren't suported yet!" ]

        AST.FragmentSpreadSelection frag ->
            Err [ todo "Fragments in objects aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            Err [ todo "Inline fragments are not allowed" ]
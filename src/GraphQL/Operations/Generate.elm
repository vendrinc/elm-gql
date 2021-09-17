module GraphQL.Operations.Generate exposing (generate)

{-| Generate elm code from an Operations.AST
-}

import Dict
import Elm
import Elm.Annotation as Type
import Generate.Args
import Generate.Example
import Generate.Input as Input
import GraphQL.Operations.AST as AST
import GraphQL.Operations.Validate as Validate
import GraphQL.Schema
import GraphQL.Schema.Type as SchemaType
import Set


generate : GraphQL.Schema.Schema -> AST.Document -> List String -> Result (List Validate.Error) (List Elm.File)
generate schema document path =
    case Validate.validate schema document of
        Err validationError ->
            Err validationError

        Ok validated ->
            Ok
                [ Elm.file path
                    [ Elm.fn "query"
                        ( "input"
                        , Type.record
                            (List.concatMap (getVariables schema) validated.definitions)
                        )
                        (\var ->
                            Elm.string "Placeholder"
                        )
                        |> Elm.expose
                    ]
                ]


getVariables : GraphQL.Schema.Schema -> AST.Definition -> List ( String, Type.Annotation )
getVariables schema def =
    case def of
        AST.Fragment frag ->
            []

        AST.Operation op ->
            List.map (toVariableAnnotation schema) op.variableDefinitions


toVariableAnnotation : GraphQL.Schema.Schema -> AST.VariableDefinition -> ( String, Type.Annotation )
toVariableAnnotation schema var =
    ( AST.nameToString var.variable.name
    , toElmType schema var.type_
    )


toElmType : GraphQL.Schema.Schema -> AST.Type -> Type.Annotation
toElmType schema astType =
    case astType of
        AST.Type_ name ->
            Type.string

        AST.List_ inner ->
            Type.list (toElmTypeHelper schema inner)

        AST.Nullable inner ->
            toElmTypeHelper schema inner


toElmTypeHelper : GraphQL.Schema.Schema -> AST.Type -> Type.Annotation
toElmTypeHelper schema astType =
    case astType of
        AST.Type_ name ->
            let
                typename =
                    AST.nameToString name
            in
            if isPrimitive schema typename then
                Type.named (Elm.moduleName []) typename

            else
                case Dict.get typename schema.inputObjects of
                    Nothing ->
                        -- this should never happen because this is validated...
                        Type.named (Elm.moduleName []) typename

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
                                Type.named (Elm.moduleName []) typename

        AST.List_ inner ->
            Type.list (toElmTypeHelper schema inner)

        AST.Nullable inner ->
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

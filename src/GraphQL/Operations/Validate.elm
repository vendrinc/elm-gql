module GraphQL.Operations.Validate exposing (Error, errorToString, validate)

import Dict
import GraphQL.Operations.AST as AST
import GraphQL.Schema


type Error
    = Invalid
    | Todo String
    | UnknownQuery String
    | UnknownField String
    | UnknownFragment String
    | InlineFragmentsAreNotAllowed String
    | UnknownArgName String


errorToString : Error -> String
errorToString err =
    case err of
        Invalid ->
            "Invalid"

        Todo str ->
            "Todo: " ++ str

        UnknownQuery name ->
            "Unknown query: " ++ name

        UnknownField name ->
            "Unknown field: " ++ name

        UnknownFragment name ->
            "Unknown fragment: " ++ name

        InlineFragmentsAreNotAllowed msg ->
            "Inline fragments are not allowed in " ++ msg

        UnknownArgName name ->
            "Unknown arg name: " ++ name


validate : GraphQL.Schema.Schema -> AST.Document -> Result (List Error) AST.Document
validate schema doc =
    case reduce (validateDefinition schema) doc.definitions (Ok ()) of
        Ok _ ->
            Ok doc

        Err err ->
            Err err


reduce : (item -> Result (List Error) ()) -> List item -> Result (List Error) () -> Result (List Error) ()
reduce isValid items res =
    case items of
        [] ->
            res

        top :: remain ->
            case isValid top of
                Ok _ ->
                    reduce isValid remain res

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


validateDefinition : GraphQL.Schema.Schema -> AST.Definition -> Result (List Error) ()
validateDefinition schema def =
    case def of
        AST.Fragment details ->
            Err [ Todo "Top level fragments are not supported yet!" ]

        AST.Operation details ->
            case details.operationType of
                AST.Query ->
                    reduce (validateQuery schema) details.fields (Ok ())

                AST.Mutation ->
                    reduce (validateMutation schema) details.fields (Ok ())


validateQuery : GraphQL.Schema.Schema -> AST.Selection -> Result (List Error) ()
validateQuery schema selection =
    case selection of
        AST.Field field ->
            case Dict.get (AST.nameToString field.name) schema.queries of
                Nothing ->
                    Err [ UnknownQuery (AST.nameToString field.name) ]

                Just queryObj ->
                    case getName queryObj.type_ of
                        Union unionName ->
                            case Dict.get unionName schema.unions of
                                Nothing ->
                                    Err [ UnknownField unionName ]

                                Just innerUnion ->
                                    reduce (validateUnion schema innerUnion) field.selection (Ok ())

                        Object objName ->
                            case Dict.get objName schema.objects of
                                Nothing ->
                                    Err [ UnknownField objName ]

                                Just obj ->
                                    Ok ()
                                        |> reduce (validateArg queryObj) field.arguments
                                        |> reduce (validateField schema obj) field.selection

                        Leaf ->
                            Ok ()

        AST.FragmentSpreadSelection frag ->
            Err [ Todo "Fragments in unions aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            Err [ InlineFragmentsAreNotAllowed "queries" ]


validateArg : { node | arguments : List GraphQL.Schema.Argument } -> AST.Argument -> Result (List Error) ()
validateArg { arguments } arg =
    case arg.value of
        AST.Var var ->
            let
                varname =
                    AST.nameToString arg.name
            in
            if List.any (\a -> a.name == varname) arguments then
                Ok ()

            else
                Err [ UnknownArgName varname ]

        _ ->
            Err [ Todo "All inputs must be variables for now.  No inline values." ]


validateMutation : GraphQL.Schema.Schema -> AST.Selection -> Result (List Error) ()
validateMutation schema selection =
    case selection of
        AST.Field field ->
            case Dict.get (AST.nameToString field.name) schema.mutations of
                Nothing ->
                    Err [ UnknownQuery (AST.nameToString field.name) ]

                Just mutationObj ->
                    case getName mutationObj.type_ of
                        Union unionName ->
                            case Dict.get unionName schema.unions of
                                Nothing ->
                                    Err [ UnknownField unionName ]

                                Just innerUnion ->
                                    reduce (validateUnion schema innerUnion) field.selection (Ok ())

                        Object objName ->
                            case Dict.get objName schema.objects of
                                Nothing ->
                                    Err [ UnknownField objName ]

                                Just obj ->
                                    Ok ()
                                        |> reduce (validateArg mutationObj) field.arguments
                                        |> reduce (validateField schema obj) field.selection

                        Leaf ->
                            Ok ()

        AST.FragmentSpreadSelection frag ->
            Err [ Todo "Fragments in unions aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            Err [ InlineFragmentsAreNotAllowed "mutations" ]


validateUnion : GraphQL.Schema.Schema -> GraphQL.Schema.UnionDetails -> AST.Selection -> Result (List Error) ()
validateUnion schema union selection =
    case selection of
        AST.Field field ->
            let
                fieldName =
                    AST.nameToString field.name
            in
            if fieldName == "__typename" then
                Ok ()

            else
                Err [ Todo "Selecting common fields in unions isn't quite supported yet!  Except __typename" ]

        AST.FragmentSpreadSelection frag ->
            Err [ Todo "Fragments in unions aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            let
                tag =
                    AST.nameToString inline.tag
            in
            if List.any (matchObjectName tag) union.variants then
                case Dict.get tag schema.objects of
                    Nothing ->
                        Err [ UnknownField tag ]

                    Just obj ->
                        reduce (validateField schema obj) inline.selection (Ok ())

            else
                Err [ UnknownFragment tag ]


matchObjectName : String -> GraphQL.Schema.Variant -> Bool
matchObjectName tag var =
    case var.kind of
        GraphQL.Schema.ObjectKind name ->
            name == tag

        GraphQL.Schema.ScalarKind name ->
            False

        GraphQL.Schema.InputObjectKind name ->
            False

        GraphQL.Schema.EnumKind name ->
            False

        GraphQL.Schema.UnionKind name ->
            False

        GraphQL.Schema.InterfaceKind name ->
            False


validateField : GraphQL.Schema.Schema -> GraphQL.Schema.ObjectDetails -> AST.Selection -> Result (List Error) ()
validateField schema object selection =
    case selection of
        AST.Field field ->
            let
                fieldName =
                    AST.nameToString field.name
            in
            if fieldName == "__typename" then
                Ok ()

            else
                let
                    matchedField =
                        object.fields
                            |> List.filter (\fld -> fld.name == fieldName)
                            |> List.head
                in
                case matchedField of
                    Just matched ->
                        let
                            argResult =
                                reduce (validateArg matched) field.arguments (Ok ())
                        in
                        case getName matched.type_ of
                            Leaf ->
                                argResult

                            Union unionName ->
                                case Dict.get unionName schema.unions of
                                    Nothing ->
                                        Err [ UnknownField unionName ]

                                    Just innerUnion ->
                                        argResult
                                            |> reduce (validateUnion schema innerUnion) field.selection

                            Object objName ->
                                case Dict.get objName schema.objects of
                                    Nothing ->
                                        Err [ UnknownField objName ]

                                    Just innerobj ->
                                        argResult
                                            |> reduce (validateField schema innerobj) field.selection

                    Nothing ->
                        Err [ UnknownField fieldName ]

        AST.FragmentSpreadSelection frag ->
            Err [ Todo "Fragments in objects aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            Err [ InlineFragmentsAreNotAllowed "objects" ]


type NamedThing
    = Leaf
    | Object String
    | Union String


getName : GraphQL.Schema.Type -> NamedThing
getName kind =
    case kind of
        GraphQL.Schema.Scalar name ->
            Leaf

        GraphQL.Schema.InputObject name ->
            Leaf

        GraphQL.Schema.Object name ->
            Object name

        GraphQL.Schema.Enum name ->
            Leaf

        GraphQL.Schema.Union name ->
            Union name

        GraphQL.Schema.Interface name ->
            Leaf

        GraphQL.Schema.List_ inner ->
            getName inner

        GraphQL.Schema.Nullable inner ->
            getName inner

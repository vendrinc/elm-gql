module GraphQL.Operations.CanonicalAST exposing (..)

import GraphQL.Operations.AST as AST
import GraphQL.Schema


type alias Document =
    { definitions : List Definition
    }


type Definition
    = Operation OperationDetails


type alias OperationDetails =
    { operationType : OperationType
    , name : Maybe Name
    , variableDefinitions : List VariableDefinition
    , directives : List Directive
    , fields : List Selection
    }


type OperationType
    = Query
    | Mutation


type alias Directive =
    { name : Name
    , arguments : List Argument
    }


type alias Argument =
    AST.Argument


type alias VariableDefinition =
    { variable : Variable
    , type_ : AST.Type
    , defaultValue : Maybe AST.Value
    , schemaType : GraphQL.Schema.Type
    }


type alias Variable =
    { name : Name
    }


type Selection
    = FieldObject FieldObjectDetails
    | FieldUnion FieldUnionDetails
    | FieldScalar FieldScalarDetails
    | FieldEnum FieldEnumDetails
    | FieldInterface FieldInterfaceDetails


isTypeNameSelection : Selection -> Bool
isTypeNameSelection sel =
    case sel of
        FieldScalar scal ->
            nameToString scal.name == "__typename"

        _ ->
            False


type alias FieldDetails =
    { alias_ : Maybe Name
    , name : Name
    , arguments : List Argument
    , directives : List Directive
    , selection : List Selection
    }


{-|

    - name        -> the field name in the schema
    - alias_      -> the alias provided in the query
    - globalAlias ->
            The name that's guaranteed to be unique for the query.
            This is used to generate record types for the results of an operation.

-}
type alias FieldObjectDetails =
    { alias_ : Maybe Name
    , name : Name
    , globalAlias : Name
    , arguments : List Argument
    , directives : List Directive
    , selection : List Selection
    , object : GraphQL.Schema.ObjectDetails
    , wrapper : GraphQL.Schema.Wrapped
    }


type alias FieldUnionDetails =
    { alias_ : Maybe Name
    , name : Name
    , globalAlias : Name
    , arguments : List Argument
    , directives : List Directive
    , selection : List Selection
    , variants : List UnionCaseDetails
    , remainingTags :
        List
            { tag : Name
            , globalAlias : Name
            }
    , union : GraphQL.Schema.UnionDetails
    , wrapper : GraphQL.Schema.Wrapped
    }


type alias FieldInterfaceDetails =
    { alias_ : Maybe Name
    , name : Name
    , globalAlias : Name
    , arguments : List Argument
    , directives : List Directive
    , selection : List Selection
    , variants : List InterfaceCase
    , remainingTags :
        List
            { tag : Name
            , globalAlias : Name
            }
    , interface : GraphQL.Schema.InterfaceDetails
    , wrapper : GraphQL.Schema.Wrapped
    }


type alias InterfaceCase =
    { tag : Name
    , globalAlias : Name
    , directives : List Directive
    , selection : List Selection
    }


type alias FieldScalarDetails =
    { alias_ : Maybe Name
    , name : Name
    , arguments : List Argument
    , directives : List Directive
    , type_ : GraphQL.Schema.Type
    }


type alias FieldEnumDetails =
    { alias_ : Maybe Name
    , name : Name
    , arguments : List Argument
    , directives : List Directive
    , enumName : String
    , values : List { name : String, description : Maybe String }
    , wrapper : GraphQL.Schema.Wrapped
    }


type alias UnionCaseDetails =
    { tag : Name
    , globalAlias : Name
    , directives : List Directive
    , selection : List Selection
    }


type Name
    = Name String


getAliasedName : Selection -> String
getAliasedName sel =
    case sel of
        FieldObject details ->
            nameToString (Maybe.withDefault details.name details.alias_)

        FieldUnion details ->
            nameToString (Maybe.withDefault details.name details.alias_)

        FieldScalar details ->
            nameToString (Maybe.withDefault details.name details.alias_)

        FieldEnum details ->
            nameToString (Maybe.withDefault details.name details.alias_)

        FieldInterface details ->
            nameToString (Maybe.withDefault details.name details.alias_)


getAliasedFieldName :
    { field
        | alias_ : Maybe Name
        , name : Name
    }
    -> String
getAliasedFieldName details =
    nameToString (Maybe.withDefault details.name details.alias_)


nameToString : Name -> String
nameToString (Name str) =
    str



{- To String -}


{-| -}
toString : Definition -> String
toString (Operation def) =
    let
        opName =
            case def.name of
                Nothing ->
                    ""

                Just (Name str) ->
                    str

        variableDefinitions =
            case def.variableDefinitions of
                [] ->
                    ""

                vars ->
                    let
                        renderedVars =
                            foldToString ", "
                                (\var ->
                                    "$"
                                        ++ nameToString var.variable.name
                                        ++ ": "
                                        ++ typeToString (getWrapper var.type_ (Val { required = True })) var.type_
                                )
                                vars
                    in
                    "(" ++ renderedVars ++ ")"
    in
    operationName def.operationType
        ++ " "
        ++ opName
        ++ variableDefinitions
        ++ " "
        ++ brackets
            (foldToString "\n" selectionToString def.fields)


{-| Only render the fields of the query, but with no outer brackets
-}
operationLabel : Definition -> Maybe String
operationLabel (Operation def) =
    case def.name of
        Nothing ->
            Nothing

        Just (Name str) ->
            Just str


{-| Only render the fields of the query, but with no outer brackets
-}
toStringFields : Definition -> String
toStringFields (Operation def) =
    let
        opName =
            case def.name of
                Nothing ->
                    ""

                Just (Name str) ->
                    str

        variableDefinitions =
            case def.variableDefinitions of
                [] ->
                    ""

                vars ->
                    let
                        renderedVars =
                            foldToString ", "
                                (\var ->
                                    "$"
                                        ++ nameToString var.variable.name
                                        ++ ": "
                                        ++ typeToString (getWrapper var.type_ (Val { required = True })) var.type_
                                )
                                vars
                    in
                    "(" ++ renderedVars ++ ")"
    in
    foldToString "\n" selectionToString def.fields


selectionToString : Selection -> String
selectionToString sel =
    case sel of
        FieldObject details ->
            aliasedName details
                ++ renderArguments details.arguments
                ++ renderSelection details.selection

        FieldUnion details ->
            aliasedName details
                ++ renderArguments details.arguments
                ++ " "
                ++ brackets
                    (foldToString "\n" selectionToString details.selection
                        ++ (if not (List.isEmpty details.selection && List.isEmpty details.variants) then
                                "\n"

                            else
                                ""
                           )
                        ++ foldToString "\n" variantFragmentToString details.variants
                    )

        FieldScalar details ->
            aliasedName details ++ renderArguments details.arguments

        FieldEnum details ->
            aliasedName details ++ renderArguments details.arguments

        FieldInterface details ->
            aliasedName details
                ++ renderArguments details.arguments
                ++ " "
                ++ brackets
                    (foldToString "\n" selectionToString details.selection
                        ++ (if not (List.isEmpty details.selection && List.isEmpty details.variants) then
                                "\n"

                            else
                                ""
                           )
                        ++ foldToString "\n" variantFragmentToString details.variants
                    )


variantFragmentToString : UnionCaseDetails -> String
variantFragmentToString instance =
    "... on "
        ++ nameToString instance.tag
        ++ " "
        ++ brackets (foldToString "\n" selectionToString instance.selection)


renderSelection : List Selection -> String
renderSelection selection =
    case selection of
        [] ->
            ""

        _ ->
            " "
                ++ brackets (foldToString "\n" selectionToString selection)


renderArguments : List Argument -> String
renderArguments args =
    case args of
        [] ->
            ""

        _ ->
            "("
                ++ foldToString "\n" argToString args
                ++ ")"


argToString : Argument -> String
argToString arg =
    AST.nameToString arg.name ++ ": " ++ argValToString arg.value


argValToString : AST.Value -> String
argValToString val =
    case val of
        AST.Str str ->
            "\"" ++ str ++ "\""

        AST.Integer int ->
            String.fromInt int

        AST.Decimal dec ->
            String.fromFloat dec

        AST.Boolean True ->
            "true"

        AST.Boolean False ->
            "false"

        AST.Null ->
            "null"

        AST.Enum (AST.Name str) ->
            str

        AST.Var var ->
            "$" ++ AST.nameToString var.name

        AST.Object keyVals ->
            brackets
                (foldToString ", "
                    (\( key, innerVal ) ->
                        AST.nameToString key ++ ": " ++ argValToString innerVal
                    )
                    keyVals
                )

        AST.ListValue vals ->
            "["
                ++ foldToString ", " argValToString vals
                ++ "]"


aliasedName : { a | alias_ : Maybe Name, name : Name } -> String
aliasedName details =
    case details.alias_ of
        Nothing ->
            nameToString details.name

        Just alias_ ->
            nameToString alias_ ++ ": " ++ nameToString details.name


foldToString : String -> (a -> String) -> List a -> String
foldToString delimiter fn vals =
    List.foldl
        (\var rendered ->
            let
                val =
                    fn var
            in
            case rendered of
                "" ->
                    val

                _ ->
                    val ++ delimiter ++ rendered
        )
        ""
        vals


operationName : OperationType -> String
operationName opType =
    case opType of
        Query ->
            "query"

        Mutation ->
            "mutation"


brackets : String -> String
brackets str =
    "{" ++ str ++ "}"


type Wrapper
    = InList { required : Bool } Wrapper
    | Val { required : Bool }


{-|

    Type ->
        Required Val

    Nullable Type ->
        Val

-}
getWrapper : AST.Type -> Wrapper -> Wrapper
getWrapper t wrap =
    case t of
        AST.Type_ _ ->
            wrap

        AST.List_ inner ->
            getWrapper inner (InList { required = True } wrap)

        AST.Nullable inner ->
            case wrap of
                Val { required } ->
                    getWrapper inner (Val { required = False })

                InList { required } wrapper ->
                    getWrapper inner (InList { required = False } wrapper)


typeToString : Wrapper -> AST.Type -> String
typeToString wrapper t =
    case t of
        AST.Type_ (AST.Name str) ->
            unwrap wrapper str

        AST.List_ inner ->
            typeToString wrapper inner

        AST.Nullable inner ->
            typeToString wrapper inner


unwrap : Wrapper -> String -> String
unwrap wrapper str =
    case wrapper of
        Val { required } ->
            if required then
                str ++ "!"

            else
                str

        InList { required } inner ->
            if required then
                unwrap inner ("[" ++ str ++ "!]")

            else
                unwrap inner ("[" ++ str ++ "]")

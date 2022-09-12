module GraphQL.Operations.CanonicalAST exposing (..)

import Elm
import Elm.Annotation as Type
import Gen.GraphQL.Operations.AST as GenAST
import Gen.GraphQL.Operations.CanonicalAST as GenCan
import Gen.GraphQL.Schema as GenSchema
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


toExpression : Definition -> Elm.Expression
toExpression (Operation op) =
    GenCan.make_.operation
        (GenCan.make_.operationDetails
            { operationType = opTypeToExp op.operationType
            , name =
                case op.name of
                    Nothing ->
                        Elm.nothing

                    Just name ->
                        Elm.just (nameToExp name)
            , variableDefinitions = Elm.list (List.map varDefToExp op.variableDefinitions)
            , directives = Elm.list (List.map directiveToExp op.directives)
            , fields =
                Elm.list (List.map fieldToExp op.fields)
            }
        )
        |> Elm.withType GenCan.annotation_.definition


directiveToExp : Directive -> Elm.Expression
directiveToExp dir =
    GenCan.make_.directive
        { name = nameToExp dir.name
        , arguments =
            Elm.list (List.map argToExp dir.arguments)
        }


argToExp : AST.Argument -> Elm.Expression
argToExp arg =
    GenAST.make_.argument
        { name = astNameToExp arg.name
        , value =
            astValueToExp arg.value
        }


astValueToExp : AST.Value -> Elm.Expression
astValueToExp val =
    case val of
        AST.Str str ->
            GenAST.make_.str (Elm.string str)

        AST.Integer int ->
            GenAST.make_.integer (Elm.int int)

        AST.Decimal float ->
            GenAST.make_.decimal (Elm.float float)

        AST.Boolean bool ->
            GenAST.make_.boolean (Elm.bool bool)

        AST.Null ->
            GenAST.make_.null

        AST.Enum name ->
            GenAST.make_.enum (astNameToExp name)

        AST.Var var ->
            GenAST.make_.var
                (GenAST.make_.variable
                    { name = astNameToExp var.name }
                )

        AST.Object fields ->
            GenAST.make_.object
                (Elm.list
                    (List.map
                        (\( name, fieldVal ) ->
                            Elm.tuple
                                (astNameToExp name)
                                (astValueToExp fieldVal)
                        )
                        fields
                    )
                )

        AST.ListValue vals ->
            GenAST.make_.listValue
                (Elm.list
                    (List.map
                        astValueToExp
                        vals
                    )
                )


astNameToExp : AST.Name -> Elm.Expression
astNameToExp (AST.Name name) =
    GenAST.make_.name (Elm.string name)


opTypeToExp : OperationType -> Elm.Expression
opTypeToExp op =
    case op of
        Query ->
            GenCan.make_.query

        Mutation ->
            GenCan.make_.mutation


nameToExp : Name -> Elm.Expression
nameToExp (Name name) =
    GenCan.make_.name (Elm.string name)


varDefToExp : VariableDefinition -> Elm.Expression
varDefToExp def =
    GenCan.make_.variableDefinition
        { variable = varToExp def.variable
        , type_ = typeToExp def.type_
        , defaultValue =
            case def.defaultValue of
                Nothing ->
                    Elm.nothing

                Just default ->
                    Elm.just (astValueToExp default)
        , schemaType =
            schemaTypeToExp def.schemaType
        }


schemaTypeToExp : GraphQL.Schema.Type -> Elm.Expression
schemaTypeToExp schemaType =
    case schemaType of
        GraphQL.Schema.Scalar scalar ->
            GenSchema.make_.scalar (Elm.string scalar)

        GraphQL.Schema.InputObject inputObj ->
            GenSchema.make_.inputObject (Elm.string inputObj)

        GraphQL.Schema.Object obj ->
            GenSchema.make_.object (Elm.string obj)

        GraphQL.Schema.Enum enum ->
            GenSchema.make_.enum (Elm.string enum)

        GraphQL.Schema.Union union ->
            GenSchema.make_.union (Elm.string union)

        GraphQL.Schema.Interface interface ->
            GenSchema.make_.interface (Elm.string interface)

        GraphQL.Schema.List_ inner ->
            GenSchema.make_.list_ (schemaTypeToExp inner)

        GraphQL.Schema.Nullable inner ->
            GenSchema.make_.scalar (schemaTypeToExp inner)


varToExp : Variable -> Elm.Expression
varToExp var =
    GenCan.make_.variable
        { name = nameToExp var.name }


typeToExp : AST.Type -> Elm.Expression
typeToExp type_ =
    case type_ of
        AST.Type_ name ->
            GenAST.make_.type_
                (astNameToExp name)

        AST.List_ inner ->
            GenAST.make_.list_
                (typeToExp inner)

        AST.Nullable inner ->
            GenAST.make_.nullable
                (typeToExp inner)


maybeExp : (a -> Elm.Expression) -> Maybe a -> Elm.Expression
maybeExp toExp maybeVal =
    case maybeVal of
        Nothing ->
            Elm.nothing

        Just val ->
            Elm.just (toExp val)


schemaWrapperToExp : GraphQL.Schema.Wrapped -> Elm.Expression
schemaWrapperToExp wrapped =
    case wrapped of
        GraphQL.Schema.UnwrappedValue ->
            GenSchema.make_.unwrappedValue

        GraphQL.Schema.InList inner ->
            GenSchema.make_.inList (schemaWrapperToExp inner)

        GraphQL.Schema.InMaybe inner ->
            GenSchema.make_.inMaybe (schemaWrapperToExp inner)


fieldToExp : Selection -> Elm.Expression
fieldToExp sel =
    case sel of
        FieldObject details ->
            GenCan.make_.fieldObject
                (GenCan.make_.fieldObjectDetails
                    { alias_ = maybeExp nameToExp details.alias_
                    , name = nameToExp details.name
                    , globalAlias = nameToExp details.globalAlias
                    , arguments = Elm.list (List.map argToExp details.arguments)
                    , directives = Elm.list (List.map directiveToExp details.directives)
                    , selection = Elm.list (List.map fieldToExp details.selection)
                    , wrapper = schemaWrapperToExp details.wrapper
                    }
                )

        FieldUnion details ->
            GenCan.make_.fieldUnion
                (GenCan.make_.fieldUnionDetails
                    { alias_ = maybeExp nameToExp details.alias_
                    , name = nameToExp details.name
                    , globalAlias = nameToExp details.globalAlias
                    , arguments = Elm.list (List.map argToExp details.arguments)
                    , directives = Elm.list (List.map directiveToExp details.directives)
                    , selection = Elm.list (List.map fieldToExp details.selection)
                    , wrapper = schemaWrapperToExp details.wrapper
                    , variants = Elm.list (List.map unionVariantToExp details.variants)
                    , remainingTags = Elm.list (List.map remainingTagsToExp details.remainingTags)
                    }
                )

        FieldScalar details ->
            GenCan.make_.fieldScalar
                (GenCan.make_.fieldScalarDetails
                    { alias_ = maybeExp nameToExp details.alias_
                    , name = nameToExp details.name
                    , arguments = Elm.list (List.map argToExp details.arguments)
                    , directives = Elm.list (List.map directiveToExp details.directives)
                    , type_ =
                        schemaTypeToExp details.type_
                    }
                )

        FieldEnum details ->
            GenCan.make_.fieldEnum
                (GenCan.make_.fieldEnumDetails
                    { alias_ = maybeExp nameToExp details.alias_
                    , name = nameToExp details.name
                    , arguments = Elm.list (List.map argToExp details.arguments)
                    , directives = Elm.list (List.map directiveToExp details.directives)
                    , enumName = Elm.string details.enumName
                    , values = Elm.list (List.map enumValueToExp details.values)
                    , wrapper = schemaWrapperToExp details.wrapper
                    }
                )

        FieldInterface details ->
            GenCan.make_.fieldUnion
                (GenCan.make_.fieldUnionDetails
                    { alias_ = maybeExp nameToExp details.alias_
                    , name = nameToExp details.name
                    , globalAlias = nameToExp details.globalAlias
                    , arguments = Elm.list (List.map argToExp details.arguments)
                    , directives = Elm.list (List.map directiveToExp details.directives)
                    , selection = Elm.list (List.map fieldToExp details.selection)
                    , wrapper = schemaWrapperToExp details.wrapper
                    , variants = Elm.list (List.map interfaceCaseToExp details.variants)
                    , remainingTags = Elm.list (List.map remainingTagsToExp details.remainingTags)
                    }
                )


enumValueToExp : { name : String, description : Maybe String } -> Elm.Expression
enumValueToExp names =
    Elm.record
        [ ( "name", Elm.string names.name )
        , ( "description", maybeExp Elm.string names.description )
        ]


remainingTagsToExp :
    { tag : Name
    , globalAlias : Name
    }
    -> Elm.Expression
remainingTagsToExp remain =
    Elm.record
        [ ( "tag", nameToExp remain.tag )
        , ( "globalAlias", nameToExp remain.globalAlias )
        ]


unionVariantToExp : UnionCaseDetails -> Elm.Expression
unionVariantToExp union =
    GenCan.make_.unionCaseDetails
        { tag = nameToExp union.tag
        , globalAlias = nameToExp union.globalAlias
        , directives = Elm.list (List.map directiveToExp union.directives)
        , selection = Elm.list (List.map fieldToExp union.selection)
        }


interfaceCaseToExp : InterfaceCase -> Elm.Expression
interfaceCaseToExp interface =
    GenCan.make_.interfaceCase
        { tag = nameToExp interface.tag
        , globalAlias = nameToExp interface.globalAlias
        , directives = Elm.list (List.map directiveToExp interface.directives)
        , selection = Elm.list (List.map fieldToExp interface.selection)
        }

module GraphQL.Operations.CanonicalAST exposing (..)

import Elm
import Elm.Annotation as Type
import Elm.Op
import Gen.GraphQL.Engine as Engine
import Gen.GraphQL.Operations.AST as GenAST
import Gen.GraphQL.Operations.CanonicalAST as GenCan
import Gen.GraphQL.Schema as GenSchema
import Gen.String
import GraphQL.Operations.AST as AST
import GraphQL.Schema


type alias Document =
    { definitions : List Definition
    , fragments : List Fragment
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


type alias Fragment =
    { name : Name
    , typeCondition : Name
    , directives : List Directive
    , selection : List Selection
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
    | FieldFragment FragmentDetails


type alias FragmentDetails =
    { fragment : Fragment
    , directives : List Directive
    }


isTypeNameSelection : Selection -> Bool
isTypeNameSelection sel =
    case sel of
        FieldScalar scal ->
            nameToString scal.name == "__typename"

        _ ->
            False


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
    , globalTagName : Name
    , globalDetailsAlias : Name
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
    , globalTagName : Name
    , globalDetailsAlias : Name
    , directives : List Directive
    , selection : List Selection
    }


type Name
    = Name String


getAliasedName : { details | name : Name, alias_ : Maybe Name } -> String
getAliasedName details =
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

        FieldFragment { fragment } ->
            "..." ++ nameToString fragment.name


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



{- TO RENDERER -}


{-| We want to render a string of this, but with a `version`

The version is an Int, which represents if there are other queries batched with it.

-}
toRendererExpression : Elm.Expression -> Definition -> Elm.Expression
toRendererExpression version (Operation def) =
    initCursor version
        |> renderFields def.fields
        |> commit
        |> (\cursor ->
                Maybe.withDefault (Elm.string "") cursor.exp
           )


renderFields fields cursor =
    List.foldr
        (\sel ( afterFirst, c ) ->
            ( True
            , c
                |> addString
                    (if afterFirst then
                        "\n"

                     else
                        ""
                    )
                |> selectionToExpressionString sel
            )
        )
        ( False, cursor )
        fields
        |> Tuple.second


initCursor : Elm.Expression -> RenderingCursor
initCursor version =
    { string = ""
    , exp = Nothing
    , depth = 0
    , version = version
    }


type alias RenderingCursor =
    { string : String
    , exp : Maybe Elm.Expression
    , depth : Int
    , version : Elm.Expression
    }


addLevelToCursor : RenderingCursor -> RenderingCursor
addLevelToCursor cursor =
    { cursor | depth = cursor.depth + 1 }


removeLevelToCursor : RenderingCursor -> RenderingCursor
removeLevelToCursor cursor =
    { cursor | depth = cursor.depth - 1 }


commit : RenderingCursor -> RenderingCursor
commit cursor =
    case cursor.string of
        "" ->
            cursor

        _ ->
            { cursor
                | string = ""
                , exp =
                    case cursor.exp of
                        Nothing ->
                            Just (Elm.string cursor.string)

                        Just existing ->
                            Just
                                (Elm.Op.append existing (Elm.string cursor.string))

                -- (Gen.String.call_.append existing (Elm.string cursor.string))
                -- (Elm.string cursor.string
                --     |> Elm.Op.pipe
                --         (Elm.apply Gen.String.values_.append [ existing ])
                -- )
            }


addString : String -> RenderingCursor -> RenderingCursor
addString str cursor =
    case str of
        "" ->
            cursor

        _ ->
            { cursor | string = cursor.string ++ str }


addExp : Elm.Expression -> RenderingCursor -> RenderingCursor
addExp new cursor =
    let
        committed =
            commit cursor
    in
    { committed
        | exp =
            case committed.exp of
                Nothing ->
                    Just new

                Just existing ->
                    Just
                        (Elm.Op.append existing new)
    }


selectionToExpressionString : Selection -> RenderingCursor -> RenderingCursor
selectionToExpressionString sel cursor =
    case sel of
        FieldObject details ->
            cursor
                |> aliasedNameExp details
                |> renderArgumentsExp details.arguments
                |> renderSelectionExp details.selection

        FieldUnion details ->
            cursor
                |> aliasedNameExp details
                |> renderArgumentsExp details.arguments
                |> addString " {"
                |> addLevelToCursor
                |> renderFields details.selection
                |> removeLevelToCursor
                |> addString
                    (if not (List.isEmpty details.selection && List.isEmpty details.variants) then
                        "\n"

                     else
                        ""
                    )
                |> addLevelToCursor
                |> (\currentCursor ->
                        List.foldr renderVariantFragmentToExp currentCursor details.variants
                   )
                |> removeLevelToCursor
                |> addString " }"

        FieldScalar details ->
            cursor
                |> aliasedNameExp details
                |> renderArgumentsExp details.arguments

        FieldEnum details ->
            cursor
                |> aliasedNameExp details
                |> renderArgumentsExp details.arguments

        FieldInterface details ->
            cursor
                |> aliasedNameExp details
                |> renderArgumentsExp details.arguments
                |> addString " {"
                |> renderFields details.selection
                |> addString
                    (if not (List.isEmpty details.selection && List.isEmpty details.variants) then
                        "\n"

                     else
                        ""
                    )
                |> (\currentCursor ->
                        List.foldr renderVariantFragmentToExp currentCursor details.variants
                   )
                |> addString " }"

        FieldFragment { fragment } ->
            cursor
                |> addString ("\n..." ++ nameToString fragment.name)


aliasedNameExp : { a | alias_ : Maybe Name, name : Name } -> RenderingCursor -> RenderingCursor
aliasedNameExp details cursor =
    if cursor.depth == 0 then
        case details.alias_ of
            Nothing ->
                cursor
                    |> addExp
                        (Engine.call_.versionedAlias
                            cursor.version
                            (Elm.string (nameToString details.name))
                        )

            Just alias_ ->
                cursor
                    |> addExp
                        (Engine.call_.versionedName
                            cursor.version
                            (Elm.string (nameToString alias_))
                        )
                    |> addString (": " ++ nameToString details.name)

    else
        case details.alias_ of
            Nothing ->
                cursor
                    |> addString (nameToString details.name)

            Just alias_ ->
                cursor
                    |> addString
                        (nameToString alias_ ++ ": " ++ nameToString details.name)


renderArgumentsExp : List Argument -> RenderingCursor -> RenderingCursor
renderArgumentsExp args cursor =
    case args of
        [] ->
            cursor

        _ ->
            List.foldr
                (\arg ( afterFirst, curs ) ->
                    ( True
                    , curs
                        |> addString
                            (if afterFirst then
                                ", "

                             else
                                ""
                            )
                        |> addString (AST.nameToString arg.name ++ ": ")
                        |> addArgValue arg.value
                    )
                )
                ( False
                , cursor
                    |> addString " ("
                )
                args
                |> Tuple.second
                |> addString ")"


addArgValue : AST.Value -> RenderingCursor -> RenderingCursor
addArgValue val cursor =
    case val of
        AST.Str str ->
            cursor
                |> addString ("\"" ++ str ++ "\"")

        AST.Integer int ->
            cursor
                |> addString (String.fromInt int)

        AST.Decimal dec ->
            cursor
                |> addString
                    (String.fromFloat dec)

        AST.Boolean True ->
            cursor
                |> addString "true"

        AST.Boolean False ->
            cursor
                |> addString "false"

        AST.Null ->
            cursor
                |> addString "null"

        AST.Enum (AST.Name str) ->
            cursor
                |> addString str

        AST.Var var ->
            cursor
                |> addExp
                    (Engine.call_.versionedName
                        cursor.version
                        (Elm.string ("$" ++ AST.nameToString var.name))
                    )

        AST.Object keyVals ->
            List.foldr
                (\( key, innerVal ) ( afterFirst, curs ) ->
                    ( True
                    , curs
                        |> addString
                            (if afterFirst then
                                ", "

                             else
                                ""
                            )
                        |> addString (AST.nameToString key ++ ": ")
                        |> addArgValue innerVal
                    )
                )
                ( False
                , cursor
                    |> addString "{"
                )
                keyVals
                |> Tuple.second
                |> addString "}"

        AST.ListValue vals ->
            List.foldr
                (\innerVal ( afterFirst, curs ) ->
                    ( True
                    , curs
                        |> addString
                            (if afterFirst then
                                ", "

                             else
                                ""
                            )
                        |> addArgValue innerVal
                    )
                )
                ( False
                , cursor
                    |> addString "["
                )
                vals
                |> Tuple.second
                |> addString "]"


renderSelectionExp : List Selection -> RenderingCursor -> RenderingCursor
renderSelectionExp selection cursor =
    cursor
        |> addString " {"
        |> addLevelToCursor
        |> renderFields selection
        |> removeLevelToCursor
        |> addString "}"


renderVariantFragmentToExp : UnionCaseDetails -> RenderingCursor -> RenderingCursor
renderVariantFragmentToExp instance cursor =
    cursor
        |> addString ("\n... on " ++ nameToString instance.tag ++ " {")
        |> addLevelToCursor
        |> renderFields instance.selection
        |> removeLevelToCursor
        |> addString "}"

module GraphQL.Operations.CanonicalAST exposing (Argument, Definition(..), Directive, Document, Field(..), FieldDetails, FieldEnumDetails, FieldVariantDetails, Fragment, FragmentDetails, FragmentSelection(..), Name(..), OperationDetails, OperationType(..), RenderingCursor, Selection(..), Variable, VariableDefinition, VariantCase, Wrapper(..), getAliasedName, isTypeNameSelection, nameToString, operationLabel, toFragmentRendererExpression, toRendererExpression, toString)

import Dict
import Elm
import Elm.Op
import Gen.GraphQL.Engine as Engine
import Gen.String
import GraphQL.Operations.AST as AST
import GraphQL.Schema
import Set


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
    , fields : List Field
    , fragmentsUsed :
        -- NOTE: WE capture alongsideOtherFields in order to inform code generation
        -- If the fragment is selected by itself, then we can generate a record specifically for that fragment
        -- otherwise, we only generate stuff for it's downstream stuff.
        List
            { fragment : Fragment
            , alongsideOtherFields : Bool
            }
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


{-| A selection is a few different pieces

    myAlias: fieldName(args) @directive {
        # selected fields
    }

  - name -> the field name in the schema
  - alias\_ -> the alias provided in the query
  - globalAlias ->
    The name that's guaranteed to be unique for the query.
    This is used to generate record types for the results of an operation.

-}
type Field
    = Field FieldDetails
    | Frag FragmentDetails


type alias FieldDetails =
    { alias_ : Maybe Name
    , name : Name
    , globalAlias : Name
    , selectsOnlyFragment :
        Maybe
            { importFrom : List String
            , name : String
            }
    , arguments : List Argument
    , directives : List Directive
    , wrapper : GraphQL.Schema.Wrapped
    , selection : Selection
    }


type alias FragmentDetails =
    { fragment : Fragment
    , directives : List Directive
    }


type alias Fragment =
    { name : Name
    , importFrom : List String
    , typeCondition : Name
    , usedVariables : List ( String, GraphQL.Schema.Type )
    , fragmentsUsed :
        List Name
    , directives : List Directive
    , selection : FragmentSelection
    }


type FragmentSelection
    = FragmentObject
        { selection : List Field
        }
    | FragmentUnion FieldVariantDetails
    | FragmentInterface FieldVariantDetails


type Selection
    = FieldScalar GraphQL.Schema.Type
    | FieldEnum FieldEnumDetails
    | FieldObject (List Field)
    | FieldUnion FieldVariantDetails
    | FieldInterface FieldVariantDetails


isTypeNameSelection : Field -> Bool
isTypeNameSelection field =
    case field of
        Field details ->
            nameToString details.name == "__typename"

        Frag _ ->
            False


type alias FieldVariantDetails =
    { selection : List Field
    , variants : List VariantCase
    , remainingTags :
        List
            { tag : Name
            , globalAlias : Name
            }
    }


type alias VariantCase =
    { tag : Name
    , globalTagName : Name
    , globalDetailsAlias : Name
    , directives : List Directive
    , selection : List Field
    }


type alias FieldEnumDetails =
    { enumName : String
    , values : List { name : String, description : Maybe String }
    }


type Name
    = Name String


getAliasedName : FieldDetails -> String
getAliasedName details =
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
            (foldToString "\n" fieldToString def.fields)


{-| Only render the fields of the query, but with no outer brackets
-}
operationLabel : Definition -> Maybe String
operationLabel (Operation def) =
    case def.name of
        Nothing ->
            Nothing

        Just (Name str) ->
            Just str


fieldToString : Field -> String
fieldToString field =
    case field of
        Field details ->
            aliasedName details
                ++ renderArguments details.arguments
                ++ selectionToString details.selection

        Frag frag ->
            "..." ++ nameToString frag.fragment.name


selectionToString : Selection -> String
selectionToString selection =
    case selection of
        FieldObject fields ->
            selectionGroupToString fields

        FieldUnion details ->
            brackets
                (foldToString "\n" fieldToString details.selection
                    ++ (if not (List.isEmpty details.selection && List.isEmpty details.variants) then
                            "\n"

                        else
                            ""
                       )
                    ++ foldToString "\n" variantFragmentToString details.variants
                )

        FieldScalar _ ->
            ""

        FieldEnum _ ->
            ""

        FieldInterface details ->
            brackets
                (foldToString "\n" fieldToString details.selection
                    ++ (if not (List.isEmpty details.selection && List.isEmpty details.variants) then
                            "\n"

                        else
                            ""
                       )
                    ++ foldToString "\n" variantFragmentToString details.variants
                )


variantFragmentToString : VariantCase -> String
variantFragmentToString instance =
    "... on "
        ++ nameToString instance.tag
        ++ " "
        ++ brackets (foldToString "\n" fieldToString instance.selection)


selectionGroupToString : List Field -> String
selectionGroupToString selection =
    case selection of
        [] ->
            ""

        _ ->
            " "
                ++ brackets (foldToString "\n" fieldToString selection)


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


aliasedName : FieldDetails -> String
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
                Val _ ->
                    getWrapper inner (Val { required = False })

                InList _ wrapper ->
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


getUsedFragments : Document -> Fragment -> List String
getUsedFragments doc frag =
    let
        subFragNames =
            doc.fragments
                |> List.filter
                    (\subfrag ->
                        List.member subfrag.name frag.fragmentsUsed
                    )
                |> List.concatMap (getUsedFragments doc)
    in
    nameToString frag.name :: subFragNames


toFragmentRendererExpression : Elm.Expression -> Document -> Definition -> Elm.Expression
toFragmentRendererExpression version doc (Operation def) =
    let
        allFrags =
            doc.fragments

        fragmentNamesUsed =
            def.fragmentsUsed
                |> List.concatMap (getUsedFragments doc << .fragment)
                |> Set.fromList

        fragmentsUsed =
            allFrags
                |> List.filter
                    (\frag ->
                        Set.member (nameToString frag.name) fragmentNamesUsed
                    )
    in
    fragmentsUsed
        |> deduplicateFragments
        |> List.map (renderFragment version)
        |> Elm.list
        |> Gen.String.call_.join (Elm.string "\n")


deduplicateFragments : List Fragment -> List Fragment
deduplicateFragments frags =
    frags
        |> List.map
            (\f ->
                ( nameToString f.name
                , f
                )
            )
        |> Dict.fromList
        |> Dict.values


renderFragment : Elm.Expression -> Fragment -> Elm.Expression
renderFragment version frag =
    let
        selection =
            case frag.selection of
                FragmentObject obj ->
                    foldToString "\n" fieldToString obj.selection

                FragmentUnion union ->
                    foldToString "\n" fieldToString union.selection
                        ++ (if not (List.isEmpty union.selection && List.isEmpty union.variants) then
                                "\n"

                            else
                                ""
                           )
                        ++ foldToString "\n" variantFragmentToString union.variants

                FragmentInterface interface ->
                    foldToString "\n" fieldToString interface.selection
                        ++ (if not (List.isEmpty interface.selection && List.isEmpty interface.variants) then
                                "\n"

                            else
                                ""
                           )
                        ++ foldToString "\n" variantFragmentToString interface.variants

        name =
            Engine.call_.versionedName version (Elm.string (nameToString frag.name))

        body =
            Elm.string
                ((" on " ++ nameToString frag.typeCondition)
                    ++ (" {" ++ selection ++ " }")
                )
    in
    Elm.Op.append
        (Elm.Op.append
            (Elm.string "fragment ")
            name
        )
        body


renderFields : List Field -> RenderingCursor -> RenderingCursor
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
                |> renderField sel
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


renderField : Field -> RenderingCursor -> RenderingCursor
renderField field cursor =
    case field of
        Frag frag ->
            cursor
                |> addString "\n..."
                |> addExp
                    (Engine.call_.versionedName
                        cursor.version
                        (Elm.string (nameToString frag.fragment.name))
                    )

        Field details ->
            cursor
                |> aliasedNameExp details
                |> renderArgumentsExp details.arguments
                -- Do we include client side directives?
                -- For now, no.
                |> renderSelection details.selection


renderSelection : Selection -> RenderingCursor -> RenderingCursor
renderSelection selection cursor =
    case selection of
        FieldScalar _ ->
            cursor

        FieldEnum _ ->
            cursor

        FieldObject fields ->
            cursor
                |> addString " {"
                |> addLevelToCursor
                |> renderFields fields
                |> removeLevelToCursor
                |> addString " }"

        FieldUnion details ->
            cursor
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
                        List.foldr renderVariant currentCursor details.variants
                   )
                |> removeLevelToCursor
                |> addString " }"

        FieldInterface details ->
            cursor
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
                        List.foldr renderVariant currentCursor details.variants
                   )
                |> removeLevelToCursor
                |> addString " }"


renderVariant : VariantCase -> RenderingCursor -> RenderingCursor
renderVariant instance cursor =
    cursor
        |> addString ("\n... on " ++ nameToString instance.tag ++ " {")
        |> addLevelToCursor
        |> renderFields instance.selection
        |> removeLevelToCursor
        |> addString "}"


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
            List.foldl
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
            List.foldl
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
            List.foldl
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

module GraphQL.Operations.Canonicalize exposing
    ( Paths
    , canonicalize
    )

{-| -}

import Dict exposing (Dict)
import Generate.Path
import GraphQL.Operations.AST as AST
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Canonicalize.Cache as Cache
import GraphQL.Operations.Canonicalize.Error as Error
import GraphQL.Schema
import Utils.String


type CanResult success
    = CanError (List Error.Error)
    | CanSuccess Cache.Cache success


mapCache : (Cache.Cache -> Cache.Cache) -> CanResult success -> CanResult success
mapCache fn result =
    case result of
        CanError message ->
            CanError message

        CanSuccess cache data ->
            CanSuccess (fn cache) data


type alias References =
    { schema : GraphQL.Schema.Schema
    , fragments : Dict String Can.Fragment
    , paths : Paths
    }


err : List Error.Error -> CanResult success
err =
    CanError


success : Cache.Cache -> success -> CanResult success
success =
    CanSuccess


ok : success -> Cache.Cache -> CanResult success
ok data cache =
    CanSuccess cache data


type alias Paths =
    { path : String
    , gqlDir : List String
    }


canonicalize : GraphQL.Schema.Schema -> Paths -> AST.Document -> Result (List Error.Error) Can.Document
canonicalize schema paths doc =
    let
        fragmentResult =
            List.foldl
                (getFragments
                    schema
                )
                (Ok Dict.empty)
                doc.definitions
    in
    case fragmentResult of
        Err fragErrorDetails ->
            Err (List.map Error.error fragErrorDetails)

        Ok fragments ->
            let
                startingCache =
                    Cache.init
                        { reservedNames =
                            -- These are names that we know will be in the generated code
                            [ "Input"
                            , "Response"
                            ]
                        }

                canonicalizedFragments =
                    List.foldl
                        (canonicalizeFragment schema paths)
                        (CanSuccess startingCache Dict.empty)
                        (List.sortBy AST.fragmentCount
                            (Dict.values fragments)
                        )
            in
            case canonicalizedFragments of
                CanSuccess _ canonicalFrags ->
                    let
                        canonicalizedDefinitions =
                            List.foldl
                                (canonicalizeDefinition
                                    { schema = schema
                                    , fragments = canonicalFrags
                                    , paths = paths
                                    }
                                )
                                (CanSuccess startingCache [])
                                doc.definitions
                    in
                    case canonicalizedDefinitions of
                        CanSuccess _ defs ->
                            Ok
                                { definitions = defs
                                , fragments = Dict.values canonicalFrags
                                }

                        CanError errorMsg ->
                            Err errorMsg

                CanError errorMsg ->
                    Err errorMsg


getFragments :
    GraphQL.Schema.Schema
    -> AST.Definition
    -> Result (List Error.ErrorDetails) (Dict String AST.FragmentDetails)
    -> Result (List Error.ErrorDetails) (Dict String AST.FragmentDetails)
getFragments schema def result =
    case result of
        Err errs ->
            Err errs

        Ok frags ->
            case def of
                AST.Operation _ ->
                    result

                AST.Fragment frag ->
                    let
                        name =
                            AST.nameToString frag.name
                    in
                    case Dict.get name frags of
                        Nothing ->
                            frags
                                |> Dict.insert
                                    (AST.nameToString frag.name)
                                    frag
                                |> Ok

                        Just found ->
                            Err
                                [ Error.FragmentDuplicateFound
                                    { firstName = AST.nameToString frag.name
                                    , firstTypeCondition = AST.nameToString frag.typeCondition
                                    , firstFieldCount = List.length frag.selection
                                    , secondName = AST.nameToString found.name
                                    , secondTypeCondition = AST.nameToString found.typeCondition
                                    , secondFieldCount = List.length found.selection
                                    }
                                ]


convertName : AST.Name -> Can.Name
convertName (AST.Name str) =
    Can.Name str


canonicalizeDefinition :
    References
    -> AST.Definition
    -> CanResult (List Can.Definition)
    -> CanResult (List Can.Definition)
canonicalizeDefinition refs def result =
    case result of
        CanError message ->
            CanError message

        CanSuccess startCache cannedDefs ->
            case def of
                AST.Fragment _ ->
                    CanSuccess startCache cannedDefs

                AST.Operation details ->
                    let
                        globalOperationName =
                            Maybe.map convertName details.name

                        operationType =
                            case details.operationType of
                                AST.Query ->
                                    Can.Query

                                AST.Mutation ->
                                    Can.Mutation

                        initialNameCache =
                            startCache
                                |> Cache.getGlobalName
                                    (globalOperationName
                                        |> Maybe.map Can.nameToString
                                        |> Maybe.withDefault (opTypeName operationType)
                                    )

                        fieldResult =
                            List.foldl
                                (\field fieldCanResult ->
                                    case fieldCanResult of
                                        CanSuccess oldCache oldItems ->
                                            let
                                                newResult =
                                                    canonicalizeOperation
                                                        refs
                                                        details.operationType
                                                        oldCache
                                                        field
                                            in
                                            case newResult of
                                                CanError errorMessage ->
                                                    CanError errorMessage

                                                CanSuccess newCache validItem ->
                                                    CanSuccess
                                                        newCache
                                                        (validItem :: oldItems)

                                        CanError _ ->
                                            fieldCanResult
                                )
                                (ok [] initialNameCache.used)
                                details.fields
                    in
                    case fieldResult of
                        CanSuccess fieldCache fields ->
                            let
                                variableSummary =
                                    List.foldl
                                        verifyVariables
                                        { declared = []
                                        , valid = []
                                        , issues = []
                                        , suggestions = []
                                        }
                                        (mergeVars fieldCache.varTypes details.variableDefinitions)
                            in
                            if not (List.isEmpty variableSummary.issues) then
                                CanError
                                    [ Error.error
                                        (Error.VariableIssueSummary variableSummary)
                                    ]

                            else
                                let
                                    fragmentVariableIssues =
                                        List.filterMap
                                            (fragmentVariableErrors details.variableDefinitions)
                                            (List.map .fragment fieldCache.fragmentsUsed)
                                in
                                if not (List.isEmpty fragmentVariableIssues) then
                                    CanError
                                        (List.map
                                            (Error.error << Error.FragmentVariableIssue)
                                            fragmentVariableIssues
                                        )

                                else
                                    let
                                        new =
                                            Can.Operation
                                                { operationType =
                                                    operationType
                                                , name = globalOperationName
                                                , variableDefinitions =
                                                    variableSummary.valid
                                                , directives =
                                                    List.map convertDirective details.directives
                                                , fields = fields
                                                , fragmentsUsed = fieldCache.fragmentsUsed
                                                }
                                    in
                                    CanSuccess fieldCache
                                        (new :: cannedDefs)

                        CanError errorMsg ->
                            CanError errorMsg


fragmentVariableErrors : List AST.VariableDefinition -> Can.Fragment -> Maybe Error.FragmentVariableSummary
fragmentVariableErrors varDefs frag =
    let
        varSummary =
            { fragmentName = Can.nameToString frag.name
            , declared =
                List.map
                    (\def ->
                        { name = AST.nameToString def.variable.name
                        , type_ = AST.typeToGqlString def.type_
                        }
                    )
                    varDefs
            , used =
                List.map
                    (\( name, varType ) ->
                        { name = name
                        , type_ = GraphQL.Schema.typeToString varType
                        }
                    )
                    frag.usedVariables
            }

        variableIssue ( name, varType ) existingIssue =
            case existingIssue of
                Just _ ->
                    existingIssue

                _ ->
                    case List.head (List.filter (\def -> AST.nameToString def.variable.name == name) varDefs) of
                        Nothing ->
                            Just varSummary

                        Just found ->
                            if String.toLower (AST.typeToGqlString found.type_) == String.toLower (GraphQL.Schema.typeToString varType) then
                                Nothing

                            else
                                Just varSummary
    in
    List.foldl variableIssue Nothing frag.usedVariables


opTypeName : Can.OperationType -> String
opTypeName op =
    case op of
        Can.Query ->
            "Query"

        Can.Mutation ->
            "Mutation"


{-| The AST.Type is the type declared at the top of the document.

The Schema.Type is what is in the schema.

    variableDefinition is the AST representation of the variable declaration at the top.

-}
doTypesMatch : GraphQL.Schema.Type -> AST.Type -> Bool
doTypesMatch schemaType variableDefinition =
    case variableDefinition of
        AST.Type_ astName ->
            case schemaType of
                GraphQL.Schema.Scalar schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.InputObject schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.Object schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.Enum schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.Union schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.Interface schemaName ->
                    AST.nameToString astName
                        == schemaName

                GraphQL.Schema.List_ _ ->
                    False

                GraphQL.Schema.Nullable innerSchema ->
                    -- the query can mark something as required even if it's optional in the schema
                    doTypesMatch innerSchema variableDefinition

        AST.Nullable innerAST ->
            case schemaType of
                GraphQL.Schema.Nullable innerSchema ->
                    doTypesMatch innerSchema innerAST

                _ ->
                    False

        AST.List_ innerAST ->
            case schemaType of
                GraphQL.Schema.List_ innerSchema ->
                    doTypesMatch innerSchema innerAST

                GraphQL.Schema.Nullable innerSchema ->
                    -- the query can mark something as required even if it's optional in the schema
                    doTypesMatch innerSchema variableDefinition

                _ ->
                    False


verifyVariables :
    { name : String
    , definition : Maybe AST.VariableDefinition
    , inOperation : Maybe GraphQL.Schema.Type
    }
    -> Error.VariableSummary
    -> Error.VariableSummary
verifyVariables item summary =
    case ( item.definition, item.inOperation ) of
        ( Just def, Just inOp ) ->
            -- check to make sure the variables are unifiable
            let
                valid =
                    { variable = { name = convertName def.variable.name }
                    , type_ = def.type_
                    , defaultValue = def.defaultValue
                    , schemaType = inOp
                    }

                typeString =
                    GraphQL.Schema.typeToString inOp

                declared =
                    { name = AST.nameToString def.variable.name
                    , type_ =
                        Just
                            (AST.typeToGqlString def.type_)
                    }

                typesMatch =
                    doTypesMatch inOp def.type_
            in
            { declared = declared :: summary.declared
            , valid = valid :: summary.valid
            , issues =
                if typesMatch then
                    summary.issues

                else
                    Error.UnexpectedType
                        { name = item.name
                        , found = Just (AST.typeToGqlString def.type_)
                        , expected = typeString
                        }
                        :: summary.issues
            , suggestions =
                if typesMatch then
                    -- we do this so that when we print an error message
                    -- If the user has specified that this is a required value
                    -- but the schema says it's optional
                    -- we maintain the required-ness
                    { name = AST.nameToString def.variable.name
                    , type_ =
                        AST.typeToGqlString def.type_
                    }
                        :: summary.suggestions

                else
                    let
                        suggestion =
                            { name = AST.nameToString def.variable.name
                            , type_ = typeString
                            }
                    in
                    suggestion :: summary.suggestions
            }

        ( Just def, Nothing ) ->
            { declared =
                { name = AST.nameToString def.variable.name
                , type_ = Nothing
                }
                    :: summary.declared
            , valid = summary.valid
            , issues =
                Error.Unused
                    { name = item.name
                    , possibly = []
                    }
                    :: summary.issues
            , suggestions =
                summary.suggestions
            }

        ( Nothing, Just inOp ) ->
            let
                suggestion =
                    { name = item.name
                    , type_ = GraphQL.Schema.typeToString inOp
                    }
            in
            { declared = summary.declared
            , valid = summary.valid
            , issues =
                Error.Undeclared
                    { name = item.name
                    , possibly = []
                    }
                    :: summary.issues
            , suggestions = suggestion :: summary.suggestions
            }

        ( Nothing, Nothing ) ->
            summary


mergeVars :
    List ( String, GraphQL.Schema.Type )
    -> List AST.VariableDefinition
    ->
        List
            { name : String
            , definition : Maybe AST.VariableDefinition
            , inOperation : Maybe GraphQL.Schema.Type
            }
mergeVars varTypes variableDefinitions =
    let
        allNames =
            List.foldl
                (\varName found ->
                    if List.member varName found then
                        found

                    else
                        varName :: found
                )
                []
                (List.map (.variable >> .name >> AST.nameToString) variableDefinitions
                    ++ List.map Tuple.first varTypes
                )
                |> List.reverse
    in
    List.map
        (\name ->
            { name = name
            , definition =
                List.foldl
                    (\def found ->
                        case found of
                            Nothing ->
                                if AST.nameToString def.variable.name == name then
                                    Just def

                                else
                                    found

                            _ ->
                                found
                    )
                    Nothing
                    variableDefinitions
            , inOperation =
                find name varTypes
            }
        )
        allNames


find : String -> List ( String, a ) -> Maybe a
find str items =
    case items of
        [] ->
            Nothing

        ( key, val ) :: remain ->
            if str == key then
                Just val

            else
                find str remain


canonicalizeOperation :
    References
    -> AST.OperationType
    -> Cache.Cache
    -> AST.Selection
    -> CanResult Can.Field
canonicalizeOperation refs op cache selection =
    case selection of
        AST.Field field ->
            let
                matched =
                    case op of
                        AST.Query ->
                            Dict.get (AST.nameToString field.name) refs.schema.queries

                        AST.Mutation ->
                            Dict.get (AST.nameToString field.name) refs.schema.mutations
            in
            case matched of
                Nothing ->
                    err [ Error.error (Error.QueryUnknown (AST.nameToString field.name)) ]

                Just query ->
                    canonicalizeFieldType refs
                        field
                        (cache
                            |> (case op of
                                    AST.Query ->
                                        Cache.query (AST.nameToString field.name) refs.paths.path

                                    AST.Mutation ->
                                        Cache.mutation (AST.nameToString field.name) refs.paths.path
                               )
                        )
                        query
                        |> mapCache Cache.dropLevel

        AST.FragmentSpreadSelection _ ->
            err [ Error.todo "Top level Fragments aren't suported yet!" ]

        AST.InlineFragmentSelection inline ->
            -- This is when we're selecting a union fragment
            err [ Error.error (Error.FragmentInlineTopLevel { fragment = inline }) ]


type InputValidation
    = Valid (List ( String, GraphQL.Schema.Type ))
    | Mismatch


validateInput :
    References
    -> GraphQL.Schema.Type
    -> String
    -> AST.Value
    -> InputValidation
validateInput refs schemaType fieldName astValue =
    case astValue of
        AST.Var var ->
            let
                varname =
                    AST.nameToString var.name
            in
            Valid [ ( varname, schemaType ) ]

        AST.Object keyValues ->
            case schemaType of
                GraphQL.Schema.InputObject inputObjectName ->
                    case Dict.get inputObjectName refs.schema.inputObjects of
                        Nothing ->
                            Mismatch

                        Just inputObject ->
                            validateObject refs fieldName keyValues inputObject

                GraphQL.Schema.Nullable (GraphQL.Schema.InputObject inputObjectName) ->
                    case Dict.get inputObjectName refs.schema.inputObjects of
                        Nothing ->
                            Mismatch

                        Just inputObject ->
                            validateObject refs fieldName keyValues inputObject

                GraphQL.Schema.List_ inner ->
                    -- A single literal can be coerced into a list
                    -- https://spec.graphql.org/June2018/#sec-Type-System.List
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch

        AST.Str _ ->
            case schemaType of
                GraphQL.Schema.Scalar "Int" ->
                    Mismatch

                GraphQL.Schema.Scalar "Float" ->
                    Mismatch

                GraphQL.Schema.Scalar "Boolean" ->
                    Mismatch

                GraphQL.Schema.Scalar _ ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput refs inner fieldName astValue

                GraphQL.Schema.List_ inner ->
                    -- A single literal can be coerced into a list
                    -- https://spec.graphql.org/June2018/#sec-Type-System.List
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch

        AST.Integer _ ->
            case schemaType of
                GraphQL.Schema.Scalar "Int" ->
                    Valid []

                GraphQL.Schema.Scalar "Float" ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput refs inner fieldName astValue

                GraphQL.Schema.List_ inner ->
                    -- A single literal can be coerced into a list
                    -- https://spec.graphql.org/June2018/#sec-Type-System.List
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch

        AST.Decimal _ ->
            case schemaType of
                GraphQL.Schema.Scalar "Float" ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput refs inner fieldName astValue

                GraphQL.Schema.List_ inner ->
                    -- A single literal can be coerced into a list
                    -- https://spec.graphql.org/June2018/#sec-Type-System.List
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch

        AST.Boolean _ ->
            case schemaType of
                GraphQL.Schema.Scalar "Boolean" ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput refs inner fieldName astValue

                GraphQL.Schema.List_ inner ->
                    -- A single literal can be coerced into a list
                    -- https://spec.graphql.org/June2018/#sec-Type-System.List
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch

        AST.Null ->
            case schemaType of
                GraphQL.Schema.Nullable _ ->
                    Valid []

                _ ->
                    Mismatch

        AST.Enum _ ->
            case schemaType of
                GraphQL.Schema.Enum _ ->
                    Valid []

                GraphQL.Schema.Nullable inner ->
                    validateInput refs inner fieldName astValue

                GraphQL.Schema.List_ inner ->
                    -- A single literal can be coerced into a list
                    -- https://spec.graphql.org/June2018/#sec-Type-System.List
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch

        AST.ListValue list ->
            case schemaType of
                GraphQL.Schema.List_ innerList ->
                    List.foldl
                        (\item current ->
                            case current of
                                Valid validArgs ->
                                    case validateInput refs innerList fieldName item of
                                        Valid newArgs ->
                                            Valid (newArgs ++ validArgs)

                                        validationError ->
                                            validationError

                                _ ->
                                    current
                        )
                        (Valid [])
                        list

                GraphQL.Schema.Nullable inner ->
                    validateInput refs inner fieldName astValue

                _ ->
                    Mismatch


validateObject refs fieldName keyValues inputObject =
    List.foldl
        (\( keyName, value ) current ->
            case current of
                Valid argValues ->
                    let
                        key =
                            AST.nameToString keyName
                    in
                    case List.head (List.filter (\a -> a.name == key) inputObject.fields) of
                        Nothing ->
                            Mismatch

                        Just field ->
                            case validateInput refs field.type_ fieldName value of
                                Valid fieldArgs ->
                                    Valid (argValues ++ fieldArgs)

                                validationError ->
                                    validationError

                _ ->
                    current
        )
        (Valid [])
        keyValues


selectsSingleFragment :
    References
    -> List AST.Selection
    ->
        Maybe
            { importFrom : List String
            , name : String
            }
selectsSingleFragment refs fields =
    case fields of
        [ AST.FragmentSpreadSelection fragment ] ->
            let
                fragName =
                    Utils.String.formatTypename (AST.nameToString fragment.name)

                paths =
                    Generate.Path.fragment
                        { name = fragName
                        , path = refs.paths.path
                        , gqlDir = refs.paths.gqlDir
                        }
            in
            Just
                { importFrom = paths.modulePath
                , name = fragName
                }

        _ ->
            Nothing


canonicalizeFragment :
    GraphQL.Schema.Schema
    -> Paths
    -> AST.FragmentDetails
    -> CanResult (Dict String Can.Fragment)
    -> CanResult (Dict String Can.Fragment)
canonicalizeFragment schema paths frag currentResult =
    case currentResult of
        CanError errMsg ->
            CanError errMsg

        CanSuccess cache existingFrags ->
            let
                fragName =
                    AST.nameToString frag.name

                fragPaths =
                    Generate.Path.fragment
                        { name = fragName
                        , path = paths.path
                        , gqlDir = paths.gqlDir
                        }

                typeCondition =
                    AST.nameToString frag.typeCondition
            in
            case Dict.get typeCondition schema.objects of
                Just obj ->
                    let
                        selectionResult =
                            List.foldl
                                (canonicalizeField
                                    { schema = schema
                                    , fragments = existingFrags
                                    , paths = paths
                                    }
                                    obj
                                )
                                (cache
                                    |> Cache.addLevel
                                        { name = AST.nameToString frag.name
                                        , isAlias = False
                                        }
                                    |> ok []
                                )
                                frag.selection
                    in
                    case selectionResult of
                        CanSuccess fragmentSpecificCache selection ->
                            CanSuccess fragmentSpecificCache
                                (existingFrags
                                    |> Dict.insert fragName
                                        { name = convertName frag.name
                                        , importFrom = fragPaths.modulePath
                                        , typeCondition = convertName frag.typeCondition
                                        , usedVariables = fragmentSpecificCache.varTypes
                                        , fragmentsUsed =
                                            List.map (.fragment >> .name) fragmentSpecificCache.fragmentsUsed
                                        , directives = List.map convertDirective frag.directives
                                        , selection =
                                            Can.FragmentObject
                                                { selection = selection }
                                        }
                                )

                        CanError errorMsg ->
                            CanError errorMsg

                Nothing ->
                    case Dict.get typeCondition schema.interfaces of
                        Just interface ->
                            let
                                variants =
                                    List.foldl getInterfaceNames [] interface.implementedBy

                                canVarSelectionResult =
                                    canonicalizeVariantSelection
                                        { schema = schema
                                        , fragments = existingFrags
                                        , paths = paths
                                        }
                                        (cache
                                            |> Cache.addLevel
                                                { name = AST.nameToString frag.name
                                                , isAlias = False
                                                }
                                        )
                                        { name = interface.name
                                        , description = interface.description
                                        , fields = interface.fields
                                        }
                                        frag.selection
                                        variants
                            in
                            case canVarSelectionResult of
                                CanSuccess fragmentSpecificCache selection ->
                                    CanSuccess fragmentSpecificCache
                                        (existingFrags
                                            |> Dict.insert (AST.nameToString frag.name)
                                                { name = convertName frag.name
                                                , importFrom = fragPaths.modulePath
                                                , typeCondition = convertName frag.typeCondition
                                                , usedVariables = fragmentSpecificCache.varTypes
                                                , fragmentsUsed = List.map (.fragment >> .name) fragmentSpecificCache.fragmentsUsed
                                                , directives = List.map convertDirective frag.directives
                                                , selection =
                                                    Can.FragmentInterface selection
                                                }
                                        )

                                CanError errorMsg ->
                                    CanError errorMsg

                        Nothing ->
                            case Dict.get typeCondition schema.unions of
                                Just union ->
                                    let
                                        variants =
                                            Maybe.withDefault [] <| extractUnionTags union.variants []

                                        canVarSelectionResult =
                                            canonicalizeVariantSelection
                                                { schema = schema
                                                , fragments = existingFrags
                                                , paths = paths
                                                }
                                                (cache
                                                    |> Cache.addLevel
                                                        { name = AST.nameToString frag.name
                                                        , isAlias = False
                                                        }
                                                )
                                                { name = union.name
                                                , description = union.description
                                                , fields = []
                                                }
                                                frag.selection
                                                variants
                                    in
                                    case canVarSelectionResult of
                                        CanSuccess fragmentSpecificCache selection ->
                                            CanSuccess fragmentSpecificCache
                                                (existingFrags
                                                    |> Dict.insert (AST.nameToString frag.name)
                                                        { name = convertName frag.name
                                                        , importFrom = fragPaths.modulePath
                                                        , typeCondition = convertName frag.typeCondition
                                                        , usedVariables = fragmentSpecificCache.varTypes
                                                        , fragmentsUsed =
                                                            List.map (.fragment >> .name) fragmentSpecificCache.fragmentsUsed
                                                        , directives = List.map convertDirective frag.directives
                                                        , selection =
                                                            Can.FragmentUnion selection
                                                        }
                                                )

                                        CanError errorMsg ->
                                            CanError errorMsg

                                Nothing ->
                                    CanError
                                        [ Error.error <|
                                            Error.FragmentTargetDoesntExist
                                                { fragmentName = AST.nameToString frag.name
                                                , typeCondition = AST.nameToString frag.typeCondition
                                                }
                                        ]


canonicalizeVariantSelection :
    References
    -> Cache.Cache
    ->
        { description : Maybe String
        , fields :
            List GraphQL.Schema.Field
        , name : String
        }
    -> List AST.Selection
    -> List String
    ->
        CanResult
            { remainingTags : List { globalAlias : Can.Name, tag : Can.Name }
            , selection : List Can.Field
            , variants : List Can.VariantCase
            }
canonicalizeVariantSelection refs cache unionOrInterface selection variants =
    let
        selectsForTypename =
            List.any
                (\sel ->
                    case sel of
                        AST.Field firstField ->
                            case AST.nameToString firstField.name of
                                "__typename" ->
                                    True

                                _ ->
                                    False

                        _ ->
                            False
                )
                selection

        selectionResult =
            List.foldl
                (canonicalizeFieldWithVariants refs
                    unionOrInterface
                )
                { result =
                    cache
                        |> ok []
                , capturedVariants = []
                , variants = variants
                , typenameAlreadySelected = selectsForTypename
                }
                selection
    in
    case selectionResult.result of
        CanSuccess selectionCache canSelection ->
            let
                ( finalCache, remaining ) =
                    List.foldl
                        gatherRemaining
                        ( selectionCache
                        , []
                        )
                        selectionResult.variants
            in
            CanSuccess
                (finalCache
                    |> Cache.dropLevel
                )
                { selection = canSelection
                , variants = selectionResult.capturedVariants
                , remainingTags =
                    List.reverse remaining
                }

        CanError errorMsg ->
            CanError errorMsg


{-| -}
canonicalizeField :
    References
    ->
        { obj
            | name : String
            , description : Maybe String
            , fields : List GraphQL.Schema.Field
        }
    -> AST.Selection
    -> CanResult (List Can.Field)
    -> CanResult (List Can.Field)
canonicalizeField refs object selection existingFieldResult =
    case existingFieldResult of
        CanError message ->
            CanError message

        CanSuccess cache existingFields ->
            case selection of
                AST.Field field ->
                    let
                        fieldName =
                            AST.nameToString field.name
                    in
                    if fieldName == "__typename" then
                        let
                            new =
                                Can.Field
                                    { alias_ = Maybe.map convertName field.alias_
                                    , name = convertName field.name
                                    , globalAlias =
                                        field.alias_
                                            |> Maybe.withDefault field.name
                                            |> convertName
                                    , selectsOnlyFragment = Nothing
                                    , arguments = []
                                    , directives = List.map convertDirective field.directives
                                    , wrapper = GraphQL.Schema.UnwrappedValue
                                    , selection =
                                        Can.FieldScalar (GraphQL.Schema.Scalar "typename")
                                    }
                        in
                        cache
                            |> ok (new :: existingFields)

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
                                    aliased =
                                        AST.getAliasedName field

                                    canonicalizedNewField =
                                        canonicalizeFieldType refs
                                            field
                                            cache
                                            matched

                                    siblingID =
                                        { aliasedName = aliased
                                        , scalar =
                                            if GraphQL.Schema.isScalar matched.type_ then
                                                Just (GraphQL.Schema.typeToString matched.type_)

                                            else
                                                Nothing
                                        }
                                in
                                case canonicalizedNewField of
                                    CanSuccess newCache new ->
                                        if Cache.siblingCollision siblingID newCache then
                                            -- There has been a collision, abort!
                                            err
                                                [ Error.error
                                                    (Error.FieldAliasRequired
                                                        { fieldName = aliased
                                                        }
                                                    )
                                                ]

                                        else
                                            newCache
                                                |> Cache.saveSibling siblingID
                                                |> Cache.field object.name fieldName refs.paths.path
                                                |> ok (new :: existingFields)

                                    CanError message ->
                                        CanError message

                            Nothing ->
                                err
                                    [ Error.error
                                        (Error.FieldUnknown
                                            { object = object.name
                                            , field = fieldName
                                            }
                                        )
                                    ]

                AST.FragmentSpreadSelection frag ->
                    let
                        fragName =
                            AST.nameToString frag.name
                    in
                    case Dict.get fragName refs.fragments of
                        Nothing ->
                            err
                                [ Error.error <|
                                    Error.FragmentNotFound
                                        { found = fragName
                                        , object = object.name
                                        , options =
                                            Dict.values refs.fragments
                                        }
                                ]

                        Just foundFrag ->
                            if Can.nameToString foundFrag.typeCondition == object.name then
                                let
                                    new =
                                        Can.Frag
                                            { fragment = foundFrag
                                            , directives =
                                                frag.directives
                                                    |> List.map
                                                        convertDirective
                                            }
                                in
                                cache
                                    |> Cache.addFragment
                                        { fragment = foundFrag
                                        , alongsideOtherFields = False
                                        }
                                    |> ok (new :: existingFields)

                            else
                                err
                                    [ Error.error <|
                                        Error.FragmentNotFound
                                            { found = fragName
                                            , object = object.name
                                            , options =
                                                Dict.values refs.fragments
                                            }
                                    ]

                AST.InlineFragmentSelection inline ->
                    err
                        [ Error.error
                            (Error.FragmentSelectionNotAllowedInObjects
                                { fragment = inline
                                , objectName = object.name
                                }
                            )
                        ]


convertDirective dir =
    { name = convertName dir.name
    , arguments =
        dir.arguments
    }


canonicalizeFieldType :
    References
    -> AST.FieldDetails
    -> Cache.Cache
    -> GraphQL.Schema.Field
    -> CanResult Can.Field
canonicalizeFieldType refs field cache schemaField =
    canonicalizeFieldTypeHelper refs field schemaField.type_ cache schemaField


canonicalizeArguments :
    References
    -> List GraphQL.Schema.Argument
    -> List AST.Argument
    ->
        { valid : List ( String, GraphQL.Schema.Type )
        , unknown : List String
        , errs : List Error.Error
        }
canonicalizeArguments refs schemaArguments arguments =
    List.foldl
        (\arg found ->
            let
                fieldname =
                    AST.nameToString arg.name
            in
            case List.head (List.filter (\a -> a.name == fieldname) schemaArguments) of
                Nothing ->
                    { found
                        | unknown =
                            fieldname :: found.unknown
                    }

                Just schemaVar ->
                    case validateInput refs schemaVar.type_ fieldname arg.value of
                        Valid vars ->
                            { found
                                | valid =
                                    vars ++ found.valid
                            }

                        Mismatch ->
                            { found
                                | errs =
                                    Error.error
                                        (Error.IncorrectInlineInput
                                            { schema = schemaVar.type_
                                            , arg = fieldname
                                            , found = arg.value
                                            }
                                        )
                                        :: found.errs
                            }
        )
        { valid = []
        , unknown = []
        , errs = []
        }
        arguments


{-|

    For `field`, we are matching it up with types from `schema`

-}
canonicalizeFieldTypeHelper :
    References
    -> AST.FieldDetails
    -> GraphQL.Schema.Type
    -> Cache.Cache
    -> GraphQL.Schema.Field
    -> CanResult Can.Field
canonicalizeFieldTypeHelper refs field type_ initialVarCache schemaField =
    let
        argValidation =
            canonicalizeArguments refs schemaField.arguments field.arguments
    in
    if not (List.isEmpty argValidation.unknown) then
        CanError
            [ Error.error <|
                Error.UnknownArgs
                    { field = AST.nameToString field.name
                    , unknownArgs = argValidation.unknown
                    , allowedArgs =
                        schemaField.arguments
                    }
            ]

    else if not (List.isEmpty argValidation.errs) then
        CanError argValidation.errs

    else
        let
            vars =
                List.reverse argValidation.valid

            newCache =
                initialVarCache |> Cache.addVars vars
        in
        case type_ of
            GraphQL.Schema.Scalar scalarName ->
                newCache
                    |> Cache.scalar scalarName refs.paths.path
                    |> ok
                        (Can.Field
                            { alias_ = Maybe.map convertName field.alias_
                            , name = convertName field.name
                            , selectsOnlyFragment = Nothing
                            , globalAlias =
                                field.alias_
                                    |> Maybe.withDefault field.name
                                    |> convertName
                            , arguments = field.arguments
                            , directives = List.map convertDirective field.directives
                            , wrapper = GraphQL.Schema.getWrap schemaField.type_
                            , selection =
                                Can.FieldScalar (GraphQL.Schema.getInner schemaField.type_)
                            }
                        )

            GraphQL.Schema.InputObject _ ->
                err [ Error.todo "Invalid schema!  Weird InputObject" ]

            GraphQL.Schema.Object name ->
                case Dict.get name refs.schema.objects of
                    Nothing ->
                        err [ Error.error (Error.ObjectUnknown name) ]

                    Just obj ->
                        canonicalizeObject refs
                            field
                            schemaField
                            newCache
                            obj

            GraphQL.Schema.Enum enumName ->
                case Dict.get enumName refs.schema.enums of
                    Nothing ->
                        err [ Error.error (Error.EnumUnknown enumName) ]

                    Just enum ->
                        newCache
                            |> Cache.enum enumName refs.paths.path
                            |> ok
                                (Can.Field
                                    { alias_ = Maybe.map convertName field.alias_
                                    , name = convertName field.name
                                    , globalAlias =
                                        field.alias_
                                            |> Maybe.withDefault field.name
                                            |> convertName
                                    , selectsOnlyFragment = Nothing
                                    , arguments = field.arguments
                                    , directives = List.map convertDirective field.directives
                                    , wrapper = GraphQL.Schema.getWrap schemaField.type_
                                    , selection =
                                        Can.FieldEnum
                                            { enumName = enum.name
                                            , values = enum.values
                                            }
                                    }
                                )

            GraphQL.Schema.Union name ->
                case Dict.get name refs.schema.unions of
                    Nothing ->
                        err [ Error.error (Error.UnionUnknown name) ]

                    Just union ->
                        case extractUnionTags union.variants [] of
                            Nothing ->
                                err [ Error.todo "Things in a union are not objects!" ]

                            Just variants ->
                                let
                                    aliasedName =
                                        field.alias_
                                            |> Maybe.withDefault field.name
                                            |> convertName
                                            |> Can.nameToString

                                    global =
                                        Cache.getGlobalName aliasedName newCache

                                    canVarSelectionResult =
                                        canonicalizeVariantSelection refs
                                            (global.used
                                                |> Cache.addLevel (Cache.levelFromField field)
                                            )
                                            { name = union.name
                                            , description = union.description

                                            -- Note, unions dont have any fields themselves, unlike interfaces
                                            , fields = []
                                            }
                                            field.selection
                                            variants
                                in
                                case canVarSelectionResult of
                                    CanSuccess cache variantSelection ->
                                        CanSuccess cache
                                            (Can.Field
                                                { alias_ = Maybe.map convertName field.alias_
                                                , name = convertName field.name
                                                , globalAlias = Can.Name global.globalName
                                                , selectsOnlyFragment = selectsSingleFragment refs field.selection
                                                , arguments = field.arguments
                                                , directives = List.map convertDirective field.directives
                                                , wrapper = GraphQL.Schema.getWrap schemaField.type_
                                                , selection =
                                                    Can.FieldUnion variantSelection
                                                }
                                            )

                                    CanError errorMsg ->
                                        CanError errorMsg

            GraphQL.Schema.Interface name ->
                case Dict.get name refs.schema.interfaces of
                    Nothing ->
                        err [ Error.error (Error.UnionUnknown name) ]

                    Just interface ->
                        let
                            variants =
                                List.foldl getInterfaceNames [] interface.implementedBy

                            aliasedName =
                                field.alias_
                                    |> Maybe.withDefault field.name
                                    |> convertName
                                    |> Can.nameToString

                            global =
                                Cache.getGlobalName aliasedName newCache

                            canVarSelectionResult =
                                canonicalizeVariantSelection refs
                                    (global.used
                                        |> Cache.addLevel (Cache.levelFromField field)
                                    )
                                    { name = interface.name
                                    , description = interface.description
                                    , fields = interface.fields
                                    }
                                    field.selection
                                    variants
                        in
                        case canVarSelectionResult of
                            CanSuccess cache variantSelection ->
                                CanSuccess cache
                                    (Can.Field
                                        { alias_ = Maybe.map convertName field.alias_
                                        , name = convertName field.name
                                        , globalAlias =
                                            Can.Name global.globalName
                                        , selectsOnlyFragment = selectsSingleFragment refs field.selection
                                        , arguments = field.arguments
                                        , directives = List.map convertDirective field.directives
                                        , wrapper = GraphQL.Schema.getWrap schemaField.type_
                                        , selection =
                                            Can.FieldInterface variantSelection
                                        }
                                    )

                            CanError errorMsg ->
                                CanError errorMsg

            GraphQL.Schema.List_ inner ->
                canonicalizeFieldTypeHelper refs field inner newCache schemaField

            GraphQL.Schema.Nullable inner ->
                canonicalizeFieldTypeHelper refs field inner newCache schemaField


gatherRemaining :
    String
    ->
        ( Cache.Cache
        , List
            { globalAlias : Can.Name
            , tag : Can.Name
            }
        )
    ->
        ( Cache.Cache
        , List
            { globalAlias : Can.Name
            , tag : Can.Name
            }
        )
gatherRemaining tag ( used, gathered ) =
    let
        global =
            Cache.getGlobalName tag used
    in
    ( global.used
    , { globalAlias = Can.Name global.globalName
      , tag = Can.Name tag
      }
        :: gathered
    )


canonicalizeObject :
    References
    -> AST.FieldDetails
    -> GraphQL.Schema.Field
    -> Cache.Cache
    -> GraphQL.Schema.ObjectDetails
    -> CanResult Can.Field
canonicalizeObject refs field schemaField varCache obj =
    case field.selection of
        [] ->
            -- This is an object with no selection, which isn't allowed for gql.
            err
                [ Error.error
                    (Error.EmptySelection
                        { field =
                            case field.alias_ of
                                Nothing ->
                                    AST.nameToString field.name

                                Just alias ->
                                    AST.nameToString alias
                                        ++ ": "
                                        ++ AST.nameToString field.name
                        , fieldType = obj.name
                        , options =
                            List.map
                                (\f ->
                                    { field = f.name
                                    , type_ = GraphQL.Schema.typeToString f.type_
                                    }
                                )
                                obj.fields
                        }
                    )
                ]

        _ ->
            let
                aliasedName =
                    field.alias_
                        |> Maybe.withDefault field.name
                        |> convertName
                        |> Can.nameToString

                global =
                    Cache.getGlobalName aliasedName varCache

                selectionResult =
                    List.foldl
                        (canonicalizeField refs obj)
                        (global.used
                            |> Cache.addLevel (Cache.levelFromField field)
                            |> ok []
                        )
                        field.selection
            in
            case selectionResult of
                CanSuccess cache canSelection ->
                    let
                        siblingID =
                            { aliasedName = aliasedName

                            -- This is an object, not a scalar
                            , scalar = Nothing
                            }
                    in
                    if Cache.siblingCollision siblingID global.used then
                        err
                            [ Error.error
                                (Error.FieldAliasRequired
                                    { fieldName = aliasedName
                                    }
                                )
                            ]

                    else
                        CanSuccess
                            (cache
                                |> Cache.dropLevel
                                |> Cache.saveSibling siblingID
                            )
                            (Can.Field
                                { alias_ = Maybe.map convertName field.alias_
                                , name = convertName field.name
                                , globalAlias = Can.Name global.globalName
                                , selectsOnlyFragment = selectsSingleFragment refs field.selection
                                , arguments = field.arguments
                                , directives = List.map convertDirective field.directives
                                , wrapper = GraphQL.Schema.getWrap schemaField.type_
                                , selection =
                                    Can.FieldObject canSelection
                                }
                            )

                CanError errorMsg ->
                    CanError errorMsg


getInterfaceNames kind found =
    case kind of
        GraphQL.Schema.ObjectKind name ->
            name :: found

        _ ->
            found


{-| Members of a union can only be objects:
<https://spec.graphql.org/June2018/#sec-Unions>

Some more details: <https://github.com/graphql/graphql-js/issues/451>

-}
extractUnionTags : List GraphQL.Schema.Variant -> List String -> Maybe (List String)
extractUnionTags vars captured =
    case vars of
        [] ->
            Just captured

        top :: remain ->
            case top.kind of
                GraphQL.Schema.ObjectKind name ->
                    extractUnionTags remain (name :: captured)

                _ ->
                    Nothing


canonicalizeFieldWithVariants :
    References
    ->
        { obj
            | name : String
            , description : Maybe String
            , fields : List GraphQL.Schema.Field
        }
    -> AST.Selection
    ->
        { result : CanResult (List Can.Field)
        , variants : List String
        , capturedVariants : List Can.VariantCase
        , typenameAlreadySelected : Bool
        }
    ->
        { result : CanResult (List Can.Field)
        , variants : List String
        , capturedVariants : List Can.VariantCase
        , typenameAlreadySelected : Bool
        }
canonicalizeFieldWithVariants refs unionOrInterface selection found =
    case found.result of
        CanError message ->
            found

        CanSuccess cache existingFields ->
            case selection of
                AST.Field field ->
                    let
                        fieldName =
                            AST.nameToString field.name
                    in
                    if fieldName == "__typename" then
                        let
                            new =
                                Can.Field
                                    { alias_ = Maybe.map convertName field.alias_
                                    , name = convertName field.name
                                    , globalAlias =
                                        field.alias_
                                            |> Maybe.withDefault field.name
                                            |> convertName
                                    , selectsOnlyFragment = Nothing
                                    , arguments = []
                                    , directives = List.map convertDirective field.directives
                                    , wrapper = GraphQL.Schema.UnwrappedValue
                                    , selection =
                                        Can.FieldScalar (GraphQL.Schema.Scalar "typename")
                                    }
                        in
                        { result =
                            cache
                                |> ok (new :: existingFields)
                        , variants = found.variants
                        , capturedVariants = found.capturedVariants
                        , typenameAlreadySelected = True
                        }

                    else
                        let
                            cannedResult =
                                canonicalizeField refs
                                    unionOrInterface
                                    selection
                                    found.result
                        in
                        { result = cannedResult
                        , variants = found.variants
                        , capturedVariants = found.capturedVariants
                        , typenameAlreadySelected = found.typenameAlreadySelected
                        }

                AST.FragmentSpreadSelection frag ->
                    let
                        fragName =
                            AST.nameToString frag.name
                    in
                    case Dict.get fragName refs.fragments of
                        Nothing ->
                            { result =
                                err
                                    [ Error.error <|
                                        Error.FragmentNotFound
                                            { found = fragName
                                            , object = unionOrInterface.name
                                            , options =
                                                Dict.values refs.fragments
                                            }
                                    ]
                            , variants = found.variants
                            , capturedVariants = found.capturedVariants
                            , typenameAlreadySelected = found.typenameAlreadySelected
                            }

                        Just foundFrag ->
                            if Can.nameToString foundFrag.typeCondition == unionOrInterface.name then
                                let
                                    new =
                                        Can.Frag
                                            { fragment = foundFrag
                                            , directives =
                                                frag.directives
                                                    |> List.map
                                                        convertDirective
                                            }
                                in
                                { result =
                                    cache
                                        |> Cache.addFragment
                                            { fragment = foundFrag
                                            , alongsideOtherFields = False
                                            }
                                        |> ok (new :: existingFields)
                                , variants = found.variants
                                , capturedVariants = found.capturedVariants
                                , typenameAlreadySelected = found.typenameAlreadySelected
                                }

                            else
                                { result =
                                    err
                                        [ Error.error <|
                                            Error.FragmentNotFound
                                                { found = fragName
                                                , object = unionOrInterface.name
                                                , options =
                                                    Dict.values refs.fragments
                                                }
                                        ]
                                , variants = found.variants
                                , capturedVariants = found.capturedVariants
                                , typenameAlreadySelected = found.typenameAlreadySelected
                                }

                AST.InlineFragmentSelection inline ->
                    case inline.selection of
                        [] ->
                            { result =
                                err [ Error.error (Error.EmptyUnionVariantSelection { tag = AST.nameToString inline.tag }) ]
                            , variants = found.variants
                            , capturedVariants = found.capturedVariants
                            , typenameAlreadySelected = found.typenameAlreadySelected
                            }

                        _ ->
                            let
                                tag =
                                    AST.nameToString inline.tag

                                ( tagMatches, leftOvertags ) =
                                    matchTag tag found.variants ( False, [] )
                            in
                            if tagMatches then
                                case Dict.get tag refs.schema.objects of
                                    Nothing ->
                                        { result =
                                            err [ Error.error (Error.ObjectUnknown tag) ]
                                        , variants = leftOvertags
                                        , capturedVariants = found.capturedVariants
                                        , typenameAlreadySelected = found.typenameAlreadySelected
                                        }

                                    Just obj ->
                                        let
                                            selectsForTypename =
                                                if found.typenameAlreadySelected then
                                                    True

                                                else
                                                    List.any
                                                        (\sel ->
                                                            case sel of
                                                                AST.Field firstField ->
                                                                    case AST.nameToString firstField.name of
                                                                        "__typename" ->
                                                                            True

                                                                        _ ->
                                                                            False

                                                                _ ->
                                                                    False
                                                        )
                                                        inline.selection

                                            selectionResult =
                                                List.foldl
                                                    (canonicalizeField refs obj)
                                                    (cache
                                                        |> Cache.addLevelKeepSiblingStack
                                                            { name = tag
                                                            , isAlias = False
                                                            }
                                                        |> ok []
                                                    )
                                                    inline.selection
                                        in
                                        if selectsForTypename then
                                            case selectionResult of
                                                CanSuccess selectionCache canSelection ->
                                                    let
                                                        global =
                                                            selectionCache
                                                                |> Cache.dropLevelNotSiblings
                                                                |> Cache.getGlobalName tag

                                                        globalDetailsAlias =
                                                            global.used
                                                                |> Cache.getGlobalName (global.globalName ++ "_Details")
                                                    in
                                                    { result =
                                                        CanSuccess globalDetailsAlias.used existingFields
                                                    , capturedVariants =
                                                        { tag = Can.Name tag
                                                        , globalTagName = Can.Name global.globalName
                                                        , globalDetailsAlias = Can.Name globalDetailsAlias.globalName
                                                        , directives = List.map convertDirective inline.directives
                                                        , selection = canSelection
                                                        }
                                                            :: found.capturedVariants
                                                    , variants = leftOvertags
                                                    , typenameAlreadySelected = found.typenameAlreadySelected
                                                    }

                                                CanError errorMsg ->
                                                    { result =
                                                        CanError errorMsg
                                                    , capturedVariants = found.capturedVariants
                                                    , variants = leftOvertags
                                                    , typenameAlreadySelected = found.typenameAlreadySelected
                                                    }

                                        else
                                            { result =
                                                err [ Error.error (Error.MissingTypename { tag = AST.nameToString inline.tag }) ]
                                            , capturedVariants = found.capturedVariants
                                            , variants = found.variants
                                            , typenameAlreadySelected = found.typenameAlreadySelected
                                            }

                            else
                                { result =
                                    err [ Error.todo (tag ++ " does not match!") ]
                                , variants = found.variants
                                , capturedVariants = found.capturedVariants
                                , typenameAlreadySelected = found.typenameAlreadySelected
                                }


matchTag : String -> List String -> ( Bool, List String ) -> ( Bool, List String )
matchTag tag tags ( matched, captured ) =
    case tags of
        [] ->
            ( matched, captured )

        top :: remain ->
            if top == tag then
                ( True, remain ++ captured )

            else
                matchTag tag
                    remain
                    ( matched, top :: captured )

module Generate.Args exposing
    ( createBuilder
    , optionalMaker
    , prepareRequired
    , recursiveOptionalMaker
    , requiredAnnotation
    )

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Decode
import Elm.Gen.Json.Encode as Encode
import Elm.Gen.List
import Elm.Gen.Maybe
import Elm.Pattern
import Generate.Common
import GraphQL.Schema
import GraphQL.Schema.Argument
import GraphQL.Schema.Field
import GraphQL.Schema.Type exposing (Type(..))
import Set exposing (Set)
import String
import Utils.String


type Wrapped
    = UnwrappedValue
    | InList Wrapped
    | InMaybe Wrapped


{-|

    val -> our variable containing the value we want to encode

    We then want to

-}
encodeScalar : String -> Wrapped -> (Elm.Expression -> Elm.Expression)
encodeScalar scalarName wrapped =
    case wrapped of
        InList inner ->
            Encode.list
                (encodeScalar scalarName inner)

        InMaybe inner ->
            Engine.maybeScalarEncode
                (encodeScalar scalarName
                    inner
                )

        UnwrappedValue ->
            let
                lowered =
                    String.toLower scalarName
            in
            case lowered of
                "int" ->
                    Encode.int

                "float" ->
                    Encode.float

                "string" ->
                    Encode.string

                "boolean" ->
                    Encode.bool

                "id" ->
                    Engine.encodeId

                _ ->
                    \val ->
                        Elm.apply
                            (Elm.valueFrom (Elm.moduleName [ "Scalar" ])
                                (Utils.String.formatValue scalarName)
                                |> Elm.get "encode"
                            )
                            [ val ]


unwrapWith :
    Wrapped
    -> Elm.Annotation.Annotation
    -> Elm.Annotation.Annotation
unwrapWith wrapped expression =
    case wrapped of
        InList inner ->
            Elm.Annotation.list
                (unwrapWith inner expression)

        InMaybe inner ->
            Elm.Annotation.maybe
                (unwrapWith inner expression)

        UnwrappedValue ->
            expression


scalarType : Wrapped -> String -> Elm.Annotation.Annotation
scalarType wrapped scalarName =
    case wrapped of
        InList inner ->
            Elm.Annotation.list
                (scalarType inner scalarName)

        InMaybe inner ->
            Elm.Annotation.maybe
                (scalarType inner scalarName)

        UnwrappedValue ->
            let
                lowered =
                    String.toLower scalarName
            in
            case lowered of
                "int" ->
                    Elm.Annotation.int

                "float" ->
                    Elm.Annotation.float

                "string" ->
                    Elm.Annotation.string

                "boolean" ->
                    Elm.Annotation.bool

                "id" ->
                    Elm.Annotation.named
                        Engine.moduleName_
                        (Utils.String.formatTypename "id")

                _ ->
                    Elm.Annotation.named
                        (Elm.moduleName [ "Scalar" ])
                        (Utils.String.formatTypename scalarName)


{-| Searches the schema and realizes the arguemnts in one annotation.

Required arguments -> as a record
Optional arguments -> as a list of optionals
Both -> record with a special field

-}
recursiveRequiredAnnotation :
    String
    -> GraphQL.Schema.Schema
    ->
        List
            { fieldOrArg
                | name : String.String
                , description : Maybe String.String
                , type_ : Type
            }
    -> Elm.Annotation.Annotation
recursiveRequiredAnnotation namespace schema reqs =
    Elm.Annotation.record
        (List.map
            (\field ->
                ( field.name
                , requiredAnnotationRecursiveHelper
                    namespace
                    schema
                    field.type_
                    UnwrappedValue
                )
            )
            reqs
        )



--(annotations.optional namespace name)


splitRequired args =
    List.partition
        (not << isOptional)
        args


isOptional arg =
    case arg.type_ of
        GraphQL.Schema.Type.Nullable _ ->
            True

        _ ->
            False


isInnerOptional schema arg =
    case arg.type_ of
        GraphQL.Schema.Type.Nullable (GraphQL.Schema.Type.InputObject inputName) ->
            case Dict.get inputName schema.inputObjects of
                Nothing ->
                    False

                Just input ->
                    List.all isOptional input.fields

        _ ->
            False


requiredAnnotationRecursiveHelper :
    String
    -> GraphQL.Schema.Schema
    -> Type
    -> Wrapped
    -> Elm.Annotation.Annotation
requiredAnnotationRecursiveHelper namespace schema type_ wrapped =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            requiredAnnotationRecursiveHelper namespace schema newType (InMaybe wrapped)

        GraphQL.Schema.Type.List_ newType ->
            requiredAnnotationRecursiveHelper namespace schema newType (InList wrapped)

        GraphQL.Schema.Type.Scalar scalarName ->
            scalarType wrapped scalarName

        GraphQL.Schema.Type.Enum enumName ->
            Elm.Annotation.named
                (Elm.moduleName [ namespace, "Enum", enumName ])
                enumName
                |> unwrapWith wrapped

        GraphQL.Schema.Type.Object nestedObjectName ->
            Engine.typeSelection.annotation
                (Elm.Annotation.var nestedObjectName)
                (Elm.Annotation.var "data")

        GraphQL.Schema.Type.InputObject inputName ->
            --let
            --    _ =
            --        Debug.log "ANNOATIONS FOR " inputName
            --in
            case Dict.get inputName schema.inputObjects of
                Nothing ->
                    annotations.arg namespace inputName
                        |> unwrapWith wrapped

                Just input ->
                    case splitRequired input.fields of
                        ( [], [] ) ->
                            annotations.arg namespace inputName
                                |> unwrapWith wrapped

                        ( required, [] ) ->
                            Elm.Annotation.record
                                (List.map
                                    (\field ->
                                        ( field.name
                                        , requiredAnnotationRecursiveHelper namespace
                                            schema
                                            field.type_
                                            UnwrappedValue
                                        )
                                    )
                                    input.fields
                                )
                                |> unwrapWith wrapped

                        ( [], optional ) ->
                            annotations.arg namespace inputName
                                |> unwrapWith wrapped

                        ( required, optional ) ->
                            Elm.Annotation.record
                                (List.map
                                    (\field ->
                                        ( field.name
                                        , requiredAnnotationRecursiveHelper inputName
                                            schema
                                            field.type_
                                            UnwrappedValue
                                        )
                                    )
                                    required
                                    ++ [ ( "optional"
                                         , annotations.optional namespace inputName
                                            |> Elm.Annotation.list
                                         )
                                       ]
                                )
                                |> unwrapWith wrapped

        GraphQL.Schema.Type.Union unionName ->
            Elm.Annotation.unit

        GraphQL.Schema.Type.Interface interfaceName ->
            Elm.Annotation.unit


requiredAnnotation : String -> List { a | name : String, type_ : Type } -> Elm.Annotation.Annotation
requiredAnnotation namespace reqs =
    Elm.Annotation.record
        (List.map
            (\field ->
                ( field.name
                , requiredAnnotationHelper namespace field.type_ UnwrappedValue
                )
            )
            reqs
        )


requiredAnnotationHelper : String -> Type -> Wrapped -> Elm.Annotation.Annotation
requiredAnnotationHelper namespace type_ wrapped =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            requiredAnnotationHelper namespace newType (InMaybe wrapped)

        GraphQL.Schema.Type.List_ newType ->
            requiredAnnotationHelper namespace newType (InList wrapped)

        GraphQL.Schema.Type.Scalar scalarName ->
            scalarType wrapped scalarName

        GraphQL.Schema.Type.Enum enumName ->
            Elm.Annotation.named (Elm.moduleName [ namespace, "Enum", enumName ]) enumName
                |> unwrapWith wrapped

        GraphQL.Schema.Type.Object nestedObjectName ->
            Engine.typeSelection.annotation (Elm.Annotation.var nestedObjectName)
                (Elm.Annotation.var "data")

        GraphQL.Schema.Type.InputObject inputName ->
            annotations.arg namespace inputName
                |> unwrapWith wrapped

        GraphQL.Schema.Type.Union unionName ->
            -- Note, we need a discriminator instead of just `data`
            Engine.typeSelection.annotation (Elm.Annotation.var unionName)
                (Elm.Annotation.var "data")
                |> unwrapWith wrapped

        GraphQL.Schema.Type.Interface interfaceName ->
            Elm.Annotation.unit


prepareRequired :
    String
    -> { a | name : String, type_ : Type }
    -> Elm.Expression
prepareRequired namespace argument =
    Elm.tuple
        (Elm.string argument.name)
        (encodeInput namespace
            argument.type_
            UnwrappedValue
            (Elm.get argument.name (Elm.value "required")
                |> Elm.withAnnotation
                    (annotations.arg namespace argument.name)
            )
        )


prepareRequiredRecursive :
    String
    -> GraphQL.Schema.Schema
    -> { a | name : String, type_ : Type }
    -> Elm.Expression
prepareRequiredRecursive namespace schema argument =
    Elm.tuple
        (Elm.string argument.name)
        (encodeInputExhaustive schema
            namespace
            argument.type_
            UnwrappedValue
            (Elm.get argument.name (Elm.value "required")
             --|> Elm.withAnnotation
             --    (Engine.typeArgument.annotation
             --        (Elm.Annotation.named
             --            (Elm.moduleName [ namespace, "Input" ])
             --            argument.name
             --        )
             --    )
            )
        )


{-|

    1 . get all optional sets

    2 . hoist them to the top

-}
recursiveOptionalMaker :
    String
    -> GraphQL.Schema.Schema
    -> String
    -> List GraphQL.Schema.Argument.Argument
    -> List Elm.Declaration
recursiveOptionalMaker namespace schema name args =
    let
        ( _, opts ) =
            getOptionals name
                schema
                Set.empty
                []
                []
                args
                True
    in
    List.concatMap
        (\options ->
            List.filterMap identity
                [ Elm.fn options.namespace
                    ( "optional"
                    , Elm.Annotation.list
                        (annotations.optional namespace options.namespace)
                    )
                    (\opt ->
                        Engine.encodeInputObject
                            (Engine.encodeOptionals
                                opt
                            )
                            (Elm.string options.namespace)
                            |> Elm.withAnnotation
                                (annotations.arg namespace options.namespace)
                    )
                    |> Elm.expose
                    |> justIf (not options.topLevel)
                , optionalMakerExhaustive namespace schema options.namespace options.options
                    |> Elm.expose
                    |> Just
                ]
        )
        opts


type alias OptionGroup =
    { topLevel : Bool
    , namespace : String
    , options : List GraphQL.Schema.Argument.Argument
    }


getOptionals :
    String
    -> GraphQL.Schema.Schema
    -> Set String
    -> List GraphQL.Schema.Argument.Argument
    -> List OptionGroup
    -> List GraphQL.Schema.Argument.Argument
    -> Bool
    -> ( Set String, List OptionGroup )
getOptionals name schema captured topLevel nested args isTopLevel =
    case args of
        [] ->
            case topLevel of
                [] ->
                    ( captured, nested )

                _ ->
                    ( captured
                    , { namespace = name
                      , topLevel = isTopLevel
                      , options = topLevel
                      }
                        :: nested
                    )

        topArg :: remaining ->
            let
                newTop =
                    if isOptional topArg then
                        topArg :: topLevel

                    else
                        topLevel

                ( newCaptured, newNested ) =
                    getNested schema captured topArg.type_
            in
            getOptionals name schema newCaptured newTop (newNested ++ nested) remaining isTopLevel


toArg field =
    { name = field.name
    , description = field.description
    , type_ = field.type_
    }


getNested :
    GraphQL.Schema.Schema
    -> Set String
    -> Type
    -> ( Set String, List OptionGroup )
getNested schema captured type_ =
    case type_ of
        Scalar _ ->
            ( captured, [] )

        InputObject inputName ->
            case Dict.get inputName schema.inputObjects of
                Nothing ->
                    ( captured, [] )

                Just input ->
                    if Set.member input.name captured then
                        ( captured, [] )

                    else
                        getOptionals input.name
                            schema
                            (Set.insert input.name captured)
                            []
                            []
                            (List.map toArg input.fields)
                            False

        Object name ->
            ( captured, [] )

        Enum name ->
            ( captured, [] )

        Union name ->
            ( captured, [] )

        Interface name ->
            ( captured, [] )

        List_ inner ->
            getNested schema captured inner

        Nullable inner ->
            getNested schema captured inner


optionalMakerExhaustive :
    String
    -> GraphQL.Schema.Schema
    -> String
    ->
        List
            { fieldOrArg
                | name : String
                , type_ : Type
                , description : Maybe String
            }
    -> Elm.Declaration
optionalMakerExhaustive namespace schema name options =
    createOptionalCreatorHelperExhaustive
        namespace
        schema
        name
        options
        []


annotations =
    { optional =
        \namespace name ->
            Engine.typeOptional.annotation
                (Elm.Annotation.named
                    (Elm.moduleName [ namespace, "Object" ])
                    name
                )
    , arg =
        \namespace name ->
            Engine.typeArgument.annotation
                (Elm.Annotation.named
                    (Elm.moduleName [ namespace, "Object" ])
                    name
                )
    }


createOptionalCreatorHelperExhaustive :
    String
    -> GraphQL.Schema.Schema
    -> String
    ->
        List
            { field
                | name : String
                , description : Maybe String
                , type_ : Type
            }
    -> List ( String, Elm.Expression )
    -> Elm.Declaration
createOptionalCreatorHelperExhaustive namespace schema name options fields =
    case options of
        [] ->
            Elm.declaration (Utils.String.formatValue (name ++ "Options"))
                (Elm.record fields)

        arg :: remain ->
            let
                implemented =
                    encodeInputExhaustive schema
                        namespace
                        arg.type_
                        UnwrappedValue
                        (Elm.valueWith
                            Elm.local
                            "val"
                            --(requiredAnnotationHelper namespace arg.type_ UnwrappedValue)
                            (requiredAnnotationRecursiveHelper namespace schema arg.type_ UnwrappedValue)
                        )
                        |> Elm.withAnnotation
                            (annotations.arg namespace name)
                        |> Engine.optional
                            (Elm.string arg.name)
                        |> Elm.withAnnotation
                            (annotations.optional namespace name)
            in
            createOptionalCreatorHelperExhaustive namespace
                schema
                name
                remain
                (( arg.name
                 , Elm.lambdaWith
                    [ ( Elm.Pattern.var "val"
                      , -- This decides whether to have the arguments inline or not.
                        -- i.e. { arg: String} -> Argument
                        -- vs   Argument Object -> Argument
                        --if isInnerOptional schema arg then
                        --    requiredAnnotationHelper namespace arg.type_ UnwrappedValue
                        --
                        --else
                        requiredAnnotationRecursiveHelper namespace schema arg.type_ UnwrappedValue
                      )
                    ]
                    implemented
                 )
                    :: fields
                )


optionalMaker :
    String
    -> String
    ->
        List
            { fieldOrArg
                | name : String
                , type_ : Type
                , description : Maybe String
            }
    -> Elm.Declaration
optionalMaker namespace name options =
    createOptionalCreatorHelper namespace name options []


createOptionalCreatorHelper :
    String
    -> String
    ->
        List
            { field
                | name : String
                , description : Maybe String
                , type_ : Type
            }
    -> List ( String, Elm.Expression )
    -> Elm.Declaration
createOptionalCreatorHelper namespace name options fields =
    case options of
        [] ->
            Elm.declaration (Utils.String.formatValue (name ++ "Options"))
                (Elm.record fields)

        arg :: remain ->
            let
                implemented =
                    encodeInput namespace
                        arg.type_
                        UnwrappedValue
                        (Elm.valueWith
                            Elm.local
                            "val"
                            (requiredAnnotationHelper namespace arg.type_ UnwrappedValue)
                        )
                        |> Elm.withAnnotation
                            (annotations.arg namespace name)
                        |> Engine.optional
                            (Elm.string arg.name)
                        |> Elm.withAnnotation
                            (annotations.optional namespace name)
            in
            createOptionalCreatorHelper namespace
                name
                remain
                (( arg.name
                 , Elm.lambdaWith
                    [ ( Elm.Pattern.var "val"
                      , requiredAnnotationHelper namespace arg.type_ UnwrappedValue
                      )
                    ]
                    implemented
                 )
                    :: fields
                )


encodeInput :
    String
    -> Type
    -> Wrapped
    -> Elm.Expression
    -> Elm.Expression
encodeInput namespace fieldType wrapped val =
    case fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            encodeInput namespace newType (InMaybe wrapped) val

        GraphQL.Schema.Type.List_ newType ->
            encodeInput namespace newType (InList wrapped) val

        GraphQL.Schema.Type.Scalar scalarName ->
            Engine.arg
                (encodeScalar scalarName
                    wrapped
                    val
                )
                (Elm.string scalarName)

        GraphQL.Schema.Type.Enum enumName ->
            --This can either be
            --     val -> Enum.encode val
            --     val ->
            --          Encode.list Enum.encode val
            --     val ->
            --          Engine.encodeMaybe Enum.encode val
            --     or some stack
            --     val ->
            --          Encode.list (Encode.list Enum.encode) val
            --
            Engine.arg
                (encodeWrapped wrapped
                    (\v ->
                        Elm.apply
                            (Elm.valueFrom (Elm.moduleName [ namespace, "Enum", enumName ]) "encode")
                            [ v
                            ]
                    )
                    val
                )
                (Elm.string enumName)

        GraphQL.Schema.Type.InputObject inputName ->
            Engine.arg
                (encodeWrapped wrapped
                    Engine.encodeArgument
                    val
                )
                (Elm.string inputName)

        GraphQL.Schema.Type.Union unionName ->
            Elm.string "Unions cant be nested in inputs"

        GraphQL.Schema.Type.Object nestedObjectName ->
            Elm.string "Objects cant be nested in inputs"

        GraphQL.Schema.Type.Interface interfaceName ->
            Elm.string "Interfaces cant be in inputs"


encodeInputExhaustive :
    GraphQL.Schema.Schema
    -> String
    -> Type
    -> Wrapped
    -> Elm.Expression
    -> Elm.Expression
encodeInputExhaustive schema namespace fieldType wrapped val =
    case fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            encodeInputExhaustive schema namespace newType (InMaybe wrapped) val

        GraphQL.Schema.Type.List_ newType ->
            encodeInputExhaustive schema namespace newType (InList wrapped) val

        GraphQL.Schema.Type.Scalar scalarName ->
            Engine.arg
                (encodeScalar scalarName
                    wrapped
                    val
                )
                (Elm.string scalarName)

        GraphQL.Schema.Type.Enum enumName ->
            --This can either be
            --     val -> Enum.encode val
            --     val ->
            --          Encode.list Enum.encode val
            --     val ->
            --          Engine.encodeMaybe Enum.encode val
            --     or some stack
            --     val ->
            --          Encode.list (Encode.list Enum.encode) val
            --
            Engine.arg
                (encodeWrapped wrapped
                    (\v ->
                        Elm.apply
                            (Elm.valueFrom (Elm.moduleName [ namespace, "Enum", enumName ]) "encode")
                            [ v
                            ]
                    )
                    val
                )
                (Elm.string enumName)

        GraphQL.Schema.Type.InputObject inputName ->
            case Dict.get inputName schema.inputObjects of
                Nothing ->
                    Engine.arg
                        (encodeWrapped wrapped
                            Engine.encodeArgument
                            val
                        )
                        (Elm.string inputName)

                Just input ->
                    if List.all isOptional input.fields then
                        Engine.arg
                            (encodeWrapped wrapped
                                Engine.encodeArgument
                                val
                            )
                            (Elm.string inputName)

                    else
                        case input.fields of
                            [] ->
                                Engine.arg
                                    (encodeWrapped wrapped
                                        Engine.encodeArgument
                                        val
                                    )
                                    (Elm.string input.name)

                            many ->
                                encodeWrappedArgument wrapped
                                    (\v ->
                                        let
                                            requiredVals =
                                                List.map
                                                    (\field ->
                                                        Elm.tuple
                                                            (Elm.string field.name)
                                                            (encodeInputExhaustive schema
                                                                namespace
                                                                field.type_
                                                                UnwrappedValue
                                                                (Elm.get field.name v)
                                                            )
                                                    )
                                                    (List.filter (not << isOptional) many)
                                                    |> Elm.list
                                        in
                                        Engine.encodeInputObject
                                            (if List.any isOptional input.fields then
                                                Elm.Gen.List.append
                                                    requiredVals
                                                    (Engine.encodeOptionals
                                                        (Elm.get "optional" v)
                                                    )

                                             else
                                                requiredVals
                                            )
                                            (Elm.string input.name)
                                    )
                                    val

        GraphQL.Schema.Type.Union unionName ->
            Elm.string "Unions cant be nested in inputs"

        GraphQL.Schema.Type.Object nestedObjectName ->
            Elm.string "Objects cant be nested in inputs"

        GraphQL.Schema.Type.Interface interfaceName ->
            Elm.string "Interfaces cant be in inputs"


{-|

    Unwrapped ->
        val.name

    Maybe ->
        Maybe.map
            (\v -> v.name)
            val

    List ->
        List.map
            (\v -> v.name)
            val

-}
wrapGet wrapped selector val =
    case wrapped of
        UnwrappedValue ->
            Elm.get selector val

        InMaybe inner ->
            Elm.Gen.Maybe.map
                (\v ->
                    Elm.lambda "inner"
                        Elm.Annotation.unit
                        (\within ->
                            wrapGet inner selector within
                        )
                )
                val

        InList inner ->
            Elm.Gen.List.map
                (\v ->
                    Elm.lambda "inner"
                        Elm.Annotation.unit
                        (\within ->
                            wrapGet inner selector within
                        )
                )
                val


{-|

    encoder is really something that converts the whole thing
    to an Argument

    So, this encodeWrappedArgument does the following


    UnwrappedValue ->
        encode val


    InMaybe ->
            case val of
                Just inner ->
                    encoder inner

                Nothing ->
                    Engine.arg Encode.null "Actual type"

-}
encodeWrappedArgument wrapper encoder val =
    case wrapper of
        UnwrappedValue ->
            encoder val

        InMaybe inner ->
            Elm.caseOf val
                [ ( Elm.Pattern.named "Just" [ Elm.Pattern.var "item" ]
                  , encodeWrappedArgument inner encoder (Elm.value "item")
                  )
                , ( Elm.Pattern.named "Nothing" []
                  , Engine.arg Encode.null (Elm.string "Unknown")
                  )
                ]

        InList inner ->
            -- TODO!!!
            encodeWrappedArgument inner encoder val


{-|

    Uses Engine.maybeScalarEncode to

-}
encodeWrapped wrapper encoder val =
    case wrapper of
        UnwrappedValue ->
            encoder val

        InMaybe inner ->
            encodeWrapped inner (Engine.maybeScalarEncode encoder) val

        InList inner ->
            encodeWrapped inner (Encode.list encoder) val


wrapAnnotation : Wrapped -> Elm.Annotation.Annotation -> Elm.Annotation.Annotation
wrapAnnotation wrap signature =
    case wrap of
        UnwrappedValue ->
            signature

        InList inner ->
            Elm.Annotation.list (wrapAnnotation inner signature)

        InMaybe inner ->
            Elm.Annotation.maybe (wrapAnnotation inner signature)


unwrapExpression : Wrapped -> Elm.Expression -> Elm.Expression
unwrapExpression wrap exp =
    case wrap of
        UnwrappedValue ->
            exp

        InList inner ->
            Decode.list
                (unwrapExpression inner exp)

        InMaybe inner ->
            Engine.nullable
                (unwrapExpression inner exp)



{- CREATE BUILDER -}


createBuilder :
    String
    -> GraphQL.Schema.Schema
    -> String
    ->
        List
            { fieldOrArg
                | name : String.String
                , description : Maybe String.String
                , type_ : Type
            }
    -> Type
    -> Elm.Declaration
createBuilder namespace schema name arguments returnType =
    let
        ( required, optional ) =
            splitRequired
                arguments

        hasRequiredArgs =
            case required of
                [] ->
                    False

                _ ->
                    True

        hasOptionalArgs =
            case optional of
                [] ->
                    False

                _ ->
                    True

        anchor =
            Generate.Common.gqlTypeToElmTypeAnnotation namespace returnType Nothing

        expression =
            Engine.objectWith
                (if hasOptionalArgs && hasRequiredArgs then
                    Elm.Gen.List.append
                        (Elm.list
                            (required
                                |> List.map (prepareRequiredRecursive namespace schema)
                            )
                        )
                        (Engine.encodeOptionals
                            (Elm.valueWith
                                (Elm.moduleName [])
                                "optional"
                                (Elm.Annotation.list
                                    (annotations.optional namespace name)
                                )
                            )
                        )

                 else if hasOptionalArgs then
                    Engine.encodeOptionals
                        (Elm.valueWith
                            (Elm.moduleName [])
                            "optional"
                            (Elm.Annotation.list
                                (annotations.optional namespace name)
                            )
                        )

                 else if hasRequiredArgs then
                    Elm.list
                        (required
                            |> List.map (prepareRequiredRecursive namespace schema)
                        )

                 else
                    Elm.list []
                )
                (Elm.string name)
                (Elm.valueWith (Elm.moduleName [])
                    "selection"
                    (Engine.typeSelection.annotation anchor (Elm.Annotation.var "data"))
                )
                |> Elm.withAnnotation
                    (Engine.typeSelection.annotation Engine.typeQuery.annotation (Elm.Annotation.var "data"))
    in
    Elm.functionWith name
        (List.filterMap identity
            [ justIf hasRequiredArgs
                ( recursiveRequiredAnnotation namespace schema required
                , Elm.Pattern.var "required"
                )
            , justIf hasOptionalArgs
                ( Elm.Annotation.list
                    (annotations.optional namespace name)
                , Elm.Pattern.var "optional"
                )
            , Just
                ( Engine.typeSelection.annotation anchor (Elm.Annotation.var "data")
                , Elm.Pattern.var "selection"
                )
            ]
        )
        expression
        |> Elm.expose


justIf : Bool -> a -> Maybe a
justIf condition val =
    if condition then
        Just val

    else
        Nothing

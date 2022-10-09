module Generate.Args exposing
    ( annotation
    , createBuilder
    , encodeWrapped
    , inputTypeToString
    , nullsRecord
    , optionsRecursive
    , toEngineArg
    , toJsonValue
    , unwrapWith
    )

import Dict
import Elm
import Elm.Annotation
import Elm.Case
import Gen.GraphQL.Engine as Engine
import Gen.Json.Encode as Encode
import Gen.List
import Gen.Maybe
import Generate.Common
import Generate.Input as Input
import Generate.Input.Encode
import Generate.Scalar
import GraphQL.Schema
import Set exposing (Set)
import String
import Utils.String


embeddedOptionsFieldName : String
embeddedOptionsFieldName =
    "optional_"


unwrapWith :
    GraphQL.Schema.Wrapped
    -> Elm.Annotation.Annotation
    -> Elm.Annotation.Annotation
unwrapWith wrapped expression =
    case wrapped of
        GraphQL.Schema.InList inner ->
            Elm.Annotation.list
                (unwrapWith inner expression)

        GraphQL.Schema.InMaybe inner ->
            Elm.Annotation.maybe
                (unwrapWith inner expression)

        GraphQL.Schema.UnwrappedValue ->
            expression


{-|

    list : (a -> Json.Encode.Value) -> List a -> Json.Encode.Value

-}
encodeList : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
encodeList fn listExpr =
    Elm.apply
        (Elm.value
            { importFrom = [ "Json", "Encode" ]
            , name = "list"
            , annotation =
                Just
                    (Elm.Annotation.function
                        [ Elm.Annotation.function
                            [ Elm.Annotation.var "a" ]
                            (Elm.Annotation.namedWith [ "Json", "Encode" ] "Value" [])
                        , Elm.Annotation.list (Elm.Annotation.var "a")
                        ]
                        (Elm.Annotation.namedWith [ "Json", "Encode" ] "Value" [])
                    )
            }
        )
        [ Elm.functionReduced "listUnpack" fn, listExpr ]


{-| Searches the schema and realizes the arguemnts in one annotation.

Required arguments -> as a record
Optional arguments -> as a list of optionals
Both -> record with a special field

-}
recursiveRequiredAnnotation :
    Namespace
    -> GraphQL.Schema.Schema
    ->
        List
            { fieldOrArg
                | name : String.String
                , description : Maybe String.String
                , type_ : GraphQL.Schema.Type
            }
    -> Elm.Annotation.Annotation
recursiveRequiredAnnotation namespace schema reqs =
    Elm.Annotation.record
        (List.map
            (\field ->
                ( field.name
                , inputAnnotationRecursive
                    namespace
                    schema
                    field.type_
                    (GraphQL.Schema.getWrap field.type_)
                    { ergonomicOptionType = False }
                )
            )
            reqs
        )



-- prepareRequiredRecursive :
--     Namespace
--     -> GraphQL.Schema.Schema
--     -> { a | name : String, type_ : GraphQL.Schema.Type }
--     -> Elm.Expression
-- prepareRequiredRecursive namespace schema argument =
--     Elm.tuple
--         (Elm.string argument.name)
--         (toEngineArg
--             namespace
--             schema
--             argument.type_
--             (GraphQL.Schema.getWrap argument.type_)
--             (Elm.get argument.name (Elm.value { importFrom = [], name = "required", annotation = Nothing} ))
--         )


type alias OptionGroup =
    { topLevel : Bool
    , namespace : String
    , options : List GraphQL.Schema.Argument
    }


getOptionals :
    String
    -> GraphQL.Schema.Schema
    -> Set String
    -> List GraphQL.Schema.Argument
    -> List OptionGroup
    -> List GraphQL.Schema.Argument
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
                    if Input.isOptional topArg then
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
    -> GraphQL.Schema.Type
    -> ( Set String, List OptionGroup )
getNested schema captured type_ =
    case type_ of
        GraphQL.Schema.Scalar _ ->
            ( captured, [] )

        GraphQL.Schema.InputObject inputName ->
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

        GraphQL.Schema.Object name ->
            ( captured, [] )

        GraphQL.Schema.Enum name ->
            ( captured, [] )

        GraphQL.Schema.Union name ->
            ( captured, [] )

        GraphQL.Schema.Interface name ->
            ( captured, [] )

        GraphQL.Schema.List_ inner ->
            getNested schema captured inner

        GraphQL.Schema.Nullable inner ->
            getNested schema captured inner


annotations :
    { optional : String -> String -> Elm.Annotation.Annotation
    , safeOptional : String -> String -> Elm.Annotation.Annotation
    , ergonomicOptional : String -> String -> Elm.Annotation.Annotation
    , localOptional : a -> b -> Elm.Annotation.Annotation
    , arg : Namespace -> String -> Elm.Annotation.Annotation
    }
annotations =
    { optional =
        \namespace name ->
            Elm.Annotation.namedWith
                (Generate.Common.modules.input namespace name)
                "Optional"
                []
    , safeOptional =
        -- safe optional needs to be of the form of
        -- Engine.Optional BaseThing
        -- This is needed within Optional files to avoid circular imports
        \namespace name ->
            Elm.Annotation.named [ namespace ]
                name
                |> Engine.annotation_.optional
    , ergonomicOptional =
        -- ergonomic optional is of the form BaseThing.Optional
        -- More ergonomic, but can only be used in operational queries
        \namespace name ->
            Elm.Annotation.named [ namespace, name ]
                "Optional"
    , localOptional =
        \namespace name ->
            Elm.Annotation.namedWith
                []
                "Optional"
                []
    , arg =
        \namespace name ->
            Generate.Common.ref namespace name
    }


{-|

    Creates a `nulls` record that looks like


    null =
        { fieldOne
        , fieldTwo
        }

-}
nullsRecord :
    Namespace
    -> String
    ->
        List
            { fieldOrArg
                | name : String
                , type_ : GraphQL.Schema.Type
                , description : Maybe String
            }
    -> Elm.Expression
nullsRecord namespace name fields =
    Elm.record
        (List.map
            (\field ->
                ( field.name
                , Engine.arg Encode.null (inputTypeToString field.type_)
                    |> Engine.optional
                        field.name
                    |> Elm.withType
                        (annotations.localOptional namespace.namespace name)
                )
            )
            fields
        )


{-|

    The `recursive` part means it's going to jump into the schema in order to figure out how to encode the various inputs

    Instead of making you do it yourself.

-}
optionsRecursive :
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    ->
        List
            { fieldOrArg
                | name : String
                , type_ : GraphQL.Schema.Type
                , description : Maybe String
            }
    -> List Elm.Declaration
optionsRecursive namespace schema name options =
    optionsRecursiveHelper namespace schema name options []


optionsRecursiveHelper :
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    ->
        List
            { field
                | name : String
                , description : Maybe String
                , type_ : GraphQL.Schema.Type
            }
    -> List Elm.Declaration
    -> List Elm.Declaration
optionsRecursiveHelper namespace schema name options fields =
    case options of
        [] ->
            fields

        arg :: remain ->
            let
                wrapping =
                    case GraphQL.Schema.getWrap arg.type_ of
                        GraphQL.Schema.InMaybe inner ->
                            inner

                        otherwise ->
                            otherwise
            in
            optionsRecursiveHelper namespace
                schema
                name
                remain
                ((Elm.fn
                    ( "val"
                    , inputAnnotationRecursive namespace schema arg.type_ wrapping { ergonomicOptionType = False }
                        |> Just
                    )
                    (\val ->
                        toEngineArg namespace
                            schema
                            arg.type_
                            wrapping
                            val
                            |> Elm.withType
                                (annotations.arg namespace name)
                            |> Engine.optional
                                arg.name
                            |> Elm.withType
                                (annotations.localOptional namespace name)
                    )
                    |> Elm.declaration arg.name
                    |> Elm.expose
                 )
                    :: fields
                )


inputAnnotationRecursive :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.Type
    -> GraphQL.Schema.Wrapped
    -> { ergonomicOptionType : Bool }
    -> Elm.Annotation.Annotation
inputAnnotationRecursive namespace schema type_ wrapped optForm =
    case type_ of
        GraphQL.Schema.Nullable newType ->
            inputAnnotationRecursive namespace schema newType wrapped optForm

        GraphQL.Schema.List_ newType ->
            inputAnnotationRecursive namespace schema newType wrapped optForm

        GraphQL.Schema.Scalar scalarName ->
            Generate.Input.Encode.scalarType namespace wrapped scalarName

        GraphQL.Schema.Enum enumName ->
            Elm.Annotation.named
                (Generate.Common.modules.enum namespace enumName)
                enumName
                |> unwrapWith wrapped

        GraphQL.Schema.InputObject inputName ->
            case Dict.get inputName schema.inputObjects of
                Nothing ->
                    annotations.arg namespace inputName
                        |> unwrapWith wrapped

                Just input ->
                    inputObjectAnnotation namespace
                        schema
                        input
                        wrapped
                        optForm

        GraphQL.Schema.Object nestedObjectName ->
            -- not used as input
            Generate.Common.selection namespace.namespace
                nestedObjectName
                (Elm.Annotation.var "data")

        GraphQL.Schema.Union unionName ->
            -- not used as input
            -- Note, we need a discriminator instead of just `data`
            Generate.Common.selection namespace.namespace
                unionName
                (Elm.Annotation.var "data")
                |> unwrapWith wrapped

        GraphQL.Schema.Interface interfaceName ->
            -- not used as input
            Elm.Annotation.unit


inputObjectAnnotation :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.InputObjectDetails
    -> GraphQL.Schema.Wrapped
    -> { ergonomicOptionType : Bool }
    -> Elm.Annotation.Annotation
inputObjectAnnotation namespace schema input wrapped optForm =
    let
        inputName =
            input.name
    in
    case Input.splitRequired input.fields of
        ( [], [] ) ->
            annotations.arg namespace inputName
                |> unwrapWith wrapped

        ( required, [] ) ->
            Elm.Annotation.record
                (List.map
                    (\field ->
                        ( field.name
                        , inputAnnotationRecursive
                            namespace
                            schema
                            field.type_
                            (GraphQL.Schema.getWrap field.type_)
                            optForm
                        )
                    )
                    input.fields
                )
                |> unwrapWith wrapped

        ( [], optional ) ->
            if optForm.ergonomicOptionType then
                annotations.ergonomicOptional namespace.namespace inputName
                    |> Elm.Annotation.list
                    |> unwrapWith wrapped

            else
                annotations.safeOptional namespace.namespace inputName
                    |> Elm.Annotation.list
                    |> unwrapWith wrapped

        ( required, optional ) ->
            Elm.Annotation.record
                (List.map
                    (\field ->
                        ( field.name
                        , inputAnnotationRecursive
                            namespace
                            schema
                            field.type_
                            (GraphQL.Schema.getWrap field.type_)
                            optForm
                        )
                    )
                    required
                    ++ [ ( embeddedOptionsFieldName
                         , annotations.optional namespace.namespace inputName
                            |> Elm.Annotation.list
                         )
                       ]
                )
                |> unwrapWith wrapped


type alias Namespace =
    { namespace : String
    , enums : String
    }


{-|

    Take an input

-}
toJsonValue :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.Type
    -> GraphQL.Schema.Wrapped
    -> Elm.Expression
    -> Elm.Expression
toJsonValue namespace schema fieldType wrapped val =
    case fieldType of
        GraphQL.Schema.Nullable newType ->
            toJsonValue namespace schema newType wrapped val

        GraphQL.Schema.List_ newType ->
            toJsonValue namespace schema newType wrapped val

        GraphQL.Schema.Scalar scalarName ->
            Generate.Scalar.encode namespace
                scalarName
                wrapped
                val

        GraphQL.Schema.Enum enumName ->
            Generate.Input.Encode.encodeEnum namespace wrapped val enumName

        GraphQL.Schema.InputObject inputName ->
            case Dict.get inputName schema.inputObjects of
                Nothing ->
                    encodeInputObjectArg inputName wrapped val 0

                Just input ->
                    if List.all Input.isOptional input.fields then
                        encodeInputObjectArg inputName wrapped val 0

                    else
                        case input.fields of
                            [] ->
                                encodeInputObjectArg inputName wrapped val 0

                            many ->
                                encodeWrappedJsonValue input.name
                                    wrapped
                                    (\v ->
                                        let
                                            requiredVals =
                                                List.map
                                                    (\field ->
                                                        Elm.tuple
                                                            (Elm.string field.name)
                                                            (toJsonValue namespace
                                                                schema
                                                                field.type_
                                                                (GraphQL.Schema.getWrap field.type_)
                                                                (Elm.get field.name v)
                                                            )
                                                    )
                                                    (List.filter (not << Input.isOptional) many)
                                                    |> Elm.list
                                        in
                                        if List.any Input.isOptional input.fields then
                                            Gen.List.call_.append
                                                requiredVals
                                                (Engine.call_.encodeOptionalsAsJson
                                                    (Elm.get embeddedOptionsFieldName v)
                                                )
                                                |> Encode.call_.object

                                        else
                                            Encode.call_.object requiredVals
                                    )
                                    val

        GraphQL.Schema.Union unionName ->
            Elm.string "Unions cant be nested in inputs"

        GraphQL.Schema.Object nestedObjectName ->
            Elm.string "Objects cant be nested in inputs"

        GraphQL.Schema.Interface interfaceName ->
            Elm.string "Interfaces cant be in inputs"


{-| -}
encodeWrappedJsonValue : String -> GraphQL.Schema.Wrapped -> (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
encodeWrappedJsonValue inputName wrapper encoder val =
    case wrapper of
        GraphQL.Schema.UnwrappedValue ->
            encoder val

        GraphQL.Schema.InMaybe inner ->
            let
                valName =
                    addCount inner (Utils.String.formatValue inputName)
            in
            Elm.Case.maybe val
                { just = ( "item", encodeWrappedJsonValue valName inner encoder )
                , nothing = Encode.null
                }

        GraphQL.Schema.InList inner ->
            let
                valName =
                    addCount inner (Utils.String.formatValue inputName)
            in
            -- Engine.argList
            encodeList
                (\v ->
                    Elm.fn
                        ( valName
                        , Just Elm.Annotation.unit
                        )
                        (\within ->
                            encodeWrappedJsonValue valName inner encoder within
                        )
                )
                val


toEngineArg :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.Type
    -> GraphQL.Schema.Wrapped
    -> Elm.Expression
    -> Elm.Expression
toEngineArg namespace schema fieldType wrapped val =
    case fieldType of
        GraphQL.Schema.Nullable newType ->
            toEngineArg namespace schema newType wrapped val

        GraphQL.Schema.List_ newType ->
            toEngineArg namespace schema newType wrapped val

        GraphQL.Schema.Scalar scalarName ->
            Engine.arg
                (Generate.Scalar.encode namespace
                    scalarName
                    wrapped
                    val
                )
                (Input.gqlType wrapped scalarName)

        GraphQL.Schema.Enum enumName ->
            Engine.arg
                (Generate.Input.Encode.encodeEnum namespace wrapped val enumName)
                (Input.gqlType wrapped enumName)

        GraphQL.Schema.InputObject inputName ->
            case Dict.get inputName schema.inputObjects of
                Nothing ->
                    Engine.arg
                        (encodeInputObjectArg inputName wrapped val 0)
                        inputName

                Just input ->
                    if List.all Input.isOptional input.fields then
                        Engine.arg
                            (encodeInputObjectArg inputName wrapped val 0)
                            (Input.gqlType wrapped inputName)

                    else
                        case input.fields of
                            [] ->
                                Engine.arg
                                    (encodeInputObjectArg inputName wrapped val 0)
                                    (Input.gqlType wrapped input.name)

                            many ->
                                encodeWrappedArgument input.name
                                    wrapped
                                    (\v ->
                                        let
                                            requiredVals =
                                                List.map
                                                    (\field ->
                                                        Elm.tuple
                                                            (Elm.string field.name)
                                                            (toEngineArg namespace
                                                                schema
                                                                field.type_
                                                                (GraphQL.Schema.getWrap field.type_)
                                                                (Elm.get field.name v)
                                                            )
                                                    )
                                                    (List.filter (not << Input.isOptional) many)
                                                    |> Elm.list
                                        in
                                        Engine.call_.encodeInputObject
                                            (if List.any Input.isOptional input.fields then
                                                Gen.List.call_.append
                                                    requiredVals
                                                    (Engine.call_.encodeOptionals
                                                        (Elm.get embeddedOptionsFieldName v)
                                                    )

                                             else
                                                requiredVals
                                            )
                                            (Elm.string (Input.gqlType GraphQL.Schema.UnwrappedValue input.name))
                                    )
                                    val

        GraphQL.Schema.Union unionName ->
            Elm.string "Unions cant be nested in inputs"

        GraphQL.Schema.Object nestedObjectName ->
            Elm.string "Objects cant be nested in inputs"

        GraphQL.Schema.Interface interfaceName ->
            Elm.string "Interfaces cant be in inputs"


encodeInputObjectArg : String -> GraphQL.Schema.Wrapped -> Elm.Expression -> Int -> Elm.Expression
encodeInputObjectArg inputName wrapper val level =
    case wrapper of
        GraphQL.Schema.UnwrappedValue ->
            -- encoder val
            Engine.call_.encodeInputObject
                (Engine.call_.encodeOptionals
                    val
                )
                (Elm.string inputName)
                |> Engine.encodeArgument

        GraphQL.Schema.InMaybe inner ->
            Engine.call_.maybeScalarEncode
                (Elm.fn
                    ( "o" ++ String.fromInt level
                    , Just Elm.Annotation.unit
                    )
                    (\o ->
                        encodeInputObjectArg inputName inner o (level + 1)
                    )
                )
                val

        GraphQL.Schema.InList inner ->
            Encode.call_.list
                (Elm.fn
                    ( "o" ++ String.fromInt level
                    , Just Elm.Annotation.unit
                    )
                    (\o ->
                        encodeInputObjectArg inputName inner o (level + 1)
                    )
                )
                val


inputTypeToString : GraphQL.Schema.Type -> String
inputTypeToString type_ =
    case type_ of
        GraphQL.Schema.Nullable newType ->
            inputTypeToString newType

        GraphQL.Schema.List_ newType ->
            "[" ++ inputTypeToString newType ++ "]"

        GraphQL.Schema.Scalar scalarName ->
            scalarName

        GraphQL.Schema.Enum enumName ->
            enumName

        GraphQL.Schema.InputObject inputName ->
            inputName

        GraphQL.Schema.Union unionName ->
            "Unions cant be nested in inputs"

        GraphQL.Schema.Object nestedObjectName ->
            "Objects cant be nested in inputs"

        GraphQL.Schema.Interface interfaceName ->
            "Interfaces cant be in inputs"


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
wrapGet : GraphQL.Schema.Wrapped -> String -> Elm.Expression -> Elm.Expression
wrapGet wrapped selector val =
    case wrapped of
        GraphQL.Schema.UnwrappedValue ->
            Elm.get selector val

        GraphQL.Schema.InMaybe inner ->
            Gen.Maybe.call_.map
                (Elm.fn
                    ( "inner"
                    , Just Elm.Annotation.unit
                    )
                    (\within ->
                        wrapGet inner selector within
                    )
                )
                val

        GraphQL.Schema.InList inner ->
            Gen.List.call_.map
                (Elm.fn
                    ( "inner"
                    , Just Elm.Annotation.unit
                    )
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
encodeWrappedArgument : String -> GraphQL.Schema.Wrapped -> (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
encodeWrappedArgument inputName wrapper encoder val =
    case wrapper of
        GraphQL.Schema.UnwrappedValue ->
            encoder val

        GraphQL.Schema.InMaybe inner ->
            let
                valName =
                    addCount inner (Utils.String.formatValue inputName)
            in
            Elm.Case.maybe val
                { just = ( "item", encodeWrappedArgument valName inner encoder )
                , nothing = Engine.arg Encode.null (Input.gqlType wrapper inputName)
                }

        GraphQL.Schema.InList inner ->
            let
                valName =
                    addCount inner (Utils.String.formatValue inputName)
            in
            Engine.call_.argList
                (Gen.List.call_.map
                    (Elm.fn
                        ( valName
                        , Just Elm.Annotation.unit
                        )
                        (\within ->
                            encodeWrappedArgument valName inner encoder within
                        )
                    )
                    val
                )
                (Elm.string (Input.gqlType wrapper inputName))


addCount : GraphQL.Schema.Wrapped -> String -> String
addCount wrapped str =
    str ++ String.fromInt (countRemainingDepth wrapped 1)


countRemainingDepth : GraphQL.Schema.Wrapped -> Int -> Int
countRemainingDepth wrapped i =
    case wrapped of
        GraphQL.Schema.UnwrappedValue ->
            i

        GraphQL.Schema.InMaybe inner ->
            countRemainingDepth inner (i + 1)

        GraphQL.Schema.InList inner ->
            countRemainingDepth inner (i + 1)


encodeWrapped :
    GraphQL.Schema.Wrapped
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
encodeWrapped wrapper encoder val =
    case wrapper of
        GraphQL.Schema.UnwrappedValue ->
            encoder val

        GraphQL.Schema.InMaybe inner ->
            encodeWrapped inner (Engine.maybeScalarEncode encoder) val

        GraphQL.Schema.InList inner ->
            encodeWrapped inner (encodeList encoder) val


encodeWrappedInverted :
    GraphQL.Schema.Wrapped
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
encodeWrappedInverted wrapper encoder val =
    case wrapper of
        GraphQL.Schema.UnwrappedValue ->
            encoder val

        GraphQL.Schema.InMaybe inner ->
            Engine.maybeScalarEncode (encodeWrappedInverted inner encoder) val

        GraphQL.Schema.InList inner ->
            encodeList (encodeWrappedInverted inner encoder) val



{- CREATE BUILDER -}


annotation :
    Namespace
    -> GraphQL.Schema.Schema
    -> GraphQL.Schema.InputObjectDetails
    -> Elm.Annotation.Annotation
annotation namespace schema input =
    inputObjectAnnotation namespace schema input GraphQL.Schema.UnwrappedValue { ergonomicOptionType = True }


{-| -}
createBuilder :
    Namespace
    -> GraphQL.Schema.Schema
    -> String
    ->
        List
            { fieldOrArg
                | name : String.String
                , description : Maybe String.String
                , type_ : GraphQL.Schema.Type
            }
    -> GraphQL.Schema.Type
    -> Input.Operation
    -> Elm.Declaration
createBuilder namespace schema name arguments returnType operation =
    let
        hasArgs =
            not (List.isEmpty arguments)

        needsSubselection =
            needsInnerSelection returnType

        maybeSubselector =
            if needsSubselection then
                -- if we're selecting an object, we need the dev to pass a selection set in.
                let
                    innerReturnType =
                        GraphQL.Schema.getInner returnType
                in
                Just
                    (Generate.Common.selection namespace.namespace
                        (GraphQL.Schema.typeToElmString innerReturnType)
                        (Elm.Annotation.var "data")
                    )

            else
                Nothing

        returnWrapper =
            GraphQL.Schema.getWrap returnType

        returnAnnotation =
            if needsSubselection then
                Generate.Common.selection namespace.namespace
                    (Input.operationToString operation)
                    (wrapWith returnWrapper (Elm.Annotation.var "data"))

            else
                Generate.Common.selection namespace.namespace
                    (Input.operationToString operation)
                    (Generate.Common.gqlTypeToElmTypeAnnotation namespace returnType Nothing)

        return inputArgs decoder =
            Engine.objectWith
                (Generate.Input.Encode.fullRecordToInputObject namespace
                    schema
                    (List.map
                        (\arg ->
                            { name = arg.name
                            , description = arg.description
                            , type_ = arg.type_
                            }
                        )
                        arguments
                    )
                    inputArgs
                )
                name
                decoder
                |> Elm.withType returnAnnotation
    in
    case maybeSubselector of
        Nothing ->
            if hasArgs then
                Elm.fn
                    ( "inputArgs", Just (Elm.Annotation.named [] "Input") )
                    (\args ->
                        return args
                            (decodeSelection namespace returnType Elm.unit)
                    )
                    |> Elm.declaration name
                    |> Elm.expose

            else
                decodeSelection namespace returnType Elm.unit
                    |> Elm.declaration name
                    |> Elm.expose

        Just subselectorType ->
            if hasArgs then
                Elm.fn2
                    ( "inputArgs", Just (Elm.Annotation.named [] "Input") )
                    ( "selection"
                    , subselectorType
                        |> Just
                    )
                    (\args subselection ->
                        return args
                            (decodeSelection namespace returnType subselection)
                    )
                    |> Elm.declaration name
                    |> Elm.expose

            else
                Elm.fn
                    ( "selection"
                    , subselectorType
                        |> Just
                    )
                    (\subselection ->
                        return (Elm.record [])
                            (decodeSelection namespace returnType subselection)
                    )
                    |> Elm.declaration name
                    |> Elm.expose


decodeSelection : Namespace -> GraphQL.Schema.Type -> Elm.Expression -> Elm.Expression
decodeSelection namespace returnType subselector =
    case returnType of
        GraphQL.Schema.Scalar name ->
            Generate.Scalar.decode namespace
                name
                GraphQL.Schema.UnwrappedValue
                |> Engine.decode

        GraphQL.Schema.Enum enumName ->
            Elm.value
                { importFrom = [ namespace.enums, "Enum", enumName ]
                , name = "decoder"
                , annotation = Nothing
                }
                |> Engine.decode

        GraphQL.Schema.List_ inner ->
            Engine.list (decodeSelection namespace inner subselector)

        GraphQL.Schema.Nullable inner ->
            Engine.nullable (decodeSelection namespace inner subselector)

        GraphQL.Schema.InputObject name ->
            subselector

        GraphQL.Schema.Object name ->
            subselector

        GraphQL.Schema.Union name ->
            subselector

        GraphQL.Schema.Interface name ->
            subselector


wrapWith wrapper inner =
    case wrapper of
        GraphQL.Schema.UnwrappedValue ->
            inner

        GraphQL.Schema.InList innerWrap ->
            Elm.Annotation.list (wrapWith innerWrap inner)

        GraphQL.Schema.InMaybe innerWrap ->
            Elm.Annotation.maybe (wrapWith innerWrap inner)


needsInnerSelection : GraphQL.Schema.Type -> Bool
needsInnerSelection type_ =
    case type_ of
        GraphQL.Schema.Scalar name ->
            False

        GraphQL.Schema.Enum name ->
            False

        GraphQL.Schema.InputObject name ->
            True

        GraphQL.Schema.Object name ->
            True

        GraphQL.Schema.Union name ->
            True

        GraphQL.Schema.Interface name ->
            True

        GraphQL.Schema.List_ inner ->
            needsInnerSelection inner

        GraphQL.Schema.Nullable inner ->
            needsInnerSelection inner


justIf : Bool -> a -> Maybe a
justIf condition val =
    if condition then
        Just val

    else
        Nothing

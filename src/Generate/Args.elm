module Generate.Args exposing
    ( Namespace
    , createBuilder
    )

import Dict
import Elm
import Elm.Annotation
import Gen.GraphQL.Engine as Engine
import Generate.Common
import Generate.Input as Input
import Generate.Input.Encode
import Generate.Scalar
import GraphQL.Schema
import Set exposing (Set)
import String


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

        GraphQL.Schema.Object _ ->
            ( captured, [] )

        GraphQL.Schema.Enum _ ->
            ( captured, [] )

        GraphQL.Schema.Union _ ->
            ( captured, [] )

        GraphQL.Schema.Interface _ ->
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
        \_ _ ->
            Elm.Annotation.namedWith
                []
                "Optional"
                []
    , arg =
        \namespace name ->
            Generate.Common.ref namespace name
    }


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

        GraphQL.Schema.Interface _ ->
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

        ( _, [] ) ->
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

        ( [], _ ) ->
            if optForm.ergonomicOptionType then
                annotations.ergonomicOptional namespace.namespace inputName
                    |> Elm.Annotation.list
                    |> unwrapWith wrapped

            else
                annotations.safeOptional namespace.namespace inputName
                    |> Elm.Annotation.list
                    |> unwrapWith wrapped

        ( required, _ ) ->
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



{- CREATE BUILDER -}


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

        returnAnnotation =
            if needsSubselection then
                let
                    returnWrapper =
                        GraphQL.Schema.getWrap returnType
                in
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

        GraphQL.Schema.InputObject _ ->
            subselector

        GraphQL.Schema.Object _ ->
            subselector

        GraphQL.Schema.Union _ ->
            subselector

        GraphQL.Schema.Interface _ ->
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
        GraphQL.Schema.Scalar _ ->
            False

        GraphQL.Schema.Enum _ ->
            False

        GraphQL.Schema.InputObject _ ->
            True

        GraphQL.Schema.Object _ ->
            True

        GraphQL.Schema.Union _ ->
            True

        GraphQL.Schema.Interface _ ->
            True

        GraphQL.Schema.List_ inner ->
            needsInnerSelection inner

        GraphQL.Schema.Nullable inner ->
            needsInnerSelection inner

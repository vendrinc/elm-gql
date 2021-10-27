module Generate.Args exposing
    ( createBuilder
    , nullsRecord
    , optionsRecursive
    , annotation
    , toEngineArg
    , toJsonValue
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
import Generate.Decode
import Generate.Input as Input
import GraphQL.Schema
import GraphQL.Schema.Argument
import GraphQL.Schema.Field
import GraphQL.Schema.InputObject as InputObject
import GraphQL.Schema.Type exposing (Type(..))
import Set exposing (Set)
import String
import Utils.String


embeddedOptionsFieldName : String
embeddedOptionsFieldName =
    "with_"


encodeScalar : String -> Input.Wrapped -> (Elm.Expression -> Elm.Expression)
encodeScalar scalarName wrapped =
    case wrapped of
        Input.InList inner ->
            Encode.list
                (encodeScalar scalarName inner)

        Input.InMaybe inner ->
            Engine.maybeScalarEncode
                (encodeScalar scalarName
                    inner
                )

        Input.UnwrappedValue ->
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

                _ ->
                    \val ->
                        Elm.apply
                            (Elm.valueFrom ( [ "Scalar" ])
                                (Utils.String.formatValue scalarName)
                                |> Elm.get "encode"
                            )
                            [ val ]


unwrapWith :
    Input.Wrapped
    -> Elm.Annotation.Annotation
    -> Elm.Annotation.Annotation
unwrapWith wrapped expression =
    case wrapped of
        Input.InList inner ->
            Elm.Annotation.list
                (unwrapWith inner expression)

        Input.InMaybe inner ->
            Elm.Annotation.maybe
                (unwrapWith inner expression)

        Input.UnwrappedValue ->
            expression


scalarType : Input.Wrapped -> String -> Elm.Annotation.Annotation
scalarType wrapped scalarName =
    case wrapped of
        Input.InList inner ->
            Elm.Annotation.list
                (scalarType inner scalarName)

        Input.InMaybe inner ->
            Elm.Annotation.maybe
                (scalarType inner scalarName)

        Input.UnwrappedValue ->
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

                _ ->
                    Elm.Annotation.named
                        ( [ "Scalar" ])
                        (Utils.String.formatScalar scalarName)


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
                , inputAnnotationRecursive namespace schema field.type_ (Input.getWrap field.type_)
                )
            )
            reqs
        )


prepareRequiredRecursive :
    String
    -> GraphQL.Schema.Schema
    -> { a | name : String, type_ : Type }
    -> Elm.Expression
prepareRequiredRecursive namespace schema argument =
    Elm.tuple
        (Elm.string argument.name)
        (toEngineArg
            namespace
            schema
            argument.type_
            (Input.getWrap argument.type_)
            (Elm.get argument.name (Elm.value "required"))
        )


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


annotations :
    { optional : String -> String -> Elm.Annotation.Annotation
    , safeOptional : String -> String -> Elm.Annotation.Annotation
    , localOptional : a -> b -> Elm.Annotation.Annotation
    , arg : String -> String -> Elm.Annotation.Annotation
    }
annotations =
    { optional =
        \namespace name ->
            Elm.Annotation.namedWith
                ( (Generate.Common.modules.input namespace name))
                "Optional"
                []
    , safeOptional =
        \namespace name ->
            Elm.Annotation.named [ namespace ]
                name
                |> Engine.types_.optional
            
    , localOptional =
        \namespace name ->
            Engine.types_.optional
                (Elm.Annotation.namedWith
                    []
                    "Optional"
                    []
                )
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
    String
    -> String
    ->
        List
            { fieldOrArg
                | name : String
                , type_ : Type
                , description : Maybe String
            }
    -> Elm.Expression
nullsRecord namespace name fields =
    Elm.record
        (List.map
            (\field ->
                Elm.field 
                    (Utils.String.formatValue field.name)
                    (Engine.arg Encode.null (Elm.string (inputTypeToString field.type_))
                        |> Engine.optional
                            (Elm.string field.name)
                        |> Elm.withType
                            (annotations.localOptional namespace name)
                    )

            )
            fields
        )


{-|

    The `recursive` part means it's going to jump into the schema in order to figure out how to encode the various inputs

    Instead of making you do it yourself.

-}
optionsRecursive :
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
    -> List Elm.Declaration
optionsRecursive namespace schema name options =
    optionsRecursiveHelper namespace schema name options []


optionsRecursiveHelper :
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
    -> List Elm.Declaration
    -> List Elm.Declaration
optionsRecursiveHelper namespace schema name options fields =
    case options of
        [] ->
            fields

        arg :: remain ->
            let
                wrapping =
                    case Input.getWrap arg.type_ of
                        Input.InMaybe inner ->
                            inner

                        otherwise ->
                            otherwise
            in
            optionsRecursiveHelper namespace
                schema
                name
                remain
                ((Elm.fn (Utils.String.formatValue arg.name)
                    ( "val"
                    , inputAnnotationRecursive namespace schema arg.type_ wrapping
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
                                (Elm.string arg.name)
                            |> Elm.withType
                                (annotations.localOptional namespace name)
                    )
                    |> Elm.expose
                 )
                    :: fields
                )


inputAnnotationRecursive : String -> GraphQL.Schema.Schema -> Type -> Input.Wrapped -> Elm.Annotation.Annotation
inputAnnotationRecursive namespace schema type_ wrapped =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            inputAnnotationRecursive namespace schema newType wrapped

        GraphQL.Schema.Type.List_ newType ->
            inputAnnotationRecursive namespace schema newType wrapped

        GraphQL.Schema.Type.Scalar scalarName ->
            scalarType wrapped scalarName

        GraphQL.Schema.Type.Enum enumName ->
            Elm.Annotation.named
                (Generate.Common.modules.enum namespace enumName)
                enumName
                |> unwrapWith wrapped

        GraphQL.Schema.Type.InputObject inputName ->
            case Dict.get inputName schema.inputObjects of
                Nothing ->
                    annotations.arg namespace inputName
                        |> unwrapWith wrapped

                Just input ->
                    inputObjectAnnotation namespace schema input wrapped

        GraphQL.Schema.Type.Object nestedObjectName ->
            -- not used as input
            Generate.Common.selection namespace
                nestedObjectName
                (Elm.Annotation.var "data")

        GraphQL.Schema.Type.Union unionName ->
            -- not used as input
            -- Note, we need a discriminator instead of just `data`
            Generate.Common.selection namespace
                unionName
                (Elm.Annotation.var "data")
                |> unwrapWith wrapped

        GraphQL.Schema.Type.Interface interfaceName ->
            -- not used as input
            Elm.Annotation.unit


inputObjectAnnotation :
    String 
        -> GraphQL.Schema.Schema 
        -> InputObject.InputObject
        -> Input.Wrapped 
        -> Elm.Annotation.Annotation
inputObjectAnnotation namespace schema input wrapped =
    let
        inputName = input.name
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
                        , inputAnnotationRecursive namespace schema field.type_ (Input.getWrap field.type_)
                        )
                    )
                    input.fields
                )
                |> unwrapWith wrapped

        ( [], optional ) ->
            annotations.safeOptional namespace inputName
                |> Elm.Annotation.list
                |> unwrapWith wrapped

        ( required, optional ) ->
            Elm.Annotation.record
                (List.map
                    (\field ->
                        ( field.name
                        , inputAnnotationRecursive namespace schema field.type_ (Input.getWrap field.type_)
                        )
                    )
                    required
                    ++ [ ( embeddedOptionsFieldName
                            , annotations.optional namespace inputName
                            |> Elm.Annotation.list
                            )
                        ]
                )
                |> unwrapWith wrapped


{-|

    Take an input

-}
toJsonValue :
    String
    -> GraphQL.Schema.Schema
    -> Type
    -> Input.Wrapped
    -> Elm.Expression
    -> Elm.Expression
toJsonValue namespace schema fieldType wrapped val =
    case Debug.log "JSON VALUE" fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            toJsonValue namespace schema newType wrapped val

        GraphQL.Schema.Type.List_ newType ->
            toJsonValue namespace schema newType wrapped val

        GraphQL.Schema.Type.Scalar scalarName ->
            encodeScalar scalarName
                wrapped
                val

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
            encodeWrappedInverted wrapped
                (\v ->
                    Elm.apply
                        (Elm.valueFrom ( [ namespace, "Enum", enumName ]) "encode")
                        [ v
                        ]
                )
                val
                
               

        GraphQL.Schema.Type.InputObject inputName ->
            case Dict.get inputName schema.inputObjects of
                Nothing ->
                    encodeInputObjectArg inputName wrapped val 0

                Just input ->
                    if List.all Input.isOptional input.fields then
                            (encodeInputObjectArg inputName wrapped val 0)

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
                                                                (Input.getWrap field.type_)
                                                                (Elm.get field.name v)
                                                            )
                                                    )
                                                    (List.filter (not << Input.isOptional) many)
                                                    |> Elm.list
                                        in
                                        if List.any Input.isOptional input.fields then
                                            Elm.Gen.List.append
                                                requiredVals
                                                (Engine.encodeOptionals
                                                    (Elm.get embeddedOptionsFieldName v)
                                                )
                                                |> Encode.object

                                        else
                                            Encode.object requiredVals
                                        
                                    )
                                    val

        GraphQL.Schema.Type.Union unionName ->
            Elm.string "Unions cant be nested in inputs"

        GraphQL.Schema.Type.Object nestedObjectName ->
            Elm.string "Objects cant be nested in inputs"

        GraphQL.Schema.Type.Interface interfaceName ->
            Elm.string "Interfaces cant be in inputs"





{-|

-}
encodeWrappedJsonValue : String -> Input.Wrapped -> (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
encodeWrappedJsonValue inputName wrapper encoder val =
    case wrapper of
        Input.UnwrappedValue ->
            encoder val

        Input.InMaybe inner ->
            let
                valName =
                    addCount inner (Utils.String.formatValue inputName)
            in
            Elm.caseOf val
                [ ( Elm.Pattern.named "Just" [ Elm.Pattern.var "item" ]
                  , encodeWrappedJsonValue valName inner encoder (Elm.value "item")
                  )
                , ( Elm.Pattern.named "Nothing" []
                  , Encode.null
                  )
                ]

        Input.InList inner ->
            let
                valName =
                    addCount inner (Utils.String.formatValue inputName)
            in
            -- Engine.argList
            Encode.list
                (\v ->
                    Elm.lambda valName
                        Elm.Annotation.unit
                        (\within ->
                            encodeWrappedJsonValue valName inner encoder within
                        )
                )
                val
                -- (Elm.Gen.List.map
                --         (\v ->
                --             Elm.lambda valName
                --                 Elm.Annotation.unit
                --                 (\within ->
                --                     encodeWrappedJsonValue valName inner encoder within
                --                 )
                --         )
                --         val
                -- )
                -- (Elm.string (Input.gqlType wrapper inputName))

                


toEngineArg :
    String
    -> GraphQL.Schema.Schema
    -> Type
    -> Input.Wrapped
    -> Elm.Expression
    -> Elm.Expression
toEngineArg namespace schema fieldType wrapped val =
    case fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            toEngineArg namespace schema newType wrapped val

        GraphQL.Schema.Type.List_ newType ->
            toEngineArg namespace schema newType wrapped val

        GraphQL.Schema.Type.Scalar scalarName ->
            Engine.arg
                (encodeScalar scalarName
                    wrapped
                    val
                )
                (Elm.string (Input.gqlType wrapped scalarName))

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
                (encodeWrappedInverted wrapped
                    (\v ->
                        Elm.apply
                            (Elm.valueFrom ( [ namespace, "Enum", enumName ]) "encode")
                            [ v
                            ]
                    )
                    val
                )
                (Elm.string (Input.gqlType wrapped enumName))

        GraphQL.Schema.Type.InputObject inputName ->
            case Dict.get inputName schema.inputObjects of
                Nothing ->
                    Engine.arg
                        (encodeInputObjectArg inputName wrapped val 0)
                        (Elm.string inputName)

                Just input ->
                    if List.all Input.isOptional input.fields then
                        Engine.arg
                            (encodeInputObjectArg inputName wrapped val 0)
                            (Elm.string (Input.gqlType wrapped inputName))

                    else
                        case input.fields of
                            [] ->
                                Engine.arg
                                    (encodeInputObjectArg inputName wrapped val 0)
                                     (Elm.string (Input.gqlType wrapped input.name))

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
                                                                (Input.getWrap field.type_)
                                                                (Elm.get field.name v)
                                                            )
                                                    )
                                                    (List.filter (not << Input.isOptional) many)
                                                    |> Elm.list
                                        in
                                        Engine.encodeInputObject
                                            (if List.any Input.isOptional input.fields then
                                                Elm.Gen.List.append
                                                    requiredVals
                                                    (Engine.encodeOptionals
                                                        (Elm.get embeddedOptionsFieldName v)
                                                    )

                                             else
                                                requiredVals
                                            )
                                            (Elm.string (Input.gqlType Input.UnwrappedValue input.name))
                                    )
                                    val

        GraphQL.Schema.Type.Union unionName ->
            Elm.string "Unions cant be nested in inputs"

        GraphQL.Schema.Type.Object nestedObjectName ->
            Elm.string "Objects cant be nested in inputs"

        GraphQL.Schema.Type.Interface interfaceName ->
            Elm.string "Interfaces cant be in inputs"


encodeInputObjectArg : String -> Input.Wrapped -> Elm.Expression -> Int -> Elm.Expression
encodeInputObjectArg inputName wrapper val level =
    case wrapper of
        Input.UnwrappedValue ->
            -- encoder val
            Engine.encodeInputObject
                (Engine.encodeOptionals
                    val
                )
                (Elm.string inputName)
                |> Engine.encodeArgument

        Input.InMaybe inner ->
            Engine.maybeScalarEncode
                (\_ ->
                    Elm.lambda ("o" ++ String.fromInt level)
                        Elm.Annotation.unit
                        (\o ->
                            encodeInputObjectArg inputName inner o (level + 1)
                        )
                )
                val

        Input.InList inner ->
            Encode.list
                (\_ ->
                    Elm.lambda ("o" ++ String.fromInt level)
                        Elm.Annotation.unit
                        (\o ->
                            encodeInputObjectArg inputName inner o (level + 1)
                        )
                )
                val


encodeInput :
    String
    -> Type
    -> Input.Wrapped
    -> Elm.Expression
    -> Elm.Expression
encodeInput namespace fieldType wrapped val =
    case fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            encodeInput namespace newType wrapped val

        GraphQL.Schema.Type.List_ newType ->
            encodeInput namespace newType wrapped val

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
                (encodeWrappedInverted wrapped
                    (\v ->
                        Elm.apply
                            (Elm.valueFrom ( [ namespace, "Enum", enumName ]) "encode")
                            [ v
                            ]
                    )
                    val
                )
                (Elm.string enumName)

        GraphQL.Schema.Type.InputObject inputName ->
            Engine.arg
                (encodeWrappedInverted wrapped
                    Engine.encodeArgument
                    val
                )
                (Elm.string (inputTypeWrappedToString wrapped inputName))

        GraphQL.Schema.Type.Union unionName ->
            Elm.string "Unions cant be nested in inputs"

        GraphQL.Schema.Type.Object nestedObjectName ->
            Elm.string "Objects cant be nested in inputs"

        GraphQL.Schema.Type.Interface interfaceName ->
            Elm.string "Interfaces cant be in inputs"


inputTypeWrappedToString : Input.Wrapped -> String -> String
inputTypeWrappedToString wrapped base =
    case wrapped of
        Input.UnwrappedValue ->
            base

        Input.InList inner ->
            "[" ++ inputTypeWrappedToString inner base ++ "]"

        Input.InMaybe inner ->
            inputTypeWrappedToString inner base


inputTypeToString : Type -> String
inputTypeToString type_ =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            inputTypeToString newType

        GraphQL.Schema.Type.List_ newType ->
            "[" ++ inputTypeToString newType ++ "]"

        GraphQL.Schema.Type.Scalar scalarName ->
            scalarName

        GraphQL.Schema.Type.Enum enumName ->
            enumName

        GraphQL.Schema.Type.InputObject inputName ->
            inputName

        GraphQL.Schema.Type.Union unionName ->
            "Unions cant be nested in inputs"

        GraphQL.Schema.Type.Object nestedObjectName ->
            "Objects cant be nested in inputs"

        GraphQL.Schema.Type.Interface interfaceName ->
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
wrapGet : Input.Wrapped -> String -> Elm.Expression -> Elm.Expression
wrapGet wrapped selector val =
    case wrapped of
        Input.UnwrappedValue ->
            Elm.get selector val

        Input.InMaybe inner ->
            Elm.Gen.Maybe.map
                (\v ->
                    Elm.lambda "inner"
                        Elm.Annotation.unit
                        (\within ->
                            wrapGet inner selector within
                        )
                )
                val

        Input.InList inner ->
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
encodeWrappedArgument : String -> Input.Wrapped -> (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
encodeWrappedArgument inputName wrapper encoder val =
    case wrapper of
        Input.UnwrappedValue ->
            encoder val

        Input.InMaybe inner ->
            let
                valName =
                    addCount inner (Utils.String.formatValue inputName)
            in
            Elm.caseOf val
                [ ( Elm.Pattern.named "Just" [ Elm.Pattern.var "item" ]
                  , encodeWrappedArgument valName inner encoder (Elm.value "item")
                  )
                , ( Elm.Pattern.named "Nothing" []
                  , Engine.arg Encode.null (Elm.string (Input.gqlType wrapper inputName))
                  )
                ]

        Input.InList inner ->
            let
                valName =
                    addCount inner (Utils.String.formatValue inputName)
            in
            Engine.argList
                (Elm.Gen.List.map
                    (\v ->
                        Elm.lambda valName
                            Elm.Annotation.unit
                            (\within ->
                                encodeWrappedArgument valName inner encoder within
                            )
                    )
                    val
                )
                (Elm.string (Input.gqlType wrapper inputName))

                


addCount : Input.Wrapped -> String -> String
addCount wrapped str =
    str ++ String.fromInt (countRemainingDepth wrapped 1)


countRemainingDepth : Input.Wrapped -> Int -> Int
countRemainingDepth wrapped i =
    case wrapped of
        Input.UnwrappedValue ->
            i

        Input.InMaybe inner ->
            countRemainingDepth inner (i + 1)

        Input.InList inner ->
            countRemainingDepth inner (i + 1)


encodeWrapped :
    Input.Wrapped
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
encodeWrapped wrapper encoder val =
    case wrapper of
        Input.UnwrappedValue ->
            encoder val

        Input.InMaybe inner ->
            encodeWrapped inner (Engine.maybeScalarEncode encoder) val

        Input.InList inner ->
            encodeWrapped inner (Encode.list encoder) val


encodeWrappedInverted :
    Input.Wrapped
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
encodeWrappedInverted wrapper encoder val =
    case wrapper of
        Input.UnwrappedValue ->
            encoder val

        Input.InMaybe inner ->
            Engine.maybeScalarEncode (encodeWrappedInverted inner encoder) val

        Input.InList inner ->
            Encode.list (encodeWrappedInverted inner encoder) val



{- CREATE BUILDER -}


annotation : 
    String 
        -> GraphQL.Schema.Schema 
        -> InputObject.InputObject 
        -> Elm.Annotation.Annotation
annotation namespace schema input =
    inputObjectAnnotation namespace schema input Input.UnwrappedValue
        

{-| -}
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
    -> Input.Operation
    -> Elm.Declaration
createBuilder namespace schema name arguments returnType operation =
    let
        ( required, optional ) =
            Input.splitRequired
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

        requiredArgs =
            Elm.list
                (required
                    |> List.map (prepareRequiredRecursive namespace schema)
                )

        optionalArgs =
            if hasOptionalArgs then
                Engine.encodeOptionals
                    (Elm.valueWith
                        ( [])
                        embeddedOptionsFieldName
                        (Elm.Annotation.list
                            (annotations.localOptional namespace name)
                        )
                    )

            else
                Elm.list []

        selectionArg =
            if needsInnerSelection returnType then
                -- if we're selecting an object, we need the dev to pass a selection set in.
                Just
                    ( Generate.Common.selection namespace
                        (GraphQL.Schema.Type.toString returnType)
                        (Elm.Annotation.var "data")
                    , Elm.Pattern.var "selection"
                    )

            else
                Nothing

        returnSelection =
            if needsInnerSelection returnType then
                Elm.valueWith []
                    "selection"
                    (Generate.Common.selection namespace
                        (GraphQL.Schema.Type.toString returnType)
                        (Elm.Annotation.var "data")
                    )

            else
                Generate.Decode.scalar
                    (GraphQL.Schema.Type.toString returnType)
                    (Input.getWrap returnType)
                    |> Engine.decode

        returnAnnotation =
            if needsInnerSelection returnType then
                Generate.Common.selection namespace
                    (Input.operationToString operation)
                    (Elm.Annotation.var "data")

            else
                Generate.Common.selection namespace
                    (Input.operationToString operation)
                    (Elm.Annotation.named [] (GraphQL.Schema.Type.toElmString returnType))

        return =
            Engine.objectWith
                (if hasRequiredArgs && hasOptionalArgs then
                    Elm.Gen.List.append
                        requiredArgs
                        optionalArgs

                 else if hasRequiredArgs then
                    requiredArgs

                 else if hasOptionalArgs then
                    optionalArgs

                 else
                    Elm.list []
                )
                (Elm.string name)
                returnSelection
                |> Elm.withType returnAnnotation
    in
    Elm.functionWith (Utils.String.formatValue name)
        (List.filterMap identity
            [ justIf hasRequiredArgs
                ( recursiveRequiredAnnotation namespace schema required
                , Elm.Pattern.var "required"
                )
            , justIf hasOptionalArgs
                ( Elm.Annotation.list
                    (annotations.localOptional namespace name)
                , Elm.Pattern.var embeddedOptionsFieldName
                )
            , selectionArg
            ]
        )
        return
        |> Elm.expose


needsInnerSelection : Type -> Bool
needsInnerSelection type_ =
    case type_ of
        Scalar name ->
            False

        InputObject name ->
            True

        Object name ->
            True

        Enum name ->
            False

        Union name ->
            True

        Interface name ->
            True

        List_ inner ->
            needsInnerSelection inner

        Nullable inner ->
            needsInnerSelection inner


justIf : Bool -> a -> Maybe a
justIf condition val =
    if condition then
        Just val

    else
        Nothing

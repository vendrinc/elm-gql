module Generate.Args exposing
    ( Operation(..)
    , createBuilder
    , createBuilderExample
    , createInput
    , isOptional
    , optionalMaker
    , optionsRecursive
    , prepareRequired
    , recursiveOptionalMaker
    , requiredAnnotation, Wrapped(..), getWrap, nullsRecord
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
import String.Extra
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

                _ ->
                    Elm.Annotation.named
                        (Elm.moduleName [ "Scalar" ])
                        (Utils.String.formatTypename scalarName)


splitRequired : List { a | type_ : Type } -> (List { a | type_ : Type }, List { a | type_ : Type })
splitRequired args =
    List.partition
        (not << isOptional)
        args


denullable : Type -> Type
denullable type_ =
    case type_ of
        GraphQL.Schema.Type.Nullable inner ->
            inner

        _ ->
            type_


isOptional : { a | type_ : Type } -> Bool
isOptional arg =
    case arg.type_ of
        GraphQL.Schema.Type.Nullable _ ->
            True

        _ ->
            False


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
            Generate.Common.selection namespace
                nestedObjectName
                (Elm.Annotation.var "data")

        GraphQL.Schema.Type.InputObject inputName ->
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
                                        , requiredAnnotationRecursiveHelper namespace
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
                , requiredAnnotationHelper namespace field.type_ (getWrap field.type_)
                )
            )
            reqs
        )


getWrap : Type -> Wrapped
getWrap type_ =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            InMaybe (getWrap newType)

        GraphQL.Schema.Type.List_ newType ->
            InList (getWrap newType)

        _ ->
            UnwrappedValue


requiredAnnotationHelper : String -> Type -> Wrapped -> Elm.Annotation.Annotation
requiredAnnotationHelper namespace type_ wrapped =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            requiredAnnotationHelper namespace newType wrapped

        GraphQL.Schema.Type.List_ newType ->
            requiredAnnotationHelper namespace newType wrapped

        GraphQL.Schema.Type.Scalar scalarName ->
            scalarType wrapped scalarName

        GraphQL.Schema.Type.Enum enumName ->
            Elm.Annotation.named (Elm.moduleName [ namespace, "Enum", enumName ]) enumName
                |> unwrapWith wrapped

        GraphQL.Schema.Type.Object nestedObjectName ->
            Generate.Common.selection namespace
                nestedObjectName
                (Elm.Annotation.var "data")

        GraphQL.Schema.Type.InputObject inputName ->
            annotations.arg namespace inputName
                |> unwrapWith wrapped

        GraphQL.Schema.Type.Union unionName ->
            -- Note, we need a discriminator instead of just `data`
            Generate.Common.selection namespace
                unionName
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
            (getWrap argument.type_)
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


annotations : 
    { optional : String -> String -> Elm.Annotation.Annotation
    , localOptional : a -> b -> Elm.Annotation.Annotation
    , arg : String -> String -> Elm.Annotation.Annotation
    }
annotations =
    { optional =
        \namespace name ->
            
            Elm.Annotation.namedWith
                (Elm.moduleName [ namespace, name ])
                "Optional"
                []
    , localOptional =
        \namespace name ->
           
            Elm.Annotation.namedWith
                Elm.local
                "Optional"
                []
    , arg =
        \namespace name ->

            Generate.Common.ref namespace name
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
                      , requiredAnnotationRecursiveHelper namespace schema arg.type_ UnwrappedValue
                      )
                    ]
                    implemented
                 )
                    :: fields
                )


{-|
    Creates a `nulls` record that looks like 


    null =
        { fieldOne
        , fieldTwo
        }



-}
nullsRecord :  String
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
                ( field.name 
                , Engine.arg (Encode.null) (Elm.string (inputTypeToString field.type_))
                    |> Engine.optional
                        (Elm.string field.name)
                    |> Elm.withAnnotation
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
    String ->
    GraphQL.Schema.Schema -> String
    ->
        List
            { fieldOrArg
                | name : String
                , type_ : Type
                , description : Maybe String
            }
    -> List Elm.Declaration
optionsRecursive namespace schema  name options =
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
                    case getWrap arg.type_ of
                        InMaybe inner ->
                            inner

                        otherwise ->
                            otherwise
            in
            optionsRecursiveHelper namespace schema
                name
                remain
                ((Elm.fn arg.name
                    ( "val"
                    , inputAnnotationRecursive namespace schema arg.type_ wrapping
                      
                    )
                    (\val ->
                        encodeInputRecursive  namespace schema
                            arg.type_
                            wrapping
                            val
                            |> Elm.withAnnotation
                                (annotations.arg namespace name)
                            |> Engine.optional
                                (Elm.string arg.name)
                            |> Elm.withAnnotation
                                (annotations.localOptional namespace name)
                    )
                    |> Elm.expose
                 )
                    :: fields
                )



inputAnnotationRecursive : String -> GraphQL.Schema.Schema  -> Type -> Wrapped -> Elm.Annotation.Annotation
inputAnnotationRecursive namespace schema type_ wrapped =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            inputAnnotationRecursive namespace schema newType wrapped

        GraphQL.Schema.Type.List_ newType ->
            inputAnnotationRecursive namespace schema newType wrapped

        GraphQL.Schema.Type.Scalar scalarName ->
            scalarType wrapped scalarName

        GraphQL.Schema.Type.Enum enumName ->
            Elm.Annotation.named (Elm.moduleName [ namespace, "Enum", enumName ]) enumName
                |> unwrapWith wrapped

       
        GraphQL.Schema.Type.InputObject inputName ->
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
                                        ,   inputAnnotationRecursive namespace schema field.type_ (getWrap field.type_)

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
                                        , inputAnnotationRecursive namespace schema field.type_ (getWrap field.type_)
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





encodeInputRecursive :
    String
    -> GraphQL.Schema.Schema 
    -> Type
    -> Wrapped
    -> Elm.Expression
    -> Elm.Expression
encodeInputRecursive namespace schema fieldType wrapped val =
    case fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            encodeInputRecursive namespace schema newType wrapped val

        GraphQL.Schema.Type.List_ newType ->
            encodeInputRecursive namespace schema newType wrapped val

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
                        (encodeWrappedInverted wrapped
                            Engine.encodeArgument
                            val
                        )
                        (Elm.string inputName)

                Just input ->
                    if List.all isOptional input.fields then
                        Engine.arg
                            (encodeWrappedInverted wrapped
                                Engine.encodeArgument
                                val
                            )
                            (Elm.string inputName)

                    else
                        case input.fields of
                            [] ->
                                Engine.arg
                                    (encodeWrappedInverted wrapped
                                        Engine.encodeArgument
                                        val
                                    )
                                    (Elm.string input.name)

                            many ->
                                encodeWrappedArgument (Utils.String.formatValue input.name) wrapped
                                    (\v ->
                                        let
                                            requiredVals =
                                                List.map
                                                    (\field ->
                                                        Elm.tuple
                                                            (Elm.string field.name)
                                                            (encodeInputRecursive namespace schema field.type_ (getWrap field.type_) (Elm.get field.name v))
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



-- optionalMakerTopLevel :
--     String
--     -> String
--     ->
--         List
--             { fieldOrArg
--                 | name : String
--                 , type_ : Type
--                 , description : Maybe String
--             }
--     -> List Elm.Declaration
-- optionalMakerTopLevel namespace name options =
--     createOptionalCreatorTopLevelHelper namespace name options []


-- createOptionalCreatorTopLevelHelper :
--     String
--     -> String
--     ->
--         List
--             { field
--                 | name : String
--                 , description : Maybe String
--                 , type_ : Type
--             }
--     -> List Elm.Declaration
--     -> List Elm.Declaration
-- createOptionalCreatorTopLevelHelper namespace name options fields =
--     case options of
--         [] ->
--             fields

--         arg :: remain ->
--             let
                
--                 wrapping =
--                     case getWrap arg.type_ of
--                         InMaybe inner ->
--                             inner
--                         otherwise ->
--                             otherwise
--             in
--             createOptionalCreatorTopLevelHelper namespace
--                 name
--                 remain
--                 ((Elm.fn arg.name
--                     ( "val", requiredAnnotationHelper namespace arg.type_ wrapping )
--                     (\val ->
--                         encodeInput namespace
--                             arg.type_
--                             wrapping
--                             (val)
--                             |> Elm.withAnnotation
--                                 (annotations.arg namespace name)
--                             |> Engine.optional
--                                 (Elm.string arg.name)
--                             |> Elm.withAnnotation
--                                 (annotations.localOptional namespace name)
--                     )
--                     |> Elm.expose
--                  )
--                     :: fields
--                 )


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
                        (getWrap arg.type_)
                        (Elm.valueWith
                            Elm.local
                            "val"
                            (requiredAnnotationHelper namespace arg.type_ (getWrap arg.type_))
                        )
                        |> Elm.withAnnotation
                            (annotations.arg namespace name)
                        |> Engine.optional
                            (Elm.string arg.name)
                        |> Elm.withAnnotation
                            (annotations.localOptional namespace name)
            in
            createOptionalCreatorHelper namespace
                name
                remain
                (( arg.name
                 , Elm.lambdaWith
                    [ ( Elm.Pattern.var "val"
                      , requiredAnnotationHelper namespace arg.type_ (getWrap arg.type_)
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
                            (Elm.valueFrom (Elm.moduleName [ namespace, "Enum", enumName ]) "encode")
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


inputTypeWrappedToString : Wrapped -> String -> String
inputTypeWrappedToString wrapped base =
    case wrapped of
        UnwrappedValue ->
            base

        InList inner ->
            "[" ++ inputTypeWrappedToString inner base  ++ "]"
        
        InMaybe inner ->
            inputTypeWrappedToString inner base

inputTypeToString : Type -> String
inputTypeToString type_ =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            inputTypeToString newType

        GraphQL.Schema.Type.List_ newType ->
            "[" ++ inputTypeToString newType  ++ "]"

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
                                encodeWrappedArgument (Utils.String.formatValue input.name) wrapped
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
wrapGet : Wrapped -> String -> Elm.Expression -> Elm.Expression
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
encodeWrappedArgument : String -> Wrapped -> (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
encodeWrappedArgument inputName wrapper encoder val =
    case wrapper of
        UnwrappedValue ->
            encoder val

        InMaybe inner ->
            let
                valName = (addCount inner inputName)
            in
            Elm.caseOf val
                [ ( Elm.Pattern.named "Just" [ Elm.Pattern.var "item" ]
                  , encodeWrappedArgument valName inner encoder (Elm.value "item")
                  )
                , ( Elm.Pattern.named "Nothing" []
                  , Engine.arg Encode.null (Elm.string "Unknown")
                  )
                ]

        InList inner ->
            let
                valName = addCount inner inputName
            in
            Elm.Gen.List.map 
                (\v ->
                    Elm.lambda valName
                        Elm.Annotation.unit
                        (\within ->
                            encodeWrappedArgument valName inner encoder within
                        )
                )
                val
                |> Engine.argList
            

addCount : Wrapped -> String -> String
addCount wrapped str =
    str ++ (String.fromInt (countRemainingDepth wrapped 1))


countRemainingDepth : Wrapped -> Int -> Int
countRemainingDepth wrapped i =
    case wrapped of
        UnwrappedValue ->
            i
        InMaybe inner ->
            countRemainingDepth inner (i + 1)
        InList inner ->
            countRemainingDepth inner (i + 1)


encodeWrapped :
    Wrapped
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
encodeWrapped wrapper encoder val =
    case wrapper of
        UnwrappedValue ->
            encoder val

        InMaybe inner ->
            encodeWrapped inner (Engine.maybeScalarEncode encoder) val

        InList inner ->
            encodeWrapped inner (Encode.list encoder) val


encodeWrappedInverted :
    Wrapped
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
encodeWrappedInverted wrapper encoder val =
    case wrapper of
        UnwrappedValue ->
            encoder val

        InMaybe inner ->
            Engine.maybeScalarEncode (encodeWrappedInverted inner encoder) val

        InList inner ->
            Encode.list (encodeWrappedInverted inner encoder) val


wrapAnnotation : Wrapped -> Elm.Annotation.Annotation -> Elm.Annotation.Annotation
wrapAnnotation wrap signature =
    case wrap of
        UnwrappedValue ->
            signature

        InList inner ->
            Elm.Annotation.list (wrapAnnotation inner signature)

        InMaybe inner ->
            Elm.Annotation.maybe (wrapAnnotation inner signature)



{- CREATE BUILDER -}


type Operation
    = Query
    | Mutation


operationToString : Operation -> String.String
operationToString op =
    case op of
        Query ->
            "Query"

        Mutation ->
            "Mutation"


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
    -> Operation
    -> Elm.Declaration
createBuilder namespace schema name arguments returnType operation =
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
                                    (annotations.localOptional namespace name)
                                )
                            )
                        )

                 else if hasOptionalArgs then
                    Engine.encodeOptionals
                        (Elm.valueWith
                            (Elm.moduleName [])
                            "optional"
                            (Elm.Annotation.list
                                (annotations.localOptional namespace name)
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
                    (Generate.Common.selection namespace
                        (GraphQL.Schema.Type.toString returnType)
                        (Elm.Annotation.var "data")
                    )
                )
                |> Elm.withAnnotation
                    (Generate.Common.selection namespace
                        (operationToString operation)
                        (Elm.Annotation.var "data")
                    )
    in
    Elm.functionWith name
        (List.filterMap identity
            [ justIf hasRequiredArgs
                ( recursiveRequiredAnnotation namespace schema required
                , Elm.Pattern.var "required"
                )
            , justIf hasOptionalArgs
                ( Elm.Annotation.list
                    (annotations.localOptional namespace name)
                , Elm.Pattern.var "optional"
                )
            , Just
                ( Generate.Common.selection namespace
                    (GraphQL.Schema.Type.toString returnType)
                    (Elm.Annotation.var "data")
                , Elm.Pattern.var "selection"
                )
            ]
        )
        expression
        |> Elm.expose


createInput :
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
createInput namespace schema name arguments returnType =
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

        expression =
            Engine.encodeInputObject
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
                |> Elm.withAnnotation
                    --(Engine.typeSelection.annotation Engine.typeQuery.annotation (Elm.Annotation.var "data"))
                    --(Elm.Annotation.namedWith
                    --    (Elm.moduleName [ namespace ])
                    --    name
                    --    []
                    --)
                    --(Generate.Common.ref namespace name)
                    (annotations.arg namespace name)

        --|> Elm.withAnnotation
        --    --(Engine.typeSelection.annotation Engine.typeQuery.annotation (Elm.Annotation.var "data"))
        --    (Generate.Common.selection namespace
        --        (operationToString operation)
        --        (Elm.Annotation.var "data")
        --    )
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


createBuilderExample :
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
    -> Operation
    -> Elm.Expression
createBuilderExample namespace schema name arguments returnType operation =
    createExample namespace
        schema
        Set.empty
        name
        (Elm.valueFrom
            (Elm.moduleName
                [ namespace
                , case operation of
                    Mutation ->
                        "Mutations"

                    Query ->
                        "Queries"
                , String.Extra.toSentenceCase name
                ]
            )
            name
        )
        arguments
        (Just
            (Elm.value ("select" ++ GraphQL.Schema.Type.toString returnType))
        )


createExample namespace schema called name base fields maybeReturn =
    let
        ( required, optional ) =
            splitRequired
                fields

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
            if hasRequiredArgs then
                Just
                    (requiredArgsExample namespace schema called required)

            else
                Nothing

        optionalArgs =
            if hasOptionalArgs then
                Just
                    (optionalArgsExample
                        namespace
                        schema
                        called
                        name
                        optional
                        (maybeReturn /= Nothing)
                        Set.empty
                        []
                    )

            else
                Nothing
    in
    Elm.apply
        base
        (List.filterMap identity
            [ requiredArgs
            , optionalArgs
            , maybeReturn
            ]
        )


optionalArgsExample :
    String
    -> GraphQL.Schema.Schema
    -> Set String
    -> String.String
    -> List { a | type_ : Type, name : String.String }
    -> Bool
    -> Set String
    -> List Elm.Expression
    -> Elm.Expression
optionalArgsExample namespace schema called parentName fields isTopLevel calledType prepared =
    case fields of
        [] ->
            Elm.list (List.reverse prepared)

        field :: remaining ->
            let
                typeString =
                    GraphQL.Schema.Type.toString field.type_
            in
            -- if we don't limit examples by type, then the code generation seems to hang or takea huge amount of time
            if Set.member typeString calledType then
                optionalArgsExample namespace
                    schema
                    called
                    parentName
                    remaining
                    isTopLevel
                    calledType
                    prepared

            else
                let
                    optionalModule =
                        if isTopLevel then
                            Elm.moduleName
                                [ namespace
                                , "Queries"
                                , Utils.String.formatTypename parentName
                                ]

                        else
                            Elm.moduleName
                                [ namespace
                                , Utils.String.formatTypename parentName
                                ]

                    unnullifiedType =
                        denullable field.type_

                    prep =
                        Elm.apply
                            (Elm.valueFrom
                                optionalModule
                                (Utils.String.formatValue field.name)
                            )
                            [ Elm.maybe
                                (Just
                                    (requiredArgsExampleHelper
                                        namespace
                                        schema
                                        called
                                        unnullifiedType
                                        UnwrappedValue
                                    )
                                )
                            ]
                in
                optionalArgsExample namespace
                    schema
                    called
                    parentName
                    remaining
                    isTopLevel
                    (Set.insert typeString calledType)
                    (prep :: prepared)


{-| -}
requiredArgsExample :
    String
    -> GraphQL.Schema.Schema
    -> Set String
    ->
        List
            { fieldOrArg
                | name : String.String
                , description : Maybe String.String
                , type_ : Type
            }
    -> Elm.Expression
requiredArgsExample namespace schema called reqs =
    Elm.record
        (List.map
            (\field ->
                ( field.name
                , requiredArgsExampleHelper
                    namespace
                    schema
                    called
                    field.type_
                    UnwrappedValue
                )
            )
            reqs
        )


requiredArgsExampleHelper :
    String
    -> GraphQL.Schema.Schema
    -> Set String
    -> Type
    -> Wrapped
    -> Elm.Expression
requiredArgsExampleHelper namespace schema called type_ wrapped =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            requiredArgsExampleHelper namespace schema called newType (InMaybe wrapped)

        GraphQL.Schema.Type.List_ newType ->
            requiredArgsExampleHelper namespace schema called newType (InList wrapped)

        GraphQL.Schema.Type.Scalar scalarName ->
            scalarExample scalarName
                |> wrapExpression wrapped

        GraphQL.Schema.Type.Enum enumName ->
            enumExample namespace schema enumName
                |> wrapExpression wrapped

        GraphQL.Schema.Type.Object nestedObjectName ->
            Elm.value ("select" ++ String.Extra.toSentenceCase nestedObjectName)
                |> wrapExpression wrapped

        GraphQL.Schema.Type.InputObject inputName ->
            if Set.member inputName called then
                Elm.value ("additional" ++ inputName)
                    |> wrapExpression wrapped

            else
                case Dict.get inputName schema.inputObjects of
                    Nothing ->
                        Elm.value inputName

                    Just input ->
                        let
                            newCalled =
                                Set.insert inputName called
                        in
                        case splitRequired input.fields of
                            ( required, [] ) ->
                                Elm.record
                                    (List.map
                                        (\field ->
                                            ( field.name
                                            , requiredArgsExampleHelper namespace
                                                schema
                                                newCalled
                                                field.type_
                                                UnwrappedValue
                                            )
                                        )
                                        required
                                    )
                                    |> wrapExpression wrapped

                            otherwise ->
                                createExample namespace
                                    schema
                                    newCalled
                                    inputName
                                    (Elm.valueFrom
                                        (Elm.moduleName
                                            [ namespace
                                            , "Input"
                                            ]
                                        )
                                        (Utils.String.formatValue inputName)
                                    )
                                    input.fields
                                    Nothing
                                    |> wrapExpression wrapped

        GraphQL.Schema.Type.Union unionName ->
            Elm.unit

        GraphQL.Schema.Type.Interface interfaceName ->
            Elm.unit


enumExample : String -> GraphQL.Schema.Schema -> String -> Elm.Expression
enumExample namespace schema enumName =
    case Dict.get enumName schema.enums of
        Nothing ->
            Elm.value enumName

        Just enum ->
            case enum.values of
                [] ->
                    Elm.value enumName

                top :: _ ->
                    Elm.valueFrom (Elm.moduleName [ namespace, "Enum", enumName ])
                        (Utils.String.formatTypename top.name)


wrapExpression : Wrapped -> Elm.Expression -> Elm.Expression
wrapExpression wrapper exp =
    case wrapper of
        InList inner ->
            Elm.list
                [ wrapExpression inner exp
                ]

        InMaybe inner ->
            Elm.maybe
                (Just (wrapExpression inner exp))

        UnwrappedValue ->
            exp


scalarExample : String -> Elm.Expression
scalarExample scalarName =
    case String.toLower scalarName of
        "int" ->
            Elm.int 10

        "float" ->
            Elm.float 10

        "string" ->
            Elm.string "Example..."

        "boolean" ->
            Elm.bool True

        "id" ->
            Elm.value "id"

        _ ->
            Elm.value (Utils.String.formatValue scalarName)

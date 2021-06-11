module Generate.Args exposing (Wrapped(..), encodeScalar, optionalMaker, prepareRequired, requiredAnnotation)

import Elm
import Elm.Annotation
import Elm.Debug
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Decode
import Elm.Gen.Json.Encode as Encode
import Elm.Pattern
import GraphQL.Schema.Type exposing (Type(..))
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


requiredAnnotation : List { a | name : String, type_ : Type } -> Elm.Annotation.Annotation
requiredAnnotation reqs =
    Elm.Annotation.record
        (List.map
            (\field ->
                ( field.name
                , requiredAnnotationHelper field.type_ UnwrappedValue
                )
            )
            reqs
        )


requiredAnnotationHelper : Type -> Wrapped -> Elm.Annotation.Annotation
requiredAnnotationHelper type_ wrapped =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            requiredAnnotationHelper newType (InMaybe wrapped)

        GraphQL.Schema.Type.List_ newType ->
            requiredAnnotationHelper newType (InList wrapped)

        GraphQL.Schema.Type.Scalar scalarName ->
            scalarType wrapped scalarName

        GraphQL.Schema.Type.Enum enumName ->
            Elm.Annotation.named (Elm.moduleName [ "TnGql", "Enum", enumName ]) enumName
                |> unwrapWith wrapped

        GraphQL.Schema.Type.Object nestedObjectName ->
            Engine.typeSelection.annotation (Elm.Annotation.var nestedObjectName)
                (Elm.Annotation.var "data")

        GraphQL.Schema.Type.InputObject inputName ->
            Engine.typeArgument.annotation
                (Elm.Annotation.named Elm.local inputName)
                |> unwrapWith wrapped

        GraphQL.Schema.Type.Union unionName ->
            -- Note, we need a discriminator instead of just `data`
            Engine.typeSelection.annotation (Elm.Annotation.var unionName)
                (Elm.Annotation.var "data")
                |> unwrapWith wrapped

        GraphQL.Schema.Type.Interface interfaceName ->
            Elm.Annotation.unit


prepareRequired :
    { a | name : String, type_ : Type }
    -> Elm.Expression
prepareRequired argument =
    Elm.tuple
        (Elm.string argument.name)
        (encodeOptionalArg argument.type_
            UnwrappedValue
            (Elm.get argument.name (Elm.value "required")
                |> Elm.withAnnotation
                    (Engine.typeArgument.annotation
                        (Elm.Annotation.named
                            (Elm.moduleName [ "TnGql", "Input" ])
                            argument.name
                        )
                    )
            )
        )


optionalMaker name options =
    createOptionalCreatorHelper name options []


createOptionalCreatorHelper :
    String
    ->
        List
            { field
                | name : String
                , description : Maybe String
                , type_ : Type
            }
    -> List ( String, Elm.Expression )
    -> Elm.Declaration
createOptionalCreatorHelper name options fields =
    case options of
        [] ->
            Elm.declaration (Utils.String.formatValue (name ++ "Options"))
                (Elm.record fields)

        arg :: remain ->
            let
                implemented =
                    encodeOptionalArg arg.type_
                        UnwrappedValue
                        (Elm.valueWith
                            Elm.local
                            "val"
                            (requiredAnnotationHelper arg.type_ UnwrappedValue)
                        )
                        |> Elm.withAnnotation
                            (Engine.typeArgument.annotation (Elm.Annotation.named Elm.local name))
                        |> Engine.optional
                            (Elm.string arg.name)
                        |> Elm.withAnnotation
                            (Engine.typeOptional.annotation
                                (Elm.Annotation.named Elm.local
                                    name
                                )
                            )
            in
            createOptionalCreatorHelper name
                remain
                (( arg.name
                 , Elm.lambdaWith
                    [ ( Elm.Pattern.var "val"
                      , requiredAnnotationHelper arg.type_ UnwrappedValue
                      )
                    ]
                    implemented
                 )
                    :: fields
                )


encodeOptionalArg :
    Type
    -> Wrapped
    -> Elm.Expression
    -> Elm.Expression
encodeOptionalArg fieldType wrapped val =
    case fieldType of
        GraphQL.Schema.Type.Nullable newType ->
            encodeOptionalArg newType (InMaybe wrapped) val

        GraphQL.Schema.Type.List_ newType ->
            encodeOptionalArg newType (InList wrapped) val

        GraphQL.Schema.Type.Scalar scalarName ->
            Engine.arg
                (encodeScalar scalarName
                    wrapped
                    val
                )
                (Elm.string "TODO?")

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
            encodeWrapped wrapped
                (\v ->
                    Elm.apply
                        (Elm.valueFrom (Elm.moduleName [ "TnGql", "Enum", enumName ]) "encode")
                        [ v
                        ]
                )
                val

        GraphQL.Schema.Type.InputObject inputName ->
            encodeWrapped wrapped
                Engine.encodeArgument
                val

        GraphQL.Schema.Type.Union unionName ->
            Elm.string "Unions cant be nested in inputs"

        GraphQL.Schema.Type.Object nestedObjectName ->
            Elm.string "Objects cant be nested in inputs"

        GraphQL.Schema.Type.Interface interfaceName ->
            Elm.string "Interfaces cant be in inputs"


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

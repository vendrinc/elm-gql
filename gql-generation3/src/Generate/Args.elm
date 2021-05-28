module Generate.Args exposing (Wrapped(..), encodeScalar, prepareRequired)

import Elm
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Encode as Encode
import GraphQL.Schema.Type exposing (Type(..))
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


prepareRequired :
    { a | name : String, type_ : Type }
    -> Elm.Expression
prepareRequired argument =
    Elm.tuple
        (Elm.string argument.name)
        (let
            convert type__ =
                case type__ of
                    GraphQL.Schema.Type.Scalar scalarName ->
                        Engine.arg
                            (encodeScalar argument.name
                                UnwrappedValue
                                (Elm.get argument.name (Elm.value "required"))
                            )
                            (Elm.string scalarName)

                    GraphQL.Schema.Type.Enum enumName ->
                        --Elm.apply (Elm.valueFrom (Elm.moduleName [ "GraphQL", "Engine", "args" ]) "scalar")
                        --    [ GenEngine.enum
                        --    , Elm.valueFrom (Elm.moduleName [ "TnGql", "Enum", enumName ]) "decoder"
                        --    , Elm.get argument.name (Elm.value "required")
                        --    ]
                        Elm.string "unimplemented"

                    GraphQL.Schema.Type.InputObject inputObject ->
                        Elm.apply (Elm.valueFrom (Elm.moduleName [ "GraphQL", "Engine", "args" ]) "scalar")
                            [ Elm.valueFrom (Elm.moduleName [ "TnGql", "InputObject", inputObject ]) "decoder"
                            , Elm.get argument.name (Elm.value "required")
                            ]

                    GraphQL.Schema.Type.Nullable innerType ->
                        -- bugbug pretty sure the inner decoder
                        -- needs to be instructed to handle null
                        -- but I'm just glossing over that for now
                        convert innerType

                    GraphQL.Schema.Type.Object name ->
                        Elm.string "unimplemented"

                    GraphQL.Schema.Type.Union name ->
                        Elm.string "unimplemented"

                    GraphQL.Schema.Type.Interface name ->
                        Elm.string "unimplemented"

                    GraphQL.Schema.Type.List_ innerType ->
                        Elm.string "unimplemented"
         in
         convert argument.type_
        )

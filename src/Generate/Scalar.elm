module Generate.Scalar exposing (decode, encode, generate, type_)

import Dict
import Elm
import Elm.Annotation as Type
import Elm.Case
import Gen.GraphQL.Engine as Engine
import Gen.Json.Decode
import Gen.Json.Encode
import Generate.Common as Common
import GraphQL.Schema exposing (Namespace)
import Utils.String


type_ : Namespace -> String -> Type.Annotation
type_ namespace scalar =
    case String.toLower scalar of
        "string" ->
            Type.string

        "int" ->
            Type.int

        "float" ->
            Type.float

        "boolean" ->
            Type.bool

        _ ->
            Type.namedWith [ namespace.namespace ]
                (Utils.String.formatScalar scalar)
                []


encode : Namespace -> String -> GraphQL.Schema.Wrapped -> (Elm.Expression -> Elm.Expression)
encode namespace scalarName wrapped =
    case wrapped of
        GraphQL.Schema.InList inner ->
            encodeList
                (encode namespace scalarName inner)

        GraphQL.Schema.InMaybe inner ->
            Engine.maybeScalarEncode
                (encode namespace
                    scalarName
                    inner
                )

        GraphQL.Schema.UnwrappedValue ->
            let
                lowered =
                    String.toLower scalarName
            in
            case lowered of
                "int" ->
                    Gen.Json.Encode.call_.int

                "float" ->
                    Gen.Json.Encode.call_.float

                "string" ->
                    Gen.Json.Encode.call_.string

                "boolean" ->
                    Gen.Json.Encode.call_.bool

                _ ->
                    \val ->
                        Elm.apply
                            (Elm.value
                                { importFrom =
                                    [ namespace.namespace
                                    ]
                                , name = Utils.String.formatValue scalarName
                                , annotation = Nothing
                                }
                                |> Elm.get "encode"
                            )
                            [ val ]


{-|

    list : (a -> Json.Encode.Value) -> List a -> Json.Encode.Value

-}
encodeList : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
encodeList fn listExpr =
    Elm.apply
        Gen.Json.Encode.values_.list
        [ Elm.functionReduced "listUnpack" fn, listExpr ]


decode : Namespace -> String -> GraphQL.Schema.Wrapped -> Elm.Expression
decode namespace scalarName wrapped =
    let
        lowered =
            String.toLower scalarName

        decoder =
            case lowered of
                "string" ->
                    Gen.Json.Decode.string

                "int" ->
                    Gen.Json.Decode.int

                "float" ->
                    Gen.Json.Decode.float

                "boolean" ->
                    Gen.Json.Decode.bool

                "bool" ->
                    Gen.Json.Decode.bool

                _ ->
                    Elm.value
                        { importFrom =
                            [ namespace.namespace
                            ]
                        , name = Utils.String.formatValue scalarName
                        , annotation = Nothing
                        }
                        |> Elm.get "decoder"
    in
    decodeWrapper wrapped decoder


decodeWrapper : GraphQL.Schema.Wrapped -> Elm.Expression -> Elm.Expression
decodeWrapper wrap exp =
    case wrap of
        GraphQL.Schema.UnwrappedValue ->
            exp

        GraphQL.Schema.InList inner ->
            Gen.Json.Decode.list
                (decodeWrapper inner exp)

        GraphQL.Schema.InMaybe inner ->
            Engine.decodeNullable
                (decodeWrapper inner exp)



{- Generated scalra file -}


builtIn : List String
builtIn =
    [ "int"
    , "float"
    , "string"
    , "boolean"
    ]


generate : Namespace -> GraphQL.Schema.Schema -> List Elm.Declaration
generate namespace schema =
    Elm.alias "Codec"
        (Type.record
            [ ( "encode"
              , Type.function
                    [ Type.var "scalar"
                    ]
                    Gen.Json.Encode.annotation_.value
              )
            , ( "decoder"
              , Gen.Json.Decode.annotation_.decoder
                    (Type.var "scalar")
              )
            ]
        )
        :: (schema.scalars
                |> Dict.toList
                |> List.concatMap generateScalarCodec
           )


generateScalarCodec : ( String, GraphQL.Schema.ScalarDetails ) -> List Elm.Declaration
generateScalarCodec ( rawname, details ) =
    if List.member (String.toLower rawname) builtIn then
        []

    else
        let
            typename =
                Utils.String.formatScalar rawname

            name =
                Utils.String.formatValue
                    typename
        in
        [ Elm.customType typename
            [ Elm.variantWith typename
                [ Type.string
                ]
            ]
            |> Elm.exposeWith
                { group = Just "Scalar Decoders and Encoders"
                , exposeConstructor = True
                }
        , Elm.declaration name
            (Elm.record
                [ ( "encode"
                  , Elm.fn ( "val", Just (Type.named [] typename) )
                        (\val ->
                            Elm.Case.custom val
                                (Type.named [] typename)
                                [ Elm.Case.branch1 typename
                                    ( "str", Type.string )
                                    Gen.Json.Encode.call_.string
                                ]
                        )
                  )
                , ( "decoder"
                  , Gen.Json.Decode.string
                        |> Gen.Json.Decode.call_.map
                            (Elm.val typename)
                  )
                ]
                |> Elm.withType
                    (Type.namedWith []
                        "Codec"
                        [ Type.named [] typename
                        ]
                    )
            )
            |> Elm.exposeWith
                { group = Just "Scalar Decoders and Encoders"
                , exposeConstructor = True
                }
        ]

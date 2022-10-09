module Generate.Scalar exposing (generate)

import Dict
import Elm
import Elm.Annotation as Type
import Elm.Case
import Gen.GraphQL.Engine as Engine
import Gen.Json.Decode
import Gen.Json.Encode
import Generate.Common as Common
import Generate.Decode
import GraphQL.Schema exposing (Namespace)
import Utils.String


builtIn : List String
builtIn =
    [ "int"
    , "float"
    , "string"
    , "boolean"
    ]


generate : Namespace -> GraphQL.Schema.Schema -> Elm.File
generate namespace schema =
    Elm.fileWith [ namespace.namespace, "Scalar" ]
        { docs =
            \docs ->
                "This is a file used by `elm-gql` to decode your GraphQL scalars."
                    "You'll need to maintain it and ensure that each scalar type is being encoded and decoded correctly!"
                    :: List.map Elm.docs (List.reverse docs)
        , aliases = []
        }
        (Elm.alias "Codec"
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
        )


generateScalarCodec : ( String, GraphQL.Schema.ScalarDetails ) -> List Elm.Declaration
generateScalarCodec ( typename, details ) =
    if List.member (String.toLower typename) builtIn then
        []

    else
        let
            name =
                if typename == "ID" then
                    "id"

                else
                    typename
        in
        [ Elm.customType typename
            [ Elm.variantWith typename
                [ Type.string
                ]
            ]
            |> Elm.exposeWith
                { group = Just typename
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
                { group = Just typename
                , exposeConstructor = True
                }
        ]

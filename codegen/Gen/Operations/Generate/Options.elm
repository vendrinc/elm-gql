module Gen.Operations.Generate.Options exposing (moduleName_, annotation_, make_)

{-|

@docs moduleName_, annotation_, make_

-}

import Elm
import Elm.Annotation as Type


{-| The name of this module.
-}
moduleName_ : List String
moduleName_ =
    [ "Operations", "Generate", "Options" ]


annotation_ : { options : Type.Annotation }
annotation_ =
    { options =
        Type.alias
            moduleName_
            "Options"
            []
            (Type.record
                [ ( "namespace", Type.namedWith [] "Namespace" [] )
                , ( "schema"
                  , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                  )
                , ( "document", Type.namedWith [ "Can" ] "Document" [] )
                , ( "path", Type.string )
                , ( "queryDir", Type.list Type.string )
                , ( "generateMocks", Type.bool )
                , ( "outputDir", Type.string )
                ]
            )
    }


make_ :
    { options :
        { namespace : Elm.Expression
        , schema : Elm.Expression
        , document : Elm.Expression
        , path : Elm.Expression
        , queryDir : Elm.Expression
        , generateMocks : Elm.Expression
        , outputDir : Elm.Expression
        }
        -> Elm.Expression
    }
make_ =
    { options =
        \options_args ->
            Elm.withType
                (Type.alias
                    [ "Operations", "Generate", "Options" ]
                    "Options"
                    []
                    (Type.record
                        [ ( "namespace", Type.namedWith [] "Namespace" [] )
                        , ( "schema"
                          , Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                          )
                        , ( "document", Type.namedWith [ "Can" ] "Document" [] )
                        , ( "path", Type.string )
                        , ( "queryDir", Type.list Type.string )
                        , ( "generateMocks", Type.bool )
                        , ( "outputDir", Type.string )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "namespace" options_args.namespace
                    , Tuple.pair "schema" options_args.schema
                    , Tuple.pair "document" options_args.document
                    , Tuple.pair "path" options_args.path
                    , Tuple.pair "queryDir" options_args.queryDir
                    , Tuple.pair "generateMocks" options_args.generateMocks
                    , Tuple.pair "outputDir" options_args.outputDir
                    ]
                )
    }

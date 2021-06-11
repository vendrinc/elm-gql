module Generate.InputObjects exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Debug
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Json
import Elm.Gen.Json.Encode as Encode
import Elm.Pattern
import Generate.Args
import GraphQL.Schema
import GraphQL.Schema.InputObject
import GraphQL.Schema.Object
import GraphQL.Schema.Type exposing (Type(..))


inputObjectToDeclarations : GraphQL.Schema.InputObject.InputObject -> List Elm.Declaration
inputObjectToDeclarations input =
    let
        ( required, optional ) =
            List.partition
                (\arg ->
                    case arg.type_ of
                        GraphQL.Schema.Type.Nullable innerType ->
                            False

                        _ ->
                            True
                )
                input.fields

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

        optionalTypeProof =
            if hasOptionalArgs then
                Just
                    (Elm.customType input.name
                        [ ( input.name, [] )
                        ]
                        |> Elm.expose
                    )

            else
                Nothing

        optionalConstructor =
            if hasOptionalArgs then
                Just
                    (Generate.Args.optionalMaker input.name
                        optional
                        |> Elm.expose
                    )

            else
                Nothing

        inputDecl =
            case ( hasRequiredArgs, hasOptionalArgs ) of
                ( False, False ) ->
                    Elm.declaration input.name
                        (Engine.encodeInputObject (Elm.list [])
                            (Elm.string input.name)
                        )

                ( True, True ) ->
                    Elm.fn2 input.name
                        ( "required", Generate.Args.requiredAnnotation required )
                        ( "optional", Elm.Annotation.string )
                        (\req opt ->
                            Engine.encodeInputObject
                                (Elm.append
                                    (Elm.list
                                        (required
                                            |> List.map Generate.Args.prepareRequired
                                        )
                                    )
                                    (Engine.encodeOptionals
                                        opt
                                    )
                                )
                                (Elm.string input.name)
                        )

                ( True, False ) ->
                    Elm.fn input.name
                        ( "required", Generate.Args.requiredAnnotation required )
                        (\req ->
                            Engine.encodeInputObject
                                (Elm.list
                                    (required
                                        |> List.map Generate.Args.prepareRequired
                                    )
                                )
                                (Elm.string input.name)
                                |> Elm.withAnnotation
                                    (Engine.typeArgument.annotation (Elm.Annotation.named Elm.local input.name))
                        )

                ( False, True ) ->
                    Elm.fn input.name
                        ( "optional"
                        , Elm.Annotation.list
                            (Engine.typeOptional.annotation
                                (Elm.Annotation.named Elm.local input.name)
                            )
                        )
                        (\opt ->
                            Engine.encodeInputObject
                                (Engine.encodeOptionals
                                    opt
                                )
                                (Elm.string input.name)
                                |> Elm.withAnnotation
                                    (Engine.typeArgument.annotation (Elm.Annotation.named Elm.local input.name))
                        )
    in
    List.filterMap identity
        [ optionalTypeProof
        , optionalConstructor
        , inputDecl
            |> Elm.expose
            |> Just
        ]


justIf : Bool -> a -> Maybe a
justIf condition val =
    if condition then
        Just val

    else
        Nothing


generateFiles : GraphQL.Schema.Schema -> List Elm.File
generateFiles graphQLSchema =
    let
        objects =
            graphQLSchema.inputObjects
                |> Dict.toList
                |> List.map Tuple.second

        --|> List.filter (\object -> String.toLower object.name == "setassignedappid")
        declarations =
            objects
                |> List.concatMap inputObjectToDeclarations
    in
    [ Elm.file (Elm.moduleName [ "TnGql", "Input" ])
        ""
        declarations
    ]

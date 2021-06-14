module Generate.InputObjects exposing (generateFiles)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.List
import Generate.Args
import GraphQL.Schema
import GraphQL.Schema.InputObject
import GraphQL.Schema.Type exposing (Type(..))


inputObjectToDeclarations : String -> GraphQL.Schema.InputObject.InputObject -> List Elm.Declaration
inputObjectToDeclarations namespace input =
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
                    (Generate.Args.optionalMaker namespace
                        input.name
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
                        ( "required", Generate.Args.requiredAnnotation namespace required )
                        ( "optional", Elm.Annotation.string )
                        (\req opt ->
                            Engine.encodeInputObject
                                (Elm.Gen.List.append
                                    (Elm.list
                                        (required
                                            |> List.map (Generate.Args.prepareRequired namespace)
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
                        ( "required", Generate.Args.requiredAnnotation namespace required )
                        (\req ->
                            Engine.encodeInputObject
                                (Elm.list
                                    (required
                                        |> List.map (Generate.Args.prepareRequired namespace)
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
        , inputDecl
            |> Elm.expose
            |> Just
        , optionalConstructor
        ]


justIf : Bool -> a -> Maybe a
justIf condition val =
    if condition then
        Just val

    else
        Nothing


generateFiles : String -> GraphQL.Schema.Schema -> List Elm.File
generateFiles namespace graphQLSchema =
    let
        objects =
            graphQLSchema.inputObjects
                |> Dict.toList
                |> List.map Tuple.second

        --|> List.filter (\object -> String.toLower object.name == "setassignedappid")
        declarations =
            objects
                |> List.concatMap (inputObjectToDeclarations namespace)
    in
    [ Elm.file (Elm.moduleName [ namespace, "Input" ])
        ""
        declarations
    ]

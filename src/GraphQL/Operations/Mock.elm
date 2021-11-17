module GraphQL.Operations.Mock exposing (generate)

import Generate.Input as Input
import GraphQL.Operations.CanonicalAST as Can
import GraphQL.Operations.Validate as Validate
import GraphQL.Schema.Type as SchemaType
import Json.Encode


type alias Namespace =
    { namespace : String
    , enums : String
    }


generate :
    Can.Document
    ->
        Result
            (List Validate.Error)
            (List { name : String, body : Json.Encode.Value })
generate doc =
    Ok (List.map definition doc.definitions)


definition : Can.Definition -> { name : String, body : Json.Encode.Value }
definition (Can.Operation def) =
    { name =
        Maybe.map Can.nameToString def.name
            |> Maybe.withDefault "query"
    , body =
        Json.Encode.object
            [ ( "data", mockDefinition def )
            ]
    }


mockDefinition : Can.OperationDetails -> Json.Encode.Value
mockDefinition def =
    Json.Encode.object
        (List.concatMap (encodeField Nothing) def.fields)


encodeField : Maybe String -> Can.Selection -> List ( String, Json.Encode.Value )
encodeField typename field =
    case field of
        Can.FieldObject details ->
            -- Note, still need to handle `details.wrapper`
            [ ( Can.getAliasedName field
              , Json.Encode.object
                    (List.concatMap (encodeField (Just details.object.name)) details.selection)
                    |> wrapEncoder details.wrapper
              )
            ]

        Can.FieldUnion details ->
            case onlyOneUnionCaseAndScalars (List.reverse details.selection) ( Nothing, [] ) of
                ( Just selectedVariant, otherFields ) ->
                    [ ( Can.getAliasedName field
                      , Json.Encode.object
                            (Can.UnionCase selectedVariant
                                :: otherFields
                                |> List.concatMap (encodeField (Just (Can.nameToString selectedVariant.tag)))
                            )
                            |> wrapEncoder details.wrapper
                      )
                    ]

                ( Nothing, otherFields ) ->
                    []

        Can.FieldScalar details ->
            case details.type_ of
                SchemaType.Scalar "typename" ->
                    case typename of
                        Nothing ->
                            [ ( Can.getAliasedName field
                              , Json.Encode.string "WRONG"
                              )
                            ]

                        Just nameStr ->
                            [ ( Can.getAliasedName field
                              , Json.Encode.string nameStr
                              )
                            ]

                _ ->
                    [ ( Can.getAliasedName field
                      , SchemaType.mockScalar details.type_
                      )
                    ]

        Can.FieldEnum details ->
            case details.values of
                [] ->
                    [ ( Can.getAliasedName field
                      , Json.Encode.null
                      )
                    ]

                top :: remain ->
                    [ ( Can.getAliasedName field
                      , Json.Encode.string top.name
                            |> wrapEncoder details.wrapper
                      )
                    ]

        Can.UnionCase details ->
            List.concatMap (encodeField typename) details.selection


wrapEncoder : Input.Wrapped -> Json.Encode.Value -> Json.Encode.Value
wrapEncoder wrapped val =
    case wrapped of
        Input.UnwrappedValue ->
            val

        Input.InList inner ->
            Json.Encode.list identity [ wrapEncoder inner val ]

        Input.InMaybe inner ->
            wrapEncoder inner val


onlyOneUnionCaseAndScalars : List Can.Selection -> ( Maybe Can.UnionCaseDetails, List Can.Selection ) -> ( Maybe Can.UnionCaseDetails, List Can.Selection )
onlyOneUnionCaseAndScalars sels (( maybeFoundUnion, otherFields ) as found) =
    case sels of
        [] ->
            found

        (Can.UnionCase union) :: remain ->
            if maybeFoundUnion /= Nothing then
                onlyOneUnionCaseAndScalars
                    remain
                    found

            else
                onlyOneUnionCaseAndScalars
                    remain
                    ( Just union, otherFields )

        (Can.FieldScalar scalar) :: remain ->
            onlyOneUnionCaseAndScalars
                remain
                ( maybeFoundUnion, Can.FieldScalar scalar :: otherFields )

        _ :: remain ->
            onlyOneUnionCaseAndScalars
                remain
                found

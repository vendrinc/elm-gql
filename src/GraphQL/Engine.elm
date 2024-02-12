module GraphQL.Engine exposing
    ( batch
    , Selection, select, map, map2, withName
    , Query, query, queryRisky, queryTask, queryRiskyTask
    , Mutation, mutation, mutationRisky, mutationTask, mutationRiskyTask
    , Subscription, subscription
    , Error(..), GqlError, Location
    , VariableDetails, selectionVariables, encodeVariables
    , queryString, queryToTestingDetails, mutationToTestingDetails
    , Request, send, mapRequest
    , Option(..)
    , operation
    , versionedName, versionedAlias
    )

{-|

@docs batch

@docs Selection, select, with, map, map2, withName

@docs Query, query, queryRisky, queryTask, queryRiskyTask

@docs Mutation, mutation, mutationRisky, mutationTask, mutationRiskyTask

@docs Subscription, subscription

@docs Error, GqlError, Location

@docs VariableDetails, selectionVariables, encodeVariables

@docs queryString, queryToTestingDetails, mutationToTestingDetails


## Requests

@docs Request, toRequest, send, mapRequest

@docs Option

@docs operation

@docs versionedName, versionedAlias

-}

import Dict exposing (Dict)
import Http
import Json.Decode
import Json.Encode
import Set
import Task exposing (Task)


{-| Batch a number of selection sets together!
-}
batch : List (Selection source data) -> Selection source (List data)
batch selections =
    Selection <|
        Details
            (List.foldl
                (\(Selection (Details newOpName _ _)) maybeOpName ->
                    mergeOpNames maybeOpName newOpName
                )
                Nothing
                selections
            )
            (\context ->
                List.foldl
                    (\(Selection (Details _ toFieldsGql _)) cursor ->
                        let
                            new =
                                toFieldsGql cursor.context
                        in
                        { context = new.context
                        , fields = cursor.fields ++ new.fields
                        , fragments = cursor.fragments ++ new.fragments
                        }
                    )
                    { context = context
                    , fields = []
                    , fragments = ""
                    }
                    selections
            )
            (\context ->
                List.foldl
                    (\(Selection (Details _ _ toItemDecoder)) ( ctxt, cursorFieldsDecoder ) ->
                        let
                            ( newCtxt, itemDecoder ) =
                                toItemDecoder ctxt
                        in
                        ( newCtxt
                        , cursorFieldsDecoder
                            |> Json.Decode.andThen
                                (\existingList ->
                                    Json.Decode.map
                                        (\item ->
                                            item :: existingList
                                        )
                                        itemDecoder
                                )
                        )
                    )
                    ( context, Json.Decode.succeed [] )
                    selections
            )


findFirstMatch : List ( String, item ) -> String -> Json.Decode.Decoder item
findFirstMatch options str =
    case options of
        [] ->
            Json.Decode.fail ("Unexpected enum value: " ++ str)

        ( name, value ) :: remaining ->
            if name == str then
                Json.Decode.succeed value

            else
                findFirstMatch remaining str


type Variable
    = Variable String


{-| -}
type Selection source selected
    = Selection (Details selected)


type alias Context =
    { version : Int
    , aliases : Dict String Int
    , variables : Dict String VariableDetails
    }


type alias VariableDetails =
    { gqlTypeName : String
    , value : Maybe Json.Encode.Value
    }


empty : Context
empty =
    { aliases = Dict.empty
    , version = 0
    , variables = Dict.empty
    }


{-| -}
select : data -> Selection source data
select data =
    Selection
        (Details Nothing
            (\context ->
                { context = context
                , fields = []
                , fragments = ""
                }
            )
            (\context ->
                ( context, Json.Decode.succeed data )
            )
        )


withName : String -> Selection source data -> Selection source data
withName name (Selection (Details _ toGql toDecoder)) =
    Selection (Details (Just name) toGql toDecoder)


{-| An unguarded GQL query.
-}
type Details selected
    = Details
        -- This is an optional *operation name*
        -- Can only be set on Queries and Mutations
        (Maybe String)
        -- Both of these take a Set String, which is how we're keeping track of
        -- what needs to be aliased
        -- How to make the gql query
        (Context
         ->
            { context : Context
            , fields : List Field
            , fragments : String
            }
        )
        -- How to decode the data coming back
        (Context -> ( Context, Json.Decode.Decoder selected ))


type Field
    = --    name   alias          args                        children
      Field String (Maybe String) (List ( String, Variable )) (List Field)
      --        ...on FragmentName
    | Fragment String (List Field)
      -- a piece of GQL that has been validated separately
      -- This is generally for operational gql
    | Baked String


{-| We can also accept:

  - Enum values (unquoted)
  - custom scalars

But we can define anything else in terms of these:

-}
type Argument obj
    = ArgValue Json.Encode.Value String
    | Var String


{-| -}
type Option value
    = Present value
    | Null
    | Absent


{-| -}
map : (a -> b) -> Selection source a -> Selection source b
map fn (Selection (Details maybeOpName fields decoder)) =
    Selection <|
        Details maybeOpName
            fields
            (\aliases ->
                let
                    ( newAliases, newDecoder ) =
                        decoder aliases
                in
                ( newAliases, Json.Decode.map fn newDecoder )
            )


mergeOpNames : Maybe String -> Maybe String -> Maybe String
mergeOpNames maybeOne maybeTwo =
    case ( maybeOne, maybeTwo ) of
        ( Nothing, Nothing ) ->
            Nothing

        ( Just one, _ ) ->
            Just one

        ( _, Just two ) ->
            Just two


{-| -}
map2 : (a -> b -> c) -> Selection source a -> Selection source b -> Selection source c
map2 fn (Selection (Details oneOpName oneFields oneDecoder)) (Selection (Details twoOpName twoFields twoDecoder)) =
    Selection <|
        Details
            (mergeOpNames oneOpName twoOpName)
            (\aliases ->
                let
                    one =
                        oneFields aliases

                    two =
                        twoFields one.context
                in
                { context = two.context
                , fields = one.fields ++ two.fields
                , fragments = one.fragments ++ two.fragments
                }
            )
            (\aliases ->
                let
                    ( oneAliasesNew, oneDecoderNew ) =
                        oneDecoder aliases

                    ( twoAliasesNew, twoDecoderNew ) =
                        twoDecoder oneAliasesNew
                in
                ( twoAliasesNew
                , Json.Decode.map2 fn oneDecoderNew twoDecoderNew
                )
            )


{-| -}
operation :
    Maybe String
    ->
        (Int
         ->
            { args : List ( String, VariableDetails )
            , body : String
            , fragments : String
            }
        )
    -> (Int -> Json.Decode.Decoder data)
    -> Selection source data
operation maybeOpName toGql toDecoder =
    Selection
        (Details maybeOpName
            (\context ->
                let
                    gql =
                        toGql context.version
                in
                { context =
                    { context
                        | version = context.version + 1
                        , variables =
                            gql.args
                                |> List.map (protectArgs context.version)
                                |> Dict.fromList
                                |> Dict.union context.variables
                    }
                , fields = [ Baked gql.body ]
                , fragments = gql.fragments
                }
            )
            (\context ->
                let
                    decoder =
                        toDecoder context.version
                in
                ( { context
                    | version = context.version + 1
                  }
                , decoder
                )
            )
        )


protectArgs : Int -> ( String, VariableDetails ) -> ( String, VariableDetails )
protectArgs version ( name, var ) =
    ( versionedName version name, var )


versionedName : Int -> String -> String
versionedName i name =
    if i == 0 then
        name

    else
        name ++ "_batch_" ++ String.fromInt i


{-| Slightly different than versioned name, this is specific to only making an alias if the version is not 0.

so if I'm selecting a field "myField"

Then

    versionedAlias 0 "myField"
        -> "myField"

but

    versionedAlias 1 "myField"
        -> "myField\_batch\_1: myField"

-}
versionedAlias : Int -> String -> String
versionedAlias i name =
    if i == 0 then
        name

    else
        name ++ "_batch_" ++ String.fromInt i ++ ": " ++ name



{- Making requests -}


{-| -}
type Query
    = Query


{-| -}
type Mutation
    = Mutation


{-| -}
type Subscription
    = Subscription


{-| -}
type Request value
    = Request
        { method : String
        , headers : List ( String, String )
        , url : String
        , body : Json.Encode.Value
        , expect : Http.Response String -> Result Error value
        , timeout : Maybe Float
        , tracker : Maybe String
        }


{-| -}
mapRequest : (a -> b) -> Request a -> Request b
mapRequest fn (Request request) =
    Request
        { method = request.method
        , headers = request.headers
        , url = request.url
        , body = request.body
        , expect = request.expect >> Result.map fn
        , timeout = request.timeout
        , tracker = request.tracker
        }


{-| -}
send : Request data -> Cmd (Result Error data)
send (Request req) =
    Http.request
        { method = req.method
        , headers = List.map (\( key, val ) -> Http.header key val) req.headers
        , url = req.url
        , body = Http.jsonBody req.body
        , expect =
            Http.expectStringResponse identity req.expect
        , timeout = req.timeout
        , tracker = req.tracker
        }


{-| -}
queryToTestingDetails :
    Selection Query data
    ->
        { payload : Json.Encode.Value
        , decoder : Json.Decode.Decoder data
        }
queryToTestingDetails ((Selection (Details _ fields toDecoder)) as sel) =
    let
        ( context_, decoder ) =
            toDecoder empty
    in
    { payload = encodePayload "query" sel
    , decoder = decoder
    }


{-| -}
mutationToTestingDetails :
    Selection Mutation data
    ->
        { payload : Json.Encode.Value
        , decoder : Json.Decode.Decoder data
        }
mutationToTestingDetails ((Selection (Details _ fields toDecoder)) as sel) =
    let
        ( context_, decoder ) =
            toDecoder empty
    in
    { payload = encodePayload "mutation" sel
    , decoder = decoder
    }


{-| -}
subscription :
    Selection Subscription data
    ->
        { payload : Json.Encode.Value
        , decoder : Json.Decode.Decoder data
        }
subscription ((Selection (Details _ fields toDecoder)) as sel) =
    let
        ( context_, decoder ) =
            toDecoder empty
    in
    { payload = encodePayload "subscription" sel
    , decoder = decoder
    }


{-| -}
query :
    Selection Query value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Error value)
query sel config =
    Http.request
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "query" sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


{-| -}
mutation :
    Selection Mutation msg
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Error msg)
mutation sel config =
    Http.request
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "mutation" sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


{-| -}
queryTask :
    Selection Query value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        }
    -> Task Error value
queryTask sel config =
    Http.task
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "query" sel
        , resolver = resolver sel
        , timeout = config.timeout
        }


{-| -}
mutationTask :
    Selection Mutation value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        }
    -> Task Error value
mutationTask sel config =
    Http.task
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "mutation" sel
        , resolver = resolver sel
        , timeout = config.timeout
        }


{-| -}
queryRisky :
    Selection Query value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Error value)
queryRisky sel config =
    Http.riskyRequest
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "query" sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


{-| -}
mutationRisky :
    Selection Mutation msg
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Error msg)
mutationRisky sel config =
    Http.riskyRequest
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "mutation" sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


{-| -}
queryRiskyTask :
    Selection Query value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        }
    -> Task Error value
queryRiskyTask sel config =
    Http.riskyTask
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "query" sel
        , resolver = resolver sel
        , timeout = config.timeout
        }


{-| -}
mutationRiskyTask :
    Selection Mutation value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        }
    -> Task Error value
mutationRiskyTask sel config =
    Http.riskyTask
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "mutation" sel
        , resolver = resolver sel
        , timeout = config.timeout
        }


{-|

      Http.request
        { method = "POST"
        , headers = []
        , url = "https://example.com/gql-endpoint"
        , body = Gql.body query
        , expect = Gql.expect Received query
        , timeout = Nothing
        , tracker = Nothing
        }

-}
body : String -> Selection source data -> Http.Body
body operationName q =
    Http.jsonBody
        (encodePayload operationName q)


encodePayload : String -> Selection source data -> Json.Encode.Value
encodePayload operationName q =
    Json.Encode.object
        [ ( "query", Json.Encode.string (queryString operationName q) )
        , ( "variables", encodeVariables (selectionVariables q) )
        ]


selectionVariables : Selection source data -> Dict String VariableDetails
selectionVariables q =
    (getContext q).variables


encodeVariables : Dict String VariableDetails -> Json.Encode.Value
encodeVariables variables =
    variables
        |> Dict.toList
        |> List.filterMap
            (\( varName, var ) ->
                case var.value of
                    Nothing ->
                        Nothing

                    Just value ->
                        Just ( varName, value )
            )
        |> Json.Encode.object


getContext : Selection source selected -> Context
getContext (Selection (Details maybeOpName gql _)) =
    let
        rendered =
            gql empty
    in
    rendered.context


{-| -}
expect : (Result Error data -> msg) -> Selection source data -> Http.Expect msg
expect toMsg (Selection (Details maybeOpName gql toDecoder)) =
    let
        ( context, decoder ) =
            toDecoder empty
    in
    Http.expectStringResponse toMsg (responseToResult decoder)


{-| -}
resolver : Selection source data -> Http.Resolver Error data
resolver (Selection (Details maybeOpName gql toDecoder)) =
    let
        ( context, decoder ) =
            toDecoder empty
    in
    Http.stringResolver (responseToResult decoder)


responseToResult : Json.Decode.Decoder data -> Http.Response String -> Result Error data
responseToResult decoder response =
    case response of
        Http.BadUrl_ url ->
            Err (BadUrl url)

        Http.Timeout_ ->
            Err Timeout

        Http.NetworkError_ ->
            Err NetworkError

        Http.BadStatus_ metadata responseBody ->
            Err
                (BadStatus
                    { status = metadata.statusCode
                    , responseBody = responseBody
                    }
                )

        Http.GoodStatus_ metadata responseBody ->
            let
                bodyDecoder =
                    Json.Decode.oneOf
                        [ Json.Decode.map2
                            (\_ errs ->
                                Err errs
                            )
                            (Json.Decode.field "data" (Json.Decode.nullable decoder))
                            (Json.Decode.field "errors"
                                (Json.Decode.list gqlErrorDecoder)
                            )
                        , Json.Decode.field "data" decoder
                            |> Json.Decode.map Ok
                        , Json.Decode.field "errors"
                            (Json.Decode.list gqlErrorDecoder)
                            |> Json.Decode.map Err
                        ]
            in
            case Json.Decode.decodeString bodyDecoder responseBody of
                Ok (Ok success) ->
                    Ok success

                Ok (Err graphqlErrors) ->
                    Err
                        (ErrorField
                            { errors = graphqlErrors
                            }
                        )

                Err err ->
                    Err
                        (BadBody
                            { responseBody = responseBody
                            , decodingError = Json.Decode.errorToString err
                            }
                        )


{-| -}
type Error
    = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus
        { status : Int
        , responseBody : String
        }
    | BadBody
        { decodingError : String
        , responseBody : String
        }
    | ErrorField
        { errors : List GqlError
        }


{-| A graphQL error specified here: <https://github.com/graphql/graphql-spec/blob/main/spec/Section%207%20--%20Response.md>
-}
gqlErrorDecoder : Json.Decode.Decoder GqlError
gqlErrorDecoder =
    Json.Decode.map4 GqlError
        (Json.Decode.field "message" Json.Decode.string)
        (Json.Decode.maybe (Json.Decode.field "path" (Json.Decode.list Json.Decode.string)))
        (Json.Decode.maybe (Json.Decode.field "locations" (Json.Decode.list locationDecoder)))
        (Json.Decode.maybe (Json.Decode.field "extensions" Json.Decode.value))


locationDecoder : Json.Decode.Decoder Location
locationDecoder =
    Json.Decode.map2 Location
        (Json.Decode.field "line" Json.Decode.int)
        (Json.Decode.field "column" Json.Decode.int)


type alias GqlError =
    { message : String
    , path : Maybe (List String)
    , locations : Maybe (List Location)
    , extensions : Maybe Json.Decode.Value
    }


type alias Location =
    { line : Int
    , column : Int
    }


{-| -}
queryString : String -> Selection source data -> String
queryString operationName (Selection (Details maybeOpName gql _)) =
    let
        rendered =
            gql empty
    in
    operationName
        ++ " "
        ++ Maybe.withDefault "" maybeOpName
        ++ renderParameters rendered.context.variables
        ++ "{"
        ++ fieldsToQueryString rendered.fields ""
        ++ "}"
        ++ rendered.fragments


renderParameters : Dict String VariableDetails -> String
renderParameters dict =
    let
        paramList =
            Dict.toList dict
    in
    case paramList of
        [] ->
            ""

        _ ->
            "(" ++ renderParametersHelper paramList "" ++ ")"


renderParametersHelper : List ( String, VariableDetails ) -> String -> String
renderParametersHelper args rendered =
    case args of
        [] ->
            rendered

        ( name, value ) :: remaining ->
            if String.isEmpty rendered then
                renderParametersHelper remaining ("$" ++ name ++ ":" ++ value.gqlTypeName)

            else
                renderParametersHelper remaining (rendered ++ ", $" ++ name ++ ":" ++ value.gqlTypeName)


fieldsToQueryString : List Field -> String -> String
fieldsToQueryString fields rendered =
    case fields of
        [] ->
            rendered

        top :: remaining ->
            if String.isEmpty rendered then
                fieldsToQueryString remaining (renderField top)

            else
                fieldsToQueryString remaining (rendered ++ "\n" ++ renderField top)


renderField : Field -> String
renderField myField =
    case myField of
        Baked q ->
            q

        Fragment name fields ->
            "... on "
                ++ name
                ++ "{"
                ++ fieldsToQueryString fields ""
                ++ "}"

        Field name maybeAlias args fields ->
            let
                aliasString =
                    maybeAlias
                        |> Maybe.map (\a -> a ++ ":")
                        |> Maybe.withDefault ""

                argString =
                    case args of
                        [] ->
                            ""

                        nonEmpty ->
                            "(" ++ renderArgs nonEmpty "" ++ ")"

                selection =
                    case fields of
                        [] ->
                            ""

                        _ ->
                            "{" ++ fieldsToQueryString fields "" ++ "}"
            in
            aliasString ++ name ++ argString ++ selection


renderArgs : List ( String, Variable ) -> String -> String
renderArgs args rendered =
    case args of
        [] ->
            rendered

        ( name, Variable varName ) :: remaining ->
            if String.isEmpty rendered then
                renderArgs remaining (rendered ++ name ++ ": $" ++ varName)

            else
                renderArgs remaining (rendered ++ ", " ++ name ++ ": $" ++ varName)

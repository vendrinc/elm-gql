export default (): string => "module GraphQL.Engine exposing\n    ( batch\n    , Selection, select, map, map2, withName\n    , Query, query, queryRisky, queryTask, queryRiskyTask\n    , Mutation, mutation, mutationRisky, mutationTask, mutationRiskyTask\n    , Subscription, subscription\n    , Error(..), GqlError, Location\n    , VariableDetails, selectionVariables, encodeVariables\n    , queryString\n    , Request, send, simulate, mapRequest\n    , Option(..)\n    , operation\n    , versionedName, versionedAlias\n    )\n\n{-|\n\n@docs batch\n\n@docs Selection, select, with, map, map2, withName\n\n@docs Query, query, queryRisky, queryTask, queryRiskyTask\n\n@docs Mutation, mutation, mutationRisky, mutationTask, mutationRiskyTask\n\n@docs Subscription, subscription\n\n@docs Error, GqlError, Location\n\n@docs VariableDetails, selectionVariables, encodeVariables\n\n@docs queryString\n\n\n## Requests\n\n@docs Request, toRequest, send, simulate, mapRequest\n\n@docs Option\n\n@docs operation\n\n@docs versionedName, versionedAlias\n\n-}\n\nimport Dict exposing (Dict)\nimport Http\nimport Json.Decode\nimport Json.Encode\nimport Set\nimport Task exposing (Task)\n\n\n{-| Batch a number of selection sets together!\n-}\nbatch : List (Selection source data) -> Selection source (List data)\nbatch selections =\n    Selection <|\n        Details\n            (List.foldl\n                (\\(Selection (Details newOpName _ _)) maybeOpName ->\n                    mergeOpNames maybeOpName newOpName\n                )\n                Nothing\n                selections\n            )\n            (\\context ->\n                List.foldl\n                    (\\(Selection (Details _ toFieldsGql _)) cursor ->\n                        let\n                            new =\n                                toFieldsGql cursor.context\n                        in\n                        { context = new.context\n                        , fields = cursor.fields ++ new.fields\n                        , fragments = cursor.fragments ++ new.fragments\n                        }\n                    )\n                    { context = context\n                    , fields = []\n                    , fragments = \"\"\n                    }\n                    selections\n            )\n            (\\context ->\n                List.foldl\n                    (\\(Selection (Details _ _ toItemDecoder)) ( ctxt, cursorFieldsDecoder ) ->\n                        let\n                            ( newCtxt, itemDecoder ) =\n                                toItemDecoder ctxt\n                        in\n                        ( newCtxt\n                        , cursorFieldsDecoder\n                            |> Json.Decode.andThen\n                                (\\existingList ->\n                                    Json.Decode.map\n                                        (\\item ->\n                                            item :: existingList\n                                        )\n                                        itemDecoder\n                                )\n                        )\n                    )\n                    ( context, Json.Decode.succeed [] )\n                    selections\n            )\n\n\nfindFirstMatch : List ( String, item ) -> String -> Json.Decode.Decoder item\nfindFirstMatch options str =\n    case options of\n        [] ->\n            Json.Decode.fail (\"Unexpected enum value: \" ++ str)\n\n        ( name, value ) :: remaining ->\n            if name == str then\n                Json.Decode.succeed value\n\n            else\n                findFirstMatch remaining str\n\n\ntype Variable\n    = Variable String\n\n\n{-| -}\ntype Selection source selected\n    = Selection (Details selected)\n\n\ntype alias Context =\n    { version : Int\n    , aliases : Dict String Int\n    , variables : Dict String VariableDetails\n    }\n\n\ntype alias VariableDetails =\n    { gqlTypeName : String\n    , value : Maybe Json.Encode.Value\n    }\n\n\nempty : Context\nempty =\n    { aliases = Dict.empty\n    , version = 0\n    , variables = Dict.empty\n    }\n\n\n{-| -}\nselect : data -> Selection source data\nselect data =\n    Selection\n        (Details Nothing\n            (\\context ->\n                { context = context\n                , fields = []\n                , fragments = \"\"\n                }\n            )\n            (\\context ->\n                ( context, Json.Decode.succeed data )\n            )\n        )\n\n\nwithName : String -> Selection source data -> Selection source data\nwithName name (Selection (Details _ toGql toDecoder)) =\n    Selection (Details (Just name) toGql toDecoder)\n\n\n{-| An unguarded GQL query.\n-}\ntype Details selected\n    = Details\n        -- This is an optional *operation name*\n        -- Can only be set on Queries and Mutations\n        (Maybe String)\n        -- Both of these take a Set String, which is how we're keeping track of\n        -- what needs to be aliased\n        -- How to make the gql query\n        (Context\n         ->\n            { context : Context\n            , fields : List Field\n            , fragments : String\n            }\n        )\n        -- How to decode the data coming back\n        (Context -> ( Context, Json.Decode.Decoder selected ))\n\n\ntype Field\n    = --    name   alias          args                        children\n      Field String (Maybe String) (List ( String, Variable )) (List Field)\n      --        ...on FragmentName\n    | Fragment String (List Field)\n      -- a piece of GQL that has been validated separately\n      -- This is generally for operational gql\n    | Baked String\n\n\n{-| We can also accept:\n\n  - Enum values (unquoted)\n  - custom scalars\n\nBut we can define anything else in terms of these:\n\n-}\ntype Argument obj\n    = ArgValue Json.Encode.Value String\n    | Var String\n\n\n{-| -}\ntype Option value\n    = Present value\n    | Null\n    | Absent\n\n\n{-| -}\ntype InputObject value\n    = InputObject String (List ( String, VariableDetails ))\n\n\n{-| -}\ninputObject : String -> InputObject value\ninputObject name =\n    InputObject name []\n\n\n{-| -}\nmap : (a -> b) -> Selection source a -> Selection source b\nmap fn (Selection (Details maybeOpName fields decoder)) =\n    Selection <|\n        Details maybeOpName\n            fields\n            (\\aliases ->\n                let\n                    ( newAliases, newDecoder ) =\n                        decoder aliases\n                in\n                ( newAliases, Json.Decode.map fn newDecoder )\n            )\n\n\nmergeOpNames : Maybe String -> Maybe String -> Maybe String\nmergeOpNames maybeOne maybeTwo =\n    case ( maybeOne, maybeTwo ) of\n        ( Nothing, Nothing ) ->\n            Nothing\n\n        ( Just one, _ ) ->\n            Just one\n\n        ( _, Just two ) ->\n            Just two\n\n\n{-| -}\nmap2 : (a -> b -> c) -> Selection source a -> Selection source b -> Selection source c\nmap2 fn (Selection (Details oneOpName oneFields oneDecoder)) (Selection (Details twoOpName twoFields twoDecoder)) =\n    Selection <|\n        Details\n            (mergeOpNames oneOpName twoOpName)\n            (\\aliases ->\n                let\n                    one =\n                        oneFields aliases\n\n                    two =\n                        twoFields one.context\n                in\n                { context = two.context\n                , fields = one.fields ++ two.fields\n                , fragments = one.fragments ++ two.fragments\n                }\n            )\n            (\\aliases ->\n                let\n                    ( oneAliasesNew, oneDecoderNew ) =\n                        oneDecoder aliases\n\n                    ( twoAliasesNew, twoDecoderNew ) =\n                        twoDecoder oneAliasesNew\n                in\n                ( twoAliasesNew\n                , Json.Decode.map2 fn oneDecoderNew twoDecoderNew\n                )\n            )\n\n\n{-| -}\noperation :\n    Maybe String\n    ->\n        (Int\n         ->\n            { args : List ( String, VariableDetails )\n            , body : String\n            , fragments : String\n            }\n        )\n    -> (Int -> Json.Decode.Decoder data)\n    -> Selection source data\noperation maybeOpName toGql toDecoder =\n    Selection\n        (Details maybeOpName\n            (\\context ->\n                let\n                    gql =\n                        toGql context.version\n                in\n                { context =\n                    { context\n                        | version = context.version + 1\n                        , variables =\n                            gql.args\n                                |> List.map (protectArgs context.version)\n                                |> Dict.fromList\n                                |> Dict.union context.variables\n                    }\n                , fields = [ Baked gql.body ]\n                , fragments = gql.fragments\n                }\n            )\n            (\\context ->\n                let\n                    decoder =\n                        toDecoder context.version\n                in\n                ( { context\n                    | version = context.version + 1\n                  }\n                , decoder\n                )\n            )\n        )\n\n\nprotectArgs : Int -> ( String, VariableDetails ) -> ( String, VariableDetails )\nprotectArgs version ( name, var ) =\n    ( versionedName version name, var )\n\n\nversionedName : Int -> String -> String\nversionedName i name =\n    if i == 0 then\n        name\n\n    else\n        name ++ \"_batch_\" ++ String.fromInt i\n\n\n{-| Slightly different than versioned name, this is specific to only making an alias if the version is not 0.\n\nso if I'm selecting a field \"myField\"\n\nThen\n\n    versionedAlias 0 \"myField\"\n        -> \"myField\"\n\nbut\n\n    versionedAlias 1 \"myField\"\n        -> \"myField\\_batch\\_1: myField\"\n\n-}\nversionedAlias : Int -> String -> String\nversionedAlias i name =\n    if i == 0 then\n        name\n\n    else\n        name ++ \"_batch_\" ++ String.fromInt i ++ \": \" ++ name\n\n\n\n{- Making requests -}\n\n\n{-| -}\ntype Query\n    = Query\n\n\n{-| -}\ntype Mutation\n    = Mutation\n\n\n{-| -}\ntype Subscription\n    = Subscription\n\n\n{-| -}\ntype Request value\n    = Request\n        { method : String\n        , headers : List ( String, String )\n        , url : String\n        , body : Json.Encode.Value\n        , expect : Http.Response String -> Result Error value\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n\n\n{-| -}\nmapRequest : (a -> b) -> Request a -> Request b\nmapRequest fn (Request request) =\n    Request\n        { method = request.method\n        , headers = request.headers\n        , url = request.url\n        , body = request.body\n        , expect = request.expect >> Result.map fn\n        , timeout = request.timeout\n        , tracker = request.tracker\n        }\n\n\n{-| -}\nsend : Request data -> Cmd (Result Error data)\nsend (Request req) =\n    Http.request\n        { method = req.method\n        , headers = List.map (\\( key, val ) -> Http.header key val) req.headers\n        , url = req.url\n        , body = Http.jsonBody req.body\n        , expect =\n            Http.expectStringResponse identity req.expect\n        , timeout = req.timeout\n        , tracker = req.tracker\n        }\n\n\n{-| -}\nsimulate :\n    { toHeader : String -> String -> header\n    , toExpectation : (Http.Response String -> Result Error value) -> expectation\n    , toBody : Json.Encode.Value -> body\n    , toRequest :\n        { method : String\n        , headers : List header\n        , url : String\n        , body : body\n        , expect : expectation\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n        -> simulated\n    }\n    -> Request value\n    -> simulated\nsimulate config (Request req) =\n    config.toRequest\n        { method = req.method\n        , headers = List.map (\\( key, val ) -> config.toHeader key val) req.headers\n        , url = req.url\n        , body = config.toBody req.body\n        , expect = config.toExpectation req.expect\n        , timeout = req.timeout\n        , tracker = req.tracker\n        }\n\n\n{-| -}\nsubscription :\n    Selection Subscription data\n    ->\n        { payload : Json.Encode.Value\n        , decoder : Json.Decode.Decoder data\n        }\nsubscription ((Selection (Details _ fields toDecoder)) as sel) =\n    let\n        ( context_, decoder ) =\n            toDecoder empty\n    in\n    { payload = encodePayload \"subscription\" sel\n    , decoder = decoder\n    }\n\n\n{-| -}\nquery :\n    Selection Query value\n    ->\n        { headers : List Http.Header\n        , url : String\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n    -> Cmd (Result Error value)\nquery sel config =\n    Http.request\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = body \"query\" sel\n        , expect = expect identity sel\n        , timeout = config.timeout\n        , tracker = config.tracker\n        }\n\n\n{-| -}\nmutation :\n    Selection Mutation msg\n    ->\n        { headers : List Http.Header\n        , url : String\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n    -> Cmd (Result Error msg)\nmutation sel config =\n    Http.request\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = body \"mutation\" sel\n        , expect = expect identity sel\n        , timeout = config.timeout\n        , tracker = config.tracker\n        }\n\n\n{-| -}\nqueryTask :\n    Selection Query value\n    ->\n        { headers : List Http.Header\n        , url : String\n        , timeout : Maybe Float\n        }\n    -> Task Error value\nqueryTask sel config =\n    Http.task\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = body \"query\" sel\n        , resolver = resolver sel\n        , timeout = config.timeout\n        }\n\n\n{-| -}\nmutationTask :\n    Selection Mutation value\n    ->\n        { headers : List Http.Header\n        , url : String\n        , timeout : Maybe Float\n        }\n    -> Task Error value\nmutationTask sel config =\n    Http.task\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = body \"mutation\" sel\n        , resolver = resolver sel\n        , timeout = config.timeout\n        }\n\n\n{-| -}\nqueryRisky :\n    Selection Query value\n    ->\n        { headers : List Http.Header\n        , url : String\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n    -> Cmd (Result Error value)\nqueryRisky sel config =\n    Http.riskyRequest\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = body \"query\" sel\n        , expect = expect identity sel\n        , timeout = config.timeout\n        , tracker = config.tracker\n        }\n\n\n{-| -}\nmutationRisky :\n    Selection Mutation msg\n    ->\n        { headers : List Http.Header\n        , url : String\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n    -> Cmd (Result Error msg)\nmutationRisky sel config =\n    Http.riskyRequest\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = body \"mutation\" sel\n        , expect = expect identity sel\n        , timeout = config.timeout\n        , tracker = config.tracker\n        }\n\n\n{-| -}\nqueryRiskyTask :\n    Selection Query value\n    ->\n        { headers : List Http.Header\n        , url : String\n        , timeout : Maybe Float\n        }\n    -> Task Error value\nqueryRiskyTask sel config =\n    Http.riskyTask\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = body \"query\" sel\n        , resolver = resolver sel\n        , timeout = config.timeout\n        }\n\n\n{-| -}\nmutationRiskyTask :\n    Selection Mutation value\n    ->\n        { headers : List Http.Header\n        , url : String\n        , timeout : Maybe Float\n        }\n    -> Task Error value\nmutationRiskyTask sel config =\n    Http.riskyTask\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = body \"mutation\" sel\n        , resolver = resolver sel\n        , timeout = config.timeout\n        }\n\n\n{-|\n\n      Http.request\n        { method = \"POST\"\n        , headers = []\n        , url = \"https://example.com/gql-endpoint\"\n        , body = Gql.body query\n        , expect = Gql.expect Received query\n        , timeout = Nothing\n        , tracker = Nothing\n        }\n\n-}\nbody : String -> Selection source data -> Http.Body\nbody operationName q =\n    Http.jsonBody\n        (encodePayload operationName q)\n\n\nencodePayload : String -> Selection source data -> Json.Encode.Value\nencodePayload operationName q =\n    Json.Encode.object\n        [ ( \"query\", Json.Encode.string (queryString operationName q) )\n        , ( \"variables\", encodeVariables (selectionVariables q) )\n        ]\n\n\nselectionVariables : Selection source data -> Dict String VariableDetails\nselectionVariables q =\n    (getContext q).variables\n\n\nencodeVariables : Dict String VariableDetails -> Json.Encode.Value\nencodeVariables variables =\n    variables\n        |> Dict.toList\n        |> List.filterMap\n            (\\( varName, var ) ->\n                case var.value of\n                    Nothing ->\n                        Nothing\n\n                    Just value ->\n                        Just ( varName, value )\n            )\n        |> Json.Encode.object\n\n\ngetContext : Selection source selected -> Context\ngetContext (Selection (Details maybeOpName gql _)) =\n    let\n        rendered =\n            gql empty\n    in\n    rendered.context\n\n\n{-| -}\nexpect : (Result Error data -> msg) -> Selection source data -> Http.Expect msg\nexpect toMsg (Selection (Details maybeOpName gql toDecoder)) =\n    let\n        ( context, decoder ) =\n            toDecoder empty\n    in\n    Http.expectStringResponse toMsg (responseToResult decoder)\n\n\n{-| -}\nresolver : Selection source data -> Http.Resolver Error data\nresolver (Selection (Details maybeOpName gql toDecoder)) =\n    let\n        ( context, decoder ) =\n            toDecoder empty\n    in\n    Http.stringResolver (responseToResult decoder)\n\n\nresponseToResult : Json.Decode.Decoder data -> Http.Response String -> Result Error data\nresponseToResult decoder response =\n    case response of\n        Http.BadUrl_ url ->\n            Err (BadUrl url)\n\n        Http.Timeout_ ->\n            Err Timeout\n\n        Http.NetworkError_ ->\n            Err NetworkError\n\n        Http.BadStatus_ metadata responseBody ->\n            Err\n                (BadStatus\n                    { status = metadata.statusCode\n                    , responseBody = responseBody\n                    }\n                )\n\n        Http.GoodStatus_ metadata responseBody ->\n            let\n                bodyDecoder =\n                    Json.Decode.oneOf\n                        [ Json.Decode.map2\n                            (\\_ errs ->\n                                Err errs\n                            )\n                            (Json.Decode.field \"data\" (Json.Decode.null ()))\n                            (Json.Decode.field \"errors\"\n                                (Json.Decode.list gqlErrorDecoder)\n                            )\n                        , Json.Decode.field \"data\" decoder\n                            |> Json.Decode.map Ok\n                        , Json.Decode.field \"errors\"\n                            (Json.Decode.list gqlErrorDecoder)\n                            |> Json.Decode.map Err\n                        ]\n            in\n            case Json.Decode.decodeString bodyDecoder responseBody of\n                Ok (Ok success) ->\n                    Ok success\n\n                Ok (Err graphqlErrors) ->\n                    Err\n                        (ErrorField\n                            { errors = graphqlErrors\n                            }\n                        )\n\n                Err err ->\n                    Err\n                        (BadBody\n                            { responseBody = responseBody\n                            , decodingError = Json.Decode.errorToString err\n                            }\n                        )\n\n\n{-| -}\ntype Error\n    = BadUrl String\n    | Timeout\n    | NetworkError\n    | BadStatus\n        { status : Int\n        , responseBody : String\n        }\n    | BadBody\n        { decodingError : String\n        , responseBody : String\n        }\n    | ErrorField\n        { errors : List GqlError\n        }\n\n\n{-| A graphQL error specified here: <https://github.com/graphql/graphql-spec/blob/main/spec/Section%207%20--%20Response.md>\n-}\ngqlErrorDecoder : Json.Decode.Decoder GqlError\ngqlErrorDecoder =\n    Json.Decode.map4 GqlError\n        (Json.Decode.field \"message\" Json.Decode.string)\n        (Json.Decode.maybe (Json.Decode.field \"path\" (Json.Decode.list Json.Decode.string)))\n        (Json.Decode.maybe (Json.Decode.field \"locations\" (Json.Decode.list locationDecoder)))\n        (Json.Decode.maybe (Json.Decode.field \"extensions\" Json.Decode.value))\n\n\nlocationDecoder : Json.Decode.Decoder Location\nlocationDecoder =\n    Json.Decode.map2 Location\n        (Json.Decode.field \"line\" Json.Decode.int)\n        (Json.Decode.field \"column\" Json.Decode.int)\n\n\ntype alias GqlError =\n    { message : String\n    , path : Maybe (List String)\n    , locations : Maybe (List Location)\n    , extensions : Maybe Json.Decode.Value\n    }\n\n\ntype alias Location =\n    { line : Int\n    , column : Int\n    }\n\n\n{-| -}\nqueryString : String -> Selection source data -> String\nqueryString operationName (Selection (Details maybeOpName gql _)) =\n    let\n        rendered =\n            gql empty\n    in\n    operationName\n        ++ \" \"\n        ++ Maybe.withDefault \"\" maybeOpName\n        ++ renderParameters rendered.context.variables\n        ++ \"{\"\n        ++ fieldsToQueryString rendered.fields \"\"\n        ++ \"}\"\n        ++ rendered.fragments\n\n\nrenderParameters : Dict String VariableDetails -> String\nrenderParameters dict =\n    let\n        paramList =\n            Dict.toList dict\n    in\n    case paramList of\n        [] ->\n            \"\"\n\n        _ ->\n            \"(\" ++ renderParametersHelper paramList \"\" ++ \")\"\n\n\nrenderParametersHelper : List ( String, VariableDetails ) -> String -> String\nrenderParametersHelper args rendered =\n    case args of\n        [] ->\n            rendered\n\n        ( name, value ) :: remaining ->\n            if String.isEmpty rendered then\n                renderParametersHelper remaining (\"$\" ++ name ++ \":\" ++ value.gqlTypeName)\n\n            else\n                renderParametersHelper remaining (rendered ++ \", $\" ++ name ++ \":\" ++ value.gqlTypeName)\n\n\nfieldsToQueryString : List Field -> String -> String\nfieldsToQueryString fields rendered =\n    case fields of\n        [] ->\n            rendered\n\n        top :: remaining ->\n            if String.isEmpty rendered then\n                fieldsToQueryString remaining (renderField top)\n\n            else\n                fieldsToQueryString remaining (rendered ++ \"\\n\" ++ renderField top)\n\n\nrenderField : Field -> String\nrenderField myField =\n    case myField of\n        Baked q ->\n            q\n\n        Fragment name fields ->\n            \"... on \"\n                ++ name\n                ++ \"{\"\n                ++ fieldsToQueryString fields \"\"\n                ++ \"}\"\n\n        Field name maybeAlias args fields ->\n            let\n                aliasString =\n                    maybeAlias\n                        |> Maybe.map (\\a -> a ++ \":\")\n                        |> Maybe.withDefault \"\"\n\n                argString =\n                    case args of\n                        [] ->\n                            \"\"\n\n                        nonEmpty ->\n                            \"(\" ++ renderArgs nonEmpty \"\" ++ \")\"\n\n                selection =\n                    case fields of\n                        [] ->\n                            \"\"\n\n                        _ ->\n                            \"{\" ++ fieldsToQueryString fields \"\" ++ \"}\"\n            in\n            aliasString ++ name ++ argString ++ selection\n\n\nrenderArgs : List ( String, Variable ) -> String -> String\nrenderArgs args rendered =\n    case args of\n        [] ->\n            rendered\n\n        ( name, Variable varName ) :: remaining ->\n            if String.isEmpty rendered then\n                renderArgs remaining (rendered ++ name ++ \": $\" ++ varName)\n\n            else\n                renderArgs remaining (rendered ++ \", \" ++ name ++ \": $\" ++ varName)\n"
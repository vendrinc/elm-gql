export default (): string => "module GraphQL.Engine exposing\n    ( batch\n    , nullable, list, object, objectWith, decode\n    , enum, maybeEnum\n    , field, fieldWith\n    , union\n    , Selection, select, with, map, map2, recover\n    , arg, argList, Optional, optional\n    , Query, query, Mutation, mutation, Error(..)\n    , prebakedQuery, Premade, premadeOperation\n    , queryString\n    , Argument(..), maybeScalarEncode\n    , encodeOptionals, encodeOptionalsAsJson, encodeInputObject, encodeArgument\n    , decodeNullable, getGql, mapPremade\n    , unsafe, selectTypeNameButSkip\n    , Request, toRequest, send, simulate, mapRequest\n    , Option(..), InputObject, inputObject, addField, addOptionalField, encodeInputObjectAsJson, inputObjectToFieldList\n    , jsonField, andMap\n    , bakeToSelection\n    )\n\n{-|\n\n@docs batch\n\n@docs nullable, list, object, objectWith, decode\n\n@docs enum, maybeEnum\n\n@docs field, fieldWith\n\n@docs union\n\n@docs Selection, select, with, map, map2, recover\n\n@docs arg, argList, Optional, optional\n\n@docs Query, query, Mutation, mutation, Error\n\n@docs prebakedQuery, Premade, premadeOperation\n\n@docs queryString\n\n@docs Argument, maybeScalarEncode\n\n@docs encodeOptionals, encodeOptionalsAsJson, encodeInputObject, encodeArgument\n\n@docs decodeNullable, getGql, mapPremade\n\n@docs unsafe, selectTypeNameButSkip\n\n@docs Request, toRequest, send, simulate, mapRequest\n\n@docs Option, InputObject, inputObject, addField, addOptionalField, encodeInputObjectAsJson, inputObjectToFieldList\n\n@docs jsonField, andMap\n\n-}\n\nimport Dict exposing (Dict)\nimport Http\nimport Json.Decode as Decode\nimport Json.Encode as Encode\nimport Set\n\n\n{-| Batch a number of selection sets together!\n-}\nbatch : List (Selection source data) -> Selection source (List data)\nbatch selections =\n    Selection <|\n        Details\n            (\\context ->\n                List.foldl\n                    (\\(Selection (Details toFieldsGql _)) ( ctxt, fields ) ->\n                        let\n                            ( newCtxt, newFields ) =\n                                toFieldsGql ctxt\n                        in\n                        ( newCtxt\n                        , fields ++ newFields\n                        )\n                    )\n                    ( context, [] )\n                    selections\n            )\n            (\\context ->\n                List.foldl\n                    (\\(Selection (Details _ toItemDecoder)) ( ctxt, cursorFieldsDecoder ) ->\n                        let\n                            ( newCtxt, itemDecoder ) =\n                                toItemDecoder ctxt\n                        in\n                        ( newCtxt\n                        , cursorFieldsDecoder\n                            |> Decode.andThen\n                                (\\existingList ->\n                                    Decode.map\n                                        (\\item ->\n                                            item :: existingList\n                                        )\n                                        itemDecoder\n                                )\n                        )\n                    )\n                    ( context, Decode.succeed [] )\n                    selections\n            )\n\n\n{-| -}\nrecover : recovered -> (data -> recovered) -> Selection source data -> Selection source recovered\nrecover default wrapValue (Selection (Details toQuery toDecoder)) =\n    Selection\n        (Details toQuery\n            (\\context ->\n                let\n                    ( newContext, decoder ) =\n                        toDecoder context\n                in\n                ( newContext\n                , Decode.oneOf\n                    [ Decode.map wrapValue decoder\n                    , Decode.succeed default\n                    ]\n                )\n            )\n        )\n\n\n{-| -}\nunion : List ( String, Selection source data ) -> Selection source data\nunion options =\n    Selection <|\n        Details\n            (\\context ->\n                let\n                    ( fragments, fragmentContext ) =\n                        List.foldl\n                            (\\( name, Selection (Details fragQuery _) ) ( frags, currentContext ) ->\n                                let\n                                    ( newContext, fields ) =\n                                        fragQuery currentContext\n\n                                    nonEmptyFields =\n                                        case fields of\n                                            [] ->\n                                                -- we're already selecting typename at the root.\n                                                -- this is just so we don't have an empty set of brackets\n                                                [ Field \"__typename\" Nothing [] [] ]\n\n                                            _ ->\n                                                fields\n                                in\n                                ( Fragment name nonEmptyFields :: frags\n                                , newContext\n                                )\n                            )\n                            ( [], context )\n                            options\n                in\n                ( fragmentContext\n                , Field \"__typename\" Nothing [] [] :: fragments\n                )\n            )\n            (\\context ->\n                let\n                    ( fragmentDecoders, fragmentContext ) =\n                        List.foldl\n                            (\\( name, Selection (Details _ toFragDecoder) ) ( frags, currentContext ) ->\n                                let\n                                    ( newContext, fragDecoder ) =\n                                        toFragDecoder currentContext\n\n                                    fragDecoderWithTypename =\n                                        Decode.field \"__typename\" Decode.string\n                                            |> Decode.andThen\n                                                (\\typename ->\n                                                    if typename == name then\n                                                        fragDecoder\n\n                                                    else\n                                                        Decode.fail \"Unknown union variant\"\n                                                )\n                                in\n                                ( fragDecoderWithTypename :: frags\n                                , newContext\n                                )\n                            )\n                            ( [], context )\n                            options\n                in\n                ( fragmentContext\n                , Decode.oneOf fragmentDecoders\n                )\n            )\n\n\n{-| -}\nmaybeEnum : List ( String, item ) -> Decode.Decoder (Maybe item)\nmaybeEnum options =\n    Decode.oneOf\n        [ Decode.map Just (enum options)\n        , Decode.succeed Nothing\n        ]\n\n\n{-| -}\nenum : List ( String, item ) -> Decode.Decoder item\nenum options =\n    Decode.string\n        |> Decode.andThen\n            (findFirstMatch options)\n\n\nfindFirstMatch : List ( String, item ) -> String -> Decode.Decoder item\nfindFirstMatch options str =\n    case options of\n        [] ->\n            Decode.fail (\"Unexpected enum value: \" ++ str)\n\n        ( name, value ) :: remaining ->\n            if name == str then\n                Decode.succeed value\n\n            else\n                findFirstMatch remaining str\n\n\n{-| Used in generated code to handle maybes\n-}\nnullable : Selection source data -> Selection source (Maybe data)\nnullable (Selection (Details toFieldsGql toFieldsDecoder)) =\n    Selection <|\n        Details\n            toFieldsGql\n            (\\context ->\n                let\n                    ( fieldContext, fieldsDecoder ) =\n                        toFieldsDecoder context\n                in\n                ( fieldContext\n                , Decode.oneOf\n                    [ Decode.map Just fieldsDecoder\n                    , Decode.succeed Nothing\n                    ]\n                )\n            )\n\n\n{-| Used in generated code to handle maybes\n-}\nlist : Selection source data -> Selection source (List data)\nlist (Selection (Details toFieldsGql toFieldsDecoder)) =\n    Selection <|\n        Details\n            toFieldsGql\n            (\\context ->\n                let\n                    ( fieldContext, fieldsDecoder ) =\n                        toFieldsDecoder context\n                in\n                ( fieldContext\n                , Decode.list fieldsDecoder\n                )\n            )\n\n\n{-| -}\nobject : String -> Selection source data -> Selection otherSource data\nobject =\n    objectWith (inputObject \"NoArgs\")\n\n\ntype Variable\n    = Variable String\n\n\n{-| -}\nobjectWith : InputObject args -> String -> Selection source data -> Selection otherSource data\nobjectWith inputObj name (Selection (Details toFieldsGql toFieldsDecoder)) =\n    Selection <|\n        Details\n            (\\context ->\n                let\n                    ( fieldContext, fields ) =\n                        toFieldsGql { context | aliases = Dict.empty }\n\n                    new =\n                        applyContext inputObj name { fieldContext | aliases = context.aliases }\n                in\n                ( new.context\n                , [ Field name new.aliasString new.args fields\n                  ]\n                )\n            )\n            (\\context ->\n                let\n                    ( fieldContext, fieldsDecoder ) =\n                        toFieldsDecoder { context | aliases = Dict.empty }\n\n                    new =\n                        applyContext inputObj name { fieldContext | aliases = context.aliases }\n\n                    aliasedName =\n                        Maybe.withDefault name new.aliasString\n                in\n                ( new.context\n                , Decode.field aliasedName fieldsDecoder\n                )\n            )\n\n\n{-| This adds a bare decoder for data that has already been pulled down.\n\nNote, this is rarely needed! So far, only when a query or mutation returns a scalar directly without selecting any fields.\n\n-}\ndecode : Decode.Decoder data -> Selection source data\ndecode decoder =\n    Selection <|\n        Details\n            (\\context ->\n                ( context\n                , []\n                )\n            )\n            (\\context ->\n                ( context\n                , decoder\n                )\n            )\n\n\n{-| -}\nselectTypeNameButSkip : Selection source ()\nselectTypeNameButSkip =\n    Selection <|\n        Details\n            (\\context ->\n                ( context\n                , [ Field \"__typename\" Nothing [] []\n                  ]\n                )\n            )\n            (\\context ->\n                ( context\n                , Decode.succeed ()\n                )\n            )\n\n\n{-| -}\nfield : String -> String -> Decode.Decoder data -> Selection source data\nfield name gqlTypeName decoder =\n    fieldWith (inputObject gqlTypeName) name gqlTypeName decoder\n\n\n{-| -}\nfieldWith : InputObject args -> String -> String -> Decode.Decoder data -> Selection source data\nfieldWith args name gqlType decoder =\n    Selection <|\n        Details\n            (\\context ->\n                let\n                    new =\n                        applyContext args name context\n                in\n                ( new.context\n                , [ Field name new.aliasString new.args []\n                  ]\n                )\n            )\n            (\\context ->\n                let\n                    new =\n                        applyContext args name context\n\n                    aliasedName =\n                        Maybe.withDefault name new.aliasString\n                in\n                ( new.context\n                , Decode.field aliasedName decoder\n                )\n            )\n\n\napplyContext :\n    InputObject args\n    -> String\n    -> Context\n    ->\n        { context : Context\n        , aliasString : Maybe String\n        , args : List ( String, Variable )\n        }\napplyContext args name context =\n    let\n        ( maybeAlias, newAliases ) =\n            makeAlias name context.aliases\n\n        ( vars, newVariables ) =\n            captureArgs args context.variables\n    in\n    { context =\n        { aliases = newAliases\n        , variables = newVariables\n        }\n    , aliasString = maybeAlias\n    , args = vars\n    }\n\n\n{-| This is the piece of code that's responsible for swapping real argument values (i.e. json values)\n\nwith variables.\n\n-}\ncaptureArgs :\n    InputObject args\n    -> Dict String VariableDetails\n    ->\n        ( List ( String, Variable )\n        , Dict String VariableDetails\n        )\ncaptureArgs (InputObject objname args) context =\n    case args of\n        [] ->\n            ( [], context )\n\n        _ ->\n            captureArgsHelper args context []\n\n\n{-| -}\ncaptureArgsHelper :\n    List ( String, VariableDetails )\n    -> Dict String VariableDetails\n    -> List ( String, Variable )\n    ->\n        ( List ( String, Variable )\n        , Dict String VariableDetails\n        )\ncaptureArgsHelper args context alreadyPassed =\n    case args of\n        [] ->\n            ( alreadyPassed, context )\n\n        ( name, value ) :: remaining ->\n            let\n                varname =\n                    getValidVariableName name 0 context\n\n                newContext =\n                    Dict.insert varname value context\n            in\n            captureArgsHelper remaining\n                newContext\n                (( name, Variable varname ) :: alreadyPassed)\n\n\ngetValidVariableName : String -> Int -> Dict String val -> String\ngetValidVariableName str index used =\n    let\n        attemptedName =\n            if index == 0 then\n                str\n\n            else\n                str ++ String.fromInt index\n    in\n    if Dict.member attemptedName used then\n        getValidVariableName str (index + 1) used\n\n    else\n        attemptedName\n\n\nmakeAlias : String -> Dict String Int -> ( Maybe String, Dict String Int )\nmakeAlias name aliases =\n    case Dict.get name aliases of\n        Nothing ->\n            ( Nothing, Dict.insert name 0 aliases )\n\n        Just found ->\n            ( Just (name ++ String.fromInt (found + 1))\n            , Dict.insert name (found + 1) aliases\n            )\n\n\n{-| -}\ntype Selection source selected\n    = Selection (Details selected)\n\n\ntype alias Context =\n    { aliases : Dict String Int\n    , variables : Dict String VariableDetails\n    }\n\n\ntype alias VariableDetails =\n    { gqlTypeName : String\n    , value : Encode.Value\n    }\n\n\n{-| -}\nunsafe : Selection source selected -> Selection unsafe selected\nunsafe (Selection deets) =\n    Selection deets\n\n\ntype Free\n    = Free\n\n\ntoFree : Argument thing -> Argument Free\ntoFree argument =\n    case argument of\n        ArgValue json tag ->\n            ArgValue json tag\n\n        Var varname ->\n            Var varname\n\n\nempty : Context\nempty =\n    { aliases = Dict.empty\n    , variables = Dict.empty\n    }\n\n\n{-| An unguarded GQL query.\n-}\ntype Details selected\n    = Details\n        -- This is an optional *operation name*\n        -- Can only be set on Queries and Mutations\n        (Maybe String)\n        -- Both of these take a Set String, which is how we're keeping track of\n        -- what needs to be aliased\n        -- How to make the gql query\n        (Context -> ( Context, List Field ))\n        -- How to decode the data coming back\n        (Context -> ( Context, Decode.Decoder selected ))\n\n\ntype Field\n    = --    name   alias          args                        children\n      Field String (Maybe String) (List ( String, Variable )) (List Field)\n      --        ...on FragmentName\n    | Fragment String (List Field)\n      -- a piece of GQL that has been validated separately\n      -- This is generally for operational gql\n    | Baked String\n\n\n{-| We can also accept:\n\n  - Enum values (unquoted)\n  - custom scalars\n\nBut we can define anything else in terms of these:\n\n-}\ntype Argument obj\n    = ArgValue Encode.Value String\n    | Var String\n\n\n{-| -}\ntype Option value\n    = Present value\n    | Null\n    | Absent\n\n\n{-| -}\ntype InputObject value\n    = InputObject String (List ( String, VariableDetails ))\n\n\n{-| -}\ninputObject : String -> InputObject value\ninputObject name =\n    InputObject name []\n\n\n{-| -}\naddField : String -> String -> Encode.Value -> InputObject value -> InputObject value\naddField fieldName gqlFieldType val (InputObject name inputFields) =\n    InputObject name\n        (( fieldName\n         , { gqlTypeName = gqlFieldType\n           , value = val\n           }\n         )\n            :: inputFields\n        )\n\n\n{-| -}\naddOptionalField : String -> String -> Option value -> (value -> Encode.Value) -> InputObject input -> InputObject input\naddOptionalField fieldName gqlFieldType optionalValue toJsonValue (InputObject name inputFields) =\n    InputObject name\n        (case optionalValue of\n            Absent ->\n                inputFields\n\n            Null ->\n                ( fieldName, { value = Encode.null, gqlTypeName = gqlFieldType } ) :: inputFields\n\n            Present val ->\n                ( fieldName, { value = toJsonValue val, gqlTypeName = gqlFieldType } ) :: inputFields\n        )\n\n\n{-| -}\ntype Optional arg\n    = Optional String (Argument arg)\n\n\n{-| The encoded value and the name of the expected type for this argument\n-}\narg : Encode.Value -> String -> Argument obj\narg val typename =\n    ArgValue val typename\n\n\n{-| -}\nargList : List (Argument obj) -> String -> Argument input\nargList fields typeName =\n    ArgValue\n        (fields\n            |> Encode.list\n                (\\argVal ->\n                    case argVal of\n                        ArgValue val _ ->\n                            val\n\n                        Var varName ->\n                            Encode.string varName\n                )\n        )\n        typeName\n\n\n{-| -}\ninputObjectToFieldList : InputObject a -> List ( String, VariableDetails )\ninputObjectToFieldList (InputObject _ fields) =\n    fields\n\n\n{-| -}\nencodeInputObjectAsJson : InputObject value -> Decode.Value\nencodeInputObjectAsJson (InputObject _ fields) =\n    Encode.object (List.map (\\( fieldName, details ) -> ( fieldName, details.value )) fields)\n\n\n{-| -}\nencodeInputObject : List ( String, Argument obj ) -> String -> Argument input\nencodeInputObject fields typeName =\n    ArgValue\n        (fields\n            |> List.map\n                (\\( name, argVal ) ->\n                    case argVal of\n                        ArgValue val _ ->\n                            ( name, val )\n\n                        Var varName ->\n                            ( name, Encode.string varName )\n                )\n            |> Encode.object\n        )\n        typeName\n\n\n{-| -}\nencodeArgument : Argument obj -> Encode.Value\nencodeArgument argVal =\n    case argVal of\n        ArgValue val _ ->\n            val\n\n        Var varName ->\n            Encode.string varName\n\n\n{-| -}\nencodeOptionals : List (Optional arg) -> List ( String, Argument arg )\nencodeOptionals opts =\n    List.foldl\n        (\\(Optional optName argument) (( found, gathered ) as skip) ->\n            if Set.member optName found then\n                skip\n\n            else\n                ( Set.insert optName found\n                , ( optName, argument ) :: gathered\n                )\n        )\n        ( Set.empty, [] )\n        opts\n        |> Tuple.second\n\n\n{-| -}\nencodeOptionalsAsJson : List (Optional arg) -> List ( String, Encode.Value )\nencodeOptionalsAsJson opts =\n    List.foldl\n        (\\(Optional optName argument) (( found, gathered ) as skip) ->\n            if Set.member optName found then\n                skip\n\n            else\n                ( Set.insert optName found\n                , ( optName, argument ) :: gathered\n                )\n        )\n        ( Set.empty, [] )\n        opts\n        |> Tuple.second\n        |> List.map (Tuple.mapSecond encodeArgument)\n\n\n{-|\n\n    Encode the nullability in the argument itself.\n\n-}\noptional : String -> Argument arg -> Optional arg\noptional =\n    Optional\n\n\n{-| -}\nselect : data -> Selection source data\nselect data =\n    Selection\n        (Details Nothing\n            (\\context ->\n                ( context, [] )\n            )\n            (\\context ->\n                ( context, Decode.succeed data )\n            )\n        )\n\n\n{-| -}\nwith : Selection source a -> Selection source (a -> b) -> Selection source b\nwith =\n    map2 (|>)\n\n\n{-| -}\nmap : (a -> b) -> Selection source a -> Selection source b\nmap fn (Selection (Details maybeOpName fields decoder)) =\n    Selection <|\n        Details maybeOpName\n            fields\n            (\\aliases ->\n                let\n                    ( newAliases, newDecoder ) =\n                        decoder aliases\n                in\n                ( newAliases, Decode.map fn newDecoder )\n            )\n\n\nmergeOpNames : Maybe String -> Maybe String -> Maybe String\nmergeOpNames maybeOne maybeTwo =\n    case ( maybeOne, maybeTwo ) of\n        ( Nothing, Nothing ) ->\n            Nothing\n\n        ( Just one, _ ) ->\n            Just one\n\n        _ ->\n            two\n\n\n{-| -}\nmap2 : (a -> b -> c) -> Selection source a -> Selection source b -> Selection source c\nmap2 fn (Selection (Details oneOpName oneFields oneDecoder)) (Selection (Details twoOpName twoFields twoDecoder)) =\n    Selection <|\n        Details\n            (mergeOpNames oneOpName twoOpName)\n            (\\aliases ->\n                let\n                    ( oneAliasesNew, oneFieldsNew ) =\n                        oneFields aliases\n\n                    ( twoAliasesNew, twoFieldsNew ) =\n                        twoFields oneAliasesNew\n                in\n                ( twoAliasesNew\n                , oneFieldsNew ++ twoFieldsNew\n                )\n            )\n            (\\aliases ->\n                let\n                    ( oneAliasesNew, oneDecoderNew ) =\n                        oneDecoder aliases\n\n                    ( twoAliasesNew, twoDecoderNew ) =\n                        twoDecoder oneAliasesNew\n                in\n                ( twoAliasesNew\n                , Decode.map2 fn oneDecoderNew twoDecoderNew\n                )\n            )\n\n\n{-| -}\nbakeToSelection : Maybe String -> String -> List ( String, VariableDetails ) -> Decode.Decoder data -> Premade data\nbakeToSelection maybeOpName gql args decoder =\n    Selection\n        (Details maybeOpName\n            (\\context ->\n                ( { context\n                    | variables =\n                        args\n                            |> Dict.fromList\n                            |> Dict.union context.variables\n                  }\n                , [ Baked gql ]\n                )\n            )\n            (\\context ->\n                ( { context\n                    | variables =\n                        args\n                            |> Dict.fromList\n                            |> Dict.union context.variables\n                  }\n                , decoder\n                )\n            )\n        )\n\n\n{-| -}\nprebakedQuery : String -> List ( String, VariableDetails ) -> Decode.Decoder data -> Premade data\nprebakedQuery gql args decoder =\n    Premade\n        { gql = gql\n        , args = List.map (Tuple.mapSecond .value) args\n        , decoder = decoder\n        }\n\n\n\n{- Making requests -}\n\n\n{-| -}\ntype Premade data\n    = Premade\n        { gql : String\n        , decoder : Decode.Decoder data\n        , args : List ( String, Encode.Value )\n        }\n\n\n{-| -}\ntype Query\n    = Query\n\n\n{-| -}\ntype Mutation\n    = Mutation\n\n\n{-| -}\ngetGql : Premade data -> String\ngetGql (Premade { gql }) =\n    gql\n\n\n{-| -}\nmapPremade : (a -> b) -> Premade a -> Premade b\nmapPremade fn (Premade details) =\n    Premade\n        { gql = details.gql\n        , decoder = Decode.map fn details.decoder\n        , args = details.args\n        }\n\n\n{-| -}\npremadeOperation :\n    Premade value\n    ->\n        { headers : List Http.Header\n        , url : String\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n    -> Cmd (Result Error value)\npremadeOperation sel config =\n    Http.request\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = Http.jsonBody (bodyPremade sel)\n        , expect = expectPremade sel\n        , timeout = config.timeout\n        , tracker = config.tracker\n        }\n\n\n{-| -}\ntype Request value\n    = Request\n        { method : String\n        , headers : List ( String, String )\n        , url : String\n        , body : Encode.Value\n        , expect : Http.Response String -> Result Error value\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n\n\n{-| -}\nmapRequest : (a -> b) -> Request a -> Request b\nmapRequest fn (Request request) =\n    Request\n        { method = request.method\n        , headers = request.headers\n        , url = request.url\n        , body = request.body\n        , expect = request.expect >> Result.map fn\n        , timeout = request.timeout\n        , tracker = request.tracker\n        }\n\n\n{-| Return details that can be directly given to `Http.request`.\n\nThis is so that wiring up [Elm Program Test](https://package.elm-lang.org/packages/avh4/elm-program-test/latest/ProgramTest) is relatively easy.\n\n-}\ntoRequest :\n    Premade value\n    ->\n        { headers : List ( String, String )\n        , url : String\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n    -> Request value\ntoRequest sel config =\n    Request\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = bodyPremade sel\n        , expect = decodePremade sel\n        , timeout = config.timeout\n        , tracker = config.tracker\n        }\n\n\n{-| -}\nsend : Request data -> Cmd (Result Error data)\nsend (Request req) =\n    Http.request\n        { method = req.method\n        , headers = List.map (\\( key, val ) -> Http.header key val) req.headers\n        , url = req.url\n        , body = Http.jsonBody req.body\n        , expect =\n            Http.expectStringResponse identity req.expect\n        , timeout = req.timeout\n        , tracker = req.tracker\n        }\n\n\n{-| -}\nsimulate :\n    { toHeader : String -> String -> header\n    , toExpectation : (Http.Response String -> Result Error value) -> expectation\n    , toBody : Encode.Value -> body\n    , toRequest :\n        { method : String\n        , headers : List header\n        , url : String\n        , body : body\n        , expect : expectation\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n        -> simulated\n    }\n    -> Request value\n    -> simulated\nsimulate config (Request req) =\n    config.toRequest\n        { method = req.method\n        , headers = List.map (\\( key, val ) -> config.toHeader key val) req.headers\n        , url = req.url\n        , body = config.toBody req.body\n        , expect = config.toExpectation req.expect\n        , timeout = req.timeout\n        , tracker = req.tracker\n        }\n\n\n{-| -}\nquery :\n    Selection Query value\n    ->\n        { name : Maybe String\n        , headers : List Http.Header\n        , url : String\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n    -> Cmd (Result Error value)\nquery sel config =\n    Http.request\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = body \"query\" config.name sel\n        , expect = expect identity sel\n        , timeout = config.timeout\n        , tracker = config.tracker\n        }\n\n\n{-| -}\nmutation :\n    Selection Mutation msg\n    ->\n        { name : Maybe String\n        , headers : List Http.Header\n        , url : String\n        , timeout : Maybe Float\n        , tracker : Maybe String\n        }\n    -> Cmd (Result Error msg)\nmutation sel config =\n    Http.request\n        { method = \"POST\"\n        , headers = config.headers\n        , url = config.url\n        , body = body \"mutation\" config.name sel\n        , expect = expect identity sel\n        , timeout = config.timeout\n        , tracker = config.tracker\n        }\n\n\n{-|\n\n      Http.request\n        { method = \"POST\"\n        , headers = []\n        , url = \"https://example.com/gql-endpoint\"\n        , body = Gql.body query\n        , expect = Gql.expect Received query\n        , timeout = Nothing\n        , tracker = Nothing\n        }\n\n-}\nbody : String -> Maybe String -> Selection source data -> Http.Body\nbody operation maybeUnformattedName q =\n    let\n        maybeName =\n            case maybeUnformattedName of\n                Nothing ->\n                    getOperationLabel q\n\n                Just unformatted ->\n                    Just (sanitizeOperationName unformatted)\n\n        variables : Dict String VariableDetails\n        variables =\n            (getContext q).variables\n\n        encodedVariables : Decode.Value\n        encodedVariables =\n            variables\n                |> Dict.toList\n                |> List.map (Tuple.mapSecond .value)\n                |> Encode.object\n    in\n    Http.jsonBody\n        (Encode.object\n            (List.filterMap identity\n                [ Maybe.map (\\name -> ( \"operationName\", Encode.string name )) maybeName\n                , Just ( \"query\", Encode.string (queryString operation maybeName q) )\n                , Just ( \"variables\", encodedVariables )\n                ]\n            )\n        )\n\n\n{-|\n\n      Http.request\n        { method = \"POST\"\n        , headers = []\n        , url = \"https://example.com/gql-endpoint\"\n        , body = Gql.body query\n        , expect = Gql.expect Received query\n        , timeout = Nothing\n        , tracker = Nothing\n        }\n\n-}\nbodyPremade : Premade data -> Encode.Value\nbodyPremade (Premade q) =\n    Encode.object\n        (List.filterMap identity\n            [ Just ( \"query\", Encode.string q.gql )\n            , Just ( \"variables\", Encode.object q.args )\n            ]\n        )\n\n\n{-|\n\n    Operation names need to be formatted in a certain way.\n\n    This is maybe too restrictive, but this keeps everything as [a-zA-Z0-9] and _\n\n    None matching characters will be transformed to _.\n\n-}\nsanitizeOperationName : String -> String\nsanitizeOperationName input =\n    String.toList input\n        |> List.map\n            (\\c ->\n                if Char.isAlphaNum c || c == '_' then\n                    c\n\n                else\n                    '_'\n            )\n        |> String.fromList\n\n\ngetContext : Selection source selected -> Context\ngetContext (Selection (Details gql _)) =\n    let\n        ( context, fields ) =\n            gql empty\n    in\n    context\n\n\ngetOperationLabel : Selection source selected -> Maybe String\ngetOperationLabel (Selection (Details maybeLabel _ _)) =\n    maybeLabel\n\n\n{-| -}\nexpect : (Result Error data -> msg) -> Selection source data -> Http.Expect msg\nexpect toMsg (Selection (Details gql toDecoder)) =\n    let\n        ( context, decoder ) =\n            toDecoder empty\n    in\n    Http.expectStringResponse toMsg <|\n        \\response ->\n            case response of\n                Http.BadUrl_ url ->\n                    Err (BadUrl url)\n\n                Http.Timeout_ ->\n                    Err Timeout\n\n                Http.NetworkError_ ->\n                    Err NetworkError\n\n                Http.BadStatus_ metadata responseBody ->\n                    Err\n                        (BadStatus\n                            { status = metadata.statusCode\n                            , responseBody = responseBody\n                            }\n                        )\n\n                Http.GoodStatus_ metadata responseBody ->\n                    case Decode.decodeString (Decode.field \"data\" decoder) responseBody of\n                        Ok value ->\n                            Ok value\n\n                        Err err ->\n                            Err\n                                (BadBody\n                                    { responseBody = responseBody\n                                    , decodingError = Decode.errorToString err\n                                    }\n                                )\n\n\n{-| -}\nexpectPremade : Premade data -> Http.Expect (Result Error data)\nexpectPremade q =\n    Http.expectStringResponse identity (decodePremade q)\n\n\ndecodePremade : Premade value -> Http.Response String -> Result Error value\ndecodePremade (Premade premadeQuery) response =\n    case response of\n        Http.BadUrl_ url ->\n            Err (BadUrl url)\n\n        Http.Timeout_ ->\n            Err Timeout\n\n        Http.NetworkError_ ->\n            Err NetworkError\n\n        Http.BadStatus_ metadata responseBody ->\n            Err\n                (BadStatus\n                    { status = metadata.statusCode\n                    , responseBody = responseBody\n                    }\n                )\n\n        Http.GoodStatus_ metadata responseBody ->\n            case Decode.decodeString (Decode.field \"data\" premadeQuery.decoder) responseBody of\n                Ok value ->\n                    Ok value\n\n                Err err ->\n                    Err\n                        (BadBody\n                            { responseBody = responseBody\n                            , decodingError = Decode.errorToString err\n                            }\n                        )\n\n\n{-| -}\ntype Error\n    = BadUrl String\n    | Timeout\n    | NetworkError\n    | BadStatus\n        { status : Int\n        , responseBody : String\n        }\n    | BadBody\n        { decodingError : String\n        , responseBody : String\n        }\n\n\n{-| -}\nqueryString : String -> Maybe String -> Selection source data -> String\nqueryString operation queryName (Selection (Details gql _)) =\n    let\n        ( context, fields ) =\n            gql empty\n    in\n    operation\n        ++ \" \"\n        ++ Maybe.withDefault \"\" queryName\n        ++ renderParameters context.variables\n        ++ \"{\"\n        ++ fieldsToQueryString fields \"\"\n        ++ \"}\"\n\n\nrenderParameters : Dict String VariableDetails -> String\nrenderParameters dict =\n    let\n        paramList =\n            Dict.toList dict\n    in\n    case paramList of\n        [] ->\n            \"\"\n\n        _ ->\n            \"(\" ++ renderParametersHelper paramList \"\" ++ \")\"\n\n\nrenderParametersHelper : List ( String, VariableDetails ) -> String -> String\nrenderParametersHelper args rendered =\n    case args of\n        [] ->\n            rendered\n\n        ( name, value ) :: remaining ->\n            if String.isEmpty rendered then\n                renderParametersHelper remaining (\"$\" ++ name ++ \":\" ++ value.gqlTypeName)\n\n            else\n                renderParametersHelper remaining (rendered ++ \", $\" ++ name ++ \":\" ++ value.gqlTypeName)\n\n\nfieldsToQueryString : List Field -> String -> String\nfieldsToQueryString fields rendered =\n    case fields of\n        [] ->\n            rendered\n\n        top :: remaining ->\n            if String.isEmpty rendered then\n                fieldsToQueryString remaining (renderField top)\n\n            else\n                fieldsToQueryString remaining (rendered ++ \"\\n\" ++ renderField top)\n\n\nrenderField : Field -> String\nrenderField myField =\n    case myField of\n        Baked q ->\n            q\n\n        Fragment name fields ->\n            \"... on \"\n                ++ name\n                ++ \"{\"\n                ++ fieldsToQueryString fields \"\"\n                ++ \"}\"\n\n        Field name maybeAlias args fields ->\n            let\n                aliasString =\n                    maybeAlias\n                        |> Maybe.map (\\a -> a ++ \":\")\n                        |> Maybe.withDefault \"\"\n\n                argString =\n                    case args of\n                        [] ->\n                            \"\"\n\n                        nonEmpty ->\n                            \"(\" ++ renderArgs nonEmpty \"\" ++ \")\"\n\n                selection =\n                    case fields of\n                        [] ->\n                            \"\"\n\n                        _ ->\n                            \"{\" ++ fieldsToQueryString fields \"\" ++ \"}\"\n            in\n            aliasString ++ name ++ argString ++ selection\n\n\nrenderArgs : List ( String, Variable ) -> String -> String\nrenderArgs args rendered =\n    case args of\n        [] ->\n            rendered\n\n        ( name, Variable varName ) :: remaining ->\n            if String.isEmpty rendered then\n                renderArgs remaining (rendered ++ name ++ \": $\" ++ varName)\n\n            else\n                renderArgs remaining (rendered ++ \", \" ++ name ++ \": $\" ++ varName)\n\n\nargToString : Argument arg -> String\nargToString argument =\n    case argument of\n        ArgValue json typename ->\n            Encode.encode 0 json\n\n        Var str ->\n            \"$\" ++ str\n\n\nargToTypeString : Argument arg -> String\nargToTypeString argument =\n    case argument of\n        ArgValue v typename ->\n            typename\n\n        Var str ->\n            \"\"\n\n\n{-| -}\nmaybeScalarEncode : (a -> Encode.Value) -> Maybe a -> Encode.Value\nmaybeScalarEncode encoder maybeA =\n    maybeA\n        |> Maybe.map encoder\n        |> Maybe.withDefault Encode.null\n\n\n{-| -}\ndecodeNullable : Decode.Decoder data -> Decode.Decoder (Maybe data)\ndecodeNullable =\n    Decode.nullable\n\n\njsonField :\n    String\n    -> Json.Decode.Decoder a\n    -> Json.Decode.Decoder (a -> inner -> (inner -> inner2) -> inner2)\n    -> Json.Decode.Decoder (inner -> (inner -> inner2) -> inner2)\njsonField name new build =\n    Json.Decode.map2\n        (\\map2Unpack -> \\unpack -> \\inner inner2 -> inner2 inner)\n        (Json.Decode.field name new)\n        build\n\n\nandMap :\n    Json.Decode.Decoder map2Unpack\n    -> Json.Decode.Decoder (map2Unpack -> inner -> (inner -> inner2) -> inner2)\n    -> Json.Decode.Decoder (inner -> (inner -> inner2) -> inner2)\nandMap new build =\n    Json.Decode.map2\n        (\\map2Unpack -> \\unpack -> \\inner inner2 -> inner2 inner)\n        new\n        build\n"
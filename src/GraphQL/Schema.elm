module GraphQL.Schema exposing
    ( getJsonValue
    , Mutation, Query, decoder, empty
    , Kind(..), Schema, Type(..), isScalar
    , mockScalar
    , Wrapped(..), getWrap, getInner
    , toString
    , Argument, Field, InputObjectDetails, InterfaceDetails, Namespace, ObjectDetails, ScalarDetails, UnionDetails, Variant, kindToString, typeToElmString, typeToString
    )

{-|

@docs getJsonValue

@docs Mutation, Query, decoder, empty

@docs Kind, Schema, Type, isScalar

@docs mockScalar

@docs Wrapped, getWrap, getInner

@docs toString

-}

import Dict exposing (Dict)
import Http
import Json.Decode as Json
import Json.Encode


type alias Namespace =
    { namespace : String
    , enums : String
    }



-- Definition


type alias Schema =
    { queries : Dict Ref Query
    , mutations : Dict Ref Mutation
    , objects : Dict Ref ObjectDetails
    , scalars : Dict Ref ScalarDetails
    , inputObjects : Dict Ref InputObjectDetails
    , enums : Dict Ref EnumDetails
    , unions : Dict Ref UnionDetails
    , interfaces : Dict Ref InterfaceDetails
    }


type Deprecation
    = Deprecated (Maybe String)
    | Active


type alias ScalarDetails =
    { name : String
    , description : Maybe String
    }


type alias UnionDetails =
    { name : String
    , description : Maybe String
    , variants : List Variant
    }


type alias Variant =
    { kind : Kind
    }


type alias ObjectDetails =
    { name : String
    , description : Maybe String
    , fields : List Field
    , interfaces : List Kind
    }


type alias Argument =
    { name : String
    , description : Maybe String
    , type_ : Type
    }


type alias Field =
    { name : String
    , deprecation : Deprecation
    , description : Maybe String
    , arguments : List Argument
    , type_ : Type
    , permissions : List Permission
    }


type alias InterfaceDetails =
    { name : String
    , description : Maybe String
    , fields : List Field
    , implementedBy : List Kind
    }


type alias EnumDetails =
    { name : String
    , description : Maybe String
    , values : List Value
    }


type alias Value =
    { name : String
    , description : Maybe String
    }


type Kind
    = ObjectKind String
    | ScalarKind String
    | InputObjectKind String
    | EnumKind String
    | UnionKind String
    | InterfaceKind String


type Type
    = Scalar String
    | InputObject String
    | Object String
    | Enum String
    | Union String
    | Interface String
    | List_ Type
    | Nullable Type


type alias Permission =
    String


type alias InputObjectDetails =
    { name : String
    , description : Maybe String
    , fields : List Field
    , isOneOf : Bool
    }



{- Helpers -}


type OperationType
    = Query
    | Mutation


operationTypeToString : OperationType -> String
operationTypeToString op =
    case op of
        Query ->
            "Query"

        Mutation ->
            "Mutation"


type Wrapped
    = UnwrappedValue
    | InList Wrapped
    | InMaybe Wrapped


isScalar : Type -> Bool
isScalar tipe =
    case tipe of
        Scalar _ ->
            True

        Nullable inner ->
            isScalar inner

        List_ inner ->
            isScalar inner

        _ ->
            False


getWrap : Type -> Wrapped
getWrap type_ =
    case type_ of
        Nullable newType ->
            InMaybe (getWrap newType)

        List_ newType ->
            InList (getWrap newType)

        _ ->
            UnwrappedValue


getInner : Type -> Type
getInner type_ =
    case type_ of
        Nullable newType ->
            getInner newType

        List_ newType ->
            getInner newType

        inner ->
            inner


mockScalar : Type -> Json.Encode.Value
mockScalar t =
    case t of
        Scalar name ->
            case String.toLower name of
                "int" ->
                    Json.Encode.int 5

                "float" ->
                    Json.Encode.float 5

                "boolean" ->
                    Json.Encode.bool True

                "id" ->
                    Json.Encode.string "<id>"

                "datetime" ->
                    Json.Encode.string "2022-04-04T21:38:43.195Z"

                _ ->
                    Json.Encode.string ("SCALAR:" ++ name)

        InputObject name ->
            Json.Encode.null

        Object name ->
            Json.Encode.null

        Enum name ->
            Json.Encode.null

        Union name ->
            Json.Encode.null

        Interface name ->
            Json.Encode.null

        List_ inner ->
            Json.Encode.list mockScalar [ inner ]

        Nullable inner ->
            mockScalar inner


typeToElmString : Type -> String
typeToElmString t =
    case t of
        Scalar "Boolean" ->
            "Bool"

        Scalar name ->
            name

        InputObject name ->
            name

        Object name ->
            name

        Enum name ->
            name

        Union name ->
            name

        Interface name ->
            name

        List_ inner ->
            "(List " ++ typeToElmString inner ++ ")"

        Nullable inner ->
            "(Maybe " ++ typeToElmString inner ++ ")"


typeToString : Type -> String
typeToString tipe =
    typeToStringHelper False tipe


typeToStringHelper : Bool -> Type -> String
typeToStringHelper nullable tipe =
    let
        required str =
            if nullable then
                str

            else
                str ++ "!"
    in
    case tipe of
        Scalar name ->
            required name

        InputObject name ->
            required name

        Object name ->
            required name

        Enum name ->
            required name

        Union name ->
            required name

        Interface name ->
            required name

        List_ inner ->
            required ("[" ++ typeToStringHelper False inner ++ "]")

        Nullable inner ->
            typeToStringHelper True inner


brackets : String -> String
brackets str =
    "{" ++ str ++ "}"


type Wrapper
    = WithinList { required : Bool } Wrapper
    | Val { required : Bool }


{-|

    Type ->
        Required Val

    Nullable Type ->
        Val

-}
getWrapper : Type -> Wrapper -> Wrapper
getWrapper t wrap =
    case t of
        Scalar name ->
            wrap

        InputObject name ->
            wrap

        Object name ->
            wrap

        Enum name ->
            wrap

        Union name ->
            wrap

        Interface name ->
            wrap

        List_ inner ->
            getWrapper inner (WithinList { required = True } wrap)

        Nullable inner ->
            case wrap of
                Val { required } ->
                    getWrapper inner (Val { required = False })

                WithinList { required } wrapper ->
                    getWrapper inner (WithinList { required = False } wrapper)



{- End of schema, below are intermediate data structures -}


type alias Ref =
    String


type SchemaGrouping
    = Query_Group (Dict String Query)
    | Mutation_Group (Dict String Mutation)
    | Object_Group ObjectDetails
    | Scalar_Group ScalarDetails
    | InputObject_Group InputObjectDetails
    | Enum_Group EnumDetails
    | Union_Group UnionDetails
    | Interface_Group InterfaceDetails


type alias Query =
    Field


type alias Mutation =
    Field


decoder : Json.Decoder Schema
decoder =
    Json.oneOf
        [ Json.field "__schema"
            (namesDecoder
                |> Json.andThen grabTypes
            )
        , Json.at [ "data", "__schema" ]
            (namesDecoder
                |> Json.andThen grabTypes
            )
        ]


namesDecoder : Json.Decoder Names
namesDecoder =
    Json.succeed Names
        |> apply (Json.at [ "queryType", "name" ] Json.string)
        |> apply
            (Json.field "mutationType"
                (Json.oneOf
                    [ Json.map Just (Json.field "name" Json.string)
                    , Json.null Nothing
                    ]
                )
            )


type alias Names =
    { queryName : String
    , mutationName : Maybe String
    }


grabTypes : Names -> Json.Decoder Schema
grabTypes names =
    let
        loop : ( String, SchemaGrouping ) -> Schema -> Schema
        loop ( name, kind ) schema =
            case kind of
                Query_Group queries ->
                    { schema | queries = queries }

                Mutation_Group mutations ->
                    { schema | mutations = mutations }

                Object_Group object ->
                    { schema
                        | objects =
                            if String.startsWith "__" name then
                                schema.objects

                            else
                                Dict.insert name object schema.objects
                    }

                Scalar_Group scalar ->
                    { schema | scalars = Dict.insert name scalar schema.scalars }

                InputObject_Group inputObject ->
                    { schema | inputObjects = Dict.insert name inputObject schema.inputObjects }

                Enum_Group enum ->
                    { schema | enums = Dict.insert name enum schema.enums }

                Union_Group union ->
                    { schema | unions = Dict.insert name union schema.unions }

                Interface_Group interface ->
                    { schema | interfaces = Dict.insert name interface schema.interfaces }
    in
    kinds names
        |> Json.map (List.foldl loop empty)


kinds : Names -> Json.Decoder (List ( String, SchemaGrouping ))
kinds names =
    let
        kind : Json.Decoder (Maybe ( String, SchemaGrouping ))
        kind =
            Json.field "name" Json.string
                |> Json.andThen
                    (\name ->
                        Json.field "kind" Json.string
                            |> Json.andThen (fromNameAndKind name)
                            |> Json.map (\kind_ -> kind_ |> Maybe.map (Tuple.pair name))
                    )

        fromNameAndKind : String -> String -> Json.Decoder (Maybe SchemaGrouping)
        fromNameAndKind name_ k =
            case k of
                "OBJECT" ->
                    if name_ == names.queryName then
                        Json.map Query_Group decodeOperation |> Json.map Just

                    else if Just name_ == names.mutationName then
                        Json.map Mutation_Group decodeOperation |> Json.map Just

                    else
                        filterHidden (Json.map Object_Group decodeObject)

                "SCALAR" ->
                    filterHidden (Json.map Scalar_Group decodeScalar)

                "INTERFACE" ->
                    filterHidden (Json.map Interface_Group decodeInterface)

                "INPUT_OBJECT" ->
                    filterHidden (Json.map InputObject_Group decodeInputObject)

                "ENUM" ->
                    filterHidden (Json.map Enum_Group decodeEnum)

                "UNION" ->
                    filterHidden (Json.map Union_Group decodeUnion)

                _ ->
                    Json.fail ("Didnt recognize kind: " ++ k)
    in
    Json.field "types"
        (Json.list kind |> Json.map (List.filterMap identity))


empty : Schema
empty =
    { queries = Dict.empty
    , mutations = Dict.empty
    , objects = Dict.empty
    , scalars = Dict.empty
    , inputObjects = Dict.empty
    , enums = Dict.empty
    , unions = Dict.empty
    , interfaces = Dict.empty
    }


getJsonValue : List ( String, String ) -> String -> (Result Http.Error Json.Value -> msg) -> Cmd msg
getJsonValue headers url toMsg =
    Http.request
        { method = "POST"
        , headers = headers |> List.map (\( key, val ) -> Http.header key val)
        , url = url
        , body =
            Http.jsonBody
                (Json.Encode.object
                    [ ( "query", Json.Encode.string introspection )
                    ]
                )
        , expect = Http.expectJson toMsg Json.value
        , timeout = Nothing
        , tracker = Nothing
        }


introspection : String
introspection =
    """
query IntrospectionQuery {
    __schema {
      queryType {
        name
      }
      mutationType {
        name
      }
      subscriptionType {
        name
      }
      types {
        ...FullType
      }
    }
  }
  fragment FullType on __Type {
    kind
    name
    description
    fields(includeDeprecated: true) {
      name
      description
      args {
        ...InputValue
      }
      type {
        ...TypeRef
      }
      isDeprecated
      deprecationReason
    }
    inputFields {
      ...InputValue
    }
    interfaces {
      ...TypeRef
    }
    enumValues(includeDeprecated: true) {
      name
      description
      isDeprecated
      deprecationReason
    }
    possibleTypes {
      ...TypeRef
    }
  }
  fragment InputValue on __InputValue {
    name
    description
    type {
      ...TypeRef
    }
    defaultValue
  }
  fragment TypeRef on __Type {
    kind
    name
    ofType {
      kind
      name
      ofType {
        kind
        name
        ofType {
          kind
          name
          ofType {
            kind
            name
            ofType {
              kind
              name
              ofType {
                kind
                name
                ofType {
                  kind
                  name
                }
              }
            }
          }
        }
      }
    }
  }
"""


decodeScalar : Json.Decoder ScalarDetails
decodeScalar =
    Json.map2 ScalarDetails
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe nonEmptyString))


kindFromNameAndString : String -> String -> Json.Decoder Kind
kindFromNameAndString name_ kind =
    case kind of
        "OBJECT" ->
            Json.succeed (ObjectKind name_)

        "SCALAR" ->
            Json.succeed (ScalarKind name_)

        "INTERFACE" ->
            Json.succeed (InterfaceKind name_)

        "INPUT_OBJECT" ->
            Json.succeed (InputObjectKind name_)

        "ENUM" ->
            Json.succeed (EnumKind name_)

        "UNION" ->
            Json.succeed (UnionKind name_)

        _ ->
            Json.fail ("Didn't recognize variant kind: " ++ kind)


decodeKind : Json.Decoder Kind
decodeKind =
    Json.field "name" Json.string
        |> Json.andThen
            (\n ->
                Json.field "kind" Json.string
                    |> Json.andThen (kindFromNameAndString n)
            )


kindToString : Kind -> String
kindToString kind =
    case kind of
        ObjectKind name_ ->
            name_

        ScalarKind name_ ->
            name_

        InputObjectKind name_ ->
            name_

        EnumKind name_ ->
            name_

        UnionKind name_ ->
            name_

        InterfaceKind name_ ->
            name_


nameOf : Kind -> String
nameOf kind =
    case kind of
        ObjectKind _ ->
            "Objects"

        ScalarKind _ ->
            "Scalars"

        InputObjectKind _ ->
            "Input Objects"

        EnumKind _ ->
            "Enums"

        UnionKind _ ->
            "Unions"

        InterfaceKind _ ->
            "Interfaces"


decodeUnion : Json.Decoder UnionDetails
decodeUnion =
    Json.map3 UnionDetails
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe nonEmptyString))
        (Json.field "possibleTypes" (Json.list decodeVariant))


decodeVariant : Json.Decoder Variant
decodeVariant =
    Json.map Variant
        decodeKind


decodeObject : Json.Decoder ObjectDetails
decodeObject =
    Json.map4 ObjectDetails
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe nonEmptyString))
        (Json.field "fields" (Json.list decodeField))
        (Json.field "interfaces" (Json.list decodeInterfaceKind))


decodeInterfaceKind : Json.Decoder Kind
decodeInterfaceKind =
    Json.field "name" Json.string
        |> Json.map InterfaceKind


decodeEnum : Json.Decoder EnumDetails
decodeEnum =
    Json.map3 EnumDetails
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe nonEmptyString))
        (Json.field "enumValues" (Json.list decodeValue))


decodeValue : Json.Decoder Value
decodeValue =
    Json.map2 Value
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe nonEmptyString))


decodeOperation : Json.Decoder (Dict String Field)
decodeOperation =
    let
        tupleDecoder : Json.Decoder ( String, Field )
        tupleDecoder =
            Json.map2 Tuple.pair
                (Json.field "name" Json.string)
                decodeField
    in
    Json.map Dict.fromList
        (Json.field "fields"
            (Json.list tupleDecoder)
        )



{- Field Decoder -}


decodeField : Json.Decoder Field
decodeField =
    Json.map6 Field
        (Json.field "name" Json.string)
        (Json.maybe decodeDeprecation
            |> Json.map
                (\maybeDeprecated ->
                    case maybeDeprecated of
                        Nothing ->
                            Active

                        Just dep ->
                            dep
                )
        )
        (Json.field "description" (Json.maybe nonEmptyString))
        (Json.oneOf
            [ Json.field "args" (Json.list decodeArgument)
            , Json.succeed []
            ]
        )
        (Json.field "type" decodeType)
        decodePermission


decodePermission : Json.Decoder (List Permission)
decodePermission =
    Json.list Json.string
        |> Json.at [ "directives", "requires", "permissions" ]
        |> Json.maybe
        |> Json.map (Maybe.withDefault [])


decodeInterface : Json.Decoder InterfaceDetails
decodeInterface =
    Json.map4 InterfaceDetails
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Json.string))
        (Json.field "fields" (Json.list decodeField))
        (Json.field "possibleTypes" (Json.list decodeKind))


decodeDeprecation : Json.Decoder Deprecation
decodeDeprecation =
    let
        fromBoolean : Bool -> Json.Decoder Deprecation
        fromBoolean isDeprecated_ =
            if isDeprecated_ then
                Json.map Deprecated
                    (Json.maybe (Json.field "deprecationReason" Json.string))

            else
                Json.succeed Active
    in
    Json.field "isDeprecated" Json.bool
        |> Json.andThen fromBoolean


isDeprecated : Deprecation -> Bool
isDeprecated deprecation =
    case deprecation of
        Deprecated _ ->
            True

        Active ->
            False


decodeInputObject : Json.Decoder InputObjectDetails
decodeInputObject =
    Json.map4 InputObjectDetails
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe nonEmptyString))
        (Json.field "inputFields" (Json.list decodeField))
        (Json.maybe
            (Json.field "oneField" Json.bool)
            |> Json.map (Maybe.withDefault False)
        )


decodeArgument : Json.Decoder Argument
decodeArgument =
    Json.map3 Argument
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe nonEmptyString))
        (Json.field "type" decodeType)



{- Handle inverting the types -}


decodeType : Json.Decoder Type
decodeType =
    innerDecoder
        |> Json.map invert


type Inner_Type
    = Inner_Scalar String
    | Inner_InputObject String
    | Inner_Object String
    | Inner_Enum String
    | Inner_Union String
    | Inner_Interface String
    | Inner_List_ Inner_Type
    | Inner_Non_Null Inner_Type


innerDecoder : Json.Decoder Inner_Type
innerDecoder =
    Json.field "kind" Json.string
        |> Json.andThen fromKind


fromKind : String -> Json.Decoder Inner_Type
fromKind kind =
    case kind of
        "SCALAR" ->
            Json.map Inner_Scalar nameDecoder

        "INPUT_OBJECT" ->
            Json.map Inner_InputObject nameDecoder

        "OBJECT" ->
            Json.map Inner_Object nameDecoder

        "ENUM" ->
            Json.map Inner_Enum nameDecoder

        "UNION" ->
            Json.map Inner_Union nameDecoder

        "INTERFACE" ->
            Json.map Inner_Interface nameDecoder

        "LIST" ->
            Json.map Inner_List_ (Json.field "ofType" lazyDecoder)

        "NON_NULL" ->
            Json.map Inner_Non_Null (Json.field "ofType" lazyDecoder)

        _ ->
            Json.fail ("Unrecognized kind: " ++ kind)


lazyDecoder : Json.Decoder Inner_Type
lazyDecoder =
    Json.lazy (\_ -> innerDecoder)


nameDecoder : Json.Decoder String
nameDecoder =
    Json.field "name" Json.string



-- Getting Kind


toKind : Inner_Type -> Kind
toKind type_ =
    case type_ of
        Inner_Scalar name ->
            ScalarKind name

        Inner_InputObject name ->
            InputObjectKind name

        Inner_Object name ->
            ObjectKind name

        Inner_Enum name ->
            EnumKind name

        Inner_Union name ->
            UnionKind name

        Inner_Interface name ->
            InterfaceKind name

        Inner_List_ child ->
            toKind child

        Inner_Non_Null child ->
            toKind child



-- INVERTING NULLABLE TRASH


invert : Inner_Type -> Type
invert =
    invert_ True


invert_ : Bool -> Inner_Type -> Type
invert_ wrappedInNull inner =
    let
        nullable type_ =
            if wrappedInNull then
                Nullable type_

            else
                type_
    in
    case inner of
        Inner_Non_Null inner_ ->
            invert_ False inner_

        Inner_List_ inner_ ->
            nullable (List_ (invert_ True inner_))

        Inner_Scalar value ->
            nullable (Scalar value)

        Inner_InputObject value ->
            nullable (InputObject value)

        Inner_Object value ->
            nullable (Object value)

        Inner_Enum value ->
            nullable (Enum value)

        Inner_Union value ->
            nullable (Union value)

        Inner_Interface value ->
            nullable (Interface value)



{- JSON helpers -}


apply : Json.Decoder a -> Json.Decoder (a -> b) -> Json.Decoder b
apply =
    Json.map2 (|>)


nonEmptyString : Json.Decoder String
nonEmptyString =
    Json.string
        |> Json.andThen
            (\str ->
                if String.isEmpty (String.trim str) then
                    Json.fail "String was empty."

                else
                    Json.succeed str
            )


filterHidden : Json.Decoder value -> Json.Decoder (Maybe value)
filterHidden decoder_ =
    let
        filterByDirectives : Dict String Json.Value -> Json.Decoder (Maybe value)
        filterByDirectives directives =
            if [ "NoDocs", "Unimplemented" ] |> List.any (\d -> Dict.member d directives) then
                Json.succeed Nothing

            else
                Json.map Just decoder_
    in
    Json.oneOf
        [ Json.field "directives" (Json.dict Json.value)
            |> Json.andThen filterByDirectives
        , Json.map Just decoder_
        ]



{- TO STRING -}


toString : Schema -> String
toString schema =
    String.join "\n\n"
        [ (schema.queries
            |> Dict.toList
            |> List.sortBy Tuple.first
            |> List.foldl
                (\( name, type_ ) acc ->
                    acc ++ "    " ++ name ++ "\n"
                )
                "query {\n"
          )
            ++ "}\n"
        , (schema.mutations
            |> Dict.toList
            |> List.sortBy Tuple.first
            |> List.foldl
                (\( name, type_ ) acc ->
                    acc ++ "    " ++ name ++ "\n"
                )
                "mutation {\n"
          )
            ++ "}\n"
        , (schema.enums
            |> Dict.toList
            |> List.sortBy Tuple.first
            |> List.foldl
                (\( name, type_ ) acc ->
                    acc ++ "    " ++ name ++ "\n"
                )
                "enum {\n"
          )
            ++ "}\n"
        , schema.objects
            |> Dict.toList
            |> List.sortBy Tuple.first
            |> List.foldl
                (\( name, obj ) acc ->
                    acc
                        ++ name
                        ++ "\n{\n"
                        ++ (obj.fields
                                |> List.sortBy .name
                                |> List.foldl
                                    (\field acc_ ->
                                        acc_ ++ "    " ++ field.name ++ "\n"
                                    )
                                    ""
                           )
                        ++ "}\n\n"
                )
                ""
        , schema.interfaces
            |> Dict.toList
            |> List.sortBy Tuple.first
            |> List.foldl
                (\( name, obj ) acc ->
                    acc
                        ++ name
                        ++ "\n{\n"
                        ++ (obj.fields
                                |> List.sortBy .name
                                |> List.foldl
                                    (\field acc_ ->
                                        acc_ ++ "    " ++ field.name ++ "\n"
                                    )
                                    ""
                           )
                        ++ "}\n\n"
                )
                ""
        ]

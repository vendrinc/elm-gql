module GraphQL.Schema exposing
    ( get, getJsonValue
    , Mutation, Query, decoder, empty
    , Kind(..), Schema, Type(..)
    , mockScalar
    , Argument, Field, InputObjectDetails, ObjectDetails, Operation, UnionDetails, Variant, kindToString, typeToElmString, typeToString
    )

{-|

@docs get, getJsonValue

@docs Mutation, Query, decoder, empty

@docs Kind, Schema, Type

@docs mockScalar

-}

import Dict exposing (Dict)
import Http
import Json.Decode as Json
import Json.Encode
import Utils.Json exposing (apply)



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
    }


type alias Operation =
    { name : String
    , deprecation : Deprecation
    , description : Maybe String
    , arguments : List Argument
    , type_ : Type
    , permissions : List Permission
    }



{- Helpers -}


mockScalar : Type -> Json.Encode.Value
mockScalar t =
    case t of
        Scalar name ->
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
            "(List " ++ typeToString inner ++ ")"

        Nullable inner ->
            "(Maybe " ++ typeToString inner ++ ")"


typeToString : Type -> String
typeToString t =
    case t of
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
            typeToString inner

        Nullable inner ->
            typeToString inner



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
    Operation


type alias Mutation =
    Operation


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
        |> apply (Json.at [ "mutationType", "name" ] Json.string)


type alias Names =
    { queryName : String
    , mutationName : String
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

                    else if name_ == names.mutationName then
                        Json.map Mutation_Group decodeOperation |> Json.map Just

                    else
                        Utils.Json.filterHidden (Json.map Object_Group decodeObject)

                "SCALAR" ->
                    Utils.Json.filterHidden (Json.map Scalar_Group decodeScalar)

                "INTERFACE" ->
                    Utils.Json.filterHidden (Json.map Interface_Group decodeInterface)

                "INPUT_OBJECT" ->
                    Utils.Json.filterHidden (Json.map InputObject_Group decodeInputObject)

                "ENUM" ->
                    Utils.Json.filterHidden (Json.map Enum_Group decodeEnum)

                "UNION" ->
                    Utils.Json.filterHidden (Json.map Union_Group decodeUnion)

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


get : String -> (Result Http.Error Schema -> msg) -> Cmd msg
get url toMsg =
    Http.post
        { url = url
        , body =
            Http.jsonBody
                (Json.Encode.object
                    [ ( "query", Json.Encode.string introspection )
                    ]
                )
        , expect =
            Http.expectJson toMsg (Json.field "data" decoder)
        }


getJsonValue : String -> (Result Http.Error Json.Value -> msg) -> Cmd msg
getJsonValue url toMsg =
    Http.post
        { url = url
        , body =
            Http.jsonBody
                (Json.Encode.object
                    [ ( "query", Json.Encode.string introspection )
                    ]
                )
        , expect =
            Http.expectJson toMsg Json.value
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
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))


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
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
        (Json.field "possibleTypes" (Json.list decodeVariant))


decodeVariant : Json.Decoder Variant
decodeVariant =
    Json.map Variant
        decodeKind


decodeObject : Json.Decoder ObjectDetails
decodeObject =
    Json.map4 ObjectDetails
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
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
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
        (Json.field "enumValues" (Json.list decodeValue))


decodeValue : Json.Decoder Value
decodeValue =
    Json.map2 Value
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))


decodeOperation : Json.Decoder (Dict String Operation)
decodeOperation =
    let
        tupleDecoder : Json.Decoder ( String, Maybe Operation )
        tupleDecoder =
            Json.map2 Tuple.pair
                (Json.field "name" Json.string)
                internalOperationDecoder
    in
    Json.map Dict.fromList
        (Json.field "fields"
            (Json.list tupleDecoder
                |> Json.map
                    (List.filterMap
                        (\( name, maybeOperation ) ->
                            maybeOperation |> Maybe.map (Tuple.pair name)
                        )
                    )
            )
        )


internalOperationDecoder : Json.Decoder (Maybe Operation)
internalOperationDecoder =
    Utils.Json.filterHidden <|
        Json.map6 Operation
            (Json.field "name" Json.string)
            decodeDeprecation
            (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
            (Json.field "args" (Json.list decodeArgument))
            (Json.field "type" decodeType)
            decodePermission



{- Field Decoder -}


decodeField : Json.Decoder Field
decodeField =
    Json.map5 Field
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
        --(Json.field "args" (Json.list GraphQL.Schema.Argument.decoder))
        (Json.succeed [])
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
    Json.map3 InputObjectDetails
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
        (Json.field "inputFields" (Json.list decodeField))


decodeArgument : Json.Decoder Argument
decodeArgument =
    Json.map3 Argument
        (Json.field "name" Json.string)
        (Json.field "description" (Json.maybe Utils.Json.nonEmptyString))
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

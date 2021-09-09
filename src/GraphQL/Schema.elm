module GraphQL.Schema exposing
    ( Mutation
    , Query
    , Schema
    , decoder
    , empty
    , get
    )

import Dict exposing (Dict)
import GraphQL.Schema.Enum as Enum exposing (Enum)
import GraphQL.Schema.InputObject as InputObject exposing (InputObject)
import GraphQL.Schema.Interface as Interface exposing (Interface)
import GraphQL.Schema.Object as Object exposing (Object)
import GraphQL.Schema.Operation as Operation exposing (Operation)
import GraphQL.Schema.Scalar as Scalar exposing (Scalar)
import GraphQL.Schema.Union as Union exposing (Union)
import Json.Decode as Json
import Utils.Json exposing (apply)
import Http
import Json.Encode

-- Definition


type alias Schema =
    { queries : Dict Ref Query
    , mutations : Dict Ref Mutation
    , objects : Dict Ref Object
    , scalars : Dict Ref Scalar
    , inputObjects : Dict Ref InputObject
    , enums : Dict Ref Enum
    , unions : Dict Ref Union
    , interfaces : Dict Ref Interface
    }


type alias Ref =
    String


type Kind
    = Query_Kind (Dict String Query)
    | Mutation_Kind (Dict String Mutation)
    | Object_Kind Object
    | Scalar_Kind Scalar
    | InputObject_Kind InputObject
    | Enum_Kind Enum
    | Union_Kind Union
    | Interface_Kind Interface


type alias Query =
    Operation


type alias Mutation =
    Operation



decoder : Json.Decoder Schema
decoder =
    Json.field "__schema"
        (namesDecoder
            |> Json.andThen grabTypes
        )


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
        loop : ( String, Kind ) -> Schema -> Schema
        loop ( name, kind ) schema =
            case kind of
                Query_Kind queries ->
                    { schema | queries = queries }

                Mutation_Kind mutations ->
                    { schema | mutations = mutations }

                Object_Kind object ->
                    { schema
                        | objects =
                            if String.startsWith "__" name then
                                schema.objects

                            else
                                Dict.insert name object schema.objects
                    }

                Scalar_Kind scalar ->
                    { schema | scalars = Dict.insert name scalar schema.scalars }

                InputObject_Kind inputObject ->
                    { schema | inputObjects = Dict.insert name inputObject schema.inputObjects }

                Enum_Kind enum ->
                    { schema | enums = Dict.insert name enum schema.enums }

                Union_Kind union ->
                    { schema | unions = Dict.insert name union schema.unions }

                Interface_Kind interface ->
                    { schema | interfaces = Dict.insert name interface schema.interfaces }
    in
    kinds names
        |> Json.map (List.foldl loop empty)


kinds : Names -> Json.Decoder (List ( String, Kind ))
kinds names =
    let
        kind : Json.Decoder (Maybe ( String, Kind ))
        kind =
            Json.field "name" Json.string
                |> Json.andThen
                    (\name ->
                        Json.field "kind" Json.string
                            |> Json.andThen (fromNameAndKind name)
                            |> Json.map (\kind_ -> kind_ |> Maybe.map (Tuple.pair name))
                    )

        fromNameAndKind : String -> String -> Json.Decoder (Maybe Kind)
        fromNameAndKind name_ k =
            case k of
                "OBJECT" ->
                    if name_ == names.queryName then
                        Json.map Query_Kind Operation.decoder |> Json.map Just

                    else if name_ == names.mutationName then
                        Json.map Mutation_Kind Operation.decoder |> Json.map Just

                    else
                        Utils.Json.filterHidden (Json.map Object_Kind Object.decoder)

                "SCALAR" ->
                    Utils.Json.filterHidden (Json.map Scalar_Kind Scalar.decoder)

                "INTERFACE" ->
                    Utils.Json.filterHidden (Json.map Interface_Kind Interface.decoder)

                "INPUT_OBJECT" ->
                    Utils.Json.filterHidden (Json.map InputObject_Kind InputObject.decoder)

                "ENUM" ->
                    Utils.Json.filterHidden (Json.map Enum_Kind Enum.decoder)

                "UNION" ->
                    Utils.Json.filterHidden (Json.map Union_Kind Union.decoder)

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
                    [ ("query", Json.Encode.string introspection)

                    ]

                )
        , expect =
            Http.expectJson toMsg (Json.field "data" decoder)

        }

introspection : String
introspection = """
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
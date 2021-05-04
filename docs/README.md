# ryannhg/elm-graphql

> Work with GraphQL with Elm

## Example

### GraphQL schema

```graphql
type Query {
  me: User
}

type User {
  id: ID!
  name: String!
  email: String
}
```

### Elm code

```elm
import GQL


query : GQL.Query (Maybe User)
query =
    GQL.query.me user


type alias User =
    { name : String
    , email : Maybe String
    }


user : GQL.User User
user =
    GQL.user User
        |> GQL.with .name
        |> GQL.with .email
```

### GraphQL query

```graphql
query {
  me {
    name
    email
  }
}
```

## Namespace Rules

Here's the GraphQL spec: http://spec.graphql.org/June2018/#sec-Schema

All types are guaranteed to have unique names.

However, it's not quite a global name space.

1. Enum values themselves can have overlapping names.
2. Two separate types can have the same field names with no clash. So, App can have name, but Person can have name as well.
3. Arguments to fields can also be the same for different fields. Easy example is id being taken by Apps or People.

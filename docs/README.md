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



# ryannhg/elm-gql
> A CLI built on top of dillonkearns/elm-graphql

## Example

```graphql
type Query {
  user: User
}

type User {
  id: ID!
  name: String!
  email: String
}
```

```elm
import GQL

type alias User =
  { name : String
  , email : Maybe String
  }

query : GQL.User User
query =
  GQL.query.user User
    |> GQL.with .name
    |> GQL.with .email
```
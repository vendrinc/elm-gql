# examples/03-nested

```graphql
type Query {
  user(id: ID!): User
}

type User {
  id: ID!
  name: Name!
  email: String
}

type Name {
  first: String!
  middle: String
  last: String!
}
```

```graphql
query {
  user(id: "123") {
    name {
      first
      middle
      last
    }
    email
  }
}
```

```elm
import GQL


query : GQL.Query (Maybe User)
query =
    GQL.query.user user
        { id = GQL.id "123"
        }


type alias User =
    { name : Name
    , email : Maybe String
    }


user : GQL.User User
user =
    GQL.user User
        |> GQL.nested .name name
        |> GQL.with .email


type alias Name =
    { first : String
    , middle : Maybe String
    , last : String
    }


name : GQL.Name Name
name =
    GQL.name Name
        |> GQL.with .first
        |> GQL.with .middle
        |> GQL.with .last
```

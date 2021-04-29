# examples/02-inputs

```graphql
type Query {
  user(id: ID!): User
}

type User {
  id: ID!
  name: String!
  email: String
}
```

```graphql
query {
  user(id: "123") {
    name
    email
  }
}
```

```elm
import GQL


type alias User =
    { name : String
    , email : Maybe String
    }


userQuery : GQL.Query (Maybe User)
userQuery =
    GQL.query.user user
        { id = GQL.id "123"
        }


usersQuery : GQL.Query (List User)
usersQuery =
    GQL.query.users.create user
        [ GQL.query.users.sort (Just GQL.ASC)
        ]


user : GQL.User User
user =
    GQL.user User
        |> GQL.with .name
        |> GQL.with .email

```
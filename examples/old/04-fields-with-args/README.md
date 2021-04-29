# examples/02-inputs

### GQL schema

```graphql
type Query {
  user(id: ID!): User
}

type User {
  id: ID!
  name: Name!
  friends(limit: Int): [User!]!
}
```

### GQL query

```graphql
query {
  user(id: "123") {
    name {
      first
      last
    }
    friends(limit: 5) {
      id
      name {
        first
        last
      }
    }
  }
}
```

### Elm code

```elm
import GQL
import GQL.User.Friends


userQuery : GQL.Query (Maybe User)
userQuery =
    GQL.Query.user user
        { id = GQL.id "123"
        }


type alias User =
    { name : Name
    , friends : List Friend
    }


user : GQL.User User
user =
    GQL.user User
        |> GQL.nested .name name
        |> GQL.field .friends friend {}
              [ GQL.User.Friends.limit (Just 5)
              ]


type alias Name =
    { first : String
    , last : String
    }


name : GQL.Name Name
name =
    GQL.name Name
        |> GQL.with .first
        |> GQL.with .last


type alias Friend =
    { id : GQL.ID
    , name : Name
    }


friend : GQL.User Friend
friend =
    GQL.user Friend
        |> GQL.with .id
        |> GQL.nested .name name
```
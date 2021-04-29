```graphql
type Query {
  app(id: ID!): App
}

type App {
  id: ID!
  name: String!
  slug: String!
}
```

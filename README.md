# Write GQL, get Elm

GraphQL and Elm have very similar type systems!

With this library you can write GraphQL queries and mutations directly and receive nice Elm code for you to use them.

This saves a ton of time! And maintains that lovely typesafety you're probably used to in Elm.

1. GraphQL itself is relatively easy to write once you get the hang of it.
2. `elm-gql` verifies everything you've written against the GraphQL schema, so you don't have to worry about writing an incorrect query or mutation.
3. `elm-gql` has nice, elm-esque error messages.

![](/guide/assets/VariableError.png)

This library has been in use at vendr.com for over a year in production! We've built a number of complex app features using it and generally enjoy working with it.

# Getting started

```bash
npm install elm-gql --save-dev
```

Once you have `elm-gql` installed, you'll need to get set up by requesting the GraphQL schema for the API you care about.

```sh
# Start your project by running init
elm-gql init https://api.github.com/graphql --header "Authorization: bearer TOKEN"

```

This will do a few things!

1. Any `*.gql` files in your project will be checked against the schema. You'll either get a nice error message describing what needs to be adjusted in the file, or it'll generate some Elm code for you to use to make that query/mutation in Elm.

2. Generate some helper code under in a folder called `Api`. (Note, you can change this base name by passing `--namespace MyApi` to the `elm-gql` command). These files will:
   - Help you construct inputs to your query
   - Allow you to reference any Enums in your GraphQL.

When you make a change to a query or mutation, just run

```bash
elm-gql run ./api/Api/schema.json
```

and everything will be checked and generated again.

## Guides

- [The Life of a Query](https://github.com/vendrinc/elm-gql/blob/main/guide/LifeOfAQuery.md)
- [Code Reuse and Patterns](https://github.com/vendrinc/elm-gql/blob/main/guide/CodePatterns.md)
- [Check out the Github Example Repo](https://github.com/mdgriffith/elm-gql-github-example)

## Talk to me in the Elm-GQL Slack or Discord!

If you have any further questions or feedback, there is both

- [The #graphql channel in the Elm slack](https://elm-lang.org/community/slack) which is for people who are getting started with `elm-gql` or want to find people to help them debug a situation.
- [The #elm-gql channel in the "Incremental Elm" Discord](https://incrementalelm.com/chat/) which is where I discuss future development of `vendr/elm-gql` and coordinate with collaborators, but I'm also happy to hear about initial experiences.

See you in there :wave:!

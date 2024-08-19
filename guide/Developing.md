# Developing Elm GQL

This is a general overview for working on `elm-gql` itself.

Elm GQL is

- A thin typscript program, which handles CLI arguments.
- An Elm codebase which handles the majority of the logic of what files to generate.

The primary command you'll be running is `pnpm build`, which

- Compiles the Elm app into `js` so it can be called from
- Calls `build.js`, which
  - Copies a few Elm files as "templates". For example, `GraphQL/Engine.elm` needs to be provided to the people using `elm-gql`. So, we create `templates/Engine.elm.ts` which is just that file but as a static string. This makes it super easy for typescript to write a file with that content if it needs to.

## Code Organization

- `cli` - The typescript codebase for handling CLI arguments.
- `codegen` - These are [`elm-codegen` helpers](https://github.com/mdgriffith/elm-codegen/blob/main/guide/UsingHelpers.md). These are used to make it easier for generated code to call other generated code.  
   For example, there is a file called `GraphQL.Decode` which is a library that the generated code uses to decode graphql results. Runing `pnpm build` will generate `Gen.GraphQL.Decode` which makes it easier to write code that calls that library!
- `src` - This is the main Elm App. It uses [`elm-codegen`](https://github.com/mdgriffith/elm-codegen) to generate code for requesting and decoding graphQL calls.

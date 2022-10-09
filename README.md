> **Warning**
> This project is not published quite yet, but will be soon!

# Write GQL, get Elm

GraphQL and Elm have very similar type systems in many aspects!

This library is focused on allowing you to write GraphQL queries and mutations directly, and then generating nice Elm code for you to use.

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
# download the schema as a json file
elm-gql inspect https://api.github.com/graphql --header "Authorization: bearer TOKEN" --output=schema.json

# Then run elm-gql and pass it the schema
elm-gql schema.json
```

This will do a few things!

1. Any `*.gql` files in your project will be checked against the schema. You'll either get a nice error message describing what needs to be adjusted in the file, or it'll generate some Elm code for you to use to make that query/mutation in Elm.

2. Generate some helper code under in a folder called `Api`. (Note, you can change this base name by passing `--namespace MyApi` to the `elm-gql` command). These files will:
   - Help you construct inputs to your query
   - Allow you to reference any Enums in your GraphQL.

# The Life of a Query

Let's say you write a query called `MyQuery.gql` and inside you have this GraphQL

```graphQL
query AllFilms {
    films {
        title
        director
        releaseDate
    }
}
```

When you run `elm-gql`, a folder called `MyQuery` will be generated next to `MyQuery.gql`, and in that folder will be a file called `AllFiles.elm`.

The field `films` returns a list of films, so the generated code will look roughly like this.

```elm
type alias AllFilms = {
    films : List Films
}

type alias Films =
    { title : String
    , director : String
    , releaseDate : String
    }
```

If you add a graphQL alias to a field, that will inform what code is generated.

```graphQL
query AllFilms {
    films {
        filmTitle: title
        director
        releaseDate
    }
}
```

Will generate

```elm
type alias AllFilms = {
    films : List Films
}

type alias Films =
    { filmTitle : String
    , director : String
    , releaseDate : String
    }
```

Though you may also note that `films` is pluralized both for the field name and the record representing a single field. That ain't great!

In this case, we can use a graphQL fragment to both deduplicate our query, but also inform the naming.

```graphQL
query AllFilms {
    films {
        ... Film
    }
}

fragment Film on Film {
    filmTitle: title
    director
    releaseDate
}
```

Will generate

```elm
type alias AllFilms = {
    films : List Film
}

type alias Film =
    { filmTitle : String
    , director : String
    , releaseDate : String
    }
```

Huray! Note, this case of allowing fragments to name a generated type only applies in the case where you use exactly one fragment for a selection.

# How do I reuse code?

One of the ideas behind GraphQL is to only ask for the exact data that you need. I'd recommend just writing a new query/mutation for most cases! Even in the case that they're very similar, if they're not literally the exact same usecase, then it's likely they have slightly different needs and may grow in different directions.

If you do need to share some bits of graphQL queries, use a graphQL fragment.

# Where do I store UI stuff?

One of the interesting aspects of this approach to GraphQL is around where you put other pieces of state you need to track to make your UI interactive.

So first, keep a copy of the data returned by a query in your model, largely unmodified.

If you need to handle additional UI state, put that at the top level of you model and reference things in the query data by ID if you need to.

This turns out to be a really nice way to handle things.

1. You avoid writing a _ton_ of code that is largely concerned with mapping into and out of large nested structures.
2. It's very easy to understand where everything is.

Potentially a nice way to think about this is to approach about your model as a mini relational database. Organizing things like a collection of tables can be really beneficial.

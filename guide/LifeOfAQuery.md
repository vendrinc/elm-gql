# The Life of a Query

Let's say you write a query called `MyQuery.gql` and inside you have this GraphQL

```GraphQL
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

```GraphQL
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
    films : List Fragment.Film
}


-- and the following will be in a Fragment.Film.elm file
type alias Film =
    { filmTitle : String
    , director : String
    , releaseDate : String
    }
```

Huray!

You can use a fragment in multiple queries within a file and they will all reference the same `Fragment.{YouFragment}.elm` file and the types within.

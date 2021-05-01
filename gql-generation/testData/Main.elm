module Main exposing (..)

query :
    { -- Cool
      app : { id : GQL.ID } -> GQL.App value -> GQL.Query (Maybe value)
    }
query =
    { app = \_ _ -> Debug.todo "hehehe"
    }
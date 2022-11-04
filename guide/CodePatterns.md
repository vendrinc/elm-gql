# Code Reuse and Patterns

# How do I reuse code?

One of the ideas behind GraphQL is to only ask for the exact data that you need. I'd recommend just writing a new query/mutation for most cases!

Even in the case that they're very similar, if they're not literally the exact same usecase, then it's likely they have slightly different needs and may grow in different directions.

If you do need to share some bits of GraphQL queries, use a graphQL fragment!

# Where do I store UI stuff?

One of the interesting aspects of this approach to GraphQL is around where you put other pieces of state you need to track to make your UI interactive.

So first, keep a copy of the data returned by a query in your model, largely unmodified.

If you need to handle additional UI state, put that at the top level of you model and reference things in the query data by ID if you need to.

This turns out to be a really nice way to handle things.

1. You avoid writing a _ton_ of code that is largely concerned with mapping into and out of large nested structures.
2. It's very easy to understand where everything is.

Potentially a nice way to think about this is to approach about your model as a mini relational database. Organizing things like a collection of tables can be really beneficial.

It generally looks something like this:

Let's say you have:

- `Api.Init` - A main GraphQL query that returns a list of `Things`
- `Api.ThingDetail` - Another GraphQL query that returns more details for each `Thing`. Maybe this is triggered when you click an item in a list.

You could organize your model roughly like

```elm
type alias Model
    { data : Api.Init.Response -- the result of the Init query

    -- We store the details for each Thing in a dict, using the ID of the Thing as a key.
    , details : Dict String Api.ThingDetail.Response

    -- If you need to store any UI state in your model, keep it top level and key it by the id it applies to, it appropriate.
    , dropdown :
        Maybe
            { id : String
            , state : Ui.Dropdown.Model
            }
    }

```

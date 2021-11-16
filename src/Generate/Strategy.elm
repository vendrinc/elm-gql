module Generate.Strategy exposing (Strategy(..))

{-| Given pieces of the schema, adjust the code generation strategy.

For example, here's a boolean flter, which has two variants, `not` and `equals`

    booleanFilter : List TnG.BooleanFilter.Optional -> TnG.BooleanFilter

    not : Maybe Bool -> TnG.BooleanFilter.Optional

    equals : Maybe Bool -> TnG.BooleanFilter.Optional

But instead of writing

    Input.booleanFilter [ not (Just True) ]
         : BooleanFilter

or
InputObject.buildBooleanFilter
(\\opts ->
{opts | not = GQL.present True}
) : BooleanFilter

We really want to write just

    BooleanFilter.not True

All we need to do is hint to our code generation that this is a `oneOf` situation.

Which can look like this.

    Generate.Strategy.input
        (\input ->
            case input.name of
                "BooleanFilter" ->
                    Just Generate.Strategy.OneOf

                _ ->
                    Nothing
        )

Also, check out the `teams` endpoint.

1.  if `filter` doesn't need to worry about nulls, then it could defined as

             (can get rid of full qualification because this is only one module)
             Teams.filter
                 [ Teams.teamsFilter.name "Example..."
                 , Teams.teamsFilter.parentId id
                 , Teams.teamsFilter.showArchived True
                 ]

         instead of

             , TnG.Queries.Teams.filter
                 (Just
                     (TnG.Input.teamsFilter
                         [ TnG.TeamsFilter.name (Just "Example...")
                         , TnG.TeamsFilter.parentId (Just id)
                         , TnG.TeamsFilter.showArchived (Just True)
                         ]
                     )
                 )

-}

import GraphQL.Schema.Enum as Enum exposing (Enum)
import GraphQL.Schema.InputObject as InputObject exposing (InputObject)
import GraphQL.Schema.Interface as Interface exposing (Interface)
import GraphQL.Schema.Object as Object exposing (Object)
import GraphQL.Schema.Operation as Operation exposing (Operation)
import GraphQL.Schema.Scalar as Scalar exposing (Scalar)
import GraphQL.Schema.Union as Union exposing (Union)


type Strategy
    = Normal
    | OneOf
    | NoNull


input : InputObject -> Maybe Strategy
input inputObject =
    Nothing

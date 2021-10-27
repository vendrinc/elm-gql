module Operations exposing (main)

{-| -}

import Dict
import Elm
import Elm.Gen
import Generate.Args
import Generate.Enums
import Generate.InputObjects
import Generate.Objects
import Generate.Operations
import Generate.Paged
import Generate.Unions
import GraphQL.Operations.AST as AST
import GraphQL.Operations.Generate
import GraphQL.Operations.Parse
import GraphQL.Operations.Validate
import GraphQL.Operations.Canonicalize as Canonicalize
import GraphQL.Schema
import Http
import Json.Decode
import Json.Encode


main :
    Program
        Json.Encode.Value
        Model
        Msg
main =
    Platform.worker
        { init =
            \flags ->
                let
                    decoded =
                        Json.Decode.decodeValue flagsDecoder flags
                in
                case decoded of
                    Err err ->
                        ( { flags = flags
                          , input = InputError
                          , namespace = "Api"
                          }
                        , Elm.Gen.error
                            { title = "Error decoding flags"
                            , description = Json.Decode.errorToString err
                            }
                        )

                    Ok input ->
                        case input of
                            InputError ->
                                ( { flags = flags
                                  , input = InputError
                                  , namespace = "Api"
                                  }
                                , Elm.Gen.error
                                    { title = "Error decoding flags"
                                    , description = ""
                                    }
                                )

                            SchemaInline schema ->
                                ( { flags = flags
                                  , input = input
                                  , namespace = "Api"
                                  }
                                , parseAndValidateQuery "Api" schema 
                                    -- dashboardQuery
                                    smallDashboardQuery
                                )

                            SchemaGet details ->
                                ( { flags = flags
                                  , input = input
                                  , namespace = details.namespace
                                  }
                                , GraphQL.Schema.get
                                    details.schema
                                    SchemaReceived
                                )
        , update =
            \msg model ->
                case msg of
                    SchemaReceived (Ok schema) ->
                        ( model
                        , parseAndValidateQuery model.namespace schema 
                            --dashboardQuery
                            smallDashboardQuery
                        )

                    SchemaReceived (Err err) ->
                        ( model
                        , Elm.Gen.error
                            { title = "Error retieving schema"
                            , description =
                                "Something went wrong with retrieving the schema.\n\n    " ++ httpErrorToString err
                            }
                        )
        , subscriptions = \_ -> Sub.none
        }


parseAndValidateQuery : String -> GraphQL.Schema.Schema -> String -> Cmd msg
parseAndValidateQuery namespace schema queryStr =
    case GraphQL.Operations.Parse.parse queryStr of
        Err err ->
            Elm.Gen.error
                { title = "Malformed query"
                , description =
                    Debug.toString err
                }

        Ok query ->
            case Canonicalize.canonicalize schema query of
                Err errors ->
                     Elm.Gen.error
                        { title = "Errors"
                        , description =
                            List.map Canonicalize.errorToString errors
                                |> String.join "\n\n    "
                        }

                Ok canAST ->
                    case GraphQL.Operations.Generate.generate schema queryStr canAST ["Ops", "Test"] of
                        Err validationError ->
                            Elm.Gen.error
                                { title = "Invalid query"
                                , description =
                                    List.map GraphQL.Operations.Validate.errorToString validationError
                                        |> String.join "\n\n    "
                                }

                        Ok files ->
                            Elm.Gen.files files


flagsDecoder : Json.Decode.Decoder Input
flagsDecoder =
    Json.Decode.oneOf
        [ Json.Decode.map2
            (\namespace schemaUrl ->
                SchemaGet
                    { schema = schemaUrl
                    , namespace = namespace
                    }
            )
            (Json.Decode.field "namespace" Json.Decode.string)
            (Json.Decode.field "schema" Json.Decode.string)
        , Json.Decode.map SchemaInline GraphQL.Schema.decoder
        ]


type alias Model =
    { flags : Json.Encode.Value
    , input : Input
    , namespace : String
    }


type Input
    = SchemaInline GraphQL.Schema.Schema
    | SchemaGet
        { schema : String
        , namespace : String
        }
    | InputError


type Msg
    = SchemaReceived (Result Http.Error GraphQL.Schema.Schema)


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        Http.BadUrl msg ->
            "Bad Url: " ++ msg

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus status ->
            "Bad Status: " ++ String.fromInt status

        Http.BadBody msg ->
            "Bad Body: " ++ msg




smallDashboardQuery : String
smallDashboardQuery =
    """query Dashboard(
  $filter: PersonAppRelationshipFilter
  $filter1: PersonAppRelationshipFilter
  $filter10: TicketFilter
  $filter11: TicketFilter
  $filter12: WorkflowFilter
  $filter13: WorkflowFilter
  $filter14: WorkflowFilter
  $filter15: WorkflowFilter
  $filter16: PeopleFilter
  $filter2: AuditLogEventsFilter
  $filter3: ServiceEntityRelationshipFilter
  $filter4: ServiceEntityRelationshipFilter
  $filter5: ServiceEntityRelationshipFilter
  $filter6: AuditLogEventsFilter
  $filter7: AuditLogEventsFilter
  $filter8: TransactionFilter
  $filter9: TransactionFilter
  $first: Int
  $first1: Int
  $first2: Int
  $first3: Int
  $first4: Int
  $orderBy: EntityPropertySortInput
  $orderBy1: EntityPropertySortInput
  $orderBy2: EntityPropertySortInput
  $orderBy3: EntityPropertySortInput
) {
  personAppRelationships(filter: $filter) {
    totalEdges
  }
  personAppRelationships1: personAppRelationships(filter: $filter1) {
    totalEdges
  }
  auditLogEvents(first: $first, filter: $filter2) {
    totalEdges
    pageInfo {
      endCursor
      startCursor
      hasNextPage
      hasPreviousPage
    }
    edges {
      node {
        details {
          __typename
          ... on EventAppAccessRevokedDetected {
            __typename
          }
          ... on EventAppAccessAffirmedDetected {
            __typename
          }
          ... on EventPersonWorkflowCreated {
            __typename
          }
          ... on EventPersonTeamRemoved {
            __typename
          }
          ... on EventPersonTeamCreated {
            __typename
          }
          ... on EventDevicePersonRemoved {
            __typename
          }
          ... on EventDevicePersonCreated {
            __typename
          }
          ... on EventAppTeamRemoved {
            __typename
          }
          ... on EventAppTeamCreated {
            __typename
          }
          ... on EventAppPersonRemoved {
            __typename
          }
          ... on EventAppPersonCreated {
            __typename
          }
          ... on EventTeamRemoved {
            __typename
          }
          ... on EventTeamPropertyUpdated {
            __typename
          }
          ... on EventTeamCreated {
            __typename
          }
          ... on EventPersonRemoved {
            __typename
          }
          ... on EventPersonPropertyUpdated {
            __typename
          }
          ... on EventPersonCreated {
            __typename
          }
          ... on EventDeviceRemoved {
            __typename
          }
          ... on EventDevicePropertyUpdated {
            __typename
          }
          ... on EventDeviceCreated {
            __typename
          }
          ... on EventAppRoleUnassigned {
            __typename
          }
          ... on EventAppRoleReassigned {
            __typename
          }
          ... on EventAppRoleAssigned {
            __typename
          }
          ... on EventAppRoleRemoved {
            __typename
          }
          ... on EventAppRoleUpdated {
            __typename
          }
          ... on EventAppRoleCreated {
            __typename
          }
          ... on EventAppRenewalDateUpdated {
            __typename
          }
          ... on EventAppSubscriptionDetected {
            __typename
          }
          ... on EventAppSubscriptionRemoved {
            __typename
          }
          ... on EventAppSubscriptionCreated {
            __typename
          }
          ... on EventAppRelationshipDetected {
            app {
              id
            }
            sources
          }
          ... on EventAppLicenseDetected {
            __typename
          }
          ... on EventAppLicenseUnassigned {
            __typename
          }
          ... on EventAppLicenseAssigned {
            __typename
          }
          ... on EventAppLicenseUpdated {
            __typename
          }
          ... on EventAppLicenseRemoved {
            __typename
          }
          ... on EventAppLicenseCreated {
            __typename
          }
          ... on EventAppFileRemoved {
            __typename
          }
          ... on EventAppFileUploaded {
            __typename
          }
          ... on EventAppRemoved {
            __typename
          }
          ... on EventAppPropertyUpdated {
            __typename
          }
          ... on EventAppCreated {
            __typename
          }
        }
        createdAt
        id
      }
    }
  }
  serviceEntityRelationships2(
    first: $first1
    orderBy: $orderBy
    filter: $filter3
  ) {
    totalEdges
    pageInfo {
      endCursor
      startCursor
      hasNextPage
      hasPreviousPage
    }
    edges {
      node {
        serviceEntity {
          categories
        }
        directlyAttributableLastMonthSpend
        serviceEntity1: serviceEntity {
          slug
          logo
          name
          id
        }
      }
    }
  }
  workflowPlans {
    __typename
    ... on PermissionDeniedError {
      __typename
    }
    ... on WorkflowPlansSuccess {
      plans {
        type
        id
      }
    }
  }
  serviceEntityRelationships21: serviceEntityRelationships2(
    first: $first2
    orderBy: $orderBy1
    filter: $filter4
  ) {
    totalEdges
    pageInfo {
      endCursor
      startCursor
      hasNextPage
      hasPreviousPage
    }
    edges {
      node {
        last12MonthSpend
        renewalOptions {
          renewalDate
        }
        serviceEntity {
          slug
          logo
          name
          id
        }
      }
    }
  }
  teams(first: $first3, orderBy: $orderBy2) {
    totalEdges
    pageInfo {
      endCursor
      startCursor
      hasNextPage
      hasPreviousPage
    }
    edges {
      node {
        spendOverTime {
          amount
          from
        }
        averageSpendPerMemberLastMonth
        id
        name
      }
    }
  }
  serviceEntityRelationships22: serviceEntityRelationships2(
    first: $first4
    orderBy: $orderBy3
    filter: $filter5
  ) {
    totalEdges
    pageInfo {
      endCursor
      startCursor
      hasNextPage
      hasPreviousPage
    }
    edges {
      node {
        directlyAttributableLastMonthSpend
        serviceEntity {
          slug
          logo
          name
          id
        }
      }
    }
  }
  auditLogEvents1: auditLogEvents(filter: $filter6) {
    totalEdges
  }
  auditLogEvents2: auditLogEvents(filter: $filter7) {
    totalEdges
  }
  transactions(filter: $filter8) {
    totalEdges
  }
  transactions1: transactions(filter: $filter9) {
    totalEdges
  }
  organization {
    spendDelta
    lastMonthSpend
    aggregateSpendOverTimeReports {
      amount
      from
    }
  }
  tickets(filter: $filter10) {
    totalEdges
  }
  tickets1: tickets(filter: $filter11) {
    totalEdges
  }
  workflows2(filter: $filter12) {
    totalEdges
  }
  workflows21: workflows2(filter: $filter13) {
    totalEdges
  }
  workflows22: workflows2(filter: $filter14) {
    totalEdges
  }
  workflows23: workflows2(filter: $filter15) {
    totalEdges
  }
  devices {
    totalEdges
  }
  teams1: teams {
    totalEdges
  }
  persons(filter: $filter16) {
    totalEdges
  }
  serviceEntityRelationships23: serviceEntityRelationships2 {
    totalEdges
  }
}


"""


dashboardQuery : String
dashboardQuery =
    """query Dashboard($filter:PersonAppRelationshipFilter, $filter1:PersonAppRelationshipFilter, $filter10:TicketFilter, $filter11:TicketFilter, $filter12:WorkflowFilter, $filter13:WorkflowFilter, $filter14:WorkflowFilter, $filter15:WorkflowFilter, $filter16:PeopleFilter, $filter2:AuditLogEventsFilter, $filter3:ServiceEntityRelationshipFilter, $filter4:ServiceEntityRelationshipFilter, $filter5:ServiceEntityRelationshipFilter, $filter6:AuditLogEventsFilter, $filter7:AuditLogEventsFilter, $filter8:TransactionFilter, $filter9:TransactionFilter, $first:Int, $first1:Int, $first2:Int, $first3:Int, $first4:Int, $orderBy:EntityPropertySortInput, $orderBy1:EntityPropertySortInput, $orderBy2:EntityPropertySortInput, $orderBy3:EntityPropertySortInput){personAppRelationships(filter: $filter){totalEdges}
personAppRelationships1:personAppRelationships(filter: $filter1){totalEdges}
auditLogEvents(first: $first, filter: $filter2){totalEdges
pageInfo{endCursor
startCursor
hasNextPage
hasPreviousPage}
edges{node{details{__typename
... on EventAppAccessRevokedDetected{__typename}
... on EventAppAccessAffirmedDetected{__typename}
... on EventPersonWorkflowCreated{__typename}
... on EventPersonTeamRemoved{__typename}
... on EventPersonTeamCreated{__typename}
... on EventDevicePersonRemoved{__typename}
... on EventDevicePersonCreated{__typename}
... on EventAppTeamRemoved{__typename}
... on EventAppTeamCreated{__typename}
... on EventAppPersonRemoved{__typename}
... on EventAppPersonCreated{__typename}
... on EventTeamRemoved{__typename}
... on EventTeamPropertyUpdated{__typename}
... on EventTeamCreated{__typename}
... on EventPersonRemoved{__typename}
... on EventPersonPropertyUpdated{__typename}
... on EventPersonCreated{__typename}
... on EventDeviceRemoved{__typename}
... on EventDevicePropertyUpdated{__typename}
... on EventDeviceCreated{__typename}
... on EventAppRoleUnassigned{__typename}
... on EventAppRoleReassigned{__typename}
... on EventAppRoleAssigned{__typename}
... on EventAppRoleRemoved{__typename}
... on EventAppRoleUpdated{__typename}
... on EventAppRoleCreated{__typename}
... on EventAppRenewalDateUpdated{__typename}
... on EventAppSubscriptionDetected{__typename}
... on EventAppSubscriptionRemoved{__typename}
... on EventAppSubscriptionCreated{__typename}
... on EventAppRelationshipDetected{app{id}
sources}
... on EventAppLicenseDetected{__typename}
... on EventAppLicenseUnassigned{__typename}
... on EventAppLicenseAssigned{__typename}
... on EventAppLicenseUpdated{__typename}
... on EventAppLicenseRemoved{__typename}
... on EventAppLicenseCreated{__typename}
... on EventAppFileRemoved{__typename}
... on EventAppFileUploaded{__typename}
... on EventAppRemoved{__typename}
... on EventAppPropertyUpdated{__typename}
... on EventAppCreated{__typename}}
createdAt
id}}}
serviceEntityRelationships2(first: $first1, orderBy: $orderBy, filter: $filter3){totalEdges
pageInfo{endCursor
startCursor
hasNextPage
hasPreviousPage}
edges{node{serviceEntity{categories}
directlyAttributableLastMonthSpend
serviceEntity1:serviceEntity{slug
logo
name
id}}}}
workflowPlans{__typename
... on PermissionDeniedError{__typename}
... on WorkflowPlansSuccess{plans{type
id}}}
serviceEntityRelationships21:serviceEntityRelationships2(first: $first2, orderBy: $orderBy1, filter: $filter4){totalEdges
pageInfo{endCursor
startCursor
hasNextPage
hasPreviousPage}
edges{node{last12MonthSpend
renewalOptions{renewalDate}
serviceEntity{slug
logo
name
id}}}}
teams(first: $first3, orderBy: $orderBy2){totalEdges
pageInfo{endCursor
startCursor
hasNextPage
hasPreviousPage}
edges{node{spendOverTime{amount
from}
averageSpendPerMemberLastMonth
id
name}}}
serviceEntityRelationships22:serviceEntityRelationships2(first: $first4, orderBy: $orderBy3, filter: $filter5){totalEdges
pageInfo{endCursor
startCursor
hasNextPage
hasPreviousPage}
edges{node{directlyAttributableLastMonthSpend
serviceEntity{slug
logo
name
id}}}}
auditLogEvents1:auditLogEvents(filter: $filter6){totalEdges}
auditLogEvents2:auditLogEvents(filter: $filter7){totalEdges}
transactions(filter: $filter8){totalEdges}
transactions1:transactions(filter: $filter9){totalEdges}
organization{spendDelta
lastMonthSpend
aggregateSpendOverTimeReports{amount
from}}
tickets(filter: $filter10){totalEdges}
tickets1:tickets(filter: $filter11){totalEdges}
workflows2(filter: $filter12){totalEdges}
workflows21:workflows2(filter: $filter13){totalEdges}
workflows22:workflows2(filter: $filter14){totalEdges}
workflows23:workflows2(filter: $filter15){totalEdges}
devices{totalEdges}
teams1:teams{totalEdges}
persons(filter: $filter16){totalEdges}
serviceEntityRelationships23:serviceEntityRelationships2{totalEdges}}
"""

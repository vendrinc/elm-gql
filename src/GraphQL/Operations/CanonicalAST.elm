module GraphQL.Operations.CanonicalAST exposing (..)


import GraphQL.Schema.Operation as Operation
import GraphQL.Schema.Object as Object
import GraphQL.Schema.Enum as Enum
import GraphQL.Schema.Field as Field
import GraphQL.Schema.Interface as Interface
import GraphQL.Schema.Union as Union
import GraphQL.Schema.Scalar as Scalar
import GraphQL.Schema.InputObject as Input
import GraphQL.Schema.Type as Type


type alias Document =
    { definitions : List Definition
    }


type Definition
    = Fragment FragmentDetails
    | Operation OperationDetails


type alias FragmentDetails =
    { name : Name
    , typeCondition : Name
    , directives : List Directive
    , selectionSet : List Selection
    }


type alias OperationDetails =
    { operationType : OperationType
    , name : Maybe Name
    , variableDefinitions : List VariableDefinition
    , directives : List Directive
    , fields : List Selection
    }

type OperationType
    = Query
    | Mutation


type alias Directive =
    { name : Name
    , arguments : List Argument
    }

type alias Argument =
    { name : Name
    , value : Value
    }



type alias VariableDefinition =
    { variable : Variable
    , type_ : Type
    , defaultValue : Maybe Value
    }


type alias Variable =
    { name : Name
    }


type Selection
    = Field FieldDetails
    | FieldObject FieldObjectDetails
    | FieldUnion FieldUnionDetails
    | FieldScalar FieldScalarDetails
    | FieldEnum FieldEnumDetails
    | FragmentSelection FragmentSpread
    | UnionCase UnionCaseDetails


getAliasedName : Selection -> String
getAliasedName sel =
    case sel of
        Field details ->
            nameToString (Maybe.withDefault details.name details.alias_)
        FieldObject details ->
            nameToString (Maybe.withDefault details.name details.alias_)
        FieldUnion details ->
            nameToString (Maybe.withDefault details.name details.alias_)
        FieldScalar details ->
            nameToString (Maybe.withDefault details.name details.alias_)
        FieldEnum details ->
            nameToString (Maybe.withDefault details.name details.alias_)
        FragmentSelection details ->
            nameToString (details.name)
        UnionCase details ->
             nameToString (details.tag)

type alias FieldDetails =
    { alias_ : Maybe Name
    , name : Name
    , arguments : List Argument
    , directives : List Directive
    , selection : List Selection
    }

type alias FieldObjectDetails =
    { alias_ : Maybe Name
    , name : Name
    , arguments : List Argument
    , directives : List Directive
    , selection : List Selection
    , object : Object.Object
    }



type alias FieldUnionDetails =
    { alias_ : Maybe Name
    , name : Name
    , arguments : List Argument
    , directives : List Directive
    , selection : List Selection
    , union : Union.Union
    }

type alias FieldScalarDetails =
    { alias_ : Maybe Name
    , name : Name
    , arguments : List Argument
    , directives : List Directive
    , type_ : Type.Type
    }


type alias FieldEnumDetails =
    { alias_ : Maybe Name
    , name : Name
    , arguments : List Argument
    , directives : List Directive
    , values : List { name : String, description : Maybe String}
    }



type alias FragmentSpread =
    { name : Name
    , directives : List Directive
    }


type alias UnionCaseDetails =
    { tag : Name
    , directives : List Directive
    , selection : List Selection
    }



type Name
    = Name String


nameToString : Name -> String
nameToString (Name str) =
    str

type Value
    = Str String
    | Integer Int
    | Decimal Float
    | Boolean Bool
    | Null
    | Enum Name
    | Var Variable
    | Object (List ( Name, Value ))
    | ListValue (List Value)


type Type
    = Type_ Name
    | List_ Type
    | Nullable Type



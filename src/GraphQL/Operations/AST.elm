module GraphQL.Operations.AST exposing (..)


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
    | FragmentSpreadSelection FragmentSpread
    | InlineFragmentSelection InlineFragment


type alias FieldDetails =
    { alias_ : Maybe Name
    , name : Name
    , arguments : List Argument
    , directives : List Directive
    , selection : List Selection
    }


type alias FragmentSpread =
    { name : Name
    , directives : List Directive
    }


type alias InlineFragment =
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


type alias Argument =
    { name : Name
    , value : Value
    }


type alias Directive =
    { name : Name
    , arguments : List Argument
    }


type Type
    = Type_ Name
    | List_ Type
    | Nullable Type

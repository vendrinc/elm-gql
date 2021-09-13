module GraphQL.Operations.AST exposing (..)


type alias Variable =
    { name : Name
    }


type Name
    = Name String


type Value
    = StringValue String
    | IntValue Int
    | FloatValue Float
    | BoolValue Bool
    | NullValue
    | EnumValue Name
    | VariableValue Variable
    | ObjectValue (List ( Name, Value ))
    | ListValue (List Value)


type Selection
    = FieldSelection Field
    | FragmentSpreadSelection FragmentSpread
    | InlineFragmentSelection InlineFragment


type alias Field =
    { alias_ : Maybe Name
    , name : Name
    , arguments : List Argument
    , directives : List Directive
    , selectionSet : List Selection
    }


type alias Argument =
    { name : Name
    , value : Value
    }


type alias Directive =
    { name : Name
    , arguments : List Argument
    }


type alias FragmentSpread =
    { name : Name
    , directives : List Directive
    }


type alias InlineFragment =
    { typeCondition : NamedType
    , directives : List Directive
    , selectionSet : List Selection
    }


type alias NamedType =
    { name : Name
    }


type alias ListType =
    { type_ : Type
    }


type NonNullType
    = NamedNonNull NamedType
    | ListNonNull ListType


type Type
    = NamedTypeType NamedType
    | ListTypeType ListType
    | NonNullTypeType NonNullType


type alias Fragment =
    { name : Name
    , typeCondition : NamedType
    , directives : List Directive
    , selectionSet : List Selection
    }


type OperationType
    = Query
    | Mutation


type alias Operation =
    { operationType : OperationType
    , name : Maybe Name
    , variableDefinitions : List VariableDefinition
    , directives : List Directive
    , selectionSet : List Selection
    }


type alias VariableDefinition =
    { variable : Variable
    , type_ : Type
    , defaultValue : Maybe Value
    }


type Definition
    = FragmentDefinition Fragment
    | OperationDefinition Operation


type alias Document =
    { definitions : List Definition
    }

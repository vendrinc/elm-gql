module GraphQL.Operations.CanonicalAST exposing (..)

import Generate.Input
import GraphQL.Operations.AST as AST
import GraphQL.Schema.Enum as Enum
import GraphQL.Schema.Field as Field
import GraphQL.Schema.InputObject as Input
import GraphQL.Schema.Interface as Interface
import GraphQL.Schema.Object as Object
import GraphQL.Schema.Operation as Operation
import GraphQL.Schema.Scalar as Scalar
import GraphQL.Schema.Type as Type
import GraphQL.Schema.Union as Union


type alias Document =
    { definitions : List Definition
    }


type Definition
    = Operation OperationDetails


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
    , value : AST.Value
    }


type alias VariableDefinition =
    { variable : Variable
    , type_ : AST.Type
    , defaultValue : Maybe AST.Value
    }


type alias Variable =
    { name : Name
    }


type Selection
    = FieldObject FieldObjectDetails
    | FieldUnion FieldUnionDetails
    | FieldScalar FieldScalarDetails
    | FieldEnum FieldEnumDetails
    | UnionCase UnionCaseDetails


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
    , wrapper : Generate.Input.Wrapped
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
    , enumName : String
    , values : List { name : String, description : Maybe String }
    }


type alias UnionCaseDetails =
    { tag : Name
    , directives : List Directive
    , selection : List Selection
    }


type Name
    = Name String


getAliasedName : Selection -> String
getAliasedName sel =
    case sel of
        FieldObject details ->
            nameToString (Maybe.withDefault details.name details.alias_)

        FieldUnion details ->
            nameToString (Maybe.withDefault details.name details.alias_)

        FieldScalar details ->
            nameToString (Maybe.withDefault details.name details.alias_)

        FieldEnum details ->
            nameToString (Maybe.withDefault details.name details.alias_)

        UnionCase details ->
            nameToString details.tag


nameToString : Name -> String
nameToString (Name str) =
    str

import { Maybe } from "graphql-tools";

type Name = string;
type Alias = string;

type QualifiedType = Name[];
type ModuleName = string[];


// Preferred: https://github.com/stil4m/elm-syntax/tree/master/src/Elm/Syntax

// from https://github.com/Bogdanp/elm-ast/blob/master/src/Ast/Statement.elm
type ExportSet =
  | { kind: "AllExport" }
  | { kind: "SubsetExport"; exports: ExportSet[] }
  | { kind: "FunctionExport"; name: Name }
  | { kind: "TypeExport"; name: Name; exports: Maybe<ExportSet> };

type Type =
  | {
      kind: "TypeConstructor";
      qualifiedType: QualifiedType;
      argumentTypes: Type[];
    }
  | { kind: "TypeVariable"; name: Name }
  | {
      kind: "TypeRecordConstructor";
      type: Type;
      fields: { name: Name; type: Type }[];
    }
  | {
      kind: "TypeRecord";
      fields: { name: Name; type: Type }[];
    }
  | {
      kind: "TypeTuple";
      types: Type[];
    }
  | {
      kind: "TypeApplication";
      input: Type;
      return: Type;
    };

type StatementBase
    = { kind: "ModuleDeclaration", moduleName: ModuleName, exports: ExportSet }
    | { kind: "PortModuleDeclaration", moduleName: ModuleName, exports: ExportSet }
    | { kind: "EffectModuleDeclaration", moduleName: ModuleName, noIdeaWhatsover: {nameLeft: Name, nameRight: Name }[], exports: ExportSet }
    | { kind: "ImportStatement", moduleName: ModuleName, alias: Maybe<Alias>, exports: Maybe<ExportSet> }
    | { kind: "TypeAliasDeclaration", typeLeft: Type, typeRight: Type }
    | { kind: "TypeDeclaration", type: Type, parameters: Type[] }
    | { kind: "PortTypeDeclaration", name: Name, type: Type }
    | { kind: "PortDeclaration", name: Name, names: Name[], mexp: Expression }
    | { kind: "FunctionTypeDeclaration", name: Name, type: Type } 
    | { kind: "FunctionDeclaration", pattern: Pattern, exp: Expression }
    | { kind: "InfixDeclaration", assoc: unknown /*Assoc*/, num: number, name: Name }
    | { kind: "Comment", comment: String } 

type Literal
    = { kind: "Character", character: string }
    | { kind: "String", string: string }
    | { kind: "Integer", int: number }
    | { kind: "Float", float: number }


type Pattern
    = { kind: "PWildcard" }
    | { kind: "PVariable", name: Name }
    | { kind: "PConstructor", name: Name }
    | { kind: "PLiteral", literal: Literal }
    | { kind: "PTuple", patterns: Pattern[] }
    | { kind: "PCons", leftPattern: Pattern, rightPattern: Pattern }
    | { kind: "PList", patterns: Pattern[] }
    | { kind: "PRecord", names: Name[] }
    | { kind: "PAs", pattern: Pattern, name: Name }
    | { kind: "PApplication", leftPattern: Pattern, rightPattern: Pattern }

type Expression
    = { kind: "Literal", literal: Literal }
    | { kind: "Variable", name: Name }
    | { kind: "Constructor", name: Name }
    | { kind: "External", names: Name[], expression: Expression }
    | { kind: "List", expressinos: Expression[] }
    | { kind: "Tuple", expressinos: Expression[] }
    | { kind: "Access", expression: Expression, names: Name[] }
    | { kind: "AccessFunction", name: Name }
    | { kind: "Record", fields: {name: Name, expression: Expression}[] }
    | { kind: "RecordUpdate", name: Name, fields: {name: Name, expression: Expression}[] }
    | { kind: "If", testExpression: Expression, ifExpression: Expression, elseExpression: Expression }
    | { kind: "Let", bindings: { pattern: Pattern, expression: Expression}[], body: Expression }
    | { kind: "Case", expression: Expression, patterns: {pattern: Pattern, expression: Expression }[] }
    | { kind: "Lambda", arguments: Pattern[], body: Expression }
    | { kind: "Application", left: Expression, right: Expression }
    | { kind: "BinOp", exp1: Expression, exp2: Expression, exp3: Expression }
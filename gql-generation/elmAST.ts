import { capitalize } from "./util";

export type ImportDeclaration = {
  name: string;
  as?: string;
  exposing?: string;
};

export type Definition = {};

export type Module = {
  moduleName: string;
  imports: {
    [key: string]: {
      as?: string;
      exposing?: string;
    };
  };
  // todo
  body: object[];
};

type VarRef = {
  name: string;
  module: string | null;
};

export const varRef = (name: string, module?: string): VarRef => {
  return {
    name,
    module: module || null,
  };
};

export const importDeclaration = (
  moduleName: string,
  as?: string
): ImportDeclaration => {
  return {
    name: moduleName,
    as,
  };
};

export const module = (
  moduleName: string,
  imports: ImportDeclaration[],
  definitions: Definition[]
): Module => {
  return {
    moduleName,
    imports: imports.reduce((result, importDecl) => {
      //@ts-ignore
      result[importDecl.name] = importDecl;
      return result;
    }, {}),
    body: definitions,
  };
};

export const string = (str: string): ExprStringLiteral => {
  return {
    tag: "StringLiteral",
    value: str,
    display: { representation: "SingleQuotedString" },
  };
};

export type CustomTypeVariant = {
  name: string;
  // todo
  parameterTypes: object[];
};

export const customTypeVariant = (
  name: string,
  parameterTypes = []
): CustomTypeVariant => {
  return {
    name: capitalize(name),
    parameterTypes,
  };
};

export const customType = (
  name: string,
  parameters = [],
  variants: CustomTypeVariant[]
) => {
  return {
    tag: "CustomType",
    name,
    parameters,
    variants,
  };
};

export type TypeReference = {
  tag: "TypeReference";
  name: string;
  arguments: TypeReference[];
};

export type ExprVarRef = {
  tag: "VariableReference";
  name: string;
};

type VariableDefintion = {
  tag: "VariableDefinition";
  name: string;
};

export type ExprAnonymousFunction = {
  tag: "AnonymousFunction";
  parameters: VariableDefintion[];
  body: Expression;
};

type ExprFunctionApplication = {
  tag: "FunctionApplication";
  function: ExprVarRef;
  arguments: Expression[];
  display: {
    showAsInfix: boolean;
  };
};

type ExprListLiteral = {
  tag: "ListLiteral";
  terms: Expression[];
};

type CasePatternStringLiteral = {
  tag: "StringLiteral";
  value: string;
};

type CasePatternAnything = {
  tag: "AnythingPattern";
};

type CasePattern = CasePatternAnything | CasePatternStringLiteral;

type CaseBranch = { pattern: CasePattern; body: Expression };

type ExprCaseExpression = {
  tag: "CaseExpression";
  subject: ExprVarRef;
  branches: CaseBranch[];
};

type ExprStringLiteral = {
  tag: "StringLiteral"
  value: string
  display: { representation: "SingleQuotedString" },
}

export type Expression =
  | ExprVarRef
  | ExprFunctionApplication
  | ExprAnonymousFunction
  | ExprListLiteral
  | ExprStringLiteral
  | ExprCaseExpression;

export const anonymousFunction = (
  parameters: string[],
  body: Expression
): ExprAnonymousFunction => {
  return {
    tag: "AnonymousFunction",
    parameters: parameters.map((name) => {
      return {
        tag: "VariableDefinition",
        name,
      };
    }),
    body,
  };
};

export const variableReference = (name: string): ExprVarRef => {
  return {
    tag: "VariableReference",
    name,
  };
};

export const listLiteral = (terms: Expression[]): ExprListLiteral => {
  return {
    tag: "ListLiteral",
    terms,
  };
};

export const typeReference = (
  varRef: VarRef,
  args: TypeReference[] = []
): TypeReference => {
  return {
    tag: "TypeReference",
    ...varRef,
    arguments: args,
  };
};

export const functionApplication = (
  func: ExprVarRef,
  args: Expression[],
  infix?: boolean
): ExprFunctionApplication => {
  return {
    tag: "FunctionApplication",
    function: func,
    arguments: args,
    display: {
      showAsInfix: infix || false,
    },
  };
};

export const caseStringPattern = (
  value: string,
  body: Expression
): CaseBranch => {
  return {
    pattern: {
      tag: "StringLiteral",
      value,
    },
    body,
  };
};

export const caseAnythingPattern = (body: Expression): CaseBranch => {
  return {
    pattern: {
      tag: "AnythingPattern",
    },
    body,
  };
}

export const caseExpression = (
  subject: ExprVarRef,
  branches: CaseBranch[]
): ExprCaseExpression => {
  return {
    tag: "CaseExpression",
    subject,
    branches,
  };
};

export const definition = (
  name: string,
  returnType: TypeReference,
  expression: object
) => {
  return {
    tag: "Definition",
    name,
    parameters: [],
    returnType,
    expression,
  };
};
// {
//   "tag": "Definition",
//   "name": "list",
//   "parameters": [],
//   "returnType": {
//       "tag": "TypeReference",
//       "name": "List",
//       "module": null,
//       "arguments": [
//           {
//               "tag": "TypeReference",
//               "name": "AppAccessSource",
//               "module": null,
//               "arguments": [],
//           }
//       ],
//   },
//   "expression": {
//       "tag": "ListLiteral",
//       "terms": [
//           {
//               "tag": "VariableReference",
//               "name": "GSuite",
//           },
//           {
//               "tag": "VariableReference",
//               "name": "GoogleSAML",
//           },

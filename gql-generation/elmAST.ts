export type ImportDeclaration = {
  name: string;
  as?: string;
  exposing?: string;
};

export type Definition = {};

export type Module = {
    moduleName: string
    imports: {
        [key:string]: {
            as?: string;
            exposing?: string;
        }
    }
    // todo
    body: object[]
}

export const importDeclaration = (moduleName: string): ImportDeclaration => {
  return {
    name: moduleName,
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

export const string = (str: string) => {
  return {
    tag: "StringLiteral",
    value: str,
    display: { representation: "SingleQuotedString" },
  };
};

export type CustomTypeVariant = {
  name: string
  // todo
  parameterTypes: object[]
}

export const customTypeVariant = (name: string, parameterTypes = []): CustomTypeVariant => {
  return {
    name,
    parameterTypes
  }
}

export const customType = (name: string, parameters = [], variants: CustomTypeVariant[]) => {
  return {
    tag: "CustomType",
    name,
    parameters,
    variants
  }
}
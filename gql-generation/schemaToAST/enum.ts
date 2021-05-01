import { GraphQLEnumType } from "graphql";
import * as Elm from "../elmAST";

export const createModuleForEnum = (
  rootModuleName: string,
  enumType: GraphQLEnumType
): Elm.Module => {
  // Create each value as a Type
  const variants = enumType
    .getValues()
    .map((enumValue) => Elm.customTypeVariant(enumValue.name, []));

  const customType = Elm.customType(enumType.name, [], variants);

  // Create an exhaustive array of all types
  const list = Elm.definition(
    "list",
    Elm.typeReference(Elm.varRef("List"), [
      Elm.typeReference(Elm.varRef(customType.name)),
    ]),
    Elm.listLiteral(
      variants.map((variant) => Elm.variableReference(variant.name))
    )
  );

  // Create wire decoder
  const decoder = Elm.definition(
    "decoder",
    Elm.typeReference(Elm.varRef("Decoder", "Json.Decode"), [
      Elm.typeReference(Elm.varRef(customType.name)),
    ]),
    Elm.functionApplication(
      Elm.variableReference("|>"),
      [
        Elm.variableReference("Decode.string"),
        Elm.functionApplication(Elm.variableReference("Decode.andThen"), [
          Elm.anonymousFunction(
            ["string"],
            Elm.caseExpression(Elm.variableReference("string"), [
              ...variants.map((variant) =>
                Elm.caseStringPattern(
                  variant.name,
                  Elm.functionApplication(
                    Elm.variableReference("Decode.succeed"),
                    [Elm.variableReference(variant.name)]
                  )
                )
              ),
              Elm.caseAnythingPattern(
                Elm.functionApplication(Elm.variableReference("Decode.fail"), [
                  Elm.string("Can't decode it"),
                ])
              ),
            ])
          ),
        ]),
      ],
      true
    )
  );

  // Create module
  const moduleName = `${rootModuleName}.Types.${enumType.name}`;
  const jsonDecodeImport = Elm.importDeclaration("Json.Decode", "Decode");
  return Elm.module(
    moduleName,
    [jsonDecodeImport],
    [customType, list, decoder]
  );
};

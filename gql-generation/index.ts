import { loadSchema } from "@graphql-tools/load";
import { UrlLoader } from "@graphql-tools/url-loader";
import { GraphQLEnumType } from "graphql";
const { writeFile, mkdir } = require("fs").promises;
const util = require("util");
const exec = util.promisify(require("child_process").exec);
const path = require("path");

import * as Elm from "./elmAST";

const RootModule = "TnGql";

const writeElmFile = async (module: Elm.Module) => {
  const jsonFileName = `./output/json/${module.moduleName.replace(/\./g, "/")}.json`;
  await mkdir(path.dirname(jsonFileName), { recursive: true });
  await writeFile(jsonFileName, JSON.stringify(module));

  const { stdout } = await exec(`./bin/elm-format --from-json ${jsonFileName}`);

  const elmFileName = `./output/elm/${module.moduleName.replace(/\./g, "/")}.elm`;
  await mkdir(path.dirname(elmFileName), { recursive: true });
  await writeFile(elmFileName, stdout);
};

const main = async () => {
  const schema = await loadSchema("http://api.blissfully.com/prod/graphql", {
    // load from endpoint
    loaders: [new UrlLoader()],
  });

  const typeMap = schema.getTypeMap();

  const enums: GraphQLEnumType[] = [];

  for (const type_ in schema.getTypeMap()) {
    const typeDefinition = typeMap[type_];

    // Skip special types
    if(typeDefinition.name.startsWith("__")) {
      continue
    }


    // For now, let's just do enums
    if (typeDefinition instanceof GraphQLEnumType) {
      enums.push(typeDefinition);
    }
  }

  //TODO Could be parallel-optimized
  await enums.map(async (enumType) => {
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
              Elm.caseExpression(
                Elm.variableReference("string"),
                [...variants.map(variant =>
                  Elm.caseStringPattern(
                    variant.name,
                    Elm.functionApplication(
                      Elm.variableReference("Decode.succeed"),
                      [Elm.variableReference(variant.name)]
                    )
                  )
                )
                , Elm.caseAnythingPattern(
                  Elm.functionApplication(
                    Elm.variableReference("Decode.fail"),
                    [Elm.string("Can't decode it")]
                  )
                )]
              )
            ),
          ]),
        ],
        true
      )
    );

    // Create module
    const moduleName = `${RootModule}.Types.${enumType.name}`;
    const jsonDecodeImport = Elm.importDeclaration("Json.Decode", "Decode");
    const module = Elm.module(
      moduleName,
      [jsonDecodeImport],
      [customType, list, decoder]
    );
    await writeElmFile(module);
  });
};

main();

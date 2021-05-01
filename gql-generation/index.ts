import { loadSchema } from "@graphql-tools/load";
import { UrlLoader } from "@graphql-tools/url-loader";
import { GraphQLEnumType } from "graphql";
const { writeFile, mkdir } = require("fs").promises;
const util = require("util");
const exec = util.promisify(require("child_process").exec);
const path = require("path");
import { createModuleForEnum} from "./schemaToAST/enum"

import * as Elm from "./elmAST";
import { createModuleForQueries } from "./schemaToAST/queries";

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

  // Do queries...
  const queryObject = schema.getQueryType()
  if(queryObject) {
    const module = createModuleForQueries(RootModule, queryObject)
    await writeElmFile(module);
  }

  //TODO Could be parallel-optimized
  await enums.map(async (enumType) => {
    const module = createModuleForEnum(RootModule, enumType)
    await writeElmFile(module);
  });
};

main();

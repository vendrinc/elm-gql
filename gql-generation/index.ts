import { loadSchema } from "@graphql-tools/load";
import { UrlLoader } from "@graphql-tools/url-loader";
import { GraphQLEnumType } from "graphql";
const { writeFile, mkdir } = require('fs').promises;
const util = require('util');
const exec = util.promisify(require('child_process').exec);
const  path = require('path');

import * as Elm from "./elmAST"

const RootModule = "TnGql"

const writeElmFile = async (module: Elm.Module) => {
    const jsonFileName = `./output/json/${module.moduleName}.json`
    await mkdir(path.dirname(jsonFileName), {recursive: true})
    await writeFile(jsonFileName, JSON.stringify(module));

    const { stdout } = await exec(`./bin/elm-format --from-json ${jsonFileName}`)

    const elmFileName = `./output/elm/${module.moduleName}.elm`
    await mkdir(path.dirname(elmFileName), {recursive: true})
    await writeFile(elmFileName, stdout);
}

const main = async () => {
  const schema = await loadSchema("http://api.blissfully.com/prod/graphql", {
    // load from endpoint
    loaders: [new UrlLoader()],
  });

  const typeMap = schema.getTypeMap()

  const enums: GraphQLEnumType[] = []

  for(const type_ in schema.getTypeMap()) {
    const typeDefinition = typeMap[type_]

    // For now, let's just do enums 
    if(typeDefinition instanceof GraphQLEnumType) {
        enums.push(typeDefinition)
    }
  }

  //TODO Could be parallel-optimized
  await enums.map(async enumType => {

    // Create each value as a Type
    const variants = enumType.getValues().map(enumValue =>
        Elm.customTypeVariant(enumValue.name, [])
    )

    const customType = Elm.customType(enumType.name, [], variants)

    // Create an exhaustive array of all types


    // Create module
    const moduleName = `${RootModule}.${enumType.name}`
    const htmlImport = Elm.importDeclaration("Html")
    const module = Elm.module(moduleName, [htmlImport], [customType])
    await writeElmFile(module)
  })  
};



main();

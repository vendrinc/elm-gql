import * as commander from "commander";
import * as fs from "fs";
import * as path from "path";
import chalk from "chalk";
import { XMLHttpRequest } from "./vendor/XMLHttpRequest";
const schema_generator = require("./generators/schema");
import engine from "./templates/Engine.elm"
import mock from "./templates/Mock.elm"
import schemaModule from "./templates/Schema.elm"
import opsAST from "./templates/Operations/AST.elm"
import opsMock from "./templates/Operations/Mock.elm"
import opsCanAST from "./templates/Operations/CanonicalAST.elm"
import opsParse from "./templates/Operations/Parse.elm"
import opsCanonicalize from "./templates/Operations/Canonicalize.elm"


// We have to stub this in the allow Elm the ability to make http requests.
// @ts-ignore
globalThis["XMLHttpRequest"] = XMLHttpRequest.XMLHttpRequest;

// Run a standard generator made by elm-prefab
async function run_generator(generator: any, output_dir: string, flags: any) {
  const promise = new Promise((resolve, reject) => {
    // @ts-ignore
    const app = generator.init({ flags: flags });
    if (app.ports.onSuccessSend) {
      app.ports.onSuccessSend.subscribe(resolve);
    }
    if (app.ports.onInfoSend) {
      app.ports.onInfoSend.subscribe((info: string) => console.log(info));
    }
    if (app.ports.onFailureSend) {
      app.ports.onFailureSend.subscribe(reject);
    }
  })
    .then((files: any) => {
      for (const file of files) {
        const fullpath = path.join(output_dir, file.path);
        fs.mkdirSync(path.dirname(fullpath), { recursive: true });
        fs.writeFileSync(fullpath, file.contents);
      }

      const s = files.length == 1 ? "" : "s";
      console.log(
        format_block([`${chalk.yellow(files.length)} file${s} generated!`])
      );
    })
    .catch((reason) => {
      console.error(
        format_title(reason.title),
        "\n\n" + reason.description + "\n"
      );
    });
  return promise;
}



/* Get files recursively */

const isDirectory = (pathStr: string) => fs.statSync(pathStr).isDirectory();
const getDirectories = (pathStr: string) =>
    fs.readdirSync(pathStr).map(name => path.join(pathStr, name)).filter(isDirectory);

const isFile = (filepath: string) => fs.statSync(filepath).isFile() && filepath.endsWith("gql");  
const getFiles = (filepath: string) =>
    fs.readdirSync(filepath).map((name: string) => path.join(filepath, name)).filter(isFile);

const getFilesRecursively = (filepath: string): string[] => {
    let dirs = getDirectories(filepath);
    let files = dirs
        .map(dir => getFilesRecursively(dir)) // go through each directory
        .reduce((a,b) => a.concat(b), []);    // map returns a 2d array (array of file arrays) so flatten
    return files.concat(getFiles(filepath));
};




/* CLI feedback formatting */

function format_title(title: string): string {
  const tail = "-".repeat(80 - (title.length + 2));
  return chalk.cyan("--" + title.toUpperCase() + tail);
}

function format_block(content: string[]) {
  return "\n    " + content.join("\n    ") + "\n";
}

async function action(options: Options, com: any) {
  let schema = options.schema;
  if (!schema.startsWith("http") && schema.endsWith("json")) {
    schema = JSON.parse(fs.readFileSync(schema).toString());
  }
  
  // @ts-ignore
  // let gql_operations = []
  if (options.gql) {
    const gql_filepaths = getFilesRecursively(options.gql)
    for (const file of gql_filepaths) {

        // The base is a list of strings that represents 
        // all the folders between options.gql and the discovered `.gql` file
        // This is needed to figure out where to generate the elm file 
        // and what to specify as the qualified name of the module
        const base = options.gql == path.dirname(file) ? [] : path.relative(options.gql, path.dirname(file)).split(path.sep);
        
        const src = fs.readFileSync(file).toString()
        // gql_operations.push({src, path: file})
        run_generator(schema_generator.Elm.Generate, path.dirname(file), {
          namespace: options.namespace,
          // @ts-ignore
          gql: [{src, path: file}],
          base: base,
          schema: schema,
          generatePlatform: false,
          existingEnumDefinitions: options.existingEnumDefinitions
        });
    }
  }

  // Copy gql engine to target dir 
  fs.mkdirSync(path.join(options.output, "GraphQL", "Operations"), { recursive: true });

  // Standard engine
  fs.writeFileSync(path.join(options.output, "GraphQL", "Engine.elm"), engine())

  // Everything required for auto-mocking
  fs.writeFileSync(path.join(options.output, "GraphQL", "Mock.elm"), mock())
  fs.writeFileSync(path.join(options.output, "GraphQL", "Schema.elm"), schemaModule())

  const ops = path.join(options.output, "GraphQL", "Operations")
  fs.writeFileSync(path.join(ops, "Mock.elm"), opsMock())
  fs.writeFileSync(path.join(ops, "AST.elm"), opsAST())
  fs.writeFileSync(path.join(ops, "Parse.elm"), opsParse())
  fs.writeFileSync(path.join(ops, "CanonicalAST.elm"), opsCanAST())
  fs.writeFileSync(path.join(ops, "Canonicalize.elm"), opsCanonicalize())



  // Generate the Elm form of the schema that can be used to construc queries
  run_generator(schema_generator.Elm.Generate, options.output, {
    namespace: options.namespace,
    // @ts-ignore
    gql: [],
    schema: schema,
    generatePlatform: true,
    base: [],
    existingEnumDefinitions: options.existingEnumDefinitions
  });
}

const program = new commander.Command();

type Options = {
  schema: string;
  gql: string | null;
  output: string;
  namespace: string;
  existingEnumDefinitions: string | null;
};

program
  .version("0.1.0")
  .option("--schema <fileOrUrl>")
 
  .option(
    "--gql <dir>",
    "Search a directory for GQL files and generate Elm bindings"
  )
  .option(
    "--namespace <namespace>",
    "Change the namespace that the generated code should have.",
    "Api"
  )
  .option(
    "--output <dir>",
    "The directory where your generated files should go.",
    "api"
  )
  .option("--existing-enum-definitions <name>",
    "This option isn't used very commonly.  If you already have Enum definitions generated, this will skip Enum generation and point to your existing enums."
  )
  .action(action);

program.parseAsync();



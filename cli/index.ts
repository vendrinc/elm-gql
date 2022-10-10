import * as commander from "commander";
import * as fs from "fs";
import * as path from "path";
import * as crypto from "crypto";
import chalk from "chalk";
import { XMLHttpRequest } from "./vendor/XMLHttpRequest";
const schema_generator = require("./generators/schema");
import engine from "./templates/Engine.elm";
import mock from "./templates/Mock.elm";
import schemaModule from "./templates/Schema.elm";
import opsAST from "./templates/Operations/AST.elm";
import opsMock from "./templates/Operations/Mock.elm";
import opsCanAST from "./templates/Operations/CanonicalAST.elm";
import opsParse from "./templates/Operations/Parse.elm";
import opsCanonicalize from "./templates/Operations/Canonicalize.elm";

// We have to stub this in the allow Elm the ability to make http requests.
// @ts-ignore
globalThis["XMLHttpRequest"] = XMLHttpRequest.XMLHttpRequest;

const version: string = "0.1.0";

type Cache = {
  engineVersion: string;
  files: { [name: string]: { modified: Date } };
};

const emptyCache: Cache = {
  engineVersion: version,
  files: {},
};

// Run a standard generator made by elm-prefab
async function run_generator(generator: any, flags: any) {
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
      // clear generated queries/mutations
      // because now we're confident we can replace them.
      for (const file of flags.gql) {
        const targetDir = file.path.replace(".gql", "");
        clearDir(targetDir);
      }

      let files_written_count = 0;
      let files_skipped = 0;
      for (const file of files) {
        fs.mkdirSync(path.dirname(file.path), { recursive: true });
        if (writeIfChanged(file.path, file.contents)) {
          files_written_count = files_written_count + 1;
        } else {
          files_skipped = files_skipped + 1;
        }
      }

      if (flags.init) {
        initGreeting(files_written_count, flags);
      } else {
        const lines = [];
        if (files_written_count > 0) {
          let modifiedFileNames = "";

          if (flags.init) {
            modifiedFileNames += "";
          } else if (flags.generatePlatform) {
            modifiedFileNames = `The ${chalk.cyan("GQL schema")} has changed, `;
          } else if (flags.gql.length == 1) {
            modifiedFileNames = `${chalk.cyan(
              flags.gql[0].path
            )} was modified, `;
          } else {
            modifiedFileNames = `${flags.gql.length} GQL files were modified, `;
          }

          if (files_written_count == 1) {
            lines.push(
              `${modifiedFileNames}${chalk.yellow(
                files_written_count
              )} file generated!`
            );
          } else {
            lines.push(
              `${modifiedFileNames}${chalk.yellow(
                files_written_count
              )} files generated!`
            );
          }
        }
        if (files_skipped > 0) {
          if (files_skipped == 1) {
            lines.push(
              `${chalk.gray(
                files_skipped
              )} file skipped because it was already present and up-to-date`
            );
          } else {
            lines.push(
              `${chalk.gray(
                files_skipped
              )} files skipped because they were already present and up-to-date`
            );
          }
        }
        console.log(format_block(lines));
      }
    })
    .catch((errorList) => {
      for (const error of errorList) {
        console.error(
          format_title(error.title),
          "\n\n" + error.description + "\n"
        );
      }

      process.exit(1);
    });
  return promise;
}

/* Get files recursively */

const isDirectory = (pathStr: string) => fs.statSync(pathStr).isDirectory();
const getDirectories = (pathStr: string) =>
  fs
    .readdirSync(pathStr)
    .map((name) => path.join(pathStr, name))
    .filter(isDirectory);

const isFile = (filepath: string) =>
  fs.statSync(filepath).isFile() && filepath.endsWith("gql");
const getFiles = (filepath: string) =>
  fs
    .readdirSync(filepath)
    .map((name: string) => path.join(filepath, name))
    .filter(isFile);

const getFilesRecursively = (filepath: string): string[] => {
  let dirs = getDirectories(filepath);
  let files = dirs
    .map((dir) => getFilesRecursively(dir)) // go through each directory
    .reduce((a, b) => a.concat(b), []); // map returns a 2d array (array of file arrays) so flatten
  return files.concat(getFiles(filepath));
};

/* CLI feedback formatting */

function format_title(title: string): string {
  const tail = "-".repeat(80 - (title.length + 2));
  return chalk.cyan("--" + title + tail);
}

function format_block(content: string[]) {
  return "\n    " + content.join("\n    ") + "\n";
}

function format_bullet(content: string) {
  return `  ${chalk.yellow("•")} ` + content;
}

function writeIfChanged(filepath: string, content: string): boolean {
  try {
    const foundContents = fs.readFileSync(filepath);
    const foundHash = crypto
      .createHash("md5")
      .update(foundContents)
      .digest("hex");
    const desiredHash = crypto.createHash("md5").update(content).digest("hex");

    if (foundHash != desiredHash) {
      fs.writeFileSync(filepath, content);
      return true;
    }
    return false;
  } catch {
    fs.writeFileSync(filepath, content);
    return true;
  }
}

const wasModified = (cache: Cache, file: string) => {
  const stat = fs.statSync(file);
  if (file in cache.files) {
    if (+cache.files[file].modified == +stat.mtime) {
      return { at: stat.mtime, was: false };
    } else {
      return { at: stat.mtime, was: true };
    }
  } else {
    return { at: stat.mtime, was: true };
  }
};

const readCache = (force: boolean) => {
  let cache = emptyCache;
  if (force) {
    return cache;
  }
  try {
    cache = JSON.parse(fs.readFileSync(".elm-gql-cache").toString());

    for (const path in cache.files) {
      cache.files[path] = { modified: new Date(cache.files[path].modified) };
    }
  } catch {}

  return cache;
};

const isDev = () => {
  return true;
};

const clearDir = (dir: string) => {
  try {
    const files = fs.readdirSync(dir);

    for (const file of files) {
      fs.unlinkSync(path.join(dir, file));
    }
  } catch {}
};

function initGreeting(filesGenerated: number, flags: any) {
  const lines = [];
  lines.push(`Welcome to ${chalk.cyan("elm-gql")}!`);
  lines.push(`I've generated a number of files to get you started:`);
  lines.push("");
  lines.push(format_bullet(`${chalk.cyan("src/" + flags.namespace + ".elm")}`));

  lines.push(
    format_bullet(
      `${chalk.yellow(filesGenerated)} files in ${chalk.cyan(
        flags.elmBaseSchema.join("/") + "/"
      )}`
    )
  );

  if (flags.gql.length == 1) {
    lines.push(
      format_bullet(
        `I also found ${chalk.yellow(
          flags.gql.length
        )} GQL file and generated Elm code to help you use it.`
      )
    );
  } else if (flags.gql.length > 0) {
    lines.push(
      format_bullet(
        `I also found ${chalk.yellow(
          flags.gql.length
        )} GQL files and generated Elm code to help you use them.`
      )
    );
  }
  lines.push(
    format_bullet(
      `I've saved the schema as ${chalk.cyan(flags.namespace + "/schema.json")}`
    )
  );

  lines.push("");
  lines.push(`Check out the getting started guide for more details!`);
  lines.push(
    chalk.yellow(
      "https://github.com/vendrinc/elm-gql/blob/main/guide/GettingStarted.md"
    )
  );
  console.log(format_block(lines));
}

async function run(schema: string, options: Options) {
  let newCache = emptyCache;

  let cache = readCache(options.force);

  let schemaWasModified = { at: new Date(), was: false };
  if (!schema.startsWith("http") && schema.endsWith("json")) {
    schemaWasModified = wasModified(cache, schema);

    newCache.files[schema] = { modified: schemaWasModified.at };
    schema = JSON.parse(fs.readFileSync(schema).toString());
  }

  const gqlFolder = ".";
  const gqlBase: string[] = ["."];
  const gql_filepaths = getFilesRecursively(gqlFolder);

  const fileSources = [];
  for (const file of gql_filepaths) {
    const modified = wasModified(cache, file);
    if (modified.was) {
      const src = fs.readFileSync(file).toString();
      fileSources.push({ src, path: file });
    }
    newCache.files[file] = { modified: modified.at };
  }

  if (fileSources.length > 0 || schemaWasModified.was || options.force) {
    run_generator(schema_generator.Elm.Generate, {
      namespace: options.namespace,
      // @ts-ignore
      gql: fileSources,
      elmBase: gqlBase,
      elmBaseSchema: options.output.split(path.sep),
      schema: schema,
      generatePlatform: schemaWasModified.was || options.force,
      init: options.init,
      existingEnumDefinitions: options.existingEnumDefinitions,
    });
  } else {
    console.log(
      format_block([
        `${chalk.cyan("elm-gql: ")} No files were modified, skipping codegen.`,
      ])
    );
  }

  if (cache.engineVersion != newCache.engineVersion || isDev()) {
    // Copy gql engine to target dir
    fs.mkdirSync(path.join(options.output, "GraphQL", "Operations"), {
      recursive: true,
    });

    // Standard engine
    writeIfChanged(
      path.join(options.output, "GraphQL", "Engine.elm"),
      engine()
    );

    // Everything required for auto-mocking
    writeIfChanged(path.join(options.output, "GraphQL", "Mock.elm"), mock());
    writeIfChanged(
      path.join(options.output, "GraphQL", "Schema.elm"),
      schemaModule()
    );

    const ops = path.join(options.output, "GraphQL", "Operations");
    writeIfChanged(path.join(ops, "Mock.elm"), opsMock());
    writeIfChanged(path.join(ops, "AST.elm"), opsAST());
    writeIfChanged(path.join(ops, "Parse.elm"), opsParse());
    writeIfChanged(path.join(ops, "CanonicalAST.elm"), opsCanAST());
    writeIfChanged(path.join(ops, "Canonicalize.elm"), opsCanonicalize());
  }

  fs.writeFileSync(".elm-gql-cache", JSON.stringify(newCache));
}

async function action(schema: string, options: Options) {
  options.init = false;
  run(schema, options);
}

async function init(schema: string, options: Options) {
  options.init = true;
  options.force = true;
  run(schema, options);
}

const program = new commander.Command();

type Options = {
  output: string;
  namespace: string;
  force: boolean;
  existingEnumDefinitions: string | null;
  init: boolean;
};

program
  .version(version)
  .argument("<schema>", "The schema.")
  .option(
    "--namespace <namespace>",
    "Change the namespace that the generated code should have.",
    "Api"
  )
  .option("--force", "Skip the cache.")
  .option(
    "--output <dir>",
    "The directory where your generated files should go.",
    "api"
  )
  .option(
    "--existing-enum-definitions <name>",
    "This option isn't used very commonly.  If you already have Enum definitions generated, this will skip Enum generation and point to your existing enums."
  )
  .action(action);

program
  .command("init")
  .argument("<schema>", "The schema.")
  .option(
    "--namespace <namespace>",
    "Change the namespace that the generated code should have.",
    "Api"
  )
  .option("--force", "Skip the cache.")
  .option(
    "--output <dir>",
    "The directory where your generated files should go.",
    "api"
  )
  .option(
    "--existing-enum-definitions <name>",
    "This option isn't used very commonly.  If you already have Enum definitions generated, this will skip Enum generation and point to your existing enums."
  )
  .action(init);

program.parseAsync();

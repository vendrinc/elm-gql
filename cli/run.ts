import * as fs from "fs";
import * as path from "path";
import * as crypto from "crypto";
import chalk from "chalk";
import { XMLHttpRequest } from "./vendor/XMLHttpRequest";
const schema_generator = require("./generators/schema");
import engine from "./templates/Engine.elm";
import input from "./templates/InputObject.elm";
import decode from "./templates/Decode.elm";

// We have to stub this in the allow Elm the ability to make http requests.
// @ts-ignore
globalThis["XMLHttpRequest"] = XMLHttpRequest.XMLHttpRequest;

export const version: string = "0.13.0";
type Cache = {
  engineVersion: string;
  files: { [namespace: string]: { [name: string]: { modified: Date } } };
};

function emptyCache(namespace: string): Cache {
  let emptyFiles: any = {};
  emptyFiles[namespace] = {};

  return {
    engineVersion: version,
    files: emptyFiles,
  };
}

export type Summary =
  | { errors: Error[] }
  | { message: string; generated: Generated[] };

export type Error = { title: string; description: string };
export type Generated = { outputDir: string; path: string };

// Run a standard generator made by elm-codegen
async function run_generator(generator: any, flags: any): Promise<Summary> {
  const promise = new Promise((resolve, reject) => {
    // @ts-ignore
    const app = generator.init({ flags: flags });
    if (app.ports.onSuccessSend) {
      app.ports.onSuccessSend.subscribe(resolve);
    }
    if (app.ports.onFailureSend) {
      app.ports.onFailureSend.subscribe(reject);
    }
  })
    .then((files: any) => {
      // clear generated queries/mutations
      // because now we're confident we can replace them.
      for (const file of flags.gql) {
        const targetDir = file.path.replace(".gql", "").replace(".graphql", "");
        clearDir(targetDir);
        clearDir(path.join(targetDir, "Fragments"));
      }

      let files_written: Generated[] = [];
      let files_written_count = 0;
      let files_skipped = 0;
      for (const file of files) {
        files_written.push({
          outputDir: flags.outputAll ? flags.outputAll : flags.output,
          path: file.path,
        });
        fs.mkdirSync(path.dirname(file.path), { recursive: true });
        if (writeIfChanged(file.path, file.contents)) {
          files_written_count = files_written_count + 1;
        } else {
          files_skipped = files_skipped + 1;
        }
      }

      if (flags.init) {
        const lines = initGreeting(files_written_count + files_skipped, flags);
        return { message: format_block(lines), generated: files };
      } else if (flags.force) {
        const lines = forceMessage(files_written_count, files_skipped, flags);
        return { message: format_block(lines), generated: files };
      } else {
        const lines = [];
        if (files_written_count > 0) {
          let modifiedFileNames = "";

          if (flags.generatePlatform) {
            modifiedFileNames = `The ${chalk.cyan(
              flags.namespace + " schema"
            )} has changed, `;
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

        return { message: format_block(lines), generated: files };
      }
    })
    .catch((errorList) => {
      const errors: Error[] = [];
      for (const error of errorList) {
        errors.push({ title: error.title, description: error.description });
      }

      return { errors: errors };
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
  fs.statSync(filepath).isFile() &&
  (filepath.endsWith(".gql") || filepath.endsWith(".graphql"));

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
  const spacing = Math.max(0, 80 - (title.length + 2));
  const tail = "-".repeat(spacing);
  return chalk.cyan("--" + title + tail);
}

function format_block(content: string[]) {
  return "\n    " + content.join("\n    ") + "\n";
}

function format_bullet(content: string) {
  return `  • ` + content;
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

const wasModified = (namespace: string, cache: Cache, file: string) => {
  const stat = fs.statSync(file);
  if (namespace in cache.files) {
    if (file in cache.files[namespace]) {
      if (+cache.files[namespace][file].modified == +stat.mtime) {
        return { at: stat.mtime, was: false };
      } else {
        return { at: stat.mtime, was: true };
      }
    } else {
      return { at: stat.mtime, was: true };
    }
  } else {
    return { at: stat.mtime, was: true };
  }
};

const readCache = (namespace: string, force: boolean) => {
  let cache = emptyCache(namespace);
  if (force) {
    return cache;
  }
  try {
    cache = JSON.parse(fs.readFileSync(".elm-gql-cache").toString());
    if (namespace in cache.files) {
      for (const path in cache.files[namespace]) {
        cache.files[namespace][path] = {
          modified: new Date(cache.files[namespace][path].modified),
        };
      }
    } else {
      return emptyCache(namespace);
    }
  } catch {}

  return cache;
};

const cacheExists = (namespace: string) => {
  try {
    return fs.existsSync(".elm-gql-cache");
  } catch {}

  return false;
};

const clearDir = (dir: string) => {
  try {
    const files = fs.readdirSync(dir);

    for (const file of files) {
      fs.unlinkSync(path.join(dir, file));
    }
  } catch {}
};

function initGreeting(filesGenerated: number, flags: any): string[] {
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
  lines.push(`Learn more about writing a query to get started!`);
  lines.push(
    chalk.yellow(
      "https://github.com/vendrinc/elm-gql/blob/main/guide/LifeOfAQuery.md"
    )
  );
  return lines;
}

function initOverwriteWarning(): Summary {
  const lines = [];
  lines.push(
    `I tried to run ${chalk.yellow(
      "elm-gql init"
    )}, but it looks like elm-gql has already been init-ed.`
  );
  lines.push(
    `If you're sure you want to rerun ${chalk.cyan(
      "init"
    )}, pass ${chalk.yellow("--force")}`
  );

  return {
    errors: [
      { title: "Already initialized", description: format_block(lines) },
    ],
  };
}

function forceMessage(
  filesGenerated: number,
  files_skipped: number,
  flags: any
): string[] {
  const lines = [];
  lines.push(
    `${
      chalk.cyan("elm-gql") + chalk.yellow(" --force")
    } was used, all files are being regenerated.`
  );
  lines.push("");

  lines.push(
    `${chalk.yellow(filesGenerated + files_skipped)} files in ${chalk.cyan(
      flags.elmBaseSchema.join("/") + "/"
    )} were recreated`
  );

  if (flags.gql.length == 1) {
    lines.push(
      `${chalk.yellow(flags.gql.length)} GQL file was found and processed.`
    );
  } else if (flags.gql.length > 0) {
    lines.push(
      `${chalk.yellow(flags.gql.length)} GQL files were found and processed.`
    );
  }

  lines.push("");
  lines.push(
    `If you find yourself using ${chalk.yellow(
      "--force"
    )} all the time, check to make sure it's actually needed.`
  );
  lines.push(`Running without it will be much faster!`);

  return lines;
}

async function generate(schema: string, options: Options): Promise<Summary> {
  let newCache = emptyCache(options.namespace);

  let cache = readCache(options.namespace, options.force);

  let schemaWasModified = { at: new Date(), was: false };
  if (!schema.startsWith("http") && schema.endsWith("json")) {
    schemaWasModified = wasModified(options.namespace, cache, schema);
    newCache.files[options.namespace][schema] = {
      modified: schemaWasModified.at,
    };
    try {
      schema = JSON.parse(fs.readFileSync(schema).toString());
    } catch (error) {
      const description = format_block([
        `${chalk.cyan(
          "elm-gql: "
        )} I was trying to read the GraphQL Schema from the local filesystem at ${chalk.yellow(
          schema
        )}, but wasn't able to!
  
  The full path of where I looked was
  
      ${chalk.cyan(path.join(process.cwd(), schema))}

  And the error I got was

      ${chalk.cyan(error)}
          
  `,
      ]);
      return { errors: [{ title: "Error reading schema", description }] };
    }
  }

  // Query files
  let gql_filepaths = [];
  try {
    gql_filepaths = getFilesRecursively(options.queries);
  } catch (error) {
    const description = format_block([
      `${chalk.cyan("elm-gql: ")} I was trying to read the ${chalk.yellow(
        options.queries
      )} directory for GraphQL files, but wasn't able to!

The full path of where I looked was:

    ${chalk.cyan(path.join(process.cwd(), options.queries))}
        
`,
    ]);

    return { errors: [{ title: "Error reading queries", description }] };
  }

  // Global fragments
  let gql_global_fragments: string[] = [];
  if (options.globalFragments) {
    try {
      gql_global_fragments = getFilesRecursively(options.globalFragments);
    } catch (error) {
      const description = format_block([
        `${chalk.cyan("elm-gql: ")} I was trying to read the ${chalk.yellow(
          options.globalFragments
        )} directory for GraphQL files, but wasn't able to!
  
  The full path of where I looked was:
  
      ${chalk.cyan(path.join(process.cwd(), options.globalFragments))}
          
  `,
      ]);

      return {
        errors: [{ title: "Error reading global fragments", description }],
      };
    }
  }

  // Global files need to always be read
  var globalFragmentsModified = false;
  const globalFragmentFileSources = [];
  for (const file of gql_global_fragments) {
    const modified = wasModified(options.namespace, cache, file);
    const src = fs.readFileSync(file).toString();
    globalFragmentFileSources.push({ src, path: file });
    newCache.files[options.namespace][file] = { modified: modified.at };

    if (modified.was || options.force) {
      globalFragmentsModified = true;
    }
  }

  const fileSources = [];
  for (const file of gql_filepaths) {
    const modified = wasModified(options.namespace, cache, file);
    if (modified.was || options.force || globalFragmentsModified) {
      const src = fs.readFileSync(file).toString();
      fileSources.push({ src, path: file });
    }
    newCache.files[options.namespace][file] = { modified: modified.at };
  }

  const outputDir = options.outputAll ? options.outputAll : options.output;
  let result: Summary = {
    message: "",
    generated: [
      { outputDir, path: path.join("GraphQL", "Engine.elm") },
      { outputDir, path: path.join("GraphQL", "InputObject.elm") },
      { outputDir, path: path.join("GraphQL", "Decode.elm") },
    ],
  };

  if (
    fileSources.length > 0 ||
    schemaWasModified.was ||
    options.force ||
    globalFragmentsModified
  ) {
    result = await run_generator(schema_generator.Elm.Generate, {
      namespace: options.namespace,
      // @ts-ignore
      gql: fileSources,
      fragmentDir: options.globalFragments
        ? options.globalFragments.split(path.sep)
        : [],
      globalFragments: globalFragmentFileSources,
      header: options.header,
      gqlDir: options.queries.split(path.sep),
      elmBaseSchema: outputDir.split(path.sep),
      outputAll: options.outputAll ? options.outputAll.split(path.sep) : null,
      schema: schema,
      generateMocks: options.generateMocks,
      generatePlatform: schemaWasModified.was || options.force,
      force: options.force,
      init: options.init,
      reportUnused: true,
      existingEnumDefinitions: options.existingEnumDefinitions,
    });
    if ("errors" in result) {
      return result;
    }
  } else {
    result.message = format_block([
      `${chalk.cyan("elm-gql: ")} No files were modified, skipping codegen.`,
    ]);
  }

  // Copy gql engine to target dir
  fs.mkdirSync(path.join(outputDir, "GraphQL"), {
    recursive: true,
  });

  // Standard engine
  writeIfChanged(path.join(outputDir, "GraphQL", "Engine.elm"), engine());
  writeIfChanged(path.join(outputDir, "GraphQL", "InputObject.elm"), input());
  writeIfChanged(path.join(outputDir, "GraphQL", "Decode.elm"), decode());
  fs.writeFileSync(".elm-gql-cache", JSON.stringify(newCache));
  return result;
}

function checkNamespace(options: Options): Summary | null {
  // Namespace must match a single Elm module name
  //(Below is a NOT check (I always miss the !)
  if (!/^[A-Z][a-zA-Z]+$/.test(options.namespace)) {
    const lines = [];
    lines.push(
      `The namespace you provided(${chalk.yellow(
        options.namespace
      )}) doesn't quite work unfortunately.`
    );
    lines.push(
      `A namespace can only be a single capitalized word like ${chalk.cyan(
        "Api"
      )} or ${chalk.cyan("Gql")} and it can't contain any periods or slashes!`
    );

    return {
      errors: [
        { title: "Invalid namespace", description: format_block(lines) },
      ],
    };
  }
  return null;
}

// Exports

export type Options = {
  output: string;
  outputAll: string | null;
  namespace: string;
  header: string[];
  force: boolean;
  generateMocks: boolean;
  queries: string;
  globalFragments: string | null;
  existingEnumDefinitions: string | null;
  init: boolean;
};

export async function run(schema: string, options: Options): Promise<Summary> {
  options.init = false;
  checkNamespace(options);
  const result = await generate(schema, options);
  return result;
}

export async function init(schema: string, options: Options): Promise<Summary> {
  options.init = true;
  const namespaceError = checkNamespace(options);
  if (namespaceError) {
    return namespaceError;
  }
  if (!options.force && cacheExists(options.namespace)) {
    return initOverwriteWarning();
  }

  options.force = true;
  const result = await generate(schema, options);
  return result;
}

export async function runCLI(schema: string, options: Options): Promise<void> {
  const result = await run(schema, options);
  printResult(result);
}

export async function initCLI(schema: string, options: Options): Promise<void> {
  const result = await init(schema, options);
  printResult(result);
}

const printResult = (result: Summary) => {
  if ("errors" in result) {
    for (const error of result.errors) {
      console.error(
        format_title(error.title),
        "\n\n" + error.description + "\n"
      );
    }
    process.exit(1);
  } else {
    console.log(result.message);
  }
};

import * as commander from "commander";
import chalk from "chalk";

import * as Run from "./run";

const version: string = "0.1.0";

function collect(val: string, memo: string[]) {
  memo.push(val);
  return memo;
}

const program = new commander.Command();

const helpText = `
  Welcome to ${chalk.cyan("elm-gql")}!
  
  Make sure to check out the ${chalk.yellow("guides")}:
      https://github.com/vendrinc/elm-gql
  `;

program.version(version).name("elm-gql").addHelpText("before", helpText);

program
  .command("run")
  .description(
    `
      Generate Elm code from a GraphQL schema and ${chalk.yellow(
        ".graphql"
      )} files.
      This will create a ${chalk.yellow(
        "codegen"
      )} directory and provide you with everything you need to get started.
  `
  )
  .argument("<schema>", "The schema.")
  .option(
    "--namespace <namespace>",
    "Use a namespace for the generated code.  It must be a capitalized word with no periods or spaces.",
    "Api"
  )
  .option("--force", "Skip the cache.", false)
  .option(
    "--generate-mocks",
    "Generate Elm files to help mock response data for testing.",
    false
  )
  .option(
    "--header <header>",
    "The header to include in the introspection query.",
    collect,
    []
  )
  .option(
    "--queries <dir>",
    "The directory to scan for GraphQL queries and mutations.",
    "src"
  )
  .option(
    "--output <dir>",
    "The directory where your generated files should go.",
    "api"
  )
  .option(
    "--existing-enum-definitions <name>",
    "This option isn't used very commonly.  If you already have Enum definitions generated, this will skip Enum generation and point to your existing enums."
  )
  .action(Run.run);

program
  .command("init")
  .description(
    `
      Start an Elm GQL project.
      
      This will generate Elm code from a GraphQL schema and ${chalk.yellow(
        ".graphql"
      )} files.
      It's nearly the same as 'run', but will generate a file for handling your Scalars as well.
  `
  )
  .argument("<schema>", "The schema.")
  .option(
    "--namespace <namespace>",
    "Use a namespace for the generated code.  It must be a capitalized word with no periods or spaces.",
    "Api"
  )
  .option("--force", "Skip the cache.", false)
  .option(
    "--generate-mocks",
    "Generate Elm files to help mock response data for testing.",
    false
  )
  .option(
    "-h, --header <header>",
    "The header to include in the introspection query.",
    collect,
    []
  )
  .option(
    "--queries <dir>",
    "The directory to scan for GraphQL queries and mutations.",
    "src"
  )
  .option(
    "--output <dir>",
    "The directory where your generated files should go.",
    "api"
  )
  .option(
    "--existing-enum-definitions <name>",
    "This option isn't used very commonly.  If you already have Enum definitions generated, this will skip Enum generation and point to your existing enums."
  )
  .action(Run.init);

program.showHelpAfterError();
program.parseAsync(process.argv);

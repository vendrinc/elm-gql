import * as Run from "./run";

export type Options = {
  outputDir?: string;
  namespace?: string;
  header?: string[];
  force?: boolean;
  queries?: string;
  existingEnumDefinitions?: string | null;
};

export async function run(targetFile: string, options: Options) {
  return Run.run(targetFile, {
    output: options.outputDir ? options.outputDir : "api",
    namespace: options.namespace ? options.namespace : "Api",
    header: options.header ? options.header : [],
    force: options.force ? options.force : false,
    queries: options.queries ? options.queries : "src",
    existingEnumDefinitions: options.existingEnumDefinitions
      ? options.existingEnumDefinitions
      : null,
    init: false,
  });
}

export async function init(targetFile: string, options: Options) {
  return Run.init(targetFile, {
    output: options.outputDir ? options.outputDir : "api",
    namespace: options.namespace ? options.namespace : "Api",
    header: options.header ? options.header : [],
    force: options.force ? options.force : false,
    queries: options.queries ? options.queries : "src",
    existingEnumDefinitions: options.existingEnumDefinitions
      ? options.existingEnumDefinitions
      : null,
    init: true,
  });
}

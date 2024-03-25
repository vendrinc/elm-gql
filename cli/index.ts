import * as Run from "./run";

export type Options = {
  outputDir?: string;
  outputAll?: string;
  namespace?: string;
  header?: string[];
  force?: boolean;
  generateMocks?: boolean;
  queries?: string;
  globalFragments: string | null;
  existingEnumDefinitions?: string | null;
};

export async function run(
  schema: string,
  options: Options
): Promise<Run.Summary> {
  return Run.run(schema, {
    output: options.outputDir ? options.outputDir : "api",
    outputAll: options.outputAll ? options.outputAll : null,
    namespace: options.namespace ? options.namespace : "Api",
    header: options.header ? options.header : [],
    force: options.force ? options.force : false,
    generateMocks: options.generateMocks ? options.generateMocks : false,
    queries: options.queries ? options.queries : "src",
    globalFragments: options.globalFragments ? options.globalFragments : null,
    existingEnumDefinitions: options.existingEnumDefinitions
      ? options.existingEnumDefinitions
      : null,
    init: false,
  });
}

export async function init(
  schema: string,
  options: Options
): Promise<Run.Summary> {
  return Run.init(schema, {
    output: options.outputDir ? options.outputDir : "api",
    outputAll: options.outputAll ? options.outputAll : null,
    namespace: options.namespace ? options.namespace : "Api",
    header: options.header ? options.header : [],
    force: options.force ? options.force : false,
    generateMocks: options.generateMocks ? options.generateMocks : false,
    queries: options.queries ? options.queries : "src",
    globalFragments: options.globalFragments ? options.globalFragments : null,
    existingEnumDefinitions: options.existingEnumDefinitions
      ? options.existingEnumDefinitions
      : null,
    init: true,
  });
}

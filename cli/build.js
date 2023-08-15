const { readFileSync, writeFileSync } = require("fs");

/*

This file creates a `.ts` file that just has the GraphQL/Engine.elm file as as string within it.

This is because we both need to ship the Engine file and use it locally in this package.

*/

const contents = (body) => `export default (): string => ${body}`;

let engine = JSON.stringify(
  readFileSync("./src/GraphQL/Engine.elm").toString()
);
writeFileSync("./cli/templates/Engine.elm.ts", contents(engine));

let input = JSON.stringify(
  readFileSync("./src/GraphQL/InputObject.elm").toString()
);
writeFileSync("./cli/templates/InputObject.elm.ts", contents(input));

let decode = JSON.stringify(
  readFileSync("./src/GraphQL/Decode.elm").toString()
);
writeFileSync("./cli/templates/Decode.elm.ts", contents(decode));

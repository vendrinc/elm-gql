const { readFileSync, writeFileSync } = require('fs');

/*

This file creates a `.ts` file that just has the GraphQL/Engine.elm file as as string within it.

This is because we both need to ship the Engine file and use it locally in this package.

*/

let engine = JSON.stringify(readFileSync('./templates/GraphQL/Engine.elm').toString());

engine = `export default (): string => ${engine}`

writeFileSync('./cli/templates/Engine.elm.ts', engine)
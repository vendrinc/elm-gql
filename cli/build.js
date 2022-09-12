const { readFileSync, writeFileSync } = require('fs');

/*

This file creates a `.ts` file that just has the GraphQL/Engine.elm file as as string within it.

This is because we both need to ship the Engine file and use it locally in this package.

*/


const contents = (body) => `export default (): string => ${body}`

let engine = JSON.stringify(readFileSync('./src/GraphQL/Engine.elm').toString());
writeFileSync('./cli/templates/Engine.elm.ts', contents(engine))

let mock = JSON.stringify(readFileSync('./src/GraphQL/Mock.elm').toString());
writeFileSync('./cli/templates/Mock.elm.ts', contents(mock))



// Also need to copy some core codegen modules to allow mocking to work
let opsMock = JSON.stringify(readFileSync('./src/GraphQL/Operations/Mock.elm').toString());
writeFileSync('./cli/templates/Operations/Mock.elm.ts', contents(opsMock))

let ast = JSON.stringify(readFileSync('./src/GraphQL/Operations/AST.elm').toString());
writeFileSync('./cli/templates/Operations/AST.elm.ts', contents(ast))

let canAst = JSON.stringify(readFileSync('./src/GraphQL/Operations/CanonicalAST.elm').toString());
writeFileSync('./cli/templates/Operations/CanonicalAST.elm.ts', contents(canAst))

let can = JSON.stringify(readFileSync('./src/GraphQL/Operations/Canonicalize.elm').toString());
writeFileSync('./cli/templates/Operations/Canonicalize.elm.ts', contents(can))

let parse = JSON.stringify(readFileSync('./src/GraphQL/Operations/Parse.elm').toString());
writeFileSync('./cli/templates/Operations/Parse.elm.ts', contents(parse))

let schema = JSON.stringify(readFileSync('./src/GraphQL/Schema.elm').toString());
writeFileSync('./cli/templates/Schema.elm.ts', contents(schema))
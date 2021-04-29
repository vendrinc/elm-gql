var express = require("express");
var { graphqlHTTP } = require("express-graphql");
var { buildSchema } = require("graphql");
var fs = require("fs");

// Construct a schema, using GraphQL schema language
const schema = fs.readFileSync("schema.graphql", { encoding: "utf8" });

// The root provides a resolver function for each API endpoint
var root = {
  hello: () => {
    return "Hello world!";
  },
};

var app = express();
app.use(
  "/graphql",
  graphqlHTTP({
    schema: buildSchema(schema),
    rootValue: root,
    graphiql: true,
  })
);
app.listen(4000);
console.log("Running a GraphQL API server at http://localhost:4000/graphql");

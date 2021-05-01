const { Elm } = require('./dist/elm.compiled.js')

const path = require("path")
const https = require("https")
const { writeFile, mkdir } = require("fs").promises;
const axios = require("axios").create({
  httpsAgent: new https.Agent({
    rejectUnauthorized: false,
  }),
})

const query = `
  query IntrospectionQuery {
    __schema {
      queryType {
        name
      }
      mutationType {
        name
      }
      subscriptionType {
        name
      }
      types {
        ...FullType
      }
    }
  }
  fragment FullType on __Type {
    kind
    name
    description
    fields(includeDeprecated: true) {
      name
      description
      args {
        ...InputValue
      }
      type {
        ...TypeRef
      }
      isDeprecated
      deprecationReason
    }
    inputFields {
      ...InputValue
    }
    interfaces {
      ...TypeRef
    }
    enumValues(includeDeprecated: true) {
      name
      description
      isDeprecated
      deprecationReason
    }
    possibleTypes {
      ...TypeRef
    }
  }
  fragment InputValue on __InputValue {
    name
    description
    type {
      ...TypeRef
    }
    defaultValue
  }
  fragment TypeRef on __Type {
    kind
    name
    ofType {
      kind
      name
      ofType {
        kind
        name
        ofType {
          kind
          name
          ofType {
            kind
            name
            ofType {
              kind
              name
              ofType {
                kind
                name
                ofType {
                  kind
                  name
                }
              }
            }
          }
        }
      }
    }
  }
`

axios
    .post("https://api.blissfully.com/prod/graphql", { query })
    .then((res) => res.data)
    .then((json) => {
      console.log({json})

      const app = Elm.Worker.init({
        flags: {
          schemaJson: json
        }
      })

      app.ports.writeElmFile.subscribe(async ({moduleName, contents}) => {
        const elmFileName = `./output/elm/${moduleName.replace(/\./g, "/")}.elm`;
        await mkdir(path.dirname(elmFileName), { recursive: true });
        await writeFile(elmFileName, contents);
      })
    })



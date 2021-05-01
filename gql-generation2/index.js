const { Elm } = require('./dist/elm.compiled.js')
const args = process.argv.slice(2)

const app = Elm.Worker.init({
  flags: {
    message: args[0] || 'Hello!'
  }
})

app.ports.outgoing.subscribe(data => console.log('Elm says', data))
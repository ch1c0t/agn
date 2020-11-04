exports.runServerTests = ->
  Promise.resolve true

runClientTests = ->
  require './client.test.coffee'

  for test in tests
    try
      server = await startServer()

      await test.fn()
      console.log '✅', test.name

      await stopServer server
    catch error
      console.log '❌', test.name
      console.log error.stack

startServer = ->
  { fork } = require 'child_process'
  server = fork './test/client/stub_server.coffee'

  new Promise (resolve) ->
    server.on 'message', (data) ->
      if data is 'ready'
        resolve server
      else
        console.log "Received unexpected #{data} from the child."


stopServer = (server) ->
  process.kill server.pid

  new Promise (resolve) ->
    server.on 'close', ->
      console.log "Child has exited."
      resolve()

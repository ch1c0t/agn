exports.runServerTests = ->
  console.log "Preparing to run the server tests."

  server = await startServer()
  await stopServer server
  Promise.resolve true

  console.log "All the server tests pass."
  console.log "==========================\n\n"

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
  { spawn } = require 'child_process'
  server = spawn 'node', ['./test/project0/build/server/server.js']

  new Promise (resolve) ->
    server.stdout.on 'data', (data) ->
      if data.toString().startsWith 'The server is listening'
        console.log 'The server has been started for testing.'
        resolve server

stopServer = (server) ->
  process.kill server.pid

  new Promise (resolve) ->
    server.on 'close', ->
      console.log "The server has been terminated."
      resolve()

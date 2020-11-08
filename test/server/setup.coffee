exports.runServerTests = ->
  console.log "Preparing to run the server tests."

  server = await startServer()

  require './server.test.coffee'
  for test in tests
    try
      await test.fn()
      console.log '✅', test.name
    catch error
      console.log '❌', test.name
      console.log error

  await stopServer server

  console.log "All the server tests pass."
  console.log "==========================\n\n"

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

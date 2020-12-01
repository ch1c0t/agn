exports.runIntegrationTests = ->
  console.log "Preparing to run the integration tests."
  console.log()


  server = await startServer
    project: 'project_with_auth'
    port: 8081

  require "./auth.test.coffee"

  for test in tests
    try
      await test.fn()
      console.log '  ✅', test.name
    catch error
      console.log '  ❌', test.name
      console.log error

  global.tests = []
  await stopServer server
  console.log()

  console.log "The integration testing is over."
  console.log "================================\n\n"

startServer = ({ project, port }) ->
  { spawn } = require 'child_process'

  env = { ...process.env, PORT: port }
  server = spawn 'node', ["#{PROJECTS_DIR}/#{project}/build/server/server.js"], { env }

  server.stderr.pipe process.stderr

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

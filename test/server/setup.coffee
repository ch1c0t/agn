exports.runServerTests = ->
  console.log "Preparing to run the server tests."
  console.log()

  for project in TEST_PROJECTS
    console.log "#{project}:"
    server = await startServer project
    require "./#{project}.test.coffee"

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

  console.log "All the server tests pass."
  console.log "==========================\n\n"

startServer = (project) ->
  { spawn } = require 'child_process'
  server = spawn 'node', ["#{PROJECTS_DIR}/#{project}/build/server/server.js"]

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

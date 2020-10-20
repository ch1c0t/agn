test 'in first', ->
  eq 0, 0

child = no

startServer = ->
  { fork } = require 'child_process'
  console.log "The parent's pid is #{process.pid}"
  child = fork './test/server.coffee'
  console.log "The child's pid is #{child.pid}"

  new Promise (resolve) ->
    child.on 'message', (data) ->
      if data is 'ready'
        resolve()
      else
        console.log "Received unexpected #{data} from the child."


stopServer = ->
  new Promise (resolve) ->
    child.on 'close', ->
      console.log "Child has exited."
      resolve()

test 'client', ->
  await startServer()

  client = require './project0/build/client'
  console.log client
  
  await client.getMailboxes()

  process.kill child.pid
  await stopServer()

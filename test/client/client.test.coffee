test 'in first', ->
  eq 0, 0

test 'client', ->
  client = require '../project0/build/client'
  console.log client
  
  await client.getMailboxes()

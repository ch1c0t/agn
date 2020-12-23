client = require '../projects/project0/dist/client'
console.log client
console.log()
  
test 'getMailboxes: happy path', ->
  mailboxes = await client.getMailboxes()

  a =
    name: 'A'
    path: '/a'

  b =
    name: 'B'
    path: '/b'

  expected = [a, b]
  eq mailboxes, expected

test 'sendMessage: happy path', ->
  isSent = await client.sendMessage
    to: 'alice@email'
    from: 'bob@email'
    subject: 'Subject'
    text: 'Body'

  eq isSent, true

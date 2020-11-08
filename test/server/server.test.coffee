axios = require 'axios'
HTTP = axios.create
  baseURL: 'http://127.0.0.1:8080'
  
test 'getMailboxes: happy path', ->
  response = await HTTP.post '/',
    fn: 'getMailboxes'

  a =
    name: 'm0'
    path: '/m0'

  b =
    name: 'm1'
    path: '/m1'

  expected = [a, b]
  
  eq response.status, 200
  eq response.data, { out: expected }

test 'sendMessage: happy path', ->
  response = await HTTP.post '/',
    fn: 'sendMessage'
    in:
      to: 'alice@email'
      from: 'bob@email'
      subject: 'Subject'
      text: 'Body'

  eq response.status, 200
  eq response.data, { out: true }

test 'bad request: if the function is not defined', ->
  checkResponse = (response) ->
    eq response.status, 400
    eq response.data, ''

  try
    response = await HTTP.post '/', fn: 'getMalboxes'
    checkResponse response
  catch error
    checkResponse error.response

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


{ fail, AssertionError } = require('assert').strict

expectBadRequest = (fn) ->
  try
    response = await fn()
    console.log()
    console.log response
    fail "an expected exception was not thrown"
  catch error
    throw error if error instanceof AssertionError

    response = error.response
    eq response.status, 400
    eq response.data, ''

test 'bad request: if the function is not defined', ->
  expectBadRequest ->
    HTTP.post '/', fn: 'getMalboxes'

test 'bad request: if the input is bad', ->
  expectBadRequest ->
    HTTP.post '/',
      fn: 'sendMessage'
      in: 'bad input'

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

test 'getNumber: happy path', ->
  response = await HTTP.post '/', fn: 'getNumber'

  eq response.status, 200
  eq response.data, { out: 42 }

test 'addOne: happy path', ->
  response = await HTTP.post '/', fn: 'addOne', in: 2

  eq response.status, 200
  eq response.data, { out: 3 }


{ expectBadRequest } = require './common'

test 'bad request: if the function is not defined', ->
  expectBadRequest status: 400, ->
    HTTP.post '/', fn: 'someNotDefinedName'

test 'bad request: if the input is bad', ->
  expectBadRequest status: 400, ->
    HTTP.post '/',
      fn: 'sendMessage'
      in: 'bad input'

test 'bad request: when String was passed instead of Number', ->
  expectBadRequest status: 400, ->
    HTTP.post '/',
      fn: 'addOne'
      in: '2'

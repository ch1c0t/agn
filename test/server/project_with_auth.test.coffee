axios = require 'axios'

{ expectBadRequest } = require './common'

test 'getProtected: should fail without a token', ->
  client = axios.create
    baseURL: 'http://127.0.0.1:8080'

  expectBadRequest status: 403, ->
    client.post '/', fn: 'getProtected'

test 'getProtected: should fail with an invalid token', ->
  client = axios.create
    baseURL: 'http://127.0.0.1:8080'
    headers:
      Authorization: "Bearer InvalidToken"

  expectBadRequest status: 403, ->
    client.post '/', fn: 'getProtected'

test 'getProtected: should return the number with a valid token', ->
  client = axios.create
    baseURL: 'http://127.0.0.1:8080'
    headers:
      Authorization: "Bearer ValidToken"

  response = await client.post '/', fn: 'getProtected'

  eq response.status, 200
  eq response.data, { out: 42 }

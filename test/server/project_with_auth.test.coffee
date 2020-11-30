axios = require 'axios'
HTTP = axios.create
  baseURL: 'http://127.0.0.1:8080'

{ expectBadRequest } = require './common'

test 'getProtected: should fail without a token', ->
  expectBadRequest status: 403, ->
    HTTP.post '/', fn: 'getProtected'

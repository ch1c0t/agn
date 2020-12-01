axios = require 'axios'

test 'the server is up', ->
  client = axios.create
    baseURL: 'http://127.0.0.1:8081'
    headers:
      Authorization: "Bearer ValidToken"

  response = await client.post '/', fn: 'getProtected'

  eq response.status, 200
  eq response.data, { out: 42 }

test 'the client is capable', ->
  client = require '../projects/project_with_auth/build/client'
  console.log client

  { getProtected, SET_ADDRESS, SET_TOKEN } = client
  SET_ADDRESS 'http://127.0.0.1:8081'
  SET_TOKEN 'ValidToken'
  
  number = await getProtected()
  eq number, 42

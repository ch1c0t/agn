axios = require 'axios'
HTTP = axios.create
  baseURL: 'http://127.0.0.1:8080'

test 'getHash: happy path', ->
  response = await HTTP.post '/',
    fn: 'getHash'

  eq response.status, 200
  eq response.data, { out: 'ks/Os51X2RTtixTQ43ZD3geXrlY=' }

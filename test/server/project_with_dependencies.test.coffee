axios = require 'axios'
HTTP = axios.create
  baseURL: 'http://127.0.0.1:8080'

test 'getHash: happy path', ->
  response = await HTTP.post '/',
    fn: 'getHash'

  eq response.status, 200
  eq response.data, { out: 'ks/Os51X2RTtixTQ43ZD3geXrlY=' }

fs = require 'fs'
test 'package.json', ->
  json = JSON.parse fs.readFileSync './test/projects/project_with_dependencies/build/server/package.json', 'utf-8'

  eq json.name, 'project_with_dependencies'
  eq json.dependencies,
    fco: '0.0.1'

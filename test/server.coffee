http = require 'http'

host = '127.0.0.1'
port = 4000

listener = (request, response) ->
  response.writeHead 200
  response.end 'OK'

server = http.createServer listener

server.listen port, host, ->
  console.log "Server is running on http://#{host}:#{port}."
  process.send 'ready'

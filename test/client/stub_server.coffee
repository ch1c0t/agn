http = require 'http'

host = '127.0.0.1'
port = 8080

listener = (request, response) ->
  try
    unless request.headers['content-type'].startsWith 'application/json'
      throw 'bad request'

    unless request.method is 'POST'
      throw 'bad request'

    data = ''
    request.on 'data', (chunk) ->
      data += chunk
    request.on 'end', ->
      try
        message = JSON.parse data

        out = switch message.fn
          when 'getMailboxes'
            a =
              name: 'A'
              path: '/a'

            b =
              name: 'B'
              path: '/b'

            [a, b]
          when 'sendMessage'
            true

        response.setHeader 'Content-Type', 'application/json'
        response.statusCode = 200
        response.end JSON.stringify out: out
      catch error
        console.log error
        response.statusCode = 400
        response.end()

  catch error
    console.log error
    response.statusCode = 400
    response.end()

server = http.createServer listener

server.listen port, host, ->
  console.log "The stub server is running at http://#{host}:#{port}."
  process.send 'ready'

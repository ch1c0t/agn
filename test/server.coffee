http = require 'http'

host = '127.0.0.1'
port = 4000

listener = (request, response) ->
  try
    unless request.headers['content-type'].startsWith 'application/json'
      throw 'bad request'

    unless request.method is 'POST'
      throw 'bad request'

    unless request.url is '/api'
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
            53

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
  console.log "Server is running on http://#{host}:#{port}."
  process.send 'ready'

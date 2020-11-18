fs = require 'fs'
coffee = require 'coffeescript'

exports.createMainFile = ->
  catchBadRequest = """
    catch error
      console.log error
      response.statusCode = 400
      response.end()
  """

  requestEnd = =>
    """
    try
      message = JSON.parse data

      out = switch message.fn
    #{@api.whenCases.indent number: 4}
        else
          throw 'bad request'
      
      response.setHeader 'Content-Type', 'application/json'
      response.statusCode = 200
      response.end JSON.stringify out: out
    #{catchBadRequest}
    """

  listener = """
    (request, response) ->
      try
        unless request.method in ['POST', 'OPTIONS']
          throw 'bad request'

        response.setHeader 'Access-Control-Allow-Origin', '*'

        switch request.method
          when 'OPTIONS'
            response.setHeader 'Access-Control-Allow-Methods', 'POST, OPTIONS'
            response.setHeader 'Access-Control-Allow-Headers', 'Authorization, Content-Type'
            response.setHeader 'Access-Control-Max-Age', '86400'
            response.end()
          when 'POST'
            unless request.headers['content-type']?.startsWith 'application/json'
              throw 'bad request'

            data = ''
            request.on 'data', (chunk) ->
              data += chunk
            request.on 'end', ->
    #{requestEnd().indent number: 10}
    #{catchBadRequest.indent number: 2}
  """

  @CoffeeSource = """
    http = require 'http'

    server = http.createServer #{listener}

    PORT = process.env.PORT or 8080
    server.listen PORT, ->
      console.log "The server is listening."
  """

  @createMainFile = ->
    fs.writeFileSync "#{@dir}/server.coffee", @CoffeeSource
    fs.writeFileSync "#{@dir}/server.js", (coffee.compile @CoffeeSource)

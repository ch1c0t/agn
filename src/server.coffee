fs = require 'fs'

coffee = require 'coffeescript'

{ fun } = require './fun'
{ ensureDirExists } = require './util'

Api = ->
  { functions, types } = @

  @whenCases = (Object.keys functions)
    .map (fn) ->
      pre = "when '#{fn}'"

      body = if functions[fn].in
        "  await require('./#{fn}.js')(message.in)"
      else
        "  await require('./#{fn}.js')()"

      "#{pre}\n#{body}"
    .join "\n"

  @

Functions = ->

exports.Server = fun
  init:
    name: -> @
    api: Api
    functions: Functions
  once: ->
    @PackageContent = JSON.stringify
      name: "#{@name}.server"
    @createPackageFile = ->
      fs.writeFileSync "#{@dir}/package.json", @PackageContent

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

    @CoffeeContent = """
      http = require 'http'

      server = http.createServer #{listener}

      PORT = process.env.PORT or 8080
      server.listen PORT, ->
        console.log "The server is listening."
    """

    @createCoffeeFile = ->
      fs.writeFileSync "#{@dir}/server.coffee", @CoffeeContent

    @createJSFile = ->
      fs.writeFileSync "#{@dir}/server.js", (coffee.compile @CoffeeContent)

    @inside = (dir, fn) ->
      ensureDirExists dir

      copy = Object.assign {}, @
      copy.dir = dir

      fn.call copy

  call: ({ dir }) ->
    @inside dir, ->
      @createPackageFile()
      @createCoffeeFile()
      @createJSFile()

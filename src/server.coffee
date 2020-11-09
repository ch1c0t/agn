fs = require 'fs'

coffee = require 'coffeescript'

{ fun } = require './fun'
{ ensureDirExists } = require './util'
{ Validate } = require './validator'

Api = ->
  { functions, types } = @

  @createIfs = Validate types

  @whenCases = (Object.keys functions)
    .map (fn) ->
      pre = "when '#{fn}'"

      body = if functions[fn].in
        "  await require('./functions/#{fn}.js')(message.in)"
      else
        "  await require('./functions/#{fn}.js')()"

      "#{pre}\n#{body}"
    .join "\n"

  @

exports.Server = fun
  init:
    name: -> @
    api: Api
    functions: -> @
  once: ->
    @PackageSource = JSON.stringify
      name: "#{@name}.server"
    @createPackageFile = ->
      fs.writeFileSync "#{@dir}/package.json", @PackageSource


    @FnSource = {}
    for fn in (Object.keys @functions)
      input = @api.functions[fn].in

      fnSource = if input
        """
        module.exports = (input) ->
          validateInput input
          fn input

        fn = #{@functions[fn]}

        validateInput = (value) ->
          throw 'no value' unless value?

        #{@api.createIfs(type: input).indent()}
        """
      else
        """
        module.exports = ->
          fn()

        fn = #{@functions[fn]}
        """

      @FnSource[fn] = coffee.compile fnSource

    @createFnFiles = ->
      ensureDirExists "#{@dir}/functions"

      for fn in (Object.keys @functions)
        fs.writeFileSync "#{@dir}/functions/#{fn}.js", @FnSource[fn]



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


    @createServer = ->
      fs.writeFileSync "#{@dir}/server.coffee", @CoffeeSource
      fs.writeFileSync "#{@dir}/server.js", (coffee.compile @CoffeeSource)

    @inside = (dir, fn) ->
      ensureDirExists dir

      copy = Object.assign {}, @
      copy.dir = dir

      fn.call copy

  call: ({ dir }) ->
    @inside dir, ->
      @createPackageFile()
      @createFnFiles()
      @createServer()

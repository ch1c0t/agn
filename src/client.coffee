fs = require 'fs'

coffee = require 'coffeescript'

{ fun } = require './fun'
{ ensureDirExists } = require './util'
{ Validate } = require './validator'

Api = ->
  @createIfs = Validate @types
  @badResponse = 'the server responded with the status #{response.status}'
  @createValidation = ({ Of, fn, type }) ->
    badValue = '#{value}:#{typeof value} was received. Error: #{error.toString()}'

    """
    validate#{Of}Of_#{fn} = (value) ->
      try
        throw "no value" unless value?

    #{@createIfs({type}).indent(number: 4)}

      catch error
        throw new TypeError "#{fn} requires #{type} output, but #{badValue}."
    """

  @createFunctionWithInput = (name) ->
    """
    #{@createValidation(Of: "Input", fn: name, type: @functions[name].in)}

    #{@createValidation(Of: "Output", fn: name, type: @functions[name].out)}

    exports.#{name} = (input) ->
      validateInputOf_#{name} input

      response = await HTTP.post address,
        fn: '#{name}'
        in: input

      if response.status is 200
        output = response.data.out
        validateOutputOf_#{name} output
        output
      else
        throw "#{name}: #{@badResponse}."
    """

  @createFunctionWithoutInput = (name) ->
    """
    #{@createValidation(Of: "Output", fn: name, type: @functions[name].out)}

    exports.#{name} = ->
      response = await HTTP.post address, fn: '#{name}'

      if response.status is 200
        output = response.data.out
        validateOutputOf_#{name} output
        output
      else
        throw "#{name}: #{@badResponse}."
    """

  @createCoffeeSource = ->
    address = 'http://localhost:8080'

    functions = (Object.keys @functions).map (fn) =>
      if @functions[fn].in
        @createFunctionWithInput fn
      else
        @createFunctionWithoutInput fn

    """
      axios = require 'axios'

      address = '#{address}'
      HTTP = axios

      #{functions.join "\n\n"}
    """

  @

exports.Client = fun
  init:
    name: -> @
    api: Api
  once: ->
    @PackageSource = JSON.stringify
      name: "#{@name}.client"
      dependencies:
        axios: '*'
    @createPackageFile = ->
      fs.writeFileSync "#{@dir}/package.json", @PackageSource

    @CoffeeSource = @api.createCoffeeSource()

    @createIndexFile = ->
      fs.writeFileSync "#{@dir}/index.coffee", @CoffeeSource
      fs.writeFileSync "#{@dir}/index.js", (coffee.compile @CoffeeSource)

    @inside = (dir, fn) ->
      ensureDirExists dir

      copy = Object.assign {}, @
      copy.dir = dir

      fn.call copy

  call: ({ dir }) ->
    @inside dir, ->
      @createPackageFile()
      @createIndexFile()

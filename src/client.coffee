fs = require 'fs'

coffee = require 'coffeescript'

{ Validate } = require './validator'

root = ''
createIfs = ->

exports.createClient = (sources) ->
  createIfs = Validate sources.api.types

  createRootDirectory()
  createPackageFile sources.name
  createCoffeeFile sources.api
  createJSFile()

createRootDirectory = ->
  root = "#{process.cwd()}/build/client"
  fs.mkdirSync root
  
createPackageFile = (name) ->
  spec =
    name: "#{name}.client"
    dependencies:
      axios: '*'

  fs.writeFileSync "#{root}/package.json", (JSON.stringify spec)

createCoffeeFile = (api) ->
  address = 'http://localhost:8080'

  functions = (Object.keys api.functions).map (fn) ->
    if api.functions[fn].in
      createFunctionWithInput fn, api
    else
      createFunctionWithoutInput fn, api

  fs.writeFileSync "#{root}/index.coffee", """
    axios = require 'axios'

    address = '#{address}'
    HTTP = axios

    #{functions.join "\n\n"}
  """

createJSFile = ->
  source = coffee.compile fs.readFileSync "#{root}/index.coffee", 'utf-8'
  fs.writeFileSync "#{root}/index.js", source


badResponse = 'the server responded with the status #{response.status}'

createFunctionWithInput = (name, api) ->
  """
  #{createValidation(Of: "Input", fn: name, type: api.functions[name].in)}

  #{createValidation(Of: "Output", fn: name, type: api.functions[name].out)}

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
      throw "#{name}: #{badResponse}."
  """

createFunctionWithoutInput = (name, api) ->
  """
  #{createValidation(Of: "Output", fn: name, type: api.functions[name].out)}

  exports.#{name} = ->
    response = await HTTP.post address, fn: '#{name}'

    if response.status is 200
      output = response.data.out
      validateOutputOf_#{name} output
      output
    else
      throw "#{name}: #{badResponse}."
  """

createValidation = ({ Of, fn, type }) ->
  badValue = '#{value}:#{typeof value} was received. Error: #{error.toString()}'

  """
  validate#{Of}Of_#{fn} = (value) ->
    try
      throw "no value" unless value?

  #{createIfs({type}).indent(number: 4)}

    catch error
      throw new TypeError "#{fn} requires #{type} output, but #{badValue}."
  """

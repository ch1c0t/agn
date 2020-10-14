fs = require 'fs'

coffee = require 'coffeescript'

{ Validate } = require './validator'

root = ''
createIfs = ->

exports.createClient = (sources) ->
  createIfs = Validate sources.api.types

  createRootDirectory()
  createPackageFile sources.build
  createCoffeeFile sources
  createJSFile()

createRootDirectory = ->
  root = "#{process.cwd()}/build/client"
  fs.mkdirSync root
  
createPackageFile = ({ name }) ->
  spec =
    name: "#{name}.client"
    version: '0.0.0'
    dependencies:
      axios: 'latest'

  fs.writeFileSync "#{root}/package.json", (JSON.stringify spec)

createCoffeeFile = ({ build, api }) ->
  functions = (Object.keys api.functions).map (fn) ->
    if api.functions[fn].in
      createFunctionWithInput fn, api
    else
      createFunctionWithoutInput fn, api

  fs.writeFileSync "#{root}/index.coffee", """
    axios = require 'axios'

    address = '#{build.address}'
    HTTP = axios

    #{functions.join "\n\n"}
  """

createJSFile = ->
  source = coffee.compile fs.readFileSync "#{root}/index.coffee", 'utf-8'
  fs.writeFileSync "#{root}/index.js", source


badResponse = 'the server responded with the status #{response.status}'

createFunctionWithInput = (name, api) ->
  """
  #{create_validateInputOf name, api.functions[name].in}

  #{create_validateOutputOf name, api.functions[name].out}

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
  #{create_validateOutputOf name, api.functions[name].out}

  exports.#{name} = ->
    response = await HTTP.post address, fn: '#{name}'

    if response.status is 200
      output = response.data.out
      validateOutputOf_#{name} output
      output
    else
      throw "#{name}: #{badResponse}."
  """

badValue = '#{value}:#{typeof value} was received'

create_validateInputOf = (fn, type) ->
  """
  validateInputOf_#{fn} = (value) ->
    error = no

  #{createIfs({type}).indent()}

    if error
      throw new TypeError "#{fn} requires #{type} output, but #{badValue}."
  """

create_validateOutputOf = (fn, type) ->
  """
  validateOutputOf_#{fn} = (value) ->
    error = no

  #{createIfs({type}).indent()}

    if error
      throw new TypeError "#{fn} requires #{type} output, but #{badValue}."
  """

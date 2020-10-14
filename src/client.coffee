fs = require 'fs'

{ Validate } = require './validator'

root = no

exports.createClient = (sources) ->
  console.log 'from createCLient()'

  createRootDirectory()
  createPackageFile sources.build
  createCoffeeFile sources

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
      #createFunctionWithInput fn, api
    else
      createFunctionWithoutInput fn, api

  fs.writeFileSync "#{root}/index.coffee", """
    axios = require 'axios'

    address = #{build.address}
    HTTP = axios

    #{functions.join "\n\n"}
  """

createFunctionWithInput = (name, api) ->

createFunctionWithoutInput = (name, api) ->
  badResponse = 'the server responded with the status #{response.status}'

  """
  #{create_validateOutputOf name, api.functions[name].out, api.types}

  exports.#{name} = ->
    response = await HTTP.post address, fn: '#{name}'

    if response.status is 200
      output = response.data.out
      validateOutputOf_#{name} output
      output
    else
      throw "#{name}: #{badResponse}."
  """

create_validateOutputOf = (fn, type, types) ->
  badOutput = '#{value}:#{typeof value} was received'

  """
  validateOutputOf_#{fn} = (value) ->
    error = no

  #{Validate({types})({type}).indent()}

    if error
      throw new TypeError "#{fn} requires #{type} output, but #{badOutput}."
  """

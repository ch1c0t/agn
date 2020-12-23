fs = require 'fs'

CWD = process.cwd()
DIR = "/tmp/makeapi/path"

exports.create = (name) ->
  DIR = "#{CWD}/#{name}"

  if fs.existsSync DIR
    console.error "#{DIR} already exists."
    process.exit 1
  else
    fs.mkdirSync DIR
  
  spec =
    name: name
    version: '0.0.0'
    devDependencies:
      makeapi: '0.1.0'

  createPackageFile spec
  createApiYml()
  createFunctions()

createPackageFile = (spec) ->
  source = JSON.stringify spec, null, 2
  fs.writeFileSync "#{DIR}/package.json", source

createApiYml = ->
  spec =
    functions:
      getNumber:
        out: 'Number'

  fs.writeFileSync "#{DIR}/api.yml", (YAML.stringify spec)

createFunctions = ->
  fs.mkdirSync "#{DIR}/functions"

  source = """
    -> Promise.resolve 42
  """

  fs.writeFileSync "#{DIR}/functions/getNumber.coffee", source

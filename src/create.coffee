fs = require 'fs'
{ exec  } = require 'child_process'

YAML = require 'yaml'

CWD = process.cwd()
DIR = "/tmp/makeapi/path"

exports.create = (name) ->
  DIR = "#{CWD}/#{name}"

  if fs.existsSync DIR
    console.error "#{DIR} already exists."
    process.exit 1
  else
    console.log "Creating a new project inside of #{DIR}"
    fs.mkdirSync DIR
  
  spec =
    name: name
    version: '0.0.0'
    devDependencies:
      makeapi: '0.1.1'

  createPackageFile spec
  createApiYml()
  createFunctions()

  console.log "Running 'npm install'"
  exec 'npm install', cwd: DIR

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

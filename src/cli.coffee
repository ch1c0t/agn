fs = require 'fs'
path = require 'path'
YAML = require 'yaml'

require './ext'
{ createClient } = require './client'
{ Server } = require './server'

{ ensureDirExists } = require './util'

exports.run = ->
  [_node, _agn, command] = process.argv

  switch command
    when 'build'
      dir = "#{process.cwd()}/build"
      ensureDirExists dir

      sources = getSources()

      Server(sources)(dir: "#{dir}/server")

      createClient sources
    else
      printHelp()

getSources = ->
  cwd = process.cwd()
  name = path.basename cwd

  api = YAML.parse fs.readFileSync "#{cwd}/api.yml", 'utf-8'

  functions = {}
  for key in (Object.keys api.functions)
    functions[key] = fs.readFileSync "#{cwd}/functions/#{key}.coffee", 'utf-8'

  { name, api, functions }

printHelp = ->
  console.log 'printHelp'

fs = require 'fs'
YAML = require 'yaml'

require './ext'
{ createClient } = require './client'
{ Server } = require './server'

exports.run = ->
  [_node, _agn, command, path] = process.argv

  switch command
    when 'build'
      dir = "#{process.cwd()}/build"
      fs.mkdirSync dir unless fs.existsSync dir

      sources = getSources()

      Server(sources)(dir: "#{dir}/server")

      createClient sources
    else
      printHelp()

getSources = ->
  cwd = process.cwd()

  build = YAML.parse fs.readFileSync "#{cwd}/build.yml", 'utf-8'
  api = YAML.parse fs.readFileSync "#{cwd}/api.yml", 'utf-8'

  functions = {}
  for name in (Object.keys api.functions)
    functions[name] = fs.readFileSync "#{cwd}/functions/#{name}.coffee", 'utf-8'

  { build, api, functions }

printHelp = ->
  console.log 'printHelp'

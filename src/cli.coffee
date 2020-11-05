fs = require 'fs'
YAML = require 'yaml'

require './ext'
{ createClient } = require './client'
{ Server } = require './server'

exports.run = ->
  [_node, _agn, command, file] = process.argv

  switch command
    when 'build'
      dir = "#{process.cwd()}/build"
      ensureDirExists dir

      file ?= 'api.yml'
      sources = getSources file

      Server(sources)(dir: "#{dir}/server")

      createClient sources
    else
      printHelp()

getSources = (file) ->
  name = file.split('.')[0]

  cwd = process.cwd()
  api = YAML.parse fs.readFileSync "#{cwd}/#{file}", 'utf-8'

  functions = {}
  for key in (Object.keys api.functions)
    functions[key] = fs.readFileSync "#{cwd}/functions/#{key}.coffee", 'utf-8'

  { name, api, functions }

ensureDirExists = (dir) ->
  fs.mkdirSync dir unless fs.existsSync dir

printHelp = ->
  console.log 'printHelp'

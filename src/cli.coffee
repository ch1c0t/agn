fs = require 'fs'
YAML = require 'yaml'

require './ext'
{ createClient } = require './client'
{ createServer } = require './server'

exports.run = ->
  dir = "#{process.cwd()}/build"
  fs.mkdirSync dir unless fs.existsSync dir

  sources = getSources()
  createClient sources
  # createServer sources

getSources = ->
  cwd = process.cwd()

  build = YAML.parse fs.readFileSync "#{cwd}/build.yml", 'utf-8'
  api = YAML.parse fs.readFileSync "#{cwd}/api.yml", 'utf-8'

  functions = {}
  for name in (Object.keys api.functions)
    functions[name] = fs.readFileSync "#{cwd}/functions/#{name}.coffee", 'utf-8'

  { build, api, functions }

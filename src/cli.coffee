fs = require 'fs'
path = require 'path'

YAML = require 'yaml'
chokidar = require 'chokidar'
nodemon = require 'nodemon'

require './ext'
{ Client } = require './client'
{ Server } = require './server'
{ ensureDirExists } = require './util'

cwd = process.cwd()

exports.run = ->
  [_node, _agn, command] = process.argv

  switch command
    when 'build'
      build()
    when 'watch'
      watch()
    else
      printHelp()

build = ->
  dir = "#{cwd}/build"
  ensureDirExists dir

  sources = getSources()

  Server(sources)("#{dir}/server")
  Client(sources)("#{dir}/client")

watch = ->
  build()

  watcher = chokidar.watch ['api.yml', 'functions/**/*.coffee'],
    persistent: true
    ignoreInitial: true

  watcher
    .on 'all', (event, path) ->
      console.log event, path
      build()

  nodemon(script: 'build/server/server.js')
    .on 'start', ->
      console.log 'nodemon started'
    .on 'quit', ->
      console.log 'nodemon quit'
    .on 'restart', (files) ->
      console.log "The server restarted due to: #{files}"

getSources = ->
  name = path.basename cwd

  api = YAML.parse fs.readFileSync "#{cwd}/api.yml", 'utf-8'

  functions = {}
  for key in (Object.keys api.functions)
    functions[key] = fs.readFileSync "#{cwd}/functions/#{key}.coffee", 'utf-8'

  { name, api, functions }

printHelp = ->
  console.log 'printHelp'

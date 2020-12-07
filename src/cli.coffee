fs = require 'fs'
path = require 'path'

YAML = require 'yaml'
chokidar = require 'chokidar'
nodemon = require 'nodemon'

require './ext'
{ Client } = require './client'
{ Server } = require './server'
{ ensureDirExists, isNotEqual } = require './util'

CWD = process.cwd()
SOURCES = {}

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
  dir = "#{CWD}/build"
  ensureDirExists dir

  SOURCES = getSources()

  Server(SOURCES)("#{dir}/server")
  Client(SOURCES)("#{dir}/client")

watch = ->
  build()

  watcher = chokidar.watch ['api.yml', 'functions/**/*.coffee', 'package.json'],
    persistent: true
    ignoreInitial: true

  watcher
    .on 'all', (event, path) ->
      console.log event, path
      build()

  nodemon script: 'build/server/server.js'

getSources = ->
  name = path.basename CWD

  api = YAML.parse fs.readFileSync "#{CWD}/api.yml", 'utf-8'

  functions = {}
  for key in (Object.keys api.functions)
    functions[key] = fs.readFileSync "#{CWD}/functions/#{key}.coffee", 'utf-8'

  verify = "#{CWD}/auth/verifyToken.coffee"
  if fs.existsSync verify
    auth = fs.readFileSync verify, 'utf-8'

  { name, api, functions, auth }

printHelp = ->
  console.log 'printHelp'

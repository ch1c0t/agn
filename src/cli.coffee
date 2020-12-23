fs = require 'fs'
path = require 'path'

YAML = require 'yaml'
chokidar = require 'chokidar'
nodemon = require 'nodemon'

require './ext'
{ Client } = require './client'
{ Server } = require './server'
{ ensureDirExists, isNotEqual } = require './util'
{ create } = require './create'

CWD = process.cwd()
SOURCES = {}

exports.run = ->
  [_node, _agn, command] = process.argv

  switch command
    when 'build'
      build()
    when 'watch'
      watch()
    when 'new'
      name = process.argv[3]
      create name
    when 'help'
      printHelp()
    else
      printHelp()

build = ->
  dir = "#{CWD}/dist"
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

  nodemon script: 'dist/server/server.js'

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
  console.log """
    A tool for API development

      new project_name    Create the directory named "project_name" and a new project inside of it.
      build               Build the project inside of the dist directory.
      watch               Watch for changes and rebuild the project continuously.
      help                Show this message.
  """

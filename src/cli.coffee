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
PREVIOUS_DEPENDENCIES = {}

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
  chokidar
    .watch('build/server/package.json')
    .on 'change', installPackagesIfNeeded

  build()
  PREVIOUS_DEPENDENCIES = SOURCES.api.server?.dependencies
  installPackages()

  watcher = chokidar.watch ['api.yml', 'functions/**/*.coffee'],
    persistent: true
    ignoreInitial: true

  watcher
    .on 'all', (event, path) ->
      console.log event, path
      build()

  nodemon script: 'build/server/server.js'

{ exec } = require 'child_process'
installPackages = ->
  console.log 'installPackages'
  exec 'npm install',
    cwd: "#{CWD}/build/server"

installPackagesIfNeeded = (path) ->
  console.log 'change', path
  
  if currentDependencies = SOURCES.api.server?.dependencies
    if isNotEqual currentDependencies, PREVIOUS_DEPENDENCIES
      installPackages()
      PREVIOUS_DEPENDENCIES = currentDependencies

getSources = ->
  name = path.basename CWD

  api = YAML.parse fs.readFileSync "#{CWD}/api.yml", 'utf-8'

  functions = {}
  for key in (Object.keys api.functions)
    functions[key] = fs.readFileSync "#{CWD}/functions/#{key}.coffee", 'utf-8'

  { name, api, functions }

printHelp = ->
  console.log 'printHelp'

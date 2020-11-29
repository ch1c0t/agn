fs = require 'fs'
path = require 'path'

YAML = require 'yaml'
chokidar = require 'chokidar'
nodemon = require 'nodemon'

require './ext'
{ Client } = require './client'
{ Server } = require './server'
{ ensureDirExists, isNotEqual } = require './util'

cwd = process.cwd()
sources = {}

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
  chokidar
    .watch('build/server/package.json')
    .on 'change', installPackagesIfNeeded

  build()
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
    cwd: "#{process.cwd()}/build/server"

installPackagesIfNeeded = (path) ->
  console.log 'change', path
  { dependencies } = JSON.parse fs.readFileSync "#{cwd}/#{path}", 'utf-8'
  
  console.log dependencies
  console.log sources.api.server?.dependencies

  if newDependencies = sources.api.server?.dependencies
    if isNotEqual newDependencies, dependencies
      installPackages()

getSources = ->
  name = path.basename cwd

  api = YAML.parse fs.readFileSync "#{cwd}/api.yml", 'utf-8'

  functions = {}
  for key in (Object.keys api.functions)
    functions[key] = fs.readFileSync "#{cwd}/functions/#{key}.coffee", 'utf-8'

  { name, api, functions }

printHelp = ->
  console.log 'printHelp'

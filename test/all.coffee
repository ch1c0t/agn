before = ->
  original = process.cwd()
  testProject = "#{process.cwd()}/test/project0"
  process.chdir testProject

  console.log "Preparing to build the test project at #{testProject}"
  
  { spawn } = require 'child_process'
  new Promise (resolve, reject) ->
    child = spawn '../../bin/agn', ['build']
    process.chdir original

    child.stderr.pipe process.stderr
    child.on 'exit', resolve
    child.on 'error', reject

after = ->
  { rmdirSync } = require 'fs'
  rmdirSync "#{process.cwd()}/test/project0/build", recursive: true

# https://stackoverflow.com/questions/14031763/doing-a-cleanup-action-just-before-node-js-exits/14032965#14032965
[
  'exit'
  'SIGINT'
  'SIGUSR1'
  'SIGUSR2'
  'uncaughtException'
  'SIGTERM'
].forEach (signal) ->
  process.on signal, after


global.tests = []

test = (name, fn) ->
  tests.push { name, fn }

global.test = test

{ deepEqual } = require('assert').strict
global.eq = deepEqual

run = ->
  await before()

  #glob = require 'glob'
  #files = glob.sync "#{process.cwd()}/test/**/*.test.coffee"
  #files.forEach require
  
  { runServerTests } = require './server/setup.coffee'
  await runServerTests()
  global.tests = []

  { runClientTests } = require './client/setup.coffee'
  await runClientTests()

run()

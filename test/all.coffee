before = ->
  original = process.cwd()
  testProject = "#{process.cwd()}/test/projects/project0"
  process.chdir testProject

  console.log "Preparing to build the test project at #{testProject}"
  
  { spawn } = require 'child_process'
  new Promise (resolve, reject) ->
    child = spawn '../../../bin/agn', ['build']
    process.chdir original

    child.stderr.pipe process.stderr
    child.on 'exit', resolve
    child.on 'error', reject

require './setup/after.coffee'
require './setup/global.coffee'

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

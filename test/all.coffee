require './setup/global.coffee'
require './setup/after.coffee'
{ before } = require './setup/before.coffee'

run = ->
  await before()

  #glob = require 'glob'
  #files = glob.sync "#{process.cwd()}/test/**/*.test.coffee"
  #files.forEach require
  
  { runServerTests } = require './server/setup.coffee'
  await runServerTests()

  { runClientTests } = require './client/setup.coffee'
  await runClientTests()

  { runIntegrationTests } = require './integration/setup.coffee'
  await runIntegrationTests()

run()

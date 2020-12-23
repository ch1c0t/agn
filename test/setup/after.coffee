{ rmdirSync, existsSync } = require 'fs'

deleteBuildIfExists = (name) ->
  path = "#{PROJECTS_DIR}/#{name}/dist"
  if existsSync path
    rmdirSync path, recursive: true

after = ->
  for name in TEST_PROJECTS
    deleteBuildIfExists name

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

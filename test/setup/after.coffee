after = ->
  { rmdirSync } = require 'fs'
  rmdirSync "#{process.cwd()}/test/projects/project0/build", recursive: true

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

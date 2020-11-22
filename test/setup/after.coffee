{ readdirSync, rmdirSync, existsSync } = require 'fs'

getDirectoriesWithin = (directory) ->
  readdirSync directory, withFileTypes: yes
    .filter (dirent) -> dirent.isDirectory()
    .map (dirent) -> dirent.name

deleteBuildIfExists = (name) ->
  path = "#{PROJECTS_DIR}/#{name}/build"
  if existsSync path
    rmdirSync path, recursive: true

after = ->
  for name in (getDirectoriesWithin PROJECTS_DIR)
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

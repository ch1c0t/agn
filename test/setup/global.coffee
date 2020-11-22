{ readdirSync } = require 'fs'

getDirectoriesWithin = (directory) ->
  readdirSync directory, withFileTypes: yes
    .filter (dirent) -> dirent.isDirectory()
    .map (dirent) -> dirent.name

global.PROJECTS_DIR = "#{process.cwd()}/test/projects"
global.TEST_PROJECTS = getDirectoriesWithin PROJECTS_DIR


global.tests = []

global.test = (name, fn) ->
  tests.push { name, fn }

{ deepEqual } = require('assert').strict
global.eq = deepEqual

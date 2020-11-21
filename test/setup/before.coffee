exports.before = ->
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

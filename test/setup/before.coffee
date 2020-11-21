exports.before = ->
  testProject = "#{process.cwd()}/test/projects/project0"
  console.log "Preparing to build the test project at #{testProject}"
  
  { exec } = require 'child_process'
  new Promise (resolve, reject) ->
    child = exec '../../../bin/agn build',
      cwd: testProject

    child.stderr.pipe process.stderr
    child.on 'exit', resolve
    child.on 'error', reject

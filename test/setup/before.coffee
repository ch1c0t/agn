{ exec } = require 'child_process'

exports.before = ->
  console.log "Preparing to build the test projects at #{PROJECTS_DIR}"

  promises = for project in TEST_PROJECTS
    build project

  await Promise.all promises

  console.log "All the projects were built successfully."
  console.log()

build = (project) ->
  path = "#{PROJECTS_DIR}/#{project}"

  new Promise (resolve, reject) ->
    child = exec '../../../bin/makeapi build',
      cwd: path

    child.stderr.pipe process.stderr
    child.on 'exit', resolve
    child.on 'error', reject

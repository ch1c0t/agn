{ exec } = require 'child_process'

projects = [
  'project0'
  'project_with_dependencies'
]

exports.before = ->
  console.log "Preparing to build the test projects at #{PROJECTS_DIR}"

  promises = for project in projects
    build project

  await Promise.all promises

  console.log "All the projects were built successfully."
  console.log()

build = (project) ->
  path = "#{PROJECTS_DIR}/#{project}"

  new Promise (resolve, reject) ->
    child = exec '../../../bin/agn build',
      cwd: path

    child.stderr.pipe process.stderr
    child.on 'exit', resolve
    child.on 'error', reject

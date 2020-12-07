{ Creator } = require './creator'
{ createMainFile } = require './server/main'
{ parseEntities, createFnFiles } = require './server/functions'
{ auth } = require './server/auth'

exports.Server = Creator
  init:
    name: -> @
    api: -> @
    functions: parseEntities
    auth: auth
  once: ->
    @embed [
      createMainFile
      createFnFiles
    ]

  call: (dir) ->
    @inside dir, ->
      @createMainFile()
      @createFnFiles()

    console.log "Building the server at #{dir}."

{ Creator } = require './creator'
{ createPackageFile } = require './server/package'
{ createMainFile } = require './server/main'
{ parseEntities, createFnFiles } = require './server/functions'

exports.Server = Creator
  init:
    name: -> @
    api: -> @
    functions: parseEntities
  once: ->
    @embed [
      createPackageFile
      createMainFile
      createFnFiles
    ]

  call: (dir) ->
    @inside dir, ->
      @createPackageFile()
      @createMainFile()
      @createFnFiles()

    console.log "Building the server at #{dir}."

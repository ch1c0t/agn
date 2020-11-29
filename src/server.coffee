{ Generator } = require './generator'
{ createPackageFile } = require './server/package'
{ createMainFile } = require './server/main'
{ parseEntities, createFnFiles } = require './server/functions'

exports.Server = Generator
  init:
    name: -> @
    api: -> @
    functions: parseEntities
  once: ->
    createPackageFile.call @
    createMainFile.call @
    createFnFiles.call @

  call: (dir) ->
    @inside dir, ->
      @createPackageFile()
      @createMainFile()
      @createFnFiles()

    console.log "Building the server at #{dir}."

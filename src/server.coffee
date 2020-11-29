{ Generator } = require './generator'
{ createPackageFile } = require './server/package'
{ createMainFile } = require './server/main'
{ Fns, createFnFiles } = require './server/functions'

exports.Server = Generator
  init:
    name: -> @
    api: -> @
    functions: Fns
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

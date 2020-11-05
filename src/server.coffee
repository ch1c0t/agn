{ fun } = require './fun'

exports.Server = fun
  init:
    name: -> @
    api: Api
    functions: Functions
  once: ->
    @inside = (dir) ->
      unsureDirExists dir

      copy = clone @
      copy.dir = dir
      copy

  call: ({ dir }) ->
    @inside(dir)
      .createPackageFile()
      .createCoffeeFile()
      .createJSFile()

Api = ->
  { functions, types } = @

Functions = ->

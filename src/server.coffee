fs = require 'fs'

{ fun } = require './fun'
{ ensureDirExists } = require './util'

Api = ->
  { functions, types } = @

Functions = ->

exports.Server = fun
  init:
    name: -> @
    api: Api
    functions: Functions
  once: ->
    @PackageContent = JSON.stringify
      name: "#{@name}.server"

    @createPackageFile = ->
      fs.writeFileSync "#{@dir}/package.json", @PackageContent

    @createCoffeeFile = ->
      console.log "from createCoffeeFile #{@dir}"

    @createJSFile = ->
      console.log "from createJSFile #{@dir}"

    @inside = (dir, fn) ->
      ensureDirExists dir

      copy = Object.assign {}, @
      copy.dir = dir

      fn.call copy

  call: ({ dir }) ->
    @inside dir, ->
      @createPackageFile()
      @createCoffeeFile()
      @createJSFile()

fs = require 'fs'

{ Generator } = require './generator'
{ Validate } = require './validator'
{ createMainFile } = require './server/main'
{ Fns, createFnFiles } = require './server/functions'

Api = ->
  { functions, types } = @

  @createIfs = Validate types

  @whenCases = (Object.keys functions)
    .map (fn) ->
      pre = "when '#{fn}'"

      body = if functions[fn].in
        "  await require('./functions/#{fn}.js')(message.in)"
      else
        "  await require('./functions/#{fn}.js')()"

      "#{pre}\n#{body}"
    .join "\n"

  @

exports.Server = Generator
  init:
    name: -> @
    api: Api
    functions: Fns
  once: ->
    @PackageSource = if @api.server?.dependencies
      JSON.stringify
        name: "#{@name}.server"
        dependencies: @api.server.dependencies
    else
      JSON.stringify
        name: "#{@name}.server"
    @createPackageFile = ->
      fs.writeFileSync "#{@dir}/package.json", @PackageSource

    createMainFile.call @
    createFnFiles.call @

  call: (dir) ->
    @inside dir, ->
      @createPackageFile()
      @createMainFile()
      @createFnFiles()

    console.log "Building the server at #{dir}."

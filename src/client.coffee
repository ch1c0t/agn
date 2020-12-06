fs = require 'fs'

coffee = require 'coffeescript'

{ Creator } = require './creator'
{ Api } = require './client/api'

exports.Client = Creator
  init:
    name: -> @
    api: Api
  once: ->
    @PackageSource = JSON.stringify
      name: "#{@name}.client"
      version: '0.0.0'
      dependencies:
        axios: '*'
    @createPackageFile = ->
      fs.writeFileSync "#{@dir}/package.json", @PackageSource

    @CoffeeSource = @api.createCoffeeSource()

    @createIndexFile = ->
      fs.writeFileSync "#{@dir}/index.coffee", @CoffeeSource
      fs.writeFileSync "#{@dir}/index.js", (coffee.compile @CoffeeSource)

  call: (dir) ->
    @inside dir, ->
      @createPackageFile()
      @createIndexFile()

    console.log "Building the client at #{dir}."

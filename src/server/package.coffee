fs = require 'fs'

exports.createPackageFile = ->
  @PackageSource = if @api.server?.dependencies
    JSON.stringify
      name: "#{@name}.server"
      dependencies: @api.server.dependencies
  else
    JSON.stringify
      name: "#{@name}.server"

  @createPackageFile = ->
    fs.writeFileSync "#{@dir}/package.json", @PackageSource

fs = require 'fs'

exports.createPackageFile = ->
  @PackageSource = if dependencies = @api.server?.dependencies
    JSON.stringify { @name, dependencies }
  else
    JSON.stringify { @name }

  @createPackageFile = ->
    fs.writeFileSync "#{@dir}/package.json", @PackageSource

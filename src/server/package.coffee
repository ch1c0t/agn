fs = require 'fs'

exports.createPackageFile = ->
  spec = if dependencies = @api.server?.dependencies
    { @name, dependencies }
  else
    { @name }

  @PackageSource = JSON.stringify spec, null, 2

  @createPackageFile = ->
    fs.writeFileSync "#{@dir}/package.json", @PackageSource

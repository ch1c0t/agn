fs = require 'fs'

exports.createPackageFile = ->
  @PackageSource = if dependencies = @api.server?.dependencies
    JSON.stringify { @name, dependencies }
  else
    JSON.stringify { @name }

  @createPackageFile = ->
    file = "#{@dir}/package.json"

    if fs.existsSync file
      source = fs.readFileSync file, 'utf-8'
      if source is @PackageSource
        return # early to not trigger 'npm install' unless necessary

    fs.writeFileSync file, @PackageSource

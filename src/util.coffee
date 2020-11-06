fs = require 'fs'

exports.ensureDirExists = (dir) ->
  fs.mkdirSync dir unless fs.existsSync dir

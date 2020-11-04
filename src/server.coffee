{ fun } = require './fun'

exports.Server = fun
  init:
    api: -> @
    functions: -> @
  call: ({ dir }) ->
    console.log dir

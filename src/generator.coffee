{ fun } = require './fun'
{ ensureDirExists } = require './util'

state =
  inside: (dir, fn) ->
    ensureDirExists dir

    copy = { ...@ }
    copy.dir = dir

    fn.call copy

exports.Generator = (input) ->
  fun { ...input, state }

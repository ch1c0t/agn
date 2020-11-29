{ fun } = require './fun'
{ ensureDirExists } = require './util'

state =
  inside: (dir, fn) ->
    ensureDirExists dir

    copy = { ...@ }
    copy.dir = dir

    fn.call copy

  embed: (fns) ->
    for fn in fns
      fn.call @

exports.Creator = (input) ->
  fun { ...input, state }

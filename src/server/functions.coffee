fs = require 'fs'
coffee = require 'coffeescript'

{ ensureDirExists } = require '../util'
{ Validate } = require '../validator'

exports.parseEntities = ->
  for fn in (Object.keys @)
    lines = @[fn].split("\n").reverse()
    index = lines.findIndex (line) ->
      (line.startsWith '->') or (line.startsWith '(')
    index = index + 1

    beforeEntry = lines.slice(index).reverse().join("\n")
    entryFn = lines.slice(0, index).reverse().join("\n")

    @[fn] = { beforeEntry, entryFn }

  @

exports.createFnFiles = ->
  createIfs = Validate @api.types

  @FnSource = {}
  for fn in (Object.keys @functions)
    input = @api.functions[fn].in

    fnSource = if input
      """
      module.exports = (input) ->
        validateInput input
        fn input

      #{@functions[fn].beforeEntry}
      fn = #{@functions[fn].entryFn}

      validateInput = (value) ->
        throw 'no value' unless value?

      #{createIfs(type: input).indent()}
      """
    else
      """
      module.exports = ->
        fn()

      #{@functions[fn].beforeEntry}
      fn = #{@functions[fn].entryFn}
      """

    @FnSource[fn] = coffee.compile fnSource

  @createFnFiles = ->
    ensureDirExists "#{@dir}/functions"

    for fn in (Object.keys @functions)
      fs.writeFileSync "#{@dir}/functions/#{fn}.js", @FnSource[fn]

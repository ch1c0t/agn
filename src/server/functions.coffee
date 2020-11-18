fs = require 'fs'
coffee = require 'coffeescript'

{ ensureDirExists } = require '../util'

exports.createFnFiles = ->
  @FnSource = {}
  for fn in (Object.keys @functions)
    input = @api.functions[fn].in

    fnSource = if input
      """
      module.exports = (input) ->
        validateInput input
        fn input

      fn = #{@functions[fn]}

      validateInput = (value) ->
        throw 'no value' unless value?

      #{@api.createIfs(type: input).indent()}
      """
    else
      """
      module.exports = ->
        fn()

      fn = #{@functions[fn]}
      """

    @FnSource[fn] = coffee.compile fnSource

  @createFnFiles = ->
    ensureDirExists "#{@dir}/functions"

    for fn in (Object.keys @functions)
      fs.writeFileSync "#{@dir}/functions/#{fn}.js", @FnSource[fn]

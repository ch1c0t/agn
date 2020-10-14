{ fun } = require './lib/fun'

deploy = (asd) ->
  console.log "from deploy: #{asd}"
  asd + 1

wtf = ->
  @ + 2

Some = fun
  init:
    asd: wtf
  call: (number) ->
    @asd + number

exports.Some = Some

console.log Some(asd: 1)(1)
console.log Some(asd: 1)(10)
some = Some(asd: 2)
console.log Object.getOwnPropertyNames some

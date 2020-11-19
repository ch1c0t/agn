global.tests = []

global.test = (name, fn) ->
  tests.push { name, fn }

{ deepEqual } = require('assert').strict
global.eq = deepEqual

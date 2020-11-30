{ fail, AssertionError } = require('assert').strict

exports.expectBadRequest = ({ status }, fn) ->
  try
    response = await fn()

    console.log()
    console.log response
    fail "an expected error was not thrown"
  catch error
    throw error if error instanceof AssertionError

    response = error.response
    eq response.status, status
    eq response.data, ''

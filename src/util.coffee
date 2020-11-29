fs = require 'fs'

exports.ensureDirExists = (dir) ->
  fs.mkdirSync dir unless fs.existsSync dir

{ deepEqual } = require('assert').strict

isEqual = (a, b) ->
  try
    deepEqual a, b
    yes
  catch error
    if error.name is 'AssertionError'
      no
    else
      throw error

exports.isNotEqual = (a, b) ->
  !(isEqual a, b)

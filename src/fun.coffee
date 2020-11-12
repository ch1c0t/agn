exports.fun = ({ init, once, call, state }) ->
  (input) ->
    state ?= {}

    for key, fn of init
      state[key] = fn.call input[key]

    if once
      once.call state

    call.bind state

exports.fun = ({ init, call }) ->
  (input) ->
    state = {}

    for key, fn of init
      state[key] = fn.call input[key]

    call.bind state

test 'in second', ->
  eq 0, 0

test 'deep', ->
  o1 =
    a:
      n: 0

  o2 =
    a:
      n: 1

  eq o1, o2

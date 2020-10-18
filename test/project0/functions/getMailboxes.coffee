module.exports = ->
  mailbox0 =
    name: 'm0'
    path: '/m0'

  mailbox1 =
    name: 'm1'
    path: '/m1'

  Promise.resolve [
    mailbox0
    mailbox1
  ]

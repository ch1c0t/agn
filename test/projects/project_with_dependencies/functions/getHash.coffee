{ createHash } = require 'crypto'

->
  Promise.resolve createHash('sha1').update('42').digest('base64')

exports.auth = ->
  if @['indent']
    define = """
      define_verifyToken = ->
      #{@.indent()}
      
      verifyToken = define_verifyToken()
    """

    check = """
      try
        token = request.headers['authorization'].split(' ')[1]
        verifyToken token
      catch error
        console.log error
        response.statusCode = 403
        response.end()
    """

    { define, check }

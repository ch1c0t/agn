// Generated by CoffeeScript 2.5.1
(function() {
  exports.auth = function() {
    var check, define;
    if (this['indent']) {
      define = `define_verifyToken = ->
${this.indent()}

verifyToken = define_verifyToken()`;
      check = `try
  token = request.headers['authorization'].split(' ')[1]
  verifyToken token
catch error
  console.log error
  response.statusCode = 403
  response.end()`;
      return {define, check};
    }
  };

}).call(this);
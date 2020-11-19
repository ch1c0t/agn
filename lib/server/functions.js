// Generated by CoffeeScript 2.5.1
(function() {
  var coffee, ensureDirExists, fs;

  fs = require('fs');

  coffee = require('coffeescript');

  ({ensureDirExists} = require('../util'));

  exports.createFnFiles = function() {
    var fn, fnSource, i, input, len, ref;
    this.FnSource = {};
    ref = Object.keys(this.functions);
    for (i = 0, len = ref.length; i < len; i++) {
      fn = ref[i];
      input = this.api.functions[fn].in;
      fnSource = input ? `module.exports = (input) ->
  validateInput input
  fn input

fn = ${this.functions[fn]}

validateInput = (value) ->
  throw 'no value' unless value?

${this.api.createIfs({
        type: input
      }).indent()}` : `module.exports = ->
  fn()

fn = ${this.functions[fn]}`;
      this.FnSource[fn] = coffee.compile(fnSource);
    }
    return this.createFnFiles = function() {
      var j, len1, ref1, results;
      ensureDirExists(`${this.dir}/functions`);
      ref1 = Object.keys(this.functions);
      results = [];
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        fn = ref1[j];
        results.push(fs.writeFileSync(`${this.dir}/functions/${fn}.js`, this.FnSource[fn]));
      }
      return results;
    };
  };

}).call(this);
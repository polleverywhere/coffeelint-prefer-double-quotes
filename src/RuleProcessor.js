(function() {
  var RuleProcessor;

  module.exports = RuleProcessor = (function() {
    RuleProcessor.prototype.rule = {
      name: "prefer_double_quotes",
      level: "ignore",
      message: "Prefer double quotes over single quotes",
      description: 'This rule prohibits single quotes unless the string\nincludes " or # characters.\n<pre>\n<code># Single quotes are discouraged:\nfoo = \'bar\'\n\n# Unless it would mean extra escaping:\nfoo = \'Use #{bar} to interpolate\'\n\n# Or they prevent cumbersome escaping:\nfoo = \'He said, "No." But I disagree.\'\n</code>\n</pre>'
    };

    function RuleProcessor() {
      this.regexps = [];
    }

    RuleProcessor.prototype.tokens = ["STRING"];

    RuleProcessor.prototype.lintToken = function(token, tokenApi) {
      var e, hasLegalConstructs, i, notInBlock, s, stringValue, tokenValue;
      tokenValue = token[1];
      i = tokenApi.i;
      stringValue = tokenValue.match(/^\'(.*)\'$/);
      if (this.regexps.length === 0) {
        this.regexps = this.getBlockRegExps(tokenApi);
      }
      notInBlock = ((function() {
        var _i, _len, _ref, _ref1, _results;
        _ref = this.regexps;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          _ref1 = _ref[_i], s = _ref1[0], e = _ref1[1];
          if ((s < i && i < e)) {
            _results.push(1);
          }
        }
        return _results;
      }).call(this)).length === 0;
      if (!(stringValue && notInBlock)) {
        return false;
      }
      hasLegalConstructs = this.containsDoubleQuote(tokenValue) || this.containsHash(tokenValue);
      return !hasLegalConstructs;
    };

    RuleProcessor.prototype.getBlockRegExps = function(tokenApi) {
      var callEnds, col, curTok, i, idx, ii, lin, lines, regexps, t, tokens, _i, _j, _len, _len1, _ref;
      lines = tokenApi.lines, tokens = tokenApi.tokens;
      regexps = [];
      for (i = _i = 0, _len = tokens.length; _i < _len; i = ++_i) {
        t = tokens[i];
        if (!(t[0] === 'IDENTIFIER' && t[1] === 'RegExp')) {
          continue;
        }
        _ref = t[2], lin = _ref.first_line, col = _ref.first_column;
        if (lines[lin].slice(col, +(col + 2) + 1 || 9e9) === "///") {
          regexps.push([i, 0]);
        }
      }
      for (idx = _j = 0, _len1 = regexps.length; _j < _len1; idx = ++_j) {
        i = regexps[idx][0];
        ii = 2;
        callEnds = 1;
        while (callEnds > 0 && (curTok = tokens[i + ii][0])) {
          if (curTok === 'CALL_END') {
            callEnds--;
          }
          if (curTok === 'CALL_START') {
            callEnds++;
          }
          ii++;
        }
        regexps[idx][1] = i + ii - 1;
      }
      return regexps;
    };

    RuleProcessor.prototype.containsDoubleQuote = function(tokenValue) {
      return tokenValue.indexOf('"') !== -1;
    };

    RuleProcessor.prototype.containsHash = function(tokenValue) {
      return tokenValue.indexOf("#") !== -1;
    };

    return RuleProcessor;

  })();

}).call(this);

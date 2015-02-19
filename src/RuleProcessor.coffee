module.exports = class RuleProcessor
  rule:
    name: "prefer_double_quotes"
    level: "ignore"
    message: "Prefer double quotes over single quotes"
    description: '''
      This rule prohibits single quotes unless the string
      includes " or # characters.
      <pre>
      <code># Single quotes are discouraged:
      foo = 'bar'

      # Unless it would mean extra escaping:
      foo = 'Use #{bar} to interpolate'

      # Or they prevent cumbersome escaping:
      foo = 'He said, "No." But I disagree.'
      </code>
      </pre>
      '''
  constructor: ->
    @regexps = []

  tokens: ["STRING"]

  lintToken: (token, tokenApi) ->
    tokenValue = token[1]

    i = tokenApi.i

    stringValue = tokenValue.match(/^\'(.*)\'$/)

    # Upon seeing first regexp, create cache of regexp locations
    @regexps = @getBlockRegExps(tokenApi) if @regexps.length == 0
    notInBlock = (1 for [s, e] in @regexps when s < i < e).length == 0
    # no single quotes, all OK
    return false unless stringValue && notInBlock

    hasLegalConstructs = @containsDoubleQuote(tokenValue) ||
      @containsHash(tokenValue)

    return !hasLegalConstructs

  getBlockRegExps: (tokenApi) ->
    { lines, tokens } = tokenApi
    regexps = []
    # Only add regexps that are from the block regexp shorthand and not
    # from ones where the user actually uses the `RegExp` function.
    for t, i in tokens when t[0] is 'IDENTIFIER' and t[1] is 'RegExp'
      { first_line: lin, first_column: col } = t[2]
      if lines[lin][col..(col + 2)] is "///"
        regexps.push([i, 0])

    # Find where the regexp calls end, anything inbetween these tokens
    # we will ignore any double-quotes.
    for [i], idx in regexps
      ii = 2
      callEnds = 1
      # Handle function calls inside of regexp
      while (callEnds > 0 and curTok = tokens[i + ii][0])
        callEnds-- if curTok is 'CALL_END'
        callEnds++ if curTok is 'CALL_START'
        ii++
      regexps[idx][1] = i + ii - 1
    return regexps

  containsDoubleQuote: (tokenValue) ->
    tokenValue.indexOf('"') != -1

  containsHash: (tokenValue) ->
    tokenValue.indexOf("#") != -1

require('coffee-script/register')

coffeelint = require 'coffeelint'
expect = require('chai').expect

PreferDoubleQuotes = require '../src/RuleProcessor'

coffeelint.registerRule PreferDoubleQuotes

configError = {prefer_double_quotes: {level: 'error'}}

describe 'PreferDoubleQuotes', ->
  it "should warn when ' is used", ->
    result = coffeelint.lint("'This is a string.'", configError)[0]
    expect(result).to.be.ok

  it 'should not warn when " is used', ->
    result = coffeelint.lint('"This is a string."', configError)[0]
    expect(result).to.be.not.ok

  it "should not warn when ' is used with \"", ->
    result = coffeelint.lint("'This is a \"big\" string.'", configError)[0]
    expect(result).to.be.not.ok

  it "should not warn when \" is used with '", ->
    result = coffeelint.lint("\"This is a 'big' string.\"", configError)[0]
    expect(result).to.be.not.ok

  it "should not warn when ' is used with #", ->
    result = coffeelint.lint("'This will not be \#{interpolated} string.'", configError)[0]
    expect(result).to.be.not.ok

  it "should not warn with multi-line strings", ->
    result = coffeelint.lint('''
      This is a string
    ''', configError)[0]
    expect(result).to.be.not.ok

  it "should not warn when ' is used in a comment", ->
    expect(coffeelint.lint("# 'my string'", configError).length).to.be.not.ok

  it "should not break with regular expressions", ->
    source ='''
            a = 'hello'
            b = ///
              .*
              #{a}
              [0-9]
            ///
            c = RegExp(".*#{a}0-9")
            '''
    expect(coffeelint.lint(source, configError).length).to.be.ok

# coffeelint-prefer-double-quotes
==================================

Influenced by
[https://github.com/parakeety/coffeelint-prefer-english-operator](https://github.com/parakeety/coffeelint-prefer-english-operator).
and
[https://github.com/clutchski/coffeelint/blob/5d818a5a4b4310cc147614e54d972b23f47cad88/src/rules/no_unnecessary_double_quotes.coffee](https://github.com/clutchski/coffeelint/blob/5d818a5a4b4310cc147614e54d972b23f47cad88/src/rules/no_unnecessary_double_quotes.coffee)

coffeelint-prefer-double-quotes is a plugin of [coffeelint](http://www.coffeelint.org/).
It insists that all strings use double quotes unless they:

* are multi-line strings; or
* include the " or # character in the string.

```
"hello" # yes
'hello" # no

"hello #{myVar}" # yes
'hello #{myVar}' # yes, but note that it prints out something different than the above line.

'He said, "Hello" to me' # yes
"He said, 'Hello' to me" # yes

```

## How to Install

1. add `"coffeelint-prefer-double-quotes": "0.1.0"` as `devDependencies` in `package.json`
2. `npm install`

## How to Use

In your `coffeelint.json`, add

```
{
  // other lint rules
  {
    "prefer_double_quotes": {
      "module": "coffeelint-prefer-double-quotes",
      "level": "error"
    }
  }
}
```

and run `coffeelint`.

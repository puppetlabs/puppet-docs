---
layout: default
title: "Future Parser: Data Types: Strings"
canonical: "/puppet/latest/reference/future_lang_data_string.html"
---

[variables]: ./future_lang_variables.html
[expression]: ./future_lang_expressions.html
[reserved]: ./future_lang_reserved.html#reserved-words
[data type]: ./future_lang_data_type.html
[enum]: ./future_lang_data_abstract.html#enum
[pattern]: ./future_lang_data_abstract.html#pattern
[function_statement]: ./future_lang_functions.html#statement-function-calls
[function_chain]: ./future_lang_functions.html#chained-function-calls
[hash access]: ./future_lang_data_hash.html#indexing
[array access]: ./future_lang_data_array.html#indexing
[undef]: ./future_lang_data_undef.html
[boolean]: ./future_lang_data_boolean.html
[number]: ./future_lang_data_number.html
[sprintf]: /references/3.7.latest/function.html#sprintf
[regular expression]: ./future_lang_data_regexp.html
[resource reference]: ./future_lang_data_resource_reference.html
[array]: ./future_lang_data_array.html
[hash]: ./future_lang_data_hash.html

Strings are unstructured text fragments of any length. They're probably the most common and useful data type.

Strings can sometimes interpolate other values, and can sometimes use escape sequences to represent characters that are inconvenient or impossible to write literally. You can access substrings of a string by numerical index.

## Quoting Syntaxes

There are four ways to write literal strings in the Puppet language:

* Bare words
* Single-quoted strings
* Double-quoted strings
* Heredocs

Each of these have slightly different behavior around syntax, interpolation features, and escape sequences.

### Bare Words

{% highlight ruby %}
    service { "ntp":
      ensure => running, # bare word string
    }
{% endhighlight %}

Puppet usually treats bare words --- that is, runs of word-like characters without surrounding quotation marks --- as single-word strings. Bare word strings are most commonly used with resource attributes that accept a limited number of one-word values.

To be treated as a string, a bare word must:

* Begin with a lower case letter, and contain only letters, digits, hyphens (`-`), and underscores (`_`).
* Not be a [reserved word][reserved]

Unquoted words that begin with upper case letters are interpreted as [data types](./future_lang_data_type.html) or [resource references](./future_lang_data_resource_reference.html), not strings.

Bare word strings can't interpolate values and can't use escape sequences.

### Single-Quoted Strings

{% highlight ruby %}
    if $autoupdate {
      notice('autoupdate parameter has been deprecated and replaced with package_ensure.  Set this to latest for the same behavior as autoupdate => true.')
    }
{% endhighlight %}

Multi-word strings can be surrounded by single quotes, `'like this'`. Line breaks within the string are interpreted as literal line breaks.

Single-quoted strings can't interpolate values.

The following escape sequences are available in single-quoted strings:

Sequence | Result
---------|-----------------
`\\`     | Single backslash
`\'`     | Literal single quote

**Note:** If a backslash _isn't_ followed by a single quote or another backslash, Puppet treats it as a literal backslash.

Some common things to watch out for:

* To include a backslash at the very end of a single-quoted string, you must use a double backslash instead of a single backslash. For example: `path => 'C:\Program Files(x86)\\'`
* To include a literal double backslash you must use a quadruple backslash.

### Double-Quoted Strings

Strings can also be surrounded by double quotes, `"like this"`. Line breaks within the string are interpreted as literal line breaks, and you can also insert line breaks with `\n` (Unix-style) or `\r\n` (Windows-style).

Double-quoted strings can interpolate values. [See below for details on interpolation.][interpolation]

The following escape sequences are available in double-quoted strings:

Sequence | Result
---------|-----------------
`\\`     | Single backslash
`\n`     | Newline
`\r`     | Carriage return
`\t`     | Tab
`\s`     | Space
`\$`     | Literal dollar sign (to prevent interpolation)
`\uXXXX` | Unicode character number XXXX (a four-digit hex number)
`\"`     | Literal double quote
`\'`     | Literal single quote

**Note:** If a backslash _isn't_ followed by a character that would make one of these escape sequences, Puppet logs a warning (`Warning: Unrecognized escape sequence`) and then treats it as a literal backslash.

### Heredocs

TODO

## Interpolation

[interpolation]: #interpolation

Interpolation allows strings to contain [expressions][expression], which will be replaced with their values. You can interpolate almost any expression that resolves to a value; the only exception is [statement-style function calls][function_statement].

To interpolate an expression, wrap it in curly braces and prefix it with a dollar sign, like `"String content ${<EXPRESSION>} more content"`.

The dollar sign doesn't have to have a space in front of it; it can be placed directly after any other character, or at the beginning of the string.

An interpolated expression can include quote marks that would end the string if they occurred outside the interpolation token. For example: `"<VirtualHost *:${hiera("http_port")}>"`.

### Preventing Interpolation

If you want a string to include a literal sequence that looks like an interpolation token --- and prevent Puppet from replacing it with a value --- you must either escape the dollar sign (with `\$`) or use a quoting syntax that disables interpolation (single quotes or a non-interpolating heredoc).

### Short Forms for Variable Interpolation

The most common thing to interpolate into a string is the value of a [variable][variables]. To make this easier, Puppet has some shorter forms of the interpolation syntax:

* `$myvariable` --- A variable reference (without curly braces) will be replaced with that variable's value. This also works with qualified variable names like `$myclass::myvariable`.

    Since there isn't an explicit stopping point for this type of interpolation token (like the closing curly brace in standard interpolation), Puppet assumes the variable name is all of the text between the dollar sign and the first character that couldn't legally be part of a variable name. (Or the end of the string, if that comes first.) This means you can't use this style of interpolation when a variable needs to be butted up against some other word-like text. And even in some cases where you _can_ use this style, you might want to use the following style instead just for clarity's sake.
* `${myvariable}` --- A dollar sign followed by a variable name in curly braces will be replaced with that variable's value. This also works with qualified variable names like `${myclass::myvariable}`.

    You can also follow a variable name with any combination of [chained function calls][function_chain] and/or [hash access][] / [array access][] / [substring access][inpage_substring] expressions. For example: `"Using interface ${::interfaces.split(',')[3]} for broadcast"`. _However,_ this doesn't work if the variable's name overlaps with a language keyword. For example, if you had a variable called `$inherits`, you would have to use normal-style interpolation, like `"Inheriting ${$inherits.upcase}."`.


### Conversion of Non-String Values

Puppet will convert the value of any interpolated expression to a string as follows:

Data type                               | Conversion
----------------------------------------|-----------
String                                  | The contents of the string, with any quoting syntax removed.
[Undef][]                               | An empty string.
[Boolean][]                             | The string `'true'` or `'false'`, respectively.
[Number][]                              | The number in decimal notation (base 10). For floats, the value may vary on different platforms; you can use [the `sprintf` function][sprintf] for more precise formatting.
[Array][]                               | A pair of square brackets (`[` and `]`) containing the array's elements, separated by `, ` (a comma with a space). Each element is converted to a string using these same rules. There is no trailing comma.
[Hash][]                                | A pair of curly braces (`{` and `}`) containing a `<KEY> => <VALUE>` string for each key/value pair, separated by `, ` (a comma with a space). Each key and value is converted to a string using these same rules. There is no trailing comma.
[Regular expression][]                  | A stringified regular expression.
[Resource reference][] or [data type][] | The value as a string.



## Line Breaks

Quoted strings can continue over multiple lines, and line breaks are preserved as a literal part of the string.

Puppet does not attempt to convert line breaks, which means whatever type of line break is used in the file (Unix's LF or Windows' CRLF) will be preserved. You can also use escape sequences to insert foreign line breaks into strings:

* To insert a CRLF in a manifest file that uses Unix line endings, use the `\r\n` escape sequences in a double-quoted string (or a heredoc with those escapes enabled).
* To insert an LF in a manifest that uses Windows line endings, use the `\n` escape sequence in a double-quoted string (or a heredoc with `\n` enabled).

## Encoding

Puppet treats strings as sequences of bytes. It does not recognize encodings or translate between them, and non-printing characters are preserved.

However, Puppet Labs recommends that all strings be valid UTF8. Future versions of Puppet might impose restrictions on string encoding, and using only UTF8 will protect you in this event. Additionally, PuppetDB will remove invalid UTF8 characters when storing catalogs.

## Indexing / Substrings

[inpage_substring]: #indexing--substrings

You can access substrings of a string by numerical index. Square brackets are used for indexing; the index consists of one integer, optionally followed by a comma and a second integer (e.g. `$string[3]` or `$string[3,10]`).

The first number of the index is the start position.

* Positive numbers will count from the start of the string, starting at `0`.
* Negative numbers will count back from the end of the string, starting at `-1`.

The second number of the index is the stop position.

* Positive numbers are lengths, counting forward from the start position.
* Negative numbers are absolute positions, counting back from the end of the string (starting at `-1`).

If the second number is omitted, it defaults to `1` (a single character).

Examples:

{% highlight ruby %}
    $foo = 'abcdef'
    notice( $foo[0] )    # resolves to 'a'
    notice( $foo[0,2] )  # resolves to 'ab'
    notice( $foo[1,2] )  # resolves to 'bc'
    notice( $foo[1,-2] ) # resolves to 'bcde'
    notice( $foo[-3,2] ) # resolves to 'de'
{% endhighlight %}

Text outside the actual range of the string is treated as an infinite amount of empty string.

{% highlight ruby %}
    $foo = 'abcdef'
    notice( $foo[10] )    # resolves to ''
    notice( $foo[3,10] )  # resolves to 'def'
    notice( $foo[-10,2] ) # resolves to ''
    notice( $foo[-10,6] ) # resolves to 'ab'
{% endhighlight %}

## The `String` Data Type

The [data type][] of strings is `String`.

By default, `String` matches strings of any length.

You can use parameters to restrict which values `String` will match.

### Parameters

The full signature for `String` is:

    String[<MIN LENGTH>, <MAX LENGTH>]

All of these parameters are optional. They must be listed in order; if you need to specify a later parameter, you must specify values for any prior ones.

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1 | Min length | `Integer` | 0 | The minimum number of (Unicode) characters in the string. This parameter accepts the special value `default`, which will use its default value.
2 | Max length | `Integer` | infinite | The maximum number of (Unicode) characters in the string. This parameter accepts the special value `default`, which will use its default value.

### Examples

* `String` --- matches a string of any length.
* `String[6]` --- matches a string with at least 6 characters.
* `String[6, 8]` --- matches a string with at least 6 and at most 8 characters.


### Related Data Types

The abstract [`Enum` type][enum] matches against a list of specific allowed string values.

The abstract [`Pattern` type][pattern] matches against one or more regular expressions.


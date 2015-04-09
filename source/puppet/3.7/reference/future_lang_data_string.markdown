---
layout: default
title: "Future Parser: Data Types: Strings"
canonical: "/puppet/latest/reference/future_lang_data_string.html"
---

[variables]: ./future_lang_variables.html
[expression]: ./future_lang_expressions.html
[reserved]: ./future_lang_reserved.html#reserved-words



Strings are unstructured text fragments of any length. They are often (but not always) surrounded by quotation marks. Use single quotes for all strings that do not require variable interpolation, and double quotes for strings that do require variable interpolation or where control characters or unicode characters are included via escape sequences.

## Bare Words

Bare (that is, not quoted) words are usually treated as single-word strings. To be treated as a string, a bare word must:

* Begin with a lower case letter, and contain only letters, digits, hyphens (`-`), and underscores (`_`).
* Not be a [reserved word][reserved]

Unquoted words that begin with upper case letters are interpreted as [data types](#TODO) or [resource references](#resource-references), not strings.

Bare word strings are usually used with resource attributes that accept a limited number of one-word values.

## Single-Quoted Strings

Strings surrounded by single quotes `'like this'` do not interpolate variables, and the only escape sequences permitted are `\'` (a literal single quote) and `\\` (a literal backslash). Line breaks within the string are interpreted as literal line breaks.

If a backslash isn't followed by a single quote or another backslash, it's treated as a literal backslash.

Some common things to watch out for:

* To include a backslash at the very end of a single-quoted string, you must use a double backslash instead of a single backslash. For example: `path => 'C:\Program Files(x86)\\'`
* To include a literal double backslash you must use a quadruple backslash.

## Double-Quoted Strings

Strings surrounded by double quotes `"like this"` allow variable interpolation and several escape sequences. Line breaks within the string are interpreted as literal line breaks, and you can also insert line breaks by using the `\n` escape sequence.

### Variable Interpolation

Any [`$variable`][variables] in a double-quoted string will be replaced with its value. To remove ambiguity about which text is part of the variable name, you can surround the variable name in curly braces:

{% highlight ruby %}
    path => "${apache::root}/${apache::vhostdir}/${name}",
{% endhighlight %}

### Expression Interpolation

In a double-quoted string, you can interpolate the value of an arbitrary [expression][] (which can contain both variables and literal values) by putting it inside `${}` (a pair of curly braces preceded by a dollar sign):

{% highlight ruby %}
    file {'config.yml':
      content => "...
    db_remote: ${ $clientcert !~ /^db\d+/ }
    ...",
      ensure => file,
    }
{% endhighlight %}


### Escape Sequences

The following escape sequences are available:

* `\$` --- literal dollar sign
* `\"` --- literal double quote
* `\'` --- literal single quote
* `\\` --- single backslash
* `\n` --- newline
* `\r` --- carriage return
* `\t` --- tab
* `\s` --- space
* `\uXXXX` --- unicode character number XXXX (a 4 digit hex number)

## Line Breaks

Quoted strings can continue over multiple lines, and line breaks are preserved as a literal part of the string.

Puppet does not attempt to convert line breaks, which means that the type of line break (Unix/LF or Windows/CRLF) used in the file will be preserved. You can also insert literal foreign line breaks into strings:

* To insert a CRLF in a manifest file that uses Unix line endings, use the `\r\n` escape sequences in a double-quoted string.
* To insert an LF in a manifest that uses Windows line endings, use the `\n` escape sequence in a double-quoted string.

## Encoding

Puppet treats strings as sequences of bytes. It does not recognize encodings or translate between them, and non-printing characters are preserved.

However, Puppet Labs recommends that all strings be valid UTF8. Future versions of Puppet might impose restrictions on string encoding, and using only UTF8 will protect you in this event. Additionally, PuppetDB will remove invalid UTF8 characters when storing catalogs.

## Indexing / Substrings

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


---
layout: default
title: "Language: Data types: Strings"
canonical: "/puppet/latest/lang_data_string.html"
---

[variables]: ./lang_variables.html
[expression]: ./lang_expressions.html
[reserved]: ./lang_reserved.html#reserved-words
[data type]: ./lang_data_type.html
[enum]: ./lang_data_abstract.html#enum
[pattern]: ./lang_data_abstract.html#pattern
[function_statement]: ./lang_functions.html#list-of-built-in-statement-functions
[function_chain]: ./lang_functions.html#chained-function-calls
[hash access]: ./lang_data_hash.html#accessing-values
[array access]: ./lang_data_array.html#accessing-values
[undef]: ./lang_data_undef.html
[boolean]: ./lang_data_boolean.html
[number]: ./lang_data_number.html
[sprintf]: ./function.html#sprintf
[regular expression]: ./lang_data_regexp.html
[resource reference]: ./lang_data_resource_reference.html
[array]: ./lang_data_array.html
[hash]: ./lang_data_hash.html

Strings are unstructured text fragments of any length. They're probably the most common and useful data type.

Strings can sometimes interpolate other values, and can sometimes use escape sequences to represent characters that are inconvenient or impossible to write literally. You can access substrings of a string by numerical index.

There are four ways to write literal strings in the Puppet language:

* Bare words
* Single-quoted strings
* Double-quoted strings
* Heredocs

Each of these have slightly different behavior around syntax, interpolation features, and escape sequences.

## Bare words

``` puppet
service { "ntp":
  ensure => running, # bare word string
}
```

Puppet usually treats bare words --- that is, runs of word-like characters without surrounding quotation marks --- as single-word strings. Bare word strings are most commonly used with resource attributes that accept a limited number of one-word values.

To be treated as a string, a bare word must:

* Begin with a lower case letter, and contain only letters, digits, hyphens (`-`), and underscores (`_`).
* Not be a [reserved word][reserved]

Unquoted words that begin with upper case letters are interpreted as [data types](./lang_data_type.html) or [resource references](./lang_data_resource_reference.html), not strings.

Bare word strings can't interpolate values and can't use escape sequences.

## Single-quoted strings

``` puppet
if $autoupdate {
  notice('autoupdate parameter has been deprecated and replaced with package_ensure.  Set this to latest for the same behavior as autoupdate => true.')
}
```

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

## Double-quoted strings

Strings can also be surrounded by double quotes, `"like this"`. Line breaks within the string are interpreted as literal line breaks, and you can also insert line breaks with `\n` (Unix-style) or `\r\n` (Windows-style).

Double-quoted strings can interpolate values. [See below for details on interpolation.][interpolation]

### Escape sequences

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
`\u{XXXXXX}` | Unicode character XXXXXX (a hex number between two and six digits)
`\"`     | Literal double quote
`\'`     | Literal single quote

**Note:** If a backslash _isn't_ followed by a character that would make one of these escape sequences, Puppet logs a warning (`Warning: Unrecognized escape sequence`) and then treats it as a literal backslash.

## Heredocs

``` puppet
$gitconfig = @("GITCONFIG"/L)
    [user]
        name = ${displayname}
        email = ${email}
    [color]
        ui = true
    [alias]
        lg = "log --pretty=format:'%C(yellow)%h%C(reset) %s \
    %C(cyan)%cr%C(reset) %C(blue)%an%C(reset) %C(green)%d%C(reset)' --graph"
        wdiff = diff --word-diff=color --ignore-space-at-eol \
    --word-diff-regex='[[:alnum:]]+|[^[:space:][:alnum:]]+'
    [merge]
        defaultToUpstream = true
    [push]
        default = upstream
    | GITCONFIG

file { "${homedir}/.gitconfig":
  ensure  => file,
  content => $gitconfig,
}
```


Heredocs let you quote strings with more control over escaping, interpolation, and formatting. They're especially good for long strings with complicated content.

### Syntax

To write a heredoc, you place a **heredoc tag** somewhere in a line of Puppet code. This tag acts as a literal string value, but the content of that string is read from the following lines. The string ends when an end marker is reached.

The general form of a heredoc string is:

* A **heredoc tag** like `@("END"/n$)`, which can be used anywhere a string value is accepted. This tag consists of:
    * An at sign and an opening parenthesis (`@(`).
    * Some [**end text,**][inpage_end] which will also appear in the end marker.
        * Optionally, you can surround the end text with double quotes (`"`) to [enable interpolation.][inpage_enable_interp]
    * Optionally, a slash (`/`) followed by zero or more [**escape switches.**][inpage_enable_escape]
    * A closing parenthesis (`)`).
* The rest of the line of Puppet code that uses this string value.
* Starting on the _next_ line: the content of the string, which can run over multiple lines.
    * The content might be able to interpolate values or use escape sequences, if you enabled that.
    * The content might have cosmetic indentation or line breaks that will be excluded from the actual string value. (See [Formatting Control][inpage_format] below.)
* An **end marker** like `|-END`, on a line of its own. An end marker consists of:
    * Optionally, some indentation and a pipe character (`|`) to show how much indentation should be stripped from the string. (See [Formatting Control][inpage_format] below.)
    * Optionally, a hyphen (`-`) to trim the final line break. (See [Formatting Control][inpage_format] below.) The hyphen can be surrounded by any amount of space.
    * The exact [**end text**][inpage_end] you specified in the heredoc tag above (without any surrounding quotes). The end text can be surrounded by any amount of space.

If a line of Puppet code includes more than one heredoc tag, Puppet will read all of those heredocs in order: the first one will begin on the following line and continue until its end marker, the second one will begin on the line immediately after the first end marker, etc. Puppet won't start evaluating additional lines of Puppet code until it reaches the end marker for the final heredoc on that original line.

### End text

[inpage_end]: #end-text

The tag that starts a heredoc has to include a piece of end text. When Puppet reaches a line that contains only that end text (plus optional formatting control), the string ends.

Both occurrences of the end text must match exactly, with the same capitalization and internal spacing.

End text can be any run of text that doesn't include line breaks, colons, slashes, or parentheses. It can include spaces, and can be mixed case.

The following are all valid end text:

* `EOT`
* `...end...end...`
* `Verse 8 of The Raven`

You should make sure your end text stands out from the actual text of the string. Uppercase end text is usually best.

### Enabling interpolation

[inpage_enable_interp]: #enabling-interpolation

By default, heredocs _do not_ allow you to [interpolate values.][interpolation] You can enable interpolation by double-quoting the end text in the opening heredoc tag. That is:

* An opening tag like `@(EOT)` _won't_ allow interpolation.
* An opening tag like `@("EOT")` _will_ allow interpolation.

By default, you can't use the `\$` escape sequence to prevent interpolation, but you can optionally enable that escape sequence. (See the next section.)

### Enabling escape sequences

[inpage_enable_escape]: #enabling-escape-sequences

By default, heredocs have _no_ escape sequences and every character is literal (except interpolated expressions, if enabled). You can enable the escapes you want by adding switches to the heredoc tag.

* To enable _individual_ escape sequences, add a slash (`/`) and some switches to the heredoc tag:
    * `@("EOT"/$n)` would start a heredoc with `\$` and `\n` enabled.
* To enable _all_ escape sequences, add a slash (`/`) and _no_ switches:
    * `@("EOT"/)` would start a heredoc with all escapes enabled.

The following escape sequences are available, and can be enabled with the listed switches:

Switch | Sequence        | Result
-------|-----------------|-------
(auto) | `\\`            | Single backslash (auto-enabled when any other escape is enabled)
`n`    | `\n`            | Newline
`r`    | `\r`            | Carriage return
`t`    | `\t`            | Tab
`s`    | `\s`            | Space
`$`    | `\$`            | Literal dollar sign (to prevent interpolation)
`u`    | `\uXXXX`        | Unicode character number XXXX (a four-digit hex number)
`u`    | `\u{XXXXXX}`    | Unicode character XXXXXX (a hex number between two and six digits)
`L`    | `\<LF or CRLF>` | Nothing (for cosmetic line breaks that appear in the source code but are excluded from the string value)

**Note:** If a backslash isn't part of an enabled escape sequence, Puppet treats it as a literal backslash. Unlike with double-quoted strings, this won't log a warning.

If a string has escapes enabled and includes several literal backslashes in a row, you should make sure each literal backslash is represented by the `\\` escape sequence. (Quadruple backslash to represent a double backslash, etc.)

### Formatting control

[inpage_format]: #formatting-control

You can control the formatting of a heredoc string by stripping indentation and suppressing line breaks.

#### Stripping indentation

To make your files easier to read, you can indent the content of a heredoc to separate it from the surrounding Puppet code.

To strip this indentation from the final string, put the same amount of indentation in front of the end marker and use a pipe character (`|`) to indicate the position of the first "real" character on each line.

```
$mytext = @(EOT)
    This block of text is
    visibly separated from
    everything around it.
    | EOT
```

* If a line has _less_ indentation than you've indicated, Puppet will strip any spaces it can without deleting non-space characters.
* If a line has _more_ indentation than you've indicated, any excess will be included in the final string.

Indentation can also include tab characters, but Puppet won't automatically convert tabs to spaces, so make sure you use the exact same sequence of space and tab characters on each line.

#### Suppressing literal line breaks

If you enable the `L` escape switch, you can end a line with a backslash (`\`) to exclude the following line break from the final string. This lets you break up long lines in your source code without adding unwanted literal line breaks.

For example, Puppet would read this as a single line:

```
lg = "log --pretty=format:'%C(yellow)%h%C(reset) %s \
%C(cyan)%cr%C(reset) %C(blue)%an%C(reset) %C(green)%d%C(reset)' --graph"
```


#### Suppressing the final line break

By default, heredocs end with a trailing line break, but you can exclude this line break from the final string. To suppress it, add a hyphen (`-`) to the end marker (before the end text, but after the indentation pipe if you used one).

For example, Puppet would read this as a string with no line breaks:

```
$mytext = @("EOT")
    This's too inconvenient for ${double} or ${single} quotes, but needs to be one line.
    |-EOT
```

This works even if you don't have the `L` escape switch enabled.


## Interpolation

[interpolation]: #interpolation

Interpolation allows strings to contain [expressions][expression], which will be replaced with their values. You can interpolate almost any expression that resolves to a value; the only exception is [statement-style function calls][function_statement].

To interpolate an expression, wrap it in curly braces and prefix it with a dollar sign, like `"String content ${<EXPRESSION>} more content"`.

The dollar sign doesn't have to have a space in front of it; it can be placed directly after any other character, or at the beginning of the string.

An interpolated expression can include quote marks that would end the string if they occurred outside the interpolation token. For example: `"<VirtualHost *:${hiera("http_port")}>"`.

Only double-quoted strings and heredocs can interpolate values. With heredocs, you have to [explicitly enable interpolation.][inpage_enable_interp]

### Preventing interpolation

If you want a string to include a literal sequence that looks like an interpolation token --- and prevent Puppet from replacing it with a value --- you must either escape the dollar sign (with `\$`) or use a quoting syntax that disables interpolation (single quotes or a non-interpolating heredoc).

### Short forms for variable interpolation

The most common thing to interpolate into a string is the value of a [variable][variables]. To make this easier, Puppet has some shorter forms of the interpolation syntax:

* `$myvariable` --- A variable reference (without curly braces) will be replaced with that variable's value. This also works with qualified variable names like `$myclass::myvariable`.

    Since this syntax doesn't have an explicit stopping point (like a closing curly brace), Puppet assumes the variable name is everything between the dollar sign and the first character that couldn't legally be part of a variable name. (Or the end of the string, if that comes first.)

    This means you can't use this style of interpolation when a value must run up against some other word-like text. And even in some cases where you _can_ use this style, the following style can sometimes be clearer.
* `${myvariable}` --- A dollar sign followed by a variable name in curly braces will be replaced with that variable's value. This also works with qualified variable names like `${myclass::myvariable}`.

    With this syntax, you can also follow a variable name with any combination of [chained function calls][function_chain] and/or [hash access][] / [array access][] / [substring access][inpage_substring] expressions. For example: `"Using interface ${::interfaces.split(',')[3]} for broadcast"`. However, this doesn't work if the variable's name overlaps with a language keyword. For example, if you had a variable called `$inherits`, you would have to use normal-style interpolation, like `"Inheriting ${$inherits.upcase}."`.


### Conversion of interpolated values

Puppet will convert the value of any interpolated expression to a string as follows:

Data type                               | Conversion
----------------------------------------|-----------
String                                  | The contents of the string, with any quoting syntax removed.
[Undef][]                               | An empty string.
[Boolean][]                             | The string `'true'` or `'false'`, respectively.
[Number][]                              | The number in decimal notation (base 10). For floats, the value can vary on different platforms; you can use [the `sprintf` function][sprintf] for more precise formatting.
[Array][]                               | A pair of square brackets (`[` and `]`) containing the array's elements, separated by `, ` (a comma and a space). Each element is converted to a string using these same rules. There is no trailing comma.
[Hash][]                                | A pair of curly braces (`{` and `}`) containing a `<KEY> => <VALUE>` string for each key/value pair, separated by `, ` (a comma and a space). Each key and value is converted to a string using these same rules. There is no trailing comma.
[Regular expression][]                  | A stringified regular expression.
[Resource reference][] or [data type][] | The value as a string.



## Line breaks

Quoted strings can continue over multiple lines, and line breaks are preserved as a literal part of the string. Heredocs let you suppress these line breaks if you enable the `L` escape.

Puppet does not attempt to convert line breaks, which means whatever type of line break is used in the file (Unix's LF or Windows' CRLF) will be preserved. You can also use escape sequences to insert foreign line breaks into strings:

* To insert a CRLF in a manifest file that uses Unix line endings, use the `\r\n` escape sequences in a double-quoted string (or a heredoc with those escapes enabled).
* To insert an LF in a manifest that uses Windows line endings, use the `\n` escape sequence in a double-quoted string (or a heredoc with `\n` enabled).

## Encoding

Puppet treats strings as sequences of bytes. It does not recognize encodings or translate between them, and non-printing characters are preserved.

However, Puppet recommends that all strings be valid UTF8. Future versions of Puppet might impose restrictions on string encoding, and using only UTF8 will protect you in this event. Additionally, PuppetDB will remove invalid UTF8 characters when storing catalogs.

## Accessing substrings

[inpage_substring]: #accessing-substrings

You can access substrings of a string by numerical index. Square brackets are used for accessing; the index consists of one integer, optionally followed by a comma and a second integer (e.g. `$string[3]` or `$string[3,10]`).

The first number of the index is the start position.

* Positive numbers will count from the start of the string, starting at `0`.
* Negative numbers will count back from the end of the string, starting at `-1`.

The second number of the index is the stop position.

* Positive numbers are lengths, counting forward from the start position.
* Negative numbers are absolute positions, counting back from the end of the string (starting at `-1`).

If the second number is omitted, it defaults to `1` (a single character).

Examples:

``` puppet
$foo = 'abcdef'
notice( $foo[0] )    # resolves to 'a'
notice( $foo[0,2] )  # resolves to 'ab'
notice( $foo[1,2] )  # resolves to 'bc'
notice( $foo[1,-2] ) # resolves to 'bcde'
notice( $foo[-3,2] ) # resolves to 'de'
```

Text outside the actual range of the string is treated as an infinite amount of empty string.

``` puppet
$foo = 'abcdef'
notice( $foo[10] )    # resolves to ''
notice( $foo[3,10] )  # resolves to 'def'
notice( $foo[-10,2] ) # resolves to ''
notice( $foo[-10,6] ) # resolves to 'ab'
```

## The `String` data type

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


### Related data types

The abstract [`Enum` type][enum] matches against a list of specific allowed string values.

The abstract [`Pattern` type][pattern] matches against one or more regular expressions.


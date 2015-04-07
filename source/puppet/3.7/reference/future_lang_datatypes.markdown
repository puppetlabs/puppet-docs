---
layout: default
title: "Future Parser: Data Types"
canonical: "/puppet/latest/reference/future_lang_datatypes.html"
---


[local]: ./future_lang_scope.html#local-scopes
[conditional]: ./future_lang_conditional.html
[node]: ./future_lang_node_definitions.html
[attribute]: ./future_lang_resources.html#syntax
[regsubst]: /references/latest/function.html#regsubst
[function]: ./future_lang_functions.html
[variables]: ./future_lang_variables.html
[expression]: ./future_lang_expressions.html
[if]: ./future_lang_conditional.html#if-statements
[comparison]: ./future_lang_expressions.html#comparison-operators
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[facts]: ./future_lang_variables.html#facts
[fact_datatypes]: ./future_lang_facts_and_builtin_vars.html#data-types
[reserved]: ./future_lang_reserved.html#reserved-words
[attribute_override]: ./future_lang_resources.html#adding-or-modifying-attributes
[resourcedefault]: ./future_lang_defaults.html
[node_def]: ./future_lang_node_definitions.html
[relationship]: ./future_lang_relationships.html
[chaining]: ./future_lang_relationships.html#chaining-arrows
[mutable]: http://projects.puppetlabs.com/issues/16116

The Puppet language allows several data types as [variables][], [attribute][] values, and [function][] arguments:

Booleans
-----

The boolean type has two possible values: `true` and `false`. Literal booleans must be one of these two bare words (that is, not quoted).

The condition of an ["if" statement][if] expects a boolean value. All of Puppet's [comparison operators][comparison] resolve to boolean values, as do many [functions][function].

### Automatic Conversion to Boolean

If a non-boolean value is used where a boolean is required:

* The `undef` value is converted to boolean `false`.
* **All** other values are converted to boolean `true`.

Notably, this means the string values `""` (zero-length string) and `"false"` both resolve to `true`. If Puppet is configured to treat all [facts][] as strings, this can cause unexpected behavior; see [the docs on fact data types][fact_datatypes] for more info.

If you want to convert other values to booleans with more permissive rules (`0` as false, `"false"` as false, etc.), the [puppetlabs-stdlib][stdlib] module includes `str2bool` and `num2bool` functions.


* * *

Undef
-----

Puppet's special undef value is roughly equivalent to `nil` in Ruby; it represents the absence of a value. If the `strict_variables` setting isn't enabled, variables which have never been declared have a value of `undef`. Literal undef values must be the bare word `undef`.

The undef value is usually useful for testing whether a variable has been set. It can also be used as the value of a resource attribute, which can let you un-set any value inherited from a [resource default][resourcedefault] and cause the attribute to be unmanaged.

When used as a boolean, `undef` is false.

* * *

Strings
-----

Strings are unstructured text fragments of any length. They are often (but not always) surrounded by quotation marks. Use single quotes for all strings that do not require variable interpolation, and double quotes for strings that do require variable interpolation or where control characters or unicode characters are included via escape sequences.

### Bare Words

Bare (that is, not quoted) words are usually treated as single-word strings. To be treated as a string, a bare word must:

* Begin with a lower case letter, and contain only letters, digits, hyphens (`-`), and underscores (`_`).
* Not be a [reserved word][reserved]

Unquoted words that begin with upper case letters are interpreted as [data types](#TODO) or [resource references](#resource-references), not strings.

Bare word strings are usually used with resource attributes that accept a limited number of one-word values.

### Single-Quoted Strings

Strings surrounded by single quotes `'like this'` do not interpolate variables, and the only escape sequences permitted are `\'` (a literal single quote) and `\\` (a literal backslash). Line breaks within the string are interpreted as literal line breaks.

If a backslash isn't followed by a single quote or another backslash, it's treated as a literal backslash.

Some common things to watch out for:

* To include a backslash at the very end of a single-quoted string, you must use a double backslash instead of a single backslash. For example: `path => 'C:\Program Files(x86)\\'`
* To include a literal double backslash you must use a quadruple backslash.

### Double-Quoted Strings

Strings surrounded by double quotes `"like this"` allow variable interpolation and several escape sequences. Line breaks within the string are interpreted as literal line breaks, and you can also insert line breaks by using the `\n` escape sequence.

#### Variable Interpolation

Any [`$variable`][variables] in a double-quoted string will be replaced with its value. To remove ambiguity about which text is part of the variable name, you can surround the variable name in curly braces:

{% highlight ruby %}
    path => "${apache::root}/${apache::vhostdir}/${name}",
{% endhighlight %}

#### Expression Interpolation

In a double-quoted string, you can interpolate the value of an arbitrary [expression][] (which can contain both variables and literal values) by putting it inside `${}` (a pair of curly braces preceded by a dollar sign):

{% highlight ruby %}
    file {'config.yml':
      content => "...
    db_remote: ${ $clientcert !~ /^db\d+/ }
    ...",
      ensure => file,
    }
{% endhighlight %}


#### Escape Sequences

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

### Line Breaks

Quoted strings can continue over multiple lines, and line breaks are preserved as a literal part of the string.

Puppet does not attempt to convert line breaks, which means that the type of line break (Unix/LF or Windows/CRLF) used in the file will be preserved. You can also insert literal foreign line breaks into strings:

* To insert a CRLF in a manifest file that uses Unix line endings, use the `\r\n` escape sequences in a double-quoted string.
* To insert an LF in a manifest that uses Windows line endings, use the `\n` escape sequence in a double-quoted string.

### Encoding

Puppet treats strings as sequences of bytes. It does not recognize encodings or translate between them, and non-printing characters are preserved.

However, Puppet Labs recommends that all strings be valid UTF8. Future versions of Puppet might impose restrictions on string encoding, and using only UTF8 will protect you in this event. Additionally, PuppetDB will remove invalid UTF8 characters when storing catalogs.

### Indexing / Substrings

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



* * *

Resource References
-----

Resource references identify a specific existing Puppet resource by its type and title. Several attributes, such as the [relationship][] metaparameters, require resource references.

{% highlight ruby %}
    # A reference to a file resource:
    subscribe => File['/etc/ntp.conf'],
    ...
    # A type with a multi-segment name:
    before => Concat::Fragment['apache_port_header'],
{% endhighlight %}

The general form of a resource reference is:

* The resource **type,** capitalized (every segment must be capitalized if the type includes a namespace separator \[`::`\])
* An opening square bracket
* The **title** of the resource, or a comma-separated list of titles
* A closing square bracket

Unlike variables, resource references are not evaluation-order dependent, and can be used before the resource itself is declared.

### Multi-Resource References

Resource references with an **array of titles** or **comma-separated list of titles** refer to multiple resources of the same type. They evaluate to an array of single title resource references.

{% highlight ruby %}
    # A multi-resource reference:
    require => File['/etc/apache2/httpd.conf', '/etc/apache2/magic', '/etc/apache2/mime.types'],
    # An equivalent multi-resource reference:
    $my_files = ['/etc/apache2/httpd.conf', '/etc/apache2/magic', '/etc/apache2/mime.types']
    require => File[$my_files]
{% endhighlight %}

They can be used wherever an array of references might be used. They can also go on either side of a [chaining arrow][chaining] or receive a [block of additional attributes][attribute_override].


* * *

Numbers
-----

Puppet's arithmetic expressions accept integers and floating point numbers.

Numbers are written without quotation marks, and can consist only of:

* Digits
* An optional negative sign (`-`; actually [the unary negation operator](./future_lang_expressions.html#subtraction-and-negation))
    * Explicit positive signs (`+`) aren't allowed.
* An optional decimal point (which results in a floating point value)
* A prefix, for octal or hexidecimal bases
* An optional `e` or `E` for scientific notation of floating point values

### Floats

If an expression includes both integer and float values, the result will be a float

{% highlight ruby %}
    $some_number = 8 * -7.992           # evaluates to -63.936
    $another_number = $some_number / 4  # evaluates to -15.984
{% endhighlight %}

Floating point numbers between -1 and 1 cannot start with a bare decimal point; they must have a zero before the decimal point.

{% highlight ruby %}
    $product = 8 * .12 # syntax error
    $product = 8 * 0.12 # OK
{% endhighlight %}

You can express floating point numbers in scientific notation: append `e` or `E` plus an exponent, and the preceding number will be multiplied by 10 to the power of that exponent. Numbers in scientific notation are always floats.

{% highlight ruby %}
    $product = 8 * 3e5  # evaluates to 240000.0
{% endhighlight %}

### Octal and Hexadecimal Integers

Integer values can be expressed in decimal notation (base 10), octal notation (base 8), and hexadecimal notation (base 16). Octal values have a prefix of `0`, which can be followed by a sequence of octal digits 0-7. Hexadecimal values have a prefix of `0x` or `0X`, which can be followed by hexadecimal digits 0-9, a-f, or A-F.

Floats can't be expressed in octal or hex.

{% highlight ruby %}
    # octal
    $value = 0777   # evaluates to decimal 511
    $value = 0789   # Error, invalid octal
    $value = 0777.3 # Error, invalid octal

    # hexadecimal
    $value = 0x777 # evaluates to decimal 1911
    $value = 0xdef # evaluates to decimal 3567
    $value = 0Xdef # same as above
    $value = 0xDEF # same as above
    $value = 0xLSD # Error, invalid hex
{% endhighlight %}

### Converting Numbers to Strings

Numbers are automatically converted to strings when interpolated into a string. The automatic conversion uses decimal (base 10) notation.

If you need to convert numbers to non-decimal string representations, you can use [the `printf` function.](/references/3.7.latest/function.html#printf)

### Converting Strings to Numbers

Strings are never automatically converted to numbers. You can use [the `scanf` function](/references/3.7.latest/function.html#scanf) to convert strings to numbers, accounting for various notations and any surrounding non-numerical text.

* * *

Arrays
-----

Arrays are written as comma-separated lists of items surrounded by square brackets. An optional trailing comma is allowed between the final value and the closing square bracket.

{% highlight ruby %}
    [ 'one', 'two', 'three' ]
    # Equivalent:
    [ 'one', 'two', 'three', ]
{% endhighlight %}

The items in an array can be any data type, including hashes or more arrays.

Resource attributes which can optionally accept multiple values (including the relationship metaparameters) expect those values in an array.

### Indexing

You can access items in an array by their numerical index (counting from zero). Square brackets are used for indexing.

Example:

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three' ]
    notice( $foo[1] )
{% endhighlight %}

This manifest would log `two` as a notice. (`$foo[0]` would be `one`, since indexing counts from zero.)

Nested arrays and hashes can be accessed by chaining indexes:

{% highlight ruby %}
    $foo = [ 'one', {'second' => 'two', 'third' => 'three'} ]
    notice( $foo[1]['third'] )
{% endhighlight %}

This manifest would log `three` as a notice. (`$foo[1]` is a hash, and we access a key named `'third'`.)

Arrays support negative indexing, with `-1` being the final element of the array:

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three', 'four', 'five' ]
    notice( $foo[2] )
    notice( $foo[-2] )
{% endhighlight %}

The first notice would log `three`, and the second would log `four`.

Note that the opening square bracket must not be preceded by a white space:

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three', 'four', 'five' ]
    notice( $foo[2] )  # ok
    notice( $foo [2] ) # syntax error
{% endhighlight %}


### Array Sectioning

You can also access sections of an array by numerical index. Like indexing, sectioning uses square brackets, but it uses two indexes (separated by a comma) instead of one (e.g. `$array[3,10]`).

The result of an array section is always another array.

The first number of the index is the start position.

* Positive numbers will count from the start of the array, starting at `0`.
* Negative numbers will count back from the end of the array, starting at `-1`.

The second number of the index is the stop position.

* Positive numbers are lengths, counting forward from the start position.
* Negative numbers are absolute positions, counting back from the end of the array (starting at `-1`).

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three', 'four', 'five' ]
    notice( $foo[2,1] )  # evaluates to ['three']
    notice( $foo[2,2] )  # evaluates to ['three', 'four']
    notice( $foo[2,-1] ) # evaluates to ['three', 'four', 'five']
    notice( $foo[-2,1] ) # evaluates to ['four']
{% endhighlight %}

### Array Operators

There are three expression operators that can act on array values: `*` (splat), `+` (concatenation), and `-` (removal).

For details, [see the relevant section of the Expressions and Operators page.](./future_lang_expressions.html#array-operators)


### Additional Functions

The [puppetlabs-stdlib][stdlib] module contains several additional functions for dealing with arrays, including:

* `delete`
* `delete_at`
* `flatten`
* `grep`
* `hash`
* `is_array`
* `join`
* `member`
* `prefix`
* `range`
* `reverse`
* `shuffle`
* `size`
* `sort`
* `unique`
* `validate_array`
* `values_at`
* `zip`


* * *

Hashes
-----

Hashes are written as key/value pairs surrounded by curly braces; a key is separated from its value by a `=>` (arrow, fat comma, or hash rocket), and adjacent pairs are separated by commas. An optional trailing comma is allowed between the final value and the closing curly brace.

{% highlight ruby %}
    { key1 => 'val1', key2 => 'val2' }
    # Equivalent:
    { key1 => 'val1', key2 => 'val2', }
{% endhighlight %}

Hash keys are strings, but hash values can be any data type, including arrays or more hashes.

### Indexing

You can access hash members with their key; square brackets are used for indexing.

{% highlight ruby %}
    $myhash = { key       => "some value",
                other_key => "some other value" }
    notice( $myhash[key] )
{% endhighlight %}

This manifest would log `some value` as a notice.

> **Note**: Accessing a nonexistent key in a hash returns `undef`.

Nested arrays and hashes can be accessed by chaining indexes:

{% highlight ruby %}
    $main_site = { port        => { http  => 80,
                                    https => 443 },
                   vhost_name  => 'docs.puppetlabs.com',
                   server_name => { mirror0 => 'warbler.example.com',
                                    mirror1 => 'egret.example.com' }
                 }
    notice ( $main_site[port][https] )
{% endhighlight %}

This example manifest would log `443` as a notice.

### Additional Functions

The [puppetlabs-stdlib][stdlib] module contains several additional functions for dealing with hashes, including:

* `has_key`
* `is_hash`
* `keys`
* `merge`
* `validate_hash`
* `values`


* * *

Regular Expressions
-----

Regular expressions (regexes) are Puppet's one **non-standard** data type. They cannot be assigned to variables, and they can only be used in the few places that specifically accept regular expressions. These places include: the `=~` and `!~` regex match operators, the cases in selectors and case statements, and the names of [node definitions][node_def]. They cannot be passed to functions or used in resource attributes. (Note that the [`regsubst` function][regsubst] takes a stringified regex in order to get around this.)

Regular expressions are written as [standard Ruby regular expressions](http://www.ruby-doc.org/core/Regexp.html) (valid for the version of Ruby being used by Puppet) and must be surrounded by forward slashes:

{% highlight ruby %}
    if $host =~ /^www(\d+)\./ {
      notify { "Welcome web server #$1": }
    }
{% endhighlight %}

Alternate forms of regex quoting are not allowed and Ruby-style variable interpolation is not available.

### Regex Options

Regexes in Puppet cannot have options or encodings appended after the final slash. However, you can turn options on or off for portions of the expression using the `(?<ENABLED OPTION>:<SUBPATTERN>)` and `(?-<DISABLED OPTION>:<SUBPATTERN>)` notation. The following example enables the `i` option while disabling the `m` and `x` options:

{% highlight ruby %}
     $packages = $operatingsystem ? {
       /(?i-mx:ubuntu|debian)/        => 'apache2',
       /(?i-mx:centos|fedora|redhat)/ => 'httpd',
     }
{% endhighlight %}

The following options are allowed:

* i --- Ignore case
* m --- Treat a newline as a character matched by `.`
* x --- Ignore whitespace and comments in the pattern

### Regex Capture Variables

Within [conditional statements][conditional] that use regexes (but **not** [node definitions][node] that use them), any captures from parentheses in the pattern will be available inside the associated value as numbered variables (`$1, $2`, etc.), and the entire match will be available as `$0`.

These are not normal variables, and have some special behaviors:

* The values of the numbered variables do not persist outside the code block associated with the pattern that set them.
* In nested conditionals, each conditional has its own set of values for the set of numbered variables. At the end of an interior statement, the numbered variables are reset to their previous values for the remainder of the outside statement. (This causes conditional statements to act like [local scopes][local], but only with regard to the numbered variables.)

### Regex Functions

You can use [the `match` function](/references/3.7.latest/function.html#match) to do more advanced regex matching. This function performs matching against strings, and returns an array containing the match's result and any captures.

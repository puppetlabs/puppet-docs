---
layout: default
title: "Future Parser: Data Types"
canonical: "/puppet/latest/reference/future_lang_datatypes.html"
---


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

The condition of an ["if" statement][if] expects a boolean value. All of Puppet's [comparison expressions][comparison] return boolean values, as do many [functions][function].

### Automatic Conversion to Boolean

If a non-boolean value is used where a boolean is required, an `undef` value is converted to boolean `false`, and all other values to boolean `true`.

Specifically:

Strings
: All strings are true, including the empty string (`""`). That means the string `"false"` actually resolves as true. 

  > Note: the [puppetlabs-stdlib][stdlib] module includes a `str2bool` function which converts strings to boolean values with interpretation of certain values such as the string 'true'. 

Numbers
: All numbers are true, including zero and negative numbers. 

  > Note: the [puppetlabs-stdlib][stdlib] module includes a `num2bool` function which converts numbers to boolean values with interpretation of certain numbers to be false or true. 

Undef
: The special data type `undef` is false.

Arrays and Hashes
: Any array or hash is always true, including the empty array and empty hash.

Resource References
: Any resource reference is `true`, regardless of whether or not the resource it refers to has been evaluated, whether the resource exists, or whether the type exists.

Regular expressions
: A regular expression is always true.

* * *

Undef
-----

Puppet's special undef value is roughly equivalent to `nil` in Ruby; variables which have never been declared have a value of `undef`. Literal undef values must be the bare word `undef`.

The undef value is usually useful for testing whether a variable has been set. It can also be used as the value of a resource attribute, which can let you un-set any value inherited from a [resource default][resourcedefault] and cause the attribute to be unmanaged. 

When used as a boolean, `undef` is false.

* * *

Strings
-----

Strings are unstructured text fragments of any length. They may or may not be surrounded by quotation marks. Use single quotes for all strings that do not require variable interpolation, and double quotes for strings that do require variable interpolation or where control characters
or unicode characters are included via escapes.

### Bare Words

Bare (that is, not quoted) words are usually treated as single-word strings. To be treated as a string, a bare word must:

* Not be a [reserved word][reserved]
* Begin with a lower case letter, and contain only letters, digits, hyphens (-), and underscores (_).
  Bare words that begin with upper case letters are interpreted as data type references [resource references](#resource-references).
<!-- NOT SURE WHERE THE REFERENCE SHOULD GO - SHOULD BE TO DATATYPES IN GENERAL -->

Bare word strings are usually used with attributes that accept a limited number of one-word values, such as `ensure`.

### Single-Quoted Strings

Strings surrounded by single quotes `'like this'` do not interpolate variables, and the only escape sequences permitted are `\'` (a literal single quote) and `\\` (a literal backslash). Line breaks within the string are interpreted as literal line breaks.

Backslashes that are followed by any other character than single quote or backslash are
included in the resulting string together with the character they precede.

Note that:

* When a literal double backslash is intended, a quadruple backslash must be used.

### Double-Quoted Strings 

Strings surrounded by double quotes `"like this"` allow variable interpolation and several escape sequences. Line breaks within the string are interpreted as literal line breaks, and you can also insert line breaks by using the `\n` escape sequence.

#### Variable Interpolation

Any [`$variable`][variables] in a double-quoted string will be replaced with its value. To remove ambiguity about which text is part of the variable name, you can surround the variable name in curly braces:

{% highlight ruby %}
    path => "${apache::root}/${apache::vhostdir}/${name}",
{% endhighlight %}

#### Expression Interpolation

In a double-quoted string, you may interpolate the value of an arbitrary [expression][] (which may contain both variables and literal values) by putting it inside `${}` (a pair of curly braces preceded by a dollar sign):

{% highlight ruby %}
    file {'config.yml':  
      content => "...
    db_remote: ${ $clientcert !~ /^db\d+/ }
    ...",
      ensure => file,
    }
{% endhighlight %}

<!-- TODO: SHOULD DOCUMENT THE INTERPOLATION RULES AS IN THE LANGUAGE SPECIFICATION -->

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

Quoted strings may continue over multiple lines, and line breaks are preserved as a literal part of the string. 

Puppet does not attempt to convert line breaks, which means that the type of line break (Unix/LF or Windows/CRLF) used in the file will be preserved. You can also insert literal foreign line breaks into strings:

* To insert a CRLF in a manifest file that uses Unix line endings, use the `\r\n` escape sequences in a double-quoted string.
* To insert an LF in a manifest that uses Windows line endings, use the `\n` escape sequence in a double-quoted string.

### Encoding

Puppet treats strings as sequences of bytes. It does not recognize encodings or translate between them, and non-printing characters are preserved.

However, Puppet Labs recommends that all strings be valid UTF8. Future versions of Puppet may impose restrictions on string encoding, and using only UTF8 will protect you in this event. Additionally, PuppetDB will remove invalid UTF8 characters when storing catalogs. 

### Indexing / Substrings

You can access substrings of a string by the numerical index (counting from zero) of a character and an optional length or offset from the end. Square brackets are used for indexing and the start and
end are given as integer values. If no length is given, the default is 1 (a single character). Negative start position or lengths are interpreted as measured from the end. A length of -1 gives the length of the remainder of the string from the given start position.

Example:

{% highlight ruby %}
    $foo = 'abcdef'
    notice( $foo[0] )    # notices 'a'
    notice( $foo[0,2] )  # notices 'ab'
    notice( $foo[1,2] )  # notices 'bc'
    notice( $foo[1,-2] ) # notices 'bcde'
    notice( $foo[-3,2] ) # notices 'de'
{% endhighlight %}

All text at positions outside of the actual range of the string are treated as an infinite amount of empty string and the result is an empty string.

{% highlight ruby %}
    $foo = 'abcdef'
    notice( $foo[10] )    # notices ''
    notice( $foo[3,10] )  # notices 'def'
    notice( $foo[-10,2] ) # notices ''
    notice( $foo[-10,6] ) # notices 'ab'
{% endhighlight %}



### More control over String content

The heredoc expression provides additional control over the content of a string with respect
to escapes, line endings and multiple lines layout in source code.

<!-- TODO: REFERENCE TO HEREDOC -->

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

<!-- NOTE: resource references share the namespace with data types - a reference to a
resource type called something like 'integer' must be entered as Resource['integer', 'title'] to
refer to the resource type instead of the Integer data type. -->


### Multi-Resource References

Resource references with an **array of titles** or **comma-separated list of titles** refer to multiple resources of the same type and evaluates to an array of single title resource references:

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

Puppet's arithmetic expressions accept integers and floating point numbers. Integer values can be expressed in Octal notation (base 8), hexadecimal notation (base 16), and decimal (base 10). Octal values has a prefix of `0` and can be followed by a sequence of octal digits 0-7. Hexadecimal values a prefix of `0x` or `0X` and can be followed by hexadecimal digits 0-9, a-f, or A-F.

Numbers are written as bare words and may consist only of digits with an optional negative sign (`-`) and decimal point. 

{% highlight ruby %}
    $some_number = 8 * -7.992
    $another_number = $some_number / 4
{% endhighlight %}

Numbers **cannot** include explicit positive signs (`+`). Numbers between -1 and 1 **cannot** start with a bare decimal point; they must have a leading zero. Floating point numbers can be expressed in scientific notation using `e` or `E` to indicate that the preceding value is multiplied by 10 to the power of the value following the `E`.

{% highlight ruby %}
    $product = 8 * +4   # syntax error
    $product = 8 * 4    # OK
    $product = 8 * .12  # syntax error
    $product = 8 * 0.12 # OK
    $product = 8 * 3e5  # OK, (result is 240000.0)
{% endhighlight %}

Octal, Hexadecimal and decimal values:

{% highlight ruby %}
    # octal
    $value = 0777  # OK, octal
    $value = 0789  # Error, invalid octal
    
    # hexadecimal
    $value = 0x777 # OK
    $value = 0xdef # OK
    $value = 0Xdef # OK
    $value = 0xDEF # OK
    $value = 0xLSD # Error, invalid hex
    
    # decimal
    $value = 789   # OK, decimal

{% endhighlight %}

### Converting Number to String

Numbers are automatically converted to string notation when interpolated into a string. The
automatic conversion uses decimal (base 10) notation. The `printf` function should be used
to convert numbers to other string representations than decimal.

<!-- TODO: Examples, octal, hex, and floating point conversion -->

### Converting String to Number

Strings are not automatically converted to numbers. The `scanf` function can be used to
convert strings in different notations (and with extra textual content) to numbers.

<!-- TODO: Examples, octal, hex, and floating point conversion, and example like 10GB -->

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

Note that the opening square bracket must not be preceded by a white space when it
is used as an indexing operation:

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three', 'four', 'five' ]
    notice( $foo[2] )  # ok
    notice( $foo [2] ) # syntax error
{% endhighlight %}


### Array section

You can access a section of an array by the numerical index (counting from zero) of an element and a length or offset from the end. Square brackets are used for indexing and the start and
end are given as integer values. Negative start position or lengths are interpreted as measured from the end. A length of -1 gives the length of the remainder of the array from the given start position.

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three', 'four', 'five' ]
    notice( $foo[2,1] )  # notices ['three']
    notice( $foo[2,2] )  # notices ['three', 'four']
    notice( $foo[2,-1] ) # notices ['three', 'four', 'five']
    notice( $foo[-2,1] ) # notices ['four']
{% endhighlight %}

### Array Concatenation

Two arrays can be concatenated by using the `+` operator. This creates a new array with the content of the two arrays.

{% highlight ruby %}
    $foo = [ 'one', 'two']
    $bar = [ 'three', 'four', 'five' ]
    notice( $foo + $bar )  # notices [ 'one', 'two', 'three', 'four', 'five' ]

{% endhighlight %}

### Array Deletion

Elements can be deleted from an array using the `-` operator. This creates a new array where content in the left array that match content in the right operand have been left out in the resulting array.

{% highlight ruby %}
    notice( [1,2,3] - [1] )   # notices [ 2,3 ]
    notice( [1,2,3] - 1 )     # notices [ 2,3 ]
    notice( [1,1,2,3,1] - 1 ) # notices [ 2,3 ]
    notice( [1,2,3] - [1,2] ) # notices [ 3 ]
    notice( [1,2,3] - [5,6] ) # notices [ 1,2,3 ]
    
    notice( [[1],[2],[3]] - [1] )   # notices [[1],[2],[3]]
    notice( [[1],[2],[3]] - [[1]] ) # notices [[2],[3]]

{% endhighlight %}


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

<!-- TODO: The restrictions have been removed, regular expressions can be used everywhere syntactically, but may naturally not be accepted as a value just like a string may
not be expected if a number is expected. -->

Regular expressions (regexes) are Puppet's one **non-standard** data type. They cannot be assigned to variables, and they can only be used in the few places that specifically accept regular expressions. These places include: the `=~` and `!~` regex match operators, the cases in selectors and case statements, and the names of [node definitions][node_def]. They cannot be passed to functions or used in resource attributes. (Note that the [`regsubst` function][regsubst] takes a stringified regex in order to get around this.)

Regular expressions are written as [standard Ruby regular expressions](http://www.ruby-doc.org/core/Regexp.html) (valid for the version of Ruby being used by Puppet) and must be surrounded by forward slashes:

{% highlight ruby %}
    if $host =~ /^www(\d+)\./ {
      notify { "Welcome web server #$1": }
    }
{% endhighlight %}

Alternate forms of regex quoting are not allowed and Ruby-style variable interpolation is not available.

### Regex Options

Regexes in Puppet cannot have options or encodings appended after the final slash. However, you may turn options on or off for portions of the expression using the `(?<ENABLED OPTION>:<SUBPATTERN>)` and `(?-<DISABLED OPTION>:<SUBPATTERN>)` notation. The following example enables the `i` option while disabling the `m` and `x` options:

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

Note that the `match` function can be used to perform matching, and receive an array with
the matches result, and captures.


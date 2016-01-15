---
layout: default
title: "Language: Data Types"
canonical: "/puppet/latest/reference/lang_datatypes.html"
---


[local]: ./lang_scope.html#local-scopes
[conditional]: ./lang_conditional.html
[node]: ./lang_node_definitions.html
[attribute]: ./lang_resources.html#syntax
[regsubst]: /puppet/latest/reference/function.html#regsubst
[function]: ./lang_functions.html
[variables]: ./lang_variables.html
[expression]: ./lang_expressions.html
[if]: ./lang_conditional.html#if-statements
[comparison]: ./lang_expressions.html#comparison-operators
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[facts]: ./lang_variables.html#facts
[reserved]: ./lang_reserved.html#reserved-words
[attribute_override]: ./lang_resources.html#adding-or-modifying-attributes
[resourcedefault]: ./lang_defaults.html
[node_def]: ./lang_node_definitions.html
[relationship]: ./lang_relationships.html
[chaining]: ./lang_relationships.html#chaining-arrows
[mutable]: http://projects.puppetlabs.com/issues/16116

The Puppet language allows several data types as [variables][], [attribute][] values, and [function][] arguments:

Booleans
-----

The boolean type has two possible values: `true` and `false`. Literal booleans must be one of these two bare words (that is, not quoted).

The condition of an ["if" statement][if] is a boolean value. All of Puppet's [comparison expressions][comparison] return boolean values, as do many [functions][function].

### Automatic Conversion to Boolean

If a non-boolean value is used where a boolean is required, it will be automatically converted to a boolean as follows:

Strings
: Empty strings are false; all other strings are true. That means the string `"false"` actually resolves as true. **Warning: all [facts][] are strings in this version of Puppet, so "boolean" facts must be handled carefully.**

  > Note: the [puppetlabs-stdlib][stdlib] module includes a `str2bool` function which converts strings to boolean values more intelligently.

Numbers
: All numbers are true, including zero and negative numbers.

  > Note: the [puppetlabs-stdlib][stdlib] module includes a `num2bool` function which converts numbers to boolean values more intelligently.

Undef
: The special data type `undef` is false.

Arrays and Hashes
: Any array or hash is true, including the empty array and empty hash.

Resource References
: Any resource reference is true, regardless of whether or not the resource it refers to has been evaluated, whether the resource exists, or whether the type is valid.

Regular expressions cannot be converted to boolean values.

* * *

Undef
-----

Puppet's special undef value is roughly equivalent to nil in Ruby; variables which have never been declared have a value of `undef`. Literal undef values must be the bare word `undef`.

The undef value is usually useful for testing whether a variable has been set. It can also be used as the value of a resource attribute, which can let you un-set any value inherited from a [resource default][resourcedefault] and cause the attribute to be unmanaged.

When used as a boolean, `undef` is false.

* * *

Strings
-----

Strings are unstructured text fragments of any length. They may or may not be surrounded by quotation marks. Use single quotes for all strings that do not require variable interpolation, and double quotes for strings that do require variable interpolation.

### Bare Words

Bare (that is, not quoted) words are usually treated as single-word strings. To be treated as a string, a bare word must:

* Not be a [reserved word][reserved]
* Begin with a lower case letter, and contain only letters, digits, hyphens (-), and underscores (_).
  Bare words that begin with upper case letters are interpreted as [resource references](#resource-references).

Bare word strings are usually used with attributes that accept a limited number of one-word values, such as `ensure`.

### Single-Quoted Strings

Strings surrounded by single quotes `'like this'` do not interpolate variables. Only one escape sequence is permitted: `\'` (a literal single quote). Line breaks within the string are interpreted as literal line breaks.

**Any** backslash (`\`) not followed by a single quote is interpreted as a literal backslash. This means there's no way to end a single-quoted string with a backslash; if you need to refer to a string like `C:\Program Files(x86)\`, you'll have to use a double-quote string instead.

> **Note:** This behavior is different when the `parser` setting is set to `future`. In the future parser, lone backslashes are literal backslashes unless followed by a single quote or another backslash. That is:
>
> * When a backslash occurs at the very end of a single-quoted string, a double backslash must be used instead of a single backslash. For example: `path => 'C:\Program Files(x86)\\'`
> * When a literal double backslash is intended, a quadruple backslash must be used.


### Double-Quoted Strings

Strings surrounded by double quotes `"like this"` allow variable interpolation and several escape sequences. Line breaks within the string are interpreted as literal line breaks, and you can also insert line breaks by using the `\n` escape sequence.

#### Variable Interpolation

Any [`$variable`][variables] in a double-quoted string will be replaced with its value. To remove ambiguity about which text is part of the variable name, you can surround the variable name in curly braces:

~~~ ruby
    path => "${apache::root}/${apache::vhostdir}/${name}",
~~~

#### Expression Interpolation

> Note: This is not recommended.

In a double-quoted string, you may interpolate the value of an arbitrary [expression][] (which may contain both variables and literal values) by putting it inside `${}` (a pair of curly braces preceded by a dollar sign):

~~~ ruby
    file {'config.yml':
      content => "...
    db_remote: ${ $clientcert !~ /^db\d+/ }
    ...",
      ensure => file,
    }
~~~

This is of limited use, since most [expressions][expression] resolve to boolean or numerical values.

Behavioral oddities of interpolated expressions:

* You may not use bare word [strings](#strings) or [numbers](#numbers); all literal string or number values must be quoted. The behavior of bare words in an interpolated expression is undefined.
* Within the `${}`, you may use double or single quotes without needing to escape them.
* Interpolated expressions may not use [function calls][function] as operands.

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

### Line Breaks

Quoted strings may continue over multiple lines, and line breaks are preserved as a literal part of the string.

Puppet does not attempt to convert line breaks, which means that the type of line break (Unix/LF or Windows/CRLF) used in the file will be preserved. You can also insert literal foreign line breaks into strings:

* To insert a CRLF in a manifest file that uses Unix line endings, use the `\r\n` escape sequences in a double-quoted string.
* To insert an LF in a manifest that uses Windows line endings, use the `\n` escape sequence in a double-quoted string.

### Encoding

Puppet treats strings as sequences of bytes. It does not recognize encodings or translate between them, and non-printing characters are preserved.

However, Puppet Labs recommends that all strings be valid UTF8. Future versions of Puppet may impose restrictions on string encoding, and using only UTF8 will protect you in this event. Additionally, PuppetDB will remove invalid UTF8 characters when storing catalogs.

* * *

Resource References
-----

Resource references identify a specific existing Puppet resource by its type and title. Several attributes, such as the [relationship][] metaparameters, require resource references.

~~~ ruby
    # A reference to a file resource:
    subscribe => File['/etc/ntp.conf'],
    ...
    # A type with a multi-segment name:
    before => Concat::Fragment['apache_port_header'],
~~~

The general form of a resource reference is:

* The resource **type,** capitalized (every segment must be capitalized if the type includes a namespace separator \[`::`\])
* An opening square bracket
* The **title** of the resource, or a comma-separated list of titles
* A closing square bracket

Unlike variables, resource references are not parse-order dependent, and can be used before the resource itself is declared.

### Multi-Resource References

Resource references with an **array of titles** or **comma-separated list of titles** refer to multiple resources of the same type:

~~~ ruby
    # A multi-resource reference:
    require => File['/etc/apache2/httpd.conf', '/etc/apache2/magic', '/etc/apache2/mime.types'],
    # An equivalent multi-resource reference:
    $my_files = ['/etc/apache2/httpd.conf', '/etc/apache2/magic', '/etc/apache2/mime.types']
    require => File[$my_files]
~~~

They can be used wherever an array of references might be used. They can also go on either side of a [chaining arrow][chaining] or receive a [block of additional attributes][attribute_override].


* * *

Numbers
-----

Puppet's arithmetic expressions accept integers and floating point numbers. Internally, Puppet treats numbers like strings until they are used in a numeric context.

Numbers can be written as bare words or quoted strings, and may consist only of digits with an optional negative sign (`-`) and decimal point.

~~~ ruby
    $some_number = 8 * -7.992
    $another_number = $some_number / 4
~~~

Numbers **cannot** include explicit positive signs (`+`) or exponents. Numbers between -1 and 1 **cannot** start with a bare decimal point; they must have a leading zero.

~~~ ruby
    $product = 8 * +4 # syntax error
    $product = 8 * 4 # OK
    $product = 8 * .12 # syntax error
    $product = 8 * 0.12 # OK
~~~

* * *

Arrays
-----

Arrays are written as comma-separated lists of items surrounded by square brackets. An optional trailing comma is allowed between the final value and the closing square bracket.

~~~ ruby
    [ 'one', 'two', 'three' ]
    # Equivalent:
    [ 'one', 'two', 'three', ]
~~~

The items in an array can be any data type, including hashes or more arrays.

Resource attributes which can optionally accept multiple values (including the relationship metaparameters) expect those values in an array.

### Indexing

You can access items in an array by their numerical index (counting from zero). Square brackets are used for indexing.

Example:

~~~ ruby
    $foo = [ 'one', 'two', 'three' ]
    notice( $foo[1] )
~~~

This manifest would log `two` as a notice. (`$foo[0]` would be `one`, since indexing counts from zero.)

Nested arrays and hashes can be accessed by chaining indexes:

~~~ ruby
    $foo = [ 'one', {'second' => 'two', 'third' => 'three'} ]
    notice( $foo[1]['third'] )
~~~

This manifest would log `three` as a notice. (`$foo[1]` is a hash, and we access a key named `'third'`.)

Arrays support negative indexing, with `-1` being the final element of the array:

~~~ ruby
    $foo = [ 'one', 'two', 'three', 'four', 'five' ]
    notice( $foo[2] )
    notice( $foo[-2] )
~~~

The first notice would log `three`, and the second would log `four`.

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

~~~ ruby
    { key1 => 'val1', key2 => 'val2' }
    # Equivalent:
    { key1 => 'val1', key2 => 'val2', }
~~~

Hash keys are strings, but hash values can be any data type, including arrays or more hashes.

### Indexing

You can access hash members with their key; square brackets are used for indexing.

~~~ ruby
    $myhash = { key       => "some value",
                other_key => "some other value" }
    notice( $myhash[key] )
~~~

This manifest would log `some value` as a notice.

Nested arrays and hashes can be accessed by chaining indexes:

~~~ ruby
    $main_site = { port        => { http  => 80,
                                    https => 443 },
                   vhost_name  => 'docs.puppetlabs.com',
                   server_name => { mirror0 => 'warbler.example.com',
                                    mirror1 => 'egret.example.com' }
                 }
    notice ( $main_site[port][https] )
~~~

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

~~~ ruby
    if $host =~ /^www(\d+)\./ {
      notify { "Welcome web server #$1": }
    }
~~~

Alternate forms of regex quoting are not allowed and Ruby-style variable interpolation is not available.

### Regex Options

Regexes in Puppet cannot have options or encodings appended after the final slash. However, you may turn options on or off for portions of the expression using the `(?<ENABLED OPTION>:<SUBPATTERN>)` and `(?-<DISABLED OPTION>:<SUBPATTERN>)` notation. The following example enables the `i` option while disabling the `m` and `x` options:

~~~ ruby
     $packages = $operatingsystem ? {
       /(?i-mx:ubuntu|debian)/        => 'apache2',
       /(?i-mx:centos|fedora|redhat)/ => 'httpd',
     }
~~~

The following options are allowed:

* i --- Ignore case
* m --- Treat a newline as a character matched by `.`
* x --- Ignore whitespace and comments in the pattern

### Regex Capture Variables

Within [conditional statements][conditional] that use regexes (but **not** [node definitions][node] that use them), any captures from parentheses in the pattern will be available inside the associated value as numbered variables (`$1, $2`, etc.), and the entire match will be available as `$0`.

These are not normal variables, and have some special behaviors:

* The values of the numbered variables do not persist outside the code block associated with the pattern that set them.
* In nested conditionals, each conditional has its own set of values for the set of numbered variables. At the end of an interior statement, the numbered variables are reset to their previous values for the remainder of the outside statement. (This causes conditional statements to act like [local scopes][local], but only with regard to the numbered variables.)

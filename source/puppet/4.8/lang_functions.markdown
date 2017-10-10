---
title: "Language: Functions"
layout: default
canonical: "/puppet/latest/lang_functions.html"
---

[func_ref]: ./function.html
[forge]: https://forge.puppetlabs.com
[custom]: /guides/custom_functions.html
[stdlib]: https://forge.puppetlabs.com/puppetlabs/stdlib
[resource]: ./lang_resources.html
[custom_facts]: {{facter}}/custom_facts.html
[datatype]: ./lang_data.html
[catalog]: ./lang_summary.html#compilation-and-catalogs
[lambda]: ./lang_lambdas.html
[expression]: ./lang_expressions.html
[template]: ./function.html#template
[include]: ./function.html#include
[each]: ./function.html#each
[splat]: ./lang_expressions.html#splat

Functions are plugins written in Ruby, which you can call during [compilation][catalog]. A call to any function is an [expression][] that resolves to a value.

Most functions take one or more values as arguments, then return some other, resulting value. The Ruby code in the function can do any number of things to produce the final value, including evaluating templates, doing math, and looking up values from an external source.

Functions may also:

* Cause side effects that modify the [catalog][]
* Evaluate a provided block of Puppet code, possibly using the function's arguments to modify that code or control how it runs.

Puppet includes several built-in functions, and more are available in modules on the [Puppet Forge][forge], particularly the [puppetlabs-stdlib][stdlib] module. You can also write [custom functions][custom] and put them in your own modules.

## Location


Like any [expression][], a function call can be used anywhere the value it returns would be allowed.

Function calls can also stand on their own, which will cause their value to be ignored. (Any side effects will still occur.)

## Syntax


There are two ways to call functions in the Puppet language: classic **prefix calls** like `template("ntp/ntp.conf.erb")`, and **chained calls** like `"ntp/ntp.conf.erb".template`. There's also a modified form of prefix call that can only be used with certain functions.

### Choosing a call style

These two call styles have the exact same capabilities, so you can choose whichever one is more readable. In general:

* For functions that take many arguments, prefix calls are easier to read.
* For functions that take one normal argument and a lambda, chained calls are easier to read.
* For a series of functions where each takes the last one's result as its argument, chained calls are easier to read.
    * This goes double if at least one of those functions accepts a [lambda][].

For other cases, tastes vary, so do whatever you prefer.

### Function names

Most functions have short, one-word names. However, the modern function API also allows qualified function names like `mymodule::foo`.

Functions must always be called with their full names; you can't shorten a qualified function name.

### Prefix function calls

You can call a function by writing its name and providing a list of arguments in parentheses.

``` puppet
file {"/etc/ntp.conf":
  ensure  => file,
  content => template("ntp/ntp.conf.erb"), # function call; resolves to a string
}

include apache # function call; modifies catalog

$binaries = [
  "facter",
  "hiera",
  "mco",
  "puppet",
  "puppetserver",
]

# function call with lambda; runs block of code several times
each($binaries) |$binary| {
  file {"/usr/bin/$binary":
    ensure => link,
    target => "/opt/puppetlabs/bin/$binary",
  }
}
```

{% capture about_examples %}
In the examples above, [`template`][template], [`include`][include], and [`each`][each] are all functions. `template` is used for its return value, `include` adds a class to the catalog, and `each` runs a block of code several times with different values.
{% endcapture %}

{{ about_examples }}

The general form of a prefix function call is:

    name(argument, argument, ...) |$parameter, $parameter, ...| { code block }

* The full name of the function, as an unquoted word.
* An opening parenthesis (`(`).
    * Parentheses are optional when calling a [_built-in statement function_][inpage_statement] with at least one argument (like `include apache`). They're mandatory in all other cases.
* Zero or more **arguments,** separated with commas. Arguments can be any [expression][] that resolves to a value. See each function's docs for the number of its arguments and their [data types][datatype].
    * Note that [the `*` (splat) array operator][splat] can convert an array to a comma-separated list of arguments.
* A closing parenthesis (`)`), if an opening parenthesis was used.
* Optionally, a [lambda][] (code block), if the function accepts one.



### Chained function calls

You can also call a function by writing its first argument, a period, and the name of the function.

``` puppet
file {"/etc/ntp.conf":
  ensure  => file,
  content => "ntp/ntp.conf.erb".template, # function call; resolves to a string
}

apache.include # function call; modifies catalog

$binaries = [
  "facter",
  "hiera",
  "mco",
  "puppet",
  "puppetserver",
]

# function call with lambda; runs block of code several times
$binaries.each |$binary| {
  file {"/usr/bin/$binary":
    ensure => link,
    target => "/opt/puppetlabs/bin/$binary",
  }
}
```

{{ about_examples }}

The general form of a chained function call is:

    argument.name(argument, ...) |$parameter, $parameter, ...| { code block }

* The **first argument** of the function, which can be any [expression][] that resolves to a value.
* A period (`.`).
* The full name of the function, as an unquoted word.
* Optionally, parentheses containing a comma-separated list of **additional arguments,** starting with the _second_ argument.
    * Note that [the `*` (splat) array operator][splat] can convert an array to a comma-separated list of arguments.
* Optionally, a [lambda][] (code block), if the function accepts one.



## Behavior


An entire function call (including the name, arguments, and lambda) constitutes an [expression][]. It will resolve to a single value, and can be used anywhere a value of that type is accepted.

A function call may also result in some side effect, in addition to returning a value.

All functions run during [compilation][catalog], which means they can only access code and data available on the Puppet master. To make changes to an agent node, you must use a [resource][]; to collect data from an agent node, you must use a [custom fact][custom_facts].


## Documentation for functions


Each function defines how many arguments it takes, what [data types][datatype] it expects those arguments to be, what values it returns, and any side effects it has. Thus, each function has its own docs.

For info about any _built-in_ function, [see the Function Reference.][func_ref]

For info about a function included in a module, see that module's documentation.


## List of built-in statement functions


[inpage_statement]: #list-of-built-in-statement-functions

"Statement functions" are a group of built-in functions that are used only for their side effects. This version of the language only recognizes Puppet's built-in statements; it doesn't allow adding new statement functions as plugins.

The only real difference between statement functions and other functions is that you can omit parentheses when calling a statement function with at least one argument (e.g. `include apache`).

Statement functions return a value like any other function, but will always return a value of `undef`.

The built-in statement functions are:

### Catalog statements

* [`include`](./function.html#include) --- includes given classes in catalog
* [`require`](./function.html#require) --- includes given classes in the catalog and adds them as a dependency of the current class or defined resource
* [`contain`](./function.html#contain) --- includes given classes in the catalog and contains them in the current class
* [`realize`](./function.html#realize) --- makes a virtual resource real
* [`tag`](./function.html#tag) --- adds the specified tag(s) to the containing class or defined resource

### Logging statements

* [`debug`](./function.html#debug) --- logs message at debug level
* [`info`](./function.html#info) --- logs message at info level
* [`notice`](./function.html#notice) --- logs message at notice level
* [`warning`](./function.html#warning) --- logs message at warning level
* [`err`](./function.html#err) --- logs message at error level

Although there are a few additional logging functions, they cannot be called as statements.

### Failure statements

* [`fail`](./function.html#fail) --- logs error message and aborts compilation

---
title: "Future Parser: Functions"
layout: default
canonical: "/puppet/latest/reference/future_lang_functions.html"
---

[func_ref]: /references/latest/function.html
[forge]: http://forge.puppetlabs.com
[custom]: /guides/custom_functions.html
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[resource]: ./future_lang_resources.html
[custom_facts]: /facter/latest/custom_facts.html
[datatype]: ./future_lang_data.html
[catalog]: ./future_lang_summary.html#compilation-and-catalogs

> * [See the Function Reference for complete info about Puppet's built-in functions.][func_ref]

**Functions** are pre-defined chunks of Ruby code which run during [compilation][catalog]. Most functions either **return values** or **modify the [catalog][].**

Puppet includes several built-in functions, and more are available in modules on the [Puppet Forge][forge], particularly the [puppetlabs-stdlib][stdlib] module. You can also write [custom functions][custom] and put them in your own modules.

Syntax
-----

{% highlight ruby %}
    file {'/etc/ntp.conf':
      ensure  => file,
      content => template('ntp/ntp.conf'),
    }

    include apache2

    if str2bool("$is_virtual") {
      include ntp::disabled
    }
    else {
      include ntp
    }
    # str2bool is part of the puppetlabs-stdlib module; install it with
    # sudo puppet module install puppetlabs-stdlib
{% endhighlight %}

In the examples above, `template`, `include`, and `str2bool` are all functions. `template` and `str2bool` return values, and `include` modifies the catalog by causing a class to be applied.

The general form of a function call is:

* The name of the function, as a bare word.
    * Note that the modern function API allows qualified function names like `mymodule::foo`. Functions must be called with their full names.
* An opening parenthesis.
    * Parentheses are optional when calling a built-in statement function with at least one argument (like `include apache`). They're mandatory in all other cases.
* Any number of **arguments,** separated with commas.
    * Arguments can be any expression that resolves to a value.
    * The number of arguments and their data types are determined by the function. See the function's docs for details.
* A closing parenthesis, if an open parenthesis was used
* An optional parameterized code block (lambda) if the function supports this


Behavior
-----

There are two kinds of Puppet functions:

* **Rvalues** return values and can be used anywhere a normal value is expected. (This includes resource attributes, variable assignments, conditions, selector values, the arguments of other functions, etc.) These values can come from a variety of places; the `template` function reads and evaluates a template to return a string, and stdlib's `str2bool` and `num2bool` functions convert values from one [data type][datatype] to another.
* **Statements** stand alone and do some form of work, which can be anything from logging a message (like `notice`), to modifying the catalog in progress (like `include`), to causing the entire compilation to fail (`fail`). Statements always return `undef`.

All functions run during [compilation][catalog], which means they can only access the commands and data available on the Puppet master. To perform tasks on, or collect data from, an agent node, you must use a [resource][] or a [custom fact][custom_facts].

### Arguments

Each function defines how many arguments it takes and what [data types][datatype] it expects those arguments to be. The [function reference][func_ref] has all the info you need to use the built-in functions. For plugin functions, see the docs of the module that installed the function.

Functions can accept values any of Puppet's standard [data types][datatype] as arguments.

List of Statement Functions
-----

This version of the Puppet language only recognizes Puppet's built-in statements; it doesn't allow adding new statement functions as plugins.

The built-in statement functions are:

#### Catalog Statements

* [`include`](/references/3.7.latest/function.html#include) --- includes given class(es) in catalog
* [`require`](/references/3.7.latest/function.html#require) --- includes given class(es) in the catalog and adds them as a dependency of the current class or defined resource
* [`contain`](/references/3.7.latest/function.html#contain) --- includes given class(es) in the catalog and contains them in the current class
* [`realize`](/references/3.7.latest/function.html#realize) --- makes a virtual resource real
* [`tag`](/references/3.7.latest/function.html#tag) --- adds the specified tag(s) to the containing class or definition

#### Logging Statements

* [`debug`](/references/3.7.latest/function.html#debug) --- logs message at debug level
* [`info`](/references/3.7.latest/function.html#info) --- logs message at info level
* [`notice`](/references/3.7.latest/function.html#notice) --- logs message at notice level
* [`warning`](/references/3.7.latest/function.html#warning) --- logs message at warning level
* [`error`](/references/3.7.latest/function.html#error) --- logs message at error level

#### Failure Statements

* [`fail`](/references/3.7.latest/function.html#fail) --- logs error message and aborts compilation

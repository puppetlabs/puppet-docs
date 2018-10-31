---
title: "Language: Functions"
layout: default
canonical: "/puppet/latest/reference/lang_functions.html"
---

[func_ref]: ./function.html
[forge]: http://forge.puppetlabs.com
[custom]: ./functions_legacy.html
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[resource]: ./lang_resources.html
[custom_facts]: {{facter}}/custom_facts.html
[datatype]: ./lang_datatypes.html
[catalog]: ./lang_summary.html#compilation-and-catalogs

> * [See the Function Reference for complete info about Puppet's built-in functions.][func_ref]

**Functions** are pre-defined chunks of Ruby code which run during [compilation][catalog]. Most functions either **return values** or **modify the [catalog][].**

Puppet includes several built-in functions, and more are available in modules on the [Puppet Forge][forge], particularly the [puppetlabs-stdlib][stdlib] module. You can also write [custom functions][custom] and put them in your own modules.

Syntax
-----

~~~ ruby
    file {'/etc/ntp.conf':
      ensure  => file,
      content => template('ntp/ntp.conf'),
    }

    include apache2

    if str2bool($is_virtual) {
      include ntp::disabled
    }
    else {
      include ntp
    }
    # str2bool is part of the puppetlabs-stdlib module; install it with
    # sudo puppet module install puppetlabs-stdlib
~~~

In the examples above, `template`, `include`, and `str2bool` are all functions. `template` and `str2bool` return values, and `include` modifies the catalog by causing a class to be applied.

The general form of a function call is:

* The name of the function, as a bare word
* An opening parenthesis, which is optional for statements but mandatory for rvalues
* Any number of **arguments,** separated with commas; the number and type of arguments are controlled by the function
* A closing parenthesis, if an open parenthesis was used

Behavior
-----

There are two types of Puppet functions:

* **Rvalues** return values and can be used anywhere a normal value is expected. (This includes resource attributes, variable assignments, conditions, selector values, the arguments of other functions, etc.) These values can come from a variety of places; the `template` function reads and evaluates a template to return a string, and stdlib's `str2bool` and `num2bool` functions convert values from one [data type][datatype] to another.
* **Statements** should stand alone and do some form of work, which can be anything from logging a message (like `notice`), to modifying the catalog in progress (like `include`), to causing the entire compilation to fail (`fail`). Statements do not return usable values.

All functions run during [compilation][catalog], which means they can only access the commands and data available on the Puppet master. To perform tasks on, or collect data from, an agent node, you must use a [resource][] or a [custom fact][custom_facts].

### Arguments

Each function defines how many arguments it takes and what [data types][datatype] it expects those arguments to be. These should be documented in the function's `:doc` string, which can be extracted and included in the [function reference][func_ref].

Functions may accept any of Puppet's standard [data types][datatype]. The values passed to the function's Ruby code will be converted to Ruby objects as follows:

Puppet type        | Ruby type
-------------------|----------
boolean            | boolean
undef              | the empty string
string             | string
resource reference | `Puppet::Resource`
number             | string
array              | array
hash               | hash


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
[datatype]: ./future_lang_datatypes.html
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

    if str2bool($is_virtual) {
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

* The name of the function, as a bare word
* An opening parenthesis
  * always required if no arguments are to be given to the function
  * is optional for built in statements but mandatory for rvalues
* Any number of **arguments,** separated with commas; the number and type of arguments are controlled by the function
* A closing parenthesis, if an open parenthesis was used
* An optional parameterized code block (lambda) if the function supports this

Note that the new function API allows functions to have qualified names and these must be
called using the full name. As an example, if there is a function named `mymodule::foo` in `mymodule`, it is called like this:

{% highlight ruby %}
    mymodule::foo()
{% endhighlight %}

### Chained calls

Puppet supports an alternative infix notation for chained calls. This is mostly useful for chaining
iterative functions (e.g. `each`, `map`, `filter`, but may be used to call any function. The syntax for this type of call is:

* Any expression (which becomes the first argument to the function)
* A period (.)
* The name of the function as a bare word
* An opening parenthesis
  * optional if no *additional* arguments are passed
* Any number of additional **arguments,** separated with commas; the number and type of arguments are controlled by the function
* A closing parenthesis, if an open parenthesis was used
* An optional parameterized code block (lambda) if the function supports this

As an example, the stdlib function `uniq` removes duplicate entries from an array, and
the function `flatten` makes a single flat array out of an array with nested arrays. To perform both operations on the same array (first `flatten`, then `uniq`)- they would be called like this without chaining:

{% highlight ruby %}

    $the_array = [1, 2, 3, 1, [1, 2]]
    uniq(flatten($the_array)) # resolves to [1,2,3]
{% endhighlight %}

And called like this with chained infix notation:

{% highlight ruby %}

    $the_array = [1, 2, 3, 1, [1, 2]]
    $the_array.flatten.uniq # resolves to [1,2,3]
{% endhighlight %}

With this notation, the left hand side value always becomes the first argument to the function.
Thus, when chained, the *result* of the first call (`uniq`) becomes the first argument in the second call (`flatten`), etc.

While the readability of the two examples above is more or less the same, when writing more advanced calls using code blocks, it is easier to read the logic from top to bottom/left to right than when calls are written in traditional nested fashion.

The examples below turns a list of user names given as first name, last name in a string (e.g. 'Fozzie Bear') into short form user names using a policy that (up to) two characters from the first name, and (up to) seven characters from the last name forms the user name to use on a system. Thus 'Fozzie Bear' becomes 'fobear'. (The examples use the `split` function from stdlib which splits
a string into an array of strings (in the example the string is split into first name, and last name), and the iterative function reduce that takes multiple elements and transforms them into one).

First, **using chained call notation**:

{% highlight ruby %}

    $users = ['Fozzie Bear', 'Miss Piggy', 'Bunsen Honeydew']
    $users.map |$name| {
      $name
        .downcase
        .split(/ /)
        .reduce |$first, $second| {
          # up to two letters from first name, and up to 7 from last
          "${first[0,2]}${second[0,7]}"
        }
      }.each |$name| {
        notice $name
   }
{% endhighlight %}

As you can see, it is possible to break up sequences like `$name.downcase.split(/ /)` on
multiple lines. When reading this to yourself, you can read "take $name", "then downcase", "then split", "then reduce".


Secondly, **using nested calls notation** (here it takes a bit more effort to mentally associate
the last block with the correct function call (`each`) since it is now the outermost
call in the "chain" of calls:

{% highlight ruby %}

    $users = ['Fozzie Bear', 'Miss Piggy', 'Bunsen Honeydew']
    each(map($users) |$name| {
      reduce(split(downcase($name), / /)) |$first, $second| {
        # up to two letters from first name, and up to 7 from last
        "${first[0,2]}${second[0,7]}"
      }}) |$name| {
      notice $name
    }

{% endhighlight %}


Behavior
-----

There are two types of Puppet functions:

* **Rvalues** return values and can be used anywhere a normal value is expected. (This includes resource attributes, variable assignments, conditions, selector values, the arguments of other functions, etc.) These values can come from a variety of places; the `template` function reads and evaluates a template to return a string, and stdlib's `str2bool` and `num2bool` functions convert values from one [data type][datatype] to another.
* **Statements** stands alone and do some form of work, which can be anything from logging a message (like `notice`), to modifying the catalog in progress (like `include`), to causing the entire compilation to fail (`fail`). Statements always returns `undef`. The set of statement functions are limited to a set of functions built in to puppet:

| Statement Function | Description
| ---                | ---
| require  | includes given class(es) in the catalog and adds them as a dependency
| realize  | makes a virtual object real
| include  | includes given class(es) in catalog
| contain  | contains one or more classes in the current class
| tag      | adds the specified tag(s) to the containing class or definition
|
| debug    | logs message at debug level
| info     | logs message at info level
| notice   | logs message at notice level
| warning  | logs message at warning level
| error    | logs message at error level
|
| fail     | logs error message and aborts compilation


All functions run during [compilation][catalog], which means they can only access the commands and data available on the puppet master. To perform tasks on, or collect data from, an agent node, you must use a [resource][] or a [custom fact][custom_facts].

### Arguments

Each function defines how many arguments it takes and what [data types][datatype] it expects those arguments to be. When writing a 3x function these should be documented in the function's `:doc` string, which can be extracted and included in the [function reference][func_ref]. When writing a function using the 4x function API, parameters are typed the same way as for parameters to defines and classes (using the Puppet Type System). The Puppet PDoc tool can extract these 4x type declarations and include them in the produced [function reference][func_ref].

<!-- TODO: Reference to Puppet Type System, and to docs for 3x and 4x functions in text above -->

Functions may accept any of Puppet's standard [data types][datatype]. The values passed to the function's Ruby code will be converted to Ruby objects as follows:

In Ruby code implementing a function using the 3x API:

Puppet type          | Ruby type
-------------------  |----------
`Boolean`            | `Boolean`
`Undef`              | '' (empty `String`), but not in nested constructs where it is `NilClass`
`String`             | `String`
Resource reference   | `Puppet::Resource`
`Numeric`            | subtype of `Numeric`
`Array`              | `Array`
`Hash`               | `Hash`
`Default`            | `Symbol` (value `:default`)
`Regexp`             | `Regexp`
code block           | `Puppet::Pops::Evaluator::Closure`
types                | type class in `Puppet::Pops::Types` e.g. `PIntegerType`

In Ruby code implementing a function using the 4x API:

Puppet type          | Ruby type
-------------------  |----------
`Boolean`            | `Boolean`
`Undef`              | `NilClass`
String               | `String`
Resource reference   | `Puppet::Pops::Types::PResourceType`, or `Puppet::Pops::Types::PHostClassType`
`Numeric`            | subtype of `Numeric`
`Array`              | `Array`
`Hash`               | `Hash`
`Default`            | `Symbol` (value `:default`)
`Regexp`             | `Regexp`
code block           | `Puppet::Pops::Evaluator::Closure`
types                | type class in `Puppet::Pops::Types` e.g. `PIntegerType`

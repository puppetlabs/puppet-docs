---
title: "Language: Functions"
layout: default
---

<!-- TODO -->
[func_ref]: /references/latest/function.html
[compilation]: ./lang_summary.html#compilation
[forge]: http://forge.puppetlabs.com
[custom]: /guides/custom_functions.html
[stdlib]: 
[resource]: 
[custom_facts]: 
[datatype]: 

* [See the Function Reference for complete info about Puppet's built-in functions.][func_ref]

**Functions** are pre-defined chunks of Ruby code which run during [compilation][]. Most functions either **return values** or **modify the catalog.**

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
* An optional opening parenthesis
* Any number of **arguments,** separated with commas; the number and type of arguments are controlled by the function
* A closing parenthesis, if an open parenthesis was used

Behavior
-----

There are two types of Puppet functions:

* **Rvalues** return values, and can be used anywhere a normal value is expected. (This includes resource attributes, variable assignments, conditions, selector values, the arguments of other functions, etc.) These values can come from a variety of places; the `template` function reads and evaluates a template to return a string, and stdlib's `str2bool` and `num2bool` functions convert values from one [data type][datatype] to another.
* **Statements** should stand alone, and do some form of work, which can be anything from logging a message (like `notice`), to modifying the catalog in progress (like `include`), to causing the entire compilation to fail (`fail`). 

All functions run during [compilation][], which means they can only access the commands and data available on the puppet master. To do perform tasks on or collect data from an agent node, you must use a [resource][] or a [custom fact][custom_facts]. 


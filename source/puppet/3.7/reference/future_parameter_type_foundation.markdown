---
layout: default
title: "Future Parser: Foundations of the Parameter Type System"
canonical: "/puppet/latest/reference/future_parameter_type_foundation.html"
---


Foundations of the Puppet Type System:
=====================================

The future parser includes support for explicit data type annotations in the parameter lists of classes
and defined types. Puppet's explicit parameter type declarations help you:

- Make it clear what values are acceptable for a given parameter
- Write more concise code by eliminating boilerplate type assertions
- Avoid mysterious errors and bugs by catching type errors early

Unlike compiled languages like C and Haskell, Puppet only checks types *at runtime*. That means they can
express much more specific requirements (like the minimum or maximum length of a string), but the trade-off
is that there's no check for type errors ahead of time.


Type Declarations are Simplified Type Assertions
------------------------------------------------

Take a look at this abridged example from the [puppetlabs-puppetdb](https://forge.puppetlabs.com/puppetlabs/puppetdb):

{% highlight ruby %}
class puppetdb::server(
  $puppetdb_service_status = $puppetdb::params::puppetdb_service_status,
  ) {
  
  # Validate puppetdb_service_status
  if !($puppetdb_service_status in ['true', 'running', 'false', 'stopped']) {
    fail("puppetdb_service_status valid values are 'true', 'running', 'false', and 'stopped'. You provided '${puppetdb_service_status}'")
  }
  # ...
}
{% endhighlight %}

The above example checks that `$puppetdb_service_status` is exactly equal to one of: `'true'`, `'running'`, `'false'`, or `'stopped'` -- failing compilation otherwise. This pattern is extremely common, but it has three significant drawbacks: first, it separates important information about the parameter into two different parts of the code (the parameter list and the body of the class). The second problem is that it takes a surprisingly large amount of code to accomplish a fairly simple validation. Finally, this is classic *boilerplate* -- repetitive, mostly fixed code that crops up over and over again.

Here's what happens when we re-write the above example using type annotations:

{% highlight ruby %}
class puppetdb::server(
  Enum['true','running','false','stopped'] $puppetdb_service_status = $puppetdb::params::puppetdb_service_status,
  ) {
  
  # ...
}
{% endhighlight %}

We now have a single line that not only tells us everything we need to know about this parameter (its name, possible values, and default value), but also does the validation automatically. In exchange, we've given up control over the error message that appears when there's an incorrect value. If we try to apply the class using `true` instead of `'true'`, we'll get this error message:

    Error: Expected parameter 'puppetdb_server_status' of 'Class[Puppetdb::Server]' to have type Enum['true', 'running', 'false', 'stopped'], got Boolean at ...

That should be adequate for most (if not all) purposes, but keep in mind that you can't override the message in a type error.


Syntax
------

Type annotations use a simple, consistent syntax: an uppercase type name, optionally followed by a set of square brackets containing some number of type parameters. Some types take other types as parameters (e.g., `Optional`). The following are all valid examples:

* `String $my_string` (matches any string)
* `String[8,default] $password` (matches any string containing at least 8 characters)
* `Optional[String[8,default]] $password` (matches above *or* `undef`)
* `Integer[0,255] $mode` (matches any integer between 0 and 255, inclusive)
* `Any $var` (matches any value at all, including `undef`)


Limitations
-----------

### Checking is Only Done at Runtime

A lot of the power of Puppet's type system comes from the fact that it doesn't do the type checking until the parameters are given their final values.

{% highlight ruby %}
class odd_class (Integer $param = false) {
  # better not try to use that default value...
  notice $param
}

class {'odd_class':
  param => 42,
}
{% endhighlight %}

There are two things to notice about the above code:

1. The default value for `$param` doesn't match its type (Boolean vs Integer).
2. The manifest runs anyway, because the default for `$param` gets overridden.

So Puppet's type-checking only ensures that there are no type errors *in a given catalog*. It won't catch errors that, for whatever reason,
don't affect the catalog in question.

### Writing Your own Error Messages

Here's that re-written example from [puppetlabs-puppetdb](https://forge.puppetlabs.com/puppetlabs/puppetdb) again, with a twist:

{% highlight ruby %}
class puppetdb::server(
  Enum['true','running','false','stopped'] $puppetdb_service_status = $puppetdb::params::puppetdb_service_status,
  ) {
  
  # ...
}

class {'puppetdb::server':
  puppetdb_service_status => true,
}
{% endhighlight %}

The class is expecting a string, but `true` (without quotes) is a boolean, so in this case we'll get the following error message:

    Error: Expected parameter 'puppetdb_server_status' of 'Class[Puppetdb::Server]' to have type Enum['true', 'running', 'false', 'stopped'], got Boolean at ...

That should be adequate for most purposes, but if you'd rather throw your own error message, you can do that by asserting the type separately from the parameter declaration:

{% highlight ruby %}
class puppetdb::server(
  $puppetdb_service_status = $puppetdb::params::puppetdb_service_status,
  ) {
  assert_type(Enum['true','running','false','stopped'], $puppetdb_service_status) |$expected, $actual| { fail("Valid choices for puppetdb_service_status are 'true', 'running', 'false', or 'stopped', not: ${actual}") }
  
  # ...
}

class {'puppetdb::server':
  puppetdb_service_status => true,
}
{% endhighlight %}

See the documentation for [assert_type](function.html#asserttype) for more information.

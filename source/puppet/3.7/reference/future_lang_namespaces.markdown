---
layout: default
title: "Future Parser: Namespaces and Autoloading"
canonical: "/puppet/latest/reference/future_lang_namespaces.html"
---

[classes]: ./future_lang_classes.html
[define]: ./future_lang_defined_types.html
[import]: ./future_lang_import.html
[variables]: ./future_lang_variables.html
[modulepath]: ./modules_fundamentals.html#the-modulepath
[module]: ./modules_fundamentals.html
[scopes]: ./future_lang_scope.html
[include]: ./future_lang_classes.html#using-include
[PUP-121]: https://tickets.puppetlabs.com/browse/PUP-121
[inherits]: ./future_lang_classes.html#inheritance
[allowed]: ./future_lang_reserved.html#classes-and-types
[relative_below]: #aside-historical-context


[Class][classes] and [defined type][define] names may be broken up into segments called **namespaces.** Namespaces tell the autoloader how to find the class or defined type in your [modules][module].

Syntax
-----

Puppet [class][classes] and [defined type][define] names may consist of any number of namespace segments separated by the `::` (double colon) namespace separator. (This separator is analogous to the `/` \[slash\] in a file path.)

{% highlight ruby %}
    class apache { ... }
    class apache::mod { ... }
    class apache::mod::passenger { ... }
    define apache::vhost { ... }
{% endhighlight %}

Autoloader Behavior
-----

When a class or defined resource is declared, Puppet will use its full name to find the class or defined type in your modules. Names are interpreted as follows:

* The first segment in a name (excluding the empty "top" namespace) identifies the [module][]. Every class and defined type should be in its own file in the module's `manifests` directory, and each file should have the `.pp` file extension.
* When resolving a name to a loadable file, the autoloader searches by shortening the name one segment at a time until only the module name remains.
  * For each searched name, the final segment is used as the file name, and any interior segments
    are used as a series of subdirectories under the manifests `directory`.
  * When only the module name remains, the module's init.pp file is used.
  * The first found existing file will be loaded, and if this file does not contain the expected
    loaded object an error is raised.


Thus, every class or defined type name maps directly to a file path within Puppet's [`modulepath`][modulepath]:

name                     | file path
------------------------ | ---------
`apache`                 | `<modulepath>/apache/manifests/init.pp`
`apache::mod`            | `<modulepath>/apache/manifests/mod.pp`
`apache::mod::passenger` | `<modulepath>/apache/manifests/mod/passenger.pp`

Note again that `init.pp` always contains a class or defined type named after the module, and any other `.pp` file contains a class or type with at least two namespace segments. (That is, `apache.pp` would contain a class named `apache::apache`.)

Nested Namespaces
---

While it is recommended that each class or define is written in a separate file using fully qualified names, it is also possible to define multiple objects in the same file, or nest classes and definitions inside of other classes. When doing so, the namespace of the outer class is prepended to the the given name of a nested class or define.

{% highlight ruby %}

    class apache {
      class mod {
        class passenger { ... }
      }
      define vhost { ... }
    }
{% endhighlight %}

This creates the classes and defines:

* class apache
* class apache::mod
* class apache::mod::passenger
* define apache::vhost

---
layout: default
title: "Future Parser: Namespaces and Autoloading"
canonical: "/puppet/latest/reference/future_lang_namespaces.html"
---

[classes]: ./lang_classes.html
[define]: ./lang_defined_types.html
[import]: ./lang_import.html
[variables]: ./lang_variables.html
[modulepath]: ./modules_fundamentals.html#the-modulepath
[module]: ./modules_fundamentals.html
[scopes]: ./lang_scope.html
[include]: ./lang_classes.html#using-include
[PUP-121]: https://tickets.puppetlabs.com/browse/PUP-121
[inherits]: ./lang_classes.html#inheritance
[allowed]: ./lang_reserved.html#classes-and-types
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
* If there are **no** additional namespaces, Puppet will look for the class or defined type in the module's `init.pp` file.
* Otherwise, Puppet will treat the final segment as the file name and any interior segments as a series of subdirectories under the `manifests` directory.

Thus, every class or defined type name maps directly to a file path within Puppet's [`modulepath`][modulepath]:

name                     | file path
------------------------ | ---------
`apache`                 | `<modulepath>/apache/manifests/init.pp`
`apache::mod`            | `<modulepath>/apache/manifests/mod.pp`
`apache::mod::passenger` | `<modulepath>/apache/manifests/mod/passenger.pp`

Note again that `init.pp` always contains a class or defined type named after the module, and any other `.pp` file contains a class or type with at least two namespace segments. (That is, `apache.pp` would contain a class named `apache::apache`.)

---
layout: default
title: "Language: Namespaces and Autoloading"
canonical: "/puppet/latest/reference/lang_namespaces.html"
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

> **Important note:** Earlier versions of Puppet used namespaces to navigate nested class/type definitions, and the code that resolves names still behaves as though this were their primary use. **This can sometimes result in the wrong class being loaded.** This is a major outstanding design issue ([PUP-121][]). [See below][relative_below] for a full description of the issue.

Syntax
-----

Puppet [class][classes] and [defined type][define] names may consist of any number of namespace segments separated by the `::` (double colon) namespace separator. (This separator is analogous to the `/` \[slash\] in a file path.)

~~~ ruby
    class apache { ... }
    class apache::mod { ... }
    class apache::mod::passenger { ... }
    define apache::vhost { ... }
~~~

Optionally, class/define names can begin with the top namespace, which is the empty string. The following names are equivalent:

* `apache` and `::apache`
* `apache::mod` and `::apache::mod`
* etc.

This is ugly and should be unnecessary, but is occasionally required due to an outstanding design issue. [See below for details.][relative_below]

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

Note again that `init.pp` always contains a class or defined type named after the module, and any other `.pp` file contains a class or type with at least two namespace segments. (That is, `apache.pp` would contain a class named `apache::apache`.) This also means you can't have a class named `<MODULE NAME>::init`.


Relative Name Lookup and Incorrect Name Resolution
-----

In this version of Puppet, class name resolution is **partially broken** --- if the final namespace segment of a class in one module matches the name of another module, Puppet will sometimes load the wrong class.

~~~ ruby
    class bar {
      notice("From class bar")
    }
    class foo::bar {
      notice("From class foo::bar")
    }
    class foo {
      include bar
    }
    include foo
~~~

In the example above, the invocation of `include bar` will actually declare class `foo::bar`. This is because Puppet assumes class and defined type names are **relative** until proven otherwise. This is a major outstanding design issue ([PUP-121][]) which will not be resolved in Puppet 3, as the fix will break some amount of existing code.

### Behavior

When asked to load a class or defined type `foo`, Puppet will:

* Attempt to load `<current namespace>::foo`
* If that fails, attempt to load `<parent of current namespace>::foo`
* If that fails, continue searching for `foo` through every ancestor namespace
* Finally, attempt to load `foo` from the top namespace (AKA `::foo`)

A concrete example:

~~~ ruby
    class apache::nagios {
      include nagios
      ...
    }
~~~

When asked to `include nagios`, Puppet will first attempt to load `apache::nagios::nagios`. Since that class does not exist, it will then attempt to load `apache::nagios`. This exists, and since [the include function][include] can safely declare a class multiple times, Puppet does not complain. It will not attempt to load class `nagios` from the `nagios` module.

### Workaround

If a class within another module is blocking the declaration of a top-namespace class, you can force the correct class to load by specifying its name from the top namespace ([as seen above](#syntax)). To specify a name from the top namespace, prepend `::` (double colon) to it:

~~~ ruby
    class apache::nagios {
      include ::nagios # Start searching from the top namespace instead of the local namespace
      ...
    }
~~~

In the example above, Puppet will load class `nagios` from the `nagios` module instead of declaring `apache::nagios` a second time.

> ### Aside: Historical Context
>
> Relative name lookup was introduced in pre-module versions of Puppet. It reflects an outdated assumption about how modules would be used.
>
> #### Proto-Modules
>
> Before modules were introduced, users would create module-like blobs by putting a group of related classes and defined types into one manifest file, then using an [import][] statement in `site.pp` to make the group available to the parser.
>
~~~ ruby
    # /etc/puppet/manifests/apache.pp
    class apache { ... } # Manage Apache
    class ssl { ... } # Optional SSL support for Apache
    class python { ... } # Optional mod_python support for Apache
    define vhost ($port) { ... } # Create an Apache vhost

    # /etc/puppet/manifests/site.pp
    import apache.pp
    include apache
    include ssl
~~~
>
> #### Namespacing for Redistribution
>
> As proto-modules got more sophisticated, their authors wanted to share them with other users. The problem with this is visible above: many modules were likely to have a `python` or `ssl` class, and the `lighttpd` module probably had a `vhost` define that clashed with the Apache one.
>
> The solution was namespacing, which would allow different proto-modules to use common class and defined type names without competing for global identifiers.
>
> #### Private vs. Public
>
> The implementation of namespaces relied on an assumption that turned out to be incorrect: that classes and defined types other than the module's main class would (and should) mostly be used inside the module, rather than applied directly to nodes. (That is, they would be _private,_ much like local variables.) Thus, namespacing was done by hiding definitions within other definitions:
>
~~~ ruby
    class apache {
      ...
      class ssl { ... }
      class python { ... }
      define vhost ($port) { ... }
    }
~~~
>
> The short names of the internal classes and defined types could only be used inside the main class. However, much like qualified variables, you could access them from anywhere by using their full (that is, namespaced) name. Full names were constructed by prepending the full name of the "outer" class, along with the `::` namespace separator. (That is, the full name of `ssl` would be `apache::ssl`, `python` would be `apache::python`, etc.)
>
> This was the origin of the relative name lookup behavior, as Puppet assumed that a class that had its own private `python` class would want to use that instead of the top-namespace `python` class.
>
> #### This Turned Out to be Pointless
>
> Users and developers eventually realized several things about this arrangement:
>
> * Using a class's full name everywhere was actually not that big a deal and was in fact a lot clearer and easier to read and maintain.
> * Public classes and defined types were more common than private ones and optimizing for the less common case was an odd approach.
> * Even for classes and defined types that _were_ only used within their module, there was little real benefit to be gained by making them "private," since they were effectively public via their full name anyway.
>
> Those realizations led to the superior [module][] autoloader design used today, where a class's "full" name is effectively its only name. However, the previous name lookup behavior was never deprecated or removed, for fear of breaking large amounts of existing code. This leaves it present in Puppet 3, where it often annoys users who have adopted the modern code style.
>
> We plan to fix this in a future release.

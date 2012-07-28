---
layout: default
title: "Language: Classes"
---


<!-- TODO -->
[allowed]: ./lang_reserved.html#classes-and-types
[function]: ./lang_functions.html
[modules]:
[hiera]: 
[function]: 
[dynamic_scope]: 
[relationships]: 
[chaining]: 
[node]: 
[resource_declaration]: 
[scope]: 
[enc]: 


**Classes** are named blocks of Puppet code, which are not applied unless they are invoked by name. They can be stored in [modules][] for later use, and declared (added to a node's catalog) with the `include` function or a resource-like syntax.

Syntax
-----

### Defining a Class

{% highlight ruby %}
    class base::linux {
      file { '/etc/passwd':
        owner => 'root',
        group => 'root',
        mode  => '0644',
      }
      file { '/etc/shadow':
        owner => 'root',
        group => 'root',
        mode  => '0440',
      }
    }
{% endhighlight %}

{% highlight ruby %}
    class apache ($version = 'latest') {
      package {'httpd':
        ensure => $version, # Get version from the class declaration
        before => File['/etc/httpd.conf'],
      }
      file {'/etc/httpd.conf':
        ensure  => file,
        owner   => 'httpd',
        content => template('apache/httpd.conf.erb'), # Template from a module
      }
      service {'httpd':
        ensure => running,
        enable => true,
        subscribe => File['/etc/httpd.conf'],
      }
    }
{% endhighlight %}

The general form of a class declaration is:

* The `class` keyword
* The [name][allowed] of the class
* An optional **set of parameters,** which consists of:
    * An opening parenthesis
    * A comma-separated list of **parameters,** each of which consists of:
        * A new [variable][] name, including the `$` prefix
        * An optional equals sign and **default value** (any data type)
    * A closing parenthesis
* Optionally, the `inherits` keyword followed by another class name
* An opening curly brace
* A block of arbitrary Puppet code, which generally contains at least one [resource declaration][resource]
* A closing curly brace

### Declaring a Class With `include`

Declaring a class adds all of the code it contains to the catalog. `include` is a [function][] that declares classes.

{% highlight ruby %}
    # Declaring a class with include
    include base::linux
{% endhighlight %}

You can safely use `include` multiple times on the same class, and it will only be declared once:

{% highlight ruby %}
    include base::linux
    include base::linux # Has no additional effect
{% endhighlight %}

`include` can accept a single class name, a comma-separated list of class names, or an array of class names:

{% highlight ruby %}
    $my_classes = ['base::linux', 'apache']
    include $my_classes # including an array of classes
{% endhighlight %}

{% highlight ruby %}
    include base::linux, apache # including a list of classes
{% endhighlight %}

`include` **cannot pass values to a class's parameters.** You may still use `include` with parameterized classes, but only if every parameter has a default value; parameters without defaults are mandatory, and will require you to use the resource-like syntax to declare the class.

### Declaring a Class with `require`

The `require` function acts like `include`, but also causes the class to become a [dependency][relationships] of the surrounding container:

{% highlight ruby %}
    define apache::vhost ($port, $docroot, $servername, $vhost_name) {
      require apache
      ...
    }
{% endhighlight %}

Whenever an `apache::vhost` resource is declared, Puppet will add the contents of the `apache` class to the catalog if it hasn't already done so, and will ensure that every resource in class `apache` is processed before every resource in that `apache::vhost` instance. 

Note that this can also be accomplished with relationship chaining. The following example will have an identical effect:

{% highlight ruby %}
    define apache::vhost ($port, $docroot, $servername, $vhost_name) {
      include apache
      Class['apache'] -> Apache::Vhost[$title]
      ...
    }
{% endhighlight %}

The `require` function should not be confused with the [`require` metaparameter][relationships].

### Declaring a Class Like a Resource

Classes can also be [declared like resources][resource_declaration], using the special "class" resource type:

{% highlight ruby %}
    # Declaring a class with the resource-like syntax
    class {'apache':
      version => '2.2.21',
    }
    # With no parameters:
    class {'base::linux':}
{% endhighlight %}

The **parameters** used when defining the class become the **attributes** (without the `$` prefix) available when declaring the class like a resource. Parameters which have a **default value** are optional; if they are left out of the declaration, the default will be used. Parameters without defaults are mandatory.

A class **can only be declared this way once:**

{% highlight ruby %}
    # WRONG:
    class {'base::linux':}
    class {'base::linux':} # Will result in a compilation error
{% endhighlight %}

Thus, unlike with `include`, you must carefully manage where and how classes are declared when using this syntax. 

The resource-like syntax **should not be mixed with `include` for a given class.** The behavior of the two syntaxes when mixed is **undefined;** practically speaking, the results will be parse-order dependent, and will sometimes succeed and sometimes fail. 

### Declaring a Class With an ENC

[External node classifiers][enc] can declare classes. See the [documentation of the ENC interface][enc] or the documentation of your specific ENC for complete details.

Note that the ENC API supports classes with or without parameters, but many of the most common ENCs only support classes without parameters. 


Behavior
-----




Inheritance
-----






Classes also support a simple form of object inheritance.  For those
not acquainted with programming terms, this means that we can extend
the functionality of the previous class without copy/pasting
the entire class.  Inheritance allows
subclasses to override resource settings declared in parent classes. A
class can only inherit from one other class, not more than one.
In programming terms, this is called 'single inheritance'.

{% highlight ruby %}
    class freebsd inherits unix {
      File['/etc/passwd'] { group => 'wheel' }
      File['/etc/shadow'] { group => 'wheel' }
    }
{% endhighlight %}

If we needed to undo some logic specified in a parent class, we can
use undef like so:

{% highlight ruby %}
    class freebsd inherits unix {
      File['/etc/passwd'] { group => undef }
    }
{% endhighlight %}

In the above example, nodes which include the `unix` class will have the
password file's group set to `root`, while nodes including
`freebsd` would have the password file group ownership left
unmodified.

In Puppet version 0.24.6 and higher, you can specify multiple overrides like
so:

{% highlight ruby %}
    class freebsd inherits unix {
      File['/etc/passwd', '/etc/shadow'] { group => 'wheel' }
    }
{% endhighlight %}

There are other ways to use inheritance.  In Puppet 0.23.1 and
higher, it's possible to add values to resource parameters using
the '+>' ('plusignment') operator:

{% highlight ruby %}
    class apache {
      service { 'apache': require => Package['httpd'] }
    }

    class apache-ssl inherits apache {
      # host certificate is required for SSL to function
      Service['apache'] { require +> File['apache.pem'] }
    }
{% endhighlight %}

The above example makes the service resource in the second class require all the packages in the first,
as well as the `apache.pem` file.

To append multiple requires, use array brackets and commas:

{% highlight ruby %}
    class apache {
      service { 'apache': require => Package['httpd'] }
    }

    class apache-ssl inherits apache {
      Service['apache'] { require +> [ File['apache.pem'], File['/etc/httpd/conf/httpd.conf'] ] }
    }
{% endhighlight %}

The above would make the `require` parameter in the `apache-ssl`
class equal to

{% highlight ruby %}
    [Package['httpd'], File['apache.pem'], File['/etc/httpd/conf/httpd.conf']]
{% endhighlight %}


-----




Like resources, you can also create relationships between classes with
'require', like so:

{% highlight ruby %}
    class apache {
      service { 'apache': require => Class['squid'] }
    }
{% endhighlight %}

The above example uses the `require` metaparameter to make the `apache`
class dependent on the `squid` class.

In Puppet version 0.24.6 and higher, you can specify multiple relationships
like so:

{% highlight ruby %}
    class apache {
      service { 'apache':
        require => Class['squid', 'xml', 'jakarta'],
      }
    }
{% endhighlight %}

The `require` metaparameter does not implicitly declare a class; this means it can be used multiple times and is compatible with parameterized classes, but you must make sure you actually declare the class you're requiring at some point. 

Puppet also has [a `require` function](/references/latest/function.html#require), which can be used inside class definitions and which _does_ implicitly declare a class, in the same way that the `include` function does. This function doesn't play well with parameterized classes. The `require` function is largely unnecessary, as class-level dependencies can be managed in other ways.





-----------------





> ## Aside: History, the Future, and Best Practices
> 
> Classes often need to be configured with site-specific and node-specific data, especially if they are to be re-used at multiple sites.
> 
> The traditional way to get this info into a class was to have it look outside its local [scope][] and read arbitrary variables, which would be set by the user however they saw fit. (If you're curious, this was why ENC-set variables were originally called "parameters:" they were almost always used to pass data into classes.) This entire approach was brittle and bad, because all classes were effectively competing for variable names in a global namespace, and the only ways to find a given class's requirements were to be really diligent about documentation or read the entire module's code. 
> 
> Parameters for classes were introduced in Puppet 2.6 as a way to directly pass site/node-specific data into a class --- by declaring up-front what information was necessary to configure the class, module developers could communicate quickly and unambiguously to users and we could eventually build automated tooling to help with discovery. This helped a bit, but it also introduced new problems and revealed some existing ones:
> 
> - Given that the `include` function can take multiple classes, there was no good way to make it also accept class parameters. This necessitated a new and less convenient syntax for using classes with parameters. 
> - If a class were to be declared twice with conflicting parameter values, there was no framework for deciding which declaration should win. Thus, Puppet will simply fail compilation if there's any possibility of a conflict --- that is, if the syntax that allows parameters is used twice for a given class. The result: parameterized classes wouldn't work with some very common design patterns, including:
>     - Having classes and defined types `include` or `require` any classes they depend on.
>     - Building overlapping "role" classes and declaring more than one role on some nodes.
> - The question of what to do about parameter conflicts also emphasized the fact that, using the traditional method of grabbing arbitrary variables, it was already possible to create parse-order dependent conflicts by using `include` multiple times in different scopes. (This remained possible after parameterized classes were introduced.)
> 
> The result was that class parameters were an incomplete feature, which didn't finish solving the problems that inspired them --- or rather, they _could_ solve the problem, but the cost was a much more difficult and rigorous site design, one which felt unnatural to a lot of users. This actually made the problem quite a bit _worse,_ mostly by muddying our message to users about how to deal with these issues and presenting the illusion that a very-much-still-alive problem was solved. This remained the state of affairs in Puppet 2.7. 
> 
> After a lot of research, we decided there were actually _two_ requirements for really solving the question of site/node-specific class data. The first was explicit class parameters, which we now had; the second was a guarantee that, while compiling a given node's catalog, there would only be **one possible value** for any given parameter. This second piece of the puzzle would restore and reaffirm the usefulness of `include`, let parameterized classes work with the traditional large-scale Puppet design patterns, and still let us have all of the benefits of class parameters. (That is: strict namespacing, obvious placement, and visibility to outside tools.) Since Puppet's language allows so much flexible logic in manifests, we determined that the only way to fulfill this second requirement was to fetch parameter values from somewhere _outside_ the Puppet manifests, and the fits-most-cases tool we settled on was [Hiera][].
> 
> Puppet 3.0 will get closer to solving this question with **automatic parameter lookup,** which will work as follows:
> 
> - Puppet will require [Hiera][], a hierarchical data lookup tool which lets you set site-wide values and override them for groups of nodes and specific nodes. 
> - The `include` function can be used with every class, including parameterized classes. 
> - If you use `include` on a class with parameters, Puppet will automatically look up each parameter in Hiera, using the lookup key `class_name::parameter_name`. (So the `apache` class's `$version` parameter would be looked up as `apache::version`.) If a parameter isn't set in Hiera, Puppet will use the default value; if it's absent and there's no default, compilation will fail and you'll have to set a value for it if you want to use the class.
> - You can still set parameters directly with the resource-like syntax or an ENC, and they will override any values from Hiera. However, you shouldn't need to (and won't want to) do this. 
> 
> In the meantime, there are several approaches to dealing with this space in your own modules and site design. 
> 
> ### Best Practices Today
> 
> In a Puppet 2.7 or 2.6 world, you have the following general options: 
> 
> * Use Hiera and parameterized classes to mimic 3.0 behavior in a forward-compatible way
> * Use a "classic" module design that doesn't use parameterized classes
> * Use a rigorous "pure" parameterized classes site design, probably using an ENC to resolve parameters and machine roles
> * Mix and match "classic" and parameterized classes, using parameters only where necessary and Hiera when you feel like it
> 
> #### Using Hiera to Mimic 3.0
> 
> [Hiera][] works today as an add-on with Puppet 2.7 and 2.6. If you maintain site data in Hiera and write your parameterized classes to use the following idiom, you can have a complete forward-compatible emulation of Puppet 3.0's auto-lookup:
> 
{% highlight ruby %}
    class example ( $parameter_one = hiera('example::parameter_one'), $parameter_two = hiera('example::parameter_two') ) {
      ...
    }
{% endhighlight %}
> 
> This allows you to use `include` on the class and automatically retrive parameter values from Hiera. When you upgrade to 3.0, Puppet will begin automatically looking up the exact same values that it was manually looking up in Puppet 2.7; you can remove the `hiera()` statements in your default values at your leisure, or leave them there for the sake of of backwards compatibility.
> 
> See [the Hiera documentation][hiera] for more details about storing your data in Hiera.
> 
> #### Using "Classic" Module/Site Design
> 
> Continue to use classes with no parameters, and have them fetch their data from variables outside their scope. This will have the same drawbacks it has always had, and you will need to beware the temptation to abuse [dynamic scope][dynamic_scope]. We highly recommend fetching these node- or group-specific values from an ENC instead of calculating them with scope hierarchies in Puppet. You may also find the classic `extlookup` function (or Hiera as an add-on) helpful, and many users have built Puppet [function][] interfaces to an external CMDB data source for this exact purpose.
> 
> #### Using a "Pure" Parameterized Classes Site
> 
> In short, you'll need to do the following:
> 
> * Abandon `include` and use the resource-like syntax to declare all classes. 
> * If you use "role" classes, make them granular enough that they have absolutely no overlap. Each role class should completely "own" the parameterized classes it declares, and nodes (via node definitions or your ENC) can declare whichever roles they need.
> * If you don't use "role" classes, every node should declare every single class it needs. This is extraordinarily unwieldy with node definitions, and you will almost certainly need a custom-built ENC able to resolve classes and parameters in a hierarchical fashion. 
> * Most of your non-role classes or defined types shouldn't declare other classes. If any of them require a given class, you should establish a dependency [relationship][relationships] with the chaining syntax inside the definition (`Class['dependency'] -> Class['example']` or `Class['dependency'] -> Example::Type[$title]`) --- this won't declare the class in question, but will protect you by failing compilation if the class isn't being declared upstream in the role, node definition, or ENC. 
> * If a class does declare another class, it must "own" that class completely, in the style of the "`ntp`, `ntp::service`, `ntp::config`, `ntp::package`" design pattern. 
> 
> Most users will want to do something other than this, as it takes fairly extreme design discipline. However, once constructed, it is reliable, knowable, and forward-compatible.
> 
> #### Mixing and Matching
> 
> The most important thing when mixing styles is to make sure your site's internal documentation is very very clear. 
> 
> If possible, you should implement Hiera and use the idiom above for mimicking 3.0 behavior on your handful of parameterized classes. This will give you and your colleagues an obvious path forward when you eventually refactor your existing modules, and you can safely continue to add parameters (or not) at your leisure while declaring all of your classes in the same familiar way. 

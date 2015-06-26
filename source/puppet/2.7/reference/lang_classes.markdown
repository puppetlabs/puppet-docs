---
layout: default
title: "Language: Classes"
canonical: "/puppet/latest/reference/lang_classes.html"
---


[hiera]: https://github.com/puppetlabs/hiera

[sitedotpp]: ./lang_summary.html#files
[collectors]: ./lang_collectors.html
[collector_override]: ./lang_resources.html#amending-attributes-with-a-collector
[namespace]: ./lang_namespaces.html
[enc]: /guides/external_nodes.html
[tags]: ./lang_tags.html
[allowed]: ./lang_reserved.html#classes-and-types
[function]: ./lang_functions.html
[modules]: ./modules_fundamentals.html
[contains]: ./lang_containment.html
[contains_float]: ./lang_containment.html#known-issues
[function]: ./lang_functions.html
[multi_ref]: ./lang_datatypes.html#multi-resource-references
[dynamic_scope]: ./lang_scope.html#dynamic-scope
[add_attribute]: ./lang_resources.html#adding-or-modifying-attributes
[undef]: ./lang_datatypes.html#undef
[relationships]: ./lang_relationships.html
[qualified_var]: ./lang_variables.html#accessing-out-of-scope-variables
[variable]: ./lang_variables.html
[variable_assignment]: ./lang_variables.html#assignment
[chaining]: ./lang_relationships.html#chaining-arrows
[conditional]: ./lang_conditional.html
[resource_reference]: ./lang_datatypes.html#resource-references
[node]: ./lang_node_definitions.html
[resource_declaration]: ./lang_resources.html
[scope]: ./lang_scope.html
[parent_scope]: ./lang_scope.html#scope-lookup-rules
[definedtype]: ./lang_defined_types.html
[metaparameters]: ./lang_resources.html#metaparameters
[catalog]: ./lang_summary.html#compilation-and-catalogs

**Classes** are named blocks of Puppet code which are not applied unless they are invoked by name. They can be stored in [modules][] for later use and then declared (added to a node's [catalog][]) with the `include` function or a resource-like syntax.

Syntax
-----

### Defining a Class

~~~ ruby
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
~~~

~~~ ruby
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
~~~

The general form of a class declaration is:

* The `class` keyword
* The [name][allowed] of the class
* An optional **set of parameters,** which consists of:
    * An opening parenthesis
    * A comma-separated list of **parameters,** each of which consists of:
        * A new [variable][] name, including the `$` prefix
        * An optional equals (=) sign and **default value** (any data type)
    * An optional trailing comma after the last parameter (Puppet 2.7.8 and later)
    * A closing parenthesis
* Optionally, the `inherits` keyword followed by a single class name
* An opening curly brace
* A block of arbitrary Puppet code, which generally contains at least one [resource declaration][resource_declaration]
* A closing curly brace

### Declaring a Class With `include`

Declaring a class adds all of the code it contains to the catalog. Classes can be declared with the `include` function [function][].

~~~ ruby
    # Declaring a class with include
    include base::linux
~~~

You can safely use `include` multiple times on the same class and it will only be declared once:

~~~ ruby
    include base::linux
    include base::linux # Has no additional effect
~~~

The `include` function can accept a single class name or a comma-separated list of class names:

~~~ ruby
    include base::linux, apache # including a list of classes
~~~

The `include` function **cannot pass values to a class's parameters.** You may still use `include` with parameterized classes, but only if every parameter has a default value; parameters without defaults are mandatory, and will require you to use the resource-like syntax to declare the class.

### Declaring a Class with `require`

The `require` function acts like `include`, but also causes the class to become a [dependency][relationships] of the surrounding container:

~~~ ruby
    define apache::vhost ($port, $docroot, $servername, $vhost_name) {
      require apache
      ...
    }
~~~

In the above example, whenever an `apache::vhost` resource is declared, Puppet will add the contents of the `apache` class to the catalog if it hasn't already done so and it will ensure that every resource in class `apache` is processed before every resource in that `apache::vhost` instance.

Note that this can also be accomplished with relationship chaining. The following example will have an identical effect:

~~~ ruby
    define apache::vhost ($port, $docroot, $servername, $vhost_name) {
      include apache
      Class['apache'] -> Apache::Vhost[$title]
      ...
    }
~~~

The `require` function should not be confused with the [`require` metaparameter][relationships].

### Declaring a Class Like a Resource

Classes can also be [declared like resources][resource_declaration], using the special "class" resource type:

~~~ ruby
    # Declaring a class with the resource-like syntax
    class {'apache':
      version => '2.2.21',
    }
    # With no parameters:
    class {'base::linux':}
~~~

The **parameters** used when defining the class become the **attributes** (without the `$` prefix) available when declaring the class like a resource. Parameters which have a **default value** are optional; if they are left out of the declaration, the default will be used. Parameters without defaults are mandatory.

A class **can only be declared this way once:**

~~~ ruby
    # WRONG:
    class {'base::linux':}
    class {'base::linux':} # Will result in a compilation error
~~~

Thus, unlike with `include`, you must carefully manage where and how classes are declared when using this syntax.

The resource-like syntax **should not be mixed with `include` for a given class.** The behavior of the two syntaxes when mixed is **undefined;** but practically speaking, the results will be parse-order dependent and will sometimes succeed and sometimes fail.

### Declaring a Class With an ENC

[External node classifiers][enc] can declare classes. See the [documentation of the ENC interface][enc] or the documentation of your specific ENC for complete details.

Note that the ENC API supports classes with or without parameters, but many of the most common ENCs only support classes without parameters.


Behavior
-----

**Defining** a class makes it available for later use; **declaring** a class activates it and adds all of its resources to the catalog.

Classes are singletons --- although a given class may have very different behavior depending on how it is declared, the resources in it will only be declared once per compilation. You can use `include` several times on the same class, but every time after the first will have no effect. (The `require` function behaves similarly with regards to declaring the class, but will continue to create ordering relationships on subsequent uses.)

### Parameters and Attributes

The parameters of a class can be used as local variables inside the class's definition. These variables are not set with [normal assignment statements][variable_assignment]; instead, they are set with attributes when the class is declared:

~~~ ruby
    class {'apache':
      version => '2.2.21',
    }
~~~

In the example above, the value of `$version` within the class definition would be set to the attribute `2.2.21`.

### Containment

A class [contains][] all of its resources. This means any [relationships][] formed with the class will be extended to every resource in the class.

Note that classes cannot contain other classes. This is a known design issue; [see the relevant note on the "Containment" page][contains_float] for more details.

### Auto-Tagging

A class's name and each of its [namespace segments][namespace] are automatically added to the [tags][tags] of every resource it contains.

### Metaparameters

When declared with the resource-like syntax, a class may use any [metaparameter][metaparameters]. In such cases, every resource contained in the class will also have that metaparameter. So if you declare a class with `noop => true`, every resource in the class will also have `noop => true`, unless they specifically override it. Metaparameters which can take more than one value (like the [relationship][relationships] metaparameters) will merge the values from the container and any specific values from the individual resource.



Location
-----

### Definitions

Class definitions can (and should) be stored in [modules][]. Puppet is automatically aware of any classes in a valid module and can autoload them by name. Classes should be stored in the `manifests/` directory of a module with one class per file, and each filename should reflect the name of its class; see [Module Fundamentals][modules] for more details.

> #### Aside: Best Practices
>
> You should usually only load classes from modules. Although the additional options below this aside will work, they are not recommended.

You can also put class definitions in [the site manifest][sitedotpp]. If you do so, they may be placed anywhere in the file and are not parse-order dependent.

This version (2.7) of Puppet still allows class definitions to be stored in other class definitions, which puts the interior class under the exterior class's [namespace][]; it does not cause the interior class to be automatically declared when the exterior class is. Note that although this is not yet formally deprecated, it is very much not recommended.

### Declarations

You can declare classes:

* At top scope in the [site manifest][sitedotpp]
* In a [node definition][node]
* In the [output of an ENC][enc]
* In any other class
* In a [defined type][definedtype]
* In a [conditional statement][conditional]

If you are using `include` or `require` to declare a class (that is, if you are not declaring it with parameters at any point), you can declare it multiple times in several different places. This is useful for allowing classes or defined types to manage their own dependencies, or for building overlapping "role" classes when a given node may have more than one role. See [Aside: History, the Future, and Best Practices](#aside-history-the-future-and-best-practices) below for more information.

Inheritance
-----

Classes can be derived from other classes using the `inherits` keyword. This allows you to make special-case classes that extend the functionality of a more general "base" class.

> Note: Puppet 2.7 does not support using parameterized classes for inheritable base classes. The base class must have no parameters.

Inheritance causes three things to happen:

* When a derived class is declared, its base class is automatically declared first (if it wasn't already declared elsewhere).
* The base class becomes the [parent scope][parent_scope] of the derived class, so that the new class receives a copy of all of the base class's variables and resource defaults.
* Code in the derived class is given special permission to override any resource attributes that were set in the base class.

> #### Aside: When to Inherit
>
> You should only use class inheritance when you need to override resource attributes in the base class. This is because you can instantiate a base class by [including](#declaring-a-class-with-include) it inside another class's definition, and assigning a direct parent scope is rarely necessary since you can use [qualified variable names][qualified_var] to read any class's internal data.
>
> Additionally, many of the traditional use cases for inheritance (notably the "anti-class" pattern, where you override a service resource's `ensure` attribute to disable it) can be accomplished just as easily with class parameters. It is also possible to [use resource collectors to override resource attributes][collector_override].

### Overriding Resource Attributes

The attributes of any resource in the base class can be overridden with a [reference][resource_reference] to the resource you wish to override, followed by a set of curly braces containing attribute => value pairs:

~~~ ruby
    class base::freebsd inherits base::unix {
      File['/etc/passwd'] {
        group => 'wheel'
      }
      File['/etc/shadow'] {
        group => 'wheel'
      }
    }
~~~

This is identical to the syntax for [adding attributes to an existing resource][add_attribute], but in a derived class, it gains the ability to rewrite resources instead of just adding to them. Note that you can also use [multi-resource references][multi_ref] here.

You can remove an attribute's previous value without setting a new one by overriding it with the special value [`undef`][undef]:

~~~ ruby
    class base::freebsd inherits base::unix {
      File['/etc/passwd'] {
        group => undef,
      }
    }
~~~

This causes the attribute to be unmanaged by Puppet.

### Appending to Resource Attributes

Some resource attributes (such as the [relationship metaparameters][relationships]) can accept multiple values in an array. When overriding attributes in a derived class, you can add to the existing values instead of replacing them by using the `+>` ("plusignment") keyword instead of the standard `=>` hash rocket:

~~~ ruby
    class apache {
      service {'apache':
        require => Package['httpd'],
      }
    }

    class apache::ssl inherits apache {
      # host certificate is required for SSL to function
      Service['apache'] {
        require +> [ File['apache.pem'], File['httpd.conf'] ],
        # Since `require` will retain its previous values, this is equivalent to:
        # require => [ Package['httpd'], File['apache.pem'], File['httpd.conf'] ],
      }
    }
~~~





> Aside: History, the Future, and Best Practices
> -----
>
> Classes often need to be configured with site-specific and node-specific data, especially if they are to be re-used at multiple sites.
>
> The traditional way to get this info into a class was to have it look outside its local [scope][] and read arbitrary variables, which would be set by the user however they saw fit. (If you're curious, this was why ENC-set variables were originally called "parameters:" they were almost always used to pass data into classes.) This entire approach was brittle and bad, because all classes were effectively competing for variable names in a global namespace, and the only ways to find a given class's requirements were to be really diligent about documentation or read the entire module's code.
>
> Parameters for classes were introduced in Puppet 2.6 as a way to directly pass site/node-specific data into a class. By declaring up-front what information was necessary to configure the class, module developers could communicate quickly and unambiguously to users and Puppet Labs could eventually build automated tooling to help with discovery. This helped a bit, but it also introduced new problems and revealed some existing ones:
>
> - Given that the `include` function can take multiple classes, there was no good way to make it also accept class parameters. This necessitated a new and less convenient syntax for using classes with parameters.
> - If a class were to be declared twice with conflicting parameter values, there was no framework for deciding which declaration should win. Thus, Puppet will simply fail compilation if there's any possibility of a conflict --- that is, if the syntax that allows parameters is used twice for a given class. The result: parameterized classes wouldn't work with some very common design patterns, including:
>     - Having classes and defined types `include` or `require` any classes they depend on.
>     - Building overlapping "role" classes and declaring more than one role on some nodes.
> - The question of what to do about parameter conflicts also emphasized the fact that, using the traditional method of grabbing arbitrary variables, it was already possible to create parse-order dependent conflicts by using `include` multiple times in different scopes. (This remained possible after parameterized classes were introduced.)
>
> The result was that class parameters were an incomplete feature, which didn't finish solving the problems that inspired them --- or rather, they _could_ solve the problem, but the cost was a much more difficult and rigorous site design, one which felt unnatural to many users. This actually made the problem a bit _worse,_ mostly by muddying our message to users about how to deal with these issues and presenting the illusion that a very-much-still-alive problem was solved. This remained the state of affairs in Puppet 2.7.
>
> After a lot of research, we decided there were actually _two_ requirements for really solving the question of site/node-specific class data. The first was explicit class parameters, which we now had; the second was a guarantee that, while compiling a given node's catalog, there would only be **one possible value** for any given parameter. This second piece of the puzzle would restore and reaffirm the usefulness of `include`, let parameterized classes work with the traditional large-scale Puppet design patterns, and still let us have all of the benefits of class parameters. (That is: strict namespacing, obvious placement, and visibility to outside tools.) Since Puppet's language allows so much flexible logic in manifests, we determined that the only way to fulfill this second requirement was to fetch parameter values from somewhere _outside_ the Puppet manifests, and the fits-most-cases tool we settled on was [Hiera][].
>
> Puppet 3.0 will get closer to solving this question with **automatic parameter lookup,** which will work as follows:
>
> - Puppet will require [Hiera][], a hierarchical data lookup tool which lets you set site-wide values and override them for groups of nodes and specific nodes.
> - The `include` function can be used with every class, including parameterized classes.
> - If you use `include` on a class with parameters, Puppet will automatically look up each parameter in Hiera, using the lookup key `class_name::parameter_name`. (So the `apache` class's `$version` parameter would be looked up as `apache::version`.) If a parameter isn't set in Hiera, Puppet will use the default value; if it's absent and there's no default, compilation will fail and you'll have to set a value for it if you want to use the class.
> - You can still set parameters directly with the resource-like syntax or with an ENC and they will override any values from Hiera. However, you shouldn't need to (and won't want to) do this.
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

~~~ ruby
    class example ( $parameter_one = hiera('example::parameter_one'), $parameter_two = hiera('example::parameter_two') ) {
      ...
    }
~~~

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
> * If you use "role" classes, make them granular enough that they have absolutely no overlap. Each role class should completely "own" the parameterized classes it declares and nodes (via node definitions or your ENC) can declare whichever roles they need.
> * If you don't use "role" classes, every node should declare every single class it needs. This is extraordinarily unwieldy with node definitions, and you will almost certainly need a custom-built ENC which can resolve classes and parameters in a hierarchical fashion.
> * Most of your non-role classes or defined types shouldn't declare other classes. If any of them require a given class, you should establish a dependency [relationship][relationships] with the chaining syntax inside the definition (`Class['dependency'] -> Class['example']` or `Class['dependency'] -> Example::Type[$title]`) --- this won't declare the class in question, but will fail compilation if the class isn't being declared elsewhere (such as in the role, node definition, or ENC).
> * If a class does declare another class, it must "own" that class completely, in the style of the "`ntp`, `ntp::service`, `ntp::config`, `ntp::package`" design pattern.
>
> Most users will want to do something other than this, as it takes fairly extreme design discipline. However, once constructed, it is reliable and forward-compatible.
>
> #### Mixing and Matching
>
> The most important thing when mixing styles is to make sure your site's internal documentation is very, very clear.
>
> If possible, you should implement Hiera and use the idiom above for mimicking 3.0 behavior on your handful of parameterized classes. This will give you and your colleagues an obvious path forward when you eventually refactor your existing modules, and you can safely continue to add parameters (or not) at your leisure while declaring all of your classes in the same familiar way.

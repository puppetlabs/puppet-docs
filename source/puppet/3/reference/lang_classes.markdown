---
layout: default
title: "Language: Classes"
canonical: "/puppet/latest/reference/lang_classes.html"
---


[hiera]: https://github.com/puppetlabs/hiera

[sitedotpp]: ./lang_summary.html#files
[collector_override]: ./lang_resources.html#amending-attributes-with-a-collector
[namespace]: ./lang_namespaces.html
[enc]: /guides/external_nodes.html
[tags]: ./lang_tags.html
[allowed]: ./lang_reserved.html#classes-and-types
[function]: ./lang_functions.html
[modules]: ./modules_fundamentals.html
[contains]: ./lang_containment.html
[contain_classes]: ./lang_containment.html#containing-classes
[function]: ./lang_functions.html
[multi_ref]: ./lang_datatypes.html#multi-resource-references
[add_attribute]: ./lang_resources.html#adding-or-modifying-attributes
[undef]: ./lang_datatypes.html#undef
[relationships]: ./lang_relationships.html
[qualified_var]: ./lang_variables.html#accessing-out-of-scope-variables
[variable]: ./lang_variables.html
[variable_assignment]: ./lang_variables.html#assignment
[resource_reference]: ./lang_datatypes.html#resource-references
[node]: ./lang_node_definitions.html
[resource_declaration]: ./lang_resources.html
[scope]: ./lang_scope.html
[parent_scope]: ./lang_scope.html#scope-lookup-rules
[definedtype]: ./lang_defined_types.html
[metaparameters]: ./lang_resources.html#metaparameters
[catalog]: ./lang_summary.html#compilation-and-catalogs
[facts]: ./lang_variables.html#facts-and-built-in-variables
[import]: ./lang_import.html
[declare]: #declaring-classes
[setting_parameters]: #include-like-vs-resource-like
[override]: #using-resource-like-declarations
[ldap_nodes]: http://projects.puppetlabs.com/projects/1/wiki/Ldap_Nodes

[hiera]: https://github.com/puppetlabs/hiera
[external_data]: https://github.com/puppetlabs/hiera
[array_search]: https://github.com/puppetlabs/hiera
[hiera_hierarchy]: https://github.com/puppetlabs/hiera



**Classes** are named blocks of Puppet code, which are stored in [modules][] for later use and are not applied until they are invoked by name. They can be added to a node's [catalog][] by either **declaring** them in your manifests or by **assigning** them from an [ENC][].

Classes generally configure large or medium-sized chunks of functionality, such as all of the packages, config files, and services needed to run an application.

Defining Classes
-----

Defining a class makes it available for later use. It doesn't yet add any resources to the catalog; to do that, you must [declare it (see below)][declare] or [assign it from an ENC][enc].

### Syntax

~~~ ruby
    # A class with no parameters
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
    # A class with parameters
    class apache ($version = 'latest') {
      package {'httpd':
        ensure => $version, # Using the class parameter from above
        before => File['/etc/httpd.conf'],
      }
      file {'/etc/httpd.conf':
        ensure  => file,
        owner   => 'httpd',
        content => template('apache/httpd.conf.erb'), # Template from a module
      }
      service {'httpd':
        ensure    => running,
        enable    => true,
        subscribe => File['/etc/httpd.conf'],
      }
    }
~~~

The general form of a class definition is:

* The `class` keyword
* The [name][allowed] of the class
* An optional **set of parameters,** which consists of:
    * An opening parenthesis
    * A comma-separated list of **parameters,** each of which consists of:
        * A new [variable][] name, including the `$` prefix
        * An optional equals (=) sign and **default value** (any data type)
    * An optional trailing comma after the last parameter
    * A closing parenthesis
* Optionally, the `inherits` keyword followed by a single class name
* An opening curly brace
* A block of arbitrary Puppet code, which generally contains at least one [resource declaration][resource_declaration]
* A closing curly brace


### Class Parameters and Variables


**Parameters** allow a class to request external data. If a class needs to configure itself with data other than [facts][], that data should usually enter the class via a parameter.

Each class parameter can be used as a normal [variable][] inside the class definition. The values of these variables are not set with [normal assignment statements][variable_assignment] or read from top or node scope; instead, they are [automatically set when the class is declared][setting_parameters].

Note that if a class parameter lacks a default value, the user of the module **must** set a value themselves (either in their [external data][external_data] or an [override][]). As such, you should supply defaults wherever possible.

### Location

Class definitions should be stored in [modules][]. Puppet is **automatically aware** of classes in modules and can autoload them by name.

Classes should be stored in their module's `manifests/` directory as one class per file, and each filename should reflect the name of its class; see [Module Fundamentals][modules] and [Namespaces and Autoloading][namespace] for more details.

> #### Other Locations
>
> Most users should **only** load classes from modules. However, you can also put classes in the following additional locations:
>
> * [The site manifest][sitedotpp]. If you do so, they may be placed anywhere in the file and are not parse-order dependent.
> * [Imported manifests][import]. If you do so, you must [import][] the file containing the class before you may declare it.
> * Other class definitions. This puts the interior class under the exterior class's [namespace][], causing its real name to be something other than the name with which it was defined. It does not cause the interior class to be automatically declared along with the exterior class. Nested classes cannot be autoloaded; in order for the interior class to be visible to Puppet, the manifest containing it must have been forcibly loaded, either by autoloading the outermost class, using an [import][] statement, or placing the entire nested structure in the site manifest. Although nesting classes is not yet formally deprecated, it is **very much** not recommended.

### Containment

A class [contains][] all of its resources. This means any [relationships][] formed with the class as a whole will be extended to every resource in the class.

Classes can also contain other classes (or mimic containment, in pre-3.4.0 versions), but _you must manually specify that a class should be contained._ For details, [see the "Containing Classes" section of the Containment page.][contain_classes]

### Auto-Tagging

Every resource in a class gets automatically [tagged][tags] with the class's name (and each of its [namespace segments][namespace]).

### Inheritance

Classes can be derived from other classes using the `inherits` keyword. This allows you to make special-case classes that extend the functionality of a more general "base" class.

> Note: Puppet 3 does not support using parameterized classes for inheritable base classes. The base class **must** have no parameters.

Inheritance causes three things to happen:

* When a derived class is declared, its base class is automatically declared **first** (if it wasn't already declared elsewhere).
* The base class becomes the [parent scope][parent_scope] of the derived class, so that the new class receives a copy of all of the base class's variables and resource defaults.
* Code in the derived class is given special permission to override any resource attributes that were set in the base class.

> #### Aside: When to Inherit
>
> Class inheritance should be used **very sparingly,** generally only in the following situations:
>
> * When you need to override resource attributes in the base class.
> * To let a "params class" provide default values for another class's parameters:
>
>       class example ($my_param = $example::params::myparam) inherits example::params { ... }
>
>   This pattern works by guaranteeing that the params class is evaluated before Puppet attempts to evaluate the main class's parameter list. It is especially useful when you want your default values to change based on system facts and other data, since it lets you isolate and encapsulate all that conditional logic.
>
> **In nearly all other cases, inheritance is unnecessary complexity.** If you need some class's resources declared before proceeding further, you can [include](#using-include) it inside another class's definition. If you need to read internal data from another class, you should generally use [qualified variable names][qualified_var] instead of assigning parent scopes. If you need to use an "anti-class" pattern (e.g. to disable a service that is normally enabled), you can use a class parameter to override the standard behavior.
>
> Note also that you can [use resource collectors to override resource attributes][collector_override] in unrelated classes, although this feature should be handled with care.

#### Overriding Resource Attributes

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

> **Note:** If a base class declares other classes with the resource-like syntax, a class derived from it cannot override the class parameters of those inner classes. This is a known bug.

#### Appending to Resource Attributes

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



Declaring Classes
-----

**Declaring** a class in a Puppet manifest adds all of its resources to the catalog. You can declare classes in [node definitions][node], at top scope in the [site manifest][sitedotpp], and in other classes or [defined types][definedtype]. Declaring classes isn't the only way to add them to the catalog; you can also [assign classes to nodes with an ENC](#assigning-classes-from-an-enc).

Classes are singletons --- although a given class may have very different behavior depending on how its parameters are set, the resources in it will only be evaluated **once per compilation.**

### Include-Like vs. Resource-Like

Puppet has two main ways to declare classes: include-like and resource-like.

> **Note:** These two behaviors **should not be mixed** for a given class. Puppet's behavior when declaring or assigning a class with both styles is undefined, and will sometimes work and sometimes cause compilation failures.

#### Include-Like Behavior

[include-like]: #include-like-behavior

The `include`, `require`, `contain`, and `hiera_include` functions let you safely declare a class **multiple times;** no matter how many times you declare it, a class will only be added to the catalog once. This can allow classes or defined types to manage their own dependencies, and lets you create overlapping "role" classes where a given node may have more than one role.

Include-like behavior relies on [external data][external_data] and defaults for class parameter values, which allows the external data source to act like cascading configuration files for all of your classes. When a class is declared, Puppet will try the following for each of its parameters:

1. Request a value from [the external data source][external_data], using the key `<class name>::<parameter name>`. (For example, to get the `apache` class's `version` parameter, Puppet would search for `apache::version`.)
2. Use the default value.
3. Fail compilation with an error if no value can be found.

> **Aside: Best Practices**
>
> **Most** users in **most** situations should use include-like declarations and set parameter values in their external data. However, compatibility with earlier versions of Puppet may require compromises. See [Aside: Writing for Multiple Puppet Versions][aside_history] below for details.

> **Version Note:** Automatic external parameter lookup is a new feature in Puppet 3. Puppet 2.7 and earlier could only use default values or override values from resource-like declarations. [See below for more details.][aside_history]

#### Resource-like Behavior

[resource-like]: #resource-like-behavior

Resource-like class declarations require that you **only declare a given class once.** They allow you to override class parameters at compile time, and will fall back to [external data][external_data] for any parameters you don't override.  When a class is declared, Puppet will try the following for each of its parameters:

1. Use the override value from the declaration, if present.
2. Request a value from [the external data source][external_data], using the key `<class name>::<parameter name>`. (For example, to get the `apache` class's `version` parameter, Puppet would search for `apache::version`.)
3. Use the default value.
4. Fail compilation with an error if no value can be found.

> **Aside: Why Do Resource-Like Declarations Have to Be Unique?**
>
> This is necessary to avoid paradoxical or conflicting parameter values. Since overridden values from the class declaration always win, are computed at compile-time, and do not have a built-in hierarchy for resolving conflicts, allowing repeated overrides would cause catalog compilation to be unreliable and parse-order dependent.
>
> This was the original reason for adding external data bindings to include-like declarations: since external data is set **before** compile-time and has a **fixed hierarchy,** the compiler can safely rely on it without risk of conflicts.


### Using `include`

The `include` [function][] is the standard way to declare classes.

~~~ ruby
    include base::linux
    include base::linux # no additional effect; the class is only declared once

    include base::linux, apache # including a list

    $my_classes = ['base::linux', 'apache']
    include $my_classes # including an array
~~~

The `include` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It can accept:

* A single class
* A comma-separated list of classes
* An array of classes

### Using `require`

The `require` function (not to be confused with the [`require` metaparameter][relationships]) declares one or more classes, then causes them to become a [dependency][relationships] of the surrounding container.

~~~ ruby
    define apache::vhost ($port, $docroot, $servername, $vhost_name) {
      require apache
      ...
    }
~~~

In the above example, Puppet will ensure that every resource in the `apache` class gets applied before every resource in **any** `apache::vhost` instance.

The `require` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It can accept:

* A single class
* A comma-separated list of classes
* An array of classes

### Using `contain`

> **Version note:** `contain` is only available in Puppet 3.4.0 / Puppet Enterprise 3.2 and later.

The `contain` function is meant to be used _inside another class definition._ It declares one or more classes, then causes them to become [contained][contains] by the surrounding class. For details, [see the "Containing Classes" section of the Containment page.][contain_classes]

~~~ ruby
    class ntp {
      file { '/etc/ntp.conf':
        ...
        require => Package['ntp'],
        notify  => Class['ntp::service'],
      }
      contain ntp::service
      package { 'ntp':
        ...
      }
    }
~~~

In the above example, any resource that forms a `before` or `require` relationship with class `ntp` will also be applied before or after class `ntp::service`, respectively.

The `contain` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It can accept:

* A single class
* A comma-separated list of classes
* An array of classes

### Using `hiera_include`

The `hiera_include` function requests a list of class names from [Hiera][], then declares all of them. Since it uses the [array resolution type][array_search], it will get a combined list that includes classes from **every level** of the [hierarchy][hiera_hierarchy]. This allows you to abandon [node definitions][node] and use Hiera like a lightweight ENC.

    # /etc/puppetlabs/puppet/hiera.yaml
    ...
    hierarchy:
      - "%{::clientcert}"
      - common

    # /etc/puppetlabs/puppet/hieradata/web01.example.com.yaml
    ---
    classes:
      - apache
      - memcached
      - wordpress

    # /etc/puppetlabs/puppet/hieradata/common.yaml
    ---
    classes:
      - base::linux

~~~ ruby
    # /etc/puppetlabs/puppet/manifests/site.pp
    hiera_include(classes)
~~~

On the node `web01.example.com`, the example above would declare the classes `apache`, `memcached`, `wordpress`, and `base::linux`. On other nodes, it would only declare `base::linux`.

The `hiera_include` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It accepts a single lookup key.

### Using Resource-Like Declarations

Resource-like declarations look like [normal resource declarations][resource_declaration], using the special `class` pseudo-resource type.

~~~ ruby
    # Overriding a parameter:
    class {'apache':
      version => '2.2.21',
    }
    # Declaring a class with no parameters:
    class {'base::linux':}
~~~

Resource-like declarations use [resource-like behavior][resource-like]. (Multiple declarations prohibited; parameters may be overridden at compile-time.) You can provide a value for any class parameter by specifying it as resource attribute; any parameters not specified will follow the normal external/default/fail lookup path.

In addition to class-specific parameters, you can also specify a value for any [metaparameter][metaparameters]. In such cases, every resource contained in the class will also have that metaparameter:

~~~ ruby
    # Cause the entire class to be noop:
    class {'apache':
      noop => true,
    }
~~~

However, note that:

* Any resource can specifically override metaparameter values received from its container.
* Metaparameters which can take more than one value (like the [relationship][relationships] metaparameters) will merge the values from the container and any resource-specific values.



Assigning Classes From an ENC
-----

Classes can also be assigned to nodes by [external node classifiers][enc] and [LDAP node data][ldap_nodes]. Note that most ENCs assign classes with include-like behavior, and some ENCs assign them with resource-like behavior. See the [documentation of the ENC interface][enc] or the documentation of your specific ENC for complete details.





[aside_history]: #aside-writing-for-multiple-puppet-versions

> Aside: Writing for Multiple Puppet Versions
> -----
>
> Hiera integration and automatic parameter lookup are new features in Puppet 3; older versions may install the Hiera functions as an add-on, but will not automatically find parameters. If you are writing code for multiple Puppet versions, you have several options:
>
> ### Expect Users to Handle Parameters
>
> The simplest approach is to not look back, and expect Puppet 2.x users to use resource-like declarations. This isn't the friendliest approach, but many modules did this even before auto-parameters were available, and users are accustomed to a subset of their modules requiring it.
>
> ### Use Hiera Functions in Default Values
>
> If you are willing to require Hiera and the `hiera-puppet` add-on package for pre-3.0 users, you can emulate Puppet 3's behavior by using a `hiera` function call in each parameter's default value:

~~~ ruby
    class example ( $parameter_one = hiera('example::parameter_one'), $parameter_two = hiera('example::parameter_two') ) {
      ...
    }
~~~

> Be sure to use 3.0-compatible lookup keys (`<class name>::<parameter>`). This will let 2.x users declare the class with `include`, and their Hiera data will continue to work without changes once they upgrade to Puppet 3.
>
> This approach can also be combined with the "params class" pattern, if default values are necessary:

~~~ ruby
    class example (
      $parameter_one = hiera('example::parameter_one', $example::params::parameter_one),
      $parameter_two = hiera('example::parameter_two', $example::params::parameter_two)
    ) inherits example::params { # Inherit the params class to let the parameter list see its variables.
      ...
    }
~~~

> The drawbacks of this approach are:
>
> * It requires 2.x users to install Hiera and `hiera-puppet`.
> * It's slower on Puppet 3 --- if you don't set a value in your external data, Puppet will do _two_ searches before falling back to the default value.
>
> However, depending on your needs, it can be a useful stopgap until Puppet 3 is widely adopted.
>
> ### Avoid Class Parameters
>
> Prior to Puppet 2.6, classes could only request data by reading arbitrary variables outside their local [scope][]. It is still possible to design classes like this. **However,** since dynamic scope was removed in Puppet 3, old-style classes can only read **top-scope or node-scope** variables, which makes them less flexible than they were in previous versions. Your best options for using old-style classes with Puppet 3 are to use an ENC to set your classes' variables, or to manually insert `$special_variable = hiera('class::special_variable')` calls at top scope in your site manifest.



Appendix: Smart Parameter Defaults
------------------------------------

This design pattern can make for significantly cleaner code while enabling some really sophisticated behavior around default values.

~~~ ruby
    # /etc/puppet/modules/webserver/manifests/params.pp

    class webserver::params {
     $packages = $operatingsystem ? {
       /(?i-mx:ubuntu|debian)/        => 'apache2',
       /(?i-mx:centos|fedora|redhat)/ => 'httpd',
     }
     $vhost_dir = $operatingsystem ? {
       /(?i-mx:ubuntu|debian)/        => '/etc/apache2/sites-enabled',
       /(?i-mx:centos|fedora|redhat)/ => '/etc/httpd/conf.d',
     }
    }

    # /etc/puppet/modules/webserver/manifests/init.pp

    class webserver(
     $packages  = $webserver::params::packages,
     $vhost_dir = $webserver::params::vhost_dir
    ) inherits webserver::params {

     package { $packages: ensure => present }

     file { 'vhost_dir':
       path   => $vhost_dir,
       ensure => directory,
       mode   => '0750',
       owner  => 'www-data',
       group  => 'root',
     }
    }
~~~

To summarize what's happening here: When a class inherits from another class, it implicitly declares the base class. Since the base class's local scope already exists before the new class's parameters get declared, those parameters can be set based on information in the base class.

This is functionally equivalent to doing the following:

~~~ ruby
    # /etc/puppet/modules/webserver/manifests/init.pp

    class webserver( $packages = 'UNSET', $vhost_dir = 'UNSET' ) {

     if $packages == 'UNSET' {
       $real_packages = $operatingsystem ? {
         /(?i-mx:ubuntu|debian)/        => 'apache2',
         /(?i-mx:centos|fedora|redhat)/ => 'httpd',
       }
     }
     else {
        $real_packages = $packages
     }

     if $vhost_dir == 'UNSET' {
       $real_vhost_dir = $operatingsystem ? {
         /(?i-mx:ubuntu|debian)/        => '/etc/apache2/sites-enabled',
         /(?i-mx:centos|fedora|redhat)/ => '/etc/httpd/conf.d',
       }
     }
     else {
        $real_vhost_dir = $vhost_dir
    }

     package { $real_packages: ensure => present }

     file { 'vhost_dir':
       path   => $real_vhost_dir,
       ensure => directory,
       mode   => '0750',
       owner  => 'www-data',
       group  => 'root',
     }
    }
~~~

... but it's a significant readability win, especially if the amount of logic or the number of parameters gets any higher than what's shown in the example.

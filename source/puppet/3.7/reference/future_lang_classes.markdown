---
layout: default
title: "Future Parser: Classes"
canonical: "/puppet/latest/reference/future_lang_classes.html"
---

[paramtypes]: ./future_parameter_types.html
[sitedotpp]: ./dirs_manifest.html
[collector_override]: ./future_lang_resources.html#amending-attributes-with-a-collector
[namespace]: ./future_lang_namespaces.html
[enc]: /guides/external_nodes.html
[tags]: ./future_lang_tags.html
[allowed]: ./future_lang_reserved.html#classes-and-types
[reserved]: ./future_lang_reserved.html#reserved-parameter-names
[function]: ./future_lang_functions.html
[modules]: ./modules_fundamentals.html
[contains]: ./future_lang_containment.html
[contain_classes]: ./future_lang_containment.html#containing-classes
[function]: ./future_lang_functions.html
[multi_ref]: ./future_lang_datatypes.html#multi-resource-references
[add_attribute]: ./future_lang_resources.html#adding-or-modifying-attributes
[undef]: ./future_lang_datatypes.html#undef
[relationships]: ./future_lang_relationships.html
[qualified_var]: ./future_lang_variables.html#accessing-out-of-scope-variables
[variable]: ./future_lang_variables.html
[variable_assignment]: ./future_lang_variables.html#assignment
[resource_reference]: ./future_lang_datatypes.html#resource-references
[node]: ./future_lang_node_definitions.html
[resource_declaration]: ./future_lang_resources.html
[scope]: ./future_lang_scope.html
[parent_scope]: ./future_lang_scope.html#scope-lookup-rules
[definedtype]: ./future_lang_defined_types.html
[metaparameters]: ./future_lang_resources.html#metaparameters
[catalog]: ./future_lang_summary.html#compilation-and-catalogs
[facts]: ./future_lang_variables.html#facts-and-built-in-variables
[import]: ./future_lang_import.html
[declare]: #declaring-classes
[setting_parameters]: #include-like-vs-resource-like
[override]: #using-resource-like-declarations
[ldap_nodes]: http://projects.puppetlabs.com/projects/1/wiki/Ldap_Nodes
[hiera]: /hiera/latest
[external_data]: /hiera/latest/puppet.html
[array_search]: /hiera/latest/lookup_types.html#array-merge
[hiera_hierarchy]: /hiera/latest/hierarchy.html



**Classes** are named blocks of Puppet code, which are stored in [modules][] for later use and are not applied until they are invoked by name. They can be added to a node's [catalog][] by either **declaring** them in your manifests or by **assigning** them from an [ENC][].

Classes generally configure large or medium-sized chunks of functionality, such as all of the packages, config files, and services needed to run an application.

Defining Classes
-----

Defining a class makes it available for later use. It doesn't yet add any resources to the catalog; to do that, you must [declare it (see below)][declare] or [assign it from an ENC][enc].

### Syntax

{% highlight ruby %}
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
{% endhighlight %}

{% highlight ruby %}
    # A class with parameters
    class apache (String $version = 'latest') {
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
{% endhighlight %}

The general form of a class definition is:

* The `class` keyword
* The [name][allowed] of the class
* An optional **set of parameters,** which consists of:
    * An opening parenthesis
    * A comma-separated list of **parameters,** each of which consists of:
        * An optional [parameter type][paramtypes] annotation (the default is `Any`)
        * A new [variable][] name, including the `$` prefix
        * An optional equals (=) sign and **default value**
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

Each parameter may be preceeded by an optional **[parameter type][paramtypes] annotation**. If you include one, puppet will check the parameter *at runtime* to make sure that it has the right type. If no type annotation is provided, the default `Any` type will be assumed.

The special variables `$title` and `$name` are both set to the class name automatically, so they can't be used as parameters.

### Location

Class definitions should be stored in [modules][]. Puppet is **automatically aware** of classes in modules and can autoload them by name.

Classes should be stored in their module's `manifests/` directory as one class per file, and each filename should reflect the name of its class; see [Module Fundamentals][modules] and [Namespaces and Autoloading][namespace] for more details.

> #### Other Locations
>
> Most users should **only** load classes from modules. However, you can also put classes in the following additional locations:
>
> * [The main manifest][sitedotpp], or a main directory of manifests. If you do so, they may be placed anywhere in the file (or directory structure) and are not evaluation-order dependent.
> * [Imported manifests][import] has been discontinued in favor of a directory of manifests.
> * Other class definitions. This puts the interior class under the exterior class's [namespace][], causing its real name to be the parents name concatenated with '::' and the name with which it was defined. It does not cause the interior class to be automatically declared along with the exterior class. Nested classes cannot be autoloaded without also causing the containing class to be autoloaded; puppet attempts to load a manifest for each part of the class' namespaces and stops when a matching manifest is found - e.g if including `mymodule::outer::nested`, puppet will try to load `mymodule/outer/nested.pp`, then `mymodule/outer.pp`. Puppet gives up if the first found manifest does not define the class. Alternatively, the nested class becomes visible if its outer class is directly autoloaded, or if its parent is in the main manifest (or directory of manifests). Although it is possible to nest classes and play tricks with loading and naming, it is **very much** not recommended.

### Containment

A class [contains][] all of its resources. This means any [relationships][] formed with the class as a whole will be extended to every resource in the class.

Classes can also contain other classes, but _you must manually specify that a class should be contained._ For details, [see the "Containing Classes" section of the Containment page.][contain_classes]

### Auto-Tagging

Every resource in a class gets automatically [tagged][tags] with the class's name (and each of its [namespace segments][namespace]).

Every class gets automatically [tagged][tags] with its container's name (typically the name of
a node.

### Inheritance

Classes can be derived from other classes using the `inherits` keyword. This allows you to make special-case classes that extend the functionality of a more general "base" class.

> Note: This version of Puppet does not support using parameterized classes for inheritable base classes. The base class **must** have no parameters, or parameters must be set by default, or
> by data binding.

Inheritance causes three things to happen:

* When a derived class is defined, its base class is automatically defined **first** (if it wasn't already defined elsewhere).
* The base class becomes the [parent scope][parent_scope] of the derived class, so that the new class receives a copy of all of the base class's variables and resource defaults.
* Code in the derived class is given special permission to override any resource attributes that were set in the base class.
* Blocks further inheritance of the base class, since it can only be included once.

> #### Aside: When to Inherit
>
> Class inheritance should be used **very sparingly,** generally only in the following situations:
>
> * When you need to override resource attributes in the base class.
> * To let a "params class" provide default values for another class's parameters:
>
>       class example (String $my_param = $example::params::myparam) inherits example::params { ... }
>
>   This pattern works by guaranteeing that the params class is evaluated before Puppet attempts to evaluate the main class's parameter list. It is especially useful when you want your default values to change based on system facts and other data, since it lets you isolate and encapsulate all that conditional logic.
>
> **In nearly all other cases, inheritance is unnecessary complexity.** If you need some class's resources defined before proceeding further, you can [include](#using-include) it inside another class's definition. If you need to read internal data from another class, you should generally use [qualified variable names][qualified_var] instead of assigning parent scopes. If you need to use an "anti-class" pattern (e.g. to disable a service that is normally enabled), you can use a class parameter to override the standard behavior.
>
> Note also that you can [use resource collectors to override resource attributes][collector_override] in unrelated classes, although this feature should be handled with care.

#### Overriding Resource Attributes

The attributes of any resource in the base class can be overridden with a [reference][resource_reference] to the resource you wish to override, followed by a set of curly braces containing attribute => value pairs:

{% highlight ruby %}
    class base::freebsd inherits base::unix {
      File['/etc/passwd'] {
        group => 'wheel'
      }
      File['/etc/shadow'] {
        group => 'wheel'
      }
    }
{% endhighlight %}

This is identical to the syntax for [adding attributes to an existing resource][add_attribute], but in a derived class, it gains the ability to rewrite resources instead of just adding to them. Note that you can also use [multi-resource references][multi_ref] here.

You can remove an attribute's previous value without setting a new one by overriding it with the special value [`undef`][undef]:

{% highlight ruby %}
    class base::freebsd inherits base::unix {
      File['/etc/passwd'] {
        group => undef,
      }
    }
{% endhighlight %}

This causes the attribute to be unmanaged by Puppet.

> **Note:** If a base class defines other classes with the resource-like syntax, a class derived from it cannot override the class parameters of those inner classes. This is a known bug.

#### Appending to Resource Attributes

Some resource attributes (such as the [relationship metaparameters][relationships]) can accept multiple values in an array. When overriding attributes in a derived class, you can add to the existing values instead of replacing them by using the `+>` ("plusignment") keyword instead of the standard `=>` hash rocket:

{% highlight ruby %}
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
{% endhighlight %}



Including Classes
-----

**Including** a class in a Puppet manifest adds all of its resources to the catalog. You can include classes in [node definitions][node], at top scope in the [site manifest][sitedotpp], and in other classes or [defined types][definedtype]. Using `include` to include classes isn't the only way to add them to the catalog; you can also [assign classes to nodes with an ENC](#assigning-classes-from-an-enc).

Classes are singletons --- although a given class may have very different behavior depending on how its parameters are set, the resources in it will only be evaluated **once per compilation.**

### Include-Like vs. Resource-Like

Puppet has two main ways to including classes: include-like and resource-like.

> **Note:** These two behaviors **should not be mixed** for a given class. Puppet's behavior when declaring or assigning a class with both styles is undefined, and will sometimes work and sometimes cause compilation failures.

#### Include-Like Behavior

[include-like]: #include-like-behavior

The `include`, `require`, `contain`, and `hiera_include` functions let you safely include a class **multiple times;** no matter how many times you include it, a class will only be added to the catalog once. This can allow classes or defined types to manage their own dependencies, and lets you create overlapping "role" classes where a given node may have more than one role.

Include-like behavior relies on [external data][external_data] and defaults for class parameter values, which allows the external data source to act like cascading configuration files for all of your classes. When a class is included, Puppet will try the following for each of its parameters:

1. Request a value from [the external data source][external_data], using the key `<class name>::<parameter name>`. (For example, to get the `apache` class's `version` parameter, Puppet would search for `apache::version`.)
2. Use the default value.
3. Fail compilation with an error if no value can be found.

> **Aside: Best Practices**
>
> **Most** users in **most** situations should use include-like statements and set parameter values in their external data. However, compatibility with earlier versions of Puppet may require compromises. See [Aside: Writing for Multiple Puppet Versions][aside_history] below for details.

> **Version Note:** Automatic external parameter lookup was a new feature in Puppet 3. Puppet 2.7 and earlier could only use default values or override values from resource-like declarations. [See below for more details.][aside_history]

#### Resource-like Behavior

[resource-like]: #resource-like-behavior

Resource-like class inclusion require that you **only declare a given class once.** They allow you to override class parameters at compile time, and will fall back to [external data][external_data] for any parameters you don't override.  When a class is included this way, Puppet will try the following for each of its parameters:

1. Use the override value from the declaration, if present.
2. Request a value from [the external data source][external_data], using the key `<class name>::<parameter name>`. (For example, to get the `apache` class's `version` parameter, Puppet would search for `apache::version`.)
3. Use the default value.
4. Fail compilation with an error if no value can be found.

> **Aside: Why Do Resource-Like Declarations Have to Be Unique?**
>
> This is necessary to avoid paradoxical or conflicting parameter values. Since overridden values from the class inclusion always win, are computed at compile-time, and do not have a built-in hierarchy for resolving conflicts, allowing repeated overrides would cause catalog compilation to be unreliable and evaluation-order dependent.
>
> This was the original reason for adding external data bindings to include-like statements: since external data is set **before** compile-time and has a **fixed hierarchy,** the compiler can safely rely on it without risk of conflicts.


### Using `include`

The `include` [function][] is the standard way to include classes (add them and their contents to
the catalog).

{% highlight ruby %}
    include base::linux
    include base::linux # no additional effect; the class is only added once

    include base::linux, apache # including a list

    $my_classes = ['base::linux', 'apache']
    include $my_classes # including an array
{% endhighlight %}

The `include` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It can accept:

* A single class name or class reference
* A comma-separated list of class names or class references
* An array of class names or class references

### Using `require`

The `require` function (not to be confused with the [`require` metaparameter][relationships]) declares one or more classes, then causes them to become a [dependency][relationships] of the surrounding container.

{% highlight ruby %}
    define apache::vhost (String $port, String $docroot, String $servername, String $vhost_name) {
      require apache
      ...
    }
{% endhighlight %}

In the above example, Puppet will ensure that every resource in the `apache` class gets applied before every resource in **any** `apache::vhost` instance.

The `require` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It can accept:

* A single class name or class reference
* A comma-separated list of class names or class references
* An array of class names or class references

### Using `contain`

The `contain` function is meant to be used _inside another class definition._ It includes one or more classes, then causes them to become [contained][contains] by the surrounding class. For details, [see the "Containing Classes" section of the Containment page.][contain_classes]

{% highlight ruby %}
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
{% endhighlight %}

In the above example, any resource that forms a `before` or `require` relationship with class `ntp` will also be applied before or after class `ntp::service`, respectively.

The `contain` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It can accept:

* A single class name or class reference
* A comma-separated list of class names or class references
* An array of class names or class references

### Using `hiera_include`

The `hiera_include` function requests a list of class names from [Hiera][], then includes all of them. Since it uses the [array resolution type][array_search], it will get a combined list that includes classes from **every level** of the [hierarchy][hiera_hierarchy]. This allows you to abandon [node definitions][node] and use Hiera like a lightweight ENC.

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

{% highlight ruby %}
    # /etc/puppetlabs/puppet/manifests/site.pp
    hiera_include(classes)
{% endhighlight %}

On the node `web01.example.com`, the example above would include the classes `apache`, `memcached`, `wordpress`, and `base::linux`. On other nodes, it would only include `base::linux`.

The `hiera_include` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It accepts a single lookup key.

### Using Resource-Like Declarations

Resource-like catalog inclusion look like [normal resource declarations][resource_declaration], using the special `class` pseudo-resource type.

{% highlight ruby %}
    # Overriding a parameter:
    class {'apache':
      version => '2.2.21',
    }
    # Including a class with no parameters:
    class {'base::linux':}
{% endhighlight %}

Resource-like catalog inclusions use [resource-like behavior][resource-like]. (Multiple inclusion prohibited; parameters may be overridden at compile-time.) You can provide a value for any class parameter by specifying it as resource attribute; any parameters not specified will follow the normal external/default/fail lookup path.

In addition to class-specific parameters, you can also specify a value for any [metaparameter][metaparameters]. In such cases, every resource contained in the class will also have that metaparameter:

{% highlight ruby %}
    # Cause the entire class to be noop:
    class {'apache':
      noop => true,
    }
{% endhighlight %}

However, note that:

* Any resource can specifically override metaparameter values received from its container.
* Metaparameters which can take more than one value (like the [relationship][relationships] metaparameters) will merge the values from the container and any resource-specific values.



Assigning Classes From an ENC
-----

Classes can also be assigned to nodes by [external node classifiers][enc] and [LDAP node data][ldap_nodes]. Note that most ENCs assign classes with include-like behavior, and some ENCs assign them with resource-like behavior. See the [documentation of the ENC interface][enc] or the documentation of your specific ENC for complete details.



Appendix: Smart Parameter Defaults
------------------------------------

This design pattern can make for significantly cleaner code while enabling some really sophisticated behavior around default values.

{% highlight ruby %}
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
     String $packages  = $webserver::params::packages,
     String $vhost_dir = $webserver::params::vhost_dir
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
{% endhighlight %}

To summarize what's happening here: When a class inherits from another class, it implicitly includes the base class. Since the base class's local scope already exists before the new class's parameters get declared, those parameters can be set based on information in the base class.

This is functionally equivalent to doing the following:

{% highlight ruby %}
    # /etc/puppet/modules/webserver/manifests/init.pp

    class webserver(String $packages = 'UNSET', String $vhost_dir = 'UNSET' ) {

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
{% endhighlight %}

... but it's a significant readability win, especially if the amount of logic or the number of parameters gets any higher than what's shown in the example.

You can also take advantage of Puppet's type system to avoid having to use the string `'UNSET'` to
indicate that a default value should be used. At the same we also add that a package name
may not be an empty string.

{% highlight ruby %}
    # /etc/puppet/modules/webserver/manifests/init.pp

    class webserver(
      Variant[String[1], Default] $packages = default,
      Variant[String[1], Default] $vhost_dir = default ) {

     if $packages == default {
       $real_packages = ...
     }
     else {
      ...
     }

     if $vhost_dir == default {
        ...
       }
     }
     else {
       ...
    }
    ...
    }
{% endhighlight %}

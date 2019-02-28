---
layout: default
title: "Language: Classes"
---

[literal_types]: ./lang_data_type.html
[sitedotpp]: ./dirs_manifest.html
[collector_override]: ./lang_resources_advanced.html#amending-attributes-with-a-collector
[namespace]: ./lang_namespaces.html
[enc]: ./nodes_external.html
[tags]: ./lang_tags.html
[allowed]: ./lang_reserved.html#classes-and-defined-resource-types
[reserved]: ./lang_reserved.html#reserved-parameter-names
[function]: ./lang_functions.html
[modules]: ./modules_fundamentals.html
[contains]: ./lang_containment.html
[contain_classes]: ./lang_containment.html#containing-classes
[function]: ./lang_functions.html
[multi_ref]: ./lang_data_resource_reference.html#multi-resource-references
[add_attribute]: ./lang_resources_advanced.html#adding-or-modifying-attributes
[undef]: ./lang_data_undef.html
[relationships]: ./lang_relationships.html
[qualified_var]: ./lang_variables.html#accessing-out-of-scope-variables
[variable]: ./lang_variables.html
[variable_assignment]: ./lang_variables.html#assignment
[resource_reference]: ./lang_data_resource_reference.html
[node]: ./lang_node_definitions.html
[resource_declaration]: ./lang_resources.html
[scope]: ./lang_scope.html
[parent_scope]: ./lang_scope.html#scope-lookup-rules
[definedtype]: ./lang_defined_types.html
[metaparameters]: ./lang_resources.html#metaparameters
[catalog]: ./lang_summary.html#compilation-and-catalogs
[facts]: ./lang_variables.html#facts-and-built-in-variables
[declare]: #declaring-classes
[setting_parameters]: #include-like-vs-resource-like
[override]: #using-resource-like-declarations
[ldap_nodes]: ./nodes_ldap.html
[array_search]: ./puppet/latest/hiera_automatic.html#arguments
[hiera_hierarchy]: ./puppet/latest/hiera_intro.html

**Classes** are named blocks of Puppet code that are stored in [modules][] for later use and are not applied until they are invoked by name. They can be added to a node's [catalog][] by either **declaring** them in your manifests or **assigning** them from an [ENC][].

Classes generally configure large or medium-sized chunks of functionality, such as all of the packages, config files, and services needed to run an application.

## Defining classes

Defining a class makes it available for later use. It doesn't yet add any resources to the catalog; to do that, you must [declare it (see below)][declare] or [assign it from an ENC][enc].

### Syntax

``` puppet
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
```

``` puppet
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
```

The general form of a class definition is:

* The `class` keyword
* The [name][allowed] of the class
* An optional **parameter list,** which consists of:
    * An opening parenthesis
    * A comma-separated list of **parameters** (for example, `String $myparam = "default value"`). Each parameter consists of:
        * An optional [data type][literal_types], which restrict the allowed values for the parameter (defaults to `Any`)
        * A [variable][] name to represent the parameter, including the `$` prefix
        * An optional equals (`=`) sign and **default value** (which must match the data type, if one was specified)
    * An optional trailing comma after the last parameter
    * A closing parenthesis
* Optionally, the `inherits` keyword followed by a single class name
* An opening curly brace
* A block of arbitrary Puppet code, which generally contains at least one [resource declaration][resource_declaration]
* A closing curly brace

### Class parameters and variables

**Parameters** allow a class to request external data. If a class needs to configure itself with data other than [facts][], that data should usually enter the class via a parameter.

Each class parameter can be used as a normal [variable][] inside the class definition. The values of these variables are not set with [normal assignment statements][variable_assignment] or looked up from top or node scope; instead, they are [set based on user input when the class is declared][setting_parameters].

Note that if a class parameter lacks a default value, the module's user **must** set a value themselves (either in their external data or an [override][]). As such, you should supply defaults wherever possible.

Each parameter can be preceeded by an optional [**data type**][literal_types]. If you include one, Puppet checks the parameter's value at runtime to make sure that it has the right data type, and raise an error if the value is illegal. If no data type is provided, the parameter accepts values of any data type.

The special variables `$title` and `$name` are both set to the class name automatically, so they can't be used as parameters.

### Location

Class definitions should be stored in [modules][]. Puppet is **automatically aware** of classes in modules and can autoload them by name.

Classes should be stored in their module's `manifests/` directory as one class per file, and each filename should reflect the name of its class; see [Module Fundamentals][modules] and [Namespaces and Autoloading][namespace] for more details.

A class definition statement isn't an expression and can't be used where a value is expected.

> #### Other locations
>
> Most users should **only** put classes in individual files in modules. However, it's technically possible to put classes in the following additional locations and still load the class by name:
>
> * [The main manifest][sitedotpp]. If you do so, they can be placed anywhere in the main manifest file and are not evaluation-order dependent. (That is, you can safely declare a class before it's defined.)
> * A file in the same module whose corresponding class name is a truncated version of this class's name. That is, the class `first::second::third` could be put in `first::second`'s file, `first/manifests/second.pp`.
> * Lexically inside another class definition. This puts the interior class under the exterior class's [namespace][], causing its real name to be something other than the name with which it was defined. (For example: in `class first { class second { ... } }`, the interior class's real name is `first::second`.) Note that this doesn't cause the interior class to be automatically declared along with the exterior class.
>
> Again: You should never do these.

### Containment

A class [contains][] all of its resources. This means any [relationships][] formed with the class as a whole is extended to every resource in the class.

Classes can also contain other classes, but _you must manually specify that a class should be contained._ For details, [see the "Containing Classes" section of the Containment page][contain_classes].

A contained class is automatically [tagged][tags] with the name of its container.

### Auto-tagging

Every resource in a class gets automatically [tagged][tags] with the class's name and each of its [namespace segments][namespace].

### Inheritance

Classes can be derived from other classes using the `inherits` keyword. This allows you to make special-case classes that extend the functionality of a more general "base" class.

If a base class has parameters, those parameters must either have default values, or have their values supplied by automatic external data lookup. You can't specify values in the Puppet language for parameters in an inherited class.

Inheritance causes three things to happen:

* When a derived class is declared, its base class is automatically declared **first** (if it wasn't already declared elsewhere).
* The base class becomes the [parent scope][parent_scope] of the derived class, so that the new class receives a copy of all of the base class's variables and resource defaults.
* Code in the derived class is given special permission to override any resource attributes that were set in the base class.

> **Aside: When to Inherit**
>
> Class inheritance should be used **very sparingly,** generally only in the following situations:
>
> * When you need to override resource attributes in the base class.
> * To let a "params class" provide default values for another class's parameters:
>
> `class example (String $my_param = $example::params::myparam) inherits example::params { ... }`
>
>   This pattern works by guaranteeing that the params class is evaluated before Puppet attempts to evaluate the main class's parameter list. It is especially useful when you want your default values to change based on system facts and other data, since it lets you isolate and encapsulate all that conditional logic.
>
> **In nearly all other cases, inheritance is unnecessary complexity.** If you need some class's resources declared before proceeding further, you can [include](#using-include) it inside another class's definition. If you need to read internal data from another class, you should generally use [qualified variable names][qualified_var] instead of assigning parent scopes. If you need to use an "anti-class" pattern (for example, to disable a service that is normally enabled), you can use a class parameter to override the standard behavior.
>
> Note also that you can [use resource collectors to override resource attributes][collector_override] in unrelated classes, although this feature should be handled with care.

#### Overriding resource attributes

The attributes of any resource in the base class can be overridden with a [reference][resource_reference] to the resource you wish to override, followed by a set of curly braces containing attribute => value pairs:

``` puppet
class base::freebsd inherits base::unix {
  File['/etc/passwd'] {
    group => 'wheel'
  }
  File['/etc/shadow'] {
    group => 'wheel'
  }
}
```

This is identical to the syntax for [adding attributes to an existing resource][add_attribute], but in a derived class, it gains the ability to rewrite resources instead of just adding to them. Note that you can also use [multi-resource references][multi_ref] here.

You can remove an attribute's previous value without setting a new one by overriding it with the special value [`undef`][undef]:

``` puppet
class base::freebsd inherits base::unix {
  File['/etc/passwd'] {
    group => undef,
  }
}
```

This causes the attribute to be unmanaged by Puppet.

> **Note:** If a base class declares other classes with the resource-like syntax, a class derived from it cannot override the class parameters of those inner classes. This is a known bug.

#### Appending to resource attributes

Some resource attributes, such as the [relationship metaparameters][relationships], can accept multiple values in an array. When overriding attributes in a derived class, you can add to the existing values instead of replacing them by using the `+>` ("plusignment") keyword instead of the standard `=>` hash rocket:

``` puppet
class apache {
  service {'apache':
    require => Package['httpd'],
  }
}

class apache::ssl inherits apache {
  # host certificate is required for SSL to function
  Service['apache'] {
    require +> [ File['apache.pem'], File['httpd.conf'] ],
    # Since `require` retains its previous values, this is equivalent to:
    # require => [ Package['httpd'], File['apache.pem'], File['httpd.conf'] ],
  }
}
```

## Declaring classes

**Declaring** a class in a Puppet manifest adds all of its resources to the catalog. You can declare classes in [node definitions][node], at top scope in the [site manifest][sitedotpp], and in other classes or [defined types][definedtype]. Declaring classes isn't the only way to add them to the catalog; you can also [assign classes to nodes with an ENC](#assigning-classes-from-an-enc).

Classes are singletons --- although a given class can have very different behavior depending on how its parameters are set, the resources in it are evaluated only once per compilation.

### Include-like vs. resource-like

Puppet has two main ways to declare classes: include-like and resource-like.

> **Note:** Do not mix these two behaviors for a given class. Puppet's behavior when declaring or assigning a class with both styles is undefined and can cause compilation failures.

#### Include-like behavior

[include-like]: #include-like-behavior

The `include`, `require`, `contain`, and `hiera_include` functions let you safely declare a class **multiple times;** no matter how many times you declare it, a class is added to the catalog only once. This can allow classes or defined types to manage their own dependencies, and lets you create overlapping "role" classes where a given node can have more than one role.

Include-like behavior relies on external data and defaults for class parameter values, which allows the external data source to act like cascading configuration files for all of your classes. When a class is declared, Puppet tries the following for each of its parameters:

1. Request a value from the external data source, using the key `<class name>::<parameter name>`. (For example, to get the `apache` class's `version` parameter, Puppet would search for `apache::version`.)
2. Use the default value.
3. Fail compilation with an error if no value can be found.

#### Resource-like behavior

[resource-like]: #resource-like-behavior

Resource-like class declarations require that you **declare a given class only once.** They allow you to override class parameters at compile time, falling back to external data for any parameters you don't override. When a class is declared, Puppet tries the following for each of its parameters:

1. Use the override value from the declaration, if present.
2. Request a value from the external data source, using the key `<class name>::<parameter name>`. (For example, to get the `apache` class's `version` parameter, Puppet would search for `apache::version`.)
3. Use the default value.
4. Fail compilation with an error if no value can be found.

> **Aside: Why do resource-like declarations have to be unique?**
>
> This is necessary to avoid paradoxical or conflicting parameter values. Since overridden values from the class declaration always win, are computed at compile-time, and do not have a built-in hierarchy for resolving conflicts, allowing repeated overrides would cause catalog compilation to be unreliable and evaluation-order dependent.
>
> This was the original reason for adding external data bindings to include-like declarations: since external data is set **before** compile-time and has a **fixed hierarchy,** the compiler can safely rely on it without risk of conflicts.

### Using `include`

The `include` [function][] is the standard way to declare classes.

``` puppet
include base::linux
include base::linux # no additional effect; the class is only declared once

include Class['base::linux'] # including a class reference

include base::linux, apache # including a list

$my_classes = ['base::linux', 'apache']
include $my_classes # including an array
```

The `include` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It can accept:

* A single class name (like `apache`) or class reference (like `Class['apache']`)
* A comma-separated list of class names or class references
* An array of class names or class references

### Using `require`

The `require` function (not to be confused with the [`require` metaparameter][relationships]) declares one or more classes, then causes them to become a [dependency][relationships] of the surrounding container.

``` puppet
define apache::vhost (Integer $port, String $docroot, String $servername, String $vhost_name) {
  require apache
  ...
}
```

In the above example, Puppet ensures that every resource in the `apache` class gets applied before every resource in **any** `apache::vhost` instance.

The `require` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It can accept:

* A single class name (like `apache`) or class reference (like `Class['apache']`)
* A comma-separated list of class names or class references
* An array of class names or class references

### Using `contain`

The `contain` function is meant to be used _inside another class definition._ It declares one or more classes, then causes them to become [contained][contains] by the surrounding class. For details, [see the "Containing Classes" section of the Containment page.][contain_classes]

``` puppet
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
```

In the above example, any resource that forms a `before` or `require` relationship with class `ntp` is also applied before or after class `ntp::service`, respectively.

The `contain` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It can accept:

* A single class name (like `apache`) or class reference (like `Class['apache']`)
* A comma-separated list of class names or class references
* An array of class names or class references

### Using `hiera_include`

The `hiera_include` function requests a list of class names from Hiera, then declares all of them. Since it uses the [array lookup type](/puppet/latest/hiera_automatic.html#arguments), it gets a combined list that includes classes from **every level** of the [hierarchy][hiera_hierarchy]. This allows you to abandon [node definitions][node] and use Hiera like a lightweight ENC.

``` yaml
# /etc/puppetlabs/puppet/hiera.yaml
...
hierarchy:
  - "%{::clientcert}"
  - common

# /etc/puppetlabs/code/hieradata/web01.example.com.yaml
---
classes:
  - apache
  - memcached
  - wordpress

# /etc/puppetlabs/code/hieradata/common.yaml
---
classes:
  - base::linux
```

``` puppet
# /etc/puppetlabs/code/environments/production/manifests/site.pp
hiera_include(classes)
```

On the node `web01.example.com` in the production environment, the example above would declare the classes `apache`, `memcached`, `wordpress`, and `base::linux`. On other nodes, it would only declare `base::linux`.

The `hiera_include` function uses [include-like behavior][include-like]. (Multiple declarations OK; relies on external data for parameters.) It accepts a single lookup key.

### Using resource-like declarations

Resource-like declarations look like [normal resource declarations][resource_declaration], using the special `class` pseudo-resource type.

``` puppet
# Specifying the "version" parameter:
class {'apache':
  version => '2.2.21',
}
# Declaring a class with no parameters:
class {'base::linux':}
```

Resource-like declarations use [resource-like behavior][resource-like]: multiple declarations are prohibited, and parameters can be overridden at compile-time. You can provide a value for any class parameter by specifying it as resource attribute; any parameters not specified follow the normal external/default/fail lookup path.

In addition to class-specific parameters, you can also specify a value for any [metaparameter][metaparameters]. In such cases, every resource contained in the class also has that metaparameter.

However, note that:

* Any resource can specifically override metaparameter values received from its container.
* Metaparameters that can take more than one value (such as the [relationship][relationships] metaparameters) merge the values from the container and any resource-specific values.
* You cannot apply the `noop` metaparameter to resource-like class declarations.

## Assigning classes from an ENC

Classes can also be assigned to nodes by [external node classifiers][enc] and [LDAP node data][ldap_nodes]. Note that most ENCs assign classes with include-like behavior, and some ENCs assign them with resource-like behavior. See the [documentation of the ENC interface][enc] or the documentation of your specific ENC for complete details.

## Appendix: Smart parameter defaults

This design pattern can make for significantly cleaner code while enabling some really sophisticated behavior around default values.

``` puppet
# /etc/puppetlabs/code/modules/webserver/manifests/params.pp

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

# /etc/puppetlabs/code/modules/webserver/manifests/init.pp

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
```

To summarize what's happening here: When a class inherits from another class, it implicitly declares the base class. Since the base class's local scope already exists before the new class's parameters get declared, those parameters can be set based on information in the base class.

This is functionally equivalent to doing the following:

``` puppet
# /etc/puppetlabs/code/modules/webserver/manifests/init.pp

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
```

This is a significant readability win, especially if the amount of logic or the number of parameters grows beyond what's shown in the example.

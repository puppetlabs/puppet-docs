---
title: "Future Parser: Defined Resource Types"
layout: default
canonical: "/puppet/latest/reference/future_lang_defined_types.html"
---

[paramtypes]: ./future_parameter_types.html
[sitedotpp]: ./dirs_manifest.html
[namespaces]: ./future_lang_namespaces.html
[collector]: ./future_lang_collectors.html
[resource]: ./future_lang_resources.html
[naming]: ./future_lang_reserved.html#classes-and-types
[resource_namevar]: ./future_lang_resources.html#namenamevar
[relationships]: ./future_lang_relationships.html
[resource_title]: ./future_lang_resources.html#title
[metaparameters]: ./future_lang_resources.html#metaparameters
[modules]: ./modules_fundamentals.html
[resource_defaults]: ./future_lang_defaults.html
[classes]: ./future_lang_classes.html
[variable_assignment]: ./future_lang_variables.html#assignment
[variable]: ./future_lang_variables.html
[references_namespaced]: ./future_lang_datatypes.html#resource-references
[attributes]: ./future_lang_resources.html#attributes
[title]: ./future_lang_resources.html#title
[contains]: ./future_lang_containment.html
[catalog]: ./future_lang_summary.html#compilation-and-catalogs

**Defined resource types** (also called **defined types** or **defines**) are blocks of Puppet code that can be evaluated multiple times with different parameters. Once defined, they act like a new resource type: you can cause the block to be evaluated by [declaring a resource][resource] of that new type.

Defines can be used as simple macros or as a lightweight way to develop fairly sophisticated resource types.

Syntax
-----

### Defining a Type

{% highlight ruby %}
    # /etc/puppetlabs/puppet/modules/apache/manifests/vhost.pp
    define apache::vhost (Integer $port, String[1] $docroot, String[1] $servername = $title, String $vhost_name = '*') {
      include apache # contains Package['httpd'] and Service['httpd']
      include apache::params # contains common config settings
      $vhost_dir = $apache::params::vhost_dir
      file { "${vhost_dir}/${servername}.conf":
        content => template('apache/vhost-default.conf.erb'),
          # This template can access all of the parameters and variables from above.
        owner   => 'www',
        group   => 'www',
        mode    => '644',
        require => Package['httpd'],
        notify  => Service['httpd'],
      }
    }
{% endhighlight %}

This creates a new type called `apache::vhost`.

The general form of a type definition is:

* The `define` keyword
* The [name][naming] of the defined type
* An optional **set of parameters,** which consists of:
    * An opening parenthesis
    * A comma-separated list of **parameters,** each of which consists of:
        * An optional [parameter type][paramtypes] annotation (defaults to `Any`)
        * A new [variable][] name, including the `$` prefix
        * An optional equals (=) sign and **default value**
    * An optional trailing comma after the last parameter
    * A closing parenthesis
* An opening curly brace
* A block of arbitrary Puppet code, which generally contains at least one [resource declaration][resource]
* A closing curly brace

The definition does not cause the code in the block to be added to the [catalog][]; it only makes it available. To execute the code, you must declare one or more resources of the defined type.

### Declaring an Instance

Instances of a defined type (often just called "resources") can be declared the same way a [normal resource][resource] is declared. (That is, with a type, title, and set of attribute/value pairs.)

The **parameters** used when defining the type become the **attributes** (without the `$` prefix) used when declaring resources of that type. Parameters which have a **default value** are optional; if they are left out of the declaration, the default will be used. Parameters without defaults **must** be specified.

To declare a resource of the `apache::vhost` type from the example above:

{% highlight ruby %}
    apache::vhost {'homepages':
      port    => 8081,
      docroot => '/var/www-testhost',
    }
{% endhighlight %}

<!-- TODO: * => and using a title of default:  -->
<!-- TODO: resource declaration is a r-value, a Resource reference, and can be
     placed in an array etc. One reference is produced per title. -->
<!-- TODO: Dynamic Reference to Resource type e.g. Resource[$type] { } -->

Behavior
-----

If a defined type is present, you can declare resources of that type anywhere in your manifests. See ["Location"](#location) below for details.

Declaring a resource of the type will cause Puppet to re-evaluate the block of code in the definition, using different values for the parameters.

### Parameters and Attributes

Every parameter of a defined type can be used as a local variable inside the definition. These variables are not set with [normal assignment statements][variable_assignment]; instead, each instance of the defined type uses its attributes to set them:

{% highlight ruby %}
    apache::vhost {'homepages':
      port    => 8081, # Becomes the value of $port
      docroot => '/var/www-testhost', # Becomes the value of $docroot
    }
{% endhighlight %}

Note that the special variables `$title` and `$name` are both set to the defined type's name automatically, so they can't be used as parameters.

### `$title` and `$name`

Every defined type gets two "free" parameters, which are always available and do not have to be explicitly added to the definition:

* `$title` is always set to the [title][] of the instance. Since it is guaranteed to be unique for each instance, it is useful when making sure that contained resources are unique. (See "[Resource Uniqueness](#resource-uniqueness)" below.)
* `$name` defaults to the value of `$title`, but users can optionally specify a different value when they declare an instance. This is only useful for mimicking the behavior of a resource with a namevar, which is usually unnecessary. If you are wondering whether to use `$name` or `$title`, use `$title`.

Unlike the other parameters, the values of `$title` and `$name` are already available **inside the parameter list.** This means you can use `$title` as the default value (or part of the default value) for another attribute:

{% highlight ruby %}
    define apache::vhost (Integer $port, String[1] $docroot, String $servername = $title, String[1] $vhost_name = '*') { ...
{% endhighlight %}

### Resource Uniqueness

Since multiple instances of a defined type might be declared in your manifests, you must make sure that every resource in the definition will be **different in every instance.** Failing to do this will result in compilation failures with a "duplicate resource declaration" error.

You can make resources different across instances by making their **titles** and **names/namevars** include the value of `$title` or another parameter.

{% highlight ruby %}
    file { "${vhost_dir}/${servername}.conf":
{% endhighlight %}

Since `$title` (and possibly other parameters) will be unique per instance, this ensures the resources will be unique as well.

### Containment

Every instance of a defined type [contains][] all of its unique resources. This means any [relationships][] formed between the instance and another resource will be extended to every resource that makes up the instance.

### Metaparameters

The declaration of a defined type instance can include any [metaparameter][metaparameters]. If it does:

* Every resource contained in the instance will also have that metaparameter. So if you declare a defined resource with `noop => true`, every resource contained in it will also have `noop => true`, unless they specifically override it. Metaparameters which can take more than one value (like the [relationship][relationships] metaparameters) will merge the values from the container and any specific values from the individual resource.
* The value of the metaparameter can be used as a variable in the definition, as though it were a normal parameter. (For example, in an instance declared with `require => Class['ntp']`, the local value of `$require` would be `Class['ntp']`.)

### Resource Defaults

Just like with a normal resource type, you can declare [resource defaults][resource_defaults] for a defined type:

{% highlight ruby %}
    # /etc/puppetlabs/puppet/manifests/site.pp
    Apache::Vhost {
      port => 80,
    }
{% endhighlight %}

In this example, every resource of the type would default to port 80 unless specifically overridden.

Location
-----

Defined types can (and should) be stored in [modules][]. Puppet is automatically aware of any defined types in a valid module and can autoload them by name. Definitions should be stored in the `manifests/` directory of a module with one definition per file and each filename should reflect the name of its type. See [Module Fundamentals][modules] for more details.

> #### Aside: Best Practices
>
> You should usually only load defined types from modules. Although the additional options below this aside will work, they are not recommended.

You can also put type definitions in [the site manifest][sitedotpp]. If you do so, they may be placed anywhere in the file and are not parse-order dependent.

Type definitions may also be placed inside class definitions; however, this limits their availability to that class and is not recommended for any purpose. This is not formally deprecated in this version of Puppet, but may become so in a future release.


Naming
-----

[The characters allowed in a defined type's name are listed here][naming].

If the definition is stored in a module, its name must reflect its place in the module with its [namespace][namespaces]. See [Module Fundamentals][modules] for details.

Note that if a type's name has one or more [namespaces][] in it, each name segment must be capitalized when writing a [resource reference][references_namespaced], [collector][], or [resource default][resource_defaults]. (For example, a reference to the vhost resource declared above would be `Apache::Vhost['homepages']`.)

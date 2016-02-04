---
layout: default
title: "Language: Resources"
canonical: "/puppet/latest/reference/lang_resources.html"
---

[realize]: ./lang_virtual.html#syntax
[virtual]: ./lang_virtual.html
[containment]: ./lang_containment.html
[scope]: ./lang_scope.html
[report]: /guides/reporting.html
[append_attributes]: ./lang_classes.html#appending-to-resource-attributes
[types]: ./type.html
[bareword]: ./lang_datatypes.html#bare-words
[string]: ./lang_datatypes.html#strings
[array]: ./lang_datatypes.html#arrays
[datatype]: ./lang_datatypes.html
[inheritance]: ./lang_classes.html#inheritance
[relationships]: ./lang_relationships.html
[resdefaults]: ./lang_defaults.html
[reference]: ./lang_datatypes.html#resource-references
[class]: ./lang_classes.html
[defined_type]: ./lang_defined_types.html
[collector]: ./lang_collectors.html
[catalog]: ./lang_summary.html#compilation-and-catalogs

> * [See the Type Reference for complete information about Puppet's built-in resource types.][types]

**Resources** are the fundamental unit for modeling system configurations. Each resource describes some aspect of a system, like a service that must be running or a package that must be installed. The block of Puppet code that describes a resource is called a **resource declaration.**

Declaring a resource instructs Puppet to include it in the [catalog][] and manage its state on the target system. Resource declarations inside a [class definition][class] or [defined type][defined_type] are only added to the catalog once the class or an instance of the defined type is declared. [Virtual resources][virtual] are only added to the catalog once they are [realized][realize].

Syntax
-----

~~~ ruby
    # A resource declaration:
    file { '/etc/passwd':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }
~~~

Every resource has a **type,** a **title,** and a set of **attributes:**

~~~ ruby
    type {'title':
      attribute => value,
    }
~~~

The general form of a resource declaration is:

* The resource type, in lower-case
* An opening curly brace
* The title, which is a [string][]
* A colon
* Optionally, any number of attribute and value pairs, each of which consists of:
    * An attribute name, which is a bare word
    * A `=>` (arrow, fat comma, or hash rocket)
    * A value, which can be any [data type][datatype], depending on what the attribute requires
    * A trailing comma (note that the comma is optional after the final attribute/value pair)
* Optionally, a semicolon, followed by another title, colon, and attribute block
* A closing curly brace

Note that, in the Puppet language, whitespace is fungible.

### Type

The type identifies what kind of resource it is. Puppet has a large number of built-in resource types, including files on disk, cron jobs, user accounts, services, and software packages. [See here for a list of built-in resource types][types].

Puppet can be extended with additional resource types, written in Ruby or in the Puppet language.

### Title

The title is an identifying string. It only has to identify the resource to Puppet's compiler; it does not need to bear any relationship to the actual target system.

Titles **must be unique per resource type.** You may have a package and a service both titled "ntp," but you may only have one service titled "ntp." Duplicate titles will cause a compilation failure.

### Attributes

Attributes describe the desired state of the resource; each attribute handles some aspect of the resource.

Each resource type has its own set of available attributes; see [the type reference][types] for a complete list. Most types have a handful of crucial attributes and a larger number of optional ones. Many attributes have a default value that will be used if a value isn't specified.

Every attribute you declare must have a value; the [data type][datatype] of the value depends on what the attribute accepts. Most attributes that can take multiple values accept them as an [array][].

#### Parameters

When discussing resources and types, **parameter** is a synonym for attribute. "Parameter" is usually used when discussing a **type,** and "attribute" is usually used when discussing an individual **resource.**

Behavior
-----

A resource declaration adds a resource to the catalog, and tells Puppet to manage that resource's state. When Puppet applies the compiled catalog, it will:

* Read the actual state of the resource on the target system
* Compare the actual state to the desired state
* If necessary, change the system to enforce the desired state

### Uniqueness

Puppet does not allow you to declare the same resource twice. This is to prevent multiple conflicting values from being declared for the same attribute.

Puppet uses the [title](#title) and [name/namevar](#namenamevar) to identify duplicate resources --- if either of these is duplicated within a given resource type, the compilation will fail.

If multiple classes require the same resource, you can use a [class][] or a [virtual resource][virtual] to add it to the catalog in multiple places without duplicating it.

### Events

If Puppet makes any changes to a resource, it will log those changes as events. These events will appear in Puppet agent's log and in the run [report][], which is sent to the Puppet master and forwarded to any number of report processors.

### Parse-Order Independence

Resources are not applied to the target system in the order they are written in the manifests --- Puppet will apply the resources in whatever way is most efficient. If a resource must be applied before or after some other resource, you must explicitly say so. [See Relationships for more information.][relationships]

### Scope Independence

Resources are not subject to [scope][] --- a resource in any scope may be [referenced][reference] from any other scope, and local scopes do not introduce local namespaces for resource titles.

### Containment

Resources may be contained by [classes][class] and [defined types][defined_type]. See [Containment][] for more details.

Special Attributes
-----

### Name/Namevar

Most types have an attribute which identifies a resource _on the target system._ This is referred to as the "namevar," and is often simply called "name." For example, the `name` of a service or package is the name by which the system's service or package tools will recognize it. The `path` of a file is its location on disk.

Namevar values **must be unique per resource type,** with only rare exceptions (such as `exec`).

Namevars are not to be confused with the title, which identifies a resource _to Puppet._ However, they often have the same value, since the namevar's value will **default to the title** if it isn't specified. Thus, the `path` of the file example [above](#syntax) is `/etc/passwd`, even though it was never specified.

The distinction between title and namevar lets you use a single, consistently-titled resource to manage something whose name differs by platform. For example, the NTP service is `ntpd` on Red Hat-derived systems, but `ntp` on Debian and Ubuntu; the service resource could simply be titled "ntp," but could have its name set correctly by platform. Other resources could then form relationships to it without worrying that its title will change.

### Ensure

Many types have an `ensure` attribute. This generally manages the most fundamental aspect of the resource on the target system --- does the file exist, is the service running or stopped, is the package installed or uninstalled, etc.

Allowed values for `ensure` vary by type. Most types accept `present` and `absent`, but there may be additional variations. Be sure to check the reference for each type you are working with.

### Metaparameters

Some attributes in Puppet can be used with every resource type. These are called **metaparameters.** They don't map directly to system state; instead, they specify how Puppet should act toward the resource.

The most commonly used metaparameters are for specifying [order relationships][relationships] between resources.

You can see the full list of all metaparameters in the [Metaparameter Reference](./metaparameter.html).


Condensed Forms
-----

There are two ways to compress multiple resource declarations. You can also use [resource defaults][resdefaults] to reduce duplicate typing.

### Array of Titles

If you specify an array of strings as the title of a resource declaration, Puppet will treat it as multiple resource declarations with an identical block of attributes.

~~~ ruby
    file { ['/etc',
            '/etc/rc.d',
            '/etc/rc.d/init.d',
            '/etc/rc.d/rc0.d',
            '/etc/rc.d/rc1.d',
            '/etc/rc.d/rc2.d',
            '/etc/rc.d/rc3.d',
            '/etc/rc.d/rc4.d',
            '/etc/rc.d/rc5.d',
            '/etc/rc.d/rc6.d']:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
~~~

This example is the same as declaring each directory as a separate resource with the same attribute block. You can also store an array in a variable and specify the variable as a resource title:

~~~ ruby
    $rcdirectories = ['/etc',
                      '/etc/rc.d',
                      '/etc/rc.d/init.d',
                      '/etc/rc.d/rc0.d',
                      '/etc/rc.d/rc1.d',
                      '/etc/rc.d/rc2.d',
                      '/etc/rc.d/rc3.d',
                      '/etc/rc.d/rc4.d',
                      '/etc/rc.d/rc5.d',
                      '/etc/rc.d/rc6.d']

    file { $rcdirectories:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
~~~


Note that you cannot specify a separate namevar with an array of titles, since it would then be duplicated across all of the resources. Thus, each title must be a valid namevar value.

### Semicolon After Attribute Block

If you end an attribute block with a semicolon rather than a comma, you may specify another title, another colon, and another complete attribute block, instead of closing the curly braces. Puppet will treat this as multiple resources of a single type.

~~~ ruby
    file {
      '/etc/rc.d':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755';

      '/etc/rc.d/init.d':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755';

      '/etc/rc.d/rc0.d':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755';
    }
~~~


Adding or Modifying Attributes
-----

Although you cannot declare the same resource twice, you can add attributes to an already-declared resource. In certain circumstances, you can also override attributes.

### Amending Attributes With a Reference

~~~ ruby
    file {'/etc/passwd':
      ensure => file,
    }

    File['/etc/passwd'] {
      owner => 'root',
      group => 'root',
      mode  => '0640',
    }
~~~

The general form of a reference attribute block is:

* A [reference][] to the resource in question (or a multi-resource reference)
* An opening curly brace
* Any number of attribute => value pairs
* A closing curly brace

In normal circumstances, this idiom can only be used to add previously unmanaged attributes to a resource; it cannot override already-specified attributes. However, within an [inherited class][inheritance], you **can** use this idiom to override attributes.

### Amending Attributes With a Collector

~~~ ruby
    class base::linux {
      file {'/etc/passwd':
        ensure => file,
      }
      ...
    }

    include base::linux

    File <| tag == 'base::linux' |> {
      owner => 'root',
      group => 'root',
      mode  => '0640',
    }
~~~

The general form of a collector attribute block is:

* A [resource collector][collector] that matches any number of resources
* An opening curly brace
* Any number of attribute => value (or attribute +> value) pairs
* A closing curly brace

Much like in an [inherited class][inheritance], you can use the special `+>` keyword to append values to attributes that accept arrays. See [appending to attributes][append_attributes] for more details.

> Note that this idiom **must be used carefully,** if at all:
>
> * It **can always override** already-specified attributes, regardless of class inheritance.
> * It can affect large numbers of resources at once.
> * It will [implicitly realize][realize] any [virtual resources][virtual] that the collector matches. If you are using virtual resources at all, you must use extreme care when constructing collectors that are not intended to realize resources, and would be better off avoiding non-realizing collectors entirely.
> * Since it ignores class inheritance, you can override the same attribute twice, which results in a parse-order dependent race where the final override wins.

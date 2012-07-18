---
layout: default
title: "Language: Resources"
---


<!-- TODO: -->
[types]: /references/latest/type.html
[bareword]: ./lang_datatypes.html#bare-words
[string]: ./lang_datatypes.html#strings
[array]: ./lang_datatypes.html#arrays
[datatype]: ./lang_datatypes.html
[relationships]: 
[resdefaults]: ./lang_defaults.html

* [See the Type Reference for complete information about Puppet's built-in resource types.][types]

**Resources** are the fundamental unit for modeling system configurations. Each resource describes some aspect of a system, like a service that must be running or a package that must be installed. The block of Puppet code that describes a resource is called a **resource declaration.**

Declaring a resource instructs Puppet to include it in the catalog and manage its state on the target system.

Resource Declarations
-----

{% highlight ruby %}
    # A resource declaration:
    file { '/etc/passwd':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }
{% endhighlight %}

Every resource has a **type,** a **title,** and a set of **attributes.** The general form of a resource is:

{% highlight ruby %}
    type {'title':
      attribute => value,
    }
{% endhighlight %}

* The resource type, in lower-case.
* An opening curly brace.
* The title, which is a [string][].
* A colon.
* Any number of attribute and value pairs. Attributes are bare words, and are followed by a `=>` (arrow, fat comma, or hash rocket). Values are any [data type][datatype], depending on what the attribute requires, and are followed by a comma; the final comma in a declaration is optional.
* A closing curly brace. 

Note that whitespace is fungible in the Puppet language.

### Type

The type identifies what kind of resource it is. Puppet has a large number of built-in resource types, including files on disk, cron jobs, user accounts, services, and software packages. [See here for a list of built-in resource types][types].

Puppet can be extended with additional resource types, written in Ruby or in the Puppet language. 

### Title

The title is an identifying string. It only has to identify the resource to Puppet's compiler; it does not need to bear any relationship to the actual target system. 

Titles must be unique per resource type. You may have a file and a service titled "ntp," but you may only have one service titled "ntp." Duplicate titles will cause a compilation failure. 

### Attributes

Attributes describe the desired state of the resource; each attribute handles some aspect of the resource.

Each resource type has its own set of available attributes; see [the type reference][types] for a complete list. Most types have a handful of crucial attributes and a larger number of optional ones. Many attributes have a default value that will be used if a value isn't specified. 

Every attribute you declare must have a value; the [data type][datatype] of the value depends on what the attribute accepts. Most attributes that can take multiple values accept them as an [array][].

#### Parameters

When discussing resources and types, **parameter** is a synonym for attribute.


Special Attributes
-----

### Name/Namevar

Most types have an attribute which identifies a resource _on the target system._ This is referred to as the "namevar," and is often simply called "name." For example, the `name` of a service or package is the name by which the system's service or package tools will recognize it. The `path` of a file is its location on disk.

Namevar values **must be unique per resource type,** with only rare exceptions (such as `exec`). 

Namevars are not to be confused with the title, which identifies a resource _to Puppet._ However, they often have the same value, since the namevar's value will **default to the title** if it isn't specified. Thus, the `path` of the file example [above](#resource-declarations) is `/etc/passwd`, even though it was never specified. 

The distinction between title and namevar lets you use a single, consistently-titled resource to manage something whose name differs by platform. For example, the NTP service is `ntpd` on Red Hat-derived systems, but `ntp` on Debian and Ubuntu; the service resource could simply be titled "ntp," but could have its name set correctly by platform. Other resources could then form relationships to it without worrying that its title will change.

### Ensure

Many types have an `ensure` attribute. This generally manages the _existence_ of the resource on the target system.

Allowed values for `ensure` vary by type. Most types accept `present` and `absent`, but there may be additional nuances. Be sure to check the reference for each type you are working with.

### Metaparameters

Puppet has attributes which can be used with every resource type, called **metaparameters.** These don't map directly to system state; instead, they specify how Puppet should act toward the resource.

The most commonly used metaparameters are for specifying [order relationships][relationships] between resources. 

You can see the full list of all metaparameters in the [Metaparameter Reference](/references/stable/metaparameter.html).


Condensed Forms
-----

There are two ways to compress multiple resource declarations. You can also use [resource defaults][resdefaults] to reduce duplicate typing. 

### Array of Titles

If you specify an array of strings as the title of a resource declaration, Puppet will treat it as multiple resource declarations with an identical block of attributes. 

{% highlight ruby %}
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
      mode   => 0755,
    }
{% endhighlight %}

This example is the same as declaring each directory as a separate resource with the same attribute block. You can also store an array in a variable and specify the variable as a resource title: 

{% highlight ruby %}
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
      mode   => 0755,
    }
{% endhighlight %}


Note that you cannot specify a separate namevar with an array of titles, since it would then be duplicated across all of the resources. Thus, each title must be a valid namevar value. 

### Semicolon After Attribute Block

If you end an attribute block with a semicolon rather than a comma, you may specify another title, another colon, and another complete attribute block, instead of closing the curly braces. Puppet will treat this as multiple resources of a single type. 

{% highlight ruby %}
    file {
      '/etc/rc.d':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => 0755;
        
      '/etc/rc.d/init.d':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => 0755;
        
      '/etc/rc.d/rc0.d':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => 0755;
    }
{% endhighlight %}



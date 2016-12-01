---
layout: default
title: "Future Parser: Resources"
canonical: "/puppet/latest/reference/lang_resources.html"
---

[realize]: ./future_lang_virtual.html#syntax
[virtual]: ./future_lang_virtual.html
[containment]: ./future_lang_containment.html
[scope]: ./future_lang_scope.html
[report]: /guides/reporting.html
[types]: ./type.html
[string]: ./future_lang_data_string.html
[array]: ./future_lang_data_array.html
[datatype]: ./future_lang_data.html
[relationships]: ./future_lang_relationships.html
[reference]: ./future_lang_data_resource_reference.html
[class]: ./future_lang_classes.html
[defined_type]: ./future_lang_defined_types.html
[catalog]: ./future_lang_summary.html#compilation-and-catalogs
[files]: ./type.html#file
[cron jobs]: ./type.html#cron
[services]: ./type.html#service
[custom_types]: /guides/custom_types.html
[resource_advanced]: ./future_lang_resources_advanced.html
[expressions]: ./future_lang_expressions.html


**Resources** are the fundamental unit for modeling system configurations. Each resource describes some aspect of a system, like a specific service or package.

A **resource declaration** is an expression that describes the desired state for a resource and tells Puppet to add it to the [catalog][]. When Puppet applies that catalog to a target system, it manages every resource it contains, ensuring that the actual state matches the desired state.

This page describes the basics of using resource declarations. For more advanced syntax, see [Resources (Advanced).][resource_advanced]


Resource Types
-----

Every resource is associated with a **resource type,** which determines the kind of configuration it manages.

Puppet has many built-in resource types, like [files][], [cron jobs][], [services][], etc. [See the resource type reference][types] for information about the built-in resource types.

You can also add new resource types to Puppet:

* [Defined types][defined_type] are lightweight resource types written in the Puppet language.
* [Custom resource types][custom_types] are written in Ruby, and have access to the same capabilities as Puppet's built-in types.

Simplified Syntax
-----

[inpage_simplified]: #simplified-syntax

Resource declarations have a lot of features, but beginners can accomplish a lot with just a subset of these. For more advanced syntax (including expressions that declare multiple resources at once), see [Resources (Advanced).][resource_advanced]

~~~ ruby
    # A resource declaration:
    file { '/etc/passwd':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }
~~~

Every resource has a **resource type,** a **title,** and a set of **attributes:**

~~~ ruby
    <TYPE> { '<TITLE>':
      <ATTRIBUTE> => <VALUE>,
    }
~~~

The form of a resource declaration is:

* The **resource type,** which is a word with no quotes.
* An opening curly brace (`{`).
* The **title,** which is a [string][].
* A colon (`:`).
* Optionally, any number of **attribute and value pairs,** each of which consists of:
    * An attribute name, which is a lowercase word with no quotes.
    * A `=>` (called an arrow, "fat comma," or "hash rocket").
    * A value, which can have any [data type][datatype].
    * A trailing comma.
* A closing curly brace (`}`).

Note that you can use any amount of whitespace in the Puppet language.

### Title

The title is a string that identifies a resource to Puppet's compiler.

A title doesn't have to match the name of what you're managing on the target system, but you'll often want it to: the value of the ["namevar" attribute][inpage_namevar] defaults to the title, so using the name in the title can save you some typing.

Titles **must be unique per resource type.** You can have a package and a service both titled "ntp," but you can only have one service titled "ntp." Duplicate titles will cause a compilation failure.

### Attributes

Attributes describe the desired state of the resource; each attribute handles some aspect of the resource.

Each resource type has its own set of available attributes; see [the resource type reference][types] for a complete list. Most resource types have a handful of crucial attributes and a larger number of optional ones.

Every attribute you declare must have a value; the [data type][datatype] of the value depends on what the attribute accepts.

> #### Synonym Note: Parameters and Properties
>
> When discussing resources and types, **parameter** is a synonym for attribute. You might also hear **property,** which has a slightly different meaning when discussing the Ruby implementation of a resource type or provider. (Properties always represent concrete state on the target system. A provider can check the current state of a property, and switch it to new states.)
>
> When talking about resource declarations in the Puppet language, you should use either "attribute" or "parameter." We suggest "attribute."

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

### Relationships and Ordering

[ordering]: ./configuration.html#ordering

By default, the order of resources in a manifest doesn't affect the order in which those resources will be applied. Puppet will apply _unrelated_ resources in a mostly random (but consistent between runs) order.

If a resource must be applied before or after some other resource, you should declare a relationship between them, to make sure Puppet applies them in the right order. You can also make changes in one resource cause a refresh of some other resource. See [the Relationships and Ordering page][relationships] for more information.

You can also change [the `ordering` setting][ordering] to make Puppet apply unrelated resources in manifest order. This will be the new default behavior in Puppet 4.

### Changes, Events, and Reporting

If Puppet makes any changes to a resource, it will log those changes as events. These events will appear in Puppet agent's log and in the run [report][], which is sent to the Puppet master and forwarded to any number of report processors.

### Scope Independence

Resources are not subject to [scope][] --- a resource in any scope can be [referenced][reference] from any other scope, and local scopes do not introduce local namespaces for resource titles.

### Containment

Resources can be contained by [classes][class] and [defined types][defined_type] --- when something forms a [relationship][relationships] with the container, the contained resources are also affected. See [Containment][] for more details.

### Delaying Resource Evaluation

The Puppet language includes some constructs that let you describe a resource but delay adding it to the catalog. For example:

* [Classes][class] and [defined types][defined_type] can contain groups of resources. These resources will only be managed if you add that class (or defined resource) to the catalog.
* [Virtual resources][virtual] are only added to the catalog once they are [realized][realize].


Special Resource Attributes
-----

### Name/Namevar

[inpage_namevar]: #namenamevar

Most resource types have an attribute which identifies a resource _on the target system._ This special attribute is called the "namevar," and the attribute itself is often (but not always) just `name`. For example, the `name` of a service or package is the name by which the system's service or package tools will recognize it. On the other hand, the `file` type's namevar is `path`, the file's location on disk.

The [resource type reference][types] lists the namevars for all of the core resource types. For custom resource types, check the documentation for the module that provides that resource type.

Namevar values **must be unique per resource type,** with only rare exceptions (such as `exec`).

Namevars are not to be confused with the **title**, which identifies a resource _to Puppet._ However, they often have the same value, since the namevar's value will default to the title if it isn't specified. Thus, the `path` of the file example [above][inpage_simplified] is `/etc/passwd`, even though we didn't include the `path` attribute in the resource declaration.

The separation between title and namevar lets you use a consistently-titled resource to manage something whose name differs by platform. For example, the NTP service might be `ntpd` on Red Hat-derived systems, but `ntp` on Debian and Ubuntu; to accommodate that, you could title the service "ntp," but set its name according to the OS. Other resources could then form relationships to it without worrying that its title will change.

### Ensure

Many resource types have an `ensure` attribute. This generally manages the most important aspect of the resource on the target system --- does the file exist, is the service running or stopped, is the package installed or uninstalled, etc.

Allowed values for `ensure` vary by resource type. Most accept `present` and `absent`, but there might be additional variations. Be sure to check the reference for each resource type you are working with.

### Metaparameters

Some attributes in Puppet can be used with every resource type. These are called **metaparameters.** They don't map directly to system state; instead, they specify how Puppet should act toward the resource.

The most commonly used metaparameters are for specifying [order relationships][relationships] between resources.

You can see the full list of all metaparameters in the [Metaparameter Reference](./metaparameter.html).



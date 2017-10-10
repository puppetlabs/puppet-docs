---
layout: default
title: "Language: Resources"
canonical: "/puppet/latest/lang_resources.html"
---

[realize]: ./lang_virtual.html#syntax
[virtual]: ./lang_virtual.html
[containment]: ./lang_containment.html
[scope]: ./lang_scope.html
[report]: /guides/reporting.html
[types]: ./type.html
[string]: ./lang_data_string.html
[array]: ./lang_data_array.html
[datatype]: ./lang_data.html
[relationships]: ./lang_relationships.html
[reference]: ./lang_data_resource_reference.html
[class]: ./lang_classes.html
[defined_type]: ./lang_defined_types.html
[catalog]: ./lang_summary.html#compilation-and-catalogs
[files]: /puppet/3.7/type.html#file
[cron jobs]: /puppet/3.7/type.html#cron
[services]: /puppet/3.7/type.html#service
[custom_types]: /guides/custom_types.html
[resource_advanced]: ./lang_resources_advanced.html
[expressions]: ./lang_expressions.html


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

**Note:** If a resource type has multiple namevars, the type gets to specify how (and if) the title will map to those namevars. For example, the `package` type uses the `provider` attribute to help determine uniqueness, but that attribute has no special relationship with the title. See a type's documentation for details about how it maps title to namevars.

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

### Unmanaged Resources

If the catalog doesn't contain a resource, Puppet will _do nothing_ with whatever that resource might have described.

This means that ceasing to manage something isn't the same as deleting it. If you remove a package resource from your manifests, this won't cause Puppet to _uninstall_ the package; it will just cause Puppet to _stop caring_ about the package. To make sure a package is removed, you would have to manage it as a resource and set `ensure => absent`.

### Uniqueness

Puppet does not allow you to declare the same resource twice. This is to prevent multiple conflicting values from being declared for the same attribute.

Puppet uses the [title](#title) and [name/namevar](#namenamevar) to identify duplicate resources --- if either of these is duplicated within a given resource type, the compilation will fail.

If multiple classes require the same resource, you can use a [class][] or a [virtual resource][virtual] to add it to the catalog in multiple places without duplicating it.

### Relationships and Ordering

[ordering]: ./configuration.html#ordering

By default, Puppet applies unrelated resources in the order in which they're written in the manifest. You can disable this with the [`ordering`][ordering] setting.

However, if a resource must be applied before or after some other resource, you should declare a relationship between them, to show that their order isn't coincidental. You can also make changes in one resource cause a refresh of some other resource. See [the Relationships and Ordering page][relationships] for more information.

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

This is different from the **title**, which identifies a resource _to Puppet's compiler._ However, they often have the same value, since the namevar's value will usually default to the title if it isn't specified. Thus, the `path` of the file example [above][inpage_simplified] is `/etc/passwd`, even though we didn't include the `path` attribute in the resource declaration.

The separation between title and namevar lets you use a consistently-titled resource to manage something whose name differs by platform. For example, the NTP service might be `ntpd` on Red Hat-derived systems, but `ntp` on Debian and Ubuntu; to accommodate that, you could title the service "ntp," but set its name according to the OS. Other resources could then form relationships to it without worrying that its title will change.

The [resource type reference][types] lists the namevars for all of the core resource types. For custom resource types, check the documentation for the module that provides that resource type.

#### Simple Namevars

Most resource types only have one namevar.

With a single namevar, the value **must be unique per resource type,** with only rare exceptions (such as `exec`).

If a value for the namevar isn't specified, it will default to the resource's title.

#### Multiple Namevars

Sometimes, a single value isn't sufficient to identify a resource on the target system. For example, consider a system that has multiple package providers available: the `yum` provider has a package called `mysql`, and the `gem` provider _also_ has a package called `mysql` that installs completely different (and non-conflicting) software. In this case, the `name` of both packages would be `mysql`.

Thus, some resource types have more than one namevar, and Puppet combines their values to determine whether a resource is uniquely identified. If two resources have the same values for _all_ of their namevars, Puppet will raise an error.

A resource type can define its own behavior for how to map a title to its namevars, if one or more of them is unspecified. For example, the `package` type has two namevars (`name` and `provider`), but only `name` will default to the title. For info about other resource types, see that type's documentation.

### Ensure

Many resource types have an `ensure` attribute. This generally manages the most important aspect of the resource on the target system --- does the file exist, is the service running or stopped, is the package installed or uninstalled, etc.

Allowed values for `ensure` vary by resource type. Most accept `present` and `absent`, but there might be additional variations. Be sure to check the reference for each resource type you are working with.

### Metaparameters

Some attributes in Puppet can be used with every resource type. These are called **metaparameters.** They don't map directly to system state; instead, they specify how Puppet should act toward the resource.

The most commonly used metaparameters are for specifying [order relationships][relationships] between resources.

You can see the full list of all metaparameters in the [Metaparameter Reference](/puppet/3.7/metaparameter.html).



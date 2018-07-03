---
layout: default
title: "Future Parser: Data Types: Resource Types"
canonical: "/puppet/latest/reference/lang_data_resource_type.html"
---

[data type]: ./future_lang_data_type.html
[resource reference]: ./future_lang_data_resource_reference.html
[resource declaration]: ./future_lang_resources.html
[resource default statement]: ./future_lang_defaults.html
[classes]: ./future_lang_classes.html
[class reference]: ./future_lang_data_resource_reference.html#class-references
[catalogentry]: ./future_lang_data_abstract.html#catalogentry

Resource types are a special family of [data types][data type] that behave kind of weirdly. They are all subtypes of the fairly abstract `Resource` data type. [Resource references][resource reference] are a more useful subset of this data type family.

In the Puppet language, there are **literally never** any actual values whose data type is one of these data types. That is, you can never create an expression where `$my_value =~ Resource` evaluates to true. (For example, a [resource declaration][] --- an expression whose value you might expect would be a resource --- executes a side effect and then produces a [resource reference][] as its value. A resource reference is a data type in this family of data types, rather than a value _that has_ one of those data types.)

In almost all situations, if one of these resource type data types is involved, it makes more sense to treat it as a special language keyword than to treat it as part of a hierarchy of data types. It does have a place in that hierarchy; it's just complicated, and you don't need to know it to get nearly anything done in the Puppet language.

In other words: if you're trying to learn everything that matters about the Puppet language, this is permission to turn back and go to another page.

## Basics

Puppet automatically creates new known [data type][] values for every _resource type_ it knows about, including custom resource types and defined types.

These one-off data types share the name of the resource type they correspond to, with the first letter of every namespace segment capitalized. For example, the `file` type creates a data type called `File`.

Additionally, there is a parent `Resource` data type. All of these one-off data types are more-specific subtypes of `Resource`.

## Usage

### Resource Data Types Without Title

A resource data type can be used in the following places:

* The resource type slot of a [resource declaration][].
* The resource type slot of a [resource default statement][].

For example:

~~~ ruby
    # A resource declaration using a resource data type:
    File { "/etc/ntp.conf":
      mode  => "0644",
      owner => "root",
      group => "root",
    }

    # Equivalent to the above:
    Resource["file"] { "/etc/ntp.conf":
      mode  => "0644",
      owner => "root",
      group => "root",
    }

    # A resource default:
    File {
      mode  => "0644",
      owner => "root",
      group => "root",
    }
~~~

### Resource Data Types With Title

If a resource data type includes a title, it acts as a [resource reference][].

A resource reference can be used in several places. They're useful enough that they have [their own page.][resource reference]

## The `<SOME ARBITRARY RESOURCE TYPE>` Data Type

For each resource type `mytype` known to Puppet, there is a [data type][] `Mytype`. It matches **no** values that can be produced in the Puppet language.

You can use parameters to restrict which values `Mytype` will match, but it will still match no values.

### Parameters

The full signature for a resource-type-corresponding data type `Mytype` is:

    Mytype[<RESOURCE TITLE>]

All of these parameters are optional. They must be listed in order; if you need to specify a later parameter, you must specify values for any prior ones.

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1 | Resource title | `String` | nothing | The title of some specific resource of this type. If provided, this will turn this data type into a usable [resource reference][].

### Examples

* `File` --- the data type corresponding to the `file` resource type.
* `File['/tmp/foo']` --- a resource reference to the `file` resource whose title is `/tmp/foo`.

Also:

* `Type[File]` --- the data type that _matches_ any [resource references][resource reference] to `file` resources. This is useful for, e.g., restricting the values of class or defined type parameters.

## The `Resource` Data Type

There is also a general `Resource` data type, which all `<SOME ARBITRARY RESOURCE TYPE>` data types are more-specific subtypes of.

Like the `Mytype`-style data types, it matches **no** values that can be produced in the Puppet language.

You can use parameters to restrict which values `Resource` will match, but it will still match no values.

This is mostly useful if:

* You need to interact with a resource type before you know its name. For example, you can do some clever business with the iteration functions to re-implement the `create_resources` function in the Puppet language, where your lambda will receive arguments telling it to create resources of some resource type at runtime.
* Someone has somehow created a resource type whose name is invalid in the Puppet language, possibly by conflicting with a reserved word --- you can use a `Resource` value to refer to that resource type in resource declarations and resource default statements, and to create resource references.

We will take this chance to say, yet again, that most users won't need to deal with this.

### Parameters

The full signature for `Resource` is:

    Resource[<RESOURCE TYPE>, <RESOURCE TITLE>...]

All of these parameters are optional. They must be listed in order; if you need to specify a later parameter, you must specify values for any prior ones.

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1 | Resource type | `String` or `Resource` | nothing | A resource type, either as a string or a `Resource` data type value. If provided, this will turn this data type into a resource-specific data type. `Resource[Mytype]` and `Resource["mytype"]` are both 100% identical to the data type `Mytype`.
2–∞ | Resource title | `String` | nothing | The title of some specific resource of this type. If provided, this will turn this data type into a usable [resource reference][] or array of resource references. `Resource[Mytype, "mytitle"]` and `Resource["mytype", "mytitle"]` are both 100% identical to the data type `Mytype["mytitle"]`.


### Examples

* `Resource[File]` --- the data type corresponding to the `file` resource type.
* `Resource[File, '/tmp/foo']` --- a resource reference to the `file` resource whose title is `/tmp/foo`.
* `Resource["file", '/tmp/foo']` --- a resource reference to the `file` resource whose title is `/tmp/foo`.
* `Resource[File, '/tmp/foo', '/tmp/bar']` --- equivalent to `[ File['/tmp/foo'], File['/tmp/bar'] ]`.

Also:

* `Type[Resource[File]]` --- a synonym for the data type that _matches_ any [resource references][resource reference] to `file` resources. This is useful for, e.g., restricting the values of class or defined type parameters.
* `Type[Resource["file"]]` --- another synonym for the data type that _matches_ any [resource references][resource reference] to `file` resources. This is useful for, e.g., restricting the values of class or defined type parameters.


## The `Class` Data Type

There is also a `Class` data type, which is roughly equivalent to the set of `Mytype` data types except for [classes][].

Like the `Mytype`-style data types, it matches **no** values that can be produced in the Puppet language.

You can use parameters to restrict which values `Class` will match, but it will still match no values.

### Parameters

The full signature for `Class` is:

    Class[<CLASS NAME>]

All of these parameters are optional. They must be listed in order; if you need to specify a later parameter, you must specify values for any prior ones.

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1 | Class name | `String` | nothing | The name of some class. If provided, this will turn this data type into a usable [class reference][].


### Examples

* `Class["apache"]` --- a [class reference][] to class `apache`.

Also:

* `Type[Class]` --- the data type that _matches_ any [class references][class reference]. This is useful for, e.g., restricting the values of class or defined type parameters.

## Related Data Types

The abstract [`Catalogentry` data type][catalogentry] is the supertype of `Resource` and `Class`. You can use `Type[Catalogentry]` as the data type for a class or defined type parameter that can accept both class references and resource references.

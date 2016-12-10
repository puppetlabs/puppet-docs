---
layout: default
title: "Language: Resources (advanced)"
---


[append_attributes]: ./lang_classes.html#appending-to-resource-attributes
[inheritance]: ./lang_classes.html#inheritance
[resdefaults]: ./lang_defaults.html
[collector]: ./lang_collectors.html
[reference]: ./lang_data_resource_reference.html
[realize]: ./lang_virtual.html#syntax
[virtual]: ./lang_virtual.html
[resources]: ./lang_resources.html
[expressions]: ./lang_expressions.html
[string]: ./lang_data_string.html
[array]: ./lang_data_array.html
[hash]: ./lang_data_hash.html
[datatype]: ./lang_data.html

[resource_data_type]: ./lang_data_resource_type.html
[default]: ./lang_data_default.html
[hash_merge]: ./lang_expressions.html#merging
[catalog]: ./lang_summary.html#compilation-and-catalogs
[namevar]: ./lang_resources.html#namenamevar
[iteration]: ./lang_iteration.html


Resource declarations are [expressions][] that describe the desired state for one or more resources and instruct Puppet to add those resources to the [catalog][].

[We describe the basics of resource declarations on another page,][resources] but the resource expression syntax has a lot of additional features, including:

* Describing many resources at once.
* Setting a group of attributes from a [hash][] (with the special `*` attribute).
* Setting default attributes.
* Specifying an abstract resource type.
* Amending or overriding attributes after a resource is already declared.

This page describes the full syntax of resource expressions. Please make sure you've read [the main page about resources][resources] before reading any further.



## Full syntax

``` puppet
<TYPE> {
  default:
    *           => <HASH OF ATTRIBUTE/VALUE PAIRS>,
    <ATTRIBUTE> => <VALUE>,
  ;
  '<TITLE>':
    *           => <HASH OF ATTRIBUTE/VALUE PAIRS>,
    <ATTRIBUTE> => <VALUE>,
  ;
  '<NEXT TITLE>':
    ...
  ;
  ['<TITLE'>, '<TITLE>', '<TITLE>']:
    ...
  ;
}
```

The full, generalized form of a resource declaration expression is:

* The **resource type,** which can be one of:
    * A lowercase word with no quotes, like `file`.
    * A [resource type data type][resource_data_type], like `File`, `Resource[File]` or `Resource['file']`. It must have a type but not a title.
* An opening curly brace (`{`).
* One or more **resource bodies**, separated with semicolons (`;`). Each resource body consists of:
    * A **title,** which can be one of:
        * A [string][].
        * An [array][] of strings (declares multiple resources).
        * [The special value `default`][default] (sets default attribute values for other resource bodies in the same expression).
    * A colon (`:`).
    * Optionally, any number of **attribute and value pairs,** separated with commas (`,`). Each attribute/value pair consists of:
        * An attribute name, which can be one of:
            * A lowercase word with no quotes.
            * The special attribute `*` (takes a [hash][] and sets _other_ attributes).
        * A `=>` (called an arrow, "fat comma," or "hash rocket").
        * A value, which can have any [data type][datatype].
    * Optionally, a trailing comma after the last attribute/value pair.
* Optionally, a trailing semicolon after the last resource body.
* A closing curly brace (`}`).


## Multiple resource bodies


If a resource expression includes more than one resource body, the expression will declare multiple resources of that resource type. (A resource body is a title and a set of attributes; each body must be separated from the next one with a semicolon.)

Each resource in an expression is almost completely independent of the others, and they can have completely different values for their attributes. The only connections between resources that share an expression are:

* They all have the same resource type.
* They can all draw from the same pool of default values, if a resource body with the special title `default` is present. (See below for details.)


## Value of a resource expression

Resource declarations are [expressions][] in the Puppet language --- they always have a side effect (adding a resource to the catalog), but they also resolve to a value.

The value of a resource declaration is an [array][] of [resource references][reference], with one reference for each resource the expression describes.

**Note:** A resource declaration has extremely low precedence; in fact, it's even lower than the variable assignment operator (`=`). This means that in almost every place where you can use a resource declaration for its value, you will need to surround it with parentheses to properly associate it with the expression that uses the value.


## Per-expression default attributes

[inpage_defaults]: #per-expression-default-attributes

If a resource expression includes a resource body whose title is [the special value `default`][default], Puppet won't create a new resource named "default."

Instead, every other resource in that expression will use attribute values from the `default` body if it doesn't have an explicit value for one of those attributes.

This is useful because it lets you set many attributes at once (like with an array of titles), but also lets you override some of them.

``` puppet
file {
  default:
    ensure => file,
    owner  => "root",
    group  => "wheel",
    mode   => "0600",
  ;
  ['ssh_host_dsa_key', 'ssh_host_key', 'ssh_host_rsa_key']:
    # use all defaults
  ;
  ['ssh_config', 'ssh_host_dsa_key.pub', 'ssh_host_key.pub', 'ssh_host_rsa_key.pub', 'sshd_config']:
    # override mode
    mode => "0644",
  ;
}
```

The position of the `default` body in an expression doesn't matter; resources above and below it will all use the default attributes if applicable.

You can only have one `default` resource body per resource expression.


## Setting attributes from a hash


[inpage_splat]: #setting-attributes-from-a-hash

A resource body can use the special attribute `*` (asterisk or splat character) to set _other_ attributes for that resource from a hash.

The value of the `*` attribute must be a [hash][], where:

* Each key is the name of a valid attribute for that resource type, as a string.
* Each value is a valid value for the attribute it's assigned to.

This will set values for that resource's attributes, using every attribute and value listed in the hash.

``` puppet
$file_ownership = {
  "owner" => "root",
  "group" => "wheel",
  "mode"  => "0644",
}

file { "/etc/passwd":
  ensure => file,
  *      => $file_ownership,
}
```

You cannot set any attribute more than once for a given resource; if you try, Puppet will raise a compilation error. This means:

* If you use a hash to set attributes for a resource, you cannot set a different, explicit value for any of those attributes. (If `mode` is present in the hash, you can't also set `mode => "0644"` in that resource body.)
* You can't use the `*` attribute multiple times in one resource body, since `*` itself acts like an attribute.

If you want to use some attributes from a hash and override others, you can either use a hash to set [per-expression defaults][inpage_defaults], or use [the `+` (merging) operator][hash_merge] to combine attributes from two hashes (with the right-hand hash overriding the left-hand one).

## Using an abstract resource type


[inpage_abstract]: #using-an-abstract-resource-type

Since a resource expression can accept a [resource type data type][resource_data_type] as its resource type, you can use a `Resource[<TYPE>]` value to specify a non-literal resource type, where the `<TYPE>` portion can be read from a variable.

That is, all of the following are equivalent:

``` puppet
file { "/tmp/foo": ensure => file, }
File { "/tmp/foo": ensure => file, }
Resource[File] { "/tmp/foo": ensure => file, }

$mytype = File
Resource[$mytype] { "/tmp/foo": ensure => file, }

$mytypename = "file"
Resource[$mytypename] { "/tmp/foo": ensure => file, }
```

This lets you declare resources without knowing in advance what type of resources they'll be, which can enable interesting transformations of data into resources. For a demonstration, see the `create_resources` example below.

## Arrays of titles


If you specify an [array][] of [strings][string] as the title of a resource body, Puppet will create multiple resources with the same set of attributes. This is useful when you have many resources that are nearly identical.

``` puppet
$rc_dirs = [
  '/etc/rc.d',       '/etc/rc.d/init.d','/etc/rc.d/rc0.d',
  '/etc/rc.d/rc1.d', '/etc/rc.d/rc2.d', '/etc/rc.d/rc3.d',
  '/etc/rc.d/rc4.d', '/etc/rc.d/rc5.d', '/etc/rc.d/rc6.d',
]

file { $rc_dirs:
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
}
```

Note that if you do this, you _must_ let the [namevar][] attributes of these resources default to their titles. You can't specify an explicit value for the namevar, because it will apply to all of those resources.

## Adding or modifying attributes


Although you cannot declare the same resource twice, you can add attributes to an already-declared resource. In certain circumstances, you can also override attributes.

### Amending attributes with a resource reference

``` puppet
file {'/etc/passwd':
  ensure => file,
}

File['/etc/passwd'] {
  owner => 'root',
  group => 'root',
  mode  => '0640',
}
```

The general form of a resource reference attribute block is:

* A [resource reference][reference] to the resource in question (or a multi-resource reference)
* An opening curly brace
* Any number of attribute => value pairs
* A closing curly brace

Normally, you can only use this syntax to add previously unmanaged attributes to a resource; it cannot override already-specified attributes. However, within an [inherited class][inheritance], you **can** use this idiom to override attributes.

You can also use the special `*` attribute to amend attributes from a hash. See [Setting Attributes From a Hash (above)][inpage_splat] for details.

### Amending attributes with a collector

``` puppet
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
```

The general form of a collector attribute block is:

* A [resource collector][collector] that matches any number of resources
* An opening curly brace
* Any number of attribute => value (or attribute +> value) pairs
* A closing curly brace

Much like in an [inherited class][inheritance], you can use the special `+>` keyword to append values to attributes that accept arrays. See [appending to attributes][append_attributes] for more details.

You can also use the special `*` attribute to amend attributes from a hash. See [Setting Attributes From a Hash (above)][inpage_splat] for details.

> **Note:** Be very careful when amending attributes with a collector.
>
> * It **can always override** already-specified attributes, regardless of class inheritance.
> * It can affect large numbers of resources at once.
> * It will [implicitly realize][realize] any [virtual resources][virtual] that the collector matches. If you are using virtual resources at all, you must use extreme care when constructing collectors that are not intended to realize resources, and would be better off avoiding non-realizing collectors entirely.
> * Since it ignores class inheritance, you can override the same attribute twice, which results in a evaluation-order dependent race where the final override wins.



## Advanced examples

### Local resource defaults

Since classic [resource default statements][resdefaults] are subject to dynamic scope, they can escape the place where they're declared and affect unpredictable areas of code. Sometimes this is powerful and useful, and other times it's really bad, like when you want to set defaults for your module's file resources, but you're also declaring classes and defined resources from other modules and want to avoid any contagious effect.

To control those effects, you can define your defaults in a variable and re-use them in multiple places, by combining [per-expression defaults][inpage_defaults] and [setting attributes from a hash][inpage_splat].

``` puppet
class mymodule::params {
  $file_defaults = {
    mode  => "0644",
    owner => "root",
    group => "root",
  }
  # ...
}

class mymodule inherits mymodule::params {
  file { default: *=> $mymodule::params::file_defaults;
    "/etc/myconfig":
      ensure => file,
    ;
  }
}
```

### Implementing the `create_resources` function

Since the Puppet 2.7 era, the `create_resources` function has been a useful tool of last resort when creating modules that were too complex to express in the Puppet language. It lets you use anything you want to create a data structure describing any number of resources, then add all of those resources to the catalog.

In the modern Puppet language, you can combine [iteration][], [abstract resource types][inpage_abstract], [per-expression defaults][inpage_defaults], and [attributes from a hash][inpage_splat] to duplicate the functionality of `create_resources`.

The `create_resources` function expects three arguments:

* A resource type.
* A [hash][], where:
    * Each key is a resource title.
    * Each value is a hash of attributes and values for that resource.
* Optionally, a [hash][] of _default_ attributes and values, to be used for any resources that don't specify their own values for those attributes.

If we assume we have those values in variables (`$type`, `$resources`, and `$defaults`):

``` puppet
$type = "user"
$resources = {
  'nick' => { uid    => '1330',
              groups => ['developers', 'operations', 'release'], },
  'dan'  => { uid    => '1308',
              groups => ['developers', 'prosvc', 'release'], },
}
$defaults = { gid => 'allstaff',
              managehome => true,
              shell      => 'bash',
            }
```

...then we can create matching resources like this:

``` puppet
$resources.each |String $resource, Hash $attributes| {
  Resource[$type] {
    $resource: * => $attributes;
    default:   * => $defaults;
  }
}
```

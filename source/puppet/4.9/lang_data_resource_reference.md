---
layout: default
title: "Language: Data types: Resource and class references"
---

[relationship]: ./lang_relationships.html
[chaining]: ./lang_relationships.html#syntax-chaining-arrows
[attribute_override]: ./lang_resources_advanced.html#adding-or-modifying-attributes
[string]: ./lang_data_string.html
[undef]: ./lang_data_undef.html
[data type]: ./lang_data_type.html
[resource_types]: ./lang_data_resource_type.html
[hash access]: ./lang_data_hash.html#accessing-values
[resource]: ./lang_resources.html

Resource references identify a specific Puppet [resource][] by its type and title. Several attributes, such as the [relationship][] metaparameters, require resource references.


## Syntax

``` puppet
# A reference to a file resource:
subscribe => File['/etc/ntp.conf'],
...
# A type with a multi-segment name:
before => Concat::Fragment['apache_port_header'],
```

The general form of a resource reference is:

* The **resource type,** capitalized (every segment must be capitalized if the resource type includes a namespace separator \[`::`\])
* An opening square bracket
* The **title** of the resource as a [string][], or a comma-separated list of titles
* A closing square bracket

Unlike variables, resource references are not evaluation-order dependent, and can be used before the resource itself is declared.

### Class references

Class references work identically to resource references, but use the pseudo-resource type `Class` instead of some other resource type name.

``` puppet
require => Class['ntp::install'],
```


### Multi-resource references

Resource reference expressions with an **array of titles** or **comma-separated list of titles** refer to multiple resources of the same type. They evaluate to an array of single-title resource references.

``` puppet
# A multi-resource reference:
require => File['/etc/apache2/httpd.conf', '/etc/apache2/magic', '/etc/apache2/mime.types'],
# An equivalent multi-resource reference:
$my_files = ['/etc/apache2/httpd.conf', '/etc/apache2/magic', '/etc/apache2/mime.types']
require => File[$my_files]
```

They can be used wherever an array of references might be used. They can also go on either side of a [chaining arrow][chaining] or receive a [block of additional attributes][attribute_override].


## Accessing attribute values

You can use a resource reference to access the values of a [resource][]'s attributes. To access a value, use square brackets and the name of an attribute (as a [string][]). This works much like [accessing hash values.][hash access]

``` puppet
file { "/etc/first.conf":
  ensure => file,
  mode   => "0644",
  owner  => "root",
}

file { "/etc/second.conf":
  ensure => file,
  mode   => File["/etc/first.conf"]["mode"],
  owner  => File["/etc/first.conf"]["owner"],
}
```

* The resource whose values you're accessing must exist.
* Like referencing variables, attribute access depends on evaluation order: Puppet must evaluate the resource you're accessing _before_ you try to access it. If it hasn't been evaluated yet, Puppet will raise an evaluation error.
* You can only access attributes that are valid for that resource type. If you try to access a nonexistent attribute, Puppet will raise an evaluation error.
* Puppet can only read the values of attributes that are _explicitly set_ in the resource's declaration.
    * It can't read the values of properties that would have to be read from the target system.
    * It also can't read the values of attributes that default to some predictable value; for example, in the code above, you wouldn't be able to access the value of the `path` attribute, even though it defaults to the resource's title.
* Like with [hash access][], the value of an attribute whose value was never set is [`undef`.][undef]

## Resource references as data types

If you've read the [Data Type Syntax][data type] page, or perused the lower sections of the other data type pages, you might have noticed that resource references use the same syntax as [values that represent data types.][data type]

Internally, they're implemented the same way, and each resource reference is actually a data type.

**For most users, this doesn't matter at all.** You should treat resource references as a special case with a coincidentally similar syntax, and it'll make your life generally easier.

But if you're interested in the meta-details, please see [the page about resource types as data types.][resource_types]

### The short version

If you just need to restrict values for a class or defined type parameter so that users must provide your code a resource reference, do one of the following.

To allow a resource reference of any resource type, use a data type of:

``` puppet
Type[Resource]
```

To allow resource references _and_ class references, use a data type of:

``` puppet
Type[Catalogentry]
```

To allow a resource reference of a _specific_ resource type --- in this example, `file` --- use one of the following:

``` puppet
Type[File]              # Capitalized resource type name
Type[Resource["file"]]  # `Resource` data type, with type name in parameter as a string
Type[Resource[File]]    # `Resource` data type, with capitalized resource type name
```

Any of these three options will allow any `File['<TITLE>']` resource reference, while rejecting, e.g., `Service[<TITLE>]`.

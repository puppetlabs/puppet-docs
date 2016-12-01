---
layout: default
title: "Future Parser: Data Types: Resource and Class References"
canonical: "/puppet/latest/reference/lang_data_resource_reference.html"
---

[relationship]: ./future_lang_relationships.html
[chaining]: ./future_lang_relationships.html#chaining-arrows
[attribute_override]: ./future_lang_resources_advanced.html#adding-or-modifying-attributes
[string]: ./future_lang_data_string.html
[data type]: ./future_lang_data_type.html
[resource_types]: ./future_lang_data_resource_type.html


Resource references identify a specific Puppet resource by its type and title. Several attributes, such as the [relationship][] metaparameters, require resource references.


## Syntax

~~~ ruby
    # A reference to a file resource:
    subscribe => File['/etc/ntp.conf'],
    ...
    # A type with a multi-segment name:
    before => Concat::Fragment['apache_port_header'],
~~~

The general form of a resource reference is:

* The **resource type,** capitalized (every segment must be capitalized if the resource type includes a namespace separator \[`::`\])
* An opening square bracket
* The **title** of the resource as a [string][], or a comma-separated list of titles
* A closing square bracket

Unlike variables, resource references are not evaluation-order dependent, and can be used before the resource itself is declared.

### Class References

Class references work identically to resource references, but use the pseudo-resource type `Class` instead of some other resource type name.

~~~ ruby
    require => Class['ntp::install'],
~~~


### Multi-Resource References

Resource reference expressions with an **array of titles** or **comma-separated list of titles** refer to multiple resources of the same type. They evaluate to an array of single-title resource references.

~~~ ruby
    # A multi-resource reference:
    require => File['/etc/apache2/httpd.conf', '/etc/apache2/magic', '/etc/apache2/mime.types'],
    # An equivalent multi-resource reference:
    $my_files = ['/etc/apache2/httpd.conf', '/etc/apache2/magic', '/etc/apache2/mime.types']
    require => File[$my_files]
~~~

They can be used wherever an array of references might be used. They can also go on either side of a [chaining arrow][chaining] or receive a [block of additional attributes][attribute_override].



## Resource References as Data Types

If you've read the [Data Type Syntax][data type] page, or perused the lower sections of the other data type pages, you might have noticed that resource references use the same syntax as [values that represent data types.][data type]

Internally, they're implemented the same way, and each resource reference is actually a data type.

**For most users, this doesn't matter at all.** You should treat resource references as a special case with a coincidentally similar syntax, and it'll make your life generally easier.

But if you're interested in the meta-details, please see [the page about resource types as data types.][resource_types]

### The Short Version

If you just need to restrict values for a class or defined type parameter so that users must provide your code a resource reference, do one of the following.

To allow a resource reference of any resource type, use a data type of:

~~~ ruby
    Type[Resource]
~~~

To allow resource references _and_ class references, use a data type of:

~~~ ruby
    Type[Catalogentry]
~~~

To allow a resource reference of a _specific_ resource type --- in this example, `file` --- use one of the following:

~~~ ruby
    Type[File]              # Capitalized resource type name
    Type[Resource["file"]]  # `Resource` data type, with type name in parameter as a string
    Type[Resource[File]]    # `Resource` data type, with capitalized resource type name
~~~

Any of these three options will allow any `File['<TITLE>']` resource reference, while rejecting, e.g., `Service[<TITLE>]`.

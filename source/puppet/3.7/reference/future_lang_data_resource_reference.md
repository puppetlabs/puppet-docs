---
layout: default
title: "Future Parser: Data Types: Resource References"
canonical: "/puppet/latest/reference/future_lang_data_resource_reference.html"
---

[relationship]: ./future_lang_relationships.html
[chaining]: ./future_lang_relationships.html#chaining-arrows
[attribute_override]: ./future_lang_resources.html#adding-or-modifying-attributes




Resource references identify a specific existing Puppet resource by its type and title. Several attributes, such as the [relationship][] metaparameters, require resource references.

{% highlight ruby %}
    # A reference to a file resource:
    subscribe => File['/etc/ntp.conf'],
    ...
    # A type with a multi-segment name:
    before => Concat::Fragment['apache_port_header'],
{% endhighlight %}

The general form of a resource reference is:

* The resource **type,** capitalized (every segment must be capitalized if the type includes a namespace separator \[`::`\])
* An opening square bracket
* The **title** of the resource, or a comma-separated list of titles
* A closing square bracket

Unlike variables, resource references are not evaluation-order dependent, and can be used before the resource itself is declared.

### Multi-Resource References

Resource references with an **array of titles** or **comma-separated list of titles** refer to multiple resources of the same type. They evaluate to an array of single title resource references.

{% highlight ruby %}
    # A multi-resource reference:
    require => File['/etc/apache2/httpd.conf', '/etc/apache2/magic', '/etc/apache2/mime.types'],
    # An equivalent multi-resource reference:
    $my_files = ['/etc/apache2/httpd.conf', '/etc/apache2/magic', '/etc/apache2/mime.types']
    require => File[$my_files]
{% endhighlight %}

They can be used wherever an array of references might be used. They can also go on either side of a [chaining arrow][chaining] or receive a [block of additional attributes][attribute_override].


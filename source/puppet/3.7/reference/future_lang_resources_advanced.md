---
layout: default
title: "Future Parser: Resources (Advanced)"
canonical: "/puppet/latest/reference/future_lang_resources_advanced.html"
---


[append_attributes]: ./future_lang_classes.html#appending-to-resource-attributes
[inheritance]: ./future_lang_classes.html#inheritance
[resdefaults]: ./future_lang_defaults.html
[collector]: ./future_lang_collectors.html
[reference]: ./future_lang_data_resource_reference.html
[realize]: ./future_lang_virtual.html#syntax
[virtual]: ./future_lang_virtual.html
[resources]: ./future_lang_resources.html
[expressions]: ./future_lang_expressions.html
[string]: ./future_lang_data_string.html
[array]: ./future_lang_data_array.html
[hash]: ./future_lang_data_hash.html
[datatype]: ./future_lang_data.html

[resource_data_type]: ./future_lang_data_resource_type.html
[default]: ./future_lang_data_default.html


Resource declarations are [expressions][] that describe the desired state for one or more resources and instruct Puppet to add those resources to the [catalog][].

[We describe the basics of resource declarations on another page,][resources] but the resource expression syntax has a lot of additional features, including:

* Describing many resources at once.
* Setting a group of attributes from a [hash][] (with the special `*` attribute).
* Setting default attributes.
* Specifying an abstract resource type.
* Amending or overriding attributes after a resource is already declared.

This page describes the full syntax of resource expressions. Please make sure you've read [the main page about resources][resources] before reading any further.



Full Syntax
-----

{% highlight ruby %}
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
{% endhighlight %}

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

Multiple Resource Bodies
-----

If a resource expression includes more than one resource body, the expression will declare multiple resources of that resource type. (A resource body is a title and a set of attributes; each body must be separated from the next one with a semicolon.)

Each resource in an expression is almost completely independent of the others, and they can have completely different values for their attributes. The only connections between resources that share an expression are:

* They all have the same resource type.
* They can all draw from the same pool of default values, if a resource body with the special title `default` is present. (See below for details.)


Value of a Resource Expression
-----

Resource declarations are [expressions][] in the Puppet language --- they always have a side effect (adding a resource to the catalog), but they also resolve to a value.

The value of a resource declaration is an [array][] of [resource references][reference], with one reference for each resource the expression describes.

**Note:** A resource declaration has extremely low precedence; in fact, it's even lower than the variable assignment operator (`=`). This means that in almost every place where you can use a resource declaration for its value, you will need to surround it with parentheses to properly associate it with the expression that uses the value.







Using an Abstract Resource Type
-----

Since a resource expression can accept a [resource type data type][resource_data_type] as its resource type, you can use a `Resource[<TYPE>]` value to specify a non-literal resource type, where the `<TYPE>` portion can be read from a variable.

That is, all of the following are equivalent:

{% highlight ruby %}
    file { "/tmp/foo": ensure => file, }
    File { "/tmp/foo": ensure => file, }
    Resource[File] { "/tmp/foo": ensure => file, }

    $mytype = File
    Resource[$mytype] { "/tmp/foo": ensure => file, }

    $mytypename = "file"
    Resource[$mytypename] { "/tmp/foo": ensure => file, }
{% endhighlight %}

This lets you declare resources without knowing in advance what type of resources they'll be, which can enable interesting transformations of data into resources. For a demonstration, see the `create_resources` example below.

Array of Titles
-----

If you specify an [array][] of [strings][string] as the title of a resource body, Puppet treats it as multiple resource declarations with an identical block of attributes.

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
      mode   => '0755',
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
      mode   => '0755',
    }
{% endhighlight %}


Note that you cannot specify a separate namevar with an array of titles, since it would then be duplicated across all of the resources. Thus, each title must be a valid namevar value.


Adding or Modifying Attributes
-----

Although you cannot declare the same resource twice, you can add attributes to an already-declared resource. In certain circumstances, you can also override attributes.

### Amending Attributes With a Reference

{% highlight ruby %}
    file {'/etc/passwd':
      ensure => file,
    }

    File['/etc/passwd'] {
      owner => 'root',
      group => 'root',
      mode  => '0640',
    }
{% endhighlight %}

The general form of a reference attribute block is:

* A [reference][] to the resource in question (or a multi-resource reference)
* An opening curly brace
* Any number of attribute => value pairs
* A closing curly brace

In normal circumstances, this idiom can only be used to add previously unmanaged attributes to a resource; it cannot override already-specified attributes. However, within an [inherited class][inheritance], you **can** use this idiom to override attributes.

### Amending Attributes With a Collector

{% highlight ruby %}
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
{% endhighlight %}

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
> * Since it ignores class inheritance, you can override the same attribute twice, which results in a evaluation-order dependent race where the final override wins.

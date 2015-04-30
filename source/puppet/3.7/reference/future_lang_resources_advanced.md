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



















Condensed Forms
-----

There are two ways to compress multiple resource declarations. You can also use [resource default statements][resdefaults] to reduce duplicate typing.

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

### Semicolon After Attribute Block

If you end an attribute block with a semicolon rather than a comma, you can specify another title, another colon, and another complete attribute block, instead of closing the curly braces. Puppet will treat this as multiple resources of a single resource type.

{% highlight ruby %}
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
{% endhighlight %}


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

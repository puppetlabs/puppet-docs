---
layout: default
title: "Language: Virtual Resources"
---

[resources]: ./lang_resources.html
[references]: ./lang_datatypes.html#resource-references
[classes]: ./lang_classes.html
[realize_function]: /references/2.7.latest/function.html#realize
[include]: ./lang_classes.html#declaring-a-class-with-include
[collectors]: ./lang_collectors.html
[search_expression]: ./lang_collectors.html#search-expressions
[override]: ./lang_resources.html#amending-attributes-with-a-collector
[chaining]: ./lang_relationships.html#chaining-arrows
[virtual_guide]: /guides/virtual_resources.html
[catalog]: ./lang_summary.html#compilation-and-catalogs


A **virtual resource declaration** specifies a desired state for a resource **without** adding it to the [catalog][]. You can then add the resource to the catalog by **realizing** it elsewhere in your manifests. This splits the work done by a normal [resource declaration][resources] into two steps. 

Although virtual resources can only be _declared_ once, they can be _realized_ any number of times (much as a class may be [`included`][include] multiple times). 

Purpose
-----

Virtual resources are useful for:

* Resources whose management depends on at least one of multiple conditions being met
* Overlapping sets of resources which may be required by any number of classes
* Resources which should only be managed if multiple cross-class conditions are met

Virtual resources can be used in some of the same situations as [classes][], since they both offer a safe way to add a resource to the catalog in more than one place. The features that distinguish virtual resources are:

* **Searchability** via [resource collectors][collectors], which lets you realize overlapping clumps of virtual resources
* **Flatness,** such that you can declare a virtual resource and realize it a few lines later without having to clutter your modules with many single-resource classes

For more details, see [Virtual Resource Design Patterns][virtual_guide].

Syntax
-----

Virtual resources are used in two steps: declaring and realizing. 

{% highlight ruby %}
    # <modulepath>/apache/manifests/init.pp
    ...
    # Declare:
    @a2mod { 'rewrite':
      ensure => present,
    } # note: The a2mod type is from the puppetlabs-apache module.
    
    # <modulepath>/wordpress/manifests/init.pp
    ...
    # Realize: 
    realize A2mod['rewrite']
    
    # <modulepath>/freight/manifests/init.pp
    ...
    # Realize again:
    realize A2mod['rewrite']
{% endhighlight %}

In the example above, the `apache` class declares a virtual resource, and both the `wordpress` and `freight` classes realize it. The resource will be managed on any node that has the `wordpress` and/or `freight` classes applied to it.

### Declaring a Virtual Resource

To declare a virtual resource, prepend `@` (the "at" sign) to the **type** of a normal [resource declaration][resources]:

{% highlight ruby %}
    @user {'deploy':
      uid     => 2004,
      comment => 'Deployment User',
      group   => www-data,
      groups  => ["enterprise"],
      tag     => [deploy, web],
    }
{% endhighlight %}

### Realizing With the `realize` Function

To realize one or more virtual resources **by title,** use the [`realize`][realize_function] function, which accepts one or more [resource references][references]:

{% highlight ruby %}
    realize User['deploy'], User['zleslie']
{% endhighlight %}

The `realize` function may be used multiple times on the same virtual resource and the resource will only be added to the catalog once.

### Realizing With a Collector

Any [resource collector][collectors] will realize any virtual resource that matches its [search expression][search_expression]:

{% highlight ruby %}
    User <| tag == web |>
{% endhighlight %}

You can use multiple resource collectors that match a given virtual resource and it will only be added to the catalog once. 

Note that a collector used in an [override block][override] or a [chaining statement][chaining] will also realize any matching virtual resources. 


Behavior
-----

By itself, a virtual resource declaration will not add any resources to the catalog. Instead, it makes the virtual resource available to the compiler, which may or may not realize it. A matching resource collector or a call to the `realize` function will cause the compiler to add the resource to the catalog. 

### Parse-Order Independence

Virtual resources do not depend on parse order. You may realize a virtual resource before the resource has been declared. 

### Collectors vs. the `realize` Function

The `realize` function will cause a compilation failure if you attempt to realize a virtual resource that has not been declared. Resource collectors will fail silently if they do not match any resources. 

### Virtual Resources in Classes

If a virtual resource is contained in a class, it cannot be realized unless the class is declared at some point during the compilation. A common pattern is to declare a class full of virtual resources and then use a collector to choose the set of resources you need:

{% highlight ruby %}
    include virtual::users
    User <| groups == admin or group == wheel |>
{% endhighlight %}

### Defined Resource Types

You may declare virtual resources of defined resource types. This will cause every resource contained in the defined resource to behave virtually --- they will not be added to the catalog unless the defined resource is realized.


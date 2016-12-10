---
layout: default
title: "Language: Virtual resources"
---

[resources]: ./lang_resources.html
[references]: ./lang_data_resource_reference.html
[classes]: ./lang_classes.html
[realize_function]: ./function.html#realize
[include]: ./lang_classes.html#using-include
[collectors]: ./lang_collectors.html
[search_expression]: ./lang_collectors.html#search-expressions
[override]: ./lang_resources_advanced.html#amending-attributes-with-a-collector
[chaining]: ./lang_relationships.html#syntax-chaining-arrows
[catalog]: ./lang_summary.html#compilation-and-catalogs


A **virtual resource declaration** specifies a desired state for a resource without necessarily enforcing that state. You can then tell Puppet to manage the resource by **realizing** it elsewhere in your manifests. This splits the work done by a normal [resource declaration][resources] into two steps.

Although virtual resources can only be _declared_ once, they can be _realized_ any number of times (much as a class can be [`included`][include] multiple times).

## Purpose

Virtual resources are useful for:

* Resources whose management depends on at least one of multiple conditions being met.
* Overlapping sets of resources which might be needed by any number of classes.
* Resources which should only be managed if multiple cross-class conditions are met.

Virtual resources can be used in some of the same situations as [classes][], since they both offer a safe way to add a resource to the catalog in more than one place. The features that distinguish virtual resources are:

* **Searchability** via [resource collectors][collectors], which lets you realize overlapping clumps of virtual resources.
* **Flatness,** such that you can declare a virtual resource and realize it a few lines later without having to clutter your modules with many single-resource classes.

## Syntax


Virtual resources are used in two steps: declaring and realizing.

``` puppet
# modules/apache/manifests/init.pp
...
# Declare:
@a2mod { 'rewrite':
  ensure => present,
} # note: The a2mod resource type is from the puppetlabs-apache module.

# modules/wordpress/manifests/init.pp
...
# Realize:
realize A2mod['rewrite']

# modules/freight/manifests/init.pp
...
# Realize again:
realize A2mod['rewrite']
```

In the example above, the `apache` class declares a virtual resource, and both the `wordpress` and `freight` classes realize it. The resource is managed on any node that has the `wordpress` and/or `freight` classes applied to it.

### Declaring a virtual resource

To declare a virtual resource, prepend `@` (the "at" sign) to the **resource type** of a normal [resource declaration][resources]:

``` puppet
@user {'deploy':
  uid     => 2004,
  comment => 'Deployment User',
  group   => 'www-data',
  groups  => ["enterprise"],
  tag     => [deploy, web],
}
```

### Realizing with the `realize` function

To realize one or more virtual resources **by title,** use the [`realize`][realize_function] function, which accepts one or more [resource references][references]:

``` puppet
realize(User['deploy'], User['zleslie'])
```

The `realize` function can be used multiple times on the same virtual resource and the resource is only managed once.

### Realizing with a collector

A [resource collector][collectors] realizes any virtual resources that match its [search expression][search_expression]:

``` puppet
User <| tag == web |>
```

If multiple resource collectors match a given virtual resource, Puppet will only manage that resource once.

Note that a collector also collects and realizes any exported resources from the current node. If you use exported resources that you don't want realized, take care to exclude them from the collector's search expression.

Note also that a collector used in an [override block][override] or a [chaining statement][chaining] will also realize any matching virtual resources.

## Behavior

By itself, a virtual resource declaration does not manage the state of a resource. Instead, it makes a virtual resource available to resource collectors and the `realize` function. If that resource is realized, Puppet will manage its state.

Unrealized virtual resources are included in the [catalog][], but they are marked as inactive.

### Evaluation-order independence

Virtual resources do not depend on evaluation order. You can realize a virtual resource before the resource has been declared.

### Collectors vs. the `realize` function

The `realize` function causes a compilation failure if you attempt to realize a virtual resource that has not been declared. Resource collectors fail silently if they do not match any resources.

### Virtual resources in classes

If a virtual resource is contained in a class, it cannot be realized unless the class is declared at some point during the compilation. A common pattern is to declare a class full of virtual resources and then use a collector to choose the set of resources you need:

``` puppet
include virtual::users
User <| groups == admin or group == wheel |>
```

### Defined resource types

You can declare virtual resources of defined resource types. This causes every resource contained in the defined resource to behave virtually --- they are not managed unless their virtual container is realized.

### Run stages

Virtual resources are evaluated in the [run stage](./lang_run_stages.html) in which they are **declared,** not the run stage in which they are **realized.**

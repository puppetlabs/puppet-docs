---
layout: default
title: "Language: Resource Collectors"
---

<!-- TODO -->
[virtual]: 
[realize]: 
[exported]: 
[puppetdb]: /puppetdb/
[puppetdb_install]: /puppetdb/0.9/install.html
[puppetdb_connect]: /puppetdb/0.9/connect_puppet.html
[chaining]: ./lang_relationships.html#chaining-arrows
[attribute]: ./lang_resources.html#attributes
[expressions]: ./lang_expressions.html
[string]: ./lang_datatypes.html#strings
[boolean]: ./lang_datatypes.html#booleans
[number]: ./lang_datatypes.html#numbers
[reference]: ./lang_datatypes.html#resource-references
[undef]: ./lang_datatypes.html#undef
[amend]: ./lang_resources.html#amending-attributes-with-a-collector


Resource collectors (AKA the spaceship operator) select a group of resources by searching the attributes of every resource in the catalog. This search is parse-order independent (that is, it even includes resources which haven't yet been declared at the time the collector is written). Collectors realize [virtual reasources][virtual], can be used in [chaining statements][chaining], and can override resource attributes.

Collectors are an irregular syntax that can function as both a statement and a value.

Syntax
-----

{% highlight ruby %}
    User <| title == 'luke' |> # Will collect a single user resource whose title is 'luke'
    User <| groups == 'admin' |> # Will collect any user resource whose list of supplemental groups includes 'admin'
    Yumrepo['custom_packages'] -> Package <| tag == 'custom' |> # Will create an order relationship with several package resources
{% endhighlight %}

The general form of a resource collector is:

* The resource type, capitalized
* `<|` --- An opening angle bracket (less-than sign) and pipe character
* Optionally, a search expression ([see below](#search-expressions))
* `|>` --- A pipe character and closing angle bracket (greater-than sign)

Note that exported resource collectors are a slightly different syntax; [see below](#exported-resource-collectors).

### Search Expressions

Collectors can search the values of resource titles and attributes, and they use a special expression syntax to do so. This resembles the normal syntax for [Puppet expressions][expressions], but is not the same.

A collector with an empty search expression will match **every** resource of the specified type.

Parentheses may be used to improve readability. You can create arbitrarily complex expressions using the following four operators:

#### `==` (equality search)

This operator is non-transitive: 

* The left operand (attribute) must be the name of a [resource attribute][attribute] or the word `title` (which searches on the resource's title).
* The right operand (search key) must be a [string][], [boolean][], [number][], [resource reference][reference], or [undef][]. The behavior of arrays and hashes in the right operand is **undefined** in this version of Puppet.

For a given resource, this operator will **match** if the value of the attribute (or one of the value's members, if the value is an array) is identical to the search key. 

#### `!=` (non-equality search)

This operator is non-transitive: 

* The left operand (attribute) must be the name of a [resource attribute][attribute] or the word `title` (which searches on the resource's title).
* The right operand (search key) must be a [string][], [boolean][], [number][], [resource reference][reference], or [undef][]. The behavior of arrays and hashes in the right operand is **undefined** in this version of Puppet.

For a given resource, this operator will **match** if the value of the attribute is **not** identical to the search key. 

> Note: This operator will always match if the value is an array. To the best of our knowledge, there is no particular reason for this, and the behavior when the value is an array may in fact be undefined. 

#### `and`

Both operands must be valid search expressions.

For a given resource, this operator will **match** if **both** of the operands would match for that resource.

#### `or`

Both operands must be valid search expressions.

For a given resource, this operator will **match** if **either** of the operands would match for that resource.

Location
-----

Resource collectors may be used as independent statements, as the operand of a [chaining statement][chaining], or in a [collector attribute block][amend] for amending resource attributes.

Notably, collectors **cannot** be used as the value of a resource attribute, the argument of a function, or the operand of an expression. 


Behavior
-----

A resource collector will **always** [realize][] any [virtual resources][virtual] that match its search expression. Note that empty search expressions match every resource of the specified type.

In addition to realizing, collectors can function as a value in two places:

* When used in a [chaining statement][chaining], a collector will act as a proxy for every resource (virtual or non) that matches its search expression.
* When given a block of attributes and values, a collector will [set and override][amend] those attributes for every resource (virtual or not) that matches its search expression.

Note again that collectors used as values will also realize any matching virtual resources. If you use virtualized resources, you must use care when chaining collectors or using them for overrides. 

Exported Resource Collectors
-----

An **exported resource collector** is a modified syntax that realizes [exported resources][exported].

### Syntax

Exported resource collectors are identical to collectors, except that their angle brackets are doubled. 

{% highlight ruby %}
    Nagios_service <<| |>> # realize all exported nagios_service resources
{% endhighlight %}

The general form of an exported resource collector is:

* The resource type, capitalized
* `<<|` --- Two opening angle brackets (less-than signs) and a pipe character
* Optionally, a search expression ([see above](#search-expressions))
* `|>>` --- A pipe character and two closing angle brackets (greater-than signs)

### Behavior

Exported resource collectors exist only to import resources that were published by other nodes. To use them, you need to have resource stashing (storeconfigs) enabled. See [Exported Resources][exported] for more details; to enable resource stashing, follow the [installation instructions][puppetdb_install] and [Puppet configuration instructions][puppetdb_connect] in [the PuppetDB manual][puppetdb].

The behavior of an exported resource collector when used with an attribute block or in a chaining statement is undefined. 


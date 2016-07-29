---
layout: default
title: "Language: Resource Collectors"
canonical: "/puppet/latest/reference/lang_collectors.html"
---

[virtual]: ./lang_virtual.html
[realize]: ./lang_virtual.html#syntax
[exported]: ./lang_exported.html
[puppetdb]: /puppetdb/
[puppetdb_install]: {{puppetdb}}/install_via_module.html
[puppetdb_connect]: {{puppetdb}}/connect_puppet_master.html
[chaining]: ./lang_relationships.html#chaining-arrows
[attribute]: ./lang_resources.html#attributes
[expressions]: ./lang_expressions.html
[string]: ./lang_datatypes.html#strings
[boolean]: ./lang_datatypes.html#booleans
[number]: ./lang_datatypes.html#numbers
[reference]: ./lang_datatypes.html#resource-references
[undef]: ./lang_datatypes.html#undef
[amend]: ./lang_resources.html#amending-attributes-with-a-collector
[catalog]: ./lang_summary.html#compilation-and-catalogs


Resource collectors (AKA the spaceship operator) select a group of resources by searching the attributes of every resource in the [catalog][]. This search is parse-order independent (that is, it even includes resources which haven't yet been declared at the time the collector is written). Collectors realize [virtual resources][virtual], can be used in [chaining statements][chaining], and can override resource attributes.

Collectors have an irregular syntax that lets them function as both a statement and a value.

Syntax
-----

~~~ ruby
    User <| title == 'luke' |> # Will collect a single user resource whose title is 'luke'
    User <| groups == 'admin' |> # Will collect any user resource whose list of supplemental groups includes 'admin'
    Yumrepo['custom_packages'] -> Package <| tag == 'custom' |> # Will create an order relationship with several package resources
~~~

The general form of a resource collector is:

* The resource type, capitalized
* `<|` --- An opening angle bracket (less-than sign) and pipe character
* Optionally, a search expression ([see below](#search-expressions))
* `|>` --- A pipe character and closing angle bracket (greater-than sign)

Note that exported resource collectors have a slightly different syntax; [see below](#exported-resource-collectors).

### Search Expressions

Collectors can search the values of resource titles and attributes using a special expression syntax. This resembles the normal syntax for [Puppet expressions][expressions], but is not the same. Note that while classes sometimes look like resources, they are not resources and thus can't be collected.

> Note: Collectors can only search on attributes which are present in the manifests and cannot read the state of the target system. For example, the collector `Package <| provider == yum |>` would only collect packages whose `provider` attribute had been _explicitly set_ to `yum` in the manifests. It would not match any packages that would default to the `yum` provider based on the state of the target system.

A collector with an empty search expression will match **every** resource of the specified type.

Parentheses may be used to improve readability. You can create arbitrarily complex expressions using the following four operators:

- [`==`](#equality-search)
- [`!=`](#non-equality-search)
- [`and`](#and)
- [`or`](#or)

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

> Note: This operator will always match if the attribute's value is an array. This behavior may be undefined.

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

An **exported resource collector** uses a modified syntax that realizes [exported resources][exported].

### Syntax

Exported resource collectors are identical to collectors, except that their angle brackets are doubled.

~~~ ruby
    Nagios_service <<| |>> # realize all exported nagios_service resources
~~~

The general form of an exported resource collector is:

* The resource type, capitalized
* `<<|` --- Two opening angle brackets (less-than signs) and a pipe character
* Optionally, a search expression ([see above](#search-expressions))
* `|>>` --- A pipe character and two closing angle brackets (greater-than signs)

### Behavior

Exported resource collectors exist only to import resources that were published by other nodes. To use them, you need to have catalog storage and searching (storeconfigs) enabled. See [Exported Resources][exported] for more details. To enable exported resources, follow the [installation instructions][puppetdb_install] and [Puppet configuration instructions][puppetdb_connect] in [the PuppetDB manual][puppetdb].

Like normal collectors, exported resource collectors can be used with attribute blocks and chaining statements.


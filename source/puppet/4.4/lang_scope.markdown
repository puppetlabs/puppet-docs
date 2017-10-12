---
layout: default
title: "Language: Scope"
canonical: "/puppet/latest/lang_scope.html"
---

[resources]: ./lang_resources.html
[refs]: ./lang_data_resource_reference.html
[class]: ./lang_classes.html
[definedtype]: ./lang_defined_types.html
[node]: ./lang_node_definitions.html
[resourcedefaults]: ./lang_defaults.html
[declare_class]: ./lang_classes.html#declaring-classes
[lookup]: #scope-lookup-rules
[enc]: /guides/external_nodes.html
[inheritance]: ./lang_classes.html#inheritance
[variables]: ./lang_variables.html
[namespace]: ./lang_namespaces.html
[diagram]: ./images/scope-euler-diagram.png
[lambda]: ./lang_lambdas.html

## Scope Basics

A **scope** is a specific **area of code** that is partially isolated from other areas of code. Scopes limit the reach of:

* [Variables][variables]
* [Resource defaults][resourcedefaults]

Scopes **do not** limit the reach of:

* [Resource titles][resources], which are all global
* [Resource references][refs], which can refer to a resource declared in any scope

### Summary Diagram

![An Euler diagram of several scopes. Top scope contains node scope, which contains the example::other, example::four, and example::parent scopes. Example::parent contains the example::child scope.][diagram]

Any given scope has access to its own contents, and also receives additional contents from its **parent scope,** node scope, and top scope. (The rules for how Puppet determines a local scope's parent are described below in [Scope Lookup Rules][scope_lookup_rules].)

In the diagram above:

* Top scope can only access variables and defaults from its own scope.
* Node scope can access variables and defaults from its own scope **and** top scope.
* Each of the `example::parent, example::other`, and `example::four` classes can access variables and defaults from their own scope, node scope, and top scope.
* The `example::child` class can access variables and defaults from its own scope, `example::parent`'s scope, node scope, and top scope.

### Top Scope

Code that is _outside_ any class definition, type definition, or node definition exists at **top scope.** Variables and defaults declared at top scope are available **everywhere.**

~~~ ruby
# site.pp
$variable = "Hi!"

class example {
  notify {"Message from elsewhere: $variable":}
}

include example
~~~

~~~
$ puppet apply site.pp
notice: Message from elsewhere: Hi!
~~~

### Node Scope

Code inside a [node definition][node] exists at **node scope.** Note that since only one node definition can match a given node, only one node scope can exist at a time.

Variables and defaults declared at node scope are available **everywhere except top scope.**

> **Note:** Classes and resources declared at top scope **bypass node scope entirely,** and so cannot access variables or defaults from node scope.

~~~ ruby
# site.pp
$top_variable = "Available!"
node 'puppet.example.com' {
  $variable = "Hi!"
  notify {"Message from here: $variable":}
  notify {"Top scope: $top_variable":}
}
notify {"Message from top scope: $variable":}
~~~

~~~
$ puppet apply site.pp
notice: Message from here: Hi!
notice: Top scope: Available!
notice: Message from top scope:
~~~

In this example, node scope can access top scope variables, but not vice-versa.

### Local Scopes

Code inside a [class definition][class], [defined type][definedtype], or [lambda][] exists in a **local scope.**

Variables and defaults declared in a local scope are only available in **that scope and its children.** There are two different sets of rules for when scopes are considered related; see "[scope lookup rules](#scope-lookup-rules)" below.

~~~ ruby
# /etc/puppetlabs/code/modules/scope_example/manifests/init.pp
class scope_example {
  $variable = "Hi!"
  notify {"Message from here: $variable":}
  notify {"Node scope: $node_variable Top scope: $top_variable":}
}

# /etc/puppetlabs/code/environments/production/manifests/site.pp
$top_variable = "Available!"
node 'puppet.example.com' {
  $node_variable = "Available!"
  include scope_example
  notify {"Message from node scope: $variable":}
}
notify {"Message from top scope: $variable":}
~~~

~~~
$ puppet apply site.pp
notice: Message from here: Hi!
notice: Node scope: Available! Top scope: Available!
notice: Message from node scope:
notice: Message from top scope:
~~~

In this example, a local scope can see "out" into node and top scope, but outer scopes cannot see "in."

### Overriding Received Values

Variables and defaults declared at node scope can override those received from top scope. Those declared at local scope can override those received from node and top scope, as well as any parent scopes. That is: if multiple variables with the same name are available, **Puppet will use the "most local" one.**

~~~ ruby
# /etc/puppetlabs/code/modules/scope_example/manifests/init.pp
class scope_example {
  $variable = "Hi, I'm local!"
  notify {"Message from here: $variable":}
}

# /etc/puppetlabs/code/environments/production/manifests/site.pp
$variable = "Hi, I'm top!"

node 'puppet.example.com' {
  $variable = "Hi, I'm node!"
  include scope_example
}
~~~

~~~
$ puppet apply site.pp
notice: Message from here: Hi, I'm local!
~~~

Resource defaults are processed **by attribute** rather than as a block. Thus, defaults that declare different attributes will be merged, and only the attributes that conflict will be overridden.

~~~ ruby
# /etc/puppetlabs/code/modules/scope_example/manifests/init.pp
class scope_example {
  File { ensure => directory, }

  file {'/tmp/example':}
}

# /etc/puppetlabs/code/environments/production/manifests/site.pp
File {
  ensure => file,
  owner  => 'puppet',
}

include scope_example
~~~

In this example, `/tmp/example` would be a directory owned by the `puppet` user, and would combine the defaults from top and local scope.

## More Details

### Scope of External Node Classifier Data

* **Variables** provided by an [ENC][] are set at top scope.
* However, all of the **classes** assigned by an ENC are declared at node scope.

This gives approximately the best and most-expected behavior --- variables from an ENC are available everywhere, and classes may use node-specific variables.

> **Note:** this means compilation will fail if the site manifest tries to set a variable that was already set at top scope by an ENC.

### Named Scopes and Anonymous Scopes

A class definition creates a **named scope,** whose name is the same as the class's name. Top scope is also a named scope; its name is the empty string.

Node scope and the local scopes created by lambdas and defined resources are **anonymous** and cannot be directly referenced.

### Accessing Out-of-Scope Variables

Variables declared in **named scopes** can be referenced directly from anywhere (including scopes that otherwise would not have access to them) by using their global **qualified name.**

Qualified variable names are formatted as follows, using the double-colon [namespace][] separator between segments:

`$<NAME OF SCOPE>::<NAME OF VARIABLE>`

~~~ ruby
include apache::params
$local_copy = $apache::params::confdir
~~~

This example would set the variable `$local_copy` to the value of the `$confdir` variable from the `apache::params` class.

> **Notes:**
>
> * Remember that top scope's name is the empty string. Thus, `$::my_variable` would always refer to the top-scope value of `$my_variable`, even if `$my_variable` has a different value in local scope.
> * Note that a class must be [declared][declare_class] in order to access its variables; simply having the class available in your modules is insufficient.
>
> This means the availability of out-of-scope variables is **evaluation order dependent.** You should only access out-of-scope variables if the class accessing them can guarantee that the other class is already declared, usually by explicitly declaring it with `include` before trying to read its variables.

Variables declared in **anonymous scopes** can only be accessed normally and do not have global qualified names.

## Scope Lookup Rules

[scope_lookup_rules]: #scope-lookup-rules

The scope lookup rules determine when a local scope becomes the parent of another local scope.

There are two different sets of scope lookup rules: **static scope** and **dynamic scope.** This version of Puppet uses:

* Static scope for [variables][]
* Dynamic scope for [resource defaults][resourcedefaults]

### Static Scope

In **static scope,** parent scopes are only assigned in the following ways:

* Classes can receive parent scopes by [class inheritance][inheritance], using the `inherits` keyword. Any derived class receives the contents of its base class in addition to the contents of node and top scope.
* A [lambda's][lambda] parent scope is the local scope in which the lambda is written. It can access variables in that scope by their short names.

**All other** local scopes have no parents --- they only receive their own contents, and the contents of node scope (if applicable) and top scope.

> Static scope has the following characteristics:
>
> * Scope contents are predictable and do not depend on evaluation order.
> * Scope contents can be determined simply by looking at the relevant class definition(s); the place where a class or defined type is _declared_ has no effect. (The only exception is node definitions --- if a class is declared outside a node, it does not receive the contents of node scope.)

This version of Puppet uses static scope for looking up variables.

### Dynamic Scope

In **dynamic scope,** parent scopes are assigned by both **inheritance** and **declaration,** with preference being given to inheritance. The full list of rules is:

* Each scope has only one parent, but may have an unlimited chain of grandparents, and receives the merged contents of all of them (with nearer ancestors overriding more distant ones).
* The parent of a derived class is its base class.
* The parent of any other class or defined resource is the **first** scope in which it was declared.
* When you declare a derived class whose base class _hasn't_ already been declared, the base class is immediately declared in the current scope, and its parent assigned accordingly. This effectively "inserts" the base class between the derived class and the current scope. (If the base class _has_ already been declared elsewhere, its existing parent scope is not changed.)

> Dynamic scope has the following characteristics:
>
> * A scope's parent cannot be identified by looking at the definition of a class --- you must examine every place where the class or resource may have been declared.
> * In some cases, you can only determine a scope's contents by executing the code.
> * Since classes may be declared multiple times with the `include` function, the contents of a given scope are evaluation-order dependent.

This version of Puppet uses dynamic scope only for resource defaults.

## Messy Under-the-Hood Details

* Node scope only exists if there is at least one node definition in the main manifest. If no node definitions exist, then ENC classes get declared at top scope.
* Although top scope and node scope are described above as being special scopes, they are actually implemented as part of the chain of parent scopes, with node scope being a child of top scope and the parent of any classes declared inside the node definition. However, since the move to static scoping causes them to behave as little islands of dynamic scoping in a statically scoped world, it's simpler to think of them as special cases.

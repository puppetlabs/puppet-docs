---
layout: default
title: "Language: Node definitions"
---

[hiera]: {{hiera}}/
[sitepp]: ./dirs_manifest.html
[certname]: ./config_important_settings.html#basics
[classes]: ./lang_classes.html
[nodescope]: ./lang_scope.html#node-scope
[topscope]: ./lang_scope.html#top-scope
[extlookup]: ./function.html#extlookup
[custom_functions]: /guides/custom_functions.html
[regex]: ./lang_data_regexp.html
[strings]: ./lang_data_string.html
[inherit]: ./lang_classes.html#inheritance
[modules]: ./modules_fundamentals.html
[enc]: ./nodes_external.html
[facts]: ./lang_variables.html#facts-and-built-in-variables
[catalogs]: ./lang_summary.html#compilation-and-catalogs
[strict]: ./configuration.html#stricthostnamechecking
[conditional]: ./lang_conditional.html


A **node definition** or **node statement** is a block of Puppet code that will only be included in matching nodes' [catalogs][]. This feature allows you to assign specific configurations to specific nodes.

Node statements are an **optional feature** of Puppet. They can be replaced by or combined with an [external node classifier][enc], or you can eschew both and use conditional statements with [facts][] to classify nodes.

Unlike more general conditional structures, node statements only match nodes by **name.** By default, the name of a node is its [certname][] (which defaults to the node's fully qualified domain name).

## Location


Node definitions should go in [the main manifest][sitepp]. The main manifest can be a single file, or a directory containing many files.

## Syntax


``` puppet
# <ENVIRONMENTS DIRECTORY>/<ENVIRONMENT>/manifests/site.pp
node 'www1.example.com' {
  include common
  include apache
  include squid
}
node 'db1.example.com' {
  include common
  include mysql
}
```

In the example above, only `www1.example.com` would receive the apache and squid classes, and only `db1.example.com` would receive the mysql class.

Node definitions look like class definitions. The general form of a node definition is:

* The `node` keyword
* The names of the nodes, separated by commas (with an optional final trailing comma)
* An opening curly brace
* Any mixture of class declarations, variables, resource declarations, collectors, conditional statements, chaining relationships, and functions
* A closing curly brace

> #### Aside: Best practices
>
> Although node statements can contain almost any Puppet code, we recommend that you **only** use them to **set variables** and **declare classes.** Avoid using resource declarations, collectors, conditional statements, chaining relationships, and functions in them; all of these belong in classes or defined types.
>
> This will make it easier to switch between node definitions and an ENC.



## Naming


Node statements match nodes by name. A node's name is its unique identifier; by default, this is its [certname][] setting, which in turn defaults to the node's fully qualified domain name.

{% partial ./_nodename_certname.md %}

A node statement's **name** must be one of the following:

* A quoted [string][strings] containing only letters, numbers, underscores (`_`), hyphens (`-`), and periods (`.`).
* A [regular expression][regex].
* The bare word `default`.

You cannot create two node statements with the same name.


### Multiple names

You can use a comma-separated list of names to create a group of nodes with a single node statement:

``` puppet
node 'www1.example.com', 'www2.example.com', 'www3.example.com' {
  include common
  include apache, squid
}
```

This example creates three identical nodes: `www1.example.com`, `www2.example.com`, and `www3.example.com`.

### The default node

The name `default` (without quotes) is a special value for node names. If no node statement matching a given node can be found, the `default` node will be used. See [Behavior](#behavior) below.

### Regular expression names

[Regular expressions (regexes)][regex] can be used as node names. This is another method for writing a single node statement that matches multiple nodes.

> **Note:** Make sure all of your node regexes match non-overlapping sets of node names. If a node's name matches more than one regex, Puppet makes no guarantee about which matching definition it will get.

``` puppet
node /^www\d+$/ {
  include common
}
```

The above example would match `www1`, `www13`, and any other node whose name consisted of `www` and one or more
digits.

``` puppet
node /^(foo|bar)\.example\.com$/ {
  include common
}
```

The above example would match `foo.example.com` and `bar.example.com`, but no other nodes.


## Behavior


If [the main manifest][sitepp] contains at least one node definition, it must have one for **every** node; compilation for a node will fail if one cannot be found. (Hence the usefulness of [the `default` node](#the-default-node).) If the main manifest contains **no** node definitions, this requirement is dropped.

### Matching

A given node will only get the contents of **one** node definition, even if two node statements could match a node's name. Puppet will do the following checks in order when deciding which definition to use:

1. If there is a node definition with the node's exact name, Puppet will use it.
2. If there is a regular expression node statement that matches the node's name, Puppet will use it. (If more than one regex node matches, Puppet will use one of them, with no guarantee as to which.)
3. If the node's name looks like a fully qualified domain name (i.e. multiple period-separated groups of letters, numbers, underscores and dashes), Puppet will chop off the final group and start again at step 1. (That is, if a definition for `www01.example.com` isn't found, Puppet will look for a definition matching `www01.example`.)
4. Puppet will use the `default` node.

Thus, for the node `www01.example.com`, Puppet would try the following, in order:

* `www01.example.com`
* A regex that matches `www01.example.com`
* `www01.example`
* A regex that matches `www01.example`
* `www01`
* A regex that matches `www01`
* `default`

You can turn off this fuzzy name matching by changing the Puppet master's [`strict_hostname_checking`][strict] setting to `true`. This will cause Puppet to skip step 3 and only use the node's full name before resorting to `default`.

### Regex capture variables

Regex node definitions will set numbered regex capture variables ($1, $2, etc.) within the body of the node definition. This is similar to the behavior of [conditional statements][conditional] that use regexes.

### Code outside node statements

Puppet code that is outside any node statement will be compiled for every node. That is, a given node will get both the code in its node definition and the code outside any node definition.

### Node scope

Node definitions create a new anonymous scope that can override variables and defaults from top scope. See [the section on node scope][nodescope] for details.

### Merging with ENC data

Node definitions and [external node classifiers][enc] can co-exist. Puppet merges their data as follows:

* Variables from an ENC are set at [top scope][topscope] and can thus be overridden by variables in a node definition.
* Classes from an ENC are declared at [node scope][nodescope], which means they will be affected by any variables set in the node definition.

Although ENCs and node definitions can work together, we recommend that most users pick one or the other.

### Inheritance is not allowed

In earlier versions of the Puppet language, nodes could inherit from other nodes using the `inherits` keyword. We removed that feature, and this version of the language will raise an error if you try to use it.

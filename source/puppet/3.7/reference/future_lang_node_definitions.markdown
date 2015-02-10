---
layout: default
title: "Future Language: Node Definitions"
canonical: "/puppet/latest/reference/future_lang_node_definitions.html"
---

[hiera]: /hiera/latest
[sitepp]: ./dirs_manifest.html
[certname]: ./config_important_settings.html#basics
[classes]: ./future_lang_classes.html
[nodescope]: ./future_lang_scope.html#node-scope
[topscope]: ./future_lang_scope.html#top-scope
[extlookup]: /references/latest/function.html#extlookup
[custom_functions]: /guides/custom_functions.html
[import]: ./future_lang_import.html
[regex]: ./future_lang_datatypes.html#regular-expressions
[strings]: ./future_lang_datatypes.html#strings
[inherit]: ./future_lang_classes.html#inheritance
[modules]: ./modules_fundamentals.html
[enc]: /guides/external_nodes.html
[facts]: ./future_lang_variables.html#facts-and-built-in-variables
[catalog]: ./future_lang_summary.html#compilation-and-catalogs
[strict]: /references/latest/configuration.html#stricthostnamechecking
[conditional]: ./future_lang_conditional.html


A **node definition** or **node statement** is a block of Puppet code that will only be included in matching nodes' [catalogs][catalog]. This feature allows you to assign specific configurations to specific nodes.

Node statements are an **optional feature** of Puppet. They can be replaced by or combined with an [external node classifier][enc], or you can eschew both and use conditional statements with [facts][] to classify nodes.

Unlike more general conditional structures, node statements only match nodes by **name.** By default, the name of a node is its [certname][] (which defaults to the node's fully qualified domain name).

Location
-----

Node definitions should go in [the site manifest (site.pp)][sitepp] or a directory structure of
manifests appointed by the manifest setting.

Syntax
-----

{% highlight ruby %}
    # /etc/puppetlabs/puppet/manifests/site.pp
    node 'www1.example.com' {
      include common
      include apache
      include squid
    }
    node 'db1.example.com' {
      include common
      include mysql
    }
{% endhighlight %}

In the example above, only `www1.example.com` would receive the apache and squid classes, and only `db1.example.com` would receive the mysql class.

Node definitions look like class definitions. The general form of a node definition is:

* The `node` keyword
* The name(s) of the node(s), separated by commas (with an optional final trailing comma)
* An opening curly brace
* Any mixture of class declarations, variables, resource declarations, collectors, conditional statements, chaining relationships, and functions
* A closing curly brace

> #### Aside: Best Practices
>
> Although node statements can contain almost any Puppet code, we recommend that you **only** use them to **set variables** and **declare classes.** Avoid using resource declarations, collectors, conditional statements, chaining relationships, and functions in them; all of these belong in classes or defined types.
>
> This will make it easier to switch between node definitions and an ENC.



Naming
-----

Node statements match nodes by name. A node's name is its unique identifier; by default, this is its [certname][] setting, which in turn resolves to the node's fully qualified domain name.

> #### Notes on Node Names
>
> * The set of characters allowed in a node name is **undefined** in this version of Puppet. For best future compatibility, you should limit node names to letters, numbers, periods, underscores, and dashes.
> * Although it is possible to configure Puppet to use something other than the [certname][] as a node name, this is not generally recommended.

A node statement's **name** must be one of the following:

* A quoted [string][strings]
* The bare word `default`
* A [regular expression][regex]

You may not create two node statements with the same name. If more than one regular expression
matches a node name, the first found node statement with a matching regexp will be used.


### Multiple Names

You can use a comma-separated list of names to create a group of nodes with a single node statement:

{% highlight ruby %}
    node 'www1.example.com', 'www2.example.com', 'www3.example.com' {
      include common
      include apache, squid
    }
{% endhighlight %}

This example creates three identical nodes: `www1.example.com`, `www2.example.com`, and `www3.example.com`.

### The Default Node

The name `default` (without quotes) is a special value for node names. If no node statement matching a given node can be found, the `default` node will be used. See [Behavior](#behavior) below.

### Regular Expression Names

[Regular expressions (regexes)][regex] can be used as node names. This is another method for writing a single node statement that matches multiple nodes.

{% highlight ruby %}
    node /^www\d+$/ {
      include common
    }
{% endhighlight %}

The above example would match `www1`, `www13`, and any other node whose name consisted of `www` and one or more
digits.

{% highlight ruby %}
    node /^(foo|bar)\.example\.com$/ {
      include common
    }
{% endhighlight %}

The above example would match `foo.example.com` and `bar.example.com`, but no other nodes.

> Make sure that node regexes do not overlap. If more than one regex statement matches a given node, the one it gets will be parse-order dependent.

Behavior
-----

If site.pp (or the directory of manifests) contains at least one node definition, it must have one for **every** node; compilation for a node will fail if one cannot be found. (Hence the usefulness of [the `default` node](#the-default-node).) If site.pp (or the directory of manifests) contains **no** node definitions, this requirement is dropped.

### Matching

A given node will only get the contents of **one** node definition, even if two node statements could match a node's name. Puppet will do the following checks in order when deciding which definition to use:

1. If there is a node definition with the node's exact name, Puppet will use it.
2. If there is at least one regular expression node statement that matches the node's whole name, Puppet will use the first one it finds.
3. If the node's name looks like a fully qualified domain name (i.e. multiple period-separated groups of letters, numbers, underscores and dashes), Puppet will chop off the final group and start again at step 1. (That is, if a definition for `www01.example.com` isn't found, Puppet will look for a definition matching `www01.example`.)
4. Puppet will use the `default` node.

Thus, for the node `www01.example.com`, Puppet would try the following, in order:

* `www01.example.com`
* The first regex matching `www01.example.com`
* `www01.example`
* The first regex matching `www01.example`
* `www01`
* The first regex matching `www01`
* `default`

You can turn off this fuzzy name matching by changing the puppet master's [`strict_hostname_checking`][strict] setting to `true`. This will cause Puppet to skip step 3 and only use the node's full name before resorting to `default`.

### Regex Capture Variables

Regex node definitions will set numbered regex capture variables ($1, $2, etc.) within the body of the node definition. This is similar to the behavior of [conditional statements][conditional] that use regexes.

### Code Outside Node Statements

Puppet code that is outside any node statement will be compiled for every node. That is, a given node will get both the code in its node definition and the code outside any node definition.

### Node Scope

Node definitions create a new anonymous scope that can override variables and defaults from top scope. See [the section on node scope][nodescope] for details.

### Merging With ENC Data

Node definitions and [external node classifiers][enc] can co-exist. Puppet merges their data as follows:

* Variables from an ENC are set at [top scope][topscope] and can thus be overridden by variables in a node definition.
* Classes from an ENC are declared at [node scope][nodescope], which means they will be affected by any variables set in the node definition.

Although ENCs and node definitions can work together, we recommend that most users pick one or the other.

### Inheritance

Node inheritance has been discontinued and can no longer be used.

> #### Alternatives to Node Inheritance
>
> * Most users who need hierarchical data should keep it in an external source and have their manifests look it up. The best solution right now is [Hiera][], which is available by default in Puppet 3 and later. See our [Hiera guides][hiera] for more information about using it.
> * [ENCs][enc] can look up data from any arbitrary source, and return it to Puppet as top-scope variables.
> * If you have node-specific data in an external CMDB, you can easily write [custom Puppet functions][custom_functions] to query it.
> * For very small numbers of nodes, you can copy and paste to make complete node definitions for special-case nodes.
> * With discipline, you can use node inheritance **only** for data lookup. The safest approach is to **only set variables** in the base nodes, then declare **all** classes in the derived nodes. This is less terse than the mix-and-match that most users try first, but is completely reliable.

<!-- TODO: Add links to documentation about data in modules and environments -->
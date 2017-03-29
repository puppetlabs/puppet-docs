---
layout: default
title: "Subsystems: Catalog compilation"
---

[environment]: ./environments.html
[certname]: ./config_important_settings.html#basics
[resource_declaration]: ./lang_resources.html
[relationships]: ./lang_relationships.html
[cert_extensions]: ./ssl_attributes_extensions.html
[facts]: ./lang_facts_and_builtin_vars.html
[enc]: ./nodes_external.html
[exported resources]: ./lang_exported.html
[puppetdb]: {{puppetdb}}/
[functions]: ./lang_functions.html
[main manifest]: ./dirs_manifest.html
[modules]: ./modules_fundamentals.html
[node terminus]: ./configuration.html#nodeterminus
[plain_node]: ./indirection.html#plain-terminus
[exec_node]: ./indirection.html#exec-terminus
[ldap_node]: ./indirection.html#ldap-terminus
[ldap_guide]: /guides/ldap_nodes.html
[trusted_on]: ./config_important_settings.html#getting-new-features-early
[facts_builtin]: ./lang_facts_and_builtin_vars.html
[node definitions]: ./lang_node_definitions.html
[agent_provided]: #agent-provided-data
[resources]: ./lang_resources.html
[class declarations]: ./lang_classes.html#declaring-classes
[node scope]: ./lang_scope.html#node-scope
[variables]: ./lang_variables.html
[class definitions]: ./lang_classes.html#defining-classes
[classes]: ./lang_classes.html
[manifest naming conventions]: ./modules_fundamentals.html#manifests
[modulepath]: ./dirs_modulepath.html

## Background info

### What's a catalog?

When configuring a node, Puppet agent uses a document called a **catalog,** which it downloads from a Puppet master server. The catalog describes the [desired state for each resource][resource_declaration] that should be managed, and can specify [dependency information][relationships] for resources that should be managed in a certain order.

### Why is it used?

Puppet manifests are concise because they can express variation between nodes with conditional logic, templates, and functions. By resolving these on the master and giving the agent just a specific catalog, Puppet is able to:

* **Separate privileges:** Each individual node has little to no knowledge about other nodes. It only receives its own resources.
* **Reduce the agent's resource consumption:** Since the agent doesn't have to compile, it can use less CPU and memory.
* **Simulate changes:** Since the agent is just checking resources and not running arbitrary code, it has the option of simulating changes. If you do a Puppet run in _noop_ mode, the agent will check against its current state and report on what _would_ have changed without actually making any changes.
* **Record and query configurations:** If you use PuppetDB, you can [query it for information about managed resources on any node]({{puppetdb}}/api/index.html).

### What about Puppet apply?

Puppet apply compiles its own catalog and then applies it, so it plays the role of both Puppet master and Puppet agent.


## Information sources


Puppet compiles a catalog using three main sources of configuration info:

* Agent-provided data
* External data
* Puppet manifests (and associated templates and file sources)

All of these sources are used by both agent/master deployments and by stand-alone Puppet apply nodes.

### Agent-provided data

When agents request a catalog, they send four pieces of information to the Puppet master:

* Their **name,** which is embedded in the request URL. (e.g. `/puppet/v3/catalog/web01.example.com?environment=production`) This is almost always the same as the [certname][].
* Their **certificate,** which contains their [certname][] and possibly some [extra information][cert_extensions]. (This is the one item not used by Puppet apply.)
* Their [**facts.**][facts]
* Their requested [environment][], which is embedded in the request URL. (e.g. `/puppet/v3/catalog/web01.example.com?environment=production`) Before requesting a catalog, agents will ask the master which environment they should be in, but they will use the environment in their own config file if the master doesn't have an opinion.


### External data

Puppet can use external data at several stages when compiling, but there are two main kinds to be aware of:

* Data from an [ENC][] or other node terminus, which is available before compilation starts. This data arrives in the form of a **node object,** which can contain any of the following:
    * **Classes** that should be assigned to the node, and parameters to configure the classes
    * Extra **top-scope variables** that should be set for the node
    * An **environment** for the node (which will override its requested environment)
* Data from other sources, which is accessed as needed during compilation. It can be invoked by the main manifest or by classes or defined types in modules. This kind of data includes:
    * [Exported resources][] queried from [PuppetDB][]
    * The results of [functions][], which can access arbitrary data sources including Hiera or an external CMDB

### Puppet manifests, templates, etc.

This is the heart of a Puppet deployment. It can include:

* The [main manifest][], which might be broken out into per-node `.pp` files for easier organization
* [Modules][] downloaded from the [Puppet Forge](https://forge.puppetlabs.com)
* [Modules][] written specifically for your site

## The process of catalog compilation

This description is simplified. It doesn't delve into the internals of the parser, model, evaluator, etc., and some items are presented out of order for the sake of conceptual clarity.

For practical purposes, you can treat Puppet apply nodes as simply a combined agent and master.

This process begins after the catalog request has been received.

### Step 1: Retrieve the node object

Once the Puppet master has the agent-provided information for this request, it asks its configured **[node terminus][]** for a node object.

By default, Puppet master uses the [`plain` node terminus][plain_node], which just returns a blank node object. This results in only manifests and agent-provided info being used in compilation.

The next most common node terminus is the [`exec` node terminus][exec_node], which will request data from an [external node classifier (ENC)][enc]. This can return classes, variables, and/or an environment, depending on how the ENC is designed.

Less commonly, some people use the [`ldap` node terminus][ldap_node], which will fetch ENC-like information from an LDAP database. See the page on [LDAP nodes][ldap_guide] for more information.

Finally, it's possible to write a custom node terminus that retrieves classes, variables, and environments from any kind of external system.

### Step 2: Set variables from the node object, from facts, and from the certificate

* Any variables provided by the node object will now be set as top-scope Puppet variables.
* The node's facts are also set as top-scope variables.
* The node's facts will also be set in the protected `$facts` hash, and certain data from the node's certificate will be set in the protected `$trusted` hash. See [the page on facts and built-in variables][facts_builtin] for more details.
* Any variables provided by the Puppet master will also be set. See [the page on facts and built-in variables][facts_builtin] for more details.

All of these variables will be available for use by any manifest or template during the subsequent stages of compilation.

### Step 3: Evaluate the main manifest

Puppet now parses the [main manifest][]. The node's [environment][] can specify a main manifest to use; if it doesn't, the Puppet master will use the main manifest from its config file.

The main manifest can contain any arbitrary Puppet code. The way it is evaluated is:

* If there are any [node definitions][] in the manifest, Puppet **must** find one that matches the node's **name** (see [agent-provided information][agent_provided], above). See [the page on node definitions][node definitions] for information on how node statements match names.
    * If at least one node definition is present and Puppet cannot find a match, it will fail compilation now.
* Any code **outside** any node definition is evaluated. Any [resources][] are added to the node's catalog. Any [class declarations][] cause classes to be loaded from modules and declared (see Step 3a below).
* If a matching node definition was found, any code in it is evaluated at [node scope][]. (This means it can [assign variables][variables] that override top-scope variables.) Any resources are added to the catalog, and any class declarations cause classes to be loaded and declared.

### Step 3a: Load and evaluate classes from modules

It's possible for the main manifest to contain [class definitions][], but usually classes are defined elsewhere, in [modules][].

If any [classes][] were declared in the main manifest and their definitions were not present, Puppet will automatically load the manifests containing them from its collection of [modules][]. It will follow the normal [manifest naming conventions][] to locate the files it should load.

The set of locations Puppet will load modules from is called the [modulepath][]. The modulepath can be influenced by the node's [environment][].

Once a class is loaded, the Puppet code in it is evaluated, and any resources are added to the catalog. If it was declared at node scope, it has access to any node-scope variables; otherwise, it only has access to top-scope variables.

Classes can also declare other classes; if they do, Puppet will load and evaluate those in the same way.

### Step 4: Evaluate classes from the node object

Finally, after Puppet has evaluated the main manifest and any classes it declared (and any classes _they_ declared), it will load from modules and evaluate any classes that were specified by the node object. Resources from those classes will be added to the catalog.

If a matching node definition was found in step 3, these classes are evaluated **at node scope,** which means they can access any node-scope variables set by the main manifest. If no node definitions were present in the main manifest, they will be evaluated at top scope.



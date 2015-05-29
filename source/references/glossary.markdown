---
title: Glossary
layout: default
---

# Glossary of Puppet Vocabulary

An accurate, shared vocabulary goes a long way to ensure the success of a project. To that end, this glossary defines the most common terms Puppet users rely on.

### attribute

Attributes are used to specify the state desired for a given configuration resource. Each resource type has a slightly different set of possible attributes, and each attribute has its own set of possible values. For example, a package resource (like `vim`) would have an `ensure` attribute, whose value could be `present`, `latest`, `absent`, or a version number:

~~~ ruby
    package {'vim':
      ensure   => present,
      provider => apt,
    }
~~~

The value of an attribute is specified with the `=>` operator; attribute/value pairs are separated by commas.

### agent

(or  **agent node**)

Puppet is usually deployed in a simple client-server arrangement, and the Puppet client daemon is known as the "agent." By association, a computer running puppet agent is usually referred to as an "agent node" (or simply "agent," or simply "node").

Puppet agent regularly pulls configuration catalogs from a puppet master server and applies them to the local system.

### catalog

A catalog is a compilation of all the resources that will be applied to a given system and the relationships between those resources.

Catalogs are compiled from manifests by a puppet master server and served to agent nodes. Unlike the manifests they were compiled from, they don't contain any conditional logic or functions. They are unambiguous, are only relevant to one specific node, and are machine-generated rather than written by hand.

### class

A collection of related resources, which, once defined, can be declared as a single unit. For example, a class could contain all of the elements (files, settings, modules, scripts, etc) needed to configure Apache on a host. Classes can also declare other classes.

Classes are singletons, and can only be applied once in a given configuration, although the `include` keyword allows you to declare a class multiple times while still only evaluating it once.

> **Note:** Being singletons, Puppet classes are not analogous to classes in object-oriented programming languages. OO classes are like templates that can be instantiated multiple times; Puppet's equivalent to this concept is [defined types](#type-defined).

### classify

(or **node classification**)

To assign [classes](#class) to a [node](#agent), as well as provide any data the classes require. Writing a class makes a set of configurations available; classifying a node determines what its actual configuration will be.

Nodes can be classified with [node definitions](#node-definition) in the [site manifest](#site-manifest), with an [ENC](#external-node-classifier), or with both.

### declare

To direct Puppet to include a given class or resource in a given configuration. To declare resources, use the lowercase `file {'/tmp/bar':}` syntax. To declare classes, use the `include` keyword or the `class {'foo':}` syntax. (Note that Puppet will automatically declare any classes it receives from an [external node classifier](#external-node-classifier).)

You can configure a resource or class when you declare it by including [attribute/value pairs](#attribute).

Contrast with "[define](#define)."

### define

To specify the contents and behavior of a class or a defined resource type. Defining a class or type doesn't automatically include it in a configuration; it simply makes it available to be [declared](#declare).

### define (noun)

(or **definition**)

An older term for a [defined resource type](#type-defined).

### define (keyword)

The language keyword used to create a [defined type](#type-defined).

### defined resource type

(or **defined type**)

See "[type (defined)](#type-defined)."

### ENC

See [external node classifier](#external-node-classifier).

### environment

An arbitrary segment of your Puppet [site](#site), which can be served a different set of modules. For example, environments can be used to set up scratch nodes for testing before roll-out, or to divide a site by types of hardware.

### expression

The Puppet language supports several types of expressions for comparison and evaluation purposes. Amongst others, Puppet supports boolean expressions, comparision expressions, and arithmetic expressions. See [the Expressions page](/puppet/latest/reference/lang_expressions.html) in the latest Puppet language reference for more information.

### external node classifier

(or **ENC**)

An executable script, which, when called by the puppet master, returns information about which classes to apply to a node.

ENCs provide an alternate method to using the main site manifest (`site.pp`) to classify nodes. An ENC can be written in any language, and can use information from any pre-existing data source (such as an LDAP db) when classifying nodes.

An ENC is called with the name of the node to be classified as an argument, and should return a YAML document describing the node. See [External Nodes](/guides/external_nodes.html) for more information.

### fact

A piece of information about a node, such as its operating system, hostname, or IP address.

Facts are read from the system by [Facter](#facter), and are made available to Puppet as global variables.

Facter can also be extended with custom facts, which can expose site-specific details of your systems to your Puppet manifests. See [Custom Facts](/facter/latest/custom_facts.html) for more details.

### Facter

Facter is Puppet's system inventory tool. Facter reads [facts](#fact) about a node (such as its hostname, IP address, operating system, etc.) and makes them available to Puppet.

Facter includes a large number of built-in facts; you can view their names and values for the local system by running `facter` at the command line.

In agent/master Puppet arrangements, agent nodes send their facts to the master.

* [Facter product page](http://puppetlabs.com/puppet/related-projects/facter/)
* [Facter GitHub page](https://github.com/puppetlabs/facter)

### filebucket

A repository in which Puppet stores file backups when it has to replace files. A filebucket can be either local (and owned by the node being mangaed) or site-global (and owned by the puppet master). Typically, a single filebucket is defined for a whole network and is used as the default backup location.

See [type: filebucket](/references/stable/type.html#filebucket) for more information.

### function

A statement in a manifest which returns a value or makes a change to the catalog.

Since they run during compilation, functions happen on the puppet master in an agent/master arrangement. The only agent-specific information they have access to are the [facts](#fact) the agent submitted.

Common functions include `template`, `notice`, and `include`. You can choose from the [list of built-in functions](/references/stable/function.html), use functions from public modules (like [puppetlabs-stdlib](http://forge.puppetlabs.com/puppetlabs/stdlib)), or write our own custom functions (see the [Writing Your Own Functions page](/guides/custom_functions.html)).

### global scope

See [scope](#scope).

### host

Any computer (physical or virtual) attached to a network.

In the Puppet docs, this usually means an instance of an operating system with the Puppet agent installed. See also "[Agent Node](#agent)".

### host (resource type)

An entry in a system's `hosts` file, used for name resolution. See [type: host](/references/stable/type.html#host) for more information.

### idempotent

Able to be applied multiple times with the same outcome. Puppet resources are idempotent, since they describe a desired final state rather than a series of steps to follow.

(The only major exception is the `exec` type; exec resources must still be idempotent, but it's up to the user to design each exec resource correctly.)


### inheritance (class)

A Puppet class can be derived from one other class with the `inherits` keyword. The derived class will declare all of the same resources, but can override some of their attributes and add new resources.

> **Note:** Most users should avoid inheritance most of the time. Unlike object-oriented programming languages, inheritance isn't terribly important in Puppet; it is only useful for overriding attributes, which can be done equally well by using a single class with a few [parameters](#parameter-defined-types-and-parameterized-classes).



### inheritance (node)

Node statements can be derived from other node statements with the `inherits` keyword. This works identically to the way class inheritance works.

> **Note:** Node inheritance **should almost always be avoided.** Many new users attempt to use node inheritance to look up variables that have a common default value and a rare specific value on certain nodes; it is not suited to this task, and often yields the opposite of the expected result. If you have a lot of conditional per-node data, we recommend using the Heira tool or assigning variables with an ENC instead.

### master

In a standard Puppet client-server deployment, the server is known as the master. The puppet master serves configuration [catalogs](#catalog) on demand to the puppet [agent](#agent) service that runs on the clients.

The puppet master uses an HTTP server to provide catalogs. It can run as a standalone daemon process with a built-in web server, or it can be managed by a production-grade web server that supports the rack API. The built-in web server is meant for testing, and is not suitable for use with more than ten nodes.

### manifest

A file containing code written in the Puppet language, and named with the `.pp` file extension. The Puppet code in a manifest can:

* [Declare](#declare) [resources](#resource) and [classes](#class)
* Set [variables](#variable)
* Evaluate [functions](#function)
* [Define](#define) [classes](#class), [defined types](#type-defined), and [nodes](#node-definition)


Most manifests are contained in [modules](#module). Every manifest in a module should [define](#define) a single [class](#class) or [defined type](#type-defined).

The puppet master service reads a single "site manifest," usually located at `/etc/puppet/manifests/site.pp`. This manifest usually defines [nodes](#node-definition), so that each managed [agent node](#node) will receive a unique catalog.

### metaparameter

A resource [attribute](#attribute) that can be specified for any type of resource. Metaparameters are part of Puppet's framework rather than part of a specific [type](#type), and usually affect the way resources relate to each other. For a list of metaparameters and their usage, see the [Metaparameter Reference](/references/stable/metaparameter.html).

### module

A collection of classes, resource types, files, and templates, organized around a particular purpose. For example, a module could be used to completely configure an Apache instance or to set-up a Rails application. There are many pre-built modules available for download in the [Puppet Forge](http://forge.puppetlabs.com/). For more information see:

* [Module Fundamentals](/puppet/latest/reference/modules_fundamentals.html)
* [Installing Modules](/puppet/latest/reference/modules_installing.html)

### namevar

(or **name**)

The attribute that represents a [resource](#resource)'s **unique identity** on the **target system.** For example: two different files cannot have the same `path`, and two different services cannot have the same `name`.

Every resource [type](#type) has a designated namevar; usually it is simply `name`, but some types, like [`file`](/references/latest/type.html#file) or [`exec`](/references/latest/type.html#exec), have their own (e.g. `path` and `command`). If the namevar is something other than `name`, it will be called out in the [type reference](/references/latest/type.html).

If you do not specify a value for a resource's namevar when you declare it, it will default to that resource's [title](#title).

### node (definition)

(or **node statement**)

A collection of classes, resources, and variables in a manifest, which will only be applied to a certain [agent node](#agent). Node definitions begin with the `node` keyword, and can match a node by full name or by regular expression.

When a managed node retrieves or compiles its catalog, it will receive the contents of a single matching node statement, as well as any classes or resources declared outside any node statement. The classes in every _other_ node statement will be hidden from that node.

See [node definitions](/puppet/latest/reference/lang_node_definitions.html) in the latest Puppet language reference for more details.

### node scope

The local variable [scope](#scope) created by a [node definition](#node-definition). Variables declared in this scope will override top-scope variables. (Note that [ENCs](#external-node-classifier-enc) assign variables at top scope, and do not introduce node scopes.)

### noop

Noop mode (short for "No Operations" mode) lets you simulate your configuration without making any actual changes. Basically, noop allows you to do a dry run with all logging working normally, but with no effect on any hosts. To run in noop mode, execute `puppet agent` or `puppet apply` with the `--noop` option.

### notify

A notification [relationship](#relationship), set with the `notify` [metaparameter](#metaparameter) or the wavy chaining arrow. (`~>`) See ["Relationships and Ordering"][lang_puppet_relationships] in the Puppet language reference for more details.

### notification

A type of [relationship](#relationship) that both declares an order for resources and causes [refresh](#refresh) events to be sent. See ["Relationships and Ordering"][lang_puppet_relationships] in the Puppet language reference for more details.

### ordering

Which resources should be managed before which others.

By default, the order of a [manifest](#manifest) is not the order in which resources are managed. You must declare a [relationship](#relationship) if a resource depends on other resources. See ["Relationships and Ordering"][lang_puppet_relationships] in the Puppet language reference for more details.

### parameter

Generally speaking, a parameter is a chunk of information that a class or resource can accept. See also:

* [parameter (custom type and provider development)](#parameter-custom-type-and-provider-development)
* [parameter (defined types and parameterized classes)](#parameter-defined-types-and-parameterized-classes)
* [parameter (external nodes)](#parameter-external-nodes)

### parameter (custom type and provider development)

A value which does not call a method on a provider. Eventually expressed as an attribute in instances of this resource type. See [Custom Types](/guides/custom_types.html).

### parameter (defined types and parameterized classes)

A variable in the [definition](#define) of a class or defined type, whose value is set by a resource [attribute](#attribute) when an instance of that type (or class) is declared.

~~~ ruby
    define my_new_type ($my_parameter) {
      file {"$title":
        ensure  => file,
        content => $my_parameter,
      }
    }

    my_new_type {'/tmp/test_file':
      my_parameter => "This text will become the content of the file.",
    }
~~~

The parameters you use when defining a type (or class) become the attributes available when the type (or class) is declared.


### parameter (external nodes)

A top-scope variable set by an [external node classifier](#external-node-classifier). Although these are called "parameters," they are just normal variables; the name refers to the fact that they are usually used to configure the behavior of classes.


### pattern

A colloquial term, describing a collection of related manifests meant to solve an issue or manage a particular configuration item. (For example, an Apache pattern.) See also [module](#module).

### plusignment operator

The `+>` operator, which allows you to add values to resource attributes using the ('plusignment') syntax. Useful when you want to override resource attributes without having to respecify already declared values.

### property (custom type and provider development)

A value that corresponds to an observable piece of state on the target system. When retrieving the state of a resource, a property will call the specified method on the provider, which will read the state from the system. If the current state does not match the specified state, the provider will change it.

Properties appear as [attributes](#attribute) when declaring instances of this resource type. See [Custom Types](/guides/custom_types.html).

### provider

Providers implement resource [types](#type) on a specific type of system, using the system's own tools. The division between types and providers allows a single resource type (like [`package`](/references/latest/type.html#package)) to manage packages on many different systems (using, for example, `yum` on Red Hat systems, `dpkg` and `apt` on Debian-based systems, and `ports` on BSD systems).

Typically, providers are simple Ruby wrappers around shell commands, so they are usually short and easy to create.

### plugin

A custom [type](#type), [function](#function), or [fact](#fact) that extends Puppet's capabilities and is distributed via a [module](#module). See [Plugins in Modules](/guides/plugins_in_modules.html) for more details.

### realize

To specify that a [virtual resource](#virtual-resource) should actually be applied to the current system. Once a virtual resource has been declared, there are two methods for realizing it:

1. Use the "spaceship" syntax `<||>`
2. Use the `realize` function

A virtually declared resource will be present in the [catalog](#catalog), but will not be applied to a system until it is realized. See [Virtual Resources](/guides/virtual_resources.html) for more details.

### refresh

A resource gets **refreshed** when a resource it [subscribes to](#subscribe) (or which [notifies it](#notify)) is changed.

Different resource types do different things when they get refreshed. (Services restart; mount points unmount and remount; execs usually do nothing, but will fire if the `refreshonly` attribute is set.)

### relationship

A rule stating that one resource should be managed before another. See ["Relationships and Ordering"][lang_puppet_relationships] in the Puppet language reference for more details.

[lang_puppet_relationships]: /puppet/latest/reference/lang_relationships.html

### resource

A unit of configuration, whose state can be managed by Puppet. Every resource has a [type](#type) (such as `file`, `service`, or `user`), a [title](#title), and one or more [attributes](#attribute) with specified values (for example, an `ensure` attribute with a value of `present`).

Resources can be large or small, simple or complex, and they do not always directly map to simple details on the client -- they might sometimes involve spreading information across multiple files, or even involve modifying devices. For example, a `service` resource only models a single service, but may involve executing an init script, running an external command to check its status, and modifying the system's run level configuration.

### resource declaration

A fragment of Puppet code that details the desired state of a resource and instructs Puppet to manage it. This term helps to differentiate between the literal resource on disk and the specification for how to manage that resource. However, most often, these are just referred to as "resources."

### scope

The area of code where a variable has a given value.

Class definitions and type definitions create local scopes. Variables declared in a local scope are available by their short name (e.g. `$my_variable`) inside the scope, but are hidden from other scopes unless you refer to them by their fully qualified name (e.g. `$my_class::my_variable`).

Variables outside any definition (or set by an ENC) exist at a special "top scope;" they are available everywhere by their short names (e.g. `$my_variable`), but can be overridden in a local scope if that scope has a variable of the same name.

Node definitions create a special "node scope." Variables in this scope are also available everywhere by their short names, and can override top-scope variables.


> Note: Previously, Puppet used dynamic scope, which would search for short-named variables through a long chain of parent scopes. This was deprecated in version 2.7 and will be removed in the next version. For more information, see [Scope and Puppet](/guides/scope_and_puppet.html).

### site

An entire IT ecosystem being managed by Puppet. That is, a site includes all puppet master servers, all agent nodes, and all independent masterless Puppet nodes within an organization.

### site manifest

The main "point of entry" [manifest](#manifest) used by the puppet master when compiling a catalog. The location of this manifest is set with the `manifest` setting in puppet.conf. Its default value is usually `/etc/puppet/manifests/site.pp` or `/etc/puppetlabs/puppet/manifests/site.pp`.

The site manifest usually contains [node definitions](#node-definition). When an [ENC](#external-node-classifier) is being used, the site manifest may be nearly empty, depending on whether the ENC was designed to have complete or partial node information.

### site module

A common idiom in which one or more [modules](#module) contain [classes](#class) specific to a given Puppet site. These classes usually describe complete configurations for a specific system or a given group of systems. For example, the `site::db_slave` class might describe the entire configuration of a database server, and a new database server could be configured simply by applying that class to it.

### subclass

A class that inherits from another class. See [inheritance](#inheritance-class).

### subscribe

A notification [relationship](#relationship), set with the `subscribe` [metaparameter](#metaparameter) or the wavy chaining arrow. (`~>`)
See ["Relationships and Ordering"][lang_puppet_relationships] in the Puppet language reference for more details.

### template

A partial document which is filled in with data from [variables](#variable). Puppet can use Ruby ERB templates to generate configuration files tailored to an individual system. See [Templating](/guides/templating.html) for more details.

### title

The unique identifier (in a given Puppet [catalog](#catalog)) of a resource or class.

* In a class, the title is simply the name of the class.
* In a resource declaration, the title is the part after the first curly brace and before the colon; in the example below, the title is `/etc/passwd`:

~~~ ruby
        file  { '/etc/passwd':
          owner => 'root',
          group => 'root',
        }
~~~

* In native resource types, the [name or namevar](#namevar) will use the title as its default value if you don't explicitly specify a name.
* In a defined resource type or a class, the title is available for use throughout the definition as the `$title` variable.

Unlike the name or namevar, a resource's title need not map to any actual attribute of the target system; it is only a referent. This means you can give a resource a single title even if its name has to vary across different kinds of system, like a configuration file whose location differs on Solaris.

For more on resource titles, see [the Resources page](/puppet/latest/reference/lang_resources.html#syntax) of the latest Puppet language reference.

### top scope

See [scope](#scope).

### type

A kind of [resource](#resource) that Puppet is able to manage; for example, `file`, `cron`, and `service` are all resource types. A type specifies the set of attributes that a resource of that type may use, and models the behavior of that kind of resource on the target system. You can declare many resources of a given type.

Puppet ships with a set of built-in resource types; see the [type reference](/references/stable/type.html) for a complete list of them. New [native types](#type-native) can be added as [plugins](#plugin), and [defined types](#type-defined) can be constructed by grouping together resources of existing types.

### type (defined)

(or **defined resource type;** sometimes called a **define** or **definition**)

A [resource type](#type) implemented as a group of other resources, written in the Puppet language and saved in a [manifest](#manifest). (For example, a defined type could use a combination of `file` and `exec` resources to set up and populate a Git repository.) Once a type is [defined](#define), new resources of that type can be [declared](#declare) just like any native or custom resource.

Since defined types are written in the Puppet language instead of as Ruby plugins, they are analogous to macros in other languages. Contrast with [native types](#type-native). For more information, see [the Learning Puppet chapter on defined types](/learning/definedtypes.html).

### type (native)

A resource type written in Ruby. Puppet ships with a large set of built-in native types, and custom native types can be distributed as [plugins](#plugin) in [modules](#module). See the [type reference](/references/stable/type.html) for a complete list of built-in types.

Native types have lower-level access to the target system than defined types, and can directly use the system's own tools to make changes. Most native types have one or more [providers](#provider), so that they can implement the same resources on different kinds of systems.


### variable

A named placeholder in a [manifest](#manifest) that represents a value. Variables in Puppet are similar to variables in other programming languages, and are indicated with a dollar sign (e.g. `$operatingsystem`) and assigned with the equals sign (e.g. `$myvariable = "something"`). Once assigned, variables cannot be reassigned within the same [scope](#scope); however, other local scopes can assign their own value to any variable name.

[Facts](#fact) from [agent nodes](#agent) are represented as variables within Puppet manifests, and are automatically pre-assigned before compilation begins. There are also [several other special pre-assigned variables](/puppet/latest/reference/lang_facts_and_builtin_vars.html).

### variable scoping

See [scope](#scope) above.

### virtual resource

A resource that is declared in the catalog but will not be applied to a system unless it is explicitly [realized](#realize).

See [Virtual Resources](/guides/virtual_resources.html) for more details.

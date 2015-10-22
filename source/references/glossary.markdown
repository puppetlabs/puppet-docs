---
title: Glossary of Puppet Vocabulary
layout: default
canonical: "/references/glossary.html"
---

[Relationships and Ordering]: /puppet/latest/reference/lang_relationships.html
[Puppet language]: #puppet-language

An accurate, shared vocabulary goes a long way to ensure the success of a project. To that end, this glossary defines the most common terms that Puppet users rely on.

### attribute

Attributes specify the desired state of a given configuration resource. Each resource type has a different set of attributes, and each attribute has its own set of allowed values. For example, a package resource (like `vim`) would have an `ensure` attribute, whose value could be `present`, `latest`, `absent`, or a version number:

~~~ ruby
package {'vim':
  ensure   => present,
  provider => apt,
}
~~~

You specify an attribute's value with the `=>` operator, and pairs of attributes and values are separated by commas.

### agent

(or **agent node**)

Puppet is usually deployed in a simple client-server arrangement, and the Puppet client daemon is known as the "agent." By association, a computer running Puppet agent can be referred to as an "agent node" (or simply "agent" or "node").

A Puppet agent regularly pulls a configuration [catalog](#catalog) from a [Puppet master](#master) server and applies it to the local system. A Puppet master also runs the Puppet agent daemon to allow its own configuration to be [puppetized](#puppetize).

### catalog

A catalog is a compilation of all the [resources](#resource) that the Puppet [agent](#agent) applies to a given system and the relationships between those resources.

Catalogs are compiled by a Puppet [master](#master) server from [manifests](#manifest) and served to agents. Unlike the manifests they were compiled from, catalogs don't contain any conditional logic or functions. They are unambiguous, relevant to only one specific node, and machine-generated rather than written by hand.

### class

A collection of related [resources](#resource) that, once [defined](#define), can be [declared](#declare) as a single unit. For example, a class can contain all of the resources (such as files, settings, modules, and scripts) needed to configure the Apache webserver on a host. Classes can also declare other classes.

Classes are [singletons](#singleton) and can be applied only once in a given configuration, although the `include` keyword allows you to declare a class multiple times that Puppet only evaluates once.

> **Note:** Being singletons, Puppet classes are not analogous to classes in object-oriented programming languages. Object-oriented classes are like templates that can be instantiated multiple times; Puppet's equivalent to this concept is [defined types](#type-defined).

### classify

(or **node classification**)

To assign [classes](#class) to a [node](#agent), as well as provide any data the classes require, you **classify** the node. By writing a class, you enable a set of configurations; by classifying a node, you determine what its actual configuration will be.

You can classify nodes by using [node definitions](#node-definition) in the [site manifest](#site-manifest), with an [ENC](#external-node-classifier), or with both.

### data type

A **data type** is a named classification of a value type that a [variable](#variable) or parameter may hold. The Puppet language has both concrete data types such as Integer, Boolean or String, and abstract types such as Any, or Optional.

### declare

To direct Puppet to include a given [class](#class) or [resource](#resource) in a given configuration, you **declare** it. To declare resources, use the lowercase `file {'/tmp/bar':}` syntax. To declare classes, use the `include` keyword or the `class {'foo':}` syntax. (Note that Puppet automatically declares any classes it receives from an [external node classifier](#external-node-classifier).)

You can configure a resource or class when you declare it by including [attribute/value pairs](#attribute).

Contrast with "[define](#define)."

### define

To specify the contents and behavior of a [class](#class) or a [defined type](#type-defined), you **define** it using the [Puppet language][]. Defining a class or type doesn't automatically include it in a configuration; it simply makes it available to be [declared](#declare).

### define (noun)

(or **definition**)

As a noun, **define** is an older term for a [defined type](#type-defined). For instance, a module might refer to its available defines.

### define (keyword)

You use the **`define`** [Puppet language][] keyword to create a [defined type](#type-defined).

### defined type

(or **defined resource type**)

See [type (defined)](#type-defined).

### ENC

See [external node classifier](#external-node-classifier).

### environment

An **environment** is an isolated group of Puppet [agent nodes](#agent) that a Puppet [master](#master) can serve with its own [main manifest](#manifest) and set of [modules](#modules). For example, you can use environments to set up scratch [nodes](#node) for testing before rolling out changes to production, or divide a site by types of hardware.

For more information, see the [About Environments](/puppet/latest/reference/environments.html) page.

### expression

The [Puppet language][] supports several types of **expressions** for comparison and evaluation purposes, including Boolean expressions, comparison expressions, and arithmetic expressions. For more information, see [the Expressions page](/puppet/latest/reference/lang_expressions.html) in the [Puppet language][] reference.

### external node classifier

(or **ENC**)

An **external node classifier** (ENC) is an executable script that returns information about which [classes](#class) to apply to a [node](#node) when called by a Puppet [master](#master).

ENCs provide an alternative to using the main [site manifest](#site-manifest) (`site.pp`) to classify nodes. An ENC can be written in any language, and can use information from any data source (such as an LDAP database) when classifying nodes.

An ENC is called with the name of the node to be classified as an argument, and should return a YAML document describing the node. For more information, see the [External Nodes](/guides/external_nodes.html) guide.

### fact

A piece of information about a [node](#node), such as its operating system, hostname, or IP address, is a **fact**.

[Facter](#facter) reads facts from a node and makes them available to Puppet as global [variables](#variable).

You can extend Facter with custom facts, which can expose [site-specific](#site) details of your systems to your Puppet [manifests](#manifest). For more information, see the [Custom Facts](/facter/latest/custom_facts.html) documentation.

### Facter

**Facter** is Puppet's system inventory tool. Facter reads [facts](#fact) about a [node](#node), such as its hostname, IP address, and operating system, and makes them available to Puppet.

Facter includes many built-in facts, and you can view their names and values for the local system by running `facter` at the command line.

In [agent](#agent)/[master](#master) Puppet arrangements, Puppet agent nodes send their facts to the Puppet master.

* [Facter documentation](https://docs.puppetlabs.com/facter/)
* [Facter GitHub project](https://github.com/puppetlabs/facter)

### filebucket

A repository in which Puppet stores file backups when it has to replace files is called a **filebucket**. A filebucket can be local (and owned by the [node](#node) being managed) or site-global (and owned by the Puppet [master](#master)). Typically, a single filebucket is defined for a network and is used as the default backup location.

For more information, see the [`filebucket` type](/references/stable/type.html#filebucket) in the [Puppet language][] type reference.

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

> **Note:** Node inheritance **should almost always be avoided.** Many new users attempt to use node inheritance to look up variables that have a common default value and a rare specific value on certain nodes; it is not suited to this task, and often yields the opposite of the expected result. If you have a lot of conditional per-node data, we recommend using the Hiera tool or assigning variables with an ENC instead.

### master

In a standard Puppet client-server deployment, the server is known as the master. The puppet master serves configuration [catalogs](#catalog) on demand to the puppet [agent](#agent) service that runs on the clients.

The puppet master uses an HTTP server to provide catalogs. It can run as a standalone daemon process with a built-in web server, or it can be managed by a production-grade web server that supports the rack API. The built-in web server is meant for testing, and is not suitable for use with more than ten nodes.

### manifest

A **manifest** file contains code written in the [Puppet language][] and is named with the `.pp` file extension. The Puppet code in a manifest can:

* [Declare](#declare) [resources](#resource) and [classes](#class)
* Set [variables](#variable)
* Evaluate [functions](#function)
* [Define](#define) [classes](#class), [defined types](#type-defined), and [nodes](#node-definition)

Most manifests are contained in [modules](#module). Every manifest in a module should [define](#define) a single [class](#class) or [defined type](#type-defined).

The Puppet [master](#master) service reads an [environment's](#environment) main manifest, such as the production environment's main manifest in `/etc/puppetlabs/code/environments/production/manifests`. This manifest usually defines [nodes](#node-definition), so that each managed [agent](#agent) receives a unique [catalog](#catalog).

### metaparameter

A **metaparameter** is a [resource](#resource) [attribute](#attribute) that can be specified for any type of resource. Metaparameters are part of Puppet's framework rather than part of a specific [type](#type), and usually affect the way resources relate to each other. For a list of metaparameters and their usage, see the [Metaparameter Reference](/references/stable/metaparameter.html).

### module

A collection of [classes](#class), [resource](#resource) [types](#type), files, and [templates](#template), organized around a particular purpose. For example, a module can configure an Apache webserver instance or Rails application. There are many modules available for download in the [Puppet Forge](https://forge.puppetlabs.com/). For more information, see:

* [Module Fundamentals](/puppet/latest/reference/modules_fundamentals.html)
* [Installing Modules](/puppet/latest/reference/modules_installing.html)

### namevar

(or **name**)

This [attribute](#attribute) represents a [resource's](#resource) unique identity on the target system. For example, two different files cannot have the same `path`, and two different services cannot have the same `name`.

Every resource [type](#type) has a designated namevar, usually `name`. Some types, such as [`file`](/references/latest/type.html#file) or [`exec`](/references/latest/type.html#exec), have their own (in these cases, `path` and `command`, respectively). If a type's namevar is something other than `name`, it's called out in the [type reference](/references/latest/type.html).

If you don't specify a value for a resource's namevar when you declare it, it defaults to that resource's [title](#title).

### node (definition)

(or **node statement**)

A collection of [classes](#class), [resources](#resource), and [variables](#variable) in a manifest, which will only be applied to a certain [agent node](#agent). Node definitions begin with the `node` keyword, and can match a node by full name or by regular expression.

When a managed node retrieves or compiles its catalog, it will receive the contents of a single matching node statement, as well as any classes or resources declared outside any node statement. The classes in every _other_ node statement will be hidden from that node.

For more information, see the [node definitions](/puppet/latest/reference/lang_node_definitions.html) in the [Puppet language][] reference.

### node scope

The local variable [scope](#scope) created by a [node definition](#node-definition). Variables declared in this scope will override top-scope variables. (Note that [ENCs](#external-node-classifier-enc) assign variables at top scope, and do not introduce node scopes.)

### noop

Noop mode (short for "No Operations" mode) lets you simulate your configuration without making any actual changes. Basically, noop allows you to do a dry run with all logging working normally, but with no effect on any hosts. To run in noop mode, execute `puppet agent` or `puppet apply` with the `--noop` option.

### notify

A notification [relationship](#relationship) set with the `notify` [metaparameter](#metaparameter) or the wavy [chaining arrow](#chaining-arrow) (`~>`). For more information, see [Relationships and Ordering][] in the [Puppet language][] reference.

### notification

A type of [relationship](#relationship) that both declares an order for resources and causes [refresh](#refresh) events to be sent. For more information, see  [Relationships and Ordering][] in the [Puppet language][] reference.

### ordering

By **ordering** [resources](#resource), you determine which resources should be managed before others.

By default, the order of a [manifest](#manifest) is not the order in which Puppet manages resources. You must declare a [relationship](#relationship) if a resource depends on other resources. For more information, see [Relationships and Ordering][] in the [Puppet language][] reference.

### parameter

Generally speaking, a **parameter** is a chunk of information that a [class](#class) or [resource](#resource) can accept. See also:

* [parameter (custom type and provider development)](#parameter-custom-type-and-provider-development)
* [parameter (defined types and parameterized classes)](#parameter-defined-types-and-parameterized-classes)
* [parameter (external nodes)](#parameter-external-nodes)

### parameter (custom type and provider development)

This type of parameter is a value that does not call a method on a [provider](#provider). They are eventually expressed as [attributes](#attributes) in instances of this [resource](#resource) [type](#type). For more information, see the [Custom Types](/guides/custom_types.html) guide.

### parameter (defined types and parameterized classes)

This type of parameter is a [variable](#variable) in the [definition](#define) of a [class](#class) or [defined type](#type-defined), whose value is set by a [resource](#resource) [attribute](#attribute) when an instance of that type or class is [declared](#declare).

~~~ ruby
define my_new_type ($my_parameter) {
  file { "$title":
    ensure  => file,
    content => $my_parameter,
  }
}

my_new_type { '/tmp/test_file':
  my_parameter => "This text will become the content of the file.",
}
~~~

The parameters you use when defining a type or class become the attributes available when the type or class is declared.

### parameter (external nodes)

This type of parameter is a top-scope [variable](#variable) set by an [external node classifier](#external-node-classifier). Although these are called "parameters," they are just normal variables; the name refers to how they are usually used to configure the behavior of [classes](#class).

### pattern

"**Pattern**" is used colloquially to describe a collection of related [manifests](#manifest) designed to solve an issue or manage a particular configuration item. For example, an "Apache pattern" refers to the manifests designed to configure Apache. See also [module](#module).

### plusignment operator

The **plusignment** (`+>`) **operator** adds values to [resource](#resource) [attributes](#attribute) using the plusignment syntax. This  is useful when you want to override resource attributes without having to specify already-declared values a second time. For more information, see the [Appending to Resource Attributes](/puppet/latest/reference/lang_classes.html#appending-to-resource-attributes) section in the [Puppet language][] reference.

### profile

A **profile** represents the configuration of a technology stack for a [site](#site) and typically consists of one or more [classes](#class). A [role](#role) can include as many profiles as required to define itself. Profiles are included in [role and profile modules](#role-and-profile-module).

For more information about roles and profiles, see [the Puppet Enterprise documentation](/pe/latest/puppet_assign_configurations.html#assigning-configuration-data-with-role-and-profile-modules).

### property (custom type and provider development)

A **property** is a value that corresponds to an observable part of the target [node's](#node) state. When retrieving a [resource's](#resource) state, a property calls the specified method on the [provider](#provider), which reads the state from the system. If the current state does not match the specified state, the provider  changes it.

Properties appear as [attributes](#attribute) when [declaring](#declare) instances of this resource [type](#type). For more information, see the [Custom Types](/guides/custom_types.html) guide.

### provider

**Providers** implement [resource](#resource) [types](#type) on a specific type of system by using the system's own tools. The division between types and providers allows a single resource type (like [`package`](/references/latest/type.html#package)) to manage packages on many different systems (using, for example, `yum` on Red Hat systems, `dpkg` and `apt` on Debian-based systems, and `ports` on BSD systems).

Providers are often Ruby wrappers around shell commands, and can be short and easy to create.

### plugin

A **plugin** is a custom [type](#type), [function](#function), or [fact](#fact) that extends Puppet's capabilities and is distributed via a [module](#module). See [Plugins in Modules](/guides/plugins_in_modules.html) for more details.

### Puppet

"Puppet" can refer to several things:

* The Puppet suite of automation products.
* The open source Puppet project.
* The command you run to invoke the Puppet [agent](#agent) daemon on a [node](#node).
* The [Puppet language][] that you use you write [manifests](#manifest).

### Puppet language

(or **Puppet code**)

You write Puppet [manifests](#manifest) in the **Puppet language**. The Puppet [master](#master) compiles this **Puppet code** into a [catalog](#catalog) during a [Puppet run](#puppet-run). For a summary of the Puppet language, see the [Language: Basics](/puppet/latest/reference/lang_summary.html) documentation.

### Puppet run

A **Puppet run** is when a Puppet [agent](#agent) requests a [catalog](#catalog) from a Puppet [master](#master), which then compiles that agent's [manifest](#manifest) into a new catalog and sends it to the [agents](#agent). The agent then applies that catalog to the [node](#node) by using [providers](#provider) to bring the node's [properties](#property) in line with the catalog. By default, a Puppet run takes place every 30 minutes.

### Puppetfile

A **Puppetfile** is an authoritative, standalone list that specifies which [modules](#module) to install, what versions to install, and a source for the modules. You can use Puppetfiles with [r10k](#r10k) to quickly install sets of modules. For more information, see [Managing Modules with the Puppetfile](/pe/latest/r10k_puppetfile.html). For the Puppetfile format specification, see 

### puppetize

A **puppetized** system, [resource](#resource), or [property](#property) is one that is managed by Puppet.

### r10k

The **r10k** tool helps you manage [Puppet code][] in [enivronments](#environment) and [modules](#module) by using [Puppetfiles](#puppetfile). For more information, see the [Getting to Know r10k](/pe/latest/r10k.html) guide.

### realize

To specify that a [virtual resource](#virtual-resource) should be applied to the current system, it must be **realized**. After you [declare](#declare) a virtual resource, there are two methods for realizing it:

1. Use the "spaceship" syntax (`<||>`).
2. Use the `realize` [function](#function).

A virtually declared resource is present in the [catalog](#catalog) but won't be applied to a system until it is realized. For more information, see the [Virtual Resources](/guides/virtual_resources.html) guide.

### refresh

A [resource](#resource) is **refreshed** when a resource it [subscribes to](#subscribe) (or which [notifies it](#notify)) is modified.

Different resource types do different things when they're refreshed. For instance, Sservices restart, mount points unmount and remount, and `exec`s execute if the `refreshonly` [attribute](#attribute) is set.

### relationship

A rule that sets the order in which [resources](#resource) should be managed creates a **relationship** between those resources. For more information, see [Relationships and Ordering][] in the [Puppet language][] reference.

### resource

A **resource** is a unit of configuration whose state can be managed by Puppet. Every resource has a [type](#type) (such as `file`, `service`, or `user`), a [title](#title), and one or more [attributes](#attribute) with specified values.

Resources can be large or small, and simple or complex. They do not always directly map to simple details on the client --- they might involve spreading information across multiple files or modifying devices. For example, a `service` resource only models a single service, but might involve executing an init script, running an external command to check its status, and modifying the system's run level configuration.

For more information about resources, see the [Language: Resource](/puppet/latest/reference/lang_resources.html) documentation.

### resource declaration

A **resource declaration** is a fragment of [Puppet code](#puppet-language) that details the desired state of a [resource](#resource) and instructs Puppet to manage it. This term helps to differentiate between the literal resource on a system and the specification for how to manage that resource. However, resource declarations are often referred to simply as "resources."

### role

A **role** defines the business purpose that a [node](#node) performs. A role typically consists of one [class](#class) that can completely configure categories of nodes with [profiles](#profile). A node shouldn't have more than one role; if a node requires more than one existing role, you should create a new role for it. See also [role and profile modules](#role-and-profile-module). 

For more information about roles and profiles, see [the Puppet Enterprise documentation](/pe/latest/puppet_assign_configurations.html#assigning-configuration-data-with-role-and-profile-modules).

### role and profile module

A **role and profile module** is a Puppet [module](#module) that assigns configuration data to groups of [nodes](#node) based on [roles](#role) and [profiles](#profile). A role and profile module doesn't have any special features; it simply represents an abstract, private, [site-specific](#site) way to use modules to configure technology stacks and node descriptions.

For more information about roles and profiles, see [the Puppet Enterprise documentation](/pe/latest/puppet_assign_configurations.html#assigning-configuration-data-with-role-and-profile-modules).

### scope

The **scope** refers to an area of [Puppet code](#puppet-language) where a [variable](#variable) has a given value.

[Class](#class) [definitions](#define) and [type](#type) definitions create local scopes. Variables declared in a local scope are available by their short name, such as `$my_variable`, inside the scope, but are hidden from other scopes unless you refer to them by their fully qualified name (such as `$my_class::my_variable`).

Variables outside any definition (or set by an [external node classifier](#external-node-classifier)) exist at a special **top scope;** they are available everywhere by their short names (`$my_variable`) but can be overridden in a local scope if that scope assigns a variable of the same name.

[Node definitions](#node-definition) create a special **node scope.** Variables in this scope are also available everywhere by their short names, and can override top-scope variables.

> **Note:** Previously, Puppet used dynamic scope, which would search for short-named variables through a long chain of parent scopes. This was deprecated in version 2.7 and will be removed in the next version. For more information, see [Scope and Puppet](/guides/scope_and_puppet.html).

### singleton

A **singleton** is an object in the [Puppet language][], such as a [class](#class), that can only be evaluated once. For example, you can't have more than one distinct class with the same specific [name](#namevar) in a [manifest](#manifest) or [catalog](#catalog), making that class a singleton.

### site

A **site** refers to an entire IT ecosystem that is managed by Puppet. A site includes all Puppet [master](#master) servers, [agent nodes](#agent), and independent masterless Puppet [nodes](#node) within an organization.

### site manifest

The main "point of entry" [manifest](#manifest) used by a Puppet [master](#master) when compiling a [catalog](#catalog). The location of this manifest is set with the `manifest` setting in [`puppet.conf`](/puppet/latest/reference/config_file_main.html). Its default value is usually `/etc/puppetlabs/puppet/manifests/site.pp` or `/etc/puppet/manifests/site.pp`.

The site manifest usually contains [node definitions](#node-definition). When an [external node classifier](#external-node-classifier) (ENC) is being used, the site manifest might be nearly empty, depending on whether the ENC was designed to have complete or partial [node](#node) information.

### site module

A **site module** is a common Puppet idiom in which one or more [modules](#module) contain [classes](#class) specific to a given Puppet [site](#site). These classes usually describe complete configurations for a specific system or group of systems. For example, the `site::db_slave` class might describe the entire configuration of a database server, and a new database server could be configured simply by applying that class to it.

### subclass

A **subclass** is a [class](#class) that inherits from another class. See [inheritance](#inheritance-class).

### subscribe

A notification [relationship](#relationship) set with the `subscribe` [metaparameter](#metaparameter), or the wavy [chaining arrow](#chaining-arrow) (`~>`), is referred to as **subscribing**. For more information, see [Relationships and Ordering][] in the [Puppet language][] reference.

### template

A **template** is a partial document that is filled in with data from [variables](#variable). Puppet can use Embedded Puppet (EPP) or Embedded Ruby (ERB) templates to generate configuration files tailored to an individual system. For more information, see [Language: Using Templates](/puppet/latest/reference/lang_template.html).

### title

The unique identifier in a given Puppet [catalog](#catalog) of a [resource](#resource) or [class](#class) is its **title**.

* In a class, the title is simply the class's name.
* In a resource [declaration](#declare), the title is the part after the first curly brace and before the colon; in the example below, the title is `/etc/passwd`:

~~~ ruby
file  { '/etc/passwd':
  owner => 'root',
  group => 'root',
}
~~~

* In native resource types, the [name or namevar](#namevar) uses the title as its default value if you don't explicitly specify a name.
* In a [defined type](#type-defined) or a class, the title is available for use throughout the [definition](#define) as the `$title` [variable](#variable).

Unlike the name or namevar, a resource's title doesn't need to map to any [attribute](#attribute) of the target system; it is only a referent. You can give a resource a single title even if its name must vary across different kinds of systems, like a configuration file whose location differs on Solaris.

For more information on resource titles, see [the Resources page](/puppet/latest/reference/lang_resources.html#syntax) in the [Puppet language][] reference.

### top scope

See [scope](#scope).

### type

A kind of [resource](#resource) that Puppet is able to manage; for example, `file`, `cron`, and `service` are all resource types. A type specifies the set of attributes that a resource of that type may use, and models the behavior of that kind of resource on the target system. You can declare many resources of a given type.

Puppet ships with a set of built-in resource types; see the [type reference](/references/stable/type.html) for a complete list of them. New [native types](#type-native) can be added as [plugins](#plugin), and [defined types](#type-defined) can be constructed by grouping together resources of existing types.

### type (defined)

(or **defined type**, or **defined resource type;** sometimes called a **define** or **definition**)

A **defined type** is a [resource type](#type) implemented as a group of other [resources](#resource), written in the [Puppet language][] and saved in a [manifest](#manifest). For example, a defined type could use a combination of `file` and `exec` resources to configure and populate a Git repository. Once a type is [defined](#define), new resources of that type can be [declared](#declare) just like any native or custom resource.

Since defined types are written in the Puppet language instead of as Ruby plugins, they are analogous to macros in other languages. Contrast with [native types](#type-native). For more information, see [the Learning Puppet chapter on defined types](/learning/definedtypes.html).

### type (native)

(or **native type**)

A [resource](#resource) type written in Ruby. Puppet ships with a large set of built-in native types, and custom native types can be distributed as [plugins](#plugin) in [modules](#module). For a complete list of built-in types, see the [type reference](/references/stable/type.html).

Native types have lower-level access to the target system than [defined types](#type-defined) and can use the system's own tools to make changes. Most native types have one or more [providers](#provider) that can implement the same resources on different kinds of systems.

### variable

A **variable** is a named placeholder in a [manifest](#manifest) that represents a value. Variables in Puppet are indicated with a dollar sign (`$operatingsystem`) and assigned with the equals sign (`$myvariable = "something"`). Once assigned, variables cannot be reassigned within the same [scope](#scope); however, other local scopes can assign their own value to any variable name.

[Facts](#fact) from [agents](#agent) are represented as variables within Puppet manifests, and are automatically pre-assigned before compilation begins. There are also [several other special pre-assigned variables](/puppet/latest/reference/lang_facts_and_builtin_vars.html).

### variable scoping

See [scope](#scope).

### virtual resource

A **virtual resource** is a [resource](#resource) that is [declared](#declare) in the [catalog](#catalog) but isn't be applied to a system unless it is explicitly [realized](#realize).

For more information, see [Virtual Resources](/guides/virtual_resources.html).

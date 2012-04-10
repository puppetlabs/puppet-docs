---
title: Glossary
layout: default
---

# Glossary of Puppet Vocabulary

An accurate, shared vocabulary goes a long way to ensure the success of a project. To that end, this glossary defines the most common terms Puppet users rely on.

**attribute**
:   Attributes are used to specify the state desired for a given configuration resource. As in other languages, attributes have a defined set of possible values. For example, a configuration might require a resource such as `vim.` The `vim` package could have an attribute `ensure` with a value of `present`.

**agent** or  **agent node**
:   Puppet is usually deployed using a simple client-server model. The Puppet client (installed on an operating system instance, see "host") is known as the "agent." This can be an operating system running on its own hardware (collectively, the server) or a virtual server image. Often shortened to just "node."

**catalog**
:   A catalog is a compilation of all the resources (files, properties, configurations, and the relationships between them) that will be applied to a given agent.

**class**
:   A fundamental Puppet concept, "classes" are used to define a collection of related resources. For example, a class could be defined that contains all of the elements (files, settings, modules, scripts, etc) needed to configure Apache on a host. A class can inherit from another class using the `inherits` keyword. A class can also declare other classes. A class can be included multiple times on a given node, but it will only be evaluated once. (See also `defined type`.)

**declare**
:   "Declare" directs Puppet to include a class or a resource in a given configuration. To add classes, use the `include` keyword or the `class {"foo":}` syntax. To add resources,  use the lowercase `file {"/tmp/bar":}` syntax.

**define**
:   To specify the contents and/or behavior of a class or a defined resource type. Sometimes, define is used as shorthand for "defined resource type".

**define (keyword)**
The language keyword used to create a <a id="defined type">defined type </a>


**environment**
:   Puppet lets you seperate your <a id="site">site</a> into distinct environments, each of which can be served a different set of modules. For example, environments can be used to set up scratch nodes for testing before roll-out, or to divide a site by types of hardware.

**expression**
:   The Puppet language supports several types of expressions for comparison and evaluation purposes. Amongst others, Puppet supports boolean expressions, comparision expressions, arithmetic expressions. See the [Language Guide](http://docs.puppetlabs.com/guides/language_guide.html#expressions) for more information.

**External Node Classifier (ENC)**
An ENC provides an alternate method to using the main site manifest (`site.pp`) to classify nodes. An ENC lets you use a pre-existing data source (such as an LDAP db) to classify nodes. Specifically, an ENC is an executable that has only one argument: the name of the node to be classified. When called by the Puppet master, an ENC returns a YAML document describing the node. See [External Nodes](http://docs.puppetlabs.com/guides/external_nodes.html) for more information.

**fact**
:   A fact is a detail or property returned by <a id="Facter">Facter</a> that describes the configuration of an agent, such as hostname or IP address. Facts are expressed as a key=>value pair (e.g. `operating system => Ubuntu`).Facts function as global variables.  If there are site-specific details not covered by existing facts, you can create custom facts by writing a snippet of Ruby code and adding it to Facter (see [[http://docs.puppetlabs.com/guides/custom_facts.html]]). 

**Facter**
:   Facter is Puppet's system inventory tool. Facter returns <a id="fact">"facts"</a> about each connected agent, such as the agent's hostname, IP address, operating system, etc. These facts are sent to the master, where they are automatically created as variables which can be used to manage the host. While Facter contains a wealth of information about common hosts, applications and services, you can also create custom facts specific to your environment. For more information, see the [Facter home page](http://puppetlabs.com/puppet/related-projects/facter/).

**filebucket**
:   A "filebucket" is a repository for containing file backups. A filebucket can be either host- or site-global. Typically, a single filebucket is defined for a whole network and is used as the default backup location. See [type: filebucket](http://docs.puppetlabs.com/references/stable/type.html#filebucket) for more information. 

**function**
:   Functions are commands that run on the Puppet master and perform various actions. Functions cannot be run on the client, they only run on the master. Consequently, functions can only operate using resources available on the master. Common functions include `generate`, `notice`, and `include`. You can choose from the [list of available functions](http://docs.puppetlabs.com/references/stable/function.html) or you can write our own custom functions (see the [Writing Your Own Functions page](http://docs.puppetlabs.com/guides/custom_functions.html))

**host**
:   An instance of an operating system with the Puppet client installed. This can be an operating system running on its own hardware (collectively, the server) or a virtual server image. See also <a id="agent">"Agent Node"</a>.

**Idempotent**
:   Idempotence refers to the ability of Puppet's transaction layer to repeatedly apply a configuration to a host. A configuration can be said to be idempotent when it can be safely run multiple times with the same outcome on the host. 

**inheritance (class)**
:  <!-- 
 Class inheritance in Puppet works differently than it traditionally does in other languages. Because Puppet is declarative, a given resource can only be declared once. This means a child class will replace the parent class.  
Puppet uses  "single inheritance," which means that a class can inherit from one and only one other class.
 -->

**inheritance (node)**
:   foo. 

**master**
:   In a standard Puppet client-server deployment, the server is known as the Master. The Master runs as a daemon on the host server and provides the configuration data for your environment to the Puppet <a id="agent">Agents</a> running on the clients.

**manifest**
:   A "manifest" is a configuration file written in the Puppet language. Manifest files use the .pp suffix (e.g. `site.pp`). By default, manifest files are stored in `etc/puppet/manifests`. Puppet manifests consist of the following major components:
 <a id="resource">Resources</a>
Files
<a id="template">Templates</a>
<a id="node">Nodes</a>
<a id="class">Classes</a>
<a id="defined resource type">Definitions</a>

**metaparameter**
:   A metaparameter is a resource attribute that is part of Puppet's framework rather than part of the implementation of a specific instance. Metaparameters perform actions on resources and can be specified for any type of resource. For examples of metaparameters and their usage, see the [Metaparameter Reference](http://docs.puppetlabs.com/references/stable/metaparameter.html)

**module**
:   A collection of classes, resource types, files, and templates, organized around a particular purpose. For example, a module could be used to completely configure an Apache instance or to set-up a Rails application. There are many pre-built modules available for download in the [Puppet Forge](http://forge.puppetlabs.com/). For more information see [Module Organisation](http://docs.puppetlabs.com/guides/modules.html).

**namevar**
:   The "name variable" or "namevar" is an attribute of a resource used to determine the name of that resource. Typically, namevar is not specified since it is synonomous with the title of the resource. However, in some cases (such as when referring to a file whose location varies), it is useful to specify namevar as a kind of short-hand.  

**node (definition)**
:   A manifest component consisting of a collection of classes and/or resources to be applied to an agent node. The target agent node is specified with a unique identifier ("certname") that matches the specified node name. Nodes defined in manifests allow inheritance, although this should be used with care due to the behavior of dynamic variable scoping. Sometimes called a "node statement."

**node scope**
When nodes are defined in manifests (either directly or via a regular expression), they create their own local scope. Variables declared in this local "node scope" will override top-scope variables. (Note that <a id="External Node Classifier">ENCs</a> assign variables at top scope, and do not introduce node scopes.)

**noop**
:   Noop mode (short for "No Operations" mode) lets you simulate your configuration without making any actual changes. Basically, noop allows you to do a dry run with all logging working normally, but with no effect on any hosts. To run in noop mode, add the argument `--noop` to `puppet agent` or `puppet apply`.

**parameter** (custom type and provider development)
:   A value which does not call a method on a provider. Eventually expressed as an attribute in instances of this resource type. See [Custom Types](http://docs.puppetlabs.com/guides/custom_types.html).

**parameter** (defined types and parameterized classes)
:   Parameters let you declare resource or class attributes more easily than setting variables by wrangling scope.  Parameters can be passed to classes or instances of this resource type upon declaration. Parameters are expressed as resource or class attributes. 

**parameter** (external nodes)
:   (see other definitions of "parameter").

**parameter**
Generally speaking, a parameter refers to information that a class or resource can accept. More specifically, there are three areas in Puppet where the concept of parameters is used:
1. When developing a custom type, parameters provide the same function as properties except they never result in methods being called on providers. 
2. When writing a parameterized class, parameters describe all the variables found within the outer scope of the class being parameterized.
3. In the case of External Node Classifiers, a parameter can be thought of as a global variable set by an <a id="external node classifier">external node classifier</a>. Although these are called "parameters," they are just normal variables; the name refers to the fact that they are usually used to configure the behavior of classes 

**pattern**
:   A colloquial community expression sometimes used to describe a collection of related manifests which are designed to solve an issue or manage a particular configuration item, as in, an Apache pattern.

**plusignment operator**
:   An operator that allows you to add values to resource parameters using the +> ('plusignment') syntax. Useful when you need to over-ride resource parameters without having to respecify already declared values.

**property** (custom type and provider development)
:   Properties define how a resource really works. When retrieving the state of a resource, a property will call the specified method on the provider. Properties will appear as attributes to the user when working with instances of this resource type. See [Custom Types](http://docs.puppetlabs.com/guides/custom_types.html).

**provider**
:   "Providers" implement types by providing the information needed to manage resources. For example, for package types, there are providers that cover tools such as `yum, dpkg,` and `ports.` Similarly, for user types there are providers for `useradd` and `netinfo.`  Typically, providers are simple Ruby wrappers around shell commands, so they are usually  short and easy to create.

**plugin**
: See <a id="type(plugin)">type (plugin)</a>

**realize**
:  in Puppet terms, a resource is "realized" when it has been declared and subsequently instantiated. Once a resource has been declared, there are two methods for "realizing" it: 

1. use the "spaceship" syntax `<||>`
2. Use the `realize` function

A virtually declared resource will not be managed until it is realized.

**resource**
:   broadly speaking, a "resource" is a defined configuration item. Resources are made up of a _type_ (the sort of resource being managed: packages, services, etc.), a _title_ (the name of the resource), and one or more _attributes_ (values specifying the state of the resource: running, present, etc.)
Resources do not always directly map to simple details on the client -- they might sometimes involve spreading information across multiple files, or even involve modifying devices.

**resource specification**
:   A resource specification details how to manage a resource as specified in Puppet code. This term helps to differentiate between the literal resource on disk and the specification for how to manage that resource. However, most often, these are just referred to as "resources".

**scope**
:   As elsewhere, "scope" in Puppet refers to the context in which a variable's identifier (e.g. its name) is valid and usable. Prior to Puppet 2.7, scope in Puppet and Puppet Enterprise was dynamic. Starting with 2.7, dynamic scope is being deprecated (similar functionality can be obtained by using parameterized classes). From 2.7 and later, scope in Puppet is closer to lexical scope insofar as Puppet will only examine local scope and top scope when resolving an unqualified variable. This means that, in effect, all variables are either strictly local or strictly global. For more information, see [Scope and Puppet](http://docs.puppetlabs.com/guides/scope_and_puppet.html).

**site**
:   In Puppet, "site" refers to the entire IT ecosystem being managed by Puppet . That is, a site includes all the Masters and all the Clients they manage.

**subclass**
:   a class that inherits from another class. Subclasses are useful for expanding one logical group of resources into another similar or related group of resources. Subclasses are also useful to override values of resources. For instance, a base class might specify a particular file be placed on the server as a configuration file. But a subclass might override that source file parameter to specify an alternate file. 

A subclass is created by using the keyword `inherits`:

    class ClassB inherits ClassA { ... }

**template**
:   templates are used to generate configuration files for systems. They are written as Ruby ERB files and are used in cases where the configuration file is not entirely static but requires only minor changes based on variables that Puppet can provide (such as hostname).

**template class**
:   template classes define commonly used server types inherited by individual nodes. For example, a well designed Puppet implementation would likely define a baseclass template, which includes only the most basic configuration required on all servers at the organization. Similarly, an implementation might have a generic webserver template, which would include modules for apache and locally manageable apache configurations for web administrators.

Template classes can take parameters by setting them in the node or main scope. The advantage of this is that the values are already available, regardless of the number of times and places where a class is included:

    node mywebserver {
        $web_fqdn = 'www.example.com'
        include singledomainwebserver
    }

This structure maps directly to a [[External Nodes|external node classifier]] which makes it easy to transition to an ENC if required.

**title**
:   There are three Puppet entities that make use of titles: Resources, Classes and Defined Types. In each case, the title is the main unique identifier and need not be declared explicitly since it is provided automatically in the declaration of the resource path. For example, say we describe a file resource as follows:

	file  {   '/etc/passwd' :
		owner => 'root',
		group => 'root',
	}
	
The title of the resource is simply the field that precedes the colon (/etc/passwd). Unless it is declared explicitly, the name attribute will default to this. 

If not explicitly declared, the "name" attribute will take the value of the title. Unlike "name," a title need not map to any actual attribute of the target system, it is only a referent.  
For more on the usage of titles, see the [language guide](http://docs.puppetlabs.com/guides/language_guide.html).

**type**
:   An abstract description of a particular kind of resource. Can be implemented as a native type, plug-in type, or defined type. For example the `cron` type can be used to manage and install cron jobs on nodes. See [type reference](http://docs.puppetlabs.com/references/stable/type.html) for a complete list of the types Puppet can manage is available online.

 **type (defined)** aka **defined resource type** (previously known as: **definition**)
:   Defined types are user-created definitions of groups of resources (as opposed to the native types that are included with Puppet. See below.). They are written in the Puppet language and are analogous to macros in some other languages. A defined resource type allows you to group basic resources into a "super resource" which you can use to model a logical chunk of configuration. For example, you could use a defined resource type to perform all the steps needed to set up and populate a Git repository.
Contrast with **native type.** For more information, see [Defined Types](http://docs.puppetlabs.com/learning/definedtypes.html)

**type (native)**
:   A built-in type written purely in Ruby and distributed with Puppet. Additional native types can extend Puppet, and can be distributed to agent nodes via the pluginsync system. For more information, see the [list of native types](http://docs.puppetlabs.com/references/2.7.0/type.html).

**type (plug-in)** aka **plugin**
:   a Puppet term for custom types created for Puppet at the Ruby level. These types are written entirely in Ruby and must correspond to the Puppet standards for custom-types.

**variable**
:   variables in Puppet are similar to variables in other programming languages. Variables in configuration statements are indicated with the dollar sign (e..g `$operatingsystem`) Once assigned, variables cannot be reassigned within the same scope. However, within a sub-scope a new assignment can be made for a variable name for that sub-scope and any further scopes created within it:

    $myvariable = "something"

Note that there are certain seemingly built-in variables, such as $hostname. These variables are actually created by Facter. Any fact presented by Facter is automatically available as a variable for use in Puppet.

**variable scoping**
:  See [scope](#scope) above.

**virtual resource**
:   a resource that is defined but will not be added to a system's catalog unless it is explicitly realized. See also [realize](#realize).
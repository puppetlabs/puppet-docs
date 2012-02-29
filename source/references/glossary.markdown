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
:   "Define" is used to specify the contents and behavior of a class or a defined resource type. 

**defined resource type** or **defined type** (older usage: **definition**)
:   Defined types are created using the Puppet language and are analogous to macros in some other languages. A defined resource type allows you to group basic resources into a "super resource" which you can use to model a logical chunk of configuration resources. For example, you could use a defined resource type to perform all the steps needed to set up and populate a Git repository.
Contrast with **native type.** For more information, see [Defined Types](http://docs.puppetlabs.com/learning/definedtypes.html)

**environment**
:   Puppet lets you seperate your <a id="site>site</a> into distinct environments, each of which can be served a different set of modules. For example, environments can be used to set up scratch nodes for testing before roll-out, or to divide a site by types of hardware.

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
:   foo.

**manifest**
:   A configuration file written in the Puppet language. These files should have the .pp extension.

**metaparameter**
:   foo.

**module**
:   A collection of classes, resource types, files, and templates, organized around a particular purpose. See also [[Module Organisation]].

**namevar**
:   foo. 

**native type**
:   A type written purely in Ruby and distributed with Puppet. Puppet can be extended with additional native types, which can be distributed to agent nodes via the pluginsync system. See the documentation for list of native types.


**node (definition)**
:   A manifest component consisting of a collection of classes and/or resources to be applied to an agent node. The target agent node is specified with a unique identifier ("certname") that matches the specified node name. Nodes defined in manifests allow inheritance, although this should be used with care due to the behavior of dynamic variable scoping. 

**noop**
:   Noop mode (short for "No Operations" mode) lets you simulate your configuration without making any actual changes. Basically, noop allows you to do a dry run with all logging working normally, but with no effect on any hosts. To run in noop mode, add the argument `--noop` to `puppet agent` or `apply`.

**parameter** (custom type and provider development)
:   A value which does not call a method on a provider. Eventually exposed as an attribute in instances of this resource type. See [Custom Types](http://docs.puppetlabs.com/guides/custom_types.html).

**parameter** (defined types and parameterized classes)
:   One of the values which can be passed to this class or instances of this resource type upon declaration. Parameters are exposed as resource or class attributes. 

**parameter** (external nodes)
: A global variable returned by the external node classifier.

**pattern**
:   An ocassionally used colloquial community expression for a collection of manifests designed to solve an issue or manage a particular configuration item, for example an Apache pattern.

**plugin, plugin types**
:   a Puppet term for custom types created for Puppet at the Ruby level. These types are written entirely in Ruby and must correspond to the Puppet standards for custom-types.

**plusignment operator**
:   An operator that allows you to add values to resource parameters using the +> ('plusignment') syntax:

    class apache {
        service { "apache": require => Package["httpd"] }
    }
        
    class apache-ssl inherits apache {
        # host certificate is required for SSL to function
        Service[apache] { require +> File["apache.pem"] }
    }

**property** (custom type and provider development)
:   A value which calls a method on a provider. Eventually exposed as an attribute in instances of this resource type. See [Custom Types](http://docs.puppetlabs.com/guides/custom_types.html).

**provider**
:   A simple implementation of a type; examples of package providers are dpkg and rpm, and examples of user providers are useradd and netinfo. Most often, providers are just Ruby wrappers around shell commands, and they are usually very short and thus easy to create.

**realize**
:   a Puppet term meaning to declare a virtual resource should be part of a system's catalog. See also virtual resources.

**resource**
:   an instantiation of a native type, plugin type, or definition such as a user, file, or package. Resources do not always directly map to simple details on the client -- they might sometimes involve spreading information across multiple files, or even involve modifying devices.

**resource object**
:   A Puppet object in memory meant to manage a resource on disk. Resource specifications get converted to these, and then they are used to perform any necessary work.

**resource specification**
:   The details of how to manage a resource as specified in Puppet code. When speaking about resources, it is sometimes important to differentiate between the literal resource on disk and the specification for how to manage that resource; most often, these are just referred to as resources.

**REST**
:   foo. 

**scope**
:   foo.

**site**
:   In Puppet, "site" refers to the entire IT ecosystem being managed by Puppet . That is, a site includes all the Masters and all the Clients they manage.

**statement**
:   foo. 

**subclass**
:   a class that inherits from another class. Subclasses are useful for expanding one logical group of resources into another similar or related group of resources. Subclasses are also useful to override values of resources. For instance, a base class might specify a particular file as the source of a configuration file to be placed on the server, but a subclass might override that source file parameter to specify an alternate file to be used. A subclass is created by using the keyword inherits:

    class ClassB inherits ClassA { ... }

**template**
:   templates are ERB files used to generate configuration files for systems and are used in cases where the configuration file is not static but only requires minor changes based on variables that Puppet can provide (such as hostname). See also distributable file.

**template class**
:   template classes define commonly used server types which individual nodes inherit. A well designed Puppet implementation would likely define a baseclass, which includes only the most basic of modules required on all servers at the organization. One might also have a genericwebserver template, which would include modules for apache and locally manageable apache configurations for web administrators:

    node mywebserver {
        include genericwebserver
    }

Template classes can take parameters by setting them in the node or main scope. This has the advantage, that the values are already available, regardless of the number of times and places where a class is included:

    node mywebserver {
        $web_fqdn = 'www.example.com'
        include singledomainwebserver
    }

This structure maps directly to a [[External Nodes|external node classifier]] and thus enables a easy transition.

**title**
:   foo. 

**type**
:   abstract description of a type of resource. Can be implemented as a native type, plug-in type, or defined type. The [complete list](http://docs.puppetlabs.com/references/stable/type.html) of the types Puppet can manage is available online.

**variable**
:   variables in Puppet are similar to variables in other programming languages. Once assigned, variables cannot be reassigned within the same scope. However, within a sub-scope a new assignment can be made for a variable name for that sub-scope and any further scopes created within it:

    $myvariable = "something"

Note that there are certain seemingly built-in variables, such as $hostname. These variables are actually created by Facter. Any fact presented by Facter is automatically available as a variable for use in Puppet.

**variable scoping**
:  foo.

**virtual resource**
:   a Puppet term for an resource that is defined but will not be made part of a system's catalog unless it is explicitly realized. See also realize.

**version control system (VCS)**
:   foo. 
---
title: Glossary
layout: default
---

# Glossary of Puppet Vocabulary

An accurate, shared vocabulary goes a long way to ensure the success of a project. To that end, this glossary defines the most common terms Puppet users rely on.

**attribute**
:   foo.

**agent**
:   foo.

**catalog**
:   A catalog is a compilation of all the resources (files, properties, configurations, and the relationships between them) for a given agent.

**class**
:   A native Puppet construct that defines a container of resources, such as File resources, Package resources, User resources, custom-defined resources (see also defined type), etc. A class can inherit from another class using the `inherits` keyword, and can also declare other classes.

**agent** or **agent node**
:   An operating system instance managed by Puppet. This can be an operating system running on its own hardware (collectively, the server) or a virtual server image. Often shortened to just "node."

**class**
:   foo. 

**declare**
:   To state that a class or a resource should be included in a given configuration. Classes are declared with the `include` keyword or with the `class {"foo":}` syntax; resources are declared with the lowercase `file {"/tmp/bar":}` syntax.

**define**
:   To specify the contents and behavior of a class or defined resource type. 

**defined resource type** or **defined type** (older usage: **definition**)
:   A Puppet resource type defined at the application level. Defined types are created in the Puppet language and are analogous to macros in some other languages. Contrast with **native type.**

**expression**
:   foo. 

**filebucket**
:   foo. 

**fact**
:   A detail or property returned by Facter. Facter has many built-in details that it reports about the machine it runs on, such as hostname. Additional facts can easily be returned by Facter (see [[Adding Facts]]). Facts are exposed to your Puppet manifests as global variables. 

**Facter**
:   foo. 

**filebucket**
:   foo. 

**function**
:   foo.

**host**
:   foo. 

**Idempotent**
:   Idempotence refers to the ability of Puppet's transaction layer to repeatedly apply a configuration to a host. 

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
:   foo.

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

**scope**
:   foo.

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
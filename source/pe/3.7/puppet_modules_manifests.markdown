---
layout: default
title: "PE 3.7 » Puppet » Modules and Manifests"
subtitle: "Puppet Modules and Manifests"
canonical: "/pe/latest/puppet_modules_manifests.html"
---

[assign]: ./puppet_assign_configurations.html
[lang]: /puppet/3.7/reference/lang_summary.html
[visual]: /puppet/3.7/reference/lang_visual_index.html
[resources]: /puppet/3.7/reference/lang_resources.html
[cond]: /puppet/3.7/reference/lang_conditional.html
[variables]: /puppet/3.7/reference/lang_variables.html
[facts]: /puppet/3.7/reference/lang_variables.html#facts-and-built-in-variables
[rel]: /puppet/3.7/reference/lang_relationships.html
[classes]: /puppet/3.7/reference/lang_classes.html
[defined]: /puppet/3.7/reference/lang_defined_types.html
[fund]: /puppet/3.7/reference/modules_fundamentals.html
[install]: /puppet/3.7/reference/modules_installing.html
[forge]: http://forge.puppetlabs.com
[geppetto]: /geppetto/4.0/index.html


Summary
-----

Puppet uses its own domain-specific language (DSL) to describe machine configurations. Code in this language is saved in files called _manifests._

Puppet works best when you isolate re-usable chunks of code into their own modules, then compose those chunks into more complete configurations.

This page covers the first part of that process: writing manifests and modules. For information on composing modules into complete configurations, see [the Assigning Configurations to Nodes page][assign] of this manual.

> Other References
> -----
>
> This page consists mostly of small examples and links to detailed information. If you want more complete context, you should read some of the following documents instead:
>
> ### Learning the Puppet Language
>
> **If you are new to Puppet, start here.** For a complete introduction to the Puppet language, read and follow along with the Learning Puppet series, which will introduce you to the basic concepts and then teach advanced class writing and module construction.
>
> * [Learning Puppet](/learning/)
>
> ### Quick Start
>
> For those who learn by doing, the PE user's guide includes a pair of interactive quick start guides, which walk you through installing, using, hacking, and creating Puppet modules.
>
> * [Quick Start: Using PE](./quick_start.html)
> * [Quick Start: Writing Modules](./quick_writing_nix.html)
>
> ### Modules in Context
>
> The Puppet Enterprise Deployment Guide includes detailed walkthroughs of how to choose modules and compose them into complete configurations.
>
> * [Deployment Guide ch. 3: Automating Your Infrastructure](/guides/deployment_guide/dg_define_infrastructure.html)
>
> ### Geppetto IDE
>
> Geppetto is an integrated development environment (IDE) for Puppet. It provides a toolset for developing Puppet modules and manifests that includes syntax highlighting, content assistance, error tracing/debugging, and code completion features. Geppetto also provides integration with git, enabling side-by-side comparison of code from a given repo complete with highlighting, code validation, syntax error parsing, and expression troubleshooting. 
>
>In addition, Geppetto provides tools that integrate with Puppet products. It includes an interface to the Puppet Forge, which allows you to create modules from existing modules on the Forge as well as easily upload your custom modules. 
> Geppetto also provides PE integration by parsing PuppetDB error reporting. This allows you to quickly find the problems with your Puppet code that are causing configuration failures. For complete information, visit the [Geppetto documentation][geppetto].
>
>
> ### Printable References
>
> These two cheat sheets are useful when writing your own modules or hacking existing modules.
>
> * [Module Layout Cheat Sheet](/module_cheat_sheet.pdf)
> * [Core Resource Type Cheat Sheet](/puppet_core_types_cheatsheet.pdf)



The Puppet Language
-----

Puppet configurations are written in the Puppet language, a DSL built to declaratively model resources.

> * For complete information about the Puppet language, [see the Puppet 3 Language Reference][lang].
> * To identify unfamiliar syntax, [see the visual index to the Puppet language][visual].

### Manifests

Manifests are files containing Puppet code. They are standard text files saved with the `.pp` extension. Most manifests should be arranged into [modules](#puppet-modules).

### Resources

The core of the Puppet language is declaring **resources.** A resource declaration looks like this:

{% highlight ruby %}
    # A resource declaration:
    file { '/etc/passwd':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }
{% endhighlight %}

When a resource depends on another resource, you should explicitly state the relationship to make sure they happen in the right order.

* See [the Resources page of the Puppet language reference][resources] for details about resource declarations.
* See [the Relationships and Ordering page][rel] for details about relationships.

>### About Manifest Ordering 
>
>Puppet Enterprise is now using a new `ordering` setting in the Puppet core that allows you to configure how unrelated resources should be ordered when applying a catalog. By default, `ordering` will be set to `manifest` in PE. 
>
>You most likely expect that resources will be executed in the order you wrote them in your manifest files—if there were no dependencies specified. If you’re an experienced user and have been using this kind of explicit ordering in your codebase, you'll be able to use manifest ordering without any problems.
>
>We know that for new PE users learning the Puppet language, one of the first stumbling blocks is figuring out how to order resources so they’re evaluated correctly when Puppet runs. We anticipate that manifest ordering will help mitigate your struggles and help get you writing more effective Puppet code. And as you’re learning, we definitely recommend you study up on [relationships and ordering in Puppet](/puppet/3.7/reference/lang_relationships.html). 
>
>The following values are allowed for the `ordering` setting:
>
>* `manifest`: (default) uses the order in which the resources were declared in their manifest files.
>* `title-hash`: orders resources randomly, but will use the same order across runs and across nodes.
>* `random`: orders resources randomly and change their order with each run. This can work like a fuzzer for shaking out undeclared dependencies.
>
>Regardless of this setting's value, Puppet will always obey explicit dependencies set with the `before`/`require`/`notify`/`subscribe` metaparameters and the `->`/`~>` chaining arrows; this setting only affects the relative ordering of *unrelated* resources.
>
>#### Changing the Resource Ordering Setting
>
>By default, the `ordering` setting is configured for `manifest` ordering, but you will not see this displayed in `puppet.conf` (located at `/etc/puppetlabs/puppet/puppet.conf` on the Puppet master). 
>
>To toggle the setting to `random` or `title-hash`, you will need to add it to the `agent` section; for example:
>
>     [agent]
>         ordering = title-hash
>         enviroment = production
>         ...
>         ...

### Conditional Logic, Variables, and Facts

Puppet manifests can dynamically adjust their behavior based on variables. Puppet includes a set of useful pre-set variables called **facts** that contain system profiling data.

{% highlight ruby %}
    # Set the name of the Apache package based on OS
    case $operatingsystem {
      centos, redhat: { $apache = "httpd" }
      debian, ubuntu: { $apache = "apache2" }
      default: { fail("Unrecognized operating system for webserver") }
    }
    package {$apache:
      ensure => installed,
    }
{% endhighlight %}

* See the [Variables][] page (and the [Facts][] subsection) of the Puppet language reference for information on variables.
* See the [Conditional Statements][cond] page for information on if, case, and selector statements.

### Classes and Defined Types

Groups of resource declarations and conditional statements can be wrapped up into a **class:**

{% highlight ruby %}
    class ntp {
      package { 'ntp':
        ensure => installed,
      }
      file { 'ntp.conf':
        path    => '/etc/ntp.conf',
        ensure  => file,
        require => Package['ntp'],
        source  => "puppet:///modules/ntp/ntp.conf"
      }
      service { 'ntp':
        name      => ntpd
        ensure    => running,
        enable    => true,
        subscribe => File['ntp.conf'],
      }
    }
{% endhighlight %}

Classes are named blocks of Puppet code that can be assigned to nodes. They should be stored in modules so that the Puppet master can locate them by name.

**Defined resources** (i.e., defined resource types) extend the capability of classes and are stored in the module structure. They cannot be assigned directly to nodes but can enable you to build much more sophisticated classes.

* See [the Classes page of the Puppet language reference][classes] for details about defining and declaring classes.
* See [the Defined Types page][defined] for details about defined resource types.

Puppet Modules
-----

**Modules** are a convention for arranging Puppet manifests so that they can be automatically located and loaded by the Puppet master. They can also contain plugins, static files for nodes to download, and templates.

Modules can contain many Puppet classes. Generally, the classes in a given module are all somewhat related. (For example, an `apache` module might have a class that installs and enables Apache, a class that enables PHP with Apache, a class that turns on `mod_rewrite`, etc.)

A module is:

* A directory...
* ...with a specific internal layout...
* ...which is located in one of the Puppet master's **modulepath** directories.

In Puppet Enterprise, the main modulepath directory for users is located at `/etc/puppetlabs/puppet/modules` on the Puppet master server.

### Module Structure

This example module, named "`my_module`," shows the standard module layout:

* `my_module/` --- This outermost directory's name matches the name of the module.
    * `manifests/` --- Contains all of the manifests in the module.
        * `init.pp` --- Contains one class named **`my_module`.** **This class's name must match the module's name.**
        * `other_class.pp` --- Contains one class named **`my_module::other_class`.**
        * `my_defined_type.pp` --- Contains one defined type named **`my_module::my_defined_type`.**
        * `implementation/` --- This directory's name affects the class names beneath it.
            * `foo.pp` --- Contains a class named **`my_module::implementation::foo`.**
            * `bar.pp` --- Contains a class named **`my_module::implementation::bar`.**
    * `files/` --- Contains static files, which managed nodes can download.
        * `service.conf` --- This file's URL would be **`puppet:///modules/my_module/service.conf`.**
    * `lib/` --- Contains plugins, like custom facts and custom resource types.
    * `templates/` --- Contains templates, which the module's manifests can use.
        * `component.erb` --- A manifest can render this template with `template('my_module/component.erb')`.
    * `tests/` --- Contains examples showing how to declare the module's classes and defined types.
        * `init.pp`
        * `other_class.pp` --- Each class or type should have an example in the tests directory.
    * `spec/` --- Contains spec tests for any plugins in the lib directory.

* See [the Module Fundamentals page of the Puppet 3 reference manual][fund] for details about module layout and location.

### Downloading Modules

You can search for pre-built modules on [the Puppet Forge][forge] and use them in your own infrastructure.

* Use the `puppet module search` command to locate modules, or [browse the Puppet Forge's web interface][forge].
* Along with the standard modules you can find on the Forge, Puppet Labs also provides Puppet Enterprise supported modules; these supported modules are rigorously tested with PE, supported via the usual [support channels](http://puppetlabs.com/services/customer-support), maintained for a long-term lifecycle, and are compatible with multiple platforms and architectures. 
* On your Puppet master server, use the `puppet module install` command to install modules from the Forge.
* See [the Installing Modules page][install] for details about installing pre-built modules.


Catalogs and Compilation
-----

In standard master/agent Puppet, agents never see the manifests and modules that comprise their configuration. Instead, the Puppet master **compiles** the manifests down into a document called a **catalog,** and serves the catalog to the agent node.

As mentioned above, manifests can contain conditional logic, as well as things like templates and functions, all of which can use variables to change what the manifest manages on a system. A catalog has none of these things; it contains only resources and relationships.

Only sending the catalog to agents allows Puppet to do several things:

* **Separate privileges:** Each individual node has little to no knowledge about other nodes. It only receives its own resources.
* **Simulate changes:** Since the agent has a declarative document describing its configuration, with no contingent logic, it has the option of simulating the changes necessary to apply the configuration. If you [do a Puppet run in _noop_ mode](./orchestration_puppet.html#arguments), the agent will check against its current state and report on what _would_ have changed without actually making any changes.
* **Record and query configurations:** Each node's most recent catalog is stored in PuppetDB, and you can [query the database service for information about managed resources](/puppetdb/1.6/api/index.html).



* * *

- [Next: Assigning Configurations to Nodes](./puppet_assign_configurations.html)
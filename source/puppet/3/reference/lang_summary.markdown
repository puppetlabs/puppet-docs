---
layout: default
title: "Language: Summary"
canonical: "/puppet/latest/reference/lang_summary.html"
---


[autoload]: ./lang_namespaces.html#autoloader-behavior
[config]: ./config_file_main.html
[usecacheonfailure]: /puppet/latest/reference/configuration.html#usecacheonfailure
[fileserve]: ./modules_fundamentals.html#files
[sitepp]: /references/glossary.html#site-manifest
[classes]: ./lang_classes.html
[enc]: /guides/external_nodes.html
[resources]: ./lang_resources.html
[chaining]: ./lang_relationships.html#chaining-arrows
[modules]: ./modules_fundamentals.html
[package]: /puppet/latest/reference/type.html#package
[file]: /puppet/latest/reference/type.html#file
[service]: /puppet/latest/reference/type.html#service
[case]: ./lang_conditional.html#case-statements
[fact]: ./lang_variables.html#facts-and-built-in-variables
[variables]: ./lang_variables.html
[relationships]: ./lang_relationships.html
[ordering]: ./lang_relationships.html#ordering-and-notification
[notification]: ./lang_relationships.html#ordering-and-notification
[declared]: /references/glossary.html#declare
[string_newline]: ./lang_datatypes.html#line-breaks
[node]: ./lang_node_definitions.html
[ordering option]: ./configuration.html#ordering

[hiera]: https://github.com/puppetlabs/hiera

Puppet uses its own configuration language, which was designed to be accessible to sysadmins. The Puppet language does not require much formal programming experience and its syntax was inspired by the Nagios configuration file format.

> To see how the Puppet language's features have evolved over time, see [History of the Puppet Language](/guides/language_history.html).

Resources, Classes, and Nodes
-----

The core of the Puppet language is **declaring [resources][].** Every other part of the language exists to add flexibility and convenience to the way resources are declared.

Groups of resources can be organized into **[classes][],** which are larger units of configuration. While a resource may describe a single file or package, a class may describe everything needed to configure an entire service or application (including any number of packages, config files, service daemons, and maintenance tasks). Smaller classes can then be combined into larger classes which describe entire custom system roles, such as "database server" or "web application worker."

Nodes that serve different roles will generally get different sets of classes. The task of configuring which classes will be applied to a given node is called **node classification.**  Nodes can be classified in the Puppet language using [node definitions][node]; they can also be classified using node-specific data from outside your manifests, such as that from an [ENC][] or [Hiera][].


Ordering
-----

Puppet's language is mostly **declarative:** Rather than listing a series of steps to carry out, a Puppet manifest describes a desired final state.

The resources in a manifest can be freely ordered --- they will not necessarily be applied to the system in the order they are written. This is because Puppet assumes most resources aren't related to each other. If one resource depends on another, [you must say so explicitly][relationships]. (If you want a short section of code to get applied in the order written, you can use [chaining arrows][chaining].)

Although resources can be freely ordered, several parts of the language do depend on parse order. The most notable of these are variables, which must be set before they are referenced.

Puppet 3.3 introduced the [ordering option][], which provides an alternative to the effectively random order for unrelated resources. If you set `ordering = manifest` in `puppet.conf`, Puppet will apply resources in the order in which they appear in the manifest **if the order is not otherwise determined,** e.g., by metaparameters like `before` or `require`.

Files
-----

Puppet language files are called **manifests,** and are named with the `.pp` file extension. Manifest files:

* Should use UTF8 encoding
* May use Unix (LF) or Windows (CRLF) line breaks (note that the line break format also affects [literal line breaks in strings][string_newline])

Puppet always begins compiling with a single manifest. When using a puppet master, this file is called [site.pp][sitepp]; when using puppet apply, it's whatever was specified on the command line.

Any [classes][] [declared][] in the manifest can be [autoloaded][autoload] from manifest files in [modules][]. Puppet will also autoload any classes declared by an optional [external node classifier][enc].

Thus, the simplest Puppet deployment is a lone manifest file with a few resources. Complexity can grow progressively, by grouping resources into modules and classifying your nodes more granularly.

Compilation and Catalogs
-----

Puppet manifests can use conditional logic to describe many nodes' configurations at once. Before configuring a node, Puppet compiles manifests into a **catalog,** which is only valid for a single node and which contains no ambiguous logic.

Catalogs are static documents which contain resources and relationships. At various stages of a Puppet run, a catalog will be in memory as a Ruby object, transmitted as JSON, and persisted to disk as YAML. The catalog format used by this version of Puppet is not documented  and does not have a spec.

In the standard agent/master architecture, nodes request catalogs from a puppet master server, which compiles and serves them to nodes as needed. When running Puppet standalone with puppet apply, catalogs are compiled locally and applied immediately.

Agent nodes cache their most recent catalog. If they request a catalog and the master fails to compile one, they will re-use their cached catalog. This recovery behavior is governed by the [`usecacheonfailure`][usecacheonfailure] setting in [puppet.conf][config]. When testing updated manifests, you can save time by turning it off.


Example
-----

The following short manifest manages NTP. It uses [package][], [file][], and [service][] resources; a [case statement][case] based on a [fact][]; [variables][]; [ordering][] and [notification][] relationships; and [file contents being served from a module][fileserve].

~~~ ruby
    case $operatingsystem {
      centos, redhat: { $service_name = 'ntpd' }
      debian, ubuntu: { $service_name = 'ntp' }
    }

    package { 'ntp':
      ensure => installed,
    }

    service { 'ntp':
      name      => $service_name,
      ensure    => running,
      enable    => true,
      subscribe => File['ntp.conf'],
    }

    file { 'ntp.conf':
      path    => '/etc/ntp.conf',
      ensure  => file,
      require => Package['ntp'],
      source  => "puppet:///modules/ntp/ntp.conf",
      # This source file would be located on the puppet master at
      # /etc/puppetlabs/puppet/modules/ntp/files/ntp.conf (in Puppet Enterprise)
      # or
      # /etc/puppet/modules/ntp/files/ntp.conf (in open source Puppet)
    }
~~~



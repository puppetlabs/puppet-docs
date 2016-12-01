---
layout: default
title: "Future Parser: Basics"
canonical: "/puppet/latest/reference/lang_summary.html"
---

[site_manifest]: ./dirs_manifest.html
[autoload]: ./future_lang_namespaces.html#autoloader-behavior
[config]: /guides/configuring.html
[usecacheonfailure]: ./configuration.html#usecacheonfailure
[fileserve]: ./modules_fundamentals.html#files
[classes]: ./future_lang_classes.html
[enc]: /guides/external_nodes.html
[resources]: ./future_lang_resources.html
[chaining]: ./future_lang_relationships.html#chaining-arrows
[modules]: ./modules_fundamentals.html
[package]: ./type.html#package
[file]: ./type.html#file
[service]: ./type.html#service
[case]: ./future_lang_conditional.html#case-statements
[fact]: ./future_lang_variables.html#facts-and-built-in-variables
[variables]: ./future_lang_variables.html
[relationships]: ./future_lang_relationships.html
[ordering]: ./future_lang_relationships.html#ordering-and-notification
[notification]: ./future_lang_relationships.html#ordering-and-notification
[declared]: /references/glossary.html#declare
[string_newline]: ./future_lang_data_string.html#line-breaks
[node]: ./future_lang_node_definitions.html
[ordering]: ./configuration.html#ordering
[hiera]: /hiera/latest
[compilation]: ./subsystem_catalog_compilation.html

Puppet uses its own configuration language, which was designed to be accessible to sysadmins. The Puppet language does not require much formal programming experience and its syntax was inspired by the Nagios configuration file format.

> To see how the Puppet language's features have evolved over time, see [History of the Puppet Language](/guides/language_history.html).

Resources, Classes, and Nodes
-----

The core of the Puppet language is **declaring [resources][].** Every other part of the language exists to add flexibility and convenience to the way resources are declared.

Groups of resources can be organized into **[classes][],** which are larger units of configuration. While a resource may describe a single file or package, a class may describe everything needed to configure an entire service or application (including any number of packages, config files, service daemons, and maintenance tasks). Smaller classes can then be combined into larger classes which describe entire custom system roles, such as "database server" or "web application worker."

Nodes that serve different roles will generally get different sets of classes. The task of configuring which classes will be applied to a given node is called **node classification.**  Nodes can be classified in the Puppet language using [node definitions][node]; they can also be classified using node-specific data from outside your manifests, such as that from an [ENC][] or [Hiera][].


Ordering
-----

Puppet's language is mostly **declarative:** Rather than listing a series of changes to make to a node, a Puppet manifest describes a desired final state.

The resources in a manifest can be freely ordered --- they will not necessarily be applied to the system in the order they are written. This is because Puppet assumes most resources aren't related to each other. If one resource depends on another, [you must say so explicitly][relationships]. (If you want a short section of code to get applied in the order written, you can use [chaining arrows][chaining].)

Although resources can be freely ordered, several parts of the language do depend on evaluation order. The most notable of these are variables, which must be set before they are referenced.

### Configurable Ordering

The [ordering setting][ordering] allows you to configure the order in which unrelated resources get applied.

By default, the order of unrelated resources is effectively random. If you set `ordering = manifest` in `puppet.conf`, Puppet will apply unrelated resources in the order in which they appear in the manifest.

This setting only affects resources whose relative order **is not otherwise determined,** e.g., by metaparameters like `before` or `require`. See [the language page on relationships](./future_lang_relationships.html) for more information.

Files
-----

Puppet language files are called **manifests,** and are named with the `.pp` file extension. Manifest files:

* Must use UTF8 encoding
* May use Unix (LF) or Windows (CRLF) line breaks (note that the line break format also affects [literal line breaks in strings][string_newline])

Puppet always begins compiling with a single manifest (which may be broken up into several pieces), called the "site manifest" or "main manifest." See [the reference page on the main manifest][site_manifest] for details about this special file/directory.

Any [classes][] [declared][] in the main manifest can be [autoloaded][autoload] from manifest files in [modules][]. Puppet will also autoload any classes declared by an optional [external node classifier][enc]. See [the reference page on catalog compilation][compilation] for details.

The simplest Puppet deployment is a lone main manifest file with a few resources. Complexity can grow progressively, by grouping resources into modules and classifying your nodes more granularly.

### Line Endings in Windows Text Files

Windows uses CRLF line endings instead of \*nix's LF line endings.

* If the contents of a file are specified with the `content` attribute, Puppet will write the content in "binary" mode. To create files with CRLF line endings, the `\r\n` escape sequence should be specified as part of the content.
* If a file is being downloaded to a Windows node with the `source` attribute, Puppet will transfer the file in "binary" mode, leaving the original newlines untouched.
* Non-`file` resource types that make partial edits to a system file (most notably the [`host`](./type.html#host) resource type, which manages the `%windir%\system32\drivers\etc\hosts` file) manage their files in text mode, and will automatically translate between Windows and \*nix line endings.

    > Note: When writing your own resource types, you can get this behavior by using the `flat` filetype.


Compilation and Catalogs
-----

Puppet manifests can use conditional logic to describe many nodes' configurations at once. Before configuring a node, Puppet compiles manifests into a **catalog,** which is only valid for a single node and which contains no ambiguous logic.

Catalogs are static documents which contain resources and relationships. At various stages of a Puppet run, a catalog will be in memory as a Ruby object, transmitted as JSON, and persisted to disk as YAML. The catalog format used by this version of Puppet is not documented  and does not have a spec.

In the standard agent/master architecture, nodes request catalogs from a Puppet master server, which compiles and serves them to nodes as needed. When running Puppet standalone with Puppet apply, catalogs are compiled locally and applied immediately.

Agent nodes cache their most recent catalog. If they request a catalog and the master fails to compile one, they will re-use their cached catalog. This recovery behavior is governed by the [`usecacheonfailure`][usecacheonfailure] setting in [puppet.conf][config]. When testing updated manifests, you can save time by turning it off.

For more information, see [the reference page on catalog compilation][compilation].


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
      # This source file would be located on the Puppet master at
      # /etc/puppetlabs/puppet/modules/ntp/files/ntp.conf (in Puppet Enterprise)
      # or
      # /etc/puppet/modules/ntp/files/ntp.conf (in open source Puppet)
    }
~~~



---
layout: default
title: "Language: Basics"
---

[site_manifest]: ./dirs_manifest.html
[autoload]: ./lang_namespaces.html#autoloader-behavior
[config]: ./config_file_main.html
[usecacheonfailure]: ./configuration.html#usecacheonfailure
[fileserve]: ./modules_fundamentals.html#files
[classes]: ./lang_classes.html
[enc]: ./nodes_external.html
[resources]: ./lang_resources.html
[chaining]: ./lang_relationships.html#chaining-arrows
[modules]: ./modules_fundamentals.html
[package]: ./type.html#package
[file]: ./type.html#file
[service]: ./type.html#service
[case]: ./lang_conditional.html#case-statements
[fact]: ./lang_variables.html#facts-and-built-in-variables
[variables]: ./lang_variables.html
[relationships]: ./lang_relationships.html
[ordering]: ./lang_relationships.html#ordering
[notification]: ./lang_relationships.html#refreshing-and-notification
[declared]: /references/glossary.html#declare
[string_newline]: ./lang_data_string.html#line-breaks
[node]: ./lang_node_definitions.html
[hiera]: {{hiera}}/
[compilation]: ./subsystem_catalog_compilation.html

Puppet uses its own configuration language, which was designed to be accessible to sysadmins. The Puppet language does not require much formal programming experience and its syntax was inspired by the Nagios configuration file format.

## Resources, classes, and nodes

The core of the Puppet language is **declaring [resources][].** Every other part of the language exists to add flexibility and convenience to the way resources are declared.

Groups of resources can be organized into **[classes][],** which are larger units of configuration. While a resource might describe a single file or package, a class can describe everything needed to configure an entire service or application (including any number of packages, config files, service daemons, and maintenance tasks). Smaller classes can then be combined into larger classes which describe entire custom system roles, such as "database server" or "web application worker."

Nodes that serve different roles will generally get different sets of classes. The task of configuring which classes will be applied to a given node is called **node classification.**  Nodes can be classified in the Puppet language using [node definitions][node]; they can also be classified using node-specific data from outside your manifests, such as that from an [ENC][] or [Hiera][].

## Ordering

Although Puppet's language is built around describing resources (and the relationships between them) in a declarative way, several parts of the language do depend on evaluation order. The most notable of these are variables, which must be set before they are referenced.

In the rest of this document, we try to call out areas where the order of statements matters.

## Files

Puppet language files are called **manifests,** and are named with the `.pp` file extension. Manifest files:

* Must use UTF8 encoding
* Can use Unix (LF) or Windows (CRLF) line breaks (note that the line break format also affects [literal line breaks in strings][string_newline])

Puppet always begins compiling with the **main manifest,** which can be either a single file or a directory containing several files. (Some documents also call this the "site manifest.") See [the reference page on the main manifest][site_manifest] for details about this special file/directory.

Any [classes][] [declared][] in the main manifest can be [autoloaded][autoload] from manifest files in [modules][]. Puppet will also autoload any classes declared by an optional [external node classifier][enc]. See [the reference page on catalog compilation][compilation] for details.

The simplest Puppet deployment is a lone main manifest file with a few resources. Complexity can grow progressively, by grouping resources into modules and classifying your nodes more granularly.

### Line endings in Windows text files

Windows uses CRLF line endings instead of \*nix's LF line endings.

* If the contents of a file are specified with the `content` attribute, Puppet will write the content in "binary" mode. To create files with CRLF line endings, the `\r\n` escape sequence should be specified as part of the content.
* If a file is being downloaded to a Windows node with the `source` attribute, Puppet will transfer the file in "binary" mode, leaving the original newlines untouched.
* Non-`file` resource types that make partial edits to a system file (most notably the [`host`](./type.html#host) resource type, which manages the `%windir%\system32\drivers\etc\hosts` file) manage their files in text mode, and will automatically translate between Windows and \*nix line endings.

> **Note:** When writing your own resource types, you can get this behavior by using the `flat` filetype.

## Compilation and catalogs

Puppet manifests can use conditional logic to describe many nodes' configurations at once. Before configuring a node, Puppet compiles manifests into a **catalog,** which is only valid for a single node and which contains no ambiguous logic.

Catalogs are static documents which contain resources and relationships. At various stages of a Puppet run, a catalog will be in memory as a Ruby object, transmitted as JSON, and persisted to disk as YAML. The catalog format used by this version of Puppet is not documented  and does not have a spec.

In the standard agent/master architecture, nodes request catalogs from a Puppet master server, which compiles and serves them to nodes as needed. When running Puppet standalone with Puppet apply, catalogs are compiled locally and applied immediately.

Agent nodes cache their most recent catalog. If they request a catalog and the master fails to compile one, they will re-use their cached catalog. This recovery behavior is governed by the [`usecacheonfailure`][usecacheonfailure] setting in [puppet.conf][config]. When testing updated manifests, you can save time by turning it off.

For more information, see [the reference page on catalog compilation][compilation].

## Example

The following short manifest manages NTP. It uses [package][], [file][], and [service][] resources; a [case statement][case] based on a [fact][]; [variables][]; [ordering][] and [notification][] relationships; and [file contents being served from a module][fileserve].

``` puppet
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
  # /etc/puppetlabs/code/modules/ntp/files/ntp.conf
}
```
---
layout: default
title: "Language: Summary"
---


<!-- TODO add links -->

[classes]: 
[enc]: 
[resources]: 
[modules]: 
[package]: 
[file]: 
[service]: 
[case]: 
[fact]: 
[variable]: 
[relationships]: 
[ordering]: 
[notification]: 
[fileserve]: 
[catalog]: 
[agentmaster]: 
[standalone]: 
[sitepp]: 
[autoload]: 
[enc]: 
[modules]: 
[declared]: (glossary declare)

The Puppet Language
-----

Puppet uses its own configuration language. This language was designed to be accessible to sysadmins without much formal programming experience, and its syntax was inspired by the Nagios configuration file format.

Puppet's language is mostly **declarative:** instead of being a series of steps to carry out, a Puppet manifest is a description of a desired final state. Among other things, this means:

* Unrelated resources are assumed to be independent of each other. If a resource must happen after another resource, you must say so with an explicit [relationship][relationships]. 
* Puppet manifests can _mostly_ be freely ordered, as resources are not applied to the target system in the order they are written. (The major exception is that variables must be defined before they are referenced.)

The core of the Puppet language is **declaring [resources][].** Every other part of the language exists to add flexibility to the way resources are declared. 

Example
-----

The following short manifest manages NTP. It uses [package][], [file][], and [service][] resources; a [case statement][case] based on a [fact][]; [variables][]; [ordering][] and [notification][] relationships; and [file contents being served from a module][fileserve].

{% highlight ruby %}
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
    }
{% endhighlight %}

Compilation
-----

Puppet manifests can use conditional logic to describe many nodes' configurations at once. Before configuring a node, Puppet compiles manifests into a **catalog,** which is only valid for a single node and which contains no ambiguous logic.

In the standard [agent/master architecture][agentmaster], nodes request catalogs from a puppet master server, which compiles and serves them as needed. This means you only have to maintain manifests in one location, and lets you prevent nodes from seeing other nodes' configurations.

In [standalone][] Puppet, catalogs are compiled locally, which means each node must have a full set of manifests.


Files
-----

Puppet language files are called **manifests,** and are named with the `.pp` file extension.

Puppet always begins compiling with a single manifest. When using a puppet master, this file is called [site.pp][sitepp]; when using puppet apply, it's whatever was specified on the command line. 

Any [classes][] [declared][] in the manifest can be [autoloaded][autoload] from manifest files in [modules][]. Puppet will also declare and autoload any classes specified by an optional [external node classifier][enc]. 

Thus, the simplest Puppet deployment is a lone manifest file with a few resources. Complexity can grow progressively, by grouping resources into modules and classifying your nodes more granularly.

---
layout: default
title: "Future Parser: Exported Resources"
canonical: "/puppet/latest/reference/lang_exported.html"
---

[resources]: ./future_lang_resources.html
[nagios_service]: ./type.html#nagiosservice
[concat]: http://forge.puppetlabs.com/ripienaar/concat
[title]: ./future_lang_resources.html#title
[namevar]: ./future_lang_resources.html#namenamevar
[hostname]: /facter/latest/core_facts.html#hostname
[fqdn]: /facter/latest/core_facts.html#fqdn
[tags]: ./future_lang_tags.html
[facts]: ./future_lang_variables.html#facts
[bacula]: https://forge.puppetlabs.com/puppetlabs/bacula
[exported_collector]: ./future_lang_collectors.html#exported-resource-collectors
[search]: ./future_lang_collectors.html#search-expressions
[puppetdb]: /puppetdb/1
[puppetdb_connect]: /puppetdb/latest/connect_puppet_master.html
[puppetdb_install]: /puppetdb/latest/install_via_module.html
[exported_guide]: /guides/exported_resources.html
[catalog]: ./future_lang_summary.html#compilation-and-catalogs

> **Note:** Exported resources require catalog storage and searching (formerly known as "storeconfigs") to be enabled on your Puppet master. Both the catalog storage and the searching (among other features) are provided by [PuppetDB][]. To enable exported resources, follow these instructions:
>
> * [Install PuppetDB on a server at your site][puppetdb_install]
> * [Connect your Puppet master to PuppetDB][puppetdb_connect]

An **exported resource declaration** specifies a desired state for a resource, **does not** manage the resource on the target system, and publishes the resource for use by **other nodes.** Any node (including the node that exported it) can then **collect** the exported resource and manage its own copy of it.

Purpose
-----

Exported resources allow the Puppet compiler to share information among nodes by combining information from multiple nodes' catalogs. This helps you manage things that rely on nodes knowing the states or activity of other nodes.

> **Note:** Exported resources rely on the compiler having access to the information, and cannot use information that's never sent to the compiler, such as the contents of arbitrary files on a node.

The most common use cases are monitoring and backups. A class that manages a service like PostgreSQL can export a [`nagios_service`][nagios_service] resource describing how to monitor the service, including information like its hostname and port. The Nagios server can then collect every `nagios_service` resource, and will automatically start monitoring the Postgres server.

For more details, see [Exported Resource Design Patterns][exported_guide].


Syntax
-----

Using exported resources requires two steps: declaring and collecting.

~~~ ruby
    class ssh {
      # Declare:
      @@sshkey { $hostname:
        type => dsa,
        key  => $sshdsakey,
      }
      # Collect:
      Sshkey <<| |>>
    }
~~~

In the example above, every node with the `ssh` class will export its own SSH host key and then collect the SSH host key of every node (including its own). This will cause every node in the site to trust SSH connections from every other node.

### Declaring an Exported Resource

To declare an exported resource, prepend `@@` (a double "at" sign) to the **resource type** of a standard [resource declaration][resources]:

~~~ ruby
    @@nagios_service { "check_zfs${hostname}":
      use                 => 'generic-service',
      host_name           => "$fqdn",
      check_command       => 'check_nrpe_1arg!check_zfs',
      service_description => "check_zfs${hostname}",
      target              => '/etc/nagios3/conf.d/nagios_service.cfg',
      notify              => Service[$nagios::params::nagios_service],
    }
~~~

### Collecting Exported Resources

To collect exported resources you must use an [exported resource collector][exported_collector] :

~~~ ruby
    Nagios_service <<| |>> # Collect all exported nagios_service resources

    #  Collect exported file fragments for building a Bacula config file:
    Concat::Fragment <<| tag == "bacula-storage-dir-${bacula_director}" |>>
~~~

(The second example, taken from [puppetlabs-bacula][bacula], uses the [concat][] module.)

Since any node could be exporting a resource, it is difficult to predict what the title of an exported resource will be. As such, it's usually best to [search][] on a more general attribute. This is one of the main use cases for [tags][].

See [Exported Resource Collectors][exported_collector] for more detail on the collector syntax and search expressions.


Behavior
-----

When catalog storage and searching (AKA storeconfigs) are enabled, the Puppet master will send a copy of every [catalog][] it compiles to [PuppetDB][]. PuppetDB retains the most recent catalog for every node and provides the Puppet master with a search interface to those catalogs.

Declaring an exported resource causes that resource to be added to the catalog and marked with an "exported" flag, which prevents Puppet agent from managing the resource (unless it was collected). When PuppetDB receives the catalog, it also takes note of this flag.

Collecting an exported resource causes the Puppet master to send a search query to PuppetDB. PuppetDB will respond with every exported resource that matches the [search expression][search], and the Puppet master will add those resources to the catalog.

### Timing

An exported resource becomes available to other nodes as soon as PuppetDB finishes storing the catalog that contains it. This is a multi-step process and may not happen immediately:

* The Puppet master must have compiled a given node's catalog at least once before its resources become available.
* When the Puppet master submits a catalog to PuppetDB, it is added to a queue and stored as soon as possible. Depending on the PuppetDB server's workload, there may be a slight delay between a node's catalog being compiled and its resources becoming available.

### Uniqueness

Every exported resource must be **globally unique** across every single node. If two nodes export resources with the same [title][] or same [name/namevar][namevar] and you attempt to collect both, **the compilation will fail.** (Note: Some pre-1.0 versions of PuppetDB will not fail in this case. This is a bug.)

To ensure uniqueness, every resource you export should include a substring unique to the node exporting it into its title and name/namevar. The most expedient way is to use the [`hostname`][hostname] or [`fqdn`][fqdn] [facts][].

### Exported Resource Collectors

Exported resource collectors do not collect normal or virtual resources. In particular, they cannot retrieve non-exported resources from other nodes' catalogs.


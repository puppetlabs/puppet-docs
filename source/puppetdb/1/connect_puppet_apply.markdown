---
title: "PuppetDB 1 » Connecting Standalone Puppet Nodes to PuppetDB"
layout: default
---

[exported]: /puppet/2.7/reference/lang_exported.html
[package]: /references/latest/type.html#package
[file]: /references/latest/type.html#file
[yumrepo]: /references/latest/type.html#yumrepo
[apt]: http://forge.puppetlabs.com/puppetlabs/apt
[puppetdb_download]: http://downloads.puppetlabs.com/puppetdb
[puppetdb_conf]: /guides/configuring.html#puppetdbconf
[routes_yaml]: /guides/configuring.html#routesyaml
[exported]: /puppet/2.7/reference/lang_exported.html
[jetty]: ./configure.html#jetty-http
[settings_namespace]: /puppet/2.7/reference/lang_variables.html#master-set-variables

> Note: The nodes at your site must be running Puppet 2.7.12 or later to use PuppetDB.

PuppetDB can also be used with standalone Puppet deployments where each node runs puppet apply. Once connected to PuppetDB, puppet apply will do the following:

* Send the node's catalog to PuppetDB
* Query PuppetDB when compiling catalogs that collect [exported resources][exported]

**Note that standalone deployments can only store catalogs, and cannot use the inventory service.** This is due to a limitation in Puppet.

Since you must change Puppet's configuration on every managed node, **we strongly recommend that you do so with Puppet itself.** 

## Step 1: Disable or Reconfigure SSL on PuppetDB

Since PuppetDB requires client authentication for SSL connections, you may need to disable SSL support if your nodes do not have certificates.

* If you use puppet apply but have **configured a central CA and issued a certificate to every node,** you may leave SSL enabled. Your nodes will use SSL when connecting to PuppetDB, and PuppetDB will only accept connections from authorized nodes.
* If your nodes do not have certificates and you **don't mind catalogs being transmitted in cleartext,** you may remove the `ssl-port` setting from the [`jetty` section of the PuppetDB config files][jetty]. Use the unencrypted port in puppetdb.conf.
* If your nodes do not have certificates and you **want your catalogs encrypted,** you must either issue them certificates (from the same CA that issued PuppetDB's certificate), or disable the embedded SSL as described above and use an SSL proxy, which can be configured for optional or no client authentication. Configuring an SSL proxy for PuppetDB is currently beyond the scope of this manual.

## Step 2: Install Plugins

Currently, puppet needs extra Ruby plugins in order to use PuppetDB. Unlike custom facts or functions, these cannot be loaded from a module, and must be installed in Puppet's main source directory. 

* First, ensure that the appropriate Puppet Labs package repository ([Puppet Enterprise](/guides/puppetlabs_package_repositories.html#puppet-enterprise-repositories), or [open source](/guides/puppetlabs_package_repositories.html#open-source-repositories)) is enabled. You can use a [package][] resource to do this, or use the apt::source (from the [puppetlabs-apt][apt] module) and [yumrepo][] types. 
* Next, use Puppet to ensure that the `pe-puppetdb-terminus` or `puppetdb-terminus` package is installed:

{% highlight ruby %}
    # for PE:
    package {'pe-puppetdb-terminus':
      ensure => installed,
    }

    # for open source:
    package {'puppetdb-terminus':
      ensure => installed,
    }
{% endhighlight %}


### On Platforms Without Packages

If your puppet master isn't running Puppet from a supported package, you will need to install the plugins with [file][] resources. 

* [Download the PuppetDB source code][puppetdb_download]; unzip it, locate the `puppet/lib/puppet` directory and put it in the `files` directory of the Puppet module you are using to enable PuppetDB integration.
* Identify the install location of Puppet on your nodes.
* Create a [file][] resource in your manifests for each of the plugin files, to move them into place on each node. 

{% highlight ruby %}
    # <modulepath>/puppetdb/manifests/terminus/file.pp
    define puppetdb::terminus::file {
      $puppetdir = "$rubysitedir/puppet"
      file {$title:
        ensure => file,
        path   => "$puppetdir/$title",
        source => "puppet:///modules/puppetdb/$title",
    }
    # <modulepath>/puppetdb/manifests/terminus.pp
    class puppetdb::terminus {
      $puppetdir = "$rubysitedir/puppet"
      $puppetdb_terminus_files = [
        'face/node/deactivate.rb',
        'face/node/status.rb',
        'indirector/catalog/puppetdb.rb',
        'indirector/facts/puppetdb.rb',
        'indirector/node/puppetdb.rb',
        'indirector/resource/puppetdb.rb',
        'util/puppetdb/char_encoding.rb',
        'util/puppetdb.rb'
      ]
      
      file {"$puppetdir/util/puppetdb":
        ensure => directory,
      }
      puppetdb::terminus::file {$puppetdb_terminus_files:}
{% endhighlight %}

## Step 3: Manage Config Files

All of the config files you need to manage will be in Puppet's config directory (`confdir`). When managing these files with puppet apply, you can use the [`$settings::confdir`][settings_namespace] variable to automatically discover the location of this directory.

### Manage puppetdb.conf

You can specify the contents of [puppetdb.conf][puppetdb_conf] directly in your manifests. It should contain the PuppetDB server's hostname and port:

    [main]
    server = puppetdb.example.com
    port = 8081

* PuppetDB's port for secure traffic defaults to 8081.
* PuppetDB's port for insecure traffic defaults to 8080, but doesn't accept connections by default. 

If no puppetdb.conf file exists, the following default values will be used:

    server = puppetdb
    port = 8081

### Manage puppet.conf

You will need to create a template for puppet.conf based on your existing configuration. Then, modify the template to add the following settings to the `[main]` block:

    [main]
      storeconfigs = true
      storeconfigs_backend = puppetdb

> Note: The `thin_storeconfigs` and `async_storeconfigs` settings should be absent or set to `false`.

### Manage routes.yaml

You can probably specify the contents of [routes.yaml][routes_yaml] directly in your manifests; if you are already using it for some other purpose, you will need to manage it with a template based on your existing configuration. Ensure that the following keys are present:

    ---
    apply:
      facts:
        terminus: facter
        cache: facter

This will disable fact storage and prevent puppet apply from using stale facts.


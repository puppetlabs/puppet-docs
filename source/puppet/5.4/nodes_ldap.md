---
title: The LDAP Node Classifier
---

[class parameters]: ./lang_classes.html#class-parameters-and-variables
[hiera]: ./hiera_intro.html
[rp]: {{pe}}/r_n_p_intro.html
[custom hiera backend]: ./hiera_custom_backends.html
[environment]: ./environments.html
[node definitions]: ./lang_node_definitions.html

> **Note:** For background on Puppet's main sources of node data, see [the page on external node classifiers](./nodes_external.html).
>
> Although you can use LDAP nodes with node definitions in your main manifest, you can't combine LDAP nodes with an ENC --- they take up the same slot in Puppet's configuration, so are mutually exclusive.

This page describes a special node terminus in Puppet for storing node information in an LDAP directory. It works similarly to an ENC, and allows you to retrieve much of the same data as an ENC, but it is implemented as a node terminus rather than as an external binary.

This information is most well-tested with [OpenLDAP](http://www.openldap.org). It should work just as well with [Fedora Directory Server](http://directory.fedora.redhat.com/wiki/Features) or [Sun's Directory Server](http://www.sun.com/software/products/directory_srvr/home_directory.xml), although you'll have to translate the schema to work with them.

This guide will go through what it takes to modify an existing OpenLDAP setup; please check [OpenLDAP's documentation](http://www.openldap.org/doc/admin/quickstart.html) to get to that point.


## Why use LDAP nodes?

There are some benefits to storing node data in LDAP instead of using [node definitions](./lang_node_definitions.html) in the main manifest:

-   Other applications can easily get access to the same data.
-   All attributes on the LDAP nodes are assigned as variables in the Puppet configuration, just like facts.
-   It is straightforward for other applications to modify LDAP data to configure nodes (for example, as part of a deployment process), which is easier to support than generating Puppet code.

**However.** This LDAP integration was written for a very different world, before Puppet had [class parameters][] or [data lookup with Hiera][hiera], and before modern best practices like [the roles and profiles method][RP] were developed. Dinosaurs walked the earth, and you configured your Puppet classes by setting top-scope variables in the node definition.

You can probably still use this effectively, but please consider the following:

* With an antique interface like this, [the roles and profiles method][RP] is even more of a best practice than it is elsewhere. Since LDAP attributes can't configure class parameters, they're not suited for building full configurations out of component modules, so you should be hiding most of your complexity with wrapper classes, doing data lookup via Hiera, and only using LDAP to assign role classes.
* Depending on where that LDAP data is coming from, it might make more sense to go right to the source and write a [custom Hiera backend][] that can access your business's configuration data. In fact, writing an LDAP-based Hiera backend might make more sense than using this rigid 0.2x-era interface.

## Prerequisites

-   [ruby-ldap](http://ruby-ldap.sourceforge.net)

## Pre-Puppet Ruby/LDAP Validation

You can run the following tests to make sure that the Ruby-LDAP Library and your LDAP software are configured properly:

    ruby -rldap -e 'puts :installed'

If this returns installed then you can try:

    ruby -rpuppet -e 'p Puppet.features.ldap?'

These are basically doing the same thing, so they should either both succeed or both fail, and if they both succeed, then LDAP nodes should work.

## Node attributes

As with an ENC, an LDAP node object can set three kinds of information for a node:

* A list of classes to assign to that node.
* The [environment][] to use for that node.
* A list of top-scope variables to set for that node.

To allow a basic defaults-with-overrides pattern, LDAP nodes also allow you to specify the name of a parent node, whose data is merged with the main node. We think you can create arbitrarily long chains of grandparent nodes, but we don't know anyone who's tried this since the '00s.

### Parent node

Use the `parentNode` attribute to specify a parent node. A corresponding node object must exist in the LDAP data.

If you think in Hiera terms, Puppet merges data with a unique merge for classes, and a first-found lookup for variables and environment. (Sort of. See below.)

### Classes

Use the `puppetClass` attribute to assign classes. You can use it any number of times to assign multiple classes.

### Environment

Use the `environment` attribute to assign an environment.

### Variables

OK: We're very sorry about this, but documentation for how variables work with LDAP has been basically lost to time. The document we inherited from the wiki was very unclear about all this, and we can't budget the time to set up a test environment and confirm it. We don't even know if anyone is using this terminus anymore, to be honest.

As far as we can tell from cross-referencing the code with the original version of this guide:

* Puppet sets a top-scope variable for every attribute from an LDAP node object, so `puppetClass` is available as `$puppetClass` (or `$puppetclass`; we're not sure).
    * If an attribute was used multiple times in a node, its variable value is an array.
    * We think LDAP booleans become real Puppet booleans (instead of "true"), but we aren't positive.
    * No hashes allowed.
* Variables from a child node always override values inherited from a parent node.
    * EXCEPT: There seems to be a really janky method for doing something similar to a Hiera unique merge across a whole chain of parent nodes, so that you'll get the combined values from the entire hierarchy as an array. If you set the `puppetVar` attribute to a `<VARIABLE>=<VALUE>` string (like `puppetVar: config_exim=true`), Puppet sets a variable named `<VARIABLE>` (`config_exim`) whose value is an array of all similar values from child/parent/grandparent nodes (`[true, false, true]`).

We're very unsure about this, but that's what the code seems to imply. Have we mentioned that you should look into [Hiera][]?

### Example LDAP node data

Here's some example node data. We suspect whoever wrote the original wiki page was just kickin' it from their head, so this might not be the most realistic example.

    dn: cn=basenode,ou=Hosts,dc=madstop,dc=com
    objectClass: device
    objectClass: ipHost
    objectClass: puppetClient
    objectClass: top
    cn: basenode
    environment: production
    ipHostNumber: 192.168.0.1
    description: The base node
    puppetClass: baseclass
    puppetVar: config_exim=true
    puppetVar: config_exim_trusted_users=lludwig,lak,joe


    dn: cn=testserver,ou=Hosts,dc=madstop,dc=com
    objectClass: device
    objectClass: ipHost
    objectClass: puppetClient
    objectClass: top
    cn: testserver
    environment: testing
    ipHostNumber: 192.168.0.50
    description: My test server
    l: dc1
    puppetClass: testing
    puppetClass: solaris

The `testserver` node's classes would be `baseclass`, `testing`, and `solaris`. The environment would be `testing`, and the variables would be all over the place (see above re: uncertainty about that behavior). Notably, we don't think there would be a `$puppetVar` variable; instead, there would be `$config_exim` and `$config_exim_trusted_users` variables.

## Modifying your LDAP schema

You first have to provide the Puppet schema to your LDAP server. You can find the Puppet schema [in Git](http://github.com/puppetlabs/puppet/blob/master/ext/ldap/puppet.schema). Place this schema into your schema directory, on Debian for example this would be /etc/ldap/schema. I recommend keeping the puppet.schema name.

With the schema file in place, modify your slapd.conf to load this schema by adding it to the list of schema files loaded:

    include         /etc/ldap/schema/core.schema
    include         /etc/ldap/schema/cosine.schema
    include         /etc/ldap/schema/nis.schema
    include         /etc/ldap/schema/inetorgperson.schema
    include         /etc/ldap/schema/puppet.schema
    ...

Restart your server, making sure it comes back up, and you're all set.

## Loading nodes into LDAP

Loading data into LDAP is up to you; presumably, if you're deciding to use this feature in the first place, you already have plenty of LDAP tooling appropriate for your site. We don't have any particular recomendations.

However you decide to load the data, you need to create host entries (usually device entries, probably with ipHost as an auxiliary class) and then add the Puppet data. This is what an example workstation definition looks like in LDAP:

    dn: cn=culain,ou=Hosts,dc=madstop,dc=com
    objectClass: device
    objectClass: ipHost
    objectClass: puppetClient
    objectClass: top
    cn: culain
    environment: production
    ipHostNumber: 192.168.0.3
    puppetClass: webserver
    puppetClass: puppetserver
    puppetClass: mailserver
    parentNode: basenode

The DN for the host follows a model that should also work well if you decide to start using LDAP as an nsswitch source. It doesn't really matter to Puppet, though; it just does a query against the search base you specify and doesn't try to guess your DN.

## Configuring Puppet to use LDAP

Once you have your data in LDAP, you just need to configure Puppet to look there.

* If you are using agent/master Puppet, the master will be the one accessing LDAP. Put the configuration in the `[master]` block of its puppet.conf file.
* If you are using standalone puppet apply nodes, each one will need to access it. Put the configuration in the `[main]` block of their puppet.conf files.

To configure LDAP nodes, set the `node_terminus` to `ldap`:

    [master]
    node_terminus = ldap
    ldapserver = ldapserver.yourdomain.com
    ldapbase = dc=puppet

The only other required setting is `ldapbase`, which specifies where to search for LDAP nodes. Specify the Hosts tree as your search base, such as `ldapbase = ou=Hosts,dc=madstop,dc=com`.

However, you'll probably also want to specify several other settings, including where to find the server, how to authenticate to it, and more. The following is a full list of settings related to LDAP nodes; click any of them for descriptions in the configuration reference.

* [`ldapattrs`](./configuration.html#ldapattrs)
* [`ldapbase`](./configuration.html#ldapbase)
* [`ldapclassattrs`](./configuration.html#ldapclassattrs)
* [`ldapparentattr`](./configuration.html#ldapparentattr)
* [`ldappassword`](./configuration.html#ldappassword)
* [`ldapport`](./configuration.html#ldapport)
* [`ldapserver`](./configuration.html#ldapserver)
* [`ldapssl`](./configuration.html#ldapssl)
* [`ldapstackedattrs`](./configuration.html#ldapstackedattrs)
* [`ldapstring`](./configuration.html#ldapstring)
* [`ldaptls`](./configuration.html#ldaptls)
* [`ldapuser`](./configuration.html#ldapuser)


## Default nodes and short names

The LDAP node terminus tries to emulate the way Puppet [node definitions][] work, so when trying to find a given node name, it tries the following:

* The full node name.
* If the node name included at least one period (`.`), the segment of the name _before_ the first period. (So `magpie` for `magpie.example.com`.)
* The literal string `default`.

So you can create a node object whose `cn=default` and it will act as a default node for any nodes that don't have specific data.

> **Note:** If you use a default LDAP node, your [main manifest](./dirs_manifest.html) must include `node default {}`. Without this node statement, your LDAP nodes will not be found.
>
> ``` puppet
> node default {}
> ```


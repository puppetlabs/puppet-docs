---
layout: legacy
title: The LDAP Node Classifier
---

## Storing Node Information in LDAP

By default, puppetmasterd looks for nodes in its normal manifests,
but you can additionally or instead have it look in LDAP. This
works especially well if you are already storing your host
information in LDAP.

I've only used [OpenLDAP](http://www.openldap.org) to do this, but
it should work just as well with
[Fedora Directory Server](http://directory.fedora.redhat.com/wiki/Features)
(confirmed working with Fedora Directory by Larry Ludwig) or
[Sun's Directory Server](http://www.sun.com/software/products/directory_srvr/home_directory.xml),
although you'll have to translate the schema to work with them.

This guide will go through what it takes to modify an existing
OpenLDAP setup; please check
[OpenLDAP's documentation](http://www.openldap.org/doc/admin/quickstart.html)
to get to that point.

NOTE: You can use node entries in your manifests together with LDAP
nodes. External or LDAP nodes will be used before node entries. You
cannot however use LDAP nodes and external nodes together. You must
use one of these two types.

## Why You'd Do This

There are multiple benefits to storing nodes in LDAP instead of
using Puppet's built-in node support:

-   Other applications can easily get access to the same data
-   All attributes on the LDAP nodes are assigned as variables in
    the Puppet configuration, just like Facts, so you can easily
    configure attributes for individual classes
-   It is straightforward to allow other applications to modify
    this data to configure nodes (e.g., as part of a deployment
    process), which is easier to support than generating Puppet
    configurations

## Prerequisites

-   [ruby-ldap](http://ruby-ldap.sourceforge.net)

## Pre-Puppet Ruby/LDAP Validation

You can run the following tests to make sure that the Ruby-LDAP
Library and your LDAP software are configured properly:

    ruby -rldap -e 'puts :installed'

If this returns installed then you can try:

    ruby -rpuppet -e 'p Puppet.features.ldap?'

These are basically doing the same thing, so they should either
both succeed or both fail, and if they both succeed, then LDAP
nodes should work.

## Node Attributes

As mentioned, every attribute returned by LDAP nodes or parent
nodes will be assigned as a variable in Puppet configurations
during compilation. Attributes with multiple values will be created
as arrays. PuppetVar attribute allows to pass variables to a node.
Keep in mind variables cannot have space in the name/value pair or
quotes. As an example, take the following simple LDAP nodes:

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

In this case, the final result for the node will be the following
(shown as YAML):

    :objectClass:
    - device
    - ipHost
    - puppetClient
    - top
    :cn: testserver
    :environment: testing
    :description: My test server
    :l: dc1
    :classes:
    - testing
    - solaris
    :dn: cn=testserver,ou=Hosts,dc=madstop,dc=com

For this node LDAP has assigned the node name, testserver, its
environment, testing (support for environments in LDAP is in
release 0.24.3 and later), a description and assigned a list of
classes. The class list will be testing, solaris, and baseclass;
note that the node's class list only has the individual classes
assigned to that node. The class list evaluated by Puppet will
include parent node classes too.

Lastly, any parameters assigned in LDAP, for example here
ipHostNumber, would be available as variables in your manifests.
Thus variable $ipHostNumber in the testserver node would have a
value of 192.168.0.50 assigned to it.

## Modifying your LDAP Schema

You first have to provide the Puppet schema to your LDAP server.
You can find the Puppet schema
[in Git](http://github.com/puppetlabs/puppet/blob/master/ext/ldap/puppet.schema).
Place this schema into your schema directory, on Debian for example
this would be /etc/ldap/schema. I recommend keeping the
puppet.schema name.

With the schema file in place, modify your slapd.conf to load this
schema by adding it to the list of schema files loaded:

    include         /etc/ldap/schema/core.schema
    include         /etc/ldap/schema/cosine.schema
    include         /etc/ldap/schema/nis.schema
    include         /etc/ldap/schema/inetorgperson.schema
    include         /etc/ldap/schema/puppet.schema
    ...

Restart your server, making sure it comes back up, and you're all
set.

## Loading Nodes Into LDAP

In my opinion, the LDAP tool space is still depressingly spare. I
generally use my own [ldapsh](/projects/ldapsh) tool to manage
LDAP, but that does not work well for data loading. However you
decide to load the data, you need to create host entries (usually
device entries, probably with ipHost as an auxiliary class) and
then add the Puppet data. This is what my workstation definition
looks like in LDAP:

    dn: cn=culain,ou=Hosts,dc=madstop,dc=com
    objectClass: device
    objectClass: ipHost
    objectClass: puppetClient
    objectClass: top
    cn: culain
    environment: production
    ipHostNumber: 192.168.0.3
    puppetclass: webserver
    puppetclass: puppetserver
    puppetclass: mailserver
    parentnode: basenode

The DN I'm using for my host follows the model that I recommend for
all LDAP repositories. This will work well if you decide to start
using LDAP as an nsswitch source. It doesn't really matter to
Puppet, though; it just does a query against the search base you
specify, it doesn't try to guess your DN.

## Configuring Puppet to use LDAP

Once you have your data in LDAP, you just need to configure Puppet
to look there. It's pretty much always puppetmasterd that will be
looking in LDAP so we need to configure the [puppetmasterd] section
of the puppet.conf configuration file. In Puppet version 0.24 and
later this means selecting the appropriate node terminus, the
earlier ldapnodes option is fully deprecated and should not be
used. For LDAP nodes we use ldap as the terminus in the
node\_terminus configuration option:

    [puppetmasterd]
    node_terminus = ldap
    ldapserver = ldapserver.yourdomain.com
    ldapbase = dc=puppet

There is only one required settings: ldapbase for where to search
for LDAP nodes. You'll probably also want to specify ldapserver,
since the default is ldap, which likely won't work for most
people.

In other words, enable searching for nodes in LDAP by setting the
node\_terminus to ldap, and then provide the information necessary
to make it work. It's a good idea to actually specify the Hosts
tree as your search base (e.g., ldapbase =
ou=Hosts,dc=madstop,dc=com), but my database is small enough that
it doesn't matter.

With version 0.23.2 and later you should not need to restart the
puppetmasterd daemon but it's probably sensible.

### Configuring LDAP Nodes in pre-0.24 releases

In versions of Puppet prior to 0.24 configuring LDAP in Puppet used
the ldapnodes configuration option in the puppet.conf configuration
file.:

    [puppetmasterd]
    ldapnodes = true
    ldapserver = ldapserver.yourdomain.com
    ldapbase = dc=puppet

In the pre-0.24 versions there are two required settings: ldapnodes
to indicate you want to look for nodes in LDAP and ldapbase for
where to search for LDAP nodes. Like later versions you'll probably
also want to specify ldapserver, since the default is ldap, which
likely won't work for most people.

With earlier versions you'll also need to restart the daemon.

## Using Arrays with LDAP

By default the puppetVar LDAP attribute does not support arrays. In
order to support an array with puppetVar you must add these two
functions to your puppetmaster.

/usr/lib/ruby/site\_ruby/1.8/puppet/parser/functions/get\_var.rb:

    # Evaluate the value of a variable that might have been defined globally.
    module Puppet::Parser::Functions
      newfunction(:get_var, :type => :rvalue) do |args|
        var = args[0]
        global_var = lookupvar(var)
        if global_var != "" and global_var != nil
          case global_var
            when "true"
            return true
            when "false"
            return false
            else
            return global_var
          end
        end
        if args.length > 1
          return args[1]
        end
        return ""
      end
    end

/usr/lib/ruby/site\_ruby/1.8/puppet/parser/functions/split.rb:

    # Split a string variable into an array using the specified split
    # character.
    #
    # Usage:
    #
    #   $string    = 'value1,value2'
    #   $array_var = split($string, ',')
    #
    # $array_var holds the result ['value1', 'value2']
    #
    module Puppet::Parser::Functions
      newfunction(:split, :type => :rvalue) do |args|
        return args[0].split(args[1])
      end
    end

In your LDAP definition you can place:

    puppetVar: config_exim_trusted_users=lludwig,lak,joe

Then you must add this code to the top of a recipe before using
that variable:

    $config_exim_trusted_users = split(get_var('config_exim_trusted_users'), ',')

In this example the variable config\_exim\_trusted\_users gets
reformatted into a Puppet array.

## Default Nodes

Note that Puppet also supports default node definitions, named
(imaginatively) default. You can use this to provide a minimal
configuration for new nodes until you get around to configuring
each node. Without a default node configuration, unconfigured nodes
will fail.

***Note***: If you use LDAP/external nodes then there must be the entry **`node default {}`** in **`site.pp`**. Without this entry your LDAP nodes will not be found.

    node default {}

And then a default node in LDAP or your external node source like:

    dn: cn=default,dc=orgName,dc=com
    objectClass: device
    objectClass: puppetClient
    objectClass: top
    cn: default


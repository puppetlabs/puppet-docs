---
layout: default
title: "Puppet 3.x to 4.x: Upgrade Puppet Server and PuppetDB"
canonical: "/puppet/latest/reference/upgrade_major_server.html"
---

Unlike the automated upgrades of Puppet agents, Puppet Server upgrades are a manual process. There's more going on under the hood, and more decisions you need to make during the process.

This page walks you through getting an upgraded Puppet Server that can handle Puppet 3 agents. Don't start upgrading agents after the servers are stabilized.

## Prepare to Upgrade

First, go through any necessary [pre-upgrade steps](./upgrade_major_pre.html). Before upgrading, your Puppet infrastructure should be stable and running:

- the latest Puppet 3-compatible versions of everything you use.
- the future parser.
- full data type support for facts.
- Puppet Server instead of Rack.

[//]: # (Add links)

If you're having any problems with this configuration, **fix them first** before continuing.

## Decide on an Upgrade Plan

> **WARNING**: Puppet master servers are in charge of running your site, and this upgrade will interrupt their work. Bring up replacement masters and gradually cut over service to them, take a few masters out of your pool for upgrades while always leaving a few to handle traffic, or schedule downtime.
> 
> If you have multiple Puppet masters, upgrade or replace the CA master first, and pause provisioning of new Puppet agent nodes while upgrading or replacing the CA server.

## Upgrade Each Puppet Master

Repeat these steps for each Puppet Server until you're running a pure Puppet 4/Puppet Server 2.1+ infrastructure.

### Install the Latest Puppet Server

[//]: # (Revise)

1. Enable the Puppet Collection 1 repository.
2. Disable any older repositories.
3. Install the `puppetserver` package.

**Don't start the `puppetserver` service yet!** There's a few other things you should do first.

### Get Familiar with the New Binary Locations

All Puppet binaries are now at `/opt/puppetlabs/bin`, which isn't in your system's `PATH` by default. You should either:

* Add it to your `PATH` however you prefer.
[//]: # (Revise)
* Symlink all the binaries you use into some directory in your path.
* Use the full path to run all Puppet commands (e.g. `/opt/puppetlabs/bin/puppet agent --test`).

### Reconcile `puppet.conf`

We also moved `puppet.conf` to `/etc/puppetlabs/puppet/puppet.conf`, changed a lot of defaults, ad removed many settings.

If you're upgrading a node, open the new, relocated `puppet.conf`, compare it to your old `puppet.conf` (probably at `/etc/puppet/puppet.conf`), and copy the modified settings you actually care about.

[//]: # (Windows?)

If this is a new node, look at the list of important settings (link) for stuff you might want to set now.

[//]: # (Why do we care about new nodes in an upgrade guide? If this is a new node, why install Puppet 3 and upgrade to Puppet 4?)

### Reconcile `auth.conf`

[//]: # (pasting in stuff from Puppet Server compatibility docs; modify if you need to. Also, note that the location changed: it's /etc/puppetlabs/puppet/auth.conf now, and was probably /etc/puppet/auth.conf before.)

[ca.conf]: /puppetserver/2.1/configuration.html#caconf
[auth.conf]: ./config_file_auth.html

Puppet 4 uses different HTTPS URLs to fetch configurations. Any rules in `auth.conf` that match Puppet 3-style URLs will have _no effect._ (For more details, see the [Puppet Server compatibility docs]().

[//]: # (Revise)

This means you must:

* Find any _custom_ rules you've added to your old [`auth.conf`][auth.conf] file. (Don't worry about default rules.)
* Change each `path` to use Puppet 4 URLs.
    * Add `/puppet/v3` to the beginning of most paths.
    * The `certificate_status` endpoint ignores `auth.conf`. Configure access in Puppet Server's [`ca.conf`][ca.conf] file.
* Add the rules to Puppet Server's new `/etc/puppetlabs/puppet/auth.conf` file.

#### `auth.conf` Rule Example

Old Puppet 3 rules:

~~~ puppet
# Puppet 3 auth.conf on the master
path ~ ^/catalog/([^/]+).uuid$
method find
allow /^$1\.uuid.*/

# Default rule, should follow the more specific rules
path ~ ^/catalog/([^/]+)$
method find
allow $1
~~~

New Puppet Server 2 rules supporting both Puppet 3 and 4 agents:

~~~ puppet
# Puppet 3 & 4 compatible auth.conf with Puppet Server 2.1
path ~ ^/puppet/v3/catalog/([^/]+).uuid$
method find
allow /^$1\.uuid.*/

# Default rule, should follow the more specific rules
path ~ ^/puppet/v3/catalog/([^/]+)$
method find
allow $1
~~~

### Migrate Other Configuration Files

If you have other configuration files, including `puppetdb.conf`, move them to `/etc/puppetlabs/puppet/`.

[//]: #  (link here to the pages about configuration files)

### Set up SSL



- If this is an existing puppet master being upgraded, find the ssldir (link to page about ssldir) and copy it to the new location at `/etc/puppetlabs/puppet/ssl`.
- If this is an exact replacement for a prior server, keeping the same names etc., copy the ssldir from the old server to the new one. We recommend using `rsync -a` for this: SSL is picky about file permissions, and rsync's "archive" mode will preserve the permissions on the files.
- If this is a new puppet master server but it's NOT serving as a CA, run `puppet agent --test --certname=<NAME> --dns_alt_names=<NAME>,<NAME>,<NAME> --server=<UPGRADED CA SERVER>`, sign the certificate on the CA, and run that puppet agent command again to fetch the signed certificate. Make sure you turn off the CA service in bootstrap.cfg (link to docs).

)

### Move Code

(You should have already moved to directory environments in the pre-upgrade steps. Now, move the entire contents of your environments directory to `/etc/puppetlabs/code/environments`. If you need multiple groups of environments, make sure you set `environmentpath` correctly in puppet.conf.

If you're using a single main manifest across all environments, move your main manifest somewhere inside `/etc/puppetlabs/code` and make sure `default_manifest` is set correctly in puppet.conf.

Move your hiera.yaml file (link to docs) to `/etc/puppetlabs/code/hiera.yaml`.

Move your Hiera data files to somewhere inside `/etc/puppetlabs/code`, and edit hiera.yaml accordingly.


If you're using r10k or some other code deployment tool, change its configuration to use the new environments directory at `/etc/puppetlabs/code/environments`.
)

### Start Puppet Server

Puppet server won't automatically start up on system boot; you'll need to enable it. You can use `puppet resource` to do this regardless of the OS flavor you're running:

    /opt/puppetlabs/bin/puppet resource service puppetserver ensure=running enable=true

Check the logfile in `/var/log/puppetlabs/puppetserver/puppetserver.log` to make sure your agents can check in successfully.

### Confirm Agents Can Connect

Log into any agent node and run `puppet agent --test --server=<THIS SERVER>`, entering the Puppet Server's hostname or IP as `<THIS SERVER>`, and confirm the agent can retrieve and apply a catalog.

### Go Live

At this point, Puppet Server is ready to serve nodes in production. If you pulled the server back to stage the upgrade, it's safe to put the node back into play.

## Upgrade PuppetDB, if Desired

In the pre-upgrade steps, you should have already upgraded to PuppetDB 2.3.x, including the terminus package on your Puppet Server nodes. This means the upgraded Puppet Server can already communicate with your PuppetDB server.

Now that you've upgraded Puppet Server, you can upgrade PuppetDB to version 3 if you want. It has some cool improvements but also retires older API versions, which can break older integrations.

[//]: # (Link?)

You should probably use the `puppetlabs/puppetdb` module to manage your PuppetDB version. Also, note that the terminus package name has changed to `puppetdb-termini` from `puppetdb-terminus`.

[//]: # (Link?)

## You're Done!

Once you've upgraded all of your Puppet Server nodes, you can start upgrading Puppet on your agents.
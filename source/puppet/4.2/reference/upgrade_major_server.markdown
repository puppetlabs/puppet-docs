---
layout: default
title: "Puppet 3.x to 4.x: Upgrade Puppet Server and PuppetDB"
canonical: "/puppet/latest/reference/upgrade_major_server.html"
---

[moved]: ./whered_it_go.html
[ca.conf]: /puppetserver/2.1/configuration.html#caconf
[auth.conf]: ./config_file_auth.html
[`puppet.conf`]: ./config_file_main.html
[Puppet Server compatibility documentation]: /puppetserver/latest/compatibility_with_puppet_agent.html 
[main manifest]: ./dirs_manifest.html
[`default_manifest`]: ./configuration.html#defaultmanifest
[retrieve and apply a catalog]: /references/latest/man/agent.html#USAGE-NOTES
[`hiera.yaml`]: /hiera/latest/configuring.html
[Hiera]: /hiera/
[r10k]: /pe/latest/r10k.html
[`puppet-terminus`]: /puppetdb/latest/connect_puppet_master.html#on-platforms-with-packages
[`puppet-termini`]: /puppetdb/latest/connect_puppet_master.html#on-platforms-with-packages
[upgrade PuppetDB]: /puppetdb/latest/install_via_module.html

Unlike the automated upgrades of Puppet agents, Puppet Server upgrades are a manual process. There's more going on under the hood, and more decisions you need to make during the process.

This page walks you through getting an upgraded Puppet Server that can handle Puppet 3 agents. Don't start upgrading agents until after the servers are stabilized.

## Prepare to Upgrade

Before upgrading, your Puppet infrastructure should be stable and running:

* Puppet Server instead of Rack or WEBrick.
* The latest Puppet 3-compatible versions of everything you use.
* The future parser.
* Full data type support for facts.

Read our [pre-upgrade steps](./upgrade_major_pre.html) to cover these concepts. If you're having any problems with your Puppet 3 configuration, **fix them first** before upgrading.

## Plan your Upgrade

> **WARNING**: Puppet master servers are in charge of running your site, and this upgrade will interrupt their work. Bring up replacement masters and gradually cut over service to them, take a few masters out of your pool for upgrades while always leaving a few to handle traffic, or schedule downtime.
> 
> If you have multiple Puppet masters, upgrade or replace the CA master first, and pause provisioning of new Puppet agent nodes while upgrading or replacing the CA server.

## Upgrade Each Puppet Master

Repeat these steps for each Puppet Server until you're running a pure Puppet 4/Puppet Server 2.1+ infrastructure.

### Install the Latest Puppet Server

Starting with Puppet 4, our software releases are grouped into **Puppet Collections**. 

To upgrade Puppet Server, you'll need to add the Puppet Collection repository to the nodes' package managers. Follow the [Puppet Server installation instructions](./install_linux.html#install-a-release-package-to-enable-puppet-labs-package-repositories) to:

* Enable the Puppet Collection 1 repository.
* Disable any older repositories.
* Install the `puppetserver` package.

Even after you've installed the package, **don't start the `puppetserver` service yet!** There's a few other things you should do first.

### Get Familiar with the New Binary Locations

In Puppet 4, we [moved][] binaries are now at `/opt/puppetlabs/bin`, which isn't in your system's `PATH` by default. You should either:

* Add `/opt/puppetlabs/bin` to your `PATH` environment variable. There's lots of ways to accomplish this---do whatever works best for you.
* Symlink all the binaries you use into a directory in your path.
* Use the full path to run all Puppet commands (e.g. `/opt/puppetlabs/bin/puppet agent --test`).

### Reconcile `puppet.conf`

We also moved [`puppet.conf`][] to `/etc/puppetlabs/puppet/puppet.conf`, changed a lot of defaults, and removed many settings.

If you're upgrading Puppet Server:

* Open the new, relocated `puppet.conf`.
* Compare it to your old `puppet.conf`, probably at `/etc/puppet/puppet.conf`.
* Copy the modified settings you need to keep.

If this is a new node, look at the [list of important settings](./config_important_settings.html#settings-for-puppet-master-servers) for stuff you might want to set now. If you enabled the [future parser](/puppet/latest/reference/experiments_future.html), you can remove the now-unused [`parser`](/puppet/3.8/reference/config_file_environment.html#parser) setting.

### Reconcile `auth.conf`

Puppet 4 uses different HTTPS URLs to fetch configurations. Any rules in `auth.conf` that match Puppet 3-style URLs will have _no effect_. For more details, see the [Puppet Server compatibility documentation][].

You must:

* Transfer and modify [any _custom_ rules](/puppetserver/latest/compatibility_with_puppet_agent.html#transfer-and-modify-custom-authconf-rules) you've added to your old [`auth.conf`][auth.conf] file. (Don't worry about default rules.)
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

### Move Other Configuration Files

If you have other [configuration files](./configuration.html), including [`puppetdb.conf`](config_file_puppetdb.html), move them to `/etc/puppetlabs/puppet/`.

### Set up SSL

If you're upgrading a Puppet master, find the server's [`ssldir`](./dirs_ssldir.html) and copy it to the new location at `/etc/puppetlabs/puppet/ssl`.

If you're configuring an exact replacement for an older Puppet master---you're keeping the same names, certificates, and DNS configuration---copy the `ssldir` from the old server to the new one. We recommend using `rsync -a` for this, as SSL is picky about file permissions and `rsync`'s "archive" mode preserves the source's permissions at the destination.

If this is a new Puppet master but _isn't_ serving as a certificate authority, use `puppet agent` to generate a new certificate.

`puppet agent --test --certname=<NAME> --dns_alt_names=<NAME>,<NAME>,<NAME> --server=<UPGRADED CA SERVER>`

Sign the certificate on the CA, then run the above `puppet agent` command again from the new Puppet master to fetch the signed certificate. Remember to [disable the internal Puppet CA service](/puppetserver/latest/external_ca_configuration.html#disabling-the-internal-puppet-ca-service) in `bootstrap.cfg`.

### Move Code

> **Note**: You should have already switched to [directory environments](/puppet/latest/reference/environments.html) in the pre-upgrade steps, as [config file environments are deprecated](/puppet/3.8/reference/environments_classic.html#config-file-environments-are-deprecated) in Puppet 4. 

Move the contents of your old `environments` directory to `/etc/puppetlabs/code/environments`. If you need multiple groups of environments, set the `environmentpath` in `puppet.conf`.

If you're using a single [main manifest][] across all environments, move it to somewhere inside `/etc/puppetlabs/code` and confirm that [`default_manifest`][] is correctly configured in `puppet.conf`.

If you're configuring individual environments, confirm your `environment.conf` files. If you enabled the [future parser](/puppet/latest/reference/experiments_future.html) in environments, you can remove the now-unused [`parser`](/puppet/3.8/reference/config_file_environment.html#parser) setting.

If you're using [r10k][] or some other code deployment tool, change its configuration to use the new `environments` directory at `/etc/puppetlabs/code/environments`.

#### Move Hiera

If you use [Hiera][], you also need to move its configuration and data files:

1. Move your [`hiera.yaml`][] file to `/etc/puppetlabs/code/hiera.yaml`.
2. Move your Hiera data files to somewhere inside `/etc/puppetlabs/code`.
3. Update file references in `hiera.yaml` accordingly.

### Start Puppet Server

Puppet Server won't automatically start up on boot---you'll need to enable it. You can use `puppet resource` to do this regardless of your operating system or distribution:

`/opt/puppetlabs/bin/puppet resource service puppetserver ensure=running enable=true`

Once it's started, check `/var/log/puppetlabs/puppetserver/puppetserver.log` to confirm that your agents have checked in.

### Confirm Agents Can Connect

Log into any Puppet agent and test its connection to the upgraded Puppet Server:

`puppet agent --test --server=<THIS SERVER>`

Enter the Puppet Server's hostname or IP address as `<THIS SERVER>` and confirm the agent can [retrieve and apply a catalog][].

### Go Live!

At this point, Puppet Server is ready to serve nodes in production. If you pulled the server back to stage the upgrade, it's safe to push the node back into use.

## Upgrade PuppetDB, if Desired

In the pre-upgrade steps, you should have already upgraded to PuppetDB 2.3.x, including the [`puppet-terminus`][] package on your Puppet Server nodes. This means the upgraded Puppet Server can already communicate with your PuppetDB server.

Now that you've upgraded Puppet Server, you can [upgrade PuppetDB][] to version 3 if you want. Be careful: it adds some cool improvements, but it also retires older API versions, which can break older integrations.

You should use the [`puppetlabs/puppetdb`] module to manage your PuppetDB version. Also, note that the terminus package's name is now [`puppetdb-termini`][] instead of `puppetdb-terminus`.

## You're Done!

Once you've upgraded all of your Puppet Server nodes, you can start [upgrading your Puppet agents](./upgrade_major_agent.html).

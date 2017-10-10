---
layout: default
title: "Puppet 3.x to 4.x: Upgrade Puppet Server and PuppetDB"
canonical: "/puppet/latest/upgrade_major_server.html"
---

[moved]: ./whered_it_go.html
[ca.conf]: {{puppetserver}}/configuration.html#caconf
[auth.conf]: ./config_file_auth.html
[puppet.conf]: ./config_file_main.html
[Puppet Server compatibility documentation]: {{puppetserver}}/compatibility_with_puppet_agent.html
[main manifest]: ./dirs_manifest.html
[default_manifest]: ./configuration.html#defaultmanifest
[retrieve and apply a catalog]: /puppet/latest/man/agent.html#USAGE-NOTES
[hiera.yaml]: {{hiera}}/configuring.html
[Hiera]: {{hiera}}/
[r10k]: {{pe}}/r10k.html
[puppetdb-terminus]: {{puppetdb}}/connect_puppet_master.html#on-platforms-with-packages
[puppetdb-termini]: {{puppetdb}}/connect_puppet_master.html#on-platforms-with-packages
[upgrade PuppetDB]: {{puppetdb}}/install_via_module.html
[puppetdb_module]: https://forge.puppetlabs.com/puppetlabs/puppetdb
[PuppetDB 3.0 release notes]: /puppetdb/3.0/release_notes.html
[future]: /puppet/3.8/experiments_future.html

Unlike the automated upgrades of Puppet agents, Puppet Server upgrades are a manual process because you need to make more decisions during the upgrade.

An upgraded Puppet Server can handle both Puppet 3 and Puppet 4 agents. Don't start upgrading agents until after the servers are stabilized.

## Prepare to upgrade

Before upgrading, complete the [pre-upgrade steps](./upgrade_major_pre.html) to ensure your Puppet infrastructure is stable and running the following things:

* Puppet Server instead of Rack or WEBrick.
* The latest Puppet 3-compatible versions of everything you use.
* The future parser.
* Full data type support for facts.

If you're having any problems with your Puppet 3 configuration, **fix them first** before upgrading.

## Plan your upgrade

Puppet masters are in charge of managing your Puppet infrastructure, and this upgrade interrupts their work. Bring up replacement masters and gradually cut over service to them, take a few masters out of your pool for upgrades while always leaving a few to handle traffic, or schedule Puppet service downtime.

If you have multiple Puppet masters, upgrade or replace the certificate authority (CA) master first, and pause provisioning of new Puppet agents while upgrading or replacing the CA server.

## Upgrade each Puppet master

Repeat the following steps for each Puppet Server until you're running a pure Puppet 4/Puppet Server 2.1+ infrastructure.

### Install the latest Puppet Server

Starting with Puppet 4, our software releases are grouped into **Puppet Collections**.

To upgrade Puppet Server, you'll need to add the Puppet Collection repository to each node's package manager. Follow the [Puppet Server installation instructions]({{puppetserver}}/install_from_packages.html) to [enable the Puppet Collection 1 repository](./puppet_collections.html) and install the `puppetserver` package.

Even after you've installed the package, **don't start the `puppetserver` service yet**! You should do a few other things first.

### Get familiar with the new binary locations

In Puppet 4, we [moved][] all of Puppet's binaries on \*nix systems. They are now at `/opt/puppetlabs/bin`, which isn't in your system's `PATH` by default. You should do one of the following :

* Add `/opt/puppetlabs/bin` to your `PATH` environment variable. There are lots of ways to accomplish this---do whatever works best for you.
* Symlink all the binaries you use into a directory in your path.
* Use the full path to run all Puppet commands (e.g. `/opt/puppetlabs/bin/puppet agent --test`).

### Reconcile `puppet.conf`

We also moved [`puppet.conf`][puppet.conf] to `/etc/puppetlabs/puppet/puppet.conf`, changed a lot of defaults, and removed many settings. Compare the new `puppet.conf` to the old one, which is probably at `/etc/puppet/puppet.conf`, and copy over the settings you need to keep.

If you are installing Puppet Server 4 onto a new node, look at the [list of important settings](./config_important_settings.html#settings-for-puppet-master-servers) for stuff you might want to set now. You can also remove the now-unused [`parser`](/puppet/3.8/config_file_environment.html#parser) setting you enabled for the [future parser][future].

### Reconcile `auth.conf`

Puppet 4 uses different HTTPS URLs to fetch configurations. Any rules in `auth.conf` that match Puppet 3-style URLs will have _no effect_. For more details, see the [Puppet Server compatibility documentation][].

To convert the URLs:

1. Open your old [`auth.conf`][auth.conf] file, which is probably at `/etc/puppet/auth.conf`.
2. Identify [any _custom_ rules]({{puppetserver}}/compatibility_with_puppet_agent.html#transfer-and-update-authconf) you've added to your old [`auth.conf`][auth.conf] file. (Don't worry about default rules.)
3. Change the `path` of each custom rule to use Puppet 4 URLs.
    1. Add `/puppet/v3` to the beginning of most paths.
    2. Configure the `certificate_status` endpoint in `auth.conf`. Puppet Server's `ca.conf` file is [deprecated][] as of Puppet Server 2.2.
4. (Optional) Convert your rules to use new authorization methods and `auth.conf` format. See the [Puppet Server configuration documentation]({{puppetserver}}/configuration.html) for details.
5. Add the custom rules to Puppet Server's new `/etc/puppetlabs/puppet/conf.d/auth.conf` file.

#### Example `auth.conf` rules for Puppet 3 and 4 agents

The other examples in this section convert this Puppet 3 example `auth.conf` rule to be compatible with Puppet 4:

```
# Puppet 3 auth.conf on the master
path ~ ^/catalog/([^/]+).uuid$
method find
allow /^$1\.uuid.*/

# Default rule, should follow the more specific rules
path ~ ^/catalog/([^/]+)$
method find
allow $1
```

To support both Puppet 3 and Puppet 4 agents when the `use-legacy-auth-conf` parameter in the `jruby-puppet` setting is false, modify the rules to follow the new HOCON `auth.conf` format and place the new rules in `/etc/puppetlabs/puppetserver/conf.d/auth.conf`:

```
authorization: {
    version: 1
    rules: [
        ...
        {
            # Puppet 3 & 4 compatible auth.conf with Puppet Server 2.2+
            match-request: {
                path: "^/puppet/v3/catalog/([^/]+).uuid$"
                type: regex
                method: [get, post]
            }
            allow: "/^$1|.uuid.*/"
            sort-order: 200
            name: "my catalog"
        },
        {
            # Default rule, should follow the more specific rules
            match-request: {
                path: "^/puppet/v3/catalog/([^/]+)$"
                type: regex
                method: [get, post]
            }
            allow: "$1"
            sort-order: 500
            name: "puppetlabs catalog"
        },
        ...
    ]
}
```

To support both Puppet 3 and Puppet 4 agents when the `use-legacy-auth-conf` parameter in the `jruby-puppet` setting is true, modify the rules to specify the v3 endpoints while following the legacy `auth.conf` format, then place the new rules in `/etc/puppetlabs/puppet/auth.conf`:

```
# Puppet 3 & 4 compatible auth.conf with Puppet Server 2.1+
path ~ ^/puppet/v3/catalog/([^/]+).uuid$
method find
allow /^$1\.uuid.*/

# Default rule, should follow the more specific rules
path ~ ^/puppet/v3/catalog/([^/]+)$
method find
allow $1
```

### Move other configuration files

If you have [other configuration files](./config_about_settings.html#main-settings-vs-extra-config-files), including [`puppetdb.conf`](./config_file_puppetdb.html), move them to `/etc/puppetlabs/puppet/`.

### Set up SSL

If you're upgrading an existing Puppet master, find the server's [`ssldir`](./dirs_ssldir.html) and copy it to the new location at `/etc/puppetlabs/puppet/ssl`.

If you're configuring an exact replacement for an older Puppet master---you're keeping the same names, certificates, and DNS configuration---copy the `ssldir` from the old server to `/etc/puppetlabs/puppet/ssl` on the new one. We recommend using `rsync -a` for this, as SSL is picky about file permissions and `rsync`'s "archive" mode preserves the source's permissions at the destination.

If this is a new Puppet master but _isn't_ serving as a certificate authority, use `puppet agent` to request a new certificate. (You should have already upgraded the CA server.)

1. Run the following command: `puppet agent --test --certname=<NAME> --dns_alt_names=<NAME>,<NAME>,<NAME> --server=<UPGRADED CA SERVER>`

2. Sign the certificate on the CA, then run the above `puppet agent` command again from the new Puppet master to fetch the signed certificate. Remember to [disable the internal Puppet CA service]({{puppetserver}}/external_ca_configuration.html#disabling-the-internal-puppet-ca-service) in `bootstrap.cfg`.

### Move code

> **Note:** You should have already switched to [directory environments](/puppet/latest/environments.html) in the pre-upgrade steps, as [config file environments are removed](/puppet/3.8/environments_classic.html#config-file-environments-are-deprecated) in Puppet 4.

Move the contents of your old `environments` directory to `/etc/puppetlabs/code/environments`. If you need multiple groups of environments, set the `environmentpath` in `puppet.conf`.

If you're using a single [main manifest][] across all environments, move it to somewhere inside `/etc/puppetlabs/code` and confirm that [`default_manifest`][default_manifest] is correctly configured in `puppet.conf`.

If you're configuring individual environments, check your `environment.conf` files. If you enabled the [future parser][future] in environments, remove the now-unused [`parser`](/puppet/3.8/config_file_environment.html#parser) setting.

If you're using [r10k][] or some other code deployment tool, change its configuration to use the new `environments` directory at `/etc/puppetlabs/code/environments`.

#### Move Hiera

If you use [Hiera][], move its configuration and data files:

1. Make sure your [`hiera.yaml`][hiera.yaml] file is in `/etc/puppetlabs/puppet/hiera.yaml`.
2. Move your Hiera data files to somewhere inside `/etc/puppetlabs/code`.
3. Update file references in `hiera.yaml` accordingly.

>**Note**: In Puppet 4.0, the default location of hiera.yaml changed from `/etc/puppetlabs/puppet/hiera.yaml` to `/etc/puppetlabs/code/hiera.yaml`. In Puppet 4.5, its location was reverted to `/etc/puppetlabs/puppet/hiera.yaml`. If you are upgrading with a package from puppet-agent 1.5.0 or newer, it will **not** move your hiera.yaml file. If you are starting with a new installation, it will place it in the correct location.

### Start Puppet Server

Puppet Server won't automatically start up on boot---you'll need to enable it. Use `puppet resource` to do this regardless of your operating system or distribution:

``` bash
/opt/puppetlabs/bin/puppet resource service puppetserver ensure=running enable=true
```

Once Puppet Server has started, check `/var/log/puppetlabs/puppetserver/puppetserver.log` to confirm that your agents have checked in.

### Confirm agents can connect

Log into any Puppet agent and test its connection to the upgraded Puppet Server:

`puppet agent --test --server=<THIS SERVER>`

Enter the Puppet Server's hostname or IP address and confirm the agent can [retrieve and apply a catalog][].

### Go live!

At this point, Puppet Server is ready to serve nodes in production. If you pulled the server back to stage the upgrade, you can now push the node back into use.

##  Optional: Upgrade PuppetDB

In the pre-upgrade steps, you upgraded to PuppetDB 2.3.x, including the [`puppetdb-terminus`][puppetdb-terminus] package on your Puppet Servers. This means the upgraded Puppet Server can already communicate with your existing PuppetDB server.

Now that you've upgraded Puppet Server, you can [upgrade PuppetDB][] to version 3 if you want. Be careful: it adds some cool improvements, but it also retires older API versions, which can break older integrations. See the [PuppetDB 3.0 release notes][] for details.

Use the [`puppetlabs/puppetdb`][puppetdb_module] module to manage your PuppetDB version. Also, note that the terminus package's name is now [`puppetdb-termini`][puppetdb-termini] instead of `puppetdb-terminus`.

## You're done upgrading Puppet Server!

Once you've upgraded all of your Puppet Server nodes, you can start [upgrading your Puppet agents](./upgrade_major_agent.html). After you've upgraded all your nodes, follow the [post-install guide](./upgrade_major_post.html) to complete the upgrade.

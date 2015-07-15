---
layout: default
title: "Puppet 3.x to 4.x: Upgrade Puppet Server and PuppetDB"
canonical: "/puppet/latest/reference/upgrade_major_server.html"
---


(intro: upgrading your puppet server nodes is a manual process. upgrading agents is automated, but puppet masters are just more complicated.

at the end of this page, you'll have Puppet 4.x servers handling Puppet 3.x agent nodes. you'll only start upgrading agents after the servers are stabilized.

make sure you did the pre-upgrade steps first, and have been running for a while with:

- the latest 3.x-compatible versions of everything
- the future parser
- full data type support for facts
- Puppet Server instead of Rack

...with no problems.
)

## Decide on an Upgrade Plan

(big loud warning: upgrading Puppet Server can cause an interruption of service if you're upgrading existing servers. They're in charge of making sure everything is fine at their site -- either bring up replacement masters and gradually cut over service to them, or take a few masters out of your pool to upgrade, leaving a few to continue handling traffic, or just accept a short interruption.

If you have multiple masters, upgrade or replace the CA puppet master first. Make sure you pause provisioning of new puppet agent nodes while you're upgrading or replacing the CA server.
)


## Upgrade Each Puppet Server Node

(Do this until you're running a pure Puppet 4.x / Puppet Server 2.x infrastructure.)

### Install the Latest Puppet Server (2.1 or Higher)

(brief explanation
    (enable PC1 repo, stop service, install package, don't start service back up yet)

Link to Puppet Server 2.1 install page)

### Get Familiar with the New Binary Locations

(All binaries are now under `/opt/puppetlabs/bin`. This isn't in your `PATH` by default, so you'll need to either add it to your path, symlink all the binaries you care about into some directory that IS in your path, or use the full path to all Puppet commands (e.g. `/opt/puppetlabs/bin/puppet agent --test`).

### Reconcile puppet.conf

(Puppet.conf's new location is /etc/puppetlabs/puppet/puppet.conf. A lot of defaults changed, and a lot of settings got removed.

If this is an existing node being upgraded, open your new puppet.conf at /etc/puppetlabs/puppet/puppet.conf, compare it to your old puppet.conf (probably at /etc/puppet/puppet.conf), and copy over the modified settings you actually care about.

If this is a new node, look at the list of important settings (link) for stuff you might want to set now.

)

### Reconcile auth.conf

(pasting in stuff from Puppet Server compatibility docs; modify if you need to. Also, note that the location changed: it's /etc/puppetlabs/puppet/auth.conf now, and was probably /etc/puppet/auth.conf before.)

[ca.conf]: /puppetserver/2.1/configuration.html#caconf
[auth.conf]: ./config_file_auth.html


Puppet 3 and 4 use different HTTPS URLs to fetch configurations. Puppet Server lets agents make requests at the old URLs, but internally it handles them as requests to the new endpoints. Any rules in auth.conf that match Puppet 3-style URLs will have _no effect._

This means you must:

* Find any _custom_ rules you've added to your [auth.conf file][auth.conf]. (Don't worry about default rules.)
* Change each `path` to match Puppet 4 URLs.
    * Add `/puppet/v3` to the beginning of most paths.
    * The `certificate_status` endpoint ignores auth.conf; configure access in Puppet Server's [ca.conf][] file.
* Add the rules to `/etc/puppetlabs/puppet/auth.conf` on your Puppet Server.

For more information, see:

* [Puppet's HTTPS API (current)](./http_api/http_api_index.html)
* [Puppet's HTTPS API (3.x)](https://github.com/puppetlabs/puppet/blob/3.8.0/api/docs/http_api_index.md)
* [Default Puppet 4.2.0 auth.conf](https://github.com/puppetlabs/puppet/blob/4.2.0/conf/auth.conf)
* [Default Puppet 3.8.0 auth.conf](https://github.com/puppetlabs/puppet/blob/3.8.0/conf/auth.conf)

#### auth.conf Rule Example

Puppet 3 rules:

    # Puppet 3 auth.conf on the master
    path ~ ^/catalog/([^/]+).uuid$
    method find
    allow /^$1\.uuid.*/

    # Default rule, should follow the more specific rules
    path ~ ^/catalog/([^/]+)$
    method find
    allow $1

Puppet Server 2 rules supporting both 3.x and 4.x agent nodes:

    # Puppet 3 & 4 compatible auth.conf with Puppet Server 2.1
    path ~ ^/puppet/v3/catalog/([^/]+).uuid$
    method find
    allow /^$1\.uuid.*/

    # Default rule, should follow the more specific rules
    path ~ ^/puppet/v3/catalog/([^/]+)$
    method find
    allow $1


### Migrate Other Config Files

(You might have other config files, including puppetdb.conf. link here to the pages about configuration files. Move all of them over into the new confdir, /etc/puppetlabs/puppet/.)

### Set up SSL

(This varies, depending on what's going on:

- If this is an existing puppet master being upgraded, find the ssldir (link to page about ssldir) and copy it to the new location at `/etc/puppetlabs/puppet/ssl`.
- If this is an exact replacement for a prior server, keeping the same names etc., copy the ssldir from the old server to the new one. We recommend using `rsync -a` for this: SSL is picky about file permissions, and rsync's "archive" mode will preserve the permissions on the files.
- If this is a new puppet master server but it's NOT serving as a CA, run `puppet agent --test --certname=<NAME> --dns_alt_names=<NAME>,<NAME>,<NAME> --server=<UPGRADED CA SERVER>`, sign the certificate on the CA, and run that puppet agent command again to fetch the signed certificate. Make sure you turn off the CA service in bootstrap.cfg (link to docs).

)

### Migrate Code

(You should have already migrated to directory environments in the pre-upgrade steps. Now, move the entire contents of your environments directory to `/etc/puppetlabs/code/environments`. If you need multiple groups of environments, make sure you set `environmentpath` correctly in puppet.conf.

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

(Log into some random agent node and point it at this specific upgraded server node, with `puppet agent --test --server=<THIS SERVER>`. Make sure it's able to retrieve and apply a catalog like normal.)

### Go Live

(If you removed this server node from your load balancer, or brought up a new node, or whatever, do whatever you have to do to get it serving nodes in production. This might be changing DNS, configuring your load balancer, or something else; if you built it, we assume you know how to reconfigure it.)

## Upgrade PuppetDB, if Desired

(In the pre-upgrade steps, you should have already upgraded to PuppetDB 2.3, including upgrading the terminus package on your Puppet Server nodes. This means the upgraded Puppet Server can already talk to your PuppetDB server as soon as it starts up.

Now, though, you have the option of upgrading to PuppetDB 3.x. Do that, if you want. It has some cool improvements, but might break older integrations since it retires several older API versions.

You should probably use the puppetlabs/puppetdb module (link) to manage your PuppetDB version. Also, note that the terminus package name has changed to `puppetdb-termini` from `puppetdb-terminus`.

)

## Next

(You have now upgraded all your Puppet Server nodes. Now you can upgrade Puppet on your agent nodes. (link) )


---
layout: default
title: "Puppet 3.x to 4.x: Get upgrade-ready"
---

Upgrading from Puppet 3 to Puppet 4 is a major upgrade with lots of configuration and functionality changes. Thoroughly read the release notes for each feature release in Puppet 4, particularly any about backwards-incompatible changes. To ease the upgrade process, split it into smaller tasks. Confirm that your system remains functional after each task before moving to the next.


## Updating to the latest Puppet Server 1.1.x, Puppet 3.8.x, and PuppetDB 2.3.x

>**Before you begin:** Ensure all your Puppet components are running the latest Puppet 3 versions, checking and updating in the following order.

**Note**: PuppetDB remains optional, and you can skip it if you don't use it.

1. If you already use Puppet Server, update it across your infrastructure to the latest 1.1.x release.
2. If you're still using Rack or WEBrick to run your Puppet master, [switch to Puppet Server](/puppetserver/1.1/install_from_packages.html). Puppet Server is designed to be a better-performing drop-in replacement for Rack and WEBrick Puppet masters, which are [deprecated as of Puppet 4.1](/puppet/4.1/release_notes.html#deprecated-rack-and-webrick-web-servers-for-puppet-master).

  **This is a big change!** Make sure you can successfully switch to Puppet Server 1.1.x before tackling the Puppet 4 upgrade.

  - Check out [our overview](/puppetserver/1.1/puppetserver_vs_passenger.html) of what sets Puppet Server apart from a Rack Puppet master.
  - Puppet Server uses 2GB of memory by default. Depending on your server's specs, you might have to adjust [how much memory you allocate](/puppetserver/1.1/install_from_packages.html#memory-allocation) to Puppet Server before you launch it.
  - If you run multiple Puppet masters with a single certificate authority, you'll need to edit Puppet Server's `bootstrap.cfg` to [disable the CA service](/puppetserver/1.1/external_ca_configuration.html#disabling-the-internal-puppet-ca-service). You'll also need to ensure you're routing traffic to the appropriate node with a load balancer or the agents' [`ca_server`](./configuration.html#caserver) setting.
3. Update all Puppet agents to the latest 3.8.x release.
4. If you use PuppetDB, [update it](/puppetdb/2.3/upgrade.html) to the latest 2.3.x release, then [update the PuppetDB terminus plugins](/puppetdb/2.3/upgrade.html#upgrading-the-terminus-plugins) on your Puppet Server node to the same release.
    - Puppet Server 1.x and 2.x look for the PuppetDB termini in two different places. The 2.3.x `puppetdb-terminus` package installs the termini in both of them, so the server is able to find the plugins after you upgrade.

## Checking for deprecated features

[deprecations]: /puppet/3.8/deprecated_summary.html

Puppet 3.8 deprecated several features which are either removed from Puppet 4 or require major workflow changes.

1. Read our [lists of deprecated features][deprecations].
2. If you're using any of them, follow steps for migrating away from them.

## Converting facts, and checking for breakage

Puppet 4 always uses proper data types for facts, but Puppet 3 converts all facts to Strings by default. If any of your modules or manifests rely on this behavior, you need to adjust them before you upgrade.

If you've already set [`stringify_facts = false`](/puppet/3.8/deprecated_settings.html#stringifyfacts--true) in `puppet.conf` on every node in your deployment, skip to the next section. Otherwise:

1. Check your Puppet code for any comparisons that _treat boolean facts like strings,_ like `if $::is_virtual == "true" {...}`, and change them so they'll work with true Boolean values.
  - If you need to support Puppet 3 and 4 with the same code, you can instead use something like `if str2bool("$::is_virtual") {...}`.
2. Next, set `stringify_facts = false` in `puppet.conf` on every node in your deployment.
   * To have Puppet change this setting, use an [`inifile` resource](https://forge.puppetlabs.com/puppetlabs/inifile).
3. Watch the next set of Puppet runs for any problems with your code changes.
4. Repeat until all of your Puppet code is working correctly!

## Enabling directory environments and moving code into them

Puppet 4 organizes all code into directory environments, which are the only way to organize code now that config file environments are removed.

[envs_config]: /puppet/3.8/environments_configuring.html

1. If you're using config file environments, [switch to directory environments.][envs_config]

If you don't currently use environments, [enable directory environments][envs_config] and move everything into the default `production` environment.

## Enabling the future parser and fixing broken code

The [future parser](/puppet/3.8/experiments_future.html) in Puppet 3 is the current parser in Puppet 4. If you haven't [enabled the future parser](/puppet/3.8/experiments_future.html#enabling-the-future-parser) yet, do so now and check for problems in your current Puppet code during the next Puppet run.

To change the parser per-environment:

1. Create a test [directory environment](./environments.html) that duplicates your production environment.
2. Set `parser = future` in the test environment's `environment.conf`.
3. Run nodes in the test environment and confirm they still get good catalogs.
4. Based on the result, make any necessary adjustments to your Puppet code.
5. Once the environment is in good shape, set `parser = future` in `puppet.conf` on all Puppet master nodes to make the change global.

Some of the changes to look out for include:

- Changes to comparison operators, particularly:
  - The `in` operator ignoring case when comparing strings.
  - Incompatible data types no longer being comparable.
  - New rules for converting values to Boolean (for example, empty strings are now true).
- Facts having additional data types.
- Quoting required for octal numbers in `file` resources' `mode` attributes.

For a more complete list, see [Updating 3.x Manifests for Puppet 4.x.](./lang_updating_manifests.html)

Run Puppet for several runs with the future parser enabled to ensure your changes won't fail in production.

## Finishing upgrade prep

1. Read the release notes for each Puppet 4 feature release version and prepare accordingly.
   Puppet 4.0 introduces several breaking changes, some of which didn't go through a formal deprecation period---for example, we moved the [tagmail report handler](/puppet/3.8/lang_tags.html#sending-tagmail-reports) out of Puppet's core and into an optional [module](https://forge.puppetlabs.com/puppetlabs/tagmail). 

## You're ready!

If your Puppet 3 system is updated and tuned for the upgrade, you're ready to proceed.

1. Upgrade to Puppet Server 2.2 or higher; see the [Server upgrade guide](./upgrade_major_server.html).
2. Upgrade your agent nodes; see the [Agent upgrade guide](./upgrade_major_agent.html).

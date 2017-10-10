---
layout: default
title: "Puppet 3.x to 4.x: Get Upgrade-Ready"
canonical: "/puppet/latest/upgrade_major_pre.html"
---

Puppet 4 is a major upgrade with lots of configuration and functionality changes. Since Puppet is likely managing your entire infrastructure, it should be **upgraded with care**. Specifically, you should try to:

- Split the upgrade process into smaller tasks.
- Confirm that your system remains functional after each task.
- Thoroughly read the release notes, particularly any about backwards-incompatible changes.

This page provides steps you should take before starting the upgrade to help prepare for a safe transition. See the navigation to the left for the actual upgrade steps and post-upgrade tasks.

## Update to the Latest Server 1.1.x, Puppet 3.8.x, and PuppetDB 2.3.x

Before upgrading from Puppet 3 to 4, make sure all your Puppet components are running the latest Puppet 3 versions, checking and updating in the following order.

**Note**: PuppetDB remains optional, and you can skip it if you don't use it.

- If you already use Puppet Server, update it across your infrastructure to the latest 1.1.x release.
- If you're still using Rack or WEBrick to run your Puppet master, this is the best time to [switch to Puppet Server](/puppetserver/1.1/install_from_packages.html). Puppet Server is designed to be a better-performing drop-in replacement for Rack and WEBrick Puppet masters, which are [deprecated as of Puppet 4.1](/puppet/4.1/release_notes.html#deprecated-rack-and-webrick-web-servers-for-puppet-master).
  - **This is a big change!** Make sure you can successfully switch to Puppet Server 1.1.x before tackling the Puppet 4 upgrade.
  - Check out [our overview](/puppetserver/1.1/puppetserver_vs_passenger.html) of what sets Puppet Server apart from a Rack Puppet master.
  - Puppet Server uses 2GB of memory by default. Depending on your server's specs, you might have to adjust [how much memory you allocate](/puppetserver/1.1/install_from_packages.html#memory-allocation) to Puppet Server before you launch it.
  - If you run multiple Puppet masters with a single certificate authority, you'll need to edit Puppet Server's `bootstrap.cfg` to [disable the CA service](/puppetserver/1.1/external_ca_configuration.html#disabling-the-internal-puppet-ca-service). You'll also need to ensure you're routing traffic to the appropriate node with a load balancer or the agents' [`ca_server`](./configuration.html#caserver) setting.
- Update all Puppet agents to the latest 3.8.x release.
- If you use PuppetDB, [update it](/puppetdb/2.3/upgrade.html) to the latest 2.3.x release, then [update the PuppetDB terminus plugins](/puppetdb/2.3/upgrade.html#upgrading-the-terminus-plugins) on your Puppet Server node to the same release.
    - Puppet Server 1.x and 2.x look for the PuppetDB termini in two different places. The 2.3.x `puppetdb-terminus` package installs the termini in both of them, so the server will still be able to find the plugins after you upgrade.

## Check for Deprecated Features

[deprecations]: /puppet/3.8/deprecated_summary.html

Puppet 3.8 [deprecated several features][deprecations] which are either removed from Puppet 4 or require major workflow changes. Read our [lists of deprecated features][deprecations], and if you're using any of them, follow our advice for migrating away from them.

## Stop Stringifying Facts, and Check for Breakage

Puppet 4 always uses proper [data types](./lang_data.html) for facts, but Puppet 3 converts all facts to Strings by default. If any of your modules or manifests rely on this behavior, you'll need to adjust them before you upgrade.

If you've already set [`stringify_facts = false`](/puppet/3.8/deprecated_settings.html#stringifyfacts--true) in `puppet.conf` on every node in your deployment, skip to the [next section](#enable-directory-environments-and-move-code-into-them). Otherwise:

- Check your Puppet code for any comparisons that _treat boolean facts like strings,_ like `if $::is_virtual == "true" {...}`, and change them so they'll work with true Boolean values.
  - If you need to support Puppet 3 and 4 with the same code, you can instead use something like `if str2bool("$::is_virtual") {...}`.
- Next, set `stringify_facts = false` in `puppet.conf` on every node in your deployment. To have Puppet change this setting, use an [`inifile` resource](https://forge.puppetlabs.com/puppetlabs/inifile).
- Watch the next set of Puppet runs for any problems with your code.
- Repeat until all of your Puppet code is working correctly!

## Enable Directory Environments and Move Code into Them

Puppet 4 organizes all code into [directory environments](./environments.html), which are the only way to organize code now that [config file environments are removed](/puppet/3.8/environments_classic.html#config-file-environments-are-deprecated).

[envs_config]: /puppet/3.8/environments_configuring.html

If you're using config file environments, [switch to directory environments now.][envs_config]

If you don't currently use environments, [enable directory environments][envs_config] and move everything into the default `production` environment.

## Enable the Future Parser and Fix Broken Code

The [future parser](/puppet/3.8/experiments_future.html) in Puppet 3 is the current parser in Puppet 4. If you haven't [enabled the future parser](/puppet/3.8/experiments_future.html#enabling-the-future-parser) yet, do so now and check for problems in your current Puppet code during the next Puppet run.

To change the parser per-environment:

1. Create a test [directory environment](./environments.html) that duplicates your production environment.
2. Set `parser = future` in the test environment's `environment.conf`.
3. Run nodes in the test environment and confirm they still get good catalogs.
4. Based on the result, make any necessary adjustments to your Puppet code.
5. Once the environment is in good shape, set `parser = future` in `puppet.conf` on all Puppet master nodes to make the change global.

Some of the changes to look out for include:

- [Changes to comparison operators](/puppet/3.8/experiments_future.html#check-your-comparisons), particularly
  - The `in` operator ignoring case when comparing strings.
  - Incompatible data types no longer being comparable.
  - New rules for converting values to Boolean (for example, empty strings are now true).
- [Facts having additional data types](/puppet/3.8/experiments_future.html#check-your-comparisons).
- [Quoting required for octal numbers in `file` resources' `mode` attributes](/puppet/3.8/experiments_future.html#quote-any-octal-numbers-in-file-modes).

Run Puppet for a while with the future parser enabled to ensure you've got any kinks worked out.

## Read the Puppet 4.x Release Notes

Puppet 4.0 introduces several breaking changes, some of which didn't go through a formal deprecation period---for example, we moved the [tagmail report handler](/puppet/3.8/lang_tags.html#sending-tagmail-reports) out of Puppet's core and into an optional [module](https://forge.puppetlabs.com/puppetlabs/tagmail). Read the release notes for [4.0](/puppet/4.0/release_notes.html), [4.1](/puppet/4.1/release_notes.html), [4.2](/puppet/4.2/release_notes.html), [4.3](/puppet/4.3/release_notes.html) [4.4](./release_notes.html) and prepare accordingly.

## You're Ready!

If your Puppet 3 system is updated and tuned for the upgrade, you're ready to proceed.

* Start by upgrading to Puppet Server 2.2 or higher; see the [Server upgrade guide](./upgrade_major_server.html).
* Once Puppet Server is upgraded, upgrade your agent nodes; see the [Agent upgrade guide](./upgrade_major_agent.html).

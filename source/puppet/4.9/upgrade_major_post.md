---
layout: default
title: "Puppet 3.x to 4.x: Post-upgrade clean-up"
---

[moved]: ./whered_it_go.html

After upgrading, you should do a few more things to make Puppet 4 easier to maintain.

## Reconfigure systems that use Puppet's data

Puppet 4 [changes the locations of many configuration files][moved]. If you have any other systems that reuse Puppet's SSL credentials, configuration data, or generated data, point them to the new directories.

## Update backup jobs

If you back up data in directories that [moved][] (like `/etc/puppet`, whose contents are now split between `/etc/puppetlabs/puppet` and `/etc/puppetlabs/code`), update your backup jobs to use the new locations.

## Delete the `/etc/puppet` directory on \*nix systems

Avoid maintenance and configuration confusion by deleting the old `/etc/puppet` directory on your \*nix systems. This prevents other systems from using stale data and protects sysadmins from accidentally updating the wrong copies of files.

## Delete the per-environment `parser` setting

If you set the [`parser`](/puppet/3.8/config_file_environment.html#parser) setting in `environment.conf` as part of your [upgrade preparations](./upgrade_major_pre.html), remove it from all environments. The setting is  inert, but Puppet will log warnings until it's gone.

## Unassign `puppet_agent` class from nodes

The [`puppet_agent` module](https://forge.puppetlabs.com/puppetlabs/puppet_agent) doesn't affect nodes running Puppet 4, and you can unassign it from all nodes after your entire Puppet infrastructure is upgraded.

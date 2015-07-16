---
layout: default
title: "Puppet 3.x to 4.x: Post-Upgrade Clean-Up"
canonical: "/puppet/latest/reference/upgrade_major_post.html"
---


(intro: There are some extra things you might want to deal with after Puppet is upgraded and running normally. )


## Reconfigure Systems that Use Puppet's Data

If you have any other systems that re-use Puppet's SSL credentials, configuration data, or generated data, make sure you configure them to use the new directories.

(link to the where'd everything go page)

## Update Backup Jobs

If you were backing up data in directories that moved (like `/etc/puppet`, whose contents are now split between `/etc/puppetlabs/puppet` and `/etc/puppetlabs/code`), make sure you update your backup jobs to use the new locations.

## Delete the `/etc/puppet` Directory (Skip on Windows)

To avoid confusion, you should delete the old `/etc/puppet` directory on your \*nix systems. This will prevent other systems from using stale data, and protect sysadmins from accidentally updating the wrong copies of files.

## Delete Per-Environment `parser` Setting

If you set the `parser` setting in `environment.conf` (link to page about file) as part of your upgrade preparations, you should now remove it from all environments. The setting is now inert, but Puppet will log warnings until it's gone.

## Unassign `puppet_agent` Class From Nodes

The `puppet_agent` class has no effect on nodes that are already running Puppet 4.x. Once your entire deployment is upgraded, you can unassign it from all nodes.


---
layout: default
title: "PE 3.8 » Installing » Upgrading (Puppet Server Notes)"
subtitle: "About the Puppet Server"
canonical: "/pe/latest/puppet_server_notes.html"
---


PE 3.8 uses Puppet Server, a replacement for the former Apache/Passenger Puppet master stack. However, due to this change in the underlying architecture of the Puppet master, there are a few changes you'll notice after upgrading that we'd like to point out.

This page details some items that are intentionally different between Puppet Server and the old Apache/Passenger stack. Additionally, there are [a few known issues related to Puppet Server](./release_notes_known_issues.html#known-issues-related-to-puppet-server) which  we expect to fix in future releases.

> **Tip**: More information about Puppet Server can be found in the [Puppet Server docs](/puppetserver/1.0/services_master_puppetserver.html). Differences between PE and open source versions of Puppet Server are typically called out.

### Service Name Changed From `pe-httpd` to `pe-puppetserver`

Previously, the service that acted as the Puppet master was called `pe-httpd`. (So to restart the Puppet master, you would run `service httpd restart`.)

In PE 3.8 the Puppet master service is now `pe-puppetserver`, and you can restart it with `service pe-puppetserver restart`.

### Updating Puppet Master Gems

After upgrading to PE 3.8, you need to update the Ruby gems used by your Puppet Master with `/opt/puppet/bin/puppetserver gem install <GEM NAME>`.

Refer to [Updating Puppet Master Gems](./release_notes_known_issues.html#updating-puppet-master-gems) for more information. If you're running Puppet Server behind a proxy, refer to the [workaround](./release_notes_known_issues.html#installing-gems-when-puppet-server-is-behind-a-proxy-requires-manual-download-of-gems) in the release notes.

### New Config Files

Although Puppet Server honors nearly all settings in `puppet.conf`, it moves some the configuration of some features (mostly web server configuration and setting up an external CA) to a group of new config files.

For details about these files, see [Configuring Puppet Server](./puppet_server_config_files.html) in the Puppet Core section of the docs.

## Certain Changes Require Service Restarts

You'll need to restart `pe-puppetserver`  any time you make changes to the config files in `/etc/puppetserver/conf.d`.

You should also restart when making changes to [environments with a long or unlimited `environment_timeout` value.](/puppet/3.8/reference/environments_configuring.html#environmenttimeout) (This is because Puppet Server can have multiple timers running for a given environment --- if a node checks in twice before _all_ of the timers have expired, it can receive inconsistent configurations.)

### Startup and Restarts Take Longer

Puppet Server takes a bit longer to start up than the Apache/Passenger stack. You’ll  see significant performance improvements after start up, but the initial start up is definitely a bit slower.

### Other Changes to Puppet Services

A few other changes/additions have been made to the services running ont the Puppet master due to the introduction of Puppet Server. You can read about these in the [Puppet Server docs](/puppetserver/1.0/services_master_puppetserver.html#puppet's-services:-puppet-server).

Notable changes include:

* Changes to the [Ruby interpreter running on the Puppet master](/puppetserver/1.0/services_master_puppetserver.html#jruby-interpreters)

* Changes to the [certificate authority service](/puppetserver/1.0/services_master_puppetserver.html#certificate-authority-service)






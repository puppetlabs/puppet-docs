---
layout: default
title: "PE 3.2 » Troubleshooting » Troubleshooting the Console & Database "
subtitle: "Finding Common Problems"
canonical: "/pe/latest/trouble_console-db.html"
---

Below are some common issues that can cause trouble with the databases that support the console.

**Note:** If you will be using your own instance of PostgreSQL (as opposed to the instance PE can install) for the console and PuppetDB, it must be version 9.1 or higher.


Disabling/Enabling Live Management
-------

Live management is enabled in the console by default when you install PE, but you can configure your installation to disable it. In addition, live management can be disabled/enabled during [upgrades][install_upgrade] or [normal operations][normal_operations]. 

[install_upgrading]: ./install_upgrading.html#disabling/enabling-live-management-during-an-upgrade
[normal_operations]: ./console_navigating_live_mgmt.html#disabling/enabling-live-management				

PostgreSQL is Taking Up Too Much Space
-----			

PostgreSQL should have `autovacuum=on` set by default. If you're having memory issues from the database growing too large and unwieldy, make sure this setting did not get turned off. PE also includes a rake task for keeping the databases in good shape. The [console maintenance page](./maintain_console-db.html#optimizing-the-database) has the details.

Recovering from a Lost Console Admin Password
-----

If you have forgotten the password of the console's initial admin user, you can [create a new admin user](./console_auth.html#working-with-users-from-the-command-line) and use it to reset the original admin user's password.

On the console server, run the following commands:

    $ cd /opt/puppet/share/puppet-dashboard
    $ sudo /opt/puppet/bin/bundle exec /opt/puppet/bin/rake -s -f /opt/puppet/share/console-auth/Rakefile db:create_user USERNAME=<adminuser@example.com> PASSWORD=<password> ROLE="Admin" RAILS_ENV=production

You can now log in to the console as the user you just created, and use the normal admin tools to reset other users' passwords.

`Puppet resource` Generates Ruby Errors After Connecting `puppet apply` to PuppetDB
-----

Users who wish to use `puppet apply` (typically in deployments running masterless puppet), need to get it working with PuppetDB. If they do so by modifying `puppet.conf` to add the parameters `storeconfigs_backend = puppetdb` and `storeconfigs = true` in both the [main] and [master] sections), then `puppet resource` will cease to function and will display a Ruby run error. To avoid this, the correct way to get `puppet apply` connected to PuppetDB is to modify `/etc/puppetlabs/puppet/routes.yaml ` to correctly define the behavior of `puppet apply` without affecting other functions. The PuppetDB manual has [complete information and code samples](http://docs.puppetlabs.com/puppetdb/1.5/connect_puppet_apply.html).  

The Console Has Too Many Pending Tasks
-----

The console either does not have enough worker processes, or the worker processes have died and need to be restarted.

* [See here to restart the worker processes](./maintain_console-db.html#restarting-the-background-tasks)
* [See here to tune the number of worker processes](./console_config.html#fine-tuning-the-delayedjob-queue)

Old "Pending Tasks" Never Expire
-----

In earlier versions of PE 3.x, failed delayed jobs did not get properly deleted. If a report for a job failed to upload (due to a problem with the report itself), a pending task would be displayed in the console in perpetuity. This has been fixed in PE 3.1. The "Background Tasks" pane in the console (upper left corner) now displays a red alert icon when a report fails to upload. Clicking the icon displays a view with information about the failure and a backtrace. You can stop the reports from showing the alert by marking them as read with the "Mark all as read" button. 

Note, however, that this will not remove old failed/delayed jobs. You can clean these out by running `/opt/puppet/bin/bundle exec rails runner 'Delayed::Job.delete_all("attempts >= 3")'` on the console node. This command should be run from `/opt/puppet/share/puppet-dashboard`.

Console Account Confirmation Emails Have Incorrect Links
-----

This can happen if the console's authentication layer thinks it lives on a hostname that isn't accessible to the rest of the world. The authentication system's hostname is automatically detected during installation, and the installer can sometimes choose an internal-only hostname.

To fix this:

1. Open the `/etc/puppetlabs/console-auth/cas_client_config.yml` file for editing. Locate the `cas_host` line, which is likely commented-out:

        authentication:

          ## Use this configuration option if the CAS server is on a host different
          ## from the console-auth server.
          # cas_host: console.example.com:443

    Change its value to contain the **public hostname** of the console server, including the correct port.
2. Open the `/etc/puppetlabs/console-auth/config.yml` file for editing. Locate the `console_hostname` line:

        authentication:
          console_hostname: console.example.com

    Change its value if necessary. If you are serving the console on a port other than 443, be sure to add the port. (For example: `console.example.com:3000`)
    
Correcting Broken URLs in the Console
----------------

Starting with PE 3.0 and later, group names with periods in them (e.g., group.name) will generate a "page doesn't exist" error. To remove broken groups, you can use the following nodegroup:del rake task:

        $ sudo /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production nodegroup:del name={bad.group.name.here}

After you remove the broken group names, you can create new groups with valid names and re-add your nodes as needed.

* * *

- [Next: Troubleshooting Orchestration](./trouble_orchestration.html)

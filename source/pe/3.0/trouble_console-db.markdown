---
layout: default
title: "PE 3.0 » Troubleshooting » Troubleshooting the Console & Database "
subtitle: "Finding Common Problems"
canonical: "/pe/latest/trouble_console-db.html"
---

Below are some common issues that can cause trouble with the databases that support the console.

**Note:** If you will be using your own instance of PostgreSQL (as opposed to the instance PE can install) for the console and PuppetDB, it must be version 9.1 or higher.

PostgreSQL is Taking Up Too Much Space
-----

PostgreSQL should have `autovacuum=on` set by default. If you're having memory issues from the database growing too large and unwieldy, make sure this setting did not get turned off. PE also includes a rake task for keeping the databases in good shape. The [console maintenance page](./maintain_console-db.html#optimizing-the-database) has the details.

PostgreSQL Buffer Memory Causes PE Install to Fail
------- 

In some cases, when installing PE on machines with large amounts of RAM, the PostgreSQL database will use more shared buffer memory than is available and will not be able to start. This will prevent PE from installing correctly. The following error will be present in `/var/log/pe-postgresql/pgstartup.log`:

    FATAL: could not create shared memory segment: No space left on device
    DETAIL: Failed system call was shmget(key=5432001, size=34427584512,03600).

A suggested workaround is tweak the machine's `shmmax` and `shmall` kernel settings before installing PE. The `shmmax` setting should be set to approximately  50% of the total RAM; the `shmall` setting can be calculated by dividing the new `shmmax` setting by the PAGE_SIZE.  (`PAGE_SIZE` can be confirmed by running `getconf PAGE_SIZE`).

Use the following commands to set the new kernel settings:

    sysctl -w kernel.shmmax=<your shmmax calculation>
    sysctl -w kernel.shmall=<your shmall calculation>

Alternatively, you can also report the issue to the [Puppet Labs customer support portal](https://support.puppetlabs.com/access/unauthenticated). 

Recovering from a Lost Console Admin Password
-----

If you have forgotten the password of the console's initial admin user, you can [create a new admin user](./console_auth.html#working-with-users-from-the-command-line) and use it to reset the original admin user's password.

On the console server, run the following commands:

    $ cd /opt/puppet/share/puppet-dashboard
    $ sudo /opt/puppet/bin/bundle exec /opt/puppet/bin/rake -s -f /opt/puppet/share/console-auth/Rakefile db:create_user USERNAME=<adminuser@example.com> PASSWORD=<password> ROLE="Admin" RAILS_ENV=production

You can now log in to the console as the user you just created, and use the normal admin tools to reset other users' passwords.

The Console Has Too Many Pending Tasks
-----

The console either does not have enough worker processes, or the worker processes have died and need to be restarted.

* [See here to restart the worker processes](./maintain_console-db.html#restarting-the-background-tasks)
* [See here to tune the number of worker processes](./console_config.html#fine-tuning-the-delayedjob-queue)

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

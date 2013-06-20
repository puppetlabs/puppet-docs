---
layout: default
title: "PE 3.0 » Troubleshooting » Troubleshooting the Console & Database "
subtitle: "Troubleshooting the Console & Database"
---

PostgreSQL is Taking Up Too Much Space
-----

PostgreSQL should have `autovacuum=on` set by default. If you're having memory issues from the database growing too large and unwieldy, make sure this setting did not get turned off.

Recovering from a Lost Console Admin Password
-----

If you have forgotten the password of the console's initial admin user, you can [create a new admin user](./console_auth.html#creating-users-from-the-command-line) and use it to reset the original admin user's password.

On the console server, run the following commands:

    $ cd /opt/puppet/share/console-auth
    $ sudo /opt/puppet/bin/rake db:create_user USERNAME="adminuser@example.com" PASSWORD="<password>" ROLE="Admin"

You can now log in to the console as the user you just created, and use the normal admin tools to reset other users' passwords.

The Console Has Too Many Pending Tasks
-----

The console either does not have enough worker processes, or the worker processes have died and need to be restarted.

* [See here to restart the worker processes](./console_maintenance.html#restarting-the-background-tasks)
* [See here to tune the number of worker processes](./config_advanced.html#fine-tuning-the-delayedjob-queue)

Console Account Confirmation Emails Have Incorrect Links
-----

This can happen if the console's authentication layer thinks it lives on a hostname that isn't accessible to the rest of the world. The authentication system's hostname is automatically detected during installation, and the installer can sometimes choose an internal-only hostname.

To fix this:

1. Open the `/etc/puppetlabs/console_auth/cas_client_config.yml` file for editing. Locate the `cas_host` line, which is likely commented-out:

        authentication:

          ## Use this configuration option if the CAS server is on a host different
          ## from the console-auth server.
          # cas_host: console.example.com:443

    Change its value to contain the **public hostname** of the console server, including the correct port.
2. Open the `/etc/puppetlabs/console_auth/config.yml` file for editing. Locate the `console_hostname` line:

        authentication:
          console_hostname: console.example.com

    Change its value if necessary. If you are serving the console on a port other than 443, be sure to add the port. (For example: `console.example.com:3000`)

* * * 

- [Next: ](./foo.html)

---
layout: pe2experimental
title: "PE 2.0 » Maintenance and Troubleshooting » Reconfiguring PE"
---

Reconfiguring Complex Settings
=====

During installation, you make several major decisions that affect the way Puppet Enterprise works. Several of these decisions can be changed after the fact. 

Changing the Console's Port
-----

By default, a new installation of PE will serve the console on port 443. However, previous versions of PE served the console's predecessor on port 3000. If you upgraded and want to change to the more convenient new default, or if you need port 443 for something else and want to shift the console somewhere else, perform the following steps:

* Stop the `pe-httpd` service:

        $ sudo /etc/init.d/pe-httpd stop
* Edit `/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf` on the console server, and change the port number in the `Listen 443` and `<VirtualHost *:443>` directives. (These directives will contain the current port, which is not necessarily 443.)
* Edit `/etc/puppetlabs/puppet/puppet.conf` on the puppet master server, and change the `reporturl` setting to use your preferred port.
* Edit `/etc/puppetlabs/puppet-dashboard/external_node` on the puppet master server, and change the `ENC_BASE_URL` to use your preferred port. 
* Make sure to allow access to the new port in your system's firewall rules.
* Start the `pe-httpd` service:

        $ sudo /etc/init.d/pe-httpd start


Changing the Console's User/Password
-----

Access to the console is controlled with a user name and password, which are chosen during installation. You can change the password or add a new user using PE's copy of `htpasswd` on the `/etc/puppetlabs/httpd/console_passwd` file. To change the password of the default "console" user:

    $ sudo /opt/puppet/bin/htpasswd /etc/puppetlabs/httpd/console_passwd console
    New password: 
    Re-type new password: 
    Updating password for user console

To add a new user: 

    $ sudo /opt/puppet/bin/htpasswd /etc/puppetlabs/httpd/console_passwd new_admin

Run `/opt/puppet/bin/htpasswd --help` for more info, including how to delete users.

Note that you do not need to change any other Puppet settings after changing this password; it is only used for the console's web interface. 

Changing the Console's Database User/Password
-----

The console uses a database user account to access its MySQL database. If this user's password is compromised, or if it just needs to be changed periodically for policy reasons, do the following: 

1. Stop the `pe-httpd` service on the console server:

        $ sudo /etc/init.d/pe-httpd stop
2. Use the MySQL administration tool of your choice to change the user's password. With the standard `mysql` client, you can do this with:

        SET PASSWORD FOR 'console'@'localhost' = PASSWORD('<new password>');
3. Edit `/etc/puppetlabs/puppet-dashboard/database.yml` on the console server and change the `password:` line under "common" (or under "production," depending on your configuration) to contain the new password.
4. Edit `/etc/puppetlabs/puppet/puppet.conf` on the console server and change the `dbpassword =` line (under `[master]`) to contain the new password. 
5. Start the `pe-httpd` service back up:

        $ sudo /etc/init.d/pe-httpd start

Changing the Orchestration Password
-----

Orchestration messages are authenticated with a randomly generatated password that isn't meant to be entered by users. If this pre-shared key is comprimised, or if it just needs to be changed periodically for policy reasons, you can do so by editing `/etc/puppetlabs/mcollective/credentials` on the puppet master server and then waiting for puppet agent to run on every node. 


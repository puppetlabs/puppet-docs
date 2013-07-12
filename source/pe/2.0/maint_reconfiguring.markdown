---
layout: default
title: "PE 2.0 » Maintenance and Troubleshooting » Reconfiguring PE"
canonical: "/pe/latest/console_config.html"
---

* * *

&larr; [Maintenance: Installing Additional Components](./maint_installing_additional.html) --- [Index](./)

* * *

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

Changing Orchestration Security
-----

PE's orchestration messages are encrypted and authenticated. You can easily change the authentication method or the password used in the PSK authentication method.

### Changing the Authentication Method

By default, orchestration messages are encrypted with SSL and authenticated with a pre-shared key (PSK). This balance of security and performance should work for most users, but if you need higher security and don't have a large number of nodes, you can reconfigure PE to authenticate orchestration messages with an AES key pair.

You can change the authentication method via the console. Navigate to your [default group][defaultgroup], then [create a new parameter][parameter] called `mcollective_security_provider`. The value of this parameter can be:

* `psk` --- Use the default PSK authentication.
* `aespe_security` --- Use AES authentication for extra security.

![A screenshot of the `mcollective_security_provider` parameter set to `psk`][maint_authentication_parameter]

After changing the authentication method, **you cannot issue orchestration messages to a given node until it has run Puppet at least once.** This means changing the authentication method requires a 30 minute maintenance window during which orchestration will not be used. You can check whether a given node has changed its orchestration settings by [checking its recent reports in the console][reports] and ensuring that its `/etc/puppetlabs/mcollective/server.cfg` file was modified. 

[defaultgroup]: ./console_classes_groups.html#the-default-group
[parameter]: ./console_classes_groups.html#parameters
[maint_authentication_parameter]: ./images/console/maint_authentication_parameter.png

Before changing the authentication method, you should carefully consider the pros and cons of each:

#### PSK

The PSK authentication method is enabled by default. Under this method, nodes receive a secret key via Puppet and trust messages sent by clients who have the same key. 

Pro: 

* Scales to many hundreds of nodes on average puppet master hardware. 

Con:

* Private key is known to all nodes --- an attacker with elevated privileges on one node could obtain the pre-shared key and issue valid orchestration commands to other nodes. 
* No protection from replay attacks --- an attacker could repeatedly re-send commands without knowing their content.

#### AES (`aespe_security`)

The AES authentication method must be manually enabled in the console. Under this method, nodes receive one or more public keys, and trust messages sent by clients who have one of the matching private keys. 

Pro: 

* Private key is only known to the puppet master node --- an attacker with elevated privileges on an agent node cannot command other nodes. 
* Protection from replay attacks --- once a short time window has passed, messages cannot be re-sent, and must be reconstructed and encrypted with a private key.

Con:

* All nodes must have very accurate timekeeping, and their clocks must be in sync. (The allowable time variance defaults to a 60-second window.)
* The puppet master node requires more powerful hardware. This authentication method may not reliably scale to multiple hundreds of nodes. 


### Changing the Pre-Shared Key

When using PSK authentication, orchestration messages are authenticated with a randomly generated password. (This password is distributed to your nodes by Puppet, and isn't meant to be entered by users.)

If this password is compromised, or if it just needs to be changed periodically for policy reasons, you can do so by editing `/etc/puppetlabs/mcollective/credentials` on the puppet master server and then waiting for puppet agent to run on every node.

After changing the password, **you cannot issue orchestration messages to a given node until it has run Puppet at least once.** This means changing the orchestration password requires a 30 minute maintenance window during which orchestration will not be used. You can check whether a given node has changed its orchestration settings by [checking its recent reports in the console][reports] and ensuring that its `/etc/puppetlabs/mcollective/server.cfg` file was modified. 

[reports]: ./console_reports.html

* * *

&larr; [Maintenance: Installing Additional Components](./maint_installing_additional.html) --- [Index](./)

* * *


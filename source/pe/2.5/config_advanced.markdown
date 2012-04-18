---
nav: pe25.html
layout: pe2experimental
title: "PE 2.5 » Configuring Puppet Enterprise » Advanced Configuration"
subtitle: "Working with Complex Settings"
---


Many behaviors of Puppet Enterprise can be configured after installation.


Increasing the MySQL Buffer Pool Size
-----

The default MySQL configuration uses an unreasonably small `innodb_buffer_pool_size` setting, which can interfere with the console's ability to function. 

If you are installing a new PE 2.5 console server and allowing the installer to configure your databases, it will set the better value for the buffer pool size. However, PE cannot automatically manage this setting for upgraded console servers and manually configured databases. 

To change this setting, edit the MySQL config file on your database server (usually located at `/etc/my.cnf`, but your system may differ) and set the value of `innodb_buffer_pool_size` to at least `80M` and possibly as high as `256M`. (Its default value is `8M`, or 8388608 bytes.)

The example diff below illustrates the change to a default MySQL config file:

{% highlight diff %}
 [mysqld]
 datadir=/var/lib/mysql
 socket=/var/lib/mysql/mysql.sock
 user=mysql
 # Default to using old password format for compatibility with mysql 3.x
 # clients (those using the mysqlclient10 compatibility package).
 old_passwords=1
+innodb_buffer_pool_size = 80M
 
 # Disabling symbolic-links is recommended to prevent assorted security risks;
 # to do so, uncomment this line:
 # symbolic-links=0
 
 [mysqld_safe]
 log-error=/var/log/mysqld.log
 pid-file=/var/run/mysqld/mysqld.pid
{% endhighlight %}

After changing the setting, restart the MySQL server:

    # sudo /etc/init.d/mysqld restart

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
        

Configuring Console Authentication
-----

### Configuring the SMTP Server

The console's account system sends verification emails to new users, and requires an SMTP server to do so. If your site's SMTP server requires a user and password, TLS, or a non-default port, you can configure these by editing the  `/etc/puppetlabs/console-auth/config.yml` file:

    smtp:
      address: mail.example.com
      port: 25
      use_tls: false
      ## Uncomment to enable SMTP authentication
      #username:  smtp_username
      #password:  smtp_password

### Allowing Anonymous Console Access

To allow anonymous, read-only access to the console, do the following:

* Edit the `/etc/puppetlabs/console-auth/cas_client_config.yml` file and change the `global_unauthenticated_access` setting to `true`.
* Restart Apache by running `sudo /etc/init.d/pe-httpd restart`.

### Disabling and Reenabling Console Auth

If necessary, you can completely disable the console's access controls. Run the following command to disable console auth:

    # sudo /opt/puppet/bin/rake -f /opt/puppet/share/console-auth/Rakefile console:auth:disable

To re-enable console auth, run the following:

    # sudo /opt/puppet/bin/rake -f /opt/puppet/share/console-auth/Rakefile console:auth:enable

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

Fine-tuning the `delayed_job` Queue
----------

The console uses a [`delayed_job`](https://github.com/collectiveidea/delayed_job/) queue to asynchronously process resource-intensive tasks such as report generation. Although the console won't lose any data sent by puppet masters if these jobs don't run, you'll need to be running at least one delayed job worker (and preferably one per CPU core) to get the full benefit of the console's UI.

Currently, to manage the `delayed_job` workers, you must either use the provided monitor script or start non-daemonized workers individually with the provided rake task.

### Using the monitor script

The console ships with a worker process manager, which can be found at `script/delayed_job`. This tool's interface resembles an init script, but it can launch any number of worker processes as well as a monitor process to babysit these workers; run it with `--help` for more details. `delayed_job` requires that you specify `RAILS_ENV` as an environment variable. To start four worker processes and the monitor process:

    # env RAILS_ENV=production script/delayed_job -p dashboard -n 4 -m start

In most configurations, you should run exactly as many workers as the machine has CPU cores.

Tuning the ActiveMQ Heap Size
-----

The puppet master node runs an ActiveMQ server to support orchestration commands. By default, the ActiveMQ process uses a Java heap size of 512 MB, which has been tested to support thousands of nodes. 

You can increase or reduce the amount of memory used by ActiveMQ by navigating to the puppet master node's page in the console and creating a new parameter called `activemq_heap_mb`. The value you assign to it will be the amount of memory, in megabytes, used by ActiveMQ; delete the parameter to revert to the default setting. 

This is most commonly used to create stable proof-of-concept deployments on virtual machines with limited amounts of RAM. Many of the puppet master's features can fail if ActiveMQ consumes all of the available memory on the system, and reducing its heap size by half or more can prevent these problems on a starved VM.

* * * 

- [Next: Installing Additional Components](./config_installing_additional.html) 



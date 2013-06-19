---
layout: default
title: "PE 3.0 » Console » Console Maintenance & Troubleshooting"
subtitle: "Console Maintenance & Troubleshooting"
---


If PE's console becomes sluggish or begins taking up too much space on disk, there are several maintenance tasks that can improve its performance. 

Restarting the Background Tasks
-----

The console uses several worker processes to process reports in the background, and it displays a running count of pending tasks in the upper left corner of the interface:

![The background tasks box with one pending task][maint_pending_task]

[maint_pending_task]: ./images/console/maint_pending_task.png

If the number of pending tasks appears to be growing linearly, the background task processes may have died and left invalid PID files. To restart the worker tasks, run:

    $ sudo /etc/init.d/pe-puppet-dashboard-workers restart

The number of pending tasks shown in the console should start decreasing rapidly after restarting the workers. 


Optimizing the Database
-----

Since the console turns over a lot of data, you can improve its speed and disk consumption by periodically optimizing its MySQL database with the `db:raw:optimize` task.

    $ sudo /opt/puppet/bin/rake \
    -f /opt/puppet/share/puppet-dashboard/Rakefile \
    RAILS_ENV=production \
    db:raw:optimize

If you find you need to optimize the database, we recommend that you do so with a monthly cron job.

Cleaning Old Reports
----------------

Agent node reports will build up over time in the console's database. If you wish to delete the oldest reports, for performance, storage, or policy reasons, you can use the `reports:prune` rake task.

For example, to delete reports more than one month old:

    $ sudo /opt/puppet/bin/rake \
    -f /opt/puppet/share/puppet-dashboard/Rakefile \
    RAILS_ENV=production \
    reports:prune upto=1 unit=mon

Although this task **should be run regularly as a cron job,** the frequency with which it should be run will depend on your site's policies.

If you run the `reports:prune` task without any arguments, it will display further usage instructions. The available units of time are `mon`, `yr`, `day`, `min`, `wk`, and `hr`.


Database backups
----------------

Although you can back up and restore the console's database with any standard MySQL tools, the `db:raw:dump` and `db:raw:restore` rake tasks can simplify the process. 

### Dumping the Database

To dump the console's `production` database to a file called `production.sql`:

    $ sudo /opt/puppet/bin/rake \
    -f /opt/puppet/share/puppet-dashboard/Rakefile \
    RAILS_ENV=production \
    db:raw:dump

Or dump it to a specific file:

    $ sudo /opt/puppet/bin/rake \
    -f /opt/puppet/share/puppet-dashboard/Rakefile \
    RAILS_ENV=production \
    FILE=/my/backup/file.sql db:raw:dump

### Restoring the Database

To restore the console's database from a file called `production.sql` to your `production` environment:

    $ sudo /opt/puppet/bin/rake \
    -f /opt/puppet/share/puppet-dashboard/Rakefile \
    RAILS_ENV=production \
    FILE=production.sql db:raw:restore


*Stuff from old adv. config page:*
Increasing the MySQL Buffer Pool Size
-----

The default MySQL configuration uses an unreasonably small `innodb_buffer_pool_size` setting, which can interfere with the console's ability to function.

If you are installing a new PE console server and allowing the installer to configure your databases, it will set the better value for the buffer pool size. However, PE cannot automatically manage this setting for upgraded console servers and manually configured databases.

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

    $ sudo /etc/init.d/mysqld restart

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


Recovering from a Lost Console Admin Password
-----

If you have forgotten the password of the console's initial admin user, you can [create a new admin user](./console_auth.html#creating-users-from-the-command-line) and use it to reset the original admin user's password.

On the console server, run the following commands:

    $ cd /opt/puppet/share/console-auth
    $ sudo /opt/puppet/bin/rake db:create_user USERNAME="adminuser@example.com" PASSWORD="<password>" ROLE="Admin"

You can now log in to the console as the user you just created, and use the normal admin tools to reset other users' passwords.



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

    $ sudo /opt/puppet/bin/rake -f /opt/puppet/share/console-auth/Rakefile console:auth:disable

To re-enable console auth, run the following:

    $ sudo /opt/puppet/bin/rake -f /opt/puppet/share/console-auth/Rakefile console:auth:enable

### Using LDAP or Active Directory Instead of Console Auth

For instructions on using third-party authentication services, see the [console_auth configuration page](./console_auth.html#configuration).


Fine-tuning the `delayed_job` Queue
----------

The console uses a [`delayed_job`](https://github.com/collectiveidea/delayed_job/) queue to asynchronously process resource-intensive tasks such as report generation. Although the console won't lose any data sent by puppet masters if these jobs don't run, you'll need to be running at least one delayed job worker (and preferably one per CPU core) to get the full benefit of the console's UI.

Currently, to manage the `delayed_job` workers, you must either use the provided monitor script or start non-daemonized workers individually with the provided rake task.

### Using the monitor script

The console ships with a worker process manager, which can be found at `script/delayed_job`. This tool's interface resembles an init script, but it can launch any number of worker processes as well as a monitor process to babysit these workers; run it with `--help` for more details. `delayed_job` requires that you specify `RAILS_ENV` as an environment variable. To start four worker processes and the monitor process:

    # env RAILS_ENV=production script/delayed_job -p dashboard -n 4 -m start

In most configurations, you should run exactly as many workers as the machine has CPU cores.

* * * 

- [Next: Puppet Overview](./puppet_overview.html) 

---
layout: default
title: "PE 3.0 » Console » Maintenance"
subtitle: "Maintaining the Console & Databases"
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

PostgreSQL should have `autovacuum=on` set by default. If you're having issues with the database growing too large and unwieldy, make sure this setting did not get turned off.

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

You can back up and restore the console's database using the standard [PostgreSQL tool, `pg dump`](http://www.postgresql.org/docs/9.2/static/app-pgdump.html). You should back up the `console`, `console_auth` and `puppetdb` databases.


Changing the Console's Database User/Password
-----

The console uses a database user account to access its PostgreSQL database. If this user's password is compromised, or if it just needs to be changed periodically for policy reasons, do the following:

1. Stop the `pe-httpd` service on the console server:

        $ sudo /etc/init.d/pe-httpd stop
2. On the database server (which may or may not be the same as the console, depending on your deployment's architecture) use the PostgreSQL administration tool of your choice to change the user's password. With the standard `psql` client, you can do this with:

        ALTER USER console PASSWORD '<new password>';
3. Edit `/etc/puppetlabs/puppet-dashboard/database.yml` on the console server and change the `password:` line under "common" (or under "production," depending on your configuration) to contain the new password.
4. Start the `pe-httpd` service back up:

        $ sudo /etc/init.d/pe-httpd start
        
Use the same procedure to change the console_auth db user's password, except you'll be editing the `/opt/puppet/share/console-auth/db/database.yml` and `/opt/puppet/share/rubycas-server/config.yml` files in the same way.

The same procedure is also used for the PuppetDB user's password, except you'll be editing `/etc/puppetlabs/puppetdb/conf.d/database.ini` and restarting the `pe-puppetdb` service.



* * * 

- [Next: Maintaining Puppet Core](./maintain_puppet.html) 

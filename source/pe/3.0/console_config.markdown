---
layout: default
title: "PE 3.0 » Console »  Configuration"
subtitle: " Configuring & Tuning the Console & Databases"
---

Changing the Console's Port
-----

By default, a new installation of PE will serve the console on port 443. However, previous versions of PE served the console's predecessor on port 3000. If you upgraded and want to change to the more convenient new default, or if you need port 443 for something else and want to shift the console somewhere else, perform the following steps:

* Stop the `pe-httpd` service:

        $ sudo /etc/init.d/pe-httpd stop
* Edit `/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf` on the console server, and change the port number in the `Listen 443` and `<VirtualHost *:443>` directives. (These directives will contain the current port, which is not necessarily 443.)
* Edit `/etc/puppetlabs/puppet/puppet.conf` on the puppet master server, and change the `reporturl` setting to use your preferred port.
* Edit `/etc/puppetlabs/puppet-dashboard/external_node` on the puppet master server, and change the `ENC_BASE_URL` to use your preferred port.
* Edit `/etc/puppetlabs/console-auth/config.yml ` on the puppet master server, and change the `cas_url` to use your preferred port.
* Edit `/etc/puppetlabs/rubycas-server/config.yml ` on the puppet master server, and change the `console_base_url` to use your preferred port.
* Make sure to allow access to the new port in your system's firewall rules.
* Start the `pe-httpd` service:

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

### Using LDAP or Active Directory Instead of Console Auth

For instructions on using third-party authentication services, see the [console_auth configuration page](./console_auth.html#configuration).

Tuning the PostgreSQL Buffer Pool Size
-----

If you are experiencing performance issues or instability with the console, you may need to adjust the buffer memory settings for PostgreSQL. The most important PostgreSQL memory settings for PE are `shared_buffers` and `work_mem`.  Generally speaking, you should allocate about 25% of your hardware's RAM to `shared_buffers`. If you have a large and/or complex deployment you will probably need to increase `work_mem` from the default of 1mb. For more detail, see in the [PostgreSQL documentation](http://www.postgresql.org/docs/9.2/static/runtime-config-resource.html).

After changing any of these settings, you should restart the PostgreSQL server:

    $ sudo /etc/init.d/pe-postgresql restart


Fine-tuning the `delayed_job` Queue
----------

The console uses a [`delayed_job`](https://github.com/collectiveidea/delayed_job/) queue to asynchronously process resource-intensive tasks such as report generation. Although the console won't lose any data sent by puppet masters if these jobs don't run, you'll need to be running at least one delayed job worker (and preferably one per CPU core) to get the full benefit of the console's UI.

Currently, to manage the `delayed_job` workers, you must either use the provided monitor script or start non-daemonized workers individually with the provided rake task.

### Using the monitor script

The console ships with a worker process manager, which can be found at `script/delayed_job`. This tool's interface resembles an init script, but it can launch any number of worker processes as well as a monitor process to babysit these workers; run it with `--help` for more details. `delayed_job` requires that you specify `RAILS_ENV` as an environment variable. To start four worker processes and the monitor process:

    # env RAILS_ENV=production script/delayed_job -p dashboard -n 4 -m start

In most configurations, you should run exactly as many workers as the machine has CPU cores.

* * * 

- [Next: Puppet Core Overview ](./puppet_overview.html)

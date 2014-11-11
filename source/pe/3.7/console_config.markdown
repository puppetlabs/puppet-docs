---
layout: default
title: "PE 3.7 » Console »  Configuration"
subtitle: "Configuring & Tuning the Console & Databases"
canonical: "/pe/latest/console_config.html"
---

Configuring Console Access Control
-----

### Changing Session Duration

There are a few options that can be configured for access control:

- `password-reset-expiration`  When a user doesn't remember their current password, an administrator can generate a token for them to change their password. The duration, in hours, that this generated token is valid can be changed with this config parameter. The default value is 24.
- `session-timeout`  This parameter is a positive integer that specifies how long a user's session should last, in minutes. This session is the same across node classification, RBAC, and the console. The default value is 60.
- `failed-attempts-lockout`  This parameter is a positive integer that specifies how many failed login attempts are allowed on an account before that account is revoked. The default value is 10.

To change these defaults, add a new file to the `/etc/puppetlabs/console-services/conf.d` directory. The file name is arbitrary, but the file format is [HOCON](https://github.com/typesafehub/config).

    rbac: {
     password-reset-expiration: 24
     session-timeout: 60
     failed-attempts-lockout: 10
    }

Then restart pe-console-services (`sudo service pe-console-services restart`)

Tuning the PostgreSQL Buffer Pool Size
-----

If you are experiencing performance issues or instability with the console, you may need to adjust the buffer memory settings for PostgreSQL. The most important PostgreSQL memory settings for PE are `shared_buffers` and `work_mem`.  Generally speaking, you should allocate about 25% of your hardware's RAM to `shared_buffers`. If you have a large and/or complex deployment you will probably need to increase `work_mem` from the default of 1mb. For more detail, see in the [PostgreSQL documentation](http://www.postgresql.org/docs/9.2/static/runtime-config-resource.html).

After changing any of these settings, you should restart the PostgreSQL server:

    $ sudo /etc/init.d/pe-postgresql restart


Changing the Console's Port
-----

By default, a new installation of PE will serve the console on the default SSL port, 443. If you wish to change the port the console is available on:

1. Visit *Classification*
2. Select the PE Console node group.
3. In the Classes tab, find the `puppet_enterprise::profile::console Class`.
4. Add a new value for the `console_ssl_listen_port` parameter.
5. Trigger a puppet run.

The console should now be available on the port you provided.

Disabling Update Checking
-----

When the console's web server (`pe-httpd`) starts or restarts, it checks for updates. To get the correct update info, the server will pass some basic, anonymous info to Puppet Labs' servers. Specifically, it will transmit:

* the IP address of the client
* the type and version of the client's OS
* the installed version of PE

If you wish to disable update checks (e.g. if your company policy forbids transmitting this information), you will need to add the following line to the `/etc/puppetlabs/installer/answers.install` file:

    q_pe_check_for_updates=n

Keep in mind that if you delete the `/etc/puppetlabs/installer/answers.install` file, update checking will resume.


* * *

- [Next: Puppet Core Overview ](./puppet_overview.html)

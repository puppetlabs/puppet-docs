---
layout: default
title: "PE 3.7 » Configuration"
subtitle: "Configuring & Tuning the Console & Databases"
canonical: "/pe/latest/console_config.html"
---

## Configuring Console Access Control

### Changing Session Duration

There are a few options that can be configured for access control:

- `password-reset-expiration`  When a user doesn't remember their current password, an administrator can generate a token for them to change their password. The duration, in hours, that this generated token is valid can be changed with this config parameter. The default value is 24.
- `session-timeout`  This parameter is a positive integer that specifies how long a user's session should last, in minutes. This session is the same across node classification, RBAC, and the console. The default value is 60.
- `failed-attempts-lockout`  This parameter is a positive integer that specifies how many failed login attempts are allowed on an account before that account is revoked. The default value is 10.

To change these defaults, add a new file to the `/etc/puppetlabs/console-services/conf.d` directory. The file name is arbitrary, but the file format is [HOCON](https://github.com/typesafehub/config#using-hocon-the-json-superset).

    rbac: {
     password-reset-expiration: 24
     session-timeout: 60
     failed-attempts-lockout: 10
    }

Then restart pe-console-services (`sudo service pe-console-services restart`).

### Tuning `max threads` on the PE Console and Console API

This sets the maximum number of threads assigned to respond to HTTP and HTTPS requests, effectively changing how many concurrent requests can be made to the PE console server and console API at one time. This setting should be increased to 150 max threads for nodes where `$::processorcount` is greater than 32.

To increase the max threads for the PE console and console API, edit your default Hiera `.yaml` file with the following code:

     puppet_enterprise::profile::console::console_services_config::tk_jetty_max_threads_api: <number of threads>
     puppet_enterprise::profile::console::console_services_config::tk_jetty_max_threads_console: <number of threads>

> **Note**: This setting is only available in PE 3.7.2 and later.

### Tuning Java Args for the PE Console

You can increase the JVM (Java Virtual Machine) memory that is allocated to Java services running on the PE console. This memory allocation is known as the Java heap size.

Instructions for using the PE console to increase the Jave heap size are detailed on on the [Configuring Java Arguments for PE](/config_java_args.html#pe-console-service) page.

## Tuning the PostgreSQL Buffer Pool Size

If you are experiencing performance issues or instability with the console, you may need to adjust the buffer memory settings for PostgreSQL. The most important PostgreSQL memory settings for PE are `shared_buffers` and `work_mem`.  Generally speaking, you should allocate about 25% of your hardware's RAM to `shared_buffers`. If you have a large and/or complex deployment you will probably need to increase `work_mem` from the default of 1mb. For more detail, see in the [PostgreSQL documentation](http://www.postgresql.org/docs/9.2/static/runtime-config-resource.html).

After changing any of these settings, you should restart the PostgreSQL server:

    $ sudo /etc/init.d/pe-postgresql restart


## Fine-tuning the `delayed_job` Queue

The PE console uses a [`delayed_job`](https://github.com/collectiveidea/delayed_job/) queue to asynchronously process resource-intensive tasks such as report generation. Although the console won't lose any data sent by Puppet masters if these jobs don't run, you'll need to be running at least two delayed job workers per CPU core to get the full benefit of the console's UI.

You can increase the number of workers by editing a class in the **PE Console** group.

1. In the PE console, navigate to the **Classification** page.
2. Click the **PE Console** group.
3. In the **PE Console** group page, click the **Classes** tab.
4. Locate the **puppet_enterprise::profile::console** class, and from the **Parameter** drop-down list, select **delayed_job_workers**.
5. In the **Value** field, enter 2.
6. Click **Add parameter**, and then the **Commit change** button.


## Changing the Console's Port

By default, a new installation of PE will serve the console on the default SSL port, 443. If you wish to change the port the console is available on:

1. Visit *Classification*
2. Select the PE Console node group.
3. In the Classes tab, find the `puppet_enterprise::profile::console Class`.
4. Add a new value for the `console_ssl_listen_port` parameter.
5. Trigger a Puppet run.

The console should now be available on the port you provided.

## Disabling Update Checking

When the console's web server (`pe-httpd`) starts or restarts, it checks for updates. To get the correct update info, the server will pass some basic, anonymous info to Puppet Labs' servers. Specifically, it will transmit:

* the IP address of the client
* the type and version of the client's OS
* the installed version of PE

If you wish to disable update checks (e.g. if your company policy forbids transmitting this information), you will need to add the following line to the `/etc/puppetlabs/installer/answers.install` file:

    q_pe_check_for_updates=n

Keep in mind that if you delete the `/etc/puppetlabs/installer/answers.install` file, update checking will resume.

Fine Tuning Live Management Node Discovery
-----

If you're running live management on a network that's slow or that has intermittent connectivity issues, you might need to tweak the timeouts for node discovery.

The following steps provide an example of configuring `LM_DISCOVERY_TIMEOUT`:

1. Configure the `datadir` hiera.yaml to point to a folder, such as `hieradata`:

		:datadir: '/etc/puppetlabs/puppet/hieradata'

2. Add a global.yaml file to the folder you created (`/etc/puppetlabs/puppet/hieradata`) and add these lines to increase the timeout time from 4 to 45 seconds, and to increase the number of retries from 3 to 10:

		---
		puppet_enterprise::console::lm_discovery_timeout: 45
		puppet_enterprise::console::lm_inventory_retries: 10

>**Note**: You might have to restart `pe-puppetserver` for these changes to take effect.



* * *

- [Next: Configuring the PE Console to Use a Custom Certificate ](./custom_console_cert.html)

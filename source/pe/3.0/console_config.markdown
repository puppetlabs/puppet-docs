---
layout: default
title: "PE 3.0 » Console »  Configuration"
subtitle: "Configuring & Tuning the Console & Databases"
canonical: "/pe/latest/console_config.html"
---

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

### Allowing Global Unauthenticated Access

>**Important**: Do not enable global unauthenticated access alongside third-party authentication services. 

To allow anonymous, read-only access to the console, do the following:

* Edit the `/etc/puppetlabs/console-auth/cas_client_config.yml` file and change the `global_unauthenticated_access` setting to `true`.
* In the same file, under `authorization`, comment out all the other authentication choices.
* Restart Apache by running `sudo /etc/init.d/pe-httpd restart`.

### Changing Session Duration

If you wish to change the duration of a user's session before they have to re-authenticate you need to edit two settings. In `/etc/puppetlabs/rubycas-server/config.yml` change the `maximum_session_lifetime` setting by specifying, in seconds, how long the session should last. The default is "1200" (20 minutes).

Next, in `/etc/puppetlabs/console-auth/cas_client_config.yml`, edit the `session_timeout` setting so it is the same as `maximum_session_lifetime`. Again, the default is 1200 seconds.


Configuring Third-Party Authentication Services
-----

[auth_thirdparty]: ./console_auth.html#using-third-party-authentication-services

User access can be managed with external, third-party authentication services, [as described on the user management and authorization page][auth_thirdparty]. The following external services are supported:

* LDAP
* Active Directory (AD)
* Google accounts

To use external authentication, the following two files must be correctly configured:

* `/etc/puppetlabs/console-auth/cas_client_config.yml` ([see below](#configuring-casclientconfigyml))
* `/etc/puppetlabs/rubycas-server/config.yml` ([see below](#configuring-rubycas-serverconfigyml))

(Note that YAML requires whitespace and tabs to match up exactly. Type carefully.)

After editing these files you must restart the `pe-httpd` and `pe-puppet-dashboard-workers` services via their `init.d` scripts.


### Configuring `cas_client_config.yml`

The `/etc/puppetlabs/console-auth/cas_client_config.yml` file contains several commented-out lines under the `authorization:` key. Un-comment the lines that correspond to the RubyCAS authenticators you wish to use, and set a new `default_role` if desired.

Each entry consists of the following:

* A common identifier (e.g. `local`, or `ldap`, etc.), which is used in the console\_auth database and corresponds to the classname of the RubyCAS authenticator.
* `default_role`, which defines the role to assign to users by default --- allowed values are `read-only`, `read-write`, or `admin`.
* `description`, which is simply a human readable description of the service.

The order in which authentication services are listed in the `cas_client_config.yml` file is the order in which the services will be checked for valid accounts. In other words, the first service that returns an account matching the entered user credential is the service that will perform authentication and log-in.

This example shows how to edit the file if you want to use AD and the built-in (local) auth services while leaving Google and LDAP disabled:

~~~ yaml

## This configuration file contains information required by any web
## service that makes use of the CAS server for authentication.

authentication:

  ## Use this configuration option if the CAS server is on a host different
  ## from the console-auth server.
  # cas_host: master:443

  ## The port CAS is listening on.  This is ignored if cas_host is set.
  # cas_port: 443

  ## The session secret is randomly generated during installation of Puppet
  ## Enterprise and will be regenerated any time console-auth is enabled or disabled.
  session_key: 'puppet_enterprise_console'
  session_secret: [REDACTED]

  ## Set this to true to allow anonymous users read-only access to all of
  ## Puppet Enterprise Console.
  global_unauthenticated_access: false

authorization:
  local:
    default_role: read-only
    description: Local
#  ldap:
#    default_role: read-only
#    description: LDAP
  activedirectoryldap:
    default_role: read-only
    description: Active Directory
#  google:
#    default_role: read-only
#    description: Google

~~~

> **Note:** If your console server ever ran PE 2.5, the commented-out sections may not be present in this file. To find example config text that can be copied and pasted into place, look for a `cas_client_config.yml.rpmnew` or `cas_client_config.yml.dpkg-new` file in the same directory.


### Configuring `rubycas-server/config.yml`

The `/etc/puppetlabs/rubycas-server/config.yml` file is used to configure RubyCAS to use external authentication services. As before, you will need to un-comment the section for the third-party services you wish to enable and configure them as necessary. The values for the listed keys are LDAP and ActiveDirectory standards. If you are not the administrator of those databases, you should check with that administrator for the correct values.

The authenticators are listed in the file in the following manner (note how this example disables the Google authenticator but enables both AD and LDAP):

~~~ yaml

authenticator:
  - class: CASServer::Authenticators::SQLEncrypted
    database:
      adapter: postgresql
      database: console_auth
      username: console_auth
      password: easnthycea098iu7aeo6oeu # installer-generated password
      server: localhost
    user_table: users
    username_column: username
  #- class: CASServer::Authenticators::Google
  #   restricted_domain: example.com
  - class: CASServer::Authenticators::LDAP
    ldap:
      host: tb-driver.example.com
      port: 389
      base: dc=example,dc=test
      filter: (objectClass=person)
      username_attribute: mail
  - class: CASServer::Authenticators::ActiveDirectoryLDAP
    ldap:
      host: winbox.example.com
      port: 389
      base: dc=example,dc=dev
      filter: (memberOf=CN=Example Users,CN=Users,DC=example,DC=dev)
      auth_user: cn=Test I. Am,cn=users,dc=example,dc=dev
      auth_password: P4ssword

~~~

> **Note:** If your console server ever ran PE 2.5, the commented-out sections may not be present in this file. To find example config text that can be copied and pasted into place, look for a `config.yml.rpmnew` or `config.yml.dpkg-new` file in the same directory.

> **Note:** The commented-out examples in the config file may or may not have a line break between after the hyphen; both are valid YAML.
>
>     # OK
>     - class: CASServer::Authenticators::SQLEncrypted
>
>     # Also OK
>     -
>       class: CASServer::Authenticators::SQLEncrypted


As the above example shows, it's generally best to specify just `dc=` attributes in the `base` key. The criteria for the Organizational Unit (`OU`) and Common Name (`CN`) should be specified in the `filter` key. The value of the `filter:` key is where authorized users should be located in the AD organizational structure. Generally speaking, the `filter:` key is where you would specify an OU or an AD Group. In order to authenticate, users will need to be in the specified OU or Group.

Also note that the value for the `filter:` key must be the full name for the leftmost `cn=`; you cannot use the user ID or logon name. In addition, the `auth_user:` key requires the full Distinguished Name (DN), including any CNs associated with the user and all of the `dc=` attributes used in the DN.


Tuning the PostgreSQL Buffer Pool Size
-----

If you are experiencing performance issues or instability with the console, you may need to adjust the buffer memory settings for PostgreSQL. The most important PostgreSQL memory settings for PE are `shared_buffers` and `work_mem`.  Generally speaking, you should allocate about 25% of your hardware's RAM to `shared_buffers`. If you have a large and/or complex deployment you will probably need to increase `work_mem` from the default of 1mb. For more detail, see in the [PostgreSQL documentation](http://www.postgresql.org/docs/9.2/static/runtime-config-resource.html).

After changing any of these settings, you should restart the PostgreSQL server:

    $ sudo /etc/init.d/pe-postgresql restart


Fine-tuning the `delayed_job` Queue
----------

The console uses a [`delayed_job`](https://github.com/collectiveidea/delayed_job/) queue to asynchronously process resource-intensive tasks such as report generation. Although the console won't lose any data sent by puppet masters if these jobs don't run, you'll need to be running at least one delayed job worker (and preferably one per CPU core) to get the full benefit of the console's UI.

Currently, to manage the `delayed_job` workers, you must either use the provided monitor script or start non-daemonized workers individually with the provided rake task.

### Changing the Number of delayed_job Worker Processes

You can increase the number of workers by changing the following setting:

 - `CPUS` in `/etc/sysconfig/pe-puppet-dashboard-workers` on Red-Hat based systems
 - `NUM_DELAYED_JOB_WORKERS` in `/etc/default/pe-puppet-dashboard-workers` on Ubuntu and Debian

In most configurations, you should run exactly as many workers as the machine has CPU cores.

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

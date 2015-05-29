---
layout: default
title: "PE 3.2 » Console »  Configuration"
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

Configuring the Console to Use a Custom SSL Certificate
-------

Full instructions are available [here](./custom_console_cert.html).  


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

>**Note**: if you are using two-factor authentication with Google accounts, you must first create an ["application-specific"](https://accounts.google.com/b/2/IssuedAuthSubTokens?hide_authsub=1) password in order to successfully log into the console.


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

The `/etc/puppetlabs/rubycas-server/config.yml` file is used to configure RubyCAS to use external authentication services. As before, you will need to un-comment the section for the third-party service you wish to enable and configure it as necessary. 

>**Note**: If you are upgrading to PE 3.2.x or later, `rubycas-server/config.yml` will not contain the commented sections for the third-party services. We've provided the commented sections below, which you can copy and paste into `rubycas-server/config.yaml` after you upgrade.

The values for the listed keys are LDAP and ActiveDirectory standards. If you are not the administrator of those databases, you should check with that administrator for the correct values.

#### Google Authentication

    # === Google Authentication ====================================================
    #
    # The Google authenticator allows users to log in to your CAS server using
    # their Google account credentials (i.e. the same email and password they
    # would use to log in to Google services like Gmail). This authenticator
    # requires no special configuration -- just specify its class name:
    #
    # authenticator:
    #  - class: CASServer::Authenticators::Google
    #
    # If you are behind an http proxy, you can try specifying proxy settings as follows:
    #
    # authenticator:
    #  - class: CASServer::Authenticators::Google
    #    proxy:
    #      host: your-proxy-server
    #      port: 8080
    #      username: nil
    #      password: nil
    # 
    # Note that as with all authenticators, it is possible to use the Google·
    # authenticator alongside other authenticators. For example, CAS can first
    # attempt to validate the account with Google, and if that fails, fall back
    # to some other local authentication mechanism.
    #
    # For example:
    #
    # authenticator:
    #  - class: CASServer::Authenticators::Google
    #  - class: CASServer::Authenticators::SQL
    #    database:
    #      adapter: postgresql
    #      database: some_database_with_users_table
    #      username: root
    #      password:
    #      host: localhost
    #    user_table: user
    #    username_column: username
    #    password_column: password
    #
    #
    
#### ActiveDirectory Authetication

    # === ActiveDirectory Authentication ===========================================
    #
    # This method authenticates against Microsoft's Active Directory using LDAP.
    # You must configure the ActiveDirectory server, and base DN. The port number
    # and LDAP filter are optional. You must also enter a CN and password
    # for a special "authenticator" user. This account is used to log in to
    # the ActiveDirectory server and search LDAP. This does not have to be an
    # administrative account -- it only has to be able to search for other
    # users.
    #·
    # Note that the auth_user parameter must be the user's CN (Common Name).
    # In Active Directory, the CN is genarally the user's full name, which is usually
    # NOT the same as their username (sAMAccountName).
    # 
    # For example:
    #
    #
    # authenticator:
    #  - class: CASServer::Authenticators::ActiveDirectoryLDAP
    #    ldap:
    #      host: ad.example.net
    #      port: 389
    #      base: dc=example,dc=net
    #      filter: (objectClass=person)
    #      auth_user: authenticator
    #      auth_password: itsasecret
    #
    # A more complicated example, where the authenticator will use TLS encryption,
    # will ignore users with disabled accounts, and will pass on the 'cn' and 'mail'·
    # attributes to CAS clients:
    #
    # authenticator:
    #  - class: CASServer::Authenticators::ActiveDirectoryLDAP
    #    ldap:
    #      host: ad.example.net
    #      port: 636
    #      base: dc=example,dc=net
    #      filter: (objectClass=person) & !(msExchHideFromAddressLists=TRUE)
    #      auth_user: authenticator
    #      auth_password: itsasecret
    #      encryption: simple_tls
    #    extra_attributes: cn, mail
    #
    # It is possible to authenticate against Active Directory without the 
    # authenticator user, but this requires that users type in their CN as
    # the username rather than typing in their sAMAccountName. In other words
    # users will likely have to authenticate by typing their full name,
    # rather than their username. If you prefer to do this, then just
    # omit the auth_user and auth_password values in the above example.
    #
    #
    
#### LDAP Authentication 

    # === LDAP Authentication ======================================================
    #
    # This is a more general version of the ActiveDirectory authenticator.
    # The configuration is similar, except you don't need an authenticator
    # username or password. The following example has been reported to work·
    # for a basic OpenLDAP setup.
    #
    # authenticator:
    #  - class: CASServer::Authenticators::LDAP
    #    ldap:
    #      host: ldap.example.net
    #      port: 389
    #      base: dc=example,dc=net
    #      username_attribute: uid
    #      filter: (objectClass=person)
    #
    # If you need more secure connections via TSL, specify the 'encryption'
    # option and change the port. This example also forces the authenticator
    # to connect using a special "authenticator" user with the given
    # username and password (see the ActiveDirectoryLDAP authenticator
    # explanation above):
    #
    # authenticator:
    #  - class: CASServer::Authenticators::LDAP
    #    ldap:
    #      host: ldap.example.net
    #      port: 636
    #      base: dc=example,dc=net
    #      filter: (objectClass=person)
    #      encryption: simple_tls
    #      auth_user: cn=admin,dc=example,dc=net
    #      auth_password: secret
    #
    # If you need additional data about the user passed to the client (for example,
    # their 'cn' and 'mail' attributes, you can specify the list of attributes
    # under the extra_attributes config option:·
    #
    # authenticator:
    #  - class: CASServer::Authenticators::LDAP
    #    ldap:
    #      host: ldap.example.net
    #      port: 389
    #      base: dc=example,dc=net
    #      filter: (objectClass=person)
    #    extra_attributes: cn, mail
    #
    # Note that the above functionality is somewhat limited by client compatibility.
    # See the SQL authenticator notes above for more info.
    
#### Custom Authentication

    # === Custom Authentication ====================================================
    #
    # It should be relatively easy to write your own Authenticator class. Have a look
    # at the built-in authenticators in the casserver/authenticators directory. Your
    # authenticator should extend the CASServer::Authenticators::Base class and must
    # implement a validate() method that takes a single hash argument. When the user·
    # submits the login form, the username and password they entered is passed to·
    # validate() as a hash under :username and :password keys. In the future, this·
    # hash might also contain other data such as the domain that the user is logging·
    # in to.
    #
    # To use your custom authenticator, specify it's class name and path to the·
    # source file in the authenticator section of the config. Any other parameters·
    # you specify in the authenticator configuration will be passed on to the·
    # authenticator and made availabe in the validate() method as an @options hash.
    #
    # Example:
    #
    # authenticator:
    #  - class: FooModule::MyCustomAuthenticator
    #    source: /path/to/source.rb
    #    option_a: foo
    #    another_option: yeeha
    #
    
#### Multiple Authenticators    
    
    # === Multiple Authenticators ==================================================
    #
    # If you need to have more than one source for authentication, such as an LDAP·
    # directory and a database, you can use multiple authenticators by making·
    # :authenticator an array of authenticators.
    #
    # authenticator:
    #  - class: CASServer::Authenticators::ActiveDirectoryLDAP
    #    ldap:
    #      host: ad.example.net
    #      port: 389
    #      base: dc=example,dc=net
    #      filter: (objectClass=person)
    #  - class: CASServer::Authenticators::SQL
    #    database:
    #      adapter: postgresql
    #      database: some_database_with_users_table
    #      username: root
    #      password:
    #      host: localhost
    #    user_table: user
    #    username_column: username
    #    password_column: password
    #
    # During authentication, the user credentials will be checked against the first
    # authenticator and on failure fall through to the second authenticator.

> **Note:** The commented-out examples in the config file may or may not have a line break between after the hyphen; both are valid YAML.
>
>     # OK
>     - class: CASServer::Authenticators::SQLEncrypted
>
>     # Also OK
>     -
>       class: CASServer::Authenticators::SQLEncrypted


As the above examples show, it's generally best to specify just `dc=` attributes in the `base` key. The criteria for the Organizational Unit (`OU`) and Common Name (`CN`) should be specified in the `filter` key. The value of the `filter:` key is where authorized users should be located in the AD organizational structure. Generally speaking, the `filter:` key is where you would specify an OU or an AD Group. In order to authenticate, users will need to be in the specified OU or Group.

Also note that the value for the `filter:` key must be the full name for the leftmost `cn=`; you cannot use the user ID or logon name. In addition, the `auth_user:` key requires the full Distinguished Name (DN), including any CNs associated with the user and all of the `dc=` attributes used in the DN.


Tuning the PostgreSQL Buffer Pool Size
-----

If you are experiencing performance issues or instability with the console, you may need to adjust the buffer memory settings for PostgreSQL. The most important PostgreSQL memory settings for PE are `shared_buffers` and `work_mem`.  Generally speaking, you should allocate about 25% of your hardware's RAM to `shared_buffers`. If you have a large and/or complex deployment you will probably need to increase `work_mem` from the default of 1mb. For more detail, see in the [PostgreSQL documentation](http://www.postgresql.org/docs/9.2/static/runtime-config-resource.html).

After changing any of these settings, you should restart the PostgreSQL server:

    $ sudo /etc/init.d/pe-postgresql restart


Fine-tuning the `delayed_job` Queue
----------

The console uses a [`delayed_job`](https://github.com/collectiveidea/delayed_job/) queue to asynchronously process resource-intensive tasks such as report generation. Although the console won't lose any data sent by puppet masters if these jobs don't run, you'll need to be running at least one delayed job worker (and preferably one per CPU core) to get the full benefit of the console's UI.

### Changing the Number of delayed_job Worker Processes

You can increase the number of workers by changing the following setting:

 - `CPUS` in `/etc/sysconfig/pe-puppet-dashboard-workers` on Red-Hat based systems
 - `NUM_DELAYED_JOB_WORKERS` in `/etc/default/pe-puppet-dashboard-workers` on Ubuntu and Debian

In most configurations, you should run exactly as many workers as the machine has CPU cores.

Changing the Console's Port
-----

By default, a new installation of PE will serve the console on port 443. However, previous versions of PE served the console's predecessor on port 3000. If you upgraded and want to change to the more convenient new default, or if you need port 443 for something else and want to shift the console somewhere else, perform the following steps:

1. Stop the `pe-httpd` service: `sudo /etc/init.d/pe-httpd stop`.
2. Edit `/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf` on the console server, and change the port number in the `Listen 443` and `<VirtualHost *:443>` directives. (These directives will contain the current port, which is not necessarily 443.)
3. Edit `/etc/puppetlabs/console-auth/config.yml ` on the puppet master server, and change the `cas_url` to use your preferred port.
4. Edit `/etc/puppetlabs/rubycas-server/config.yml ` on the puppet master server, and change the `console_base_url` to use your preferred port.
5. Make sure to allow access to the new port in your system's firewall rules.
6. Start the `pe-httpd` service: `sudo /etc/init.d/pe-httpd start`.
        
Configuring the Console Location
------

By default, the puppet master finds the console by reading the contents of `/etc/puppetlabs/puppet/console.conf`, which contains the following:

		[main]
 		server = <console hostname>
 		port = <console port>
 		certificate_name = pe-internal-dashboard
 	
 To change the location of the console, you'll need to specify the console hostname, port, and certificate name.


Disabling Update Checking
-----

When the console's web server (`pe-httpd`) starts or restarts, it checks for updates. To get the correct update info, the server will pass some basic, anonymous info to Puppet Labs' servers. Specifically, it will transmit:

* the IP address of the client
* the type and version of the client's OS
* the installed version of PE

If you wish to disable update checks (e.g. if your company policy forbids transmitting this information), you will need to add the following line to the `/etc/puppetlabs/installer/answers.install` file:

    q_pe_check_for_updates=n

Keep in mind that if you delete the `/etc/puppetlabs/installer/answers.install` file, update checking will resume.

Fine Tuning Live Management Node Discovery
-----

If you're running Live Management on a network that's slow, or has intermittent connectivity issues, you may need to tweak the timeouts for node discovery.

On your console node (the master if this is an all-in-one installation), the file `/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf` contains the setting `#SetEnv LM_DISCOVERY_TIMEOUT 4`, commented out.

The number represents seconds allowed for node discovery. You can uncomment this line and increase the number to allow more time for node discovery.

After tweaking this setting, you'll want to restart the `pe-httpd` and `pe-memcached` services to force-refresh node discovery.




* * *

- [Next: Puppet Core Overview ](./puppet_overview.html)

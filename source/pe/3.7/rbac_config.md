---
title: "RBAC Service 1.0 >> API >> v1 >> RBAC Service Configuration Options"
layout: default
subtitle: "Configuration Options"
canonical: "/pe/latest/rbac_config.html"
---

RBAC Service Configuration Options
---------------------------

There are various configuration options for the RBAC service. Each
section can exist in its own file or in separate files.

General RBAC Config
-------------------

The following is general configuration of the RBAC service and is not required,
but when present must be under the 'rbac' secion:

    rbac: {
      # Duration in hours that a password reset token is viable
      password-reset-expiration: 24
      # Duration in minutes that a session is viable
      session-timeout: 60
      failed-attempts-lockout: 10
    }

### `password-reset-expiration`

When a user doesn't remember their current password, an administrator
can generate a token for them to change their password. The duration,
in hours, that this generated token is valid can be changed with this
config parameter. The default value is 24.

### `session-timeout`

This parameter is a positive integer that specifies how long a user's
session should last, in minutes. This session is the same across node classifier, RBAC, and the console. By default this value is 60.

### `failed-attempts-lockout`

This parameter is a positive integer that specifies how many failed
login attempts are allowed on an account before that account is
revoked. The default value is 10.

>Note: If you change this value, you have to also create a new file or Puppet will reset back to 10 when it next runs. Create the file in an RBAC section of /etc/puppetlabs/console-services/conf.d.

### `certificate-whitelist`

This parameter is a path for specifying the file that contains the
names of hosts that are allowed to use RBAC APIs and other downstream
component APIs, such as the Node Classifier and the Activity services.
This configuration is for the users who want to script interaction with
the RBAC service. Users must connect to the RBAC service with a client
certificate that has been specified in this `certificate-whitelist`
file. A successful match of the client certificate and this
certificate-whitelist will allow access to the RBAC APIs as the
'api_user'. This user is by default an administrator, but permissions
for the 'api_user' can be changed. By default there is no certificate
whitelist.

#### Authentication

You need to authenticate requests to the RBAC API using a certificate listed in RBAC's certificate whitelist, located at `/etc/puppetlabs/console-services/rbac-certificate-whitelist`. Note that if you edit this file, you must restart the `pe-console-services` service for your changes to take effect. You can attach the certificate using the command line as demonstrated in the [example curl query](./rbac_config.html#example-query) below. You must have the whitelist certificate name and the private key to run the script.

You do not need to use an agent certificate for authentication. You can use `puppet cert generate` to create a new certificate specifically for use with the API.

#### Example Query

The following query will return a list of all users that exist in the RBAC service, along with their associated metadata. This query shows how to attach the whitelist certificate to authenticate the RBAC API.

In this query, the "whitelisted certname" needs to match a name in the file, `/etc/puppetlabs/console-services/rbac-certificate-whitelist`.

`curl https://<DNS NAME OF CONSOLE>:4433/rbac-api/v1/users --cert /etc/puppetlabs/puppet/ssl/certs/<WHITELISTED CERTNAME>.pem --key /etc/puppetlabs/puppet/ssl/private_keys/<WHITELISTED CERTNAME>.pem --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem -H "Content-Type: application/json"`


RBAC Database Config
--------------------

Credential information for the RBAC service is stored in a PostgreSQL
database. The configuration of that database is found in the
'rbac-database' section of the config, like below:

    rbac-database: {
      classname: org.postgresql.Driver
      subprotocol: postgresql
      subname: "//<path-to-host>:5432/perbac"
      user: <username here>
      password: <password here>
    }

### `classname`

Used by the RBAC service for connecting to the database; this option should always be `org.postgresql.Driver`.

### `subprotocol`

Used by the RBAC service for connecting to the database; this options should always be `postgresql`.

### `subname`

JDBC connection path Used by the RBAC service for connecting to the
database. This should be set to the hostname and configured port of
the PostgreSQL database. `perbac` is the database the RBAC service
will use to store credentials.

### `user`

This is the username the RBAC service should use to connect to the PostgreSQL database.

### `password`

This is the password the RBAC service should use to connect to the PostgreSQL database.
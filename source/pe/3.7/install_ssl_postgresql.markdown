---
layout: default
title: "PE 3.8 » Installing » SSL for PE and External PostgreSQL"
subtitle: "Enabling SSL on PE and External PostgreSQL"
canonical: "/pe/latest/install_ssl_postgresql.html"
---


If you are using an external PostgreSQL instance instead of the one PE installs, there are some additional steps you'll need to take after installing PE to ensure SSL is correctly configured between PE and your PostgreSQL database.

### Step 1: Copy PE SSL Files to the PE PostgreSQL Certs Directory

>**Note**: The following examples use `$PGDATA` for the PostgreSQL config directory. `$PGDATA` is typically `/var/lib/pgsql/9.2/data`.

1. Create a `certs` directory in `$PGDATA`.
2. Copy the the PE SSL cert and private key to the PostgreSQL `certs` directory.

   a. Copy `/etc/puppetlabs/puppet/ssl/certs/<POSTGRESQL HOSTNAME>.pem` to `$PGDATA/certs/<POSTGRESQL HOSTNAME>.cert.pem`.

   b. Copy `/etc/puppetlabs/puppet/ssl/private_keys/<POSTGRESQL HOSTNAME>.pem` to `$PGDATA/certs/<POSTGRESQL HOSTNAME>.private_key.pem`.

3. Ensure these files are owned by the Postgres user and the file permissions are only readable by that user. From `$PGDATA/certs/`, run the following commands:

   a. `chmod 400 *.pem`.

   b. `chown postgres:postgres *.pem`.


### Step 2: Update `postgresql.conf`

1. Navigate to `/var/lib/pgsql/9.2/data` and edit `postgresql.conf` with the following values:

   a. `ssl = on`

   b. `ssl_cert_file = 'certs/<POSTGRESQL HOSTNAME>.cert.pem'`

   c. `ssl_key_file = 'certs/<POSTGRESQL HOSTNAME>.private_key.pem'`

   d. `ssl_ca_file = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'`

2. Make sure the file has no entry resembling `ssl = off`.
3. Save and exit the file.
4. Restart PostgreSQL.

If there are any errors check your postgresql log file. Potential errors that might happen include certs/keys not being readable by PostgreSQL.

>**Note**: If you are managing PostgreSQL with Puppet, make sure to add these SSL settings in your Puppet manifest instead of in `postgresql.conf`; otherwise, Puppet will remove the entries the next time it runs.

### Step 3: Update PE to Use SSL

1. From the console, click __Classification__ in the top navigation bar.
2. From the __Classification page__, select the __PE Infrastructure__ group.
3. Click the __Classes__ tab.
3. Find the class `puppet_enterprise`, and edit the the `database_ssl` parameter to `true`.
4. Click the Commit change button.
5. Navigate to `/etc/puppetlabs/console-services/conf.d/` and edit `activity-database.conf` so that `subname` has the following setting: `"//<POSTGRESQL_SERVER_HOSTNAME>:5432/pe-activity?ssl=true&sslfactory=org.postgresql.ssl.jdbc4.LibPQFactory&sslmode=verify-full&sslrootcert=/etc/puppetlabs/puppet/ssl/certs/ca.pem"`
6. Navigate to `/etc/puppetlabs/console-services/conf.d/` and edit `classifier-database.conf` so that `subname` has the following setting: `"//<POSTGRESQL_SERVER_HOSTNAME>:5432/pe-classifier?ssl=true&sslfactory=org.postgresql.ssl.jdbc4.LibPQFactory&sslmode=verify-full&sslrootcert=/etc/puppetlabs/puppet/ssl/certs/ca.pem"`
7. Navigate to `/etc/puppetlabs/console-services/conf.d/` and edit `rbac-database.conf` so that `subname` has the following setting: `"//<POSTGRESQL_SERVER_HOSTNAME>:5432/pe-rbac?ssl=true&sslfactory=org.postgresql.ssl.jdbc4.LibPQFactory&sslmode=verify-full&sslrootcert=/etc/puppetlabs/puppet/ssl/certs/ca.pem",`
8. Restart the pe-console-services. Run `service pe-console-services restart`.
9. On the PE console node, kick off a Puppet run. (This is the same as the master node for a monolithic install.)
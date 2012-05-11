---
title: "PuppetDB 0.9 » Installing and Connecting"
layout: pe2experimental
nav: puppetdb0.9.html
---

### Installing from system packages

If installing from a distribution maintained package, such as those
listed on the
[Downloading Puppet Wiki Page](http://projects.puppetlabs.com/projects/puppet/wiki/Downloading_Puppet)
all OS prerequisites should be handled by your package manager. See
the Wiki for information on how to enable repositories for your
particular OS. Usually the latest stable version is available as a
package. If you would like to do puppet-development or see the latest
versions, however, you will want to install from source.

### Installing from source

While we recommend using pre-built packages for production use, it is
occasionally handy to have a source-based installation:

    $ mkdir -p ~/git && cd ~/git
    $ git clone git://github.com/puppetlabs/puppetdb
    $ cd puppetdb
    $ rake install DESTDIR=/opt/puppetdb

You can replace `/opt/puppetdb` with a target installation prefix of
your choosing.

The Puppet terminuses can be installed from source by copying them into the
same directory as your Puppet installation. Using Ruby 1.8 on Linux (without
rvm), this is probably `/usr/lib/ruby/1.8/puppet`.

    $ cp -R puppet/lib/puppet /usr/lib/ruby/1.8/puppet

### Running directly from source

While installing from source is useful for simply running a development version
for testing, for development it's better to be able to run *directly* from
source, without any installation step. This can be accomplished using
[leiningen](https://github.com/technomancy/leiningen#installation), a Clojure build tool.

    # Install leiningen

    # Get the code!
    $ mkdir -p ~/git && cd ~/git
    $ git clone git://github.com/puppetlabs/puppetdb
    $ cd puppetdb

    # Download the dependencies
    $ lein deps

    # Start the server from source. A sample config is provided in the root of
    # the repo, in config.sample.ini
    $ lein run services -c /path/to/config.ini # or to a conf.d directory with ini fragments

From here you can make changes to the code, and trying them out is as easy as
restarting the server.

Other useful commands:

* `lein test` to run the test suite

* `lein docs` to build docs in `docs/uberdoc.html`

To use the Puppet module from source, add the Ruby code to $RUBYLIB.

    $ export RUBYLIB=$RUBYLIB:`pwd`/puppet/lib

Restart the Puppet master each time changes are made to the Ruby code.

### Installing PostgreSQL

While a full discussion of how to install PostgreSQL is outside the
scope of this document, you can get a local copy of PostgreSQL
installed for testing fairly easily.

For example, if you're on a Mac you can install PostgreSQL easily
through Homebrew:

    $ brew install postgresql

    # Now start the database
    $ postgres -D /usr/local/var/postgres &

    # Create a database
    $ createdb puppetdb

On a Debian box you can install PostgreSQL locally like so:

    $ apt-get install postgresql

    # Switch to the postgres user
    $ sudo -u postgres sh

    # Create a new user and database for puppetdb
    $ createuser -DRSP puppetdb
    $ createdb -O puppetdb puppetdb
    $ exit

    # You can now login to the database via TCP with the credentials
    # you just established
    $ psql -h localhost puppetdb puppetdb

## Puppet Setup

In order to talk to PuppetDB, Puppet must be configured to use the PuppetDB
terminuses. This can be achieved by installing the module on the Puppet master
and changing the `storeconfigs_backend` setting to `puppetdb`. The location of
the server can be specified using the `$confdir/puppetdb.conf` file. The basic
format of this file is:

    [main]
    server = puppetdb.example.com
    port = 8080

If no config file is specified, or a value isn't supplied, the defaults will be
used:

    server = puppetdb
    port = 8080

*Additionally*, you will need to specify a "routes" file, which is located by
default at `$confdir/routes.yaml`. The content should be:

    master:
      facts:
        terminus: puppetdb
        cache: yaml

This configuration tells Puppet to use PuppetDB as the authoritative source of
fact information, which is what is necessary for inventory search to consult
it.

## SSL Setup

PuppetDB can do full, verified HTTPS communication between
Puppetmaster and itself. To set this up you need to complete a few
steps:

* Generate a keypair for your PuppetDB instance

* Create a Java _truststore_ containing the CA cert, so we can verify
  client certificates

* Create a Java _keystore_ containing the cert to advertise for HTTPS

* Configure PuppetDB to use the files you just created for HTTPS

The following instructions will use the Puppet CA you've already got
to create the keypair, but you can use any CA as long as you have PEM
format keys and certificates.

For ease-of-explanation, let's assume that:

* you'll be running PuppetDB on a host called `puppetdb.my.net`

* your puppet installation uses the standard directory structure and
  its `ssldir` is `/etc/puppet/ssl`

### Create a keypair

This is pretty easy with Puppet's built-in CA. On the host acting as
your CA (your puppetmaster, most likely):

    # puppet cert generate puppetdb.my.net
    notice: puppetdb.my.net has a waiting certificate request
    notice: Signed certificate request for puppetdb.my.net
    notice: Removing file Puppet::SSL::CertificateRequest puppetdb.my.net at '/etc/puppet/ssl/ca/requests/puppetdb.my.net.pem'
    notice: Removing file Puppet::SSL::CertificateRequest puppetdb.my.net at '/etc/puppet/ssl/certificate_requests/puppetdb.my.net.pem'

Et voilà, you've got a keypair. Copy the following files from your CA
to the machine that will be running PuppetDB:

* `/etc/puppet/ssl/ca/ca_crt.pem`
* `/etc/puppet/ssl/private_keys/puppetdb.my.net.pem`
* `/etc/puppet/ssl/certs/puppetdb.my.net.pem`

You can do that using `scp`:

    # scp /etc/puppet/ssl/ca/ca_crt.pem puppetdb.my.net:/tmp/certs/ca_crt.pem
    # scp /etc/puppet/ssl/private_keys/puppetdb.my.net.pem puppetdb.my.net:/tmp/certs/privkey.pem
    # scp /etc/puppet/ssl/certs/puppetdb.my.net.pem puppetdb.my.net:/tmp/certs/pubkey.pem

The rest of the SSL setup occurs on the PuppetDB host; once you've
copied the aforementioned files over, you don't need to remain logged
in to your CA.

### Create a truststore

On the PuppetDB host, you'll need to use the JDK's `keytool` command
to import your CA's cert into a file format that PuppetDB can
understand.

First, change into the directory where you copied the generated certs
and the CA cert from the previous section. If you copied them to, say,
`/tmp/certs`:

    # cd /tmp/certs

Now use `keytool` to create a _truststore_ file. A _truststore_
contains the set of CA certs to use for validation.

    # keytool -import -alias "My CA" -file ca_crt.pem -keystore truststore.jks
    Enter keystore password:
    Re-enter new password:
    .
    .
    .
    Trust this certificate? [no]:  y
    Certificate was added to keystore

Note that you _must_ supply a password; remember the password you
used, as you'll need it to configure PuppetDB later. Once imported,
you can view your certificate:

    # keytool -list -keystore truststore.jks
    Enter keystore password:

    Keystore type: JKS
    Keystore provider: SUN

    Your keystore contains 1 entry

    my ca, Mar 30, 2012, trustedCertEntry,
    Certificate fingerprint (MD5): 99:D3:28:6B:37:13:7A:A2:B8:73:75:4A:31:78:0B:68

Note the MD5 fingerprint; you can use it to verify this is the correct cert:

    # openssl x509 -in ca_crt.pem -fingerprint -md5
    MD5 Fingerprint=99:D3:28:6B:37:13:7A:A2:B8:73:75:4A:31:78:0B:68

### Create a keystore

Now we can take the keypair you generated for `puppetdb.my.net` and
import it into a Java _keystore_. A _keystore_ file contains
certificate to use during HTTPS. Again, on the PuppetDB host in the
same directory you were using in the previous section:

    # cat privkey.pem pubkey.pem > temp.pem
    # openssl pkcs12 -export -in temp.pem -out puppetdb.p12 -name puppetdb.my.net
    Enter Export Password:
    Verifying - Enter Export Password:
    # keytool -importkeystore  -destkeystore keystore.jks -srckeystore puppetdb.p12 -srcstoretype PKCS12 -alias puppetdb.my.net
    Enter destination keystore password:
    Re-enter new password:
    Enter source keystore password:

You can validate this was correct:

    # keytool -list -keystore keystore.jks
    Enter keystore password:

    Keystore type: JKS
    Keystore provider: SUN

    Your keystore contains 1 entry

    puppetdb.my.net, Mar 30, 2012, PrivateKeyEntry,
    Certificate fingerprint (MD5): 7E:2A:B4:4D:1E:6D:D1:70:A9:E7:20:0D:9D:41:F3:B9

    # puppet cert fingerprint puppetdb.my.net --digest=md5
    MD5 Fingerprint=7E:2A:B4:4D:1E:6D:D1:70:A9:E7:20:0D:9D:41:F3:B9

### Configuring PuppetDB to do HTTPS

Take the _truststore_ and _keystore_ you generated in the preceding
steps and copy them to a directory of your choice. For the sake of
instruction, let's assume you've put them into `/etc/puppetdb/ssl`.

First, change ownership to whatever user you plan on running PuppetDB
as and ensure that only that user can read the files. For example, if
you have a specific `puppetdb` user:

    # chown puppetdb:puppetdb /etc/puppetdb/ssl/truststore.jks /etc/puppetdb/ssl/keystore.jks
    # chmod 400 /etc/puppetdb/ssl/truststore.jks /etc/puppetdb/ssl/keystore.jks

Now you can setup PuppetDB itself. In you PuppetDB configuration
file, make the `[jetty]` section look like so:

    [jetty]
    host = <hostname you wish to bind to for HTTP>
    port = <port you wish to listen on for HTTP>
    ssl-host = <hostname you wish to bind to for HTTPS>
    ssl-port = <port you wish to listen on for HTTPS>
    keystore = /etc/puppetdb/ssl/keystore.jks
    truststore = /etc/puppetdb/ssl/truststore.jks
    key-password = <pw you used when creating the keystore>
    trust-password = <pw you used when creating the truststore>

If you don't want to do unsecured HTTP at all, then you can just leave
out the `host` and `port` declarations. But keep in mind that anyone
that wants to connect to PuppetDB for any purpose will need to be
prepared to give a valid client certificate (even for things like
viewing dashboards and such). A reasonable compromise could be to set
`host` to `localhost`, so that unsecured traffic is only allowed from
the local box. Then tunnels could be used to gain access to
administrative consoles.

That should do it; the next time you start PuppetDB, it will be doing
HTTPS and using the CA's certificate for verifiying clients.

With HTTPS properly setup, the PuppetDB host no longer requires the
PEM files copied over during configuration. Those can be safely
deleted from the PuppetDB box (the "master copies" exist on your CA
host).


[leiningen]: https://github.com/technomancy/leiningen

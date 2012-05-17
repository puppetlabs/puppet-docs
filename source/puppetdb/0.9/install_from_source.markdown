---
title: "PuppetDB 0.9 » Installing from Source"
layout: pe2experimental
nav: puppetdb0.9.html
---

[use_puppetdb]: ./install.html#step-5-connect-the-puppet-master-to-puppetdb

## Installing from source

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

After installing, you will need to [configure Puppet to connect to PuppetDB][use_puppetdb].

## Running directly from source

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

After installing, you will need to [configure Puppet to connect to PuppetDB][use_puppetdb].

## Manual SSL Setup

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

* you'll be running PuppetDB on a host called `puppetdb.example.com`
* your puppet installation uses the standard directory structure and
  its `ssldir` is `/etc/puppet/ssl`

### Create a keypair

This is pretty easy with Puppet's built-in CA. On the host acting as
your CA (your puppetmaster, most likely):

    # puppet cert generate puppetdb.example.com
    notice: puppetdb.example.com has a waiting certificate request
    notice: Signed certificate request for puppetdb.example.com
    notice: Removing file Puppet::SSL::CertificateRequest puppetdb.example.com at '/etc/puppet/ssl/ca/requests/puppetdb.example.com.pem'
    notice: Removing file Puppet::SSL::CertificateRequest puppetdb.example.com at '/etc/puppet/ssl/certificate_requests/puppetdb.example.com.pem'

Et voilà, you've got a keypair. Copy the following files from your CA
to the machine that will be running PuppetDB:

* `/etc/puppet/ssl/ca/ca_crt.pem`
* `/etc/puppet/ssl/private_keys/puppetdb.example.com.pem`
* `/etc/puppet/ssl/certs/puppetdb.example.com.pem`

You can do that using `scp`:

    # scp /etc/puppet/ssl/ca/ca_crt.pem puppetdb.example.com:/tmp/certs/ca_crt.pem
    # scp /etc/puppet/ssl/private_keys/puppetdb.example.com.pem puppetdb.example.com:/tmp/certs/privkey.pem
    # scp /etc/puppet/ssl/certs/puppetdb.example.com.pem puppetdb.example.com:/tmp/certs/pubkey.pem

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

Now we can take the keypair you generated for `puppetdb.example.com` and
import it into a Java _keystore_. A _keystore_ file contains
certificate to use during HTTPS. Again, on the PuppetDB host in the
same directory you were using in the previous section:

    # cat privkey.pem pubkey.pem > temp.pem
    # openssl pkcs12 -export -in temp.pem -out puppetdb.p12 -name puppetdb.example.com
    Enter Export Password:
    Verifying - Enter Export Password:
    # keytool -importkeystore  -destkeystore keystore.jks -srckeystore puppetdb.p12 -srcstoretype PKCS12 -alias puppetdb.example.com
    Enter destination keystore password:
    Re-enter new password:
    Enter source keystore password:

You can validate this was correct:

    # keytool -list -keystore keystore.jks
    Enter keystore password:

    Keystore type: JKS
    Keystore provider: SUN

    Your keystore contains 1 entry

    puppetdb.example.com, Mar 30, 2012, PrivateKeyEntry,
    Certificate fingerprint (MD5): 7E:2A:B4:4D:1E:6D:D1:70:A9:E7:20:0D:9D:41:F3:B9

    # puppet cert fingerprint puppetdb.example.com --digest=md5
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

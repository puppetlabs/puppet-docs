---
layout: default
title: "SSL Configuration: External CA Support"
canonical: "/puppet/latest/reference/config_ssl_external_ca.html"
---

[conf]: ./config_file_main.html
[verify_header]: /puppet/latest/reference/configuration.html#sslclientverifyheader
[client_header]: /puppet/latest/reference/configuration.html#sslclientheader
[ca_auth]: /puppet/latest/reference/configuration.html#sslclientcaauth
[puppetdb]: /puppetdb/latest

In lieu of its built-in CA and PKI tools, Puppet can use an existing external CA for all of its SSL communications.

This page describes the supported and tested configurations for external CAs in this version of Puppet. If you have an external CA use case that isn't covered here, please get in touch with Puppet Labs so we can learn more about it.

> **Note:** This page uses RFC 2119 style semantics for MUST, SHOULD, MAY.


Supported External CA Configurations
-----

Puppet 3.5 supports _some_ external CA configurations, but not every possible arrangement. We fully support the following setups:

1. [Single self-signed CA which directly issues SSL certificates.](#option-1-single-ca)
2. [Single, intermediate CA issued by a root self-signed CA.](#option-2-single-intermediate-ca)  The intermediate
   CA directly issues SSL certificates; the root CA doesn't.
3. [Two intermediate CAs, both issued by the same root self-signed CA.](#option-3-two-intermediate-cas-issued-by-one-root-ca)
    * One intermediate CA issues SSL certificates for puppet master servers.
    * The other intermediate CA issues SSL certificates for agent nodes.
    * Agent certificates can't act as servers, and master certificates can't act as clients.

These are fully supported by Puppet Labs, which means:

* Issues that arise in one of these three arrangements are considered **bugs,** and we'll fix them ASAP.
* Issues that arise in any _other_ external CA setup are considered **feature requests,** and we'll consider whether to expand our support.

These configurations are all-or-nothing rather than mix-and-match. When using an external CA, the built in Puppet CA service **must** be disabled and cannot be used to issue SSL certificates.

Additionally, Puppet cannot automatically distribute certificates in these configurations --- you must have your own complete system for issuing and distributing certificates.


General Notes and Requirements
-----

### Rack Webserver is Required

The puppet master must be running inside of a Rack-enabled web server, not the built-in Webrick server.

In practice, this means Apache or Nginx.  We fully support any web server that can:

* Terminate SSL
* Verify the authenticity of a client SSL certificate
* Set two request headers for:
    * Whether the client was verified
    * The client's distinguished name

### PEM Encoding of Credentials is Mandatory

Puppet always expects its SSL credentials to be in `.pem` format.

### Normal Puppet Master Certificate Requirements Still Apply

Any puppet master certificate must contain the DNS name at which agent nodes will attempt to contact that master, either as the subject CN or as a Subject Alternative Name (DNS).

### Format of X-Client-DN Request Header

Rack web servers must set a client request header, which the puppet master will check based on the [`ssl_client_header` setting](/puppet/latest/reference/configuration.html#sslclientheader).

This header should conform to the following specifications:

* The value of the client certificate DN should be in [RFC-2253](http://www.ietf.org/rfc/rfc2253.txt) format. The format of the `SSL_CLIENT_S_DN` environment variable (set by Apache ≥ 2.2's `mod_ssl`) is fully supported.
* Alternatively, the value of this request header may be in "OpenSSL" format.

### Revocation

Certificate revocation list (CRL) checking works in all three supported
configurations, so long as the CRL file is distributed to the agents and masters
using an "out of band" process.  Puppet won't automatically update the CRL on any
of the components in the system.

#### If Unused:

If revocation lists are **not** being used by the external CA, you must disable CRL checking on the agent.
Set `certificate_revocation = false` in the
`[agent]` section of [puppet.conf][conf] on **every agent node.**

(If it's not set to false and the agent doesn't already have a CRL file, it will try to download one from the master. This will fail, because the master must have the CA service disabled.)

#### If Used:

If revocation lists **are** being used by the external CA, then the CRL file must
be manually distributed to **every agent node** as a PEM encoded bundle.  Puppet will not automatically distribute this file.

To determine where to put the CRL file, run `puppet agent --configprint hostcrl`.

Option 1: Single CA
-----

A single CA is the default configuration of Puppet when the internal CA is
being used.  A single, externally issued CA may also be used in a similar
manner.



                   +------------------------+
                   |                        |
                   |  Root self-signed CA   |
                   |                        |
                   +------+----------+------+
                          |          |
               +----------+          +------------+
               |                                  |
               v                                  v
      +-----------------+                +----------------+
      |                 |                |                |
      | Master SSL Cert |                | Agent SSL Cert |
      |                 |                |                |
      +-----------------+                +----------------+


### Puppet Master

{% capture master_basic %}
Configure the puppet master in four steps:

1. Disable the internal CA service
2. Ensure that the certname will never change
3. Put certificates/keys in place on disk
4. Configure the web server

On the master, in [`puppet.conf`][conf], make sure the following settings are configured:

    [master]
    ca = false
    certname = <some static string, e.g. 'puppetmaster'>

* The internal CA service must be disabled using `ca = false`.
* The certname must be set to a static value. This can still be the machine's FQDN, but you must not leave the setting blank. (A static certname will keep Puppet from getting confused if the machine's hostname ever changes.)

Once this configuration is set, put the external credentials into the correct filesystem locations.  You can run the following commands to find the appropriate locations:

Credential                         | File location
-----------------------------------|-------------------------------------------
Master SSL certificate             | `puppet master --configprint hostcert`
Master SSL certificate private key | `puppet master --configprint hostprivkey`
Root CA certificate                | `puppet master --configprint localcacert`
{% endcapture %}

{{ master_basic }}

With these files in place, the web server should be configured to:

* Use the root CA certificate, the master's certificate, and the master's key
* Set the verification header (as specified in the master's [`ssl_client_verify_header` setting][verify_header])
* Set the client DN header (as specified in the master's [`ssl_client_header` setting][client_header])

An example of this configuration for Apache:

    Listen 8140
    <VirtualHost *:8140>
        SSLEngine on
        SSLProtocol ALL -SSLv2
        SSLCipherSuite ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:-LOW:-SSLv2:-EXP

        # Replace with the value of `puppet master --configprint hostcert`
        SSLCertificateFile "/path/to/master.pem"
        # Replace with the value of `puppet master --configprint hostprivkey`
        SSLCertificateKeyFile "/path/to/master.key"

        # Replace with the value of `puppet master --configprint localcacert`
        SSLCACertificateFile "/path/to/ca.pem"

        SSLVerifyClient optional
        SSLVerifyDepth 1
        SSLOptions +StdEnvVars
        RequestHeader set X-SSL-Subject %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-DN %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-Verify %{SSL_CLIENT_VERIFY}e

        DocumentRoot "/etc/puppet/public"

        PassengerRoot /usr/share/gems/gems/passenger-3.0.17
        PassengerRuby /usr/bin/ruby

        RackAutoDetect On
        RackBaseURI /
    </VirtualHost>

{% capture master_config_ru %}
The `config.ru` file for rack has no special configuration when using an
external CA.  Please follow the standard rack documentation for using Puppet
with rack.  The following example will work with this version of Puppet:

    ~~~ ruby
    $0 = "master"
    ARGV << "--rack"
    ARGV << "--confdir=/etc/puppet"
    ARGV << "--vardir=/var/lib/puppet"
    require 'puppet/util/command_line'
    run Puppet::Util::CommandLine.new.execute
~~~
{% endcapture %}

{{ master_config_ru }}

### Puppet Agent

You don't need to change any settings.

Put the external credentials into the correct filesystem locations.  You can run the following commands to find the appropriate locations:

Credential                        | File location
----------------------------------|-----------------------------------------
Agent SSL certificate             | `puppet agent --configprint hostcert`
Agent SSL certificate private key | `puppet agent --configprint hostprivkey`
Root CA certificate               | `puppet agent --configprint localcacert`



Option 2: Single Intermediate CA
-----

The single intermediate CA configuration builds from the single self-signed CA
configuration and introduces one additional intermediate CA.



                   +------------------------+
                   |                        |
                   |  self-signed Root CA   |
                   |                        |
                   +-----------+------------+
                               |
                               |
                               v
                   +------------------------+
                   |                        |
                   |    Intermediate CA     |
                   |                        |
                   +------+----------+------+
                          |          |
               +----------+          +------------+
               |                                  |
               v                                  v
      +-----------------+                +----------------+
      |                 |                |                |
      | Master SSL Cert |                | Agent SSL Cert |
      |                 |                |                |
      +-----------------+                +----------------+


The Root CA does not issue SSL certificates in this configuration.  The
intermediate CA issues SSL certificates for clients and servers alike.

### Puppet Master

{{ master_basic }}

You must also create a **CA bundle** for the web server. Append **the two CA certificates** together; the Root CA certificate must be located after the intermediate CA certificate within the file.

    $ cat intermediate_ca.pem root_ca.pem > ca_bundle.pem

Put this file somewhere predictable. Puppet doesn't use it directly, but it can live alongside Puppet's copies of the certificates.

With these files in place, the web server should be configured to:

* Use the intermediate+Root CA bundle, the master's certificate, and the master's key
* Set the verification header (as specified in the master's [`ssl_client_verify_header` setting][verify_header])
* Set the client DN header (as specified in the master's [`ssl_client_header` setting][client_header])

An example of this configuration for Apache:

    Listen 8140
    <VirtualHost *:8140>
        SSLEngine on
        SSLProtocol ALL -SSLv2
        SSLCipherSuite ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:-LOW:-SSLv2:-EXP

        # Replace with the value of `puppet master --configprint hostcert`
        SSLCertificateFile "/path/to/master.pem"
        # Replace with the value of `puppet master --configprint hostprivkey`
        SSLCertificateKeyFile "/path/to/master.key"

        # Replace with the value of `puppet master --configprint localcacert`
        SSLCACertificateFile "/path/to/ca_bundle.pem"
        SSLCertificateChainFile "/path/to/ca_bundle.pem"

        # Allow only clients with a SSL certificate issued by the intermediate CA with
        # common name "Puppet CA"  Replace "Puppet CA" with the CN of your
        # intermediate CA certificate.
        <Location />
            SSLRequire %{SSL_CLIENT_I_DN_CN} eq "Puppet CA"
        </Location>

        SSLVerifyClient optional
        SSLVerifyDepth 2
        SSLOptions +StdEnvVars
        RequestHeader set X-SSL-Subject %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-DN %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-Verify %{SSL_CLIENT_VERIFY}e

        DocumentRoot "/etc/puppet/public"

        PassengerRoot /usr/share/gems/gems/passenger-3.0.17
        PassengerRuby /usr/bin/ruby

        RackAutoDetect On
        RackBaseURI /
    </VirtualHost>


{{ master_config_ru }}

### Puppet Agent

With an intermediate CA, puppet agent needs a modified value for [the `ssl_client_ca_auth` setting][ca_auth] in its puppet.conf:

    [agent]
    ssl_client_ca_auth = $certdir/issuer.pem

The value should point to somewhere in the `$certdir`.

Put the external credentials into the correct filesystem locations.  You can run the following commands to find the appropriate locations:

Credential                        | File location
----------------------------------|------------------------------------------------
Agent SSL certificate             | `puppet agent --configprint hostcert`
Agent SSL certificate private key | `puppet agent --configprint hostprivkey`
Root CA certificate               | `puppet agent --configprint localcacert`
Intermediate CA certificate       | `puppet agent --configprint ssl_client_ca_auth`



Option 3: Two Intermediate CAs Issued by One Root CA
-----

This configuration uses different CAs to issue puppet master certificates and puppet agent
certificates.  This makes them easily distinguishable, and prevents any agent certificate from being
usable for a puppet master.



                   +------------------------+
                   |                        |
                   |  Root self-signed CA   |
                   |                        |
                   +------+----------+------+
                          |          |
               +----------+          +------------+
               |                                  |
               v                                  v
      +-----------------+                +----------------+
      |                 |                |                |
      |    Master CA    |                |    Agent CA    |
      |                 |                |                |
      +--------+--------+                +--------+-------+
               |                                  |
               |                                  |
               v                                  v
      +-----------------+                +----------------+
      |                 |                |                |
      | Master SSL Cert |                | Agent SSL Cert |
      |                 |                |                |
      +-----------------+                +----------------+


In this configuration puppet agents are configured to only authenticate peer
certificates issued by the Master CA.  Puppet masters are configured to only
authenticate peer certificates issued by the Agent CA.

> **Note:** If you're using this configuration, you can't use the ActiveRecord inventory service backend with multiple puppet master servers. Use [PuppetDB][] for the inventory service instead.

### Puppet Master

{{ master_basic }}

You must also create a **CA bundle** for the web server. Append the **Agent CA certificate and Root CA certificate** together; the Root CA certificate must be located after the Agent CA certificate within the file.

    $ cat agent_ca.pem root_ca.pem > ca_bundle_for_master.pem

Put this file somewhere predictable. Puppet doesn't use it directly, but it can live alongside Puppet's copies of the certificates.

With these files in place, the web server should be configured to:

* Use the Agent+Root CA bundle, the master's certificate, and the master's key
* Set the verification header (as specified in the master's [`ssl_client_verify_header` setting][verify_header])
* Set the client DN header (as specified in the master's [`ssl_client_header` setting][client_header])

An example of this configuration for Apache:

    Listen 8140
    <VirtualHost *:8140>
        SSLEngine on
        SSLProtocol ALL -SSLv2
        SSLCipherSuite ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:-LOW:-SSLv2:-EXP

        # Replace with the value of `puppet master --configprint hostcert`
        SSLCertificateFile "/path/to/master.pem"
        # Replace with the value of `puppet master --configprint hostprivkey`
        SSLCertificateKeyFile "/path/to/master.key"

        # Replace with the value of `puppet master --configprint localcacert`
        SSLCACertificateFile "/path/to/ca_bundle_for_master.pem"
        SSLCertificateChainFile "/path/to/ca_bundle_for_master.pem"

        # Allow only clients with a SSL certificate issued by the intermediate CA with
        # common name "Puppet Agent CA"  Replace "Puppet Agent CA" with the CN of your
        # Agent CA certificate.
        <Location />
            SSLRequire %{SSL_CLIENT_I_DN_CN} eq "Puppet Agent CA"
        </Location>

        SSLVerifyClient optional
        SSLVerifyDepth 2
        SSLOptions +StdEnvVars
        RequestHeader set X-SSL-Subject %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-DN %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-Verify %{SSL_CLIENT_VERIFY}e

        DocumentRoot "/etc/puppet/public"

        PassengerRoot /usr/share/gems/gems/passenger-3.0.17
        PassengerRuby /usr/bin/ruby

        RackAutoDetect On
        RackBaseURI /
    </VirtualHost>


{{ master_config_ru }}

### Puppet Agent

With split CAs, puppet agent needs a modified value for [the `ssl_client_ca_auth` setting][ca_auth] in its puppet.conf:

    [agent]
    ssl_client_ca_auth = $certdir/ca_master.pem

The value should point to somewhere in the `$certdir`.

Put the external credentials into the correct filesystem locations.  You can run the following commands to find the appropriate locations:

Credential                        | File location
----------------------------------|------------------------------------------------
Agent SSL certificate             | `puppet agent --configprint hostcert`
Agent SSL certificate private key | `puppet agent --configprint hostprivkey`
Root CA certificate               | `puppet agent --configprint localcacert`
Master CA certificate             | `puppet agent --configprint ssl_client_ca_auth`


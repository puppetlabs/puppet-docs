---
layout: default
title: "SSL configuration: External CA support"
---

[conf]: ./config_file_main.html
[verify_header]: ./configuration.html#sslclientverifyheader
[client_header]: ./configuration.html#sslclientheader
[ca_auth]: ./configuration.html#sslclientcaauth
[puppetdb]: {{puppetdb}}/

In lieu of its built-in certificate authority (CA) and public key infrastructure (PKI) tools, Puppet can use an existing external CA for all of its secure socket layer (SSL) communications.

This page describes the supported and tested configurations for external CAs in this version of Puppet. If you have an external CA use case that isn't covered here, please contact Puppet so we can learn more about it.

> **Note:** This page uses RFC 2119 style semantics for MUST, SHOULD, and MAY.

## Supported external CA configurations

This version of Puppet supports _some_ external CA configurations, but not every possible arrangement. We fully support the following setups:

1. [Single self-signed CA which directly issues SSL certificates.](#option-1-single-ca)
2. [Puppet master functioning as an intermediate CA of a root self-signed CA.](#option-2-intermediate-ca)

These are fully supported by Puppet, which means:

* Issues that arise in one of these three arrangements are considered **bugs,** and we'll fix them ASAP.
* Issues that arise in any _other_ external CA setup are considered **feature requests,** and we'll consider whether to expand our support.

## General notes and requirements

### PEM encoding of credentials is mandatory

Puppet always expects its SSL credentials to be in `.pem` format.

### Normal Puppet master certificate requirements still apply

Any Puppet master certificate must contain the DNS name at which agent nodes will attempt to contact that master, either as the subject common name (CN) or as a Subject Alternative Name (DNS).

## Option 1: Single CA

When Puppet uses its internal CA, it defaults to a single CA configuration. A single externally issued CA can also be used in a similar manner.

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

This configuration is all-or-nothing rather than mix-and-match. When using an external CA, the built-in Puppet CA service **must** be disabled and cannot be used to issue SSL certificates.

Additionally, Puppet cannot automatically distribute certificates in this configurations --- you must have your own complete system for issuing and distributing certificates.

### Puppet master

{% capture master_basic %}
Configure the Puppet master in four steps:

1. Disable the internal CA service
2. Ensure that the certname will never change
3. Put certificates/keys in place on disk
4. Configure the web server

On the master, in [`puppet.conf`][conf], make sure the following settings are configured:

```
[master]
ca = false
certname = <some static string, e.g. 'puppetmaster'>
```

* The internal CA service must be disabled using `ca = false`.
* The certname must be set to a static value. This can still be the machine's FQDN, but you must not leave the setting blank. (A static certname will keep Puppet from getting confused if the machine's hostname ever changes.)

Once this configuration is set, put the external credentials into the correct filesystem locations. You can run the following commands to find the appropriate locations:

Credential                         | File location
-----------------------------------|-------------------------------------------
Master SSL certificate             | `puppet master --configprint hostcert`
Master SSL certificate private key | `puppet master --configprint hostprivkey`
Root CA certificate                | `puppet master --configprint localcacert`
{% endcapture %}

{{ master_basic }}

With these files in place, the puppetserver needs to be configured to use an external CA.  Follow the steps here ["Disable the Internal Puppet CA Service"][disablepuppetserverca]

[disablepuppetserverca]: https://docs.puppet.com/puppetserver/latest/external_ca_configuration.html#disabling-the-internal-puppet-ca-service

### Puppet agent

You don't need to change any settings.

Put the external credentials into the correct filesystem locations. You can run the following commands to find the appropriate locations:

Credential                        | File location
----------------------------------|-----------------------------------------
Agent SSL certificate             | `puppet agent --configprint hostcert`
Agent SSL certificate private key | `puppet agent --configprint hostprivkey`
Root CA certificate               | `puppet agent --configprint localcacert`
Root CRL certificate              | `puppet agent --configprint hostcrl`

## Option 2: Puppet master functioning as an intermediate CA

The puppet master can operate as an intermediate CA to an external Root CA.  The puppet master cannot be an intermediate to an intermediate.  In this mode the puppet master CA is left enabled and generation of agent certificates can remain automated, however there are some limitations:

* Agent-side CRL checking is not possible however CRL verification will still happen on the puppetserver
* The CA certificate bundle (ie the external Root CA combined with the Intermediate CA certificate) must be distributed to the agents manually - ideally before puppet runs

### Puppet master

Before configuring the puppet master, you will need to obtain the intermediate CA certificate from your external Root CA.  Generating the Intermediate CA cert is outside the scope of the doc, since it will depend your external certificate authority solution.  This guide assumes you are either starting with a fresh installation or have removed all SSL files from your existing master and are starting over.  Also, you should stop all puppet related services on the master server before this process.

In order to configure the puppet master you will need the following files placed:

Certificate     | Purpose                     | File Location
----------------|--------------------------------------------
ca_crt.pem      | Intermediate CA Certificate | /etc/puppetlabs/puppet/ssl/ca/ca_crt.pem
ca_key.pem      | Intermediate CA Key         | /etc/puppetlabs/puppet/ssl/ca/ca_key.pem
root_crt.pem    | Root CA Certificate         | /etc/puppetlabs/puppet/ssl/ca/root_crt.pem

> Note: The root_crt.pem can actually be placed anywhere, however this doc assumes you placed it as shown

> Note: The ca_key.pem needs to have any passphrase removed to match the expectations of the Puppet CA

All of the files placed should have owner set to `puppet:puppet` and permissions of `0600`.

Next, you have to generate the CA bundle to be placed on the master as well as any agents you create.  This is achieved by combining the Root CA and Intermediate CA certificates into one PEM file.

```
cd /etc/puppetlabs/puppet/ssl/ca
cat ca_cert.pem root_crt.pem > ../certs/ca.pem
```
> Note: You also need to install a CRL file for the CA.  If you do not have one pre-generated from the Root CA you can easily create one by first executing `puppet cert generate fakehost` and then revoking this certificate with `puppet cert clean fakehost`.  If you do have a pre-generated CRL install it into `/etc/puppetlabs/puppet/ssl/ca/ca_crl.pem.

You now need to generate a new certificate for the puppet master to use.  Remember to include the `dns_alt_names` that this puppet master will need to service.

```
puppet cert generate puppetserver.my.domain.net --dns_alt_names=puppetserver,puppet
```

You can now restart the puppetserver process and validate it successfully has started.  For other puppet services, please see ["Regenerating all Certificates for a Puppet deployment"][regen] for specific instructions.

[regen]: https://docs.puppet.com/puppet/latest/ssl_regenerate_certificates.html

### Puppet agent

In order for the puppet agent to work properly with this CA configuration you need to do two things:

* Copy the CA bundle in place prior to a puppet run (ideally)
* Disable certificate revocation validation

The CA bundle needs to be copied to `/etc/puppetlabs/puppet/ssl/certs/ca.pem`.  If you copy this file in place prior to the first puppet execution you will not recieve any errors.  If you attempt to execute a puppet run prior to this file being present you will receive errors since the auto-distributed ca.pem file will not be the entire CA certificate chain. 

Example error:

```
Error: Could not request certificate: SSL_connect returned=1 errno=0 state=error: certificate verify failed: [unable to get local issuer certificate for /CN=<master>]
```

Once the CA file is in place, disable certificate revocation validation by adding the following to the main section of puppet.conf:

```
certificate_revocation = false
```

Once you've completed both of these steps the agent will run successfully.

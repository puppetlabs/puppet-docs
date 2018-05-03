---
layout: default
title: "SSL configuration: External CA support"
---

[conf]: ./config_file_main.html

In lieu of its built-in certificate authority (CA) and public key infrastructure (PKI) tools, Puppet can use an existing external CA for all of its secure socket layer (SSL) communications.

This page describes the supported and tested configurations for external CAs in this version of Puppet. If you have an external CA use case that isn't covered here, please contact Puppet so we can learn more about it.

## Supported external CA configurations

This version of Puppet supports _some_ external CA configurations, but not every possible arrangement. We fully support the following setups:

1. [Single self-signed CA which directly issues SSL certificates.](#option-1-single-ca)
2. [Puppet Server functioning as an intermediate CA of a root self-signed CA.](#option-2-puppet-server-functioning-as-an-intermediate-ca)

These are fully supported by Puppet, which means:

* Issues that arise in one of these three arrangements are considered **bugs,** and we'll fix them ASAP.
* Issues that arise in any _other_ external CA setup are considered **feature requests,** and we'll consider whether to expand our support.

## General notes and requirements

### PEM encoding of credentials is mandatory

Puppet always expects its SSL credentials to be in `.pem` format.

### Normal Puppet certificate requirements still apply

Any Puppet Server certificate must contain the DNS name at which agent nodes will attempt to contact that server, either as the subject common name (CN) or as a Subject Alternative Name (DNS).

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
      | Server SSL Cert |                | Agent SSL Cert |
      |                 |                |                |
      +-----------------+                +----------------+

This configuration is all-or-nothing rather than mix-and-match. When using an external CA, the built-in Puppet CA service **must** be disabled and cannot be used to issue SSL certificates.

Additionally, Puppet cannot automatically distribute certificates in this configurations --- you must have your own complete system for issuing and distributing certificates.

### Puppet Server

Configure Puppet Server in three steps:

* Disable the internal CA service.
* Ensure that the certname will never change.
* Put certificates/keys in place on disk.

1. Edit Puppet Server's `/etc/puppetlabs/puppetserver/services.d/ca.cfg` file to disable the internal CA. Comment out the line following "To enable the CA service..." and uncomment the line following "To disable the CA service...", as follows:

   ```
   # To enable the CA service, leave the following line uncommented
   # puppetlabs.services.ca.certificate-authority-service/certificate-authority-service
   # To disable the CA service, comment out the above line and uncomment the line below
   puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service
   ```
2. Set a static value for the `certname` setting in [`puppet.conf`][conf]:

   ```
   [master]
   certname = puppetserver.example.com
   ```

   Setting a static value keeps Puppet from getting confused if the machine's hostname ever changes. The value must be whatever certname you'll use to issue the server's certificate. It must not be blank.
3. Put the credentials from your external CA on disk in the correct locations. These locations must match what's configured in your [webserver.conf file]({{puppetserver}}/config_file_webserver.html). If you haven't changed those settings, you can run the following commands to find the default locations:

   Credential                         | File location
   -----------------------------------|-------------------------------------------
   Server SSL certificate             | `puppet config print hostcert --section master`
   Server SSL certificate private key | `puppet config print hostprivkey --section master`
   Root CA certificate                | `puppet config print localcacert --section master`
   Root certificate revocation list   | `puppet config print hostcrl --section master`

If you've put the credentials in the correct locations, you shouldn't need to change any additional settings.

### Puppet agent

You don't need to change any settings.

Put the external credentials into the correct filesystem locations. You can run the following commands to find the appropriate locations:

Credential                        | File location
----------------------------------|-----------------------------------------
Agent SSL certificate             | `puppet config print hostcert --section agent`
Agent SSL certificate private key | `puppet config print hostprivkey --section agent`
Root CA certificate               | `puppet config print localcacert --section agent`
Root certificate revocation list  | `puppet config print hostcrl --section agent`

## Option 2: Puppet Server functioning as an intermediate CA

Puppet Server can operate as an intermediate CA to an external root CA. Please
refer to [Using Puppet Server as an intermediate certificate authority]({puppetserver}/intermediate_ca_configuration.html)
for a complete walk through of setting it up.

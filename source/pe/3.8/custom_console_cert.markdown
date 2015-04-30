---
layout: default
title: "PE 3.8 » Configuration » Custom Console Cert"
subtitle: "Configuring the Puppet Enterprise Console to Use a Custom SSL Certificate"
canonical: "/pe/latest/custom_console_cert.html"
---

The PE console uses a certificate signed by PE's built-in certificate authority (CA). Since this CA is specific to PE, web browsers don't know it or trust it, and you have to add a security exception in order to access the console. You may find that this is not an acceptable scenario and want to use a custom CA to create the console's certificate. The following procedure provides the necessary steps.

## What You Will Need

Before you get started, you should have a X.509 cert, signed by the custom party CA, in PEM format, with matching private and public keys

Please note that if your custom cert is issued by an intermediate CA, the CA bundle (e.g. `public-console.ca_cert.pem` in this example) needs to contain a complete chain, including the applicable root CA.

>**Note**: The following procedure is only compatible with PE 3.8 or higher. If you're upgrading from an earlier version of PE, you can use these steps to re-configure your custom console cert.

## Set up Custom Certs and Security Credentials

1. Retrieve the custom certificate's public and private keys and the customs CA's public key, and, for ease of use, name them as follows:

   * `public-console.cert.pem`
   * `public-console.private_key.pem`
   * `public-console.ca_cert.pem`

> **Note**: these keys and certs must be in PEM format. You will need to convert them to PEM format before proceeding.

2. Add the files from step 1 to `/opt/puppet/share/console-services/certs/`. (Note that if you have a split install, this directory is on the PE console node.)
3. Use the PE console to set the edit the parameters of the `puppet_enterprise::profile::console` class.

   a. Click __Classification__ in the top navigation bar.

   b. From the __Classification page__, select the __PE Console__ group.

   c. Click the __Classes__ tab, and find `puppet_enterprise::profile::console` in the list of classes.

   d. From the parameter drop-down list, choose `browser_ssl_cert`, and in the value field, enter `/opt/puppet/share/console-services/certs/public-console.cert.pem`.

   e. Click __Add parameter__.

   f. From the parameter drop-down list, choose `browser_ssl_private_key`, and in the value field, enter `/opt/puppet/share/console-services/certs/public-console.private_key.pem`.

   g. Click __Add parameter__.

   h. From the parameter drop-down list, choose `browser_ssl_cert_chain`, and in the value field, enter `/opt/puppet/share/console-services/certs/public-console.ca_cert.pem`.

   i. Click __Add parameter__.

   j. Click the Commit change button.

4. Kick off a Puppet run. (Note that if you have a split install, the Puppet run needs to happen on the PE console node.)

You should now be able to navigate to your console and see the custom certificate in your browser.

* * *

- [Next: Configuring Java Arguments For PE ](./config_java_args.html)
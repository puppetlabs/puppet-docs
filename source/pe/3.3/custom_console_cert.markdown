---
layout: default
title: "PE 3.3 » Deploying PE » Custom Console Cert"
subtitle: "Configuring the Puppet Enterprise Console to Use a Custom SSL Certificate"
canonical: "/pe/latest/custom_console_cert.html"
---

> **Important**: The procedures in this document apply to 3.3.x versions of Puppet Enterprise. PE 3.7.0 users should not perform these steps as certificate functionality has changed between versions. 

The PE console uses a certificate signed by PE's built-in certificate authority (CA). Since this CA is specific to PE, web browsers don't know it or trust it, and you have to add a security exception in order to access the console. You may find that this is not an acceptable scenario and want to use a custom CA to create the console's certificate. However, because several elements of the PE infrastructure are authenticated with certificates signed by PE's built-in CA, you must bundle the custom CA with the built-in CA.

#### About the CA Bundle

When you use a custom CA to create a certificate for the console, the console still needs to trust requests from other elements of your PE infrastructure that have been authenticated with certificates signed by PE's built-in CA; and when making requests to the puppet master, the console still needs to present a certificate signed by PE's built-in CA.

If your custom cert is issued by an intermediate CA, the CA bundle (i.e., `ca_auth.pem`) needs to contain a complete chain, including the applicable root CA.

Here are the main things you will need to do:

1. Set up the custom certificates and security credentials (private and public keys).
2. Generate a complete CA bundle for the puppet master.

### Step 1: Set up Custom Certs and Security Credentials

1. Retrieve the custom certificate's public and private keys and the customs CA's public key, and, for ease of use, name them as follows:

   * `public-dashboard.cert.pem`
   * `public-dashboard.private_key.pem`
   * `public-dashboard.ca_cert.pem`

2. Add those files to `/opt/puppet/share/puppet-dashboard/certs/`.
3. Edit `/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf` so that it contains the new certificate and keys. The complete SSL list in `puppetdashboard.conf` should appear as follows:

        SSLCertificateFile /opt/puppet/share/puppet-dashboard/certs/public-dashboard.cert.pem
        SSLCertificateKeyFile /opt/puppet/share/puppet-dashboard/certs/public-dashboard.private_key.pem
        SSLCertificateChainFile /opt/puppet/share/puppet-dashboard/certs/public-dashboard.ca_cert.pem
        SSLCACertificateFile /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.ca_cert.pem
        SSLCARevocationFile /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.ca_crl.pem

> **Important**: Make sure you do not duplicate *any* of the above parameters in `/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf`.

The first three certificates in the list are your custom certificate's public and private keys and your custom CA's public key. The fourth and fifth entries are PE's built-in CA's public key and certificate revocation list (CRL). They **should not** be edited in any way. This configuration will cause the console to present the signed certificate from your custom CA to clients while still using PE's built-in CA to authenticate requests from the puppet master.

### Step 2: Generate the Complete CA Bundle for the Puppet Master

1. On the puppet master, create `ca_auth.pem` by running `cat /etc/puppetlabs/puppet/ssl/certs/ca.pem /opt/puppet/share/puppet-dashboard/certs/public-dashboard.ca_cert.pem > /etc/puppetlabs/puppet/ssl/ca_auth.pem`.

   > **Note**: The second path in the above command is the full path the public key of the custom CA, which you put in `/opt/puppet/share/puppet-dashboard/certs/` in step 1.2.

2. If you need to include an applicable root CA in your bundle, run `cat root.pem >> ca_auth.pem`.
3. Change the permissions of the file you just created by running `chmod 644 /etc/puppetlabs/puppet/ssl/ca_auth.pem`.
4. Edit `/etc/puppetlabs/puppet/puppet.conf` and, in the `[master]` stanza, add `ssl_client_ca_auth = /etc/puppetlabs/puppet/ssl/ca_auth.pem`.
5. Edit `/etc/puppetlabs/puppet/console.conf` and for `certificate_name`, change the value to the DNS FQDN of the console server. Note that the DNS FQDN must match the name of the new console certificate.
6. Restart the `pe-httpd` service on both the master and console servers by running `sudo /etc/init.d/pe-httpd restart`. (If it is an all-in-one install, you only need to restart the `pe-httpd` service once.)
7. Kick off a puppet run.

You should now be able to navigate to your console and see the custom certificate in your browser.